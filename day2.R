# putting data back into R Studio
gapminder <- read.csv("data/gapminder_data.csv")
head(gapminder)

# BASIC IF-ELSE SYNTAX:
## if (condition) {do something}
## if (condition) {do something} else
                  #{do somethingelse}
## if (condition) {do something} else
                  #if (other condition) {do some other thing} else
                  #{do something else}

if (nrow(gapminder)>100){
                    print("It's big!")
}

# NOTE ABOUT DATAFRAME SIZES: nrow(), ncol(), dim()

# NOTE ABOUT DATAFRAME LABELS: rownames(), colnames()

if ("birthrate" %in% colnames(gapminder)) {
  # linear model of birthrate vs population
  lm(birthRate ~ pop, data=gapminder)
  
} else if ("avgHeight" %in% colnames(gapminder)) {
  # linear model of average height vs population
  lm(avgHeight ~ pop, data=gapminder)
} else if ("gdpPercap" %in% colnames(gapminder)){
  # linear model of life expectancy vs pop
  lm(gdpPercap ~ pop, data=gapminder)
} else {
  # linear model of life expectancy vs population
  lm(lifeExp ~ pop, data=gapminder)
}

# USE AN IF() STATEMENT TO TEST WHETHER GAPMINDER HAS ANY RECORDS FROM 2012

if(2012 %in% gapminder$year) {
  print("gapminder has data from 2012")
} else{
  print("no data from 2012, sad!")
}

# If you want to leave a command statement to tell you if something went wrong,
# you can use a printed statement (as shown above) to make sure that the user is aware
# of an error

# FOR LOOP
#for (var in collection) {do something with the variable}

for (i in 1:3){
  print(gapminder[1:i,])
}

# use square brackets to idenfity specific rows 
# (i in 1:3) this will only work in a series of values, 
  # whereas 2012 %in% gapminder$year will give a T or F value


result <- list()
for (i in c(10, 25, 50)) {
  current_result<-mean(gapminder[1:i,"lifeExp"])
  result <- c(result, current_result)
}

# NESTED LIST
  # in a nested list, the first loop is run, then the second loop is appied before restarting at the first loop. 
new_result <- c()
for (i in 1:3) {
  for (j in c('a','b','c','d')){
    current_name <- paste(i,j)
    new_result[current_name] <- rnorm(1)
  }
}

#LOOP THORUGH GAPMINDER, BY CONTINENT, PRINT WHETHER MEAN LIFE EXPECTENCY IS MORE OR LESS THAN 50

unique(gapminder$year)

result <- list()

for (current_continent in unique(gapminder$continent)) {
  data_subset <- gapminder[gapminder$continent == current_continent,"lifeExp"]
   mean_life_expectency<-mean(data_subset)
  if (mean_life_expectency<50) {
    adjective<-"less than "
  } else if (mean_life_expectency>50){
    adjective<-"greater than"
  } else (
    adjective<-"equal to"
  )
   
   print(paste("Mean life expectancy in", current_continent, "is", adjective, "50."))
}


# WRITING OUR OWN FUNCTIONS
paste(c('one','two'), c(111,222), sep="----", collapse='++')

fahr_to_kelvin<-function(fahr_temperature) {
  # main content of the function goes here
  kelvin_temperature <- (fahr_temperature - 32)* 5/9 + 273.15
  return(kelvin_temperature)
}

kelvin_to_celsius <- function(kelvin_temp) {
  celsius_temperature <- (kelvin_temp) -273.15
  return(celsius_temperature)
}

fahr_to_celsius <- function(celsius_temp){
  farenheit_temperature <- kelvin_to_celsius(fahr_to_kelvin(celsius_temp))
  return(farenheit_temperature)
  print(celsius_temp, farenheit_temperature)
}

# We are going to calculate GDP with a new function that uses the dataframe.

calc_gdp <- function(dataframe) {
  gdp <- dataframe$pop * dataframe$gdpPercap
  return(gdp)
}

all_the_gdps <- calc_gdp(gapminder)
cbind(gapminder, all_the_gdps)

###################
#DPLYR
###################

library(dplyr)

# the pipe %>% takes whatever is on the left, and sticks it into the 
# function to the right automatically

gapminder %>% calc_gdp()

# mutate adds or changes columns at the end of the dataframe that you put in. 

gapminder %>% mutate(GDP = gdpPercap * pop) -> gapminder_plus

# Adding "group_by" pipe to first group the files by the continets before calculating the GDP

gapminder_plus %>% group_by(continent) %>% summarize(meanGDP= mean(GDP))

# Adding the dplyr pipelines as a way to filter and combine calculations
# Selecting columns and putting them into a new dataframe 

gapminder_plus %>% 
  select(country, lifeExp ) %>% 
  head()

# using the filter command on dplyr

gapminder_plus %>% 
  filter( year == 2002, continent== "Europe", lifeExp >78) %>%
  head()

# Way to measure the total count of data from each contient
gapminder_plus %>% 
  group_by(continent) %>%
  count()

# Sampling 20 datapoints per continent

gapminder_plus %>% 
  group_by(continent) %>% 
  sample_n(20) %>% 
  count()

# Showing the sample without spitting out the count
gapminder_plus %>% 
  group_by(continent) %>% 
  sample_n(20)

# Sample with replacement
gapminder_plus %>% 
  group_by(continent) %>%
  sample_n(2000, replace=TRUE) %>% 
  count()

# Creating an output variable called "count_of_samples_per_group
gapminder_plus %>% 
  group_by(continent) %>%
  sample_n(2000, replace=TRUE) %>% 
  count() -> count_of_samples_per_group

# Add a column to gapminder_plus where it contains the average GDP for that continent in that year
gapminder_plus %>%
  # with the group_by function, you can group by multiple variables at once...
    group_by(continent, year) %>%
    mutate( meanGDPofcontinentthisyear = mean(GDP)) %>% 
    filter(year==1957, continent=='Americas') -> gapminder_plus

gapminder_plus %>%
  # Removal of filtering steps, but adding mean GDP to the total graph
  group_by(continent, year) %>%
  mutate( meanGDPofcontinentthisyear = mean(GDP)) -> gapminder_plus

# Removal of certain columns from graph
gapminder_plus %>%
  select(-continent, -lifeExp, -gdpPercap)

####DPLYR PIPELINES WITH GGPLOT !!!!OMG SO AWESOME!!!###
library("ggplot2")

gapminder_plus %>% 
  # Adding a filter to isolate out data if the GDP per capita is less than half of the mean GDP per capita. 
  filter( gdpPercap < 0.5 * mean(gdpPercap) ) %>%
  ggplot(mapping=aes(x=year, y=lifeExp, by=country, color=continent)) +
  geom_line()





