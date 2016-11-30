library(RNeo4j)


graph <- startGraph("http://localhost:7474/db/data/")

clear(graph)
source("./sheep1-graph.R")


###########################################################################
##                Sheep who have contact most other sheep                ##
###########################################################################


# Directed contact

query <- "
MATCH (s)-[:contacts]->(s2)
WITH s, count(s2) as count
WHERE count > 2
RETURN s.name, count
ORDER BY count DESC
"

cypher(graph, query)


# Undirected

query <- "
MATCH (s)-[:contacts]-(s2)
WITH s, count(s2) as count
WHERE count > 5
RETURN s.name, count
ORDER BY count DESC
"

cypher(graph, query)


# undirected number of contact partners

query <- "
MATCH (s)-[:contacts]-(s2)
WITH s, count(DISTINCT s2) as count
WHERE count > 5
RETURN s.name, count
ORDER BY count DESC
"

cypher(graph, query)



###########################################################################
##                question 2 up to second order contacts                 ##
###########################################################################


query <- "
MATCH (s)-[:contacts*1..2]-(s2)
WITH s, count(DISTINCT s2) as count
WHERE count > 10
RETURN s.name, count
ORDER BY count DESC
"


cypher(graph, query)


###########################################################################
##                    quesiton 3 shortest path length                    ##
###########################################################################


query <- "
MATCH (s1), (s2), p = shortestPath((s1)-[*]-(s2))
RETURN s1.name, s2.name, length(p)
ORDER BY length(p) DESC
LIMIT 20
"


cypher(graph, query)



###########################################################################
##         question 4 sheep who have had the longest contact time        ##
###########################################################################


query <- "
MATCH (s1)-[c:contacts]->(s2)
WITH s1, sum(c.dur) as duration
RETURN s1.name, duration
ORDER BY duration DESC
LIMIT 10
"

cypher(graph, query)


###########################################################################
##                           adjacency matrix                            ##
###########################################################################

query <- "
MATCH (s1), (s2)
OPTIONAL MATCH path = (s1)--(s2)
WITH s1, s2, CASE WHEN path IS NULL THEN 0 ELSE count(path) END AS count
ORDER BY s1.name, s2.name
RETURN s1.name, collect(count)
"

cypher(graph, query)


###########################################################################
##                               EXAMPLE 2                               ##
###########################################################################

clear(graph)

source("./sheep2-graph.R")


###########################################################################
##                  largest average contact group size                   ##
###########################################################################

query <- "
MATCH (s1:Sheep)<-[:includes]-(c:Contact)
MATCH (c:Contact)-[:includes]->(s2:Sheep)
WITH s1, c, collect(s2.name) as contacts, count(s2) as num_contacts
WITH s1, avg(num_contacts) as avg_size
RETURN s1.name, avg_size
ORDER BY avg_size
"

cypher(graph, query)


query <- "
MATCH (s1:Sheep)<-[:includes]-(c:Contact)-[:includes]->(s2:Sheep)
WHERE s1.name = 'sheep1'
WITH s1, c, collect(s2.name) as contacts, count(s2) as num_contacts
RETURN s1.name, num_contacts, contacts
ORDER BY num_contacts
"

cypher(graph, query)



query <- "
MATCH (s1:Sheep)<-[:includes]-(c:Contact)
MATCH (c:Contact)-[:includes]->(s2:Sheep)
WHERE s1.name = 'sheep1'
WITH s1, c, collect(s2.name) as contacts, count(s2) as num_contacts
RETURN s1.name, num_contacts, contacts
ORDER BY num_contacts
"

cypher(graph, query)


query <- "
MATCH (s1:Sheep), (s2:Sheep)
WHERE NOT (s1)-[*1..10]-(s2) AND (s1) <> (s2)
RETURN s1.name, s2.name
"

cypher(graph, query)


query <- "
MATCH (s1:Sheep), (s2:Sheep), p = shortestPath((s1)-[*]-(s2))
RETURN s1.name, s2.name, length(p) / 2
"

cypher(graph, query)

query <- "
MATCH (s:Sheep)
WITH COLLECT(s) as all_sheep
MATCH (s1:Sheep), (s2:Sheep), p = shortestPath((s1)-[*]-(s2))
WITH all_sheep, COLLECT([s1, s2]) as connected_sheep
WITH FILTER (n IN all_sheep WHERE NOT n IN connected_sheep) as s
UNWIND(s) as sheep
RETURN sheep.name
"

cypher(graph, query)


###########################################################################
##                               Example 3                               ##
###########################################################################


source("./sheep3-graph.R")





query <- "CREATE (:Domestic {name: 'horse1'}), (:Domestic {name: 'farmsheep1'})"

cypher(graph, query)




query <- "CREATE (:DomesticType {value: 'horse'}), (:DomesticType {name: 'sheep'})"

cypher(graph, query)




query <- "
MATCH (a:Domestic {name: 'horse1'}), (atype:DomesticType {value: 'horse'})
CREATE (a)-[:is_type]->(atype)
"


cypher(graph, query)



query <- "
MATCH (a:Domestic {name: 'farmsheep1'}), (atype:DomesticType {value: 'sheep'})
CREATE (a)-[:is_type]->(atype)
"

cypher(graph, query)




query <- "CREATE (:SaltLick {name: 'saltlick1'})"

cypher(graph, query)




query <- "
MATCH (s1:Sheep {name: 'sheep1'}), (h:Domestic {name: 'horse1'}), (fs:Domestic {name: 'farmsheep1'}), (sl:SaltLick {name: 'saltlick1'})
CREATE (c:Contact {name: 'extreme', dur: 20}),(c)-[:includes {action: 'licker'}]->(s1),(c)-[:includes {action: 'licker'}]->(fs), (c)-[:includes {action: 'sniffer'}]->(h), (c)-[:includes {action: 'was_licked'}]->(sl)
"

cypher(graph, query)




query <- "
MATCH (s:Sheep)<-[i:includes]-(c:Contact)-[i2:includes]->(o)
WHERE s.name = 'sheep1'
RETURN s.name, i.action, c.name, c.dur, o.name, labels(o), i2.action
"

cypher(graph, query)





query <- "
MATCH (:Health {status:'healthy'})<--(s:Sheep)<--(c:Contact)
MATCH (c)-->(sh)-->(:Health {status: 'healthy'})
WITH s, c, count(sh) as healthy
MATCH (c)-->(ss)-->(:Health {status: 'sick'})
WITH s, c, healthy, count(ss) as sick
MATCH (c)-->(su)-->(:Health {status: 'unknown'})
WITH s, c, healthy, sick, count(su) as unknown
WITH s, avg(healthy) as avg_healthy, avg(sick) as avg_sick, avg(unknown) as avg_unknown
RETURN s.name, avg_healthy, avg_sick, avg_unknown
ORDER BY s.name
"

cypher(graph, query)

