You are a technical assistant and SQL wizard.  This document between <BEGIN> and <END> describes a large health insurance database.

<BEGIN>
# Introduction

This data dictionary provides information about the definitions of all the data elements in each file type.

Inovalon Insights Real-World Data (RWD) datasets consists of:

- Core dataset of files that are included with each delivery type (per contractual terms)
- Supplemental files that may accompany the core dataset

Each file contains data that can be used to create a database structure with a system of choice. A list of columns is included, describing the column name used in the file, its data type, a description of the column content, expected values for each column, key notation, and required field indicators.


# CLAIM

The CLAIM file contains claim service line information for medical services and may also include information relating to lab services (without an associated result), pharmaceuticals administered from the practitioner’s office, and medical encounter data.

### Columns:

| Column Name               | Description                                                                                          | Data Type | Key(s) | Null  |
|---------------------------|------------------------------------------------------------------------------------------------------|-----------|--------|-------|
| **ClaimUID**               | Unique record ID for a claim service line. Not derived from or related to the individual.            | BIGINT    | PK     | No    |
| **MemberUID**              | Unique ID of a person identified as a result of matching patients across all plans; bridges data.    | VARCHAR   | FK     | No    |
| **ProviderUID**            | Unique ID of a healthcare provider. Re-assigned to make it unique across all data sources' data.     | BIGINT    | FK     | Yes   |
| **ClaimStatusCode**        | Code value identifying the payment status of a claim. Values: A, D, I, P, R, U, X.                  | VARCHAR   |        | Yes   |
| **ServiceDate**            | The date when the service was provided or began.                                                     | DATE      |        | No    |
| **ServiceThruDate**        | The date when the service ended.                                                                    | DATE      |        | No    |
| **UBPatientDischargeStatusCode** | National Uniform Billing Committee (UB) Patient Discharge Status code value identifying the discharge status of an institutional claim. | VARCHAR   |        | Yes   |
| **ServiceUnitQuantity**    | Quantity per service unit used for cost calculation.                                                 | DECIMAL   |        | Yes   |
| **DeniedDaysCount**        | Number of days not covered for inpatient claims.                                                     | INTEGER   |        | No    |
| **BilledAmount**           | Amount billed for the service.                                                                      | DECIMAL   |        | Yes   |
| **AllowedAmount**          | The amount the insurance company allows the provider to be reimbursed under contract.                | DECIMAL   |        | Yes   |
| **CopayAmount**            | The amount the member is responsible to pay.                                                        | DECIMAL   |        | Yes   |
| **PaidAmount**             | The amount the insurance company paid to the provider.                                               | DECIMAL   |        | Yes   |
| **RxProviderIndicator**    | Indicates whether the claim provider has prescribing privileges. Values: 1 = True, 0 = False.       | INTEGER   |        | No    |
| **PCPProviderIndicator**   | Indicator for whether the claim provider serves as a PCP for the health plan.                        | INTEGER   |        | No    |
| **RoomBoardIndicator**     | Indicates whether the claim is for Room and Board service. Values: 1 = True, 0 = False.             | INTEGER   |        | No    |
| **MajorSurgeryIndicator**  | Indicates whether the claim includes a procedure considered major surgery. Values: 1 = True, 0 = False. | INTEGER   |        | No    |
| **ExcludeFromDischargeIndicator** | Indicates whether the claim should be excluded from discharge. Values: 1 = True, 0 = False.   | INTEGER   |        | No    |
| **ClaimFormTypeCode**      | Type of claim form. Values: I - Institutional, P - Professional.                                     | VARCHAR   |        | Yes   |
| **InstitutionalTypeCode**  | A derived field indicating the type of institutional service. Values: I - Inpatient, O - Outpatient. | VARCHAR   |        | Yes   |
| **ProfessionalTypeCode**   | A derived field indicating the type of professional service.                                         | VARCHAR   |        | Yes   |
| **BillingProviderUID**     | Unique ID of the healthcare provider billing the claim.                                              | BIGINT    | FK     | Yes   |
| **RenderingProviderUID**   | Unique ID of the healthcare provider rendering service on the claim.                                 | BIGINT    | FK     | Yes   |
| **RenderingProviderNPI**   | National Provider Identification number of the Rendering provider (for professional claims) or Attending provider (for institutional claims). | VARCHAR   |        | Yes   |
| **BillingProviderNPI**     | National Provider Identification number of the Billing provider.                                     | VARCHAR   |        | Yes   |
| **SourceModifiedDate**     | Date the data source last modified the claim.                                                        | DATE      |        | Yes   |
| **ClaimNumber**            | Hashed and salted claim header number for a claim transaction as it would appear on the CMS 1500 or UB04. | CHAR     |        | Yes   |
| **ClaimLineNumber**        | Indicates the line number for the particular service being rendered.                                 | VARCHAR   |        | Yes   |
| **CreatedDate**            | Date when the extract was created.                                                                  | DATE      |        | No    |

This concludes the CLAIM section. The next section, starting with CLAIM CODE, will contain additional attributes related to encounter data.


# CLAIMCODE

The CLAIMCODE file contains claim attributes related to encounter data. See Appendix A for lookup values.

### Columns:

| Column Name        | Description                                                                                               | Data Type | Key(s) | Null  |
|--------------------|-----------------------------------------------------------------------------------------------------------|-----------|--------|-------|
| **ClaimUID**        | Unique record ID for a claim service line, from the Claim table.                                          | BIGINT    | PK     | No    |
| **MemberUID**       | Unique ID of a person identified as a result of matching patients across all plans.                       | VARCHAR   | FK     | No    |
| **ServiceDate**     | The date when the service was provided or began.                                                          | DATE      |        | No    |
| **ServiceThruDate** | The date when the service ended.                                                                         | DATE      |        | No    |
| **CodeType**        | Describes the claim attribute related to encounter claims.                                                | INTEGER   | PK     | No    |
| **OrdinalPosition** | Ordinal position within the source data. (all CodeTypes start with 0).                                    | INTEGER   | PK     | No    |
| **CodeValue**       | Contains the actual value corresponding to the claim attribute.                                           | VARCHAR   |        | No    |
| **DerivedIndicator**| Indicates whether the value was derived. Values: 1 = Derived, 0 = Not Derived.                           | INTEGER   |        | No    |
| **CreatedDate**     | Date when extract was created.                                                                           | DATE      |        | No    |

This concludes the CLAIM CODE section. The next section, starting with LAB CLAIM, will cover attributes related to laboratory procedures.



## LABCLAIM

The LABCLAIM file contains claim attributes associated with laboratory procedures.

| COLUMN NAME         | DESCRIPTION                                                                | COMMENTS                                                                                                 | DATA TYPE | KEY(S) | NULL |
|---------------------|----------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|-----------|--------|------|
| LabClaimUID         | Unique ID assigned to a laboratory claim record                            | Re-assigned and used in the dataset to make it unidentifiable and unique across all client data.          | BIGINT    | PK     | No   |
| MemberUID           | Unique ID of a person identified as a result of matching patients across all plans; bridges data across entire dataset. | This is a unique number, generated sequentially and stored as an integer in the database. It is "not derived from or related to the individual" and is compliant with Section 164.514(c)(1). | VARCHAR   | FK     | No   |
| ProviderUID         | Unique ID of a healthcare provider.                                         | Re-assigned to make it unique across all data sources' data. Provider information is identifiable, but member information is unidentifiable. | BIGINT    | FK     | Yes  |
| ClaimStatusCode     | Code value identifying the payment status of a claim. Defined by Inovalon Insights. | Values: A - Adjustment to Original Claim, D - Denied Claims, I - Initial Pay Claim, P - Pended for Adjudication, R - Reversal to Original Claim, U - Unknown, X, x - Null. | VARCHAR   |        | Yes  |
| ServiceDate         | The date when the service was provided.                                    | Value is passed through from source data.                                                                | DATE      |        | No   |
| CPTCode             | Current Procedural Terminology Code value identifying medical services and procedures provided by healthcare providers. | Value is passed through from source data.                                                                 | VARCHAR   |        | Yes  |
| LOINCCode           | Code value of Logical Observation Identifiers Names and Codes identifying laboratory tests conducted. | Value is passed through from source data.                                                                | VARCHAR   |        | Yes  |
| ResultNumber        | Not provided                                                               |                                                                                                          | NULL      |        | Yes  |
| ResultText          | Not provided                                                               |                                                                                                          | NULL      |        | Yes  |
| PosNegResultIndicator | Indicates whether the result is positive or negative (PosNeg) for results not having an associated numeric result. | Value is passed through from source data. Values: True = Positive, False = Negative.                      | BOOLEAN   |        | Yes  |
| UnitName            | Name of the unit used in the lab test.                                      | Value is passed through from source data.                                                                | VARCHAR   |        | Yes  |
| Sourcemodifieddate  | Date the data source last modified the claim.                               |                                                                                                          | DATE      |        |      |
| CreatedDate         | Date when Extract was created.                                              |                                                                                                          | DATE      |        | No   |

## MEMBER

The MEMBER file contains attributes pertaining to members enrolled in an insurance company provided health plan.

| COLUMN NAME         | DESCRIPTION                                                                | COMMENTS                                                                                                 | DATA TYPE | KEY(S) | NULL |
|---------------------|----------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|-----------|--------|------|
| MemberUID           | Unique ID of a person identified as a result of matching patients across all plans; bridges data across entire dataset. | This is a unique number, generated sequentially and stored as an integer in the database. It is "not derived from or related to the individual" and is compliant with Section 164.514(c)(1). | VARCHAR   | PK     | No   |
| BirthYear           | De-identification rule: To calculate Member age, the maximum of the following date is first determined: Plan termination date, Claim service date, Lab service date, Rx fill date, etc.  | Year of birth, top-coded at 89. Ages 90 and above are coded as 1800. | INTEGER   |        | Yes  |
| GenderCode          | Code value identifying the gender of a person.                            | Values: F - Female, M - Male, U - Unknown, X - NULL.                                                      | VARCHAR   |        | Yes  |
| StateCode           | Two-character code value identifying US State or territory.               | Value is passed through from source data.                                                                | VARCHAR   |        | Yes  |
| Zip3Value           | Derived from the zip code of patient residence.                           | The zip code of patient residence is either removed (as 000) or mapped to a string of 1 or more 3-digit zip codes, describing a larger postal delivery area (ex. 21401 maps to 210_211_214_219). | VARCHAR   |        | Yes  |
| RaceEthnicityTypeCode | Code value identifying the type of race of a person.                    | Values: 01 - White, 02 - Black or African American, 04 - Asian or Pacific Islander, 06 - Some Other Race, 09 - Unknown, 11 - Hispanic or Latino. | VARCHAR   |        | Yes  |
| CreatedDate         | Date when extract was created.                                              |                                                                                                          | DATE      |        | No   |



## MEMBERENROLLMENT_ADJUSTED

The MEMBERENROLLMENT_ADJUSTED file contains adjusted enrollment dates that align with claims data. Sources often send enrollment information for their members for time spans that are longer than the spans for which they supply claims information. The process of aligning the begin and end dates with claims data is Inovalon defined as “enrollment adjusted.”

| COLUMN NAME              | DESCRIPTION                                                                | COMMENTS                                                                                                 | DATA TYPE | KEY(S) | NULL |
|--------------------------|----------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|-----------|--------|------|
| MemberUID                | Unique ID of a person identified as a result of matching patients across all plans; bridges data across entire dataset. | This is a unique number, generated sequentially and stored as an integer in the database. It is "not derived from or related to the individual" and is compliant with Section 164.514(c)(1). | VARCHAR   | FK     | No   |
| EffectiveDate            | Effective date of the health plan enrollment.                               | Value is passed through from source data.                                                                | DATE      |        | No   |
| TerminationDate          | Termination date of the health plan enrollment.                             | Value is passed through from source data.                                                                | DATE      |        | No   |
| ClaimAdjustedEffectiveDate | The effective date is increased to the earliest date for which medical claims data can be expected to exist. | Value is derived from source data.                                                                       | DATE      |        | Yes  |
| ClaimAdjustedTerminationDate | The termination date is decreased to the latest date for which medical claims data can be expected to exist. | Value is derived from source data.                                                                       | DATE      |        | Yes  |
| RxClaimAdjustedEffectiveDate | The effective date is increased to the earliest date for which Rx claims data can be expected to exist. | Value is derived from source data.                                                                       | DATE      |        | Yes  |
| RxClaimAdjustedTerminationDate | The termination date is decreased to the latest date for which Rx claims data can be expected to exist. | Value is derived from source data.                                                                       | DATE      |        | Yes  |
| PayerGroupCode           | Rollup of PayerTypeCode.                                                    | Value is derived from the PayerTypeCode. Values: C - Commercial, M - Medicaid, R - Medicare Advantage, U - Unknown / Other. | VARCHAR   |        | Yes  |
| PayerTypeCode            | Code value identifying the type of entities responsible for the costs for the services performed. Defined by Inovalon Insights. | Value is passed through from source data. Values: C - Commercial, CM - Commercial and Medicaid, CR - Commercial and Medicare, CS - Commercial and SNP, etc. | VARCHAR   |        | Yes  |
| ProductCode              | Code value identifying the type of health plan product.                     | Defined by Inovalon Insights. ProductCode differentiates product lines. Values: E - EPO, F - PFFS, H - HMO, O - Other, P - PPO, S - POS, X - Null. | VARCHAR   |        | Yes  |
| MedicalIndicator         | Indicates if medical benefit is included.                                   | Value is mapped from source data values.                                                                 | INTEGER   |        | No   |
| RxIndicator              | Indicates if pharmacy benefit is included.                                  | Value is mapped from source data values. Values: 1 = True, 0 = False.                                     | INTEGER   |        | No   |
| SourceID                 | Not Provided                                                                |                                                                                                          | INTEGER   |        | Yes  |
| GroupPlanTypeCode        | The type of enrollment group size for which the Commercial Plan is designed. | This is only applicable to commercial plans. Value is mapped from source data values. Values: ID - Individual, SM - Small Group, LG - Large Group. | VARCHAR   |        | Yes  |
| MAContractTypeCode       | Medicare Advantage contract type.                                           | This is only applicable to Medicare Advantage plans. Value is mapped from source data values. Values: E - Employer Direct Prescription Drug Plan (PDP), H - Local Medicare Advantage (MA), Local Medicare Advantage Prescription Drug (MAPD), or non-Medicare Advantage (MA) Plan, R - Regional Medicare Advantage (MA) or Medicare Advantage Prescription Drug (MAPD) Plan, S - Regular Standalone Prescription Drug P...
| ACAIndicator             | Indicates if plan is ACA.                                                   | ACA can be on or off exchange plans. Value is mapped from source data values. Values: 1 = True, 0 = False. | INTEGER   |        | Yes  |
| ACAIssuerStateCode       | Indicates the state for which the IssuerID has been issued for each client.  | Value is mapped from source data values.                                                                 | VARCHAR   |        | Yes  |
| ACAGrandfatheredIndicator | Indicates if plan has ACA grandfathered status.                            | Grandfathered Plan - a group health plan or individual coverage that was in effect on March 23, 2010. Value is mapped from source data values. Values: 1 = True, 0 = False. | INTEGER   |        | Yes  |
| ACAOnExchangeIndicator   | Indicates if plan is offered on ACA exchange.                               | ACA can be on or off exchange plans. Value is mapped from source data values. Values: 1 = True, 0 = False. | INTEGER   |        | Yes  |
| ACAMetalLevel            | Indicator that classifies the plan based on the range and the quality of benefits offered by a plan. | Value is mapped from source data values. Values: B = Bronze, E = Bronze Expanded, C = Catastrophic, G = Gold, P = Platinum, S = Silver, U = Unknown. | VARCHAR   |        | Yes  |
| ACAActuarialValue        | Indicates the Actuarial value rate.                                         | The projected average amount an ACA plan will pay for covered essential benefits, for a standard population, as a whole number percentage, +/- 2%. Value is mapped from source data values. | INTEGER   |        | Yes  |
| CreatedDate              | Date when extract was created.                                              |                                                                                                          | DATE      |        | No   |



## PROVIDER

The PROVIDER file contains attributes pertaining to health care providers, as identified by each health plan, who submit claims for services rendered to health plan members.

| COLUMN NAME              | DESCRIPTION                                                                | COMMENTS                                                                                                 | DATA TYPE | KEY(S) | NULL |
|--------------------------|----------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|-----------|--------|------|
| ProviderUID              | Unique ID of a health care provider.                                        | Re-assigned to make it unique across all data sources' data. Provider information is identifiable, but member information is unidentifiable. | BIGINT    | PK     | No   |
| LastName                 | Standardized last name.                                                     | Value is enriched using third party data. Not provided when financial data is provided separately.        | VARCHAR   |        | Yes  |
| FirstName                | Standardized first name.                                                    | Value is enriched using third party data. Not provided when financial data is provided separately.        | VARCHAR   |        | Yes  |
| MiddleName               | Standardized middle name.                                                   | Value is enriched using third party data. Not provided when financial data is provided separately.        | VARCHAR   |        | Yes  |
| CompanyName              | Legal business name used to file tax returns with the IRS.                  | Value is enriched using third party data. Not provided when financial data is provided separately.        | VARCHAR   |        | Yes  |
| NPI1                     | National Provider Identification number.                                    | Value is enriched using third party data. Not provided when financial data is provided separately.        | VARCHAR   |        | Yes  |
| NPITypeCode1             | Code value indicating the provider entity type.                             | Value is enriched using third party data. Values: 1 = Type 1 (Individuals), 2 = Type 2 (Non-Individuals). | VARCHAR   |        | Yes  |
| ParentOrganization1      | Parent organization Name.                                                   | Value is enriched using third party data. Not provided when financial data is provided separately.        | VARCHAR   |        | Yes  |
| NPI2                     | National Provider Identification number.                                    | Value is enriched using third party data. Legacy field that may be populated if a provider has more than one NPI. | VARCHAR   |        | Yes  |
| NPITypeCode2             | Code value indicating the provider entity type.                             | Legacy field that may be populated if a provider has more than one NPI.                                   | VARCHAR   |        | Yes  |
| ParentOrganization2      | Parent Organization Name.                                                   | Value is enriched using third party data. Legacy field that may be populated if a provider has more than one NPI. | VARCHAR   |        | Yes  |
| PrimaryPracticeAddress   | Address data on practice location.                                          | Value is enriched using third party data. Not provided when financial data is provided separately.        | VARCHAR   |        | Yes  |
| SecondaryPracticeAddress | Address data on practice location.                                          | Value is enriched using third party data. Not provided when financial data is provided separately.        | VARCHAR   |        | Yes  |
| PracticeCity             | Address data on practice location.                                          | Value is enriched using third party data. Not provided when financial data is provided separately.        | VARCHAR   |        | Yes  |
| PracticeState            | Address data on practice location.                                          | Value is enriched using third party data. Not provided when financial data is provided separately.        | VARCHAR   |        | Yes  |
| PracticeZip              | Address data on practice location.                                          | Value is enriched using third party data. Not provided when financial data is provided separately.        | VARCHAR   |        | Yes  |
| PracticeZip4             | Address data on practice location.                                          | Value is enriched using third party data. Not provided when financial data is provided separately.        | VARCHAR   |        | Yes  |
| PracticePhone            | Address data on practice location.                                          | Value is enriched using third party data. Not provided when financial data is provided separately.        | VARCHAR   |        | Yes  |
| PrimaryBillingAddress    | Address data on billing location.                                           | Value is enriched using third party data. Not provided when financial data is provided separately.        | VARCHAR   |        | Yes  |
| SecondaryBillingAddress  | Address data on billing location.                                           | Value is enriched using third party data. Not provided when financial data is provided separately.        | VARCHAR   |        | Yes  |
| BillingCity              | Address data on billing location.                                           | Value is enriched using third party data. Not provided when financial data is provided separately.        | VARCHAR   |        | Yes  |
| BillingState             | Address data on billing location.                                           | Value is enriched using third party data. Not provided when financial data is provided separately.        | VARCHAR   |        | Yes  |
| BillingZip               | Address data on billing location.                                           | Value is enriched using third party data. Not provided when financial data is provided separately.        | VARCHAR   |        | Yes  |
| BillingZip4              | Address data on billing location.                                           | Value is enriched using third party data. Not provided when financial data is provided separately.        | VARCHAR   |        | Yes  |
| BillingPhone             | Address data on billing location.                                           | Value is enriched using third party data. Not provided when financial data is provided separately.        | VARCHAR   |        | Yes  |
| TaxonomyCode1            | Taxonomy is the NUCC healthcare provider taxonomy code set and is self-reported by providers when applying for an NPI. | More information on the provider taxonomy codes can be found on the CMS website. Values can be found in Appendix (Provider Taxonomy). | VARCHAR   |        | Yes  |
| TaxonomyType1            | Provider Type.                                                              | Values can be found in Appendix (Provider Taxonomy).                                                      | VARCHAR   |        | Yes  |
| TaxonomyClassification1  | Provider Classification.                                                    | Values can be found in Appendix (Provider Taxonomy).                                                      | VARCHAR   |        | Yes  |
| TaxonomySpecialization1  | Provider Specialization.                                                    | Values can be found in Appendix (Provider Taxonomy).                                                      | VARCHAR   |        | Yes  |
| TaxonomyCode2            | Taxonomy is the NUCC healthcare provider taxonomy code set and is self-reported by providers when applying for an NPI. | More information on the provider taxonomy codes can be found on the CMS website. Values can be found in Appendix (Provider Taxonomy). | VARCHAR   |        | Yes  |
| TaxonomyType2            | Provider Type.                                                              | Values can be found in Appendix (Provider Taxonomy).                                                      | VARCHAR   |        | Yes  |
| TaxonomyClassification2  | Provider Classification.                                                    | Values can be found in Appendix (Provider Taxonomy).                                                      | VARCHAR   |        | Yes  |
| TaxonomySpecialization2  | Provider Specialization.                                                    | Values can be found in Appendix (Provider Taxonomy).                                                      | VARCHAR   |        | Yes  |
| CreatedDate              | Date when extract was created.                                              |                                                                                                          | DATE      |        | No   |



## PROVIDERSUPPLEMENTAL

The PROVIDER_SUPPLEMENTAL file contains the provider details passed through from our data sources, excluding validation from our third-party vendor.

| COLUMN NAME           | DESCRIPTION                                               | COMMENTS                                                                                                 | DATA TYPE | KEY(S) | NULL |
|-----------------------|-----------------------------------------------------------|----------------------------------------------------------------------------------------------------------|-----------|--------|------|
| ProviderUID           | Unique ID of a health care provider.                      | Re-assigned to make it unique across all data sources' data.                                              | BIGINT    | PK     | No   |
| NamePrefix            | Source provider name prefix, such as "Dr".                | Not provided when financial data is provided separately.                                                  | VARCHAR   |        | Yes  |
| Name                  | Source provider name. Could be an organization name.      | Could contain prefix and/or suffix. Not provided when financial data is provided separately.              | VARCHAR   |        | Yes  |
| NameSuffix            | Source provider name suffix, such as "Jr.", "Sr.", "III". | Standardization is defined as parsing name elements in the correct field positions. Typing error corrections are not part of the standardization process. Not provided when financial data is provided separately. | VARCHAR   |        | Yes  |
| Address1              | Source provider address data.                             | Not provided when financial data is provided separately.                                                  | VARCHAR   |        | Yes  |
| Address2              | Source provider address data.                             | Not provided when financial data is provided separately.                                                  | VARCHAR   |        | Yes  |
| City                  | Source provider address data.                             | Not provided when financial data is provided separately.                                                  | VARCHAR   |        | Yes  |
| State                 | Source provider address data.                             | Not provided when financial data is provided separately.                                                  | VARCHAR   |        | Yes  |
| Zip                   | Source provider address data.                             | Not provided when financial data is provided separately.                                                  | VARCHAR   |        | Yes  |
| Phone                 | Source provider phone number.                             | Not provided when financial data is provided separately.                                                  | VARCHAR   |        | Yes  |
| Fax                   | Source provider fax number.                               | Not provided when financial data is provided separately.                                                  | VARCHAR   |        | Yes  |
| DEANumber             | Source provider DEA number.                               | Drug Enforcement Administration (DEA) Number associated with a provider. It is a number assigned to a health care provider by the U.S. Drug Enforcement Administration allowing them to write prescriptions for controlled substances. Not provided when financial data is provided separately. | VARCHAR   |        | Yes  |
| NPINumber             | Source provider NPI number.                               | National Provider Identification number. Not provided when financial data is provided separately.          | VARCHAR   |        | Yes  |
| CreatedDate           | Date when extract was created.                            |                                                                                                          | DATE      |        | No   |



## RXCLAIM

The RX CLAIM file contains attributes associated with pharmacy (prescription) claims.

| COLUMN NAME           | DESCRIPTION                                               | COMMENTS                                                                                                 | DATA TYPE | KEY(S) | NULL |
|-----------------------|-----------------------------------------------------------|----------------------------------------------------------------------------------------------------------|-----------|--------|------|
| RxClaimUID            | Unique ID of a pharmacy (Rx) claim service line record.    | Re-assigned and used in the dataset to make it unidentifiable and unique across all client data.           | BIGINT    | PK     | No   |
| MemberUID             | Unique ID of a person identified as a result of matching patients across all plans; bridges data across entire dataset. | This is a unique number, generated sequentially and stored as an integer in the database. It is "not derived from or related to the individual" and is compliant with Section 164.514(c)(1). | VARCHAR   | FK     | No   |
| ProviderUID           | Unique ID of a health care provider.                       | Re-assigned to make it unique across all data sources' data.                                              | BIGINT    | FK     | Yes  |
| ClaimStatusCode       | Code value identifying the payment status of a claim.      | Defined by Inovalon Insights. Values: A - Adjustment to Original Claim, D - Denied Claims, I - Initial Pay Claim, P - Pended for Adjudication, R - Reversal to Original Claim, U - Unknown, X - Null. | VARCHAR   |        | Yes  |
| FillDate              | The date when the prescription is filled.                  | Value is passed through from source data.                                                                 | DATE      |        | No   |
| NDC11Code             | Dispensed drug identifier.                                 | Value is passed through from source data. Usually 11-digit National Drug Code (NDC), but can be a formatted NDC, a truncated NDC, or an alternate identifier like UPC, HRI, GPI, DDID, RxNorm, etc. | VARCHAR   |        | Yes  |
| SupplyDaysCount       | Number of days' supply of Rx.                              | Value is passed through from source data.                                                                 | INTEGER   |        | Yes  |
| DispensedQuantity     | The quantity or package size of drug dispensed.            | Used for Relative Resource Use (RRU) cost calculation. This field must be populated in the same metric they come in, milliliter for liquid, number of pills for pills, and grams for cream. When QuantityDispensed is not supplied, the RRU cost is calculated by multiplying SupplyDaysCount by a standard cost provided by NCQA. | DOUBLE    |        | Yes  |
| BilledAmount          | Not provided                                               |                                                                                                          | NULL      |        | Yes  |
| AllowedAmount         | The amount the insurance company allows the provider to charge under contract with the provider for the service performed. | Value is passed through from source data. Not provided when provider-identifying data is provided separately. | DECIMAL   |        | Yes  |
| CopayAmount           | The amount the member is responsible to pay for the service performed. | Value is passed through from source data.                                                                | DECIMAL   |        | Yes  |
| PaidAmount            | The amount the insurance company actually paid to the provider for this claim service line. | Value is passed through from source data. Not provided when provider-identifying data is provided separately. | DECIMAL   |        | Yes  |
| CostAmount            | Not provided                                               |                                                                                                          | NULL      |        | Yes  |
| PrescribingNPI        | National Provider Identification number of the prescribing healthcare provider. | Value passed through from source data. Not provided when financial data is provided separately.           | VARCHAR   |        | Yes  |
| DispensingNPI         | National Provider Identification number of the dispensing healthcare provider, facility, clinic, or pharmacy. | Value passed through from source data. Not provided when financial data is provided separately.            | VARCHAR   |        | Yes  |
| Sourcemodifieddate    | Date the data source last modified the claim.              |                                                                                                          | DATE      |        | Yes  |
| CreatedDate           | Date when extract was created.                             |                                                                                                          | DATE      |        | No   |



## APPENDIX A – CODE TYPE VALUES

Code type values describe the attribute related to encounter claims.

| CODE TYPE | VALUE NAME                              | DESCRIPTION                                                                                                 |
|-----------|------------------------------------------|-------------------------------------------------------------------------------------------------------------|
| 1         | Ambulatory Surgery Code                  | Code value indicating the year when it is classified as Ambulatory Surgery procedure. Defined by Inovalon Insights. |
| 2         | APDRG                                    | All Patient Diagnosis Related Group (APDRG) code value. APDRG is specific to NY.                             |
| 3         | CPT Code                                 | Current Procedural Terminology Code value identifying medical services and procedures provided by healthcare providers. |
| 4         | CPT Modifier Code                        | Current Procedural Terminology Modifier Code value.                                                          |
| 5         | HCPCS Code                               | Healthcare Common Procedure Coding System code value identifying products, supplies, and services not included in the CPT codes. |
| 6         | HCPCS Modifier Code                      | Healthcare Common Procedure Coding System Modifier code value.                                               |
| 7         | ICD9CMDx Code                            | Code value of International Classification of Diseases, 9th Edition, Clinical Modification Diagnosis code.   |
| 8         | ICD9CMPx Code                            | Code value of International Classification of Diseases, 9th Edition, Clinical Modification Procedure code.   |
| 9         | MSDRG                                    | Medicare Severity Diagnosis Related Group code value. DRG is not always collected for all clients.           |
| 10        | POS Code                                 | Place of Service (POS) code value. Defined by CMS.                                                           |
| 11        | POS Group Code                           | Rolled-up Place of Service code value. Defined by Inovalon Insights.                                         |
| 12        | Provider Taxonomy Code                   | Healthcare Provider Taxonomy code value.                                                                     |
| 13        | TOB Code                                 | Three-digit alphanumeric Type of Bill (TOB) code value (leading zero ignored).                               |
| 14        | UB Occurrence Code                       | National Uniform Billing Committee (UB) Patient Occurrence code value identifying a significant event relating to the bill that may affect payer processing. |
| 15        | Provider Type Code                       | Code value identifying the type of providers based on their specialty or facility. Defined by Inovalon Insights. |
| 16        | UB Revenue Code                          | National Uniform Billing Committee (UB) Patient Occurrence code value identifying a specific accommodation, ancillary service, or billing calculation such as emergency room charges. |
| 17        | ICD10CMDx Code                           | Code value of International Classification of Diseases, 10th Edition, Clinical Modification Diagnosis code.  |
| 18        | ICD10CMPx Code                           | Code value of International Classification of Diseases, 10th Edition, Clinical Modification Procedure code.  |
| 19        | ADM ICD9CMDx Code                        | Admitting Diagnosis. Code value of International Classification of Diseases, 9th Edition, Clinical Modification Diagnosis code. |
| 20        | PRV ICD9CMDx Code                        | Patient's Reason for Visit. Code value of International Classification of Diseases, 9th Edition, Clinical Modification Diagnosis code. |
| 21        | ECI ICD9CMDx Code                        | External Cause of Injury. Code value of International Classification of Diseases, 9th Edition, Clinical Modification Diagnosis code. |
| 22        | ADM ICD10CMDx Code                       | Admitting Diagnosis. Code value of International Classification of Diseases, 10th Edition, Clinical Modification Diagnosis code. |
| 23        | PRV ICD10CMDx Code                       | Patient's Reason for Visit. Code value of International Classification of Diseases, 10th Edition, Clinical Modification Diagnosis code. |
| 24        | ECI ICD10CMDx Code                       | External Cause of Injury. Code value of International Classification of Diseases, 10th Edition, Clinical Modification Diagnosis code. |
| 25        | CVX Code                                 | CVX code is a numeric string, which identifies the type of vaccine product used and are designed to represent administered and historical immunizations and will not contain manufacturer-specific information. |



## APPENDIX B - DISCHARGE STATUS CODE VALUES

The National Uniform Billing Committee (NUBC) patient discharge status codes are industry standard codes; values identifying the discharge status of an institutional claim. Inovalon converts sensitive codes (20-21, 40-42) to ‘NULL’ in compliance with statistical de-identification rules.

| CODE | DISCHARGE STATUS CODE DESCRIPTION                                                                 |
|------|---------------------------------------------------------------------------------------------------|
| 1    | Discharged to home or self-care (routine discharge)                                                |
| 2    | Discharged/transferred to another short-term general hospital                                      |
| 3    | Discharged/transferred to Skilled Nursing Facility (SNF)                                           |
| 4    | Discharged/transferred to Intermediate Care Facility (ICF)                                         |
| 5    | Discharged/transferred to a designated cancer center or children’s hospital                        |
| 6    | Disch/trans to home under care of HHS in anticipation of cov skills care                           |
| 7    | Left against medical advice or discontinued care                                                   |
| 8    | Discharged/transferred to home under care of home IV drug therapy provider                         |
| 9    | Admitted as an inpatient to this hospital                                                          |
| 30   | Still patient or expected to return for outpatient services                                        |
| 43   | Discharged/transferred to a Federal Hospital                                                       |
| 50   | Discharged/transferred to Hospice - home                                                           |
| 51   | Discharged/transferred to Hospice - medical facility                                                |
| 61   | Discharged/transferred to hospital-based Medicare Approved Swing Bed                               |
| 62   | Disch/trans to inpat rehab fac incl distinct part units of a hospital                              |
| 63   | Discharged/transferred to long term care hospitals                                                 |
| 64   | Discharged/transferred to nursing fac cert under Medicaid but not Medicare                         |
| 65   | Disch/trans to a psychiatric hospital or psychiatric distinct part of hosp                         |
| 66   | Discharged/transferred to a Critical Access Hospital (CAH)                                         |
| 69   | Discharged/Transferred to a Designated Disaster Alternative Care Site                              |
| 70   | Discharge/transfer to another type of health care institution not defined elsewhere in the code list |
| 71   | Discharged/transferred/referred to another institution for OP services                             |
| 72   | Discharged/transferred/referred to this institution for OP services                                |
| 81   | Discharged to home or self-care with a planned acute care hospital inpatient readmission            |
| 82   | Discharged/Transferred to a Short-Term General Hospital for Inpatient Care with a Planned Acute Care Hospital Inpatient Readmission |
| 83   | Discharged/Transferred to a Skilled Nursing Facility (SNF) with Medicare Certification with a Planned Acute Care Hospital Inpatient Readmission |
| 84   | Discharged/Transferred to a Facility that Provides Custodial or Supportive Care with a Planned Acute Care Hospital Inpatient Readmission |
| 85   | Discharged/Transferred to a Designated Cancer Center or Children's Hospital with a Planned Acute Care Hospital Inpatient Readmission |
| 86   | Discharged/transferred to home under care of organized home health service organization in anticipation of covered skilled care with a planned acute care hospital inpatient readmission |
| 88   | Discharged/Transferred to a Federal Health Care Facility with a Planned Acute Care Hospital Inpatient Readmission |
| 89   | Discharged/Transferred to a Hospital-based Medicare Approved Swing Bed with a Planned Acute Care Hospital Inpatient Readmission |
| 90   | Discharged/Transferred to an Inpatient Rehabilitation Facility (IRF) including Rehabilitation Distinct Part Units of a Hospital with a Planned Acute Care Hospital Inpatient Readmission |
| 91   | Discharged/Transferred to a Medicare Certified Long Term Care Hospital (LTCH) with a Planned Acute Care Hospital Inpatient Readmission |
| 92   | Discharged/Transferred to a Nursing Facility Certified Under Medicaid but not Certified Under Medicare with a Planned Acute Care Hospital Inpatient Readmission |
| 93   | Discharged/Transferred to a Psychiatric Hospital or Psychiatric Distinct Part Unit of a Hospital with a Planned Acute Care Hospital Inpatient Readmission |
| 94   | Discharged/Transferred to a Critical Access Hospital (CAH) with a Planned Acute Care Hospital Inpatient Readmission |
| 95   | Discharged/transferred to another type of health care institution not defined elsewhere in this code list with a planned acute care hospital inpatient readmission |
| NULL | Null                                                                                               |
| X    | Null                                                                                               |



## APPENDIX C – PLACE OF SERVICE (POS) CODE VALUES

Centers for Medicare & Medicaid Services (CMS) place of service (POS) codes are industry standard codes. Codes marked with an asterisk (*) have been recoded to ‘99’ in compliance with statistical de-identification rules.

| CODE | POS NAME                                  | PLACE OF SERVICE DESCRIPTION                                                                                            |
|------|-------------------------------------------|-------------------------------------------------------------------------------------------------------------------------|
| 1    | Pharmacy                                  | A facility or location where drugs and other medically related items and services are sold, dispensed, or otherwise provided directly to patients. |
| 2    | Telehealth Provided Other than in Patient’s Home | The location where health services and health-related services are provided or received, through telecommunication technology. Patient is not located in their home when receiving health services or health-related services through telecommunication technology. |
| 3    | School                                    | A facility whose primary purpose is education.                                                                          |
| 4    | Homeless Shelter                          | A facility or location whose primary purpose is to provide temporary housing to homeless individuals (e.g., emergency shelters, individuals or family shelters). |
| 05*  | Indian Health Service Free-standing Facility | A facility or location, owned and operated by the Indian Health Service, which provides diagnostic, therapeutic (surgical and non-surgical), and rehabilitation services to American Indians and Alaska Natives who do not require hospitalization. |
| 06*  | Indian Health Service Provider-based Facility | A facility or location, owned and operated by the Indian Health Service, which provides diagnostic, therapeutic (surgical and non-surgical), and rehabilitation services rendered by, or under the supervision of, physicians to American Indians and Alaska Natives admitted as inpatients or outpatients. |
| 07*  | Tribal 638 Free-standing Facility         | A facility or location owned and operated by a federally recognized American Indian or Alaska Native tribe or tribal organization under a 638 agreement, which provides diagnostic, therapeutic (surgical and non-surgical), and rehabilitation services to tribal members who do not require hospitalization. |
| 08*  | Tribal 638 Provider-based Facility        | A facility or location owned and operated by a federally recognized American Indian or Alaska Native tribe or tribal organization under a 638 agreement, which provides diagnostic, therapeutic (surgical and non-surgical), and rehabilitation services to tribal members admitted as inpatients or outpatients. |
| 09*  | Prison/Correctional Facility              | A prison, jail, reformatory, work farm, detention center, or any other similar facility maintained by either Federal, State or local authorities for the purpose of confinement or rehabilitation of adult or juvenile criminal offenders. |
| 10   | Telehealth Provided in Patient’s Home     | The location where health services and health-related services are provided or received, through telecommunication technology. Patient is located in their home (which is a location other than a hospital or other facility where the patient receives care in a private residence) when receiving health services or health-related services through telecommunication technology. |
| 11   | Office                                    | Location other than a hospital, skilled nursing facility (SNF), military treatment facility, community health center, State or local public health clinic, or intermediate care facility (ICF), where the health professional routinely provides health examinations, diagnosis, and treatment of illness or injury on an ambulatory basis. |
| 12   | Home                                      | Location, other than a hospital or other facility, where the patient receives care in a private residence.               |
| 13   | Assisted Living Facility                  | Congregate residential facility with self-contained living units providing assessment of each resident's needs and on-site support 24 hours a day, 7 days a week, with the capacity to deliver or arrange for services including some health care and other services. |
| 14   | Group Home                                | A residence, with shared living areas, where clients receive supervision and other services such as social and/or behavioral services, custodial service, and minimal services (e.g., medication administration). |
| 15   | Mobile Unit                               | A facility/unit that moves from place-to-place equipped to provide preventive, screening, diagnostic, and/or treatment services. |
| 16   | Temporary Lodging                         | A short-term accommodation such as a hotel, campground, hostel, cruise ship or resort where the patient receive care, and which is not identified by any other POS code. |
| 17   | Walk-in Retail Health Clinic              | A walk-in health clinic, other than an office, urgent care facility, pharmacy or independent clinic and not described by any other POS code, that is located within a retail operation and provides, on an ambulatory basis, preventive, and primary care services. |
| 18   | Place of Employment-Worksite             | A location, not described by any other POS code, owned, or operated by a public or private entity where the patient is employed, and where a health professional provides on-going or episodic occupational medical, therapeutic or rehabilitative services to the individual. |
| 19   | Off Campus-Outpatient Hospital           | A portion of an off-campus hospital provider-based department which provides diagnostic, therapeutic (both surgical and nonsurgical), and rehabilitation services to sick or injured persons who do not require hospitalization or institutionalization. |
| 20   | Urgent Care Facility                      | Location, distinct from a hospital emergency room, an office, or a clinic, whose purpose is to diagnose and treat illness or injury for unscheduled, ambulatory patients seeking immediate medical attention. |
| 21   | Inpatient Hospital                        | A facility, other than psychiatric, which primarily provides diagnostic, therapeutic (both surgical and non-surgical), and rehabilitation services by, or under, the supervision of physicians to patients admitted for a variety of medical conditions. |
| 22   | On Campus-Outpatient Hospital            | A portion of a hospital’s main campus which provides diagnostic, therapeutic (both surgical and nonsurgical), and rehabilitation services to sick or injured persons who do not require hospitalization or institutionalization. |
| 23   | Emergency Room - Hospital                 | A portion of a hospital where emergency diagnosis and treatment of illness or injury is provided.                        |
| 24   | Ambulatory Surgical Center                | A freestanding facility, other than a physician's office, where surgical and diagnostic services are provided on an ambulatory basis. |
| 25   | Birthing Center                           | A facility, other than a hospital's maternity facilities or a physician's office, which provides a setting for labor, delivery, and immediate post-partum care as well as immediate care of newborn infants. |
| 26*  | Military Treatment Center                 | A medical facility operated by one or more of the Uniformed Services. Military Treatment Facility (MTF) also refers to certain former U.S. Public Health Service (USPHS) facilities now designated as Uniformed Service Treatment Facilities (USTF). |
| 27-30| Unassigned                                | N/A                                                                                                                     |
| 31   | Skilled Nursing Facility                  | A facility which primarily provides inpatient skilled nursing care and related services to patients who require medical, nursing, or rehabilitative services but does not provide the level or care or treatment available in a hospital. |
| 32   | Nursing Facility                          | A facility which primarily provides to residents skilled nursing care and related services for the rehabilitation of injured, disabled, or sick persons, or, on a regular basis, health-related care services above the level of custodial care to other than individuals with intellectual disabilities. |
| 33   | Custodial Care Facility                   | A facility which provides room, board and other personal assistance services, generally on a long-term basis, and which does not include a medical component. |
| 34   | Hospice                                   | A facility, other than a patient's home, in which palliative and supportive care for terminally ill patients and their families are provided. |
| 35-40| Unassigned                                | N/A                                                                                                                     |
| 41   | Ambulance - Land                          | A land vehicle specifically designed, equipped, and staffed for lifesaving and transporting the sick or injured.         |
| 42   | Ambulance - Air or Water                  | An air or water vehicle specifically designed, equipped, and staffed for lifesaving and transporting the sick or injured. |
| 43-48| Unassigned                                | N/A                                                                                                                     |
| 49   | Independent Clinic                        | A location, not part of a hospital and not described by any other POS code, that is organized and operated to provide preventive, diagnostic, therapeutic, rehabilitative, or palliative services to outpatients only. |
| 50   | Federally Qualified Health Center         | A facility located in a medically underserved area that provides Medicare beneficiaries preventive primary medical care under the general direction of a physician. |
| 51   | Inpatient Psychiatric Facility            | A facility that provides inpatient psychiatric services for the diagnosis and treatment of mental illness on a 24-hour basis, by or under the supervision of a physician. |
| 52   | Psychiatric Facility - Partial Hospitalization | A facility for the diagnosis and treatment of mental illness that provides a planned therapeutic program for patients who do not require full time hospitalization, but who need broader programs than are possible from outpatient visits to a hospital-based or hospital-affiliated facility. |
| 53   | Community Mental Health Center            | A facility that provides the following services: outpatient services, including specialized outpatient services for children, the elderly, individuals who are chronically ill, and residents of the CMHC's mental health services area who have been discharged from inpatient treatment at a mental health facility; 24 hour a day emergency care services; day treatment, other partial hospitalization services, or psychosocial rehabilitation services; screening for patients being considered for admission to State mental health facilities to determine that appropriateness of such admission; and consultation and education services. |
| 54   | Intermediate Care Facility/Individuals with Intellectual Disabilities | A facility which primarily provides health-related care and services above the level of custodial care to individuals but does not provide the level of care or treatment available in a hospital or SNF. |
| 55   | Residential Substance Abuse Treatment Facility | A facility which provides treatment for substance (alcohol and drug) abuse to live-in residents who do not require acute medical care. Services include individual and group therapy and counseling, family counseling, laboratory tests, drugs and supplies, psychological testing, and room and board. |
| 56   | Psychiatric Residential Treatment Center  | A facility or distinct part of a facility for psychiatric care which provides a total 24-hour therapeutically planned and professionally staffed group living and learning environment. |
| 57   | Non-residential Substance Abuse Treatment Facility | A location which provides treatment for substance (alcohol and drug) abuse on an ambulatory basis. Services include individual and group therapy and counseling, family counseling, laboratory tests, drugs and supplies, and psychological testing. |
| 58   | Non-residential Opioid Treatment Facility | A location that provides treatment for opioid use disorder on an ambulatory basis. Services include methadone and other forms of Medication Assisted Treatment (MAT). |
| 59   | Unassigned                                | N/A                                                                                                                     |
| 60   | Mass Immunization Center                  | A location where providers administer pneumococcal pneumonia and influenza virus vaccinations and submit these services as electronic media claims, paper claims, or using the roster billing method. This generally takes place in a mass immunization setting, such as, a public health center, pharmacy, or mall but may include a physician office setting. |
| 61   | Comprehensive Inpatient Rehabilitation Facility | A facility that provides comprehensive rehabilitation services under the supervision of a physician to inpatients with physical disabilities. Services include physical therapy, occupational therapy, speech pathology, social or psychological services, and orthotics and prosthetics services. |
| 62   | Comprehensive Outpatient Rehabilitation Facility | A facility that provides comprehensive rehabilitation services under the supervision of a physician to outpatients with physical disabilities. Services include physical therapy, occupational therapy, and speech pathology services. |
| 63-64| Unassigned                                | N/A                                                                                                                     |
| 65   | End-Stage Renal Disease Treatment Facility | A facility other than a hospital, which provides dialysis treatment, maintenance, and/or training to patients or caregivers on an ambulatory or home-care basis. |
| 66-70| Unassigned                                | N/A                                                                                                                     |
| 71   | Public Health Clinic                      | A facility maintained by either State or local health departments that provides ambulatory primary medical care under the general direction of a physician. |
| 72   | Rural Health Clinic                       | A certified facility which is located in a rural medically underserved area that provides ambulatory primary medical care under the general direction of a physician. |
| 73-80| Unassigned                                | N/A                                                                                                                     |
| 81   | Independent Laboratory                    | A laboratory certified to perform diagnostic and/or clinical tests independent of an institution or a physician's office. |
| 82-98| Unassigned                                | N/A                                                                                                                     |
| 99   | Other Place of Service                    | Other place of service not identified above.                                                                             |
| *    | Other Values converted to 99 according to current statistical de-identification rules. |

<END>

Write a Transact-SQL (for MS SQL Server) query for the database described above that does the following:

calculates the average allowed amount for hip replacement surgeries in members who have had at least 2 diagnoses of diabetic retinopathy.  

Use the description of the database tables, as well as your knowledge of ICD and CPT codes.  The ICD codes in this data do not include punctuation, so if you use ICD codes in your query, don't include period '.' symbols.  The ICD codes in this database are all billable codes, so if you use non-billable non-specific ICD codes, then any equality comparisons that include such codes in the query should use LIKE operator with `%` wildcard matches at the end of the ICD code.  Otherwise, specific billable codes can be used with the '=' equality operator, but remove the dot from the strings for these ICD codes.

Make sure that NULL values are removed from any aggregate operation.

Make sure to alias all table names to make the query easy to read.

Implement this workflow in a way that never joins more than two tables at a time.  The intermediate artifacts should be stored as temporary tables in TempDB (table names prefixed with '#' character).  Create clustered columnstore indexes on each of these intermediate tables to make subsequent join operations fast.

Include a comment with each step in the workflow describing what the code does.

If you don't know how to do this task, then say so.  Don't make things up.