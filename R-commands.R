# EXAMPLES OF ARITHMETIC IN R

2^3  # Exponenets, ^ is preferred, but 2**3 works too
11 %/% 3 # integer division
11 %% 3 # modular operator for (remainders)
log(100) # functions take input inside of parenthesis

# VARIABLE ASSIGNMENT USES THE ARROW: <- or -> 
snake_case <- "foo_bar"
CamelCase <- "FooBar"
dot.case <- "foo.bar"
.hidden_variable <- "top secret"

"foo" -> bar

# PACKAGE MANAGEMENT
installed.packages()
intall.packages()
update.packages()   # new versions of what you already have
remove.packages()   # uninstall
library(ggplot2)

c(1,2,"f")

paste(1, 2)

paste(c("one", "two"), c(111, 222), sep="__", collapse="++++")

paste(c("one", "two", "three", c("X")))

paste(c("one", "two", "three"), c("X", "Y"))
