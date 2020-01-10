rm(list=ls())

# Libraries
if(!require("ggplot2")) install.packages("ggplot2")
if(!require("caret")) install.packages("caret")
if(!require("dslabs")) install.packages("dslabs")
if(!require("dplyr")) install.packages("dplyr")
if(!require("skimr")) install.packages("skimr")
if(!require("klaR")) install.packages("klaR")


# Read the data (classifying wines into 3 different cultivars)
d <- read.table('wine.data', encoding="UTF-16", dec=".", sep=",", header=FALSE)
d

# Add column names
colnames(d) <- c("Cultivar", "Alcohol", "Malic_acid", "Ash", "Alcalinity", "Magnesium", "Total_phenols", "Flavanoids", "Nonflavanoid_phenols", "Proanthocyanins", "Color_intensity", "Hue", "OD280", "Proline")

d$Cultivar <- as.factor(d$Cultivar)
summary <- summary(d)


# Split into train and test datasets
set.seed(1)
test_index <- createDataPartition(d$Cultivar, times=1, p=0.3, list=FALSE)
train_set <- d[-test_index,]
test_set <- d[test_index,]

x <- train_set[, 2:14]
y <- train_set$Cultivar
x_test <- test_set[, 2:14]
y_test <- test_set$Cultivar

train_set %>% group_by(Cultivar) %>% count()
test_set %>% group_by(Cultivar) %>% count()


# Basic statistics for each feature
skimmed <- skim_to_wide(train_set)
skimmed[2:14, c(1:5, 9:16)]


# Normalize the data into range [0,1]
preProcess_range_model <- preProcess(train_set, method='range')
train_set <- predict(preProcess_range_model, newdata = train_set)
train_set$Cultivar <- y
apply(train_set[, 2:14], 2, FUN=function(x){c('min'=min(x), 'max'=max(x))})

test_set <- predict(preProcess_range_model, newdata = test_set)
test_set$Cultivar <- y_test
apply(test_set[, 2:14], 2, FUN=function(x){c('min'=min(x), 'max'=max(x))})


# Visualize correlations
featurePlot(x = train_set[, 2:14], 
            y = train_set$Cultivar, 
            plot = "box",
            strip=strip.custom(par.strip.text=list(cex=.7)),
            scales = list(x = list(relation="free"), 
                          y = list(relation="free")))

featurePlot(x = train_set[, 2:14], 
            y = train_set$Cultivar, 
            plot = "density",
            strip=strip.custom(par.strip.text=list(cex=.7)),
            scales = list(x = list(relation="free"), 
                          y = list(relation="free")))

featurePlot(x = train_set[, 2:14], 
            y = train_set$Cultivar,
            plot="pairs")


### Build classification models

# KNN (k nearest neighbors) algorithm
set.seed(10)
train_knn <- train(Cultivar~., method="knn", data=train_set, tuneGrid=data.frame(k=seq(3,59,2)))
ggplot(train_knn, highlight=TRUE) +
  theme_bw()
train_knn$bestTune
train_knn$finalModel
y_hat <- predict(train_knn, test_set, type="raw")
confusionMatrix(data = y_hat, reference = test_set$Cultivar)

imp_knn <- varImp(train_knn)

train_set %>% 
  ggplot() +
  geom_point(aes(OD280, Flavanoids, col=Cultivar)) +
  theme_bw()

train_set %>% 
  mutate(y_hat = predict(train_knn)) %>% 
  ggplot() +
  geom_point(aes(Alcohol, Cultivar)) +
  geom_step(aes(Alcohol, y_hat), col = 3) +
  theme_bw()

test_set %>%
  mutate(y_hat=predict(train_knn, test_set)) %>%
  ggplot() + 
  geom_point(aes(OD280, Flavanoids, col=y_hat, shape=Cultivar), size=3) +
  theme_bw()

featurePlot(x=train_set[c("OD280","Flavanoids")], y=train_set$Cultivar, plot="pairs")
featurePlot(x=test_set[c("OD280","Flavanoids")], y=test_set$Cultivar, plot="pairs")


# Sample decision tree
set.seed(10)
train_rp <- train(Cultivar~., method="rpart", data=train_set, tuneGrid=data.frame(cp=seq(0,0.1,0.01)))
confusionMatrix(train_rp)
plot(train_rp$finalModel, margin=0.1)
text(train_rp$finalModel, cex=0.6)


# Random Forest algorithm
set.seed(10)
train_rf <- train(Cultivar~., data=train_set, method="rf", tuneGrid=data.frame(mtry=seq(1,13)))
ggplot(train_rf, highlight=T) +
  theme_bw()
train_rf$bestTune
train_rf$finalModel
y_hat <- predict(train_rf, test_set)
confusionMatrix(y_hat, test_set$Cultivar)
imp <- varImp(train_rf)


# QDA - quadratic discriminant analysis
# assumption: conditional probabilities have multivariate normal distribution
set.seed(10)
train_qda <- train(Cultivar~., data=train_set, method="qda")
y_hat <- predict(train_qda, test_set)
confusionMatrix(y_hat, test_set$Cultivar)

imp <- varImp(train_qda)

partimat(train_set[c("OD280","Flavanoids")], train_set$Cultivar, method="qda", plot.matrix = FALSE, imageplot = TRUE, image.colors=c("lightgreen", "lightblue", "lightgrey"))

featurePlot(x = train_set[c("OD280","Flavanoids")], 
            y = train_set$Cultivar,
            plot="pairs",
            type=c("p","smooth"))


# LDA - linear discriminant analysis
set.seed(10)
train_lda <- train(Cultivar~., data=train_set, method="lda")
y_hat <- predict(train_lda, test_set)
confusionMatrix(y_hat, test_set$Cultivar)

imp <- varImp(train_lda)
partimat(train_set[c("OD280","Flavanoids")], train_set$Cultivar, method="lda", plot.matrix = FALSE, imageplot = TRUE, image.colors=c("lightgreen", "lightblue", "lightgrey"))


# Comparison of all algorithms
models_compare <- resamples(list(RF=train_rf, KNN=train_knn, QDA=train_qda, LDA=train_lda))
summary(models_compare)
scales <- list(x=list(relation="free"), y=list(relation="free"))
bwplot(models_compare, scales=scales)
