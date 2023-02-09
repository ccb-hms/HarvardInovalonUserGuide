import pyodbc
cnxn = pyodbc.connect('DRIVER=ODBC Driver 17 for SQL Server;Server=CCBWSQLP01.med.harvard.edu;Trusted_Connection=Yes;Database=Inovalon;TDS_Version=8.0;Encryption=require;Port=1433;REALM=MED.HARVARD.EDU')
cursor = cnxn.cursor()
cursor.execute("SELECT TOP 1 * FROM Inovalon.dbo.provider")
row = cursor.fetchone()
if row:
    print(row)