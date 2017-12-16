library("data.table")
library("reshape2")
library("RSQLite")
library("RWeka")

setwd("~/filmo/db")
sqlite <- dbDriver("SQLite")
con <- dbConnect(sqlite,"development.sqlite3")
ratings <- dbGetQuery(con,'select * from ratings')
ratings2 <- dcast(ratings, film_id~user_id, value.var = "rating_value", na.rm=FALSE)


sqlcmd <- paste("select user_id from clusters where cluster = ", cluster, sep="")
cluster_users <- dbGetQuery(con, sqlcmd)

for (i in 1:ncol(ratings2)){
    ratings2[which(is.na(ratings2[,i]) == TRUE),i] <- 0
}

filmID <- ratings2[,1]
ratings2 <- ratings2[,-1]

cluster_users<-cluster_users[-which(cluster_users == userId)] #si el usaurio objetivo se repite ne la lista anterior, ejecutar esto
newdata <- as.data.frame(cluster_users)


films <- ratings2
for (i in 1:ncol(films)){
    films[which(films[,i] != 0),i] <- 1

    if (films[userId,i] == 1)
    {
        films[,i] <- 0
    }
}
#films <- as.matrix(sapply(films, as.numeric))
#films <- t(films)
#films <- as.data.frame(films)

newdata3 <- matrix(0,10,9067) #empty matrix
for (i in 1:10){
    newdata3[i,1]<-rownames(newdata)[i]
    for (j in 1:9066){
        if (films[j,rownames(newdata)[i]] == 1){
            newdata3[i,1+j] <- ratings2[j,rownames(newdata)[i]]
        }
    }
}

result <- matrix(0,10,5) #empty matrix
for (i in 1:10){
    newdata2 <- head(order(newdata3[i,][-1], decreasing=TRUE), 6)
    newdata2 <- newdata2[-1]
    result[i,] <- newdata2
}

for (i in 1:10){
    for (j in 1:5){
        result[i,j] <- filmID[result[i,j]]
    }
}
cluster
result
result <- unique(c(result[1:3,1], result[1:3,2], result[1:3,3], result[1:3,4]))