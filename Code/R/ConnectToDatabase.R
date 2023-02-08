# An example of connecting R to the Inovalon database and pulling a
# small result set.

cn = MsSqlTools::connectMsSqlDomainLogin(
	server="DBMIHDSWSQLP01.med.harvard.edu",
	database="Inovalon")

DBI::dbGetQuery(cn, "SELECT TOP 10 * FROM provider")
