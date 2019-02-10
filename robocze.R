library(tidyverse)
library(weights)
library(rmarkdown)
library(scales)

setwd("C:/Users/450/Documents/GitHub")
example_data <- read_csv("example_data.csv")
data <- read_csv("Pliki do strony/ING_2017_WAVE_19.csv", na = "")

data <- slice(data, c(100:300, 400:600, 700:900, 1000:1200, 2000:2200))
data <- data[, c("P2", "WeightPerCountry", "G22_s4")]

names(data) <- c("Gender", "Weight", "Question")

example_data %>%
  group_by(question_1) %>% 
  tally()

data %>% 
  count(question_1) %>% 
  mutate(prop = prop.table(n))

# Let's save the list of answers to variable, for later use.

freq_table <- data$Question %>% 
              wpct(data$Weight) %>%
                as.data.frame()

freq_table$value <- freq_table$value %>% percent()

answers <- names(wpct(data$Question, weight = data$Weight))

freq_table <- data %>% 
  group_by(Gender) %>%
  do(as.data.frame(wpct(.$Question, .$Weight, na.rm = TRUE))) %>%
  mutate(answers = answers)

names(freq_table)[2] <- "frequency"
freq_table$frequency <- freq_table$frequency %>% percent()

freq_table <- freq_table %>% 
  spread(key = answers, "frequency")

as.list(freq_table[,2:6]) %>% percent()


###### Tymczasowe

names(freq_table)[2] <- "frequency"
answers <- names(wpct(data$Question, weight = data$Weight))

freq_table <- data %>% 
  group_by(Gender) %>%
  do(as.data.frame(wpct(.$Question, .$Weight, na.rm = TRUE))) %>%
  mutate(answers = answers)


```{r eval = TRUE, include = TRUE, echo = TRUE}
freq_table_long <- freq_table %>% 
  gather(key = "key", value = "value", 2:6, - Gender)
```
to obtain:
  ```{r message = FALSE, include = TRUE}
kable(freq_table_long, "html") %>% 
  kable_styling(bootstrap_options = "striped", 
                full_width = FALSE, 
                position = "left")
```
