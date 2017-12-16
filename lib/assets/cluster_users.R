library("data.table")
library("reshape2")
library("RSQLite")
library("RWeka")
library("rJava")

setwd("~/filmo/db")
sqlite <- dbDriver("SQLite")
con <- dbConnect(sqlite,"development.sqlite3")
ratings <- dbGetQuery(con,'select * from ratings')
ratings2 <- dcast(ratings, film_id~user_id, value.var = "rating_value", na.rm=FALSE)

for (i in 1:ncol(ratings2)){
    ratings2[which(is.na(ratings2[,i]) == TRUE),i] <- 0
}

ratings2 <- ratings2[,-1]
correlation<-cor(ratings2)
userClusters <- kmeans(correlation, 30)
ratings2<-transpose(ratings2)
cluster_users<-list(userClusters$cluster)
cluster_users<-data.frame(cluster_users)
colnames(cluster_users) <- c("clusterId")
t<-lapply(cluster_users, as.factor)
ratings2<-cbind(t, ratings2)
cluster_users<-cluster_users[,1]

j48.model <- J48(clusterId~., data = ratings2)

.jcache(j48.model$classifier)
save(j48.model, file="j48.model.rda")