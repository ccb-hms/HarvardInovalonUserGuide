# the devtools package contains functionality required to install packages from GitHub
install.packages('devtools')

# this package allows R to make calls through unixODBC
install.packages('odbc')

# this package makes establishing a database connection easy by generating connection strings
devtools::install_git('https://github.com/nathan-palmer/MsSqlTools.git', ref='v1.1.0')

# this package provides a performant pivot function to reshape a fact table to a 
# design matrix
devtools::install_github('https://github.com/nathan-palmer/FactToCube.git', ref='v1.0.0')

# this package contains several convenience functions
devtools::install_github('https://github.com/nathan-palmer/SqlTools.git', ref='v1.0.0')