set.seed(8675309)
require("lda")
require("medSTC")
## Use the newsgroup data set.
data(newsgroup.train.documents)
data(newsgroup.train.labels)
data(newsgroup.vocab)
data(newsgroup.test.documents)
data(newsgroup.test.labels)

num.topics <- 10

## Cusomize labels
for (n in 1:length(newsgroup.train.labels)) {
  if (newsgroup.train.labels[n] == 1) {
    newsgroup.train.labels[n] = 1
  } else {
    newsgroup.train.labels[n] = -1
  }
}

for (n in 1:length(newsgroup.test.labels)) {
  if (newsgroup.test.labels[n] == 1) {
    newsgroup.test.labels[n] = 1
  } else {
    newsgroup.test.labels[n] = -1
  }
}

## Shift word index in document by 1 
## because the word index start from 0 (which should be 1)
for (n in 1:1633) {
  for (i in 1:ncol(newsgroup.train.documents[[n]])) {
      newsgroup.train.documents[[n]][1,i] <- as.integer(newsgroup.train.documents[[n]][1,i] + 1) 
  }
} 

for (n in 1:1098) {
  for (i in 1:ncol(newsgroup.test.documents[[n]])) {
      newsgroup.test.documents[[n]][1,i] <- as.integer(newsgroup.test.documents[[n]][1,i] + 1) 
  }
} 

## Initialize the params
params <- sample(c(-1, 1), num.topics, replace=TRUE)

## Train the model
result <- slda.em(documents=newsgroup.train.documents,
                  K=num.topics,
                  vocab=newsgroup.vocab,
                  num.e.iterations=50,
                  num.m.iterations=20,
                  alpha=1.0, eta=0.1,
                  newsgroup.train.labels,
                  params,
                  variance=0.25,
                  lambda=1.0,
                  logistic=FALSE,
                  method="sLDA")

## Plot top 10 words in each topic
require("ggplot2")
Topics <- apply(top.topic.words(result$topics, 10, by.score=TRUE),
                2, paste, collapse=" ")
coefs <- data.frame(coef(summary(result$model)))
theme_set(theme_bw())
coefs <- cbind(coefs, Topics=factor(Topics, Topics[order(coefs$Estimate)]))
coefs <- coefs[order(coefs$Estimate),]
qplot(Topics, Estimate, colour=Estimate, size=abs(t.value), data=coefs) +
  geom_errorbar(width=0.5, aes(ymin=Estimate-Std..Error,
                               ymax=Estimate+Std..Error)) + coord_flip()

## Predict test data
predictions <- slda.predict(newsgroup.test.documents,
                            result$topics, 
                            result$model,
                            alpha = 1.0,
                            eta=0.1)

## Plot the distribution of test data labels and results
qplot(predictions,
      fill=factor(newsgroup.test.labels),
      xlab = "predicted labels",
      ylab = "density",
      alpha=I(0.5),
      geom="density") +
  geom_vline(aes(xintercept=0)) +
  theme(legend.position = "none")

## Build the relationship between each document and topics
predicted.docsums <- slda.predict.docsums(newsgroup.test.documents,
                                          result$topics, 
                                          alpha = 1.0,
                                          eta=0.1)
predicted.proportions <- t(predicted.docsums) / colSums(predicted.docsums)


## Plot the relationship between documents and topic 1, topic 5, and topic 6
qplot(`Topic 1`, `Topic 6`, 
      data = structure(data.frame(predicted.proportions), 
                       names = paste("Topic", 1:10)), 
      size = `Topic 5`)
