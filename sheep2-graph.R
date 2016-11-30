n <- 50
sheep <- paste0("sheep", 1:n)

d <- readLines("./data/graph2.csv")

query <- paste0("CREATE (", sheep[1], ":Sheep {name: '", sheep[1], "'})")
for (i in 2:n)
{
    query <- paste0(query, ", (", sheep[i], ":Sheep {name: '", sheep[i], "'})")
}

cid <- 1

a <- as.character(unlist(read.csv(text = d[1], head = FALSE, stringsAsFactors = FALSE)))
query <- paste0(query, ", (contact", cid, ":Contact {dur:", as.numeric(a[length(a)]), ", name:'contact", cid, "'})")
for (j in 1:(length(a) - 1))
{
    query <- paste0(query, ", (contact", cid, ")-[:includes]->(", a[j], ")")
}
for (i in 2:length(d))
{
    cid <- cid + 1
    a <- as.character(unlist(read.csv(text = d[i], head = FALSE, stringsAsFactors = FALSE)))
    query <- paste0(query, ", (contact", cid, ":Contact {dur:", as.numeric(a[length(a)]), ", name:'contact", cid, "'})")
    for (j in 1:(length(a) - 1))
    {
        query <- paste0(query, ", (contact", cid, ")-[:includes]->(", a[j], ")")
    }
}

cypherToList(graph, query)
