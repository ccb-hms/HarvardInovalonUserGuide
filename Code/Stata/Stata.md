# Instructions for setting up access to the database in Stata 19

## Acquire kerberos tickets

This will request your HMS password:

```
kinit
```

## Load the required modules
On an interactive slurm job, run this command to load the modules:

```
module load gcc/14.2.0 unixODBC/2.3.12 freetds/1.4.26 msodbcsql17/17.10.6.1-1
```

## Configure .odbc.ini

Create a file named `.odbc.ini` file in your home directory -- this will define an ODBC data source for Stata.  You can edit the file with `nano ~/.odbc.ini`.  Put the following contents in that file:

```
[CCBWSQLP01]
Description=CCBWSQLP01 Server Connection
Driver=ODBC Driver 17 for SQL Server
Server=CCBWSQLP01.med.harvard.edu
Database=Inovalon
Authentication=ActiveDirectoryIntegrated
Encrypt=yes
TrustServerCertificate=yes
```

## Test the connection
Use the `isql` tool to test the connection that you defined in `~/.odbc.ini` above:

```
isql -v CCBWSQLP01
```
Then in the `isql` tool, run a test query:

```
SQL> SELECT TOP 10 * FROM Inovalon.dbo.member
+---------------------+------------+-----------+----------+-------------------------------------------------------------+----------------------+------------+
| memberuid           | birthyear  | gendercode| statecode| zip3value                                                   | raceethnicitytypecode| createddate|
+---------------------+------------+-----------+----------+-------------------------------------------------------------+----------------------+------------+
| 213066094           | 1977       | F         | CA       | 900_903                                                     | 09                   | 2022-09-19 |
| 4883899             | 1979       | F         | CA       | 900_903                                                     | 09                   | 2022-09-19 |
| 288431786           | 1999       | F         | CA       | 900_903                                                     | 09                   | 2022-09-19 |
| 439984153           | 1964       | F         | CA       | 900_903                                                     | 09                   | 2022-09-19 |
| 19264756            | 1996       | F         | CA       | 900_903                                                     | 09                   | 2022-09-19 |
| 208319920           | 1997       | F         | CA       | 900_903                                                     | 09                   | 2022-09-19 |
| 20199088            | 1994       | F         | CA       | 900_903                                                     | 09                   | 2022-09-19 |
| 443822239           | 1984       | F         | CA       | 900_903                                                     | 09                   | 2022-09-19 |
| 213028230           | 1980       | F         | CA       | 900_903                                                     | 09                   | 2022-09-19 |
| 432336810           | 1980       | F         | CA       | 900_903                                                     | 09                   | 2022-09-19 |
+---------------------+------------+-----------+----------+-------------------------------------------------------------+----------------------+------------+
SQLRowCount returns 0
10 rows fetched
```

## Run `Stata` and test the connection:

```
/n/app/stata/19/stata-mp
```

In Stata, first set the driver manager to `unixODBC` instead of the default `iODBC`:

```
. set odbcmgr unixodbc
```

Then list the DSNs avaiable (namely the one we created above):

```
. odbc list

Data Source Name                   Driver
-------------------------------------------------------------------------------
CCBWSQLP01                         ODBC Driver 17 for SQL Server
-------------------------------------------------------------------------------
```

And finally load some data:

```
odbc load, dsn("CCBWSQLP01") exec("SELECT TOP 10 * FROM member")

list in 1/10


     +------------------------------------------------------------------------------+
     | memberuid   birthy~r   gender~e   statec~e   zip3va~e   raceet~e   created~e |
     |------------------------------------------------------------------------------|
     ...
```