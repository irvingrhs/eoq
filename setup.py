import MySQLdb

def createData():
	db = MySQLdb.connect("localhost", "root", "")
	cursor = db.cursor()
	file = open("eoq.sql","r")
	query = file.read()
	file.close()
	try:
		cursor.execute(query)
	except:
		print "Conexion Interrumpida"
	db.close()

	
if __name__ == "__main__":
	createData()