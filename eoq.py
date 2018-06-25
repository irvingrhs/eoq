import matplotlib.pyplot as plt
import numpy as np
import errno
import MySQLdb
import math
import os

def ensure_dir(path):
	try:
		os.makedirs(path)
	except OSError as exception:
		if exception.errno != errno.EEXIST:
			raise

def costoTotal(costoOrden,demanda,costoAlmacen,costoUnitario, cantidadOptima):
	ct             = ((demanda*costoUnitario)+((costoOrden*demanda)/cantidadOptima)+((cantidadOptima*costoAlmacen*costoUnitario)/2.0))
	return ct 
	
def cantidadProductoOptima(costoOrden,demanda, costoAlmacen, costoUnitario):
	return math.sqrt((2.0*costoOrden*demanda)/(costoAlmacen*costoUnitario))

def update_line(num, data, line):
    line.set_data(data[...,:num])
    return line,
	
def fix(num):
	res = float(num)
	if res > 1.0:
		res = 1.0
	return res

def sign(num):
	if num > 0:
		return 1
	else:
		return 0

def fixQuantity(num, min, max):
	x = min-num
	y = max-num
	return num+(x*sign(x))+(y*sign(-y))

def getQnC(row):
	res = queryData('SELECT descuento, loteMin, loteMax FROM descuento WHERE Inventario_Id = '+str(row[14])+';')
	qnc=[]
	for i in range(len(res)):
		discount = applyDiscount(row[6], res[i][0])
		q  = fixQuantity(cantidadProductoOptima(row[12], row[8], row[13], discount), res[i][1], res[i][2])
		# cantidad de producto optima, costoUnitarioConDescuento
		datapack=(q, discount)
		qnc.append(datapack)
	return qnc	

def solveEOQItem(row):
	res = queryData('SELECT descuento, loteMin, loteMax FROM descuento WHERE Inventario_Id = '+str(row[14])+';')
	cts=[]
	for i in range(len(res)):
		discount = applyDiscount(row[6], res[i][0])
		q  = round(fixQuantity(cantidadProductoOptima(row[12], row[8], row[13], discount), res[i][1], res[i][2]))
		ct = costoTotal(row[12], row[8], row[13], discount, q)
		# cantidad de producto optima, costo total, loteMin, loteMax
		datapack=(q,  ct, res[i][1], res[i][2])
		cts.append(datapack)
	orderedcosts = sorted(cts, key=lambda x: x[1]) 
	return orderedcosts[0]

#Esta funcion no esta en uso actualmente, EOQ se resuelve localmente y
#se optimizan los resultados en conjunto en la funcion optimizeGAMS	
def solveEOQGAMS(row):
	qnc = getQnC(row)
	index = len(qnc)
	filename = str(row[14])+"-"+str(row[3])+".gms"
	file = open('output/'+filename, "w")
	file.write("$ontext"+
	"*Modelo de inventario eoq con descuento\n"+
	"*Autor: Generado Automaticamente por eoq.py\n"+
	'*Clave del Producto: '+str(row[3])+' \n'+
	'*Nombre del Producto: '+str(row[4])+' \n'+
	"$offtext\n"+
	"sets\n"+
	"j /1*"+str(index)+"/\n"+
	"scalar\n"+
	'd/'+str(float(row[8]))+'/\n'+
	'k/'+str(row[12])+'/\n'+
	'i/'+str(row[13])+'/\n'+
	"parameters\n"+
	"q(j)\n"+
	"/\n")
	for i in range(index):
		file.write(str(i+1)+' '+str(qnc[i][0])+'\n')
	file.write("/\n"+
	"c(j)\n"+
	"/\n")
	for i in range(index):
		file.write(str(i+1)+' '+str(qnc[i][1])+'\n')
	file.write("/\n"+
	"positive variables\n"+
	"x(j)\n"+
	"free variables\n"+
	'ct "Costo total optimo"\n;'+
	"equations\n"+
	"cto costo total optimo\n"+
	"r   restriccion para elegir solo un precio;\n"+
	"cto.. ct =e= sum( j ,( ((d*k)/( round(q(j)) )) + (c(j)*d)+ (i*c(j)*( round(q(j)) ))/2 )*x(j));\n"+
	"r.. sum(j, x(j)) =e= 1;\n"+
	"model eoq /all/\n"+
	"solve eoq using lp minimizing ct;\n"+
	"display ct.l;\n"+
	'option c:3:0:2 display "Costo total optimo:", ct.l;\n'+
	"scalar n;\n"+
	"file report /"+filename+".dat/;\n"+
	"put report;\n"+
	"put '<table border=\"1\">'/\n"+
	"put '<tr><td>Clave del producto: </td><td>"+str(row[3])+"</td></tr>'/\n"+
	"put '<tr><td>Nombre del producto:</td><td>"+str(row[4])+"</td></tr>'/\n"+
	"put '<tr><td>Costo total optimo: </td><td>$', ct.l, ' MN.</td></tr>'/;\n"+
	"loop(j,\n"+
	"         if(x.l(j) eq 1,\n"+
	"                 put '<tr><td>Cantidad a pedir: </td><td>', round(q(j)), ' unidades</td></tr>'/;\n"+
#	"                 put '<tr><td>N&uacute;mero de meses que tardar&aacute; en agotarse:</td><td>', ((round(q(j))/d)*12), ' meses</td></tr>'/;\n"+
	"                 put '<tr><td>Cada cuando realizar la compra:</td><td>', (12/(d/round(q(j)))), ' meses</td></tr>'/;\n"+
	"         );\n"+
	");\n"+
	"put '</table></br>'/\n")
	file.close()
	os.system("gams output/"+filename)
	os.system("type "+filename+".dat >> output/reportGAMS.html")

def plotTable(table):
	data          = []
	frontx        = []
	fronty        = []
	index         = []
	costoAC       = 1
	inventarioAC  = 2
	index = range(len(table))
	for item in table:
			frontx.append(fix(item[costoAC]))
			fronty.append(fix(item[inventarioAC]))
	data.append(frontx)
	data.append(fronty)
	fig2 = plt.figure()
	plt.xlim(0, len(index))
	plt.ylim(0, 1.0)
	plt.grid(True)
	plt.xlabel('Numero de producto')
	plt.ylabel('Porcentaje')
	plt.plot(np.array(index), np.array(data[costoAC-1]), 'b-')
	plt.plot(np.array(index), np.array(data[inventarioAC-1]), 'r-')
	plt.savefig('output/pareto1.png')
	fig2 = plt.figure()
	l, = plt.plot([], [], 'r-')
	plt.xlim(0.0, 1.0)
	plt.ylim(0.0, 1.0)
	plt.grid(True)
	plt.xlabel('Costo total de inventario acumulado')
	plt.ylabel('Cantidad de inventario acumulado')
	plt.plot(np.array(data[0]),np.array(data[1]),'r-')
	plt.savefig('output/pareto2.png')


def applyDiscount(cost, discount):
	return cost-(cost*discount)

def discountTable(data):
	table = []
	for item in data:
		res = queryData("select descuento, loteMin, loteMax from descuento where Inventario_Id = "+str(data[14])+";")
		table.append(res)
	return table

def queryData(query):
	db = MySQLdb.connect("localhost", "root", "", "eoq")
	cursor = db.cursor()
	try:
		cursor.execute(query)
		res = cursor.fetchall()
	except:
		print "Conexion Interrumpida"
	db.close()
	return res

def writeReport(data, eoqData):
	header = open("headertemplate.html","r")
	file = open("output/report.html", "w")
	index = len(data)
	head = header.read()
	file.write(head)
	for i in range(index):
		file.write('<table border="1"><tr><td>Clave del producto:</td><td>'+str(data[i][3])+"</td></tr>"+
		"<tr><td>Nombre del producto: </td><td>"+str(data[i][4])+"</td></tr>"+
		"<tr><td>Costo total optimo:  </td><td>$"+str("%.2f"%float(eoqData[i][1]))+" MN</td></tr>"+
		"<tr><td>Cantidad a pedir:    </td><td>"+str("%.2f"%float(eoqData[i][0]))+" unidades</td></tr>"+
		#"<tr><td>N&uacute;mero de meses que tardar&aacute; en agotarse:</td><td>"+str((float(eoqData[i][0])/float(data[i][8]))*12.0)+" meses</td></tr>"+
		"<tr><td>Cada cuando realizar la compra:</td><td>"+str("%.2f"%float(12.0/(float(data[i][8])/float(eoqData[i][0]))))+" meses</td></tr></table></br>")
	file.write("</body>\n</html>\n")
	file.close()
	header.close()

#if __name__ == "__main__":
def executeEoq(method):
	build  = "DEBUG"
	res = queryData("call productosEstrella();")
	ensure_dir("output")
	if method == "GAMS":
		os.system('type headertemplate.html > output/reportGAMS.html')
		for item in res:
			solveEOQGAMS(item)
		#os.system("type *.dat >> output/reportGAMS.html")
		os.system('type foottemplate.html >> output/reportGAMS.html')
		os.system('del *.dat')
	else:
		eoqData = []
		for item in res:
			eoqData.append(solveEOQItem(item))
		writeReport(res, eoqData)
	res = queryData("call frenteDeParetoOrdenado();")
	plotTable(res)