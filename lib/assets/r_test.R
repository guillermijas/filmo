library(data.table)
library(reshape2)
library(RSQLite)

setwd("~/filmo/db")
sqlite <- dbDriver("SQLite")
con <- dbConnect(sqlite,"development.sqlite3")

ratings = dbGetQuery(con,'select * from ratings')
ratings2 <- dcast(ratings, film_id~user_id, value.var = "rating_value", na.rm=FALSE)

for (i in 1:ncol(ratings2)){
  ratings2[which(is.na(ratings2[,i]) == TRUE),i] <- 0
}

ratings2 = ratings2[,-1]
#head(ratings2, 670)
correlation<-cor(ratings2)
correlation <- abs(correlation)

x<-correlation[user_id,]
newdata <- head(sort(x, decreasing=TRUE), 11)
newdata <- newdata[-1]
newdata <- as.data.frame(newdata)


#Buscar peliculas que tienen los correlacionados y no el target
films <- ratings2
for (i in 1:ncol(films)){
  films[which(films[,i] != 0),i] <- 1
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
result
rec_ids = result[1,]