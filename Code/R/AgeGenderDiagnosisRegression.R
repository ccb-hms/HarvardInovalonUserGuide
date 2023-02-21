# AgeGenderDiagnosisRegression.R
# Nathan Palmer
# Harvard Medical School
#
# This example demonstrates how to manipulate the claimcode,
# member, and member_enrollment tables to generate a dataset
# to investigate the relationship between gender, age, and
# ASD diagnoses.  The Inovalon tables are manipuleted on the
# SQL Server to generate the data set of interest, and the
# analytic-ready table is then pulled into R to fit a simple
# regression model.

# Use the down-sampled data set.
cn = MsSqlTools::connectMsSqlDomainLogin(
    server = "CCBWSQLP01.med.harvard.edu",
    database = "InovalonSample1M")

# Identify all members with either an ICD9 or ICD10 Dx
SqlTools::dbSendUpdate(cn, "
    SELECT CC.memberuid
    INTO #tmpAsdMembers
    FROM claimcode CC
    WHERE
        -- ICD9
        (CC.codetype=7 AND CC.codevalue LIKE '299%')
        OR
        -- ICD10
        (CC.codetype=17 AND CC.codevalue='F840')
    GROUP BY CC.memberuid;
")

## See how many there were, should be about 7k
DBI::dbGetQuery(cn, "SELECT COUNT(*) FROM #tmpAsdMembers")

# Materialize a row for each ASD member's year of age while enrolled (approx).
SqlTools::dbSendUpdate(cn, "
    SELECT
        T.memberuid,
        YEAR(ME.effectivedate) - M.birthyear AS MemberAge
    INTO #tmpAsdMemberAges
    FROM 
        #tmpAsdMembers T 
        INNER JOIN memberenrollment_adjusted ME ON
            T.memberuid = ME.memberuid
        INNER JOIN member M ON
            ME.memberuid = M.memberuid
    GROUP BY
        T.memberuid,
        YEAR(ME.effectivedate) - M.birthyear
")

# Count how many ASD diagnoses each of these members had during 
# each year of enrollment
SqlTools::dbSendUpdate(cn, "
    SELECT
        T.memberuid,
        YEAR(CC.servicedate) - M.birthyear AS AgeAtService,
        COUNT_BIG(DISTINCT CC.claimuid) AS NumberOfDiagnoses
    INTO #tmpAsdDiagnoses
    FROM
        #tmpAsdMembers T
        INNER JOIN member M ON
            T.memberuid = M.memberuid
        INNER JOIN claimcode CC ON
            T.memberuid = CC.memberuid
    WHERE
        -- ICD9
        (CC.codetype=7 AND CC.codevalue LIKE '299%')
        OR
        -- ICD10
        (CC.codetype=17 AND CC.codevalue='F840')
    GROUP BY
        T.memberuid,
        YEAR(CC.servicedate) - M.birthyear
")

# Join diagnosis counts to enrollement year ages, left join and plug in a zero
# when no diagnoses appeared at a particular age.
SqlTools::dbSendUpdate(cn, "
    SELECT
        A.memberuid,
        A.MemberAge,
        M.gendercode,
        CASE
            WHEN D.NumberOfDiagnoses IS NOT NULL THEN D.NumberOfDiagnoses
            ELSE 0 END AS NumberOfDiagnoses
    INTO #tmpAsdDiagnosesAgeGender
    FROM
        member M
        INNER JOIN #tmpAsdMemberAges A ON
            M.memberuid=A.memberuid
        LEFT OUTER JOIN #tmpAsdDiagnoses D ON
            A.memberuid=D.memberuid
            AND A.MemberAge=D.AgeAtService
    WHERE
        A.MemberAge>0
        AND A.MemberAge<22
        AND (M.gendercode='F' OR M.gendercode='M')
")

# Pull the table into R
asdDiagnosesByAge =
    DBI::dbGetQuery(cn, "SELECT * FROM #tmpAsdDiagnosesAgeGender")

# Take a look at the first few rows
head(asdDiagnosesByAge)

# Fit a linear model to predict number of diagnoses as a function of 
# age and gender
fit = glm(
    formula = NumberOfDiagnoses ~ MemberAge + gendercode,
    data = asdDiagnosesByAge)

# Not much there...
summary(fit)

# Let's try separating the males and females and
# fit the models independently
asdDiagnosesByAgeM =
    asdDiagnosesByAge[which(asdDiagnosesByAge[,"gendercode"]=="M"),]
asdDiagnosesByAgeF = 
    asdDiagnosesByAge[which(asdDiagnosesByAge[,"gendercode"]=="F"),]

fitM = glm(formula = NumberOfDiagnoses ~ MemberAge, data = asdDiagnosesByAgeM)
fitF = glm(formula = NumberOfDiagnoses ~ MemberAge, data = asdDiagnosesByAgeF)

# Looks like males are more likely to receive an ASD diagnosis at a younger age,
# while females are more likely to receive an ASD diagnosis at later age.
summary(fitM)
summary(fitF)