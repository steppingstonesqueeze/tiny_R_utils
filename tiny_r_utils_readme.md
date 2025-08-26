# Tiny R Utils: Advanced R Programming Patterns & Utilities

**A curated collection of production-ready R utilities demonstrating advanced programming patterns, computational insights, and performance-aware coding practices**

## Overview

This repository contains a carefully crafted collection of R utilities that showcase advanced programming techniques, memory management concepts, and computational insights. Each utility addresses specific programming challenges encountered in data science and statistical computing workflows, demonstrating both R language mastery and broader software engineering principles.

## Key Categories

### 🔧 **Language Mechanics & Memory Management**
- **Memory Address Tracking**: Copy semantics and shared memory analysis
- **Argument Handling**: Flexible parameter passing with arbitrary argument lists
- **Namespace Management**: Clean package dependency handling
- **Function Composition**: Advanced infix operators and functional programming patterns

### 📊 **Computational Utilities**
- **Multi-dimensional PRNG**: Scalable random number generation for arbitrary dimensions
- **Distance Metrics Analysis**: Euclidean and cosine similarity computations with visualization
- **Statistical Distribution Exploration**: High-dimensional probability space analysis

### 🛠️ **Development Tools**
- **Package Dependency Checking**: Robust library loading with error handling
- **Function Parameter Management**: Default value systems with named argument processing
- **Code Organization**: Utility patterns for maintainable R codebases

## Featured Implementations

### Advanced Argument Handling
```r
generate_uniform_nums <- function(...) {
  DEFAULTS <- list(dims = 3, min_val = 0.0, max_val = 1.0, N = 1000)
  args <- list(...)
  n_args <- names(args)
  
  # Intelligent parameter resolution with defaults
  dims <- if ("dims" %in% n_args) args$dims else DEFAULTS$dims
  # ... flexible parameter handling
}
```

### Memory Management Analysis
```r
share_mem <- function(a, b) {
  obj_addr(a) == obj_addr(b)  # Memory address comparison
}

# Demonstrates copy-on-write semantics
y <- x
obj_addr(y)   # Same as x (no copy yet)
y[1] <- 99    # Triggers copy
obj_addr(y)   # Different address now
```

### Custom Infix Operators
```r
`%f%` <- function(a, b) { a - 2*b }

cumulative_ops <- function(operation = `%plus%`, ...) {
  args <- unlist(list(...))
  # Fold operation across argument list
  Reduce(operation, args)
}
```

## Technical Highlights

### Memory-Aware Programming
The utilities demonstrate deep understanding of R's memory model:
- **Copy Semantics**: Tracking when objects are copied vs. shared
- **Reference Counting**: Understanding R's copy-on-write behavior
- **Memory Profiling**: Using `lobstr::obj_addr()` for performance analysis

### Computational Geometry
Multi-dimensional analysis utilities:
```r
# N-dimensional distance analysis
mat <- as.matrix(generate_uniform_nums(dims = 6, N = 10000))
dists <- dist(mat)                    # Euclidean distances
norm_mat <- mat / sqrt(rowSums(mat^2)) # L2 normalization
cosine_sim <- tcrossprod(norm_mat)     # Cosine similarity matrix
```

### Functional Programming Patterns
- **Higher-Order Functions**: Operations that accept other functions as parameters
- **Infix Operators**: Custom binary operators for domain-specific logic
- **Argument Unpacking**: Flexible parameter handling with `...` ellipsis

## Performance Considerations

### Efficient Data Generation
```r
# Vectorized approach for multi-dimensional data
for (j in 2:dims) {
  df2 <- data.frame(runif(N, min = min_val, max = max_val))
  df <- bind_cols(df, df2)
}
```

### Memory Efficiency
- Avoiding unnecessary copies through reference tracking
- Using `suppressPackageStartupMessages()` for clean loading
- Implementing lazy evaluation patterns where appropriate

## Code Quality Patterns

### Robust Error Handling
```r
suppressPackageStartupMessages({
  ok <- requireNamespace("ggplot2", quietly = TRUE)
  if (!ok) stop("Install ggplot2")
})
```

### Parameter Validation
```r
stopifnot(len_data >= 2)  # Explicit precondition checking
return(ifelse(b != 0, a/b, NA))  # Graceful division by zero handling
```

### Self-Documenting Code
- Clear naming conventions
- Inline parameter defaults
- Explicit type handling for mixed arguments

## Mathematical Insights

### High-Dimensional Probability
The distance analysis utilities reveal key insights about high-dimensional spaces:
- **Curse of Dimensionality**: Distance distributions in high dimensions
- **Cosine vs. Euclidean**: Different similarity measures for different use cases
- **Random Point Distributions**: Statistical properties of PRNG outputs

### Statistical Computing
- Efficient pairwise distance computation: O(n²) but memory-aware
- Matrix operations using `tcrossprod()` for performance
- Vectorized operations throughout for R efficiency

## Usage Examples

### Multi-Dimensional Random Data
```r
# Generate 10K points in 6D space
df <- generate_uniform_nums(dims = 6, N = 10000)

# Analyze distance distributions
mat <- as.matrix(df) - 0.5  # Center on origin
dists <- dist(mat)
hist(dists, main = "Euclidean Distance Distribution")
```

### Memory Analysis
```r
library(lobstr)
large_df <- data.frame(x = rnorm(1e6), y = runif(1e6))
copy_df <- large_df

# Check if sharing memory (before modification)
share_mem(large_df, copy_df)  # TRUE

copy_df$x[1] <- 999
share_mem(large_df, copy_df)  # FALSE (copy-on-write triggered)
```

### Custom Operations
```r
# Chain custom infix operations
result <- cumulative_ops(`%mult%`, 2, 3, 4, 5)  # 2*3*4*5 = 120
```

## Educational Value

These utilities demonstrate several important concepts:

### R Language Mastery
- **Ellipsis Handling**: Flexible argument processing
- **Scoping Rules**: Understanding R's lexical scoping
- **Memory Model**: Copy-on-write semantics and reference counting

### Software Engineering
- **Default Parameters**: Clean API design patterns
- **Error Handling**: Graceful failure with informative messages
- **Code Reusability**: Generic functions with sensible defaults

### Computational Thinking
- **Algorithmic Complexity**: Understanding performance implications
- **Statistical Computing**: Efficient matrix operations
- **Visualization**: Data exploration through plotting

## Applications

These utilities support various data science workflows:
- **Simulation Studies**: Multi-dimensional random data generation
- **Performance Profiling**: Memory usage analysis and optimization
- **Statistical Analysis**: Distance and similarity computations
- **Package Development**: Clean dependency management patterns

## Technical Requirements

- **R Version**: 4.0+ (for improved argument handling)
- **Dependencies**: `ggplot2`, `lobstr`, `dplyr` (loaded conditionally)
- **Memory**: Efficient for datasets up to millions of points
- **Performance**: Vectorized operations throughout

## Design Philosophy

1. **Clarity over Cleverness**: Readable, maintainable code
2. **Performance Awareness**: Memory and computational efficiency
3. **Flexible APIs**: Sensible defaults with customization options
4. **Educational Value**: Code that teaches R programming patterns

These utilities represent practical solutions to common R programming challenges while demonstrating advanced language features and computational insights.

---

*A collection of production-ready R utilities showcasing advanced programming patterns and computational efficiency.*