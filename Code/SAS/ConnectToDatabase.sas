/* This works with integrated authentication, so make sure you have kerberos tickets before proceeding */

/* With the FreeTDS ODBC driver: */
libname mylib odbc noprompt="DRIVER={FreeTDS};
                             Server=CCBWSQLP01.med.harvard.edu;
                             Trusted_Connection=Yes;
                             Database=Inovalon;
                             TDS_Version=7.3;
                             Encryption=require;
                             Port=1433;
                             REALM=MED.HARVARD.EDU"
                   schema=dbo;

PROC SQL;
SELECT * FROM mylib.claimcode (OBS=10);
QUIT;

/* With Microsoft's ODBC driver: */
libname mylib odbc noprompt="DRIVER={ODBC Driver 17 for SQL Server};
                             Server=CCBWSQLP01.med.harvard.edu;
                             Trusted_Connection=Yes;
                             Database=Inovalon;
                             TDS_Version=8.0;
                             Encryption=require;
                             Port=1433;"
                   schema=dbo;

PROC SQL;
SELECT * FROM mylib.claimcode (OBS=10);
QUIT;