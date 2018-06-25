import math

def sign(num):
	if num > 0:
		return 1
	else:
		return 0

def applyDiscount(cost, discount):
	return cost-(cost*discount)

def fixQuantity(num, min, max):
	x = min-num
	y = max-num
	return num+(x*sign(x))+(y*sign(-y))

def costoTotal(costoOrden,demanda,costoAlmacen,costoUnitario, cantidadOptima):
	ct = ((demanda*costoUnitario)+((costoOrden*demanda)/cantidadOptima)+((cantidadOptima*costoAlmacen*costoUnitario)/2.0))
	return ct 
	
def cantidadProductoOptima(costoOrden,demanda, costoAlmacen, costoUnitario):
	return math.sqrt((2.0*costoOrden*demanda)/(costoAlmacen*costoUnitario))

	
def getQnC(row):
	res = ((0,0,999),(0.03,1000,2444),(0.05,2500,1000000000))
	qnc=[]
	for i in range(len(res)):
		discount = applyDiscount(row[6], res[i][0])
		q  = fixQuantity(cantidadProductoOptima(row[12], row[8], row[13], discount), res[i][1], res[i][2])
		# cantidad de producto optima, costoUnitarioConDescuento
		datapack=(q, discount)
		qnc.append(datapack)
	return qnc

def solveEOQItem(row):
	res = ((0,0,999),(0.03,1000,2444),(0.05,2500,1000000000))
	cts=[]
	for i in range(len(res)):
		discount = applyDiscount(row[6], res[i][0])
		q  = fixQuantity(cantidadProductoOptima(row[12], row[8], row[13], discount), res[i][1], res[i][2])
		ct = costoTotal(row[12], row[8], row[13], discount, q)
		# cantidad de producto optima, costo total, costoUnitarioConDescuento
		datapack=(q,  ct, discount)
		cts.append(datapack)
	orderedcosts = sorted(cts, key=lambda x: x[1]) 
	return orderedcosts[0]

if __name__ == "__main__":
	row = (0,0,0,0,0,0,5,0,5000,0,0,0,49,0.2,801)
	res = solveEOQItem(row)
	res2 = getQnC(row)
	print res
	print res2