library(tidyverse)
library(weights)
library(rmarkdown)

#setwd("C:/Users/450/Documents/GitHub")
example_data <- read_csv("example_data.csv")
data <- read_csv("Pliki do strony/ING_2017_WAVE_19.csv", na = "")

data <- slice(data, 1001:2000)
data <- data[, c("P2", "WeightPerCountry", "G1")]

names(data) <- c("Country", "Gender", "Weight", "Question")

example_data %>%
  group_by(question_1) %>% 
  tally()

data %>% 
  count(question_1) %>% 
  mutate(prop = prop.table(n))

# Let's save the list of answers to variable, for later use. 
answers <- names(wpct(data$Question, weight = data$Weight))

freq_table <- data %>% 
  group_by(Gender) %>%
  do(as.data.frame(wpct(.$Question, .$Weight, na.rm = TRUE))) %>%
  mutate(answers = answers) %>% 
  names(freq_table)[2] <- "frequency"

freq_table <- freq_table %>% 
  spread(key = answers, "frequency")


###### Tymczasowe

answers <- names(wpct(data$Question, weight = data$Weight))

freq_table <- data %>% 
  group_by(Gender) %>%
  do(as.data.frame(wpct(.$Question, .$Weight, na.rm = TRUE))) %>%
  mutate(answers = answers)

names(freq_table)[2] <- "frequency"
