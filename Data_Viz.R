getwd()
setwd("~/Documents/RPNewStart/GoogleDrive/EFPM/6-R_Training/DataMunging")

require(ggplot2)
require(scales)
require(ggthemes)
require(ggvis)
require(rCharts)
require(graphics)
require(reshape2)


#################### DATA IMPUTATION SUMMARY ################

### Now let us take a step back and see what all we learnt:
# 1. Why data imputation is critical - you dont want to lose important data!
# 2. Mean vs. Median vs. Time Series vs. KNN imputation : when to do what
# 3. Understand your data first and last...! You saw what you could do with knowing time series
# 4. Last but not the least, IMPORTANCE OF VISUALIZATION! 

#################### SUMMARY #################################




################################################################
################################################################
################################################################
################## DATA VISUALIZATION ##########################
################################################################
################################################################
################################################################



data(diamonds)

head(diamonds)
str(diamonds)

## Base plotting functions

# Histogram
hist(diamonds$carat)
hist(diamonds$carat, main = "Histogram of Carat Frequencies", 
     xlab = "Carat")

# Getting help
?hist

# Scatter plot
plot(diamonds$carat, diamonds$price)
# Another way to do the same!
plot(price ~ carat, data = diamonds, main = "Price Vs. Carat")

# BoxPlots
boxplot(diamonds$carat)
summary(diamonds$carat)


### GGPLOT2

# Components of a ggplot2 function
ggplot(data = diamonds)

geom_boxplot()

aes(x, y)

# Hist
ggplot(data = diamonds) + geom_histogram(aes(x = carat))
# changing the bin width
ggplot(data = diamonds) + geom_histogram(aes(x = carat), binwidth = 0.5)
ggplot(data = diamonds) + geom_histogram(aes(x = carat), binwidth = 0.1)


# Density Plot
ggplot(data = diamonds) + geom_density(aes(x = carat))
ggplot(data = diamonds) + geom_density(aes(x = carat), fill = "grey50")


# Scatter plot
ggplot(data = diamonds, aes(x = carat, y = price))
ggplot(data = diamonds, aes(x = carat, y = price)) + geom_point()


# Add some color...!!
g = ggplot(data = diamonds, aes(x = carat, y = price))
g # Canvas...!!

g + geom_point()
g + geom_point(aes(color = color))

# Shape
g
g + geom_point(aes(color = color, shape = clarity))
ggplot(data = diamonds, aes(x=carat, y=price, color = color,
                            shape = cut, size = depth)) + geom_point()

# Boxplot
ggplot(data = diamonds, aes(y = carat, x = 1)) + geom_boxplot()
ggplot(data = diamonds, aes(y = carat, x = cut)) + geom_boxplot()

# Violin plot
ggplot(data = diamonds, aes(y = carat, x = cut)) + geom_violin()
g = ggplot(data = diamonds, aes(y = carat, x = cut))
g
g + geom_point() + geom_violin()
g + geom_violin() + geom_point()
g + geom_jitter() + geom_violin()
g + geom_violin() + geom_jitter()


# Creating small multiples - so as to simplify life...!
g = ggplot(diamonds, aes(x = carat, y = price))
g
g + geom_point(aes(color = color))

g = g + geom_point(aes(color = color)) + facet_wrap(~color)
g

g = g + geom_point(aes(color = color)) + facet_grid(~color)
g

g = g + geom_point(aes(color = color)) + facet_grid(cut~clarity)
g


# Adding themes
require(ggthemes)

g = ggplot(diamonds, aes(x = carat, y = price, color = color)) + geom_point()
g

g + theme_wsj()
g + theme_economist()
g + theme_tufte()

g + theme_excel() + scale_color_excel()


#### WEB GRAPHICS

require(ggvis)
data("cocaine")

head(cocaine)
str(cocaine)

ggplot(cocaine, aes(x=weight, y = price)) + geom_point()

cocaine %>% ggvis(x = ~weight, y = ~price) %>% layer_points()
cocaine %>% ggvis(x = ~weight, y = ~price, stroke = ~potency) %>% layer_points()
cocaine %>% ggvis(x = ~weight, y = ~price, fill = ~potency) %>% layer_points() %>% layer_smooths()

# with input sliders...!
cocaine %>% ggvis(x = ~weight, y = ~price, fill = ~potency, 
                  size := input_slider(5, 100), 
                  opacity := input_slider(0,1)) %>% layer_points()



ggplot(cocaine, aes(x=price)) + geom_histogram()
cocaine %>% ggvis(x = ~price) %>% layer_histograms()


### D3.js 

require(rCharts)
head(iris)

rPlot(data = diamonds, price ~ carat | color, color = "color", type = "point")
rPlot(data = diamonds, price ~ carat | color, color = "color", type = "bar")



#### Using maps

map1 = Leaflet$new()
map1$setView(c(51.505, -.09), zoom = 13)
map1

map2 = Leaflet$new()
map2$setView(c(13.043, 77.64), zoom = 14)
map2

# Adding popups
map2$marker(c(13.034, 77.642), bindPopup = "<p>This is where Rohit lives...!</p>")
map2$marker(c(13.05, 77.621),  bindPopup = "<p>This is where Rohit works...!</p>")
map2


################# DATA VISUALIZATION SUMMARY ################

### Now let us take a step back and see what all we learnt:
# 1. Progress covered: Base plotting --> Advanced plotting (GGPLOT2) --> Web Graphics (GGVIS)
# 2. Why data visualization is important - It gives you great insights almost immediately about the data
# 3. One must ensure there is good business context while interpreting the data
# 4. Knowing when to use what visualization is important
# 5. Dont go overboard - Client probably wants a Da vinci (very detailed) and you end up giving an abstract Picasso..!

#################### SUMMARY #################################
