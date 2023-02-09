# InovalonDemo
This repository contains example code and instructions for working with the Inovalon database.

## O2 Cluster

All of what follows assumes that you are working in an interactive job.

## Working in R and Python on O2
The O2 cluster uses a [module system](https://harvardmed.atlassian.net/wiki/spaces/O2/pages/1588661845/Using+Applications+on+O2) 
to manage software packages.  Before you can connect to the database server from either R or Python, you need to make 
the underlying database drivers accessible in your session.  This is accomplished by loading several 
modules with this command:

```
module load gcc/6.2.0 unixODBC msodbcsql17/17.7.2.1-1 freetds
```

That command can be executed in the shell on a per-session basis, or you can add it to your shell initialization file, 
e.g., by adding it to the end of your `.bashrc` script, which will ensure the libraries are available every time you 
log in to the cluster, and in every job that you run.  If you add it to your initialization script, make sure to 
log out and then back in to the cluster after you edit the file, before you attempt to connect to the database.

To verify that the module successfully loaded in your session, you can run the `module list` command.  You should
see `msodbcsql17/17.7.2.1-1` and the otherse listed above among the currently loaded modules, e.g.:

```
USERNAME@compute-e-16-233 (~): module list

Currently Loaded Modules:
  1) gcc/6.2.0   2) msodbcsql17/17.7.2.1-1   3) unixODBC/2.3.6   4) freetds/1.2.21
```

### Authentication
Access to the Inovalon database is provided on a per-user basis.  The O2 compute nodes use  
Kerberos to authenticate your specific user credentials to the database server.  You will need to interactively
enter your password only once per session, and once you're authenticated, the session will hold a "ticket"
that grants access to the database for the duration of the job.  This single-sign-on approach eliminates
the need for both multiple manual password entries per session, and clear-text embedding of credentials in 
R or Python code.

You can acquire kerberos tickets for your session by running the following at the command line:

```
kinit
```

You will be prompted `Password for [USERNAME]@MED.HARVARD.EDU:`.  Type your password and press enter.  
You can verify that the ticket was acquired by running the `klist` command.  If authentication was 
successful, you see output similar to:

```
Ticket cache: FILE:/tmp/krb5cc_96451_9FpM4g
Default principal: [USERNAME]@MED.HARVARD.EDU

Valid starting       Expires              Service principal
02/08/2023 10:57:40  02/08/2023 20:57:40  krbtgt/MED.HARVARD.EDU@MED.HARVARD.EDU
	renew until 02/09/2023 10:57:33
```

If authentication failed, 
you will see a message similar to:

```
klist: No credentials cache found (filename: /tmp/krb5cc_96451_9FpM4g)
```

### Testing connectivity
After loading the modules described above and acquiring kerberos tickets in an interactive slurm job, you
can test connectivity to the database server using the `tsql` interactive query tool:

```
USERNAME@compute-a-16-167 (~): tsql -S DBMIHDSWSQLP01.med.harvard.edu
locale is "en_US.UTF-8"
locale charset is "UTF-8"
using default charset "UTF-8"
1> SELECT TOP 10 * FROM Inovalon.dbo.provider
2> GO
```

Press enter after the `SELECT` statement and after entering `GO`.  The program should print 10 rows
of data from the database table to the console.  If it didn't, then check that you 

### R
In order to run R on O2, you need to load the module that corresponds to your preferred version of
R.  This is in addition to the modules listed above.  To see the available versions, run this at the command line:

```
module spider R
```

The latest version of R that is currently compatible with the database connectivity tools is R 4.1.1.

Once you have chosen a version of R you can load the module, e.g.:

```
module load gcc/6.2.0 R/4.1.1
```

The first time that you run R you will need to install several database connectivity tools by running the
commands in the `Code//R/InstallDatabaseTools.R` script in this repository.  If you are prompted to "use a 
personal library" respond "yes", and then yes again if prompted to "create a personal library".

Once the dependencies are installed, you should be able to run the small example R code in
`Code/R/ConnectToDatabase.R`.

### Python
With the `gcc/6.2.0 unixODBC msodbcsql17/17.7.2.1-1 freetds` modules loaded as described above, 
and kerberos tickets acquired, you will need to add the following module to your environment
to run Python.  The latest version of Python installed on O2 that
is compatible with the database connectivity tools is python 3.7.4.

```
module load python/3.7.4
```

Then create and activate a virtual environment:

```
python3 -m venv ~/InovalonEnv
source ~/InovalonEnv/bin/activate
```

Inside of the virtual environment, upgrade `pip` and install `pyodbc`:

```
pip install --upgrade pip
python3 -m pip install pyodbc
```

You should now be able to run Python and connect to the database to pull down data:

```
import pyodbc
cnxn = pyodbc.connect('DRIVER=ODBC Driver 17 for SQL Server;Server=DBMIHDSWSQLP01.med.harvard.edu;Trusted_Connection=Yes;Database=Inovalon;TDS_Version=8.0;Encryption=require;Port=1433;REALM=MED.HARVARD.EDU')
cursor = cnxn.cursor()
cursor.execute("SELECT TOP 1 * FROM Inovalon.dbo.provider")
row = cursor.fetchone()
if row:
    print(row)
```

## VS Code
Visual Studio Code can be run via the [O2portal](https://o2portal.rc.hms.harvard.edu/pun/sys/dashboard).  
Please refer to Research Computing's documentation to learn more about running jobs through the Portal.

Once you have a VS Code session running, you can install the MS SQL Server extension, which provides a GUI 
for exploring the various objects in the database, as well as interactive query sessions.  Click on the 
Extensions icon in the Activity Bar on the left side of the VS Code interface.  Search the marketplace 
for "sql server" and install the extension named "SQL Server (mssql)".

After the extension is installed, you will need to get Kerberos tickets for the session that is 
running VS Code to authenticate to the database server.  Click on the "Terminal" menu in VS Code and
select New Terminal. A terminal should open at the bottom of the screen, running a shell on the O2
host where your VS Code session is running.  Run `kinit` in that shell and enter your password, just as you did above.

Bring up the Command Pallate (CTRL + shift + P), and begin typing 
"sql: add connection".  It should autocomplete; select "MS SQL: Add Connection".  When prompted for a server name, 
enter "DBMIHDSWSQLP01.med.harvard.edu" (no quotes).  For the database, enter "Inovalon" (no quotes).
For Authenticaion Type, select "Integrated".  Optionally provide a display name for the connection.  You should 
see a prompt in the bottom-right of the window about encryption on the connection.  Click "Enable Trust Server Certificate".

If you click on the SQL Server icon in the Activity Bar, you should now see the contents of the database.
You can use VS Code to interactively query the database.  It provides syntax highlighting and code completion
to make the task of designing complicated queries easier.  See the documentation for the extension for 
additional details and functionality.