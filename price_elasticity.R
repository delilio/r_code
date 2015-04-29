####Load Packages#####
require(reshape)
require(reshape2)
require(data.table)
require(sqldf)
require(plyr)
require(data.table)
require(RMySQL)

###############Connection Parameters###########
Dela = dbConnect(MySQL(), user = 'xdxa052', password = 'iamthebest',
                 dbname= 'Dela', host = 'analytics-prod-rds.c7bb8aqta34p.us-east-1.rds.amazonaws.com', port=3306,client.flag=CLIENT_MULTI_STATEMENTS)
on.exit(dbDisconnect(Dela))

######################################Obtaining promo input dataset######################################
promo_date_pull <- dbSendQuery(Dela, "select * 
                                  from promo_date_sales;")

promo_date_data <- fetch(promo_date_pull, n=-1)

######################################Obtaining comp input dataset######################################
comp_date_pull <- dbSendQuery(Dela, "select * 
                                  from comp_date_sales;")

comp_date_data <- fetch(comp_date_pull, n=-1)


##################Merging promo and comp to get super_set###############
batch15data <- merge(promo_date_data,comp_date_data, by = c("zoroNo","offer_group"))

########Calculate change in quantity from comp to promo######
batch15data$quantity_change <- (batch15data$avg_promo_qty - batch15data$avg_comp_qty)/batch15data$avg_comp_qty



########Plot Results#######
attach(batch15data)
plot(quantity_change, offer_group, main = "Scatterplot for promo groupings",
     xlab="Quantity Change (%)", ylab="Promo Offer Group", pch=19 )


