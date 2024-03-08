import mysql.connector as sql

try:
    tkpk=sql.connect(host="localhost",port=3306,user='root',password="tarun@123",db='mydt')
    plane=tkpk.cursor()
except:
    print("connecrtin failed")
else:
    print("database connected")
 