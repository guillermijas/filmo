library(data.table)
library(reshape2)
library(stringr)
library("RWeka")
library("rJava")
library("RSQLite")

setwd("~/filmo/db")

load("j48.model.rda")

sqlite <- dbDriver("SQLite")
con <- dbConnect(sqlite,"development.sqlite3")
ratings <- dbGetQuery(con,'select * from ratings')
ratings2 <- dcast(ratings, film_id~user_id, value.var = "rating_value", na.rm=FALSE)
for (i in 1:ncol(ratings2)){
    ratings2[which(is.na(ratings2[,i]) == TRUE),i] <- 0
}

ratings2 <- ratings2[,-1]

list_userId <- transpose(data.frame(ratings2[,1])) #Lista de ratings de userId
cluster_id <- as.numeric(predict(j48.model, newdata = list_userId))
