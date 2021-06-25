# Classification of grape cultivars in wine based on chemical characteristics - classification algorithms

## Introduction

The aim of this project is to classify the grape cultivar from which the wine is made on the basis of its chemical characteristics. The chemical characteristics take into account, for instance, color and shade of the wine, alcohol content, alkalinity, magnesium, flavonoid content, etc. Several classification algorithms were applied and the results were compared.

For the analysis, the R program was used, including mainly the **caret** package dedicated to machine learning. In the paper selected classification algorithms were characterized and various functionalities of the **caret** package were presented to facilitate working with data and creating classification models.

The database comes from the UCI Machine Learning Repository, and the original source is: Forina, M. et al, PARVUS - An Extendible Package for Data Exploration, Classification and Correlation. Institute of Pharmaceutical and Food Analysis and Technologies, Via Brigata Salerno, 16147 Genoa, Italy. The data was obtained by chemical analysis of wines from the same region of Italy. It is a balanced database, where each cultivar represents about 1/3 of all observations. The dataset consists of the category variable Cultivar and 13 continuous variables describing the chemical characteristics of the wine. The collection contains 178 observations, i.e. 178 different wines.

The names of all variables contained in the dataset:

* Cultivar - cultivar of the grape from which the wine was produced;
* Alcohol - the amount of alcohol in %;
* Malic acid - malic acid content (one of the main organic acids present in the wine);
* Ash - ash content (inorganic matter remaining after evaporation and burning);
* Alcalinity - alcalinity of ash;
* Magnesium - magnesium content;
* Total phenols - total content of phenols (chemicals influencing taste, color and wine texture);
* Flavonoids - flavonoids content (type of phenols);
* Nonflavanoid phenols - content of phenols other than flavonoids;
* Proanthocyanins - proanthocyanins content (type of phenols);
* Color intensity - intensity of wine color;
* Hue - the shade of wine;
* OD280 - OD280/OD315 of diluted wines (measurements of protein content);
* Proline - content of proline (amino acid present in wines).

<img src="https://github.com/ASledziewska/WineTypes_classification/blob/master/images/Table1.jpg" alt="Table 1" width="700"/>

First of all, the dataset was examined and it was split into training and test set. Then, all numeric variables were normalized to fit in the range from 0 to 1 for the purpose of future use of algorithms taking into account distance metrics, and basic visualizations were created to better understand the data and correlations between variables. Finally, the classification models were built using sample classification algorithms, such as KNN, LDA, QDA and Random Forest. The results were assessed based on accuracy calculated on the test set.


## Methods

Firstly, basic descriptive statistics (mean, standard deviation, median) were calculated for continuous variables in the dataset:

<img src="https://github.com/ASledziewska/WineTypes_classification/blob/master/images/Table2.jpg" alt="Table 2" width="500"/>

The variables take values from very different ranges (from less than 1 to more than 1000). The alcohol content of wine ranges from about 11% to less than 15%. The lowest values are taken by the variable Nonflavanoid Phenols and the highest by Proline. Categorical variable Cultivar consists of 3 categories, with 59 observations belonging to the first category, 71 to the second category, 48 to the third category.

Then, after the initial data exploration, the set was divided into a train and test set. The division was made in a random way in the proportion 70:30, i.e. the train set contains 123 observations and the test set - 55 observations. The **createDataPartition** function from the **caret** package was used to divide the set.

The dataset does not contain null values, i.e. no imputation of missing data needs to be performed, and it does not require transformations to dummy variables (no explanatory categorical variables). However, due to the fact that the variables take values from significantly different ranges, it was necessary to normalize the variables. For this purpose, the **preProcess** function (from the **caret** package) and the **range** method were used, which brings all variables to the range [0,1]. This method is called min-max normalization. The highest value for each variable takes the value of 1 and the lowest one - 0, the rest of the values is scaled to this interval. Normalization begins with the train set, and then, in the same way, using rules known from the train set, the test set is scaled.

<img src="https://github.com/ASledziewska/WineTypes_classification/blob/master/images/Table3.jpg" alt="Table 3" width="700"/>

Afterwards, the next step was a visual representation of the relationships between the Cultivar variable and explanatory variables. This visualization allows for a preliminary assessment of which variables may be most important when deciding on the classification of the wine in a given cultivar. The best variables are those that show significantly different values for different grape cultivars. The **featurePlot** function was used for the visualization, which makes it easy to draw a graph coming from the **lattice** library. Plots were created, such as: boxplot, density plot and scatterplot for variables selected in pairs. Below the most transparent boxplot for all variables is presented.

<img src="https://github.com/ASledziewska/WineTypes_classification/blob/master/images/Image1.jpg" alt="Image 1" width="800"/>

For example, the variable Hue seems promising in terms of distinguishing cultivars 1 and 2 from cultivar 3, while the variable Proline probably effectively distinguishes cultivars 2 and 3 from cultivar 1. The variable Color intensity, on the other hand, takes the lowest values for cultivar 2, which distinguishes it from cultivars 1 and 3. The least promising variable from this set seems to be the variable Ash, as its values are very similar for each cultivar.

Finally, 4 different classification models were built using:

* K-Nearest Neighbors algorithm
* Random Forest algorithm
* Analysis (LDA) algorithm
* Quadratic Discriminant Analysis (QDA) algorithm


The **train** function from the **caret** package was used to build the models. This package combines over 200 different algorithms that are scattered across different libraries. **Caret** aims to consolidate all these libraries. The **train** function allows you to train different algorithms using very similar syntax. This function also performs automatic cross validation for different parameters. By default, cross validation is performed by testing on 25 bootstrap samples consisting of 25% randomly selected (sampling with replacement) observations from a given train set. Parameters (depending on the algorithm used) can be changed with **tuneGrid** option in the **train** function.


## Results

#### K-Nearest Neighbors algorithm

The k-nearest neighbors algorithm is a non-parametric method used for classification and regression. This method determines the k nearest neighbors to which the examined observation is closest (usually Euclidean distance is used). A larger number of neighbors leads to smoothing out the division areas, but may lead to larger classification errors. On the other hand, the choice of a very small k-value leads to overfitting.

<img src="https://github.com/ASledziewska/WineTypes_classification/blob/master/images/Image2.jpg" alt="Image 2" width="800"/>

In the given iteration the number of neighbors k=27 gave the best results in terms of accuracy of matching the model to the data. The k values from the range [3; 59] were considered. The maximum accuracy was equal 96.36%, i.e. the algorithm correctly identifies the class of a given object in over 96% cases.

<img src="https://github.com/ASledziewska/WineTypes_classification/blob/master/images/Table4.jpg" alt="Table 4" width="300"/>

The table shows the sensitivity measures, i.e. the ability of the model to correctly classify observations belonging to a given class, and the specificity measures, i.e. the ability of the model to correctly classify observations not belonging to a given class. The model classifies observations belonging to class 1 and 3 100% correctly, while it rejects observations not belonging to class 2 100% correctly.

<img src="https://github.com/ASledziewska/WineTypes_classification/blob/master/images/Table5.jpg" alt="Table 5" width="200"/>

The above measures of accuracy, sensitivity and specificity are based on the contingency table. The table shows that 2 observations were classified incorrectly (both belonging to class 2).

<img src="https://github.com/ASledziewska/WineTypes_classification/blob/master/images/Table6.jpg" alt="Table 6" width="600"/>

The above table shows a ranking of the variables that best differentiate the grape cultivars in wine, i.e. they are most important for the operation of the algorithm. The three most important variables are: Flavonoids, OD280 and Hue. The weakest variable is the ash content of the wine.

<img src="https://github.com/ASledziewska/WineTypes_classification/blob/master/images/Image3.jpg" alt="Image 3" width="800"/>

The above figure shows how the class assignment looks in such an algorithm. The graph was created for only two most important variables, so that it can be presented in two-dimensional space. Different colors represent the predicted classes, while shapes represent the classes in reality. Orange triangle and blue triangle represent observations where the algorithm made an error.


#### Random Forest algorithm

The random forest algorithm is based on the use of decision trees. Each branch coming out of a tree divides it on the basis of the value of a given feature. If a given value (higher or lower than the limit value marked on the branch for continuous features) determines the class of a given observation, the given exit from the decision tree ends with a "leaf", i.e. an allocation to the class. If a further division by other characteristics is required, another branch of the tree is created. The disadvantage of decision trees is their low stability. Thus a random forest algorithm has been created, which generates a very large number of decision trees and averages their results in order to achieve greater stability of the algorithm.

<img src="https://github.com/ASledziewska/WineTypes_classification/blob/master/images/Image4.jpg" alt="Image 4" width="800"/>

The number of explanatory variables is a parameter that needs to be determined when building a random forest model. All possibilities were checked - from 1 to 13 explanatory variables. The highest accuracy was achieved with the number of variables equal to 1. The accuracy is then 98.18%, i.e. the algorithm is wrong only in less than 2% of cases.

<img src="https://github.com/ASledziewska/WineTypes_classification/blob/master/images/Table7.jpg" alt="Table 7" width="300"/>

The contingency table and measures of sensitivity and specificity illustrate that the model incorrectly classifies only one observation in the validation set (from class 2). All class 1 observations have been correctly classified.

<img src="https://github.com/ASledziewska/WineTypes_classification/blob/master/images/Table8.jpg" alt="Table 8" width="300"/>

The above table shows the variables in order of importance. The most important variable to create a random forest model was the proline content, followed by the intensity of color and flavonoids. When creating a random forest model, most of the variables other than in the k-nearest neighbors model were of the greatest importance. The lowest importance, both for the model of random forest and for the model of k-nearest neighbors, had the variable Ash, i.e. as it could be expected after looking at the boxplots generated in Methodology chapter.

<img src="https://github.com/ASledziewska/WineTypes_classification/blob/master/images/Image5.jpg" alt="Image 5" width="600"/>

The above graph shows how an example of a decision tree (classification) classifying a grape cultivar in wine looks like. In the first step, the intensity of the color (below 0.22) distinguishes variety 2 from the others. Then the flavonoid content is checked, which, if it is less than 0.30, the variety is classified as class 3. Finally, the proline content is checked. For values less than or equal to 0.31, variety 1 is assigned, and for values greater than 0.31, variety 2 is assigned.


#### Linear Discriminant Analysis and Quadratic Discriminant Analysis algorithms

The Linear Discriminant Analysis (LDA) algorithm consists in determining the hyperplane separating objects of different classes. The Quadratic Discriminant Analysis (QDA) algorithm is an extension of the linear discriminant algorithm and allows parabolic separating surfaces to occur. However, the quadratic discriminant algorithm works correctly only if the conditional probabilities for explanatory variables have multivariate normal distribution.

<img src="https://github.com/ASledziewska/WineTypes_classification/blob/master/images/Table9.jpg" alt="Table 9" width="300"/>

The LDA model was only wrong in one case. Its accuracy was equal 98.18%.

<img src="https://github.com/ASledziewska/WineTypes_classification/blob/master/images/Table10.jpg" alt="Table 10" width="300"/>

The QDA model was not mistaken even once. The accuracy, sensitivity and specificity of the model were equal 100%.

<img src="https://github.com/ASledziewska/WineTypes_classification/blob/master/images/Table11.jpg" alt="Table 11" width="600"/>

In both models the most important variables in terms of ROC curve were: OD280 protein content, flavonoid content and wine hue.

Although the QDA model was not mistaken even once, this can only be a coincidence, because the conditional probabilities of the variables in the model do not seem to have a multivariate normal distribution. 

<img src="https://github.com/ASledziewska/WineTypes_classification/blob/master/images/Image6.jpg" alt="Image 6" width="800"/>

The above graphs have been created only for the two most important explanatory variables to illustrate the operation of the algorithms on a two-dimensional plane. There are much more misclassified observations (red digits) than for an algorithm with 13 variables. Above diagrams show the differences in the lines marking the boundaries of decision areas. For linear discriminant analysis it is a straight line, and for quadratic discriminant analysis - a parabola. In the diagram for QDA we can also see a significant susceptibility of the algorithm to outliers (digit 2 in the upper right corner). The red digits denote observations for which the algorithm made a mistake and classified them into the wrong group.


## Conclusion

In this project the intent was to classify grape cultivars in wine using a dataset with 178 different wines and their 13 chemical characteristics. The data was firstly examined, cleaned and visualized. Then, 4 classification algorithms including the k-nearest neighbors, random forest, linear discriminant analysis and quadratic discriminant analysis were applied to the data. The table and graph below illustrate a comparison of the performance of these algorithms. They compare the accuracy and Kappa coefficient for each model. The Kappa coefficient is very close to the measure of accuracy, but it performs better in unbalanced tests where the classes are of significantly different sizes. In this case we are dealing with a balanced dataset, so more attention can be paid to the measure of accuracy.

<img src="https://github.com/ASledziewska/WineTypes_classification/blob/master/images/Table12.jpg" alt="Table 12" width="600"/>

<img src="https://github.com/ASledziewska/WineTypes_classification/blob/master/images/Image7.jpg" alt="Image 7" width="800"/>

Despite the initial best result for the quadratic discriminant analysis model (accuracy of 1) in the previous analysis, above table and figure show that this model is subject to the greatest variation in estimation accuracy. In some cases it classifies with 100% accuracy, but it may also be wrong in 20% of cases. This is therefore not the best classification method for such data. This is probably due to the fact that the assumption of multivariate normal distribution of conditional probabilities of the variables has not been met.

Also the k-nearest neighbors algorithm is subject to quite large fluctuations and, on average, performs worse than the random forest and linear discriminant algorithm. The analysis shows that the methods of random forests and linear discriminant analysis are best suited for classifying grape cultivars in wine on the basis of their chemical characteristics. The median for the linear discriminant and random forest model is as high as over 97%, while the minimum accuracy for both models is higher than 90%.

Moreover, the author publishing the dataset mentions that originally this dataset had around 30 variables, not only 13, however, the data was partly lost. More variables would allow to build probably even better model, and it could contain some variables that are strongly different for each cultivar of grapes. However, even with the limited number of explanatory variables, the accuracy of the models is very high.

The model attained in this project is satisfactory, nevertheless, only 4 classification algorithms were tested for this data, while the choice of algorithms is vast. For example, the more modern algorithms based on decision trees could be applied, like AdaBoost or XGBoost implementing gradient boosted decision tree.
