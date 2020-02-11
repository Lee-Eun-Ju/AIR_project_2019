library(dplyr)
library(ggplot2)

data <- read.csv("C://Users//������//Desktop//AIR ���Ƹ�//#Sillicon Valley//Chess game//games.csv", header=TRUE)
glimpse(data)
summary(data)

#TRUE�� True / False�� FALSE
data$rated <- as.character(data$rated)
Ti = which(data$rated=="True")
Fi = which(data$rated=="False")
data[Ti,2] <- "TRUE" 
data[Fi,2] <- "FALSE"
#���� index�� ����(data[Ti,rated]�� error)
data$rated <- as.factor(data$rated)
summary(data)

#�ߺ� id(���� ������) ����
data <- unique(data)
summary(data)
#-> ���ŵ��� ���� ������ : created_at/last_move_at �� ����
filter(data,id=='079kHDqh')
filter(data,id=='07e0uVvn')
#-> ������ ��ġ�� ���ٰ� �����Ǿ� ���� ����
data <- data[,-c(3,4)]
data <- unique(data)
summary(data)
data$id <- as.character(data$id)

#winner=1, loser=0�� ���� ������ ������ �����
glimpse(data)
data$winner <- as.character(data$winner)
data <- data[-which(data$winner=="draw"),] #�º�X�� ������ ����
data$winner <- as.factor(data$winner)
summary(data)

data$victory_status <- as.character(data$victory_status)
data$victory_status <- as.factor(data$victory_status)

#moves->white�� black ���� / ��� �����ӿ� ���� ���� �м��� �ǹ̰� ����.
movector = as.character(data$moves)
movector = strsplit(movector," ")
head(movector)

white_first_moving = vector()
black_first_moving = vector()
for (i in 1:length(movector)){
  white_first_moving[i] = movector[[i]][1] 
  black_first_moving[i] = movector[[i]][2]
}

head(white_first_moving)
head(black_first_moving)

#���ο� ������������
summary(data)
rating_difference = vector()
first_moving = vector()

for (k in 1:length(data$winner)){
  if(data$winner=="white"){
    rating_difference[k] = data[k,8] - data[k,10]
    first_moving[k] = white_first_moving[k] 
  }
  else{
    rating_difference[k] = data[k,10] - data[k,8]
    first_moving[k] = black_first_moving[k] 
  }
}

data0 <- data[,-c(1,7,8,9,10,11)]
data0 <- cbind(data0,rating_difference,first_moving)
summary(data0)
glimpse(data0)

###EDA 
pairs(data0)

#turns
ggplot(data0,aes(winner,turns)) + geom_boxplot()
data0 <- data0[-which(data0$turns==349),] #�̻�ġ ����
summary(data0)

#rating_difference
ggplot(data0,aes(rating_difference)) + geom_freqpoly() #���->���п� �������

#victory_status
ggplot(data0,aes(x=victory_status,fill=winner)) + geom_bar(stat = 'count')

#opening_eco
distinct(data$opening_eco)
ggplot(data0,aes(x=opening_eco,fill=winner)) + geom_bar(stat = 'count', position = 'fill')

#opening_name
summary(data0$opening_name)
ggplot(data0,aes(opening_name)) + geom_bar()

#opening_ply
ggplot(data0,aes(opening_ply)) + geom_freqpoly()
#6~7�̵����� ���� �����׿��� ��� ������ ������ ��������.
#but �̰��� �����,�й��� ������ ���̹Ƿ� ��¿� ������ �ش� �� �� ��..?

#first_moving
ggplot(filter(data0,winner=="white"),aes(first_moving)) + geom_bar()
#ù��° �������� e4�� �� �¸�Ȯ�� ����..

ggplot(filter(data0,winner=="black"),aes(first_moving)) + geom_bar()
#ù��° �������� e4�� �� �¸�Ȯ�� ����..
summary(data$moves)