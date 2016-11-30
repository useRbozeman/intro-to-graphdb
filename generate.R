
###########################################################################
##                               example 1                               ##
###########################################################################

file.remove("./data/graph1.csv")
set.seed(32)
n <- 50
d <- 15
m <- 50

sheep <- paste0("sheep", 1:n)

for (i in 1:m)
{
    r <- sample(1:(n - d), 2, replace = FALSE)
    wline <- paste(sheep[r[1]], sheep[r[2]], round(runif(1, 1, 100)), sep = ",")
    write(wline, file = "./data/graph1.csv", append = TRUE)
}
for (i in 1:m)
{
    r <- sample((n - d + 1):n, 2, replace = FALSE)
    wline <- paste(sheep[r[1]], sheep[r[2]], round(runif(1, 1, 100)), sep = ",")
    write(wline, file = "./data/graph1.csv", append = TRUE)
}


###########################################################################
##                               example 2                               ##
###########################################################################

file.remove("./data/graph2.csv")
set.seed(32)
n <- 50
m <- 50

sheep <- paste0("sheep", 1:n)

for (i in 1:n)
{
    ni <- floor(rbeta(1, 1, 20) * 38) + 2
    r <- sample(1:n, ni, replace = FALSE)
    wline <- paste(paste(sheep[r], collapse = ","), round(runif(1, 1, 100)), sep = ",")
    write(wline, file = "./data/graph2.csv", append = TRUE)
}




###########################################################################
##                               example 3                               ##
###########################################################################


file.remove("./data/graph3.csv")
set.seed(32)
n <- 50
m <- 50

sheep <- paste0("sheep", 1:n)

for (i in 1:n)
{
    ni <- floor(rbeta(1, 1, 20) * 38) + 2
    r <- sample(1:n, ni, replace = FALSE)
    wline <- paste(paste(sheep[r], collapse = ","), round(runif(1, 1, 100)), sep = ",")
    write(wline, file = "./data/graph3.csv", append = TRUE)
}

file.remove("./data/graph3-health.csv")

for (i in 1:n)
{
    p <- runif(1, 0, 1)
    if (p < 0.20)
    {
        wline <- paste(sheep[i], "sick", sep = ",")
        write(wline, file = "./data/graph3-health.csv", append = TRUE)
    } else if (p < 0.50 & p >= 0.20)
    {
        wline <- paste(sheep[i], "healthy", sep = ",")
        write(wline, file = "./data/graph3-health.csv", append = TRUE)
    } else {
        wline <- paste(sheep[i], "unknown", sep = ",")
        write(wline, file = "./data/graph3-health.csv", append = TRUE)
    }
}

###########################################################################
##                            unused example                             ##
###########################################################################


# set.seed(32)
# n <- 40
# m <- 200
# types <- c("sniff", "sneeze", "butt")
# contact <- list()
# for (i in 1:m)
# {
#     ni <- floor(rbeta(1, 1, 20) * 38) + 2
#     contact[[i]] <- sample(1:n, ni, replace = FALSE)
# }

# sheeps <- paste("sheep", 1:n, sep = "")


# create <- paste("CREATE (", sheeps[1], ":sheep {name: '", sheeps[1], "'})", sep ="")
# for (i in 2:n)
# {
#     create <- paste(create, ", (", sheeps[i], ":sheep { name: '", sheeps[i], "'})", sep = "")
# }
# for (i in 1:m)
# {
#     ctype <- sample(types, 1)
#     meet <- paste("meet", i, sep = "")
#     create <- paste(create, ", (", meet, ":contact { id: '", meet, "'})", sep = "")
#     if (ctype != "sneeze")
#     {
#         for (j in contact[[i]])
#         {
#             create <- paste(create, ", (", meet, ")-[:", ctype, "]->(", sheeps[j], ")", sep = "")
#         }
#     } else {
#         j <- contact[[i]][1]
#         create <- paste(create, ", (", meet, ")-[:sneezer]->(", sheeps[j], ")", sep = "")
#         for (j in contact[[i]][2:length(contact[[i]])])
#         {
#             create <- paste(create, ", (", meet, ")-[:sneezee]->(", sheeps[j], ")", sep = "")
#         }
#     }
# }


