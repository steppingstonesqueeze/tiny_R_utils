# The R Book of Lists (and Beyond)

---

## Chapter 1: All About Lists in R

### 1.1 What is a List?
A list in R is a generic vector that can hold elements of different types and lengths:
```r
my_list <- list(name = "Alice", age = 30, scores = c(80, 90, 100))
```

### 1.2 Accessing Elements
- Named: `my_list$name` or `my_list[["name"]]`
- By position: `my_list[[1]]` or `my_list[1]` (returns sublist)

### 1.3 Modifying Lists
```r
my_list$age <- 31
my_list[["new_field"]] <- "hello"
my_list[[2]] <- NULL  # Removes second element
```

### 1.4 List Operations
- `length(my_list)`
- `names(my_list)`
- `lapply(my_list, class)`
- Flatten: `unlist()`
- Combine: `c(list1, list2)`
- Recursive apply: `rapply()`

### 1.5 List as Tree Structure
Lists can be nested arbitrarily:
```r
nested <- list(a = list(b = list(c = 42)))
nested$a$b$c
```

---

## Chapter 2: Metaprogramming in R

### 2.1 Expressions and Quoting
```r
expr <- quote(a + b)
eval(expr, list(a = 1, b = 2))  # 3
```

### 2.2 Substitution and Deparsing
```r
substitute(x + y, list(x = quote(a), y = quote(b)))
deparse(expr)
```

### 2.3 Functions that Write Functions
```r
make_adder <- function(n) function(x) x + n
add5 <- make_adder(5)
add5(10)  # 15
```

### 2.4 Environments
```r
ls(environment(add5))
get("n", envir = environment(add5))
```

### 2.5 `match.call()` and `...`
Useful in writing flexible wrappers that inspect or manipulate calls.

---

## Chapter 3: Object Systems (S3 vs S4)

### 3.1 S3: Informal, Flexible
```r
person <- list(name = "Alice", age = 30)
class(person) <- "person"
print.person <- function(x) cat(x$name, "is", x$age, "years old\n")
```

### 3.2 S4: Formal, Structured
```r
setClass("Person", representation(name = "character", age = "numeric"))
p <- new("Person", name = "Bob", age = 40)
setMethod("show", "Person", function(object) cat(object@name, object@age))
```

### 3.3 S3 vs S4
| Feature     | S3         | S4           |
|-------------|------------|--------------|
| Formality   | Informal   | Strict       |
| Validation  | None       | Yes          |
| Extensibility | Easy     | Safer        |

---

## Chapter 4: Tidyverse Essentials

### 4.1 Tibbles and Pipes
```r
library(tidyverse)
df <- tibble(x = 1:5, y = x^2)
df %>% filter(x > 2) %>% mutate(z = y - x)
```

### 4.2 `dplyr`
- `filter()`, `select()`, `mutate()`, `summarise()`, `group_by()`

### 4.3 `ggplot2`
```r
ggplot(df, aes(x, y)) + geom_point() + geom_smooth(method = "lm")
```

### 4.4 `purrr`
Functional programming with lists and vectors:
```r
map(1:5, ~ .x^2)
map_df(list(a = 1:3, b = 4:6), mean)
```

---

## Chapter 5: Advanced List Usage in Tidyverse

### 5.1 Nested Data Frames
```r
nested <- df %>% group_by(x %% 2) %>% nest()
nested$data[[1]]
```

### 5.2 List-Columns
```r
library(tibble)
tibble(x = 1:3, lst = list(1:2, 3:5, 6:7)) %>% mutate(len = map_int(lst, length))
```

---
