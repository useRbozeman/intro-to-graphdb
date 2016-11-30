n <- 50
sheep <- paste0("sheep", 1:n)

d <- readLines("./data/graph1.csv")

query <- paste0("CREATE (", sheep[1], ":Sheep {name: '", sheep[1], "'})")
for (i in 2:n)
{
    query <- paste0(query, ", (", sheep[i], ":Sheep {name: '", sheep[i], "'})")
}

a <- as.character(unlist(read.csv(text = d[1], head = FALSE, stringsAsFactors = FALSE)))
if (length(a) != 3)
{
    print("Too many entries")
}
query <- paste0(query, ", (", a[1], ")-[:contacts {dur:", as.numeric(a[3]), "}]->(", a[2], ")")
for (i in 2:length(d))
{
    a <- as.character(unlist(read.csv(text = d[i], head = FALSE, stringsAsFactors = FALSE)))
    if (length(a) != 3)
    {
        print("Too many entries")
    }
    query <- paste0(query, ", (", a[1], ")-[:contacts {dur:", as.numeric(a[3]), "}]->(", a[2], ")")
}

cypherToList(graph, query)
