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
temp<-cor(ratings2)
x<-temp[user_id,]   #viene de ruby
sort(x, decreasing = TRUE)
newdata <- head(sort(x, decreasing=TRUE), 11)
newdata <- newdata[-1]
newdata







