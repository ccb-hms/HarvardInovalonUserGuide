# Inovalon User Guide
This repository contains guidance, example code, and instructions for working with the Inovalon database
at Harvard Medical School.

 If you have not already been granted access to the Inovalon dataset, please email HMS Office of Research Administration at data_ORA@hms.harvard.edu about gaining access to the Inovalon Data.

## Introduction
The Inovalon data is stored in a large relational database, Microsoft SQL Server, on Windows Server. There are two primary methods for accessing the data: 

1. You can remote desktop to the database server and use Microsoft’s SQL Server Management Studio (SSMS), which provides a convenient GUI for query construction (provides syntax highlighting, code completion, allows you to interactively explore the database).

2. You can create an encrypted connection to the server from O2 compute nodes and pull data into a program such as R, Python, or another analytic tool so that you can perform statistical analyses of the data.

* _Some users may have stand-alone systems that have been authorized to access the Inovalon database_
_for the purpose of running SAS.  We are providing a simple SAS program in `Code\SAS\ConnectToDatabase.sas` to demonstrate connectivity_
_to the database via ODBC, but stand-alone system configuration is generally outside the scope of this guide._

Our recommended workflow is for users to connect to the server with Remote Desktop and use the interactive
query tools there to carve off the relevant data for their analysis into a personal database (details below).
Then, for statistical analysis, modelling, figure plotting, etc, pull that subset of the data from your personal
database to an O2 compute node in R or Python.

You will need access to the Harvard Medical School VPN to continue.  You can request access if you don’t already have it, and learn how to configure your VPN client software here:

http://it.hms.harvard.edu/services/servers-network/virtual-private-network

Please email CCB with any technical questions.  The CCB help desk can be reached at <ccbhelp@hms.harvard.edu>.

## Connecting to the Database Server with Remote Desktop
If you are on a macOS machine, you can download Microsoft Remote Desktop from the App Store.  Just search for “Microsoft Remote Desktop” and install the app (it’s free).  If you are on a Windows computer, then you should have the Remote Desktop tool installed by default (it’s typically located in the “Windows Accessories” folder in your start menu).

Start the Remote Desktop application and create a new connection. You can provide whatever name you’d like for the connection.  The server address for the connection should be:

`ccbwsqlp01.med.harvard.edu`

Use your HMS user name and password.  Because this is a Windows machine, you need to add the Windows domain name (“MED\”) in front of your username.  So if your user ID is `abc123`, you would enter `MED\abc123` for your username to log on to Windows.

*IMPORTANT:*

The database server is located on a private network.  Access to this network is restricted by a firewall.  Your VPN account has been configured to allow you access to this network, and we have allowed very limited access to this network from the HMS O2 computing cluster.

You cannot connect directly to the database server (e.g., via remote desktop) without first starting your two-factor secured HMS Pulse Secure VPN connection. If you are having trouble connecting via Remote Desktop, the first thing to check is to make sure that your VPN connection is running.

After starting your VPN connection, open the Remote Desktop connection created above.  You will be presented with a virtual session on the database server once you successfully log in.  To start SSMS, click the Windows Start button, click “Microsoft SQL Server Tools 19” and click on “Microsoft SQL Server Management Studio”.

Once SSMS starts, you will be presented with a “Connect to Server” dialog.  Make sure the following default values are set in the dialog box:

`Server type: Database Engine`

`Server name: localhost`

`Authentication: Windows Authentication`

Click `Options >>`, then on the `Connection Properties` tab. Check the `Encrypt connection` and `Trust server certificate` options if they are not already enabled.

Then click “Connect”.

Once the connection is established, click New Query on the toolbar to create a new query session.

## Relational Database Learning Materials
An introduction to relational database systems is beyond the scope of this document.  If you need more information on working with the SQL language, relational database, or relational algebra in general, these are good starting points:

* https://www.coursera.org/learn/introduction-to-relational-databases#syllabus (sign up, and choose to audit the course for free, no need for free trial or to pay)

* https://www.amazon.com/Database-Management-Systems-Raghu-Ramakrishnan/dp/0072465638

* There are many good O’Reilly technical books freely available to Harvard faculty, students, and employees.  Go here: https://library.harvard.edu/services-tools/oreilly-learning-platform and log in with your Harvard credentials.  Once you’re logged in to the O’Reilly site, search for “SQL”.

* https://learn.microsoft.com/en-us/sql/sql-server/?view=sql-server-ver15

There are many other good tutorials available on the web.

## The Inovalon Database
The Inovalon data is stored in the database named "Inovalon". Please see the [Inovalon help center](https://support.inovalon.com/hc/en-us/categories/360005803231-Insights) for data dictionaries, database diagrams, FAQs and more.

Inovalon has informed us that the source data that was sent to us contains approximately 5% duplicate claims. To remediate this
they have provided the framework of an algorithm to de-duplicate the claims table.  We are actively working on implementing this 
de-duplication strategy and will provide updates as they are available.

The database is very large and consequently some queries will take a very long time to run. To facilitate interactive 
data exploration, method development, and debugging, we have created a one million member random sample of the original database 
and placed all of the records for this < 1% of the population in a separate database named `InovalonSample1M`. The tables in 
`InovalonSample1M` have identical names and schemas to those in the complete `Inovalon` database. Thus, any workflows that
are developed against the down-sampled data set can be run against the full data set by simply changing the database context.
We strongly encourage use of this down-sampled data set during the development phase of your work.

## Creating Your Own Database
You can create your own database on the server, which may be useful as a temporary place to store intermediate tables.  To do so, in SSMS, right-click on the “Databases” entry of the treeview on the left side of the screen.  Click on “New Database…”.  Please use your username as the name for the database.  Do not change the default file locations.  One change that you MUST make is to select the “Options” page on the left side of the “New Database” dialog and change the “Recovery model” value from “Full” to “Simple”.  Failure to do this will cause your transaction logs to expand unnecessarily, consuming large amounts of disk space.  If this happens, we will delete your database and you will be forced to recreate your work.

### Allowing Other Users to Access Your Database
By default, in SQL Server, a database is only accessible by the user who created it.  There are times when it may be helpful to allow other to access your database, e.g., when working on a team, or creating a database that you believe would generally be useful to others. 

The easiest way to do this is through the GUI.  Expand your database in the tree view on the left, expand `Security` and right click on `Users`.  Select `New User`.  Under `User Type` select `Windows user`.  Under `User name` click on the ellipsis `…`.  
Then click on `Locations`, expand `Entire Directory`, `MED.HARVARD.EDU`, then select `PEOPLE` and click `OK`. 
You can then search for a name by clicking `Check Names`.  Then click `OK`. 

Once you’ve selected the name, you can leave `Login name` and `Default schema` blank.  Click `Membership` on the left, and select the permissions you’d like to grant.  If you want the user to have read-only access, then select `db_datareader`.  If you want the user to be able to write data, select `db_datawriter` (for more information on permissions: https://learn.microsoft.com/en-us/sql/relational-databases/security/authentication-access/database-level-roles?view=sql-server-ver15). Click `OK` and you’re done.


## Scratch Space on the Server and Transferring Files
The `S:\` drive on this server is dedicated temporary “scratch” space.  You can use this area as temporary storage.  Files on this drive older than 30 days will be automatically deleted.  You can “map” or “mount” this volume remotely, allowing you to transfer files to the server e.g. to be staged into your own database.  

From a macOS machine with an active VPN connection, you can mount the scratch space through Finder.  In the menu bar, click `Go` then `Connect to Server`.  Enter this SMB share address, and click `Connect`: `smb://ccbwsqlp01.med.harvard.edu/UserTemp$`

Make sure to include the dollar sign at the end (it’s an indication that the share is hidden and not browsable on the network).  When prompted for your credentials, again, use your HMS user ID prefixed by “MED\” to indicate it is a Windows domain account.

From a Windows client machine with an active VPN connection, in File Explorer, right-click `This PC` and select `Map network drive…`.  Select a drive letter of your own choosing, and in the `Folder` text box, enter:

`\\ccbwsqlp01.med.harvard.edu\UserTemp$`

## A Note on Disaster Recovery
We are not performing backups of any kind on this platform.  We are recommending that users not try to copy or backup their data, but rather backup the scripts and code that were used to generate the data. If there is a storage failure on the server, please assume that everything on it will be un-recoverable.  We will repair the storage, and a new copy of the Inovalon database will be available, but everything else will be lost.  You are responsible for keeping backup copies of your code on a separate platform.

## Connecting to the Database from the O2 Cluster
If you are unfamiliar with the Medical School's high-performance compute cluster, called "O2", you can read about it here:
https://wiki.rc.hms.harvard.edu/display/O2

To request an O2 account, see:

https://harvardmed.atlassian.net/wiki/spaces/O2/pages/1918304257/How+to+request+or+retain+an+O2+account

All of what follows assumes that you are working in an interactive slurm job on the O2 cluster, for example with an `srun`
command such as 

```
srun --pty -p interactive --mem 1024M -c 1 -t 0-06:00 --account=[ACCOUNT] /bin/bash
```

replacing `[ACCOUNT]` with an appropriate value.

## Working in R and Python on O2
The O2 cluster uses a [module system](https://harvardmed.atlassian.net/wiki/spaces/O2/pages/1588661845/Using+Applications+on+O2) 
to manage software packages.  Before you can connect to the database server from either R or Python, you need to make 
the underlying database drivers accessible in your session.  Load the required modules with:

```
module load gcc/6.2.0 unixODBC msodbcsql17/17.7.2.1-1 freetds
```

That command can be executed in the shell on a per-session basis, or you can add it to your shell initialization file, 
e.g., by adding it to the end of your `.bashrc` script, which will ensure that the libraries are available every time you 
log in to the cluster, and in every job that you run.  If you add it to your initialization script, make sure to 
log out and then back in to the cluster after you edit the file, before you attempt to connect to the database.

To verify that the modules successfully loaded in your session, you can run the `module list` command.  You should
see `msodbcsql17/17.7.2.1-1` and the others listed above among the currently loaded modules, e.g.:

```
USERNAME@compute-e-16-233 (~): module list

Currently Loaded Modules:
  1) gcc/6.2.0   2) msodbcsql17/17.7.2.1-1   3) unixODBC/2.3.6   4) freetds/1.2.21
```

### Authentication
Access to the Inovalon database is provided on a per-user basis.  The O2 compute nodes use 
Kerberos to authenticate your user credentials to the database server.  You will need to interactively
enter your password only once per session, and after you're authenticated, the session will hold a "ticket"
that grants access to the database for the duration of the job.  This single-sign-on approach eliminates
the need for both multiple manual password entries per session, and clear-text embedding of credentials in 
R or Python code.

You can acquire kerberos tickets for your session by running the following at the command line:

```
kinit
```

You will be prompted `Password for [USERNAME]@MED.HARVARD.EDU:`.  Type your password and press enter.  
You can verify that the ticket was acquired by running the `klist` command.  If authentication was 
successful, you should see output similar to:

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
USERNAME@compute-a-16-167 (~): tsql -S CCBWSQLP01.med.harvard.edu
locale is "en_US.UTF-8"
locale charset is "UTF-8"
using default charset "UTF-8"
1> SELECT TOP 10 * FROM Inovalon.dbo.provider
2> GO
```

Press enter after the `SELECT` statement and after entering `GO`.  The program should print 10 rows
of data from the database table to the console.  If it didn't, then check that you have loaded the 
required modules and have acquired kerberos tickets.

### R
In order to run R on O2, you first need to load the appropraite software module. As above, the module 
can be loaded manually on a per-session basis, or the command can be added to your `~/.bashrc` initialization script.
The latest version of R that is currently compatible with the database connectivity tools on O2 is R 4.1.1.

You can load the appropriate module with:

```
module load gcc/6.2.0 R/4.1.1
```

You will need to install several database connectivity tools (only once) by running the
commands in the `Code/R/InstallDatabaseTools.R` script in this repository.  If, when running those R commands,
you are prompted to "use a personal library" respond "yes", and then "yes" again if prompted to "create a personal library".

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

You should now be able to run Python and connect to the database to pull down data. See example code
in `Code/Python/connect_to_database.py` in this repository.

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
enter "CCBWSQLP01.med.harvard.edu" (no quotes).  For the database, enter "Inovalon" (no quotes).
For Authenticaion Type, select "Integrated".  Optionally provide a display name for the connection.  You should 
see a prompt in the bottom-right of the window about encryption on the connection; click "Enable Trust Server Certificate".

If you click on the SQL Server icon in the Activity Bar, you should now see the contents of the database.
You can use VS Code to interactively query the database.  It provides syntax highlighting and code completion
to make the task of designing complicated queries easier.  See the documentation for the extension for 
additional details and functionality.

## Example Workflows

### R
* `Code\R\AgeGenderDiagnosisRegression.R`:
This example demonstrates how to manipulate the claimcode,
member, and member_enrollment tables to generate a dataset
to investigate the relationship between gender, age, and
ASD diagnoses.  The Inovalon tables are manipuleted on the
SQL Server to generate the data set of interest, and the
analytic-ready table is then pulled into R to fit a simple
regression model.  Althought the SQL statements are embedded 
in the R script, they were designed interactively using SSMS
and pasted into the R workflow.