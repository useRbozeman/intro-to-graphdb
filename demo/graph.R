library(RNeo4j)

graph = startGraph("http://localhost:7474/db/data/")


nicole <- createNode(graph, "Person", name="Nicole", age=24)
greta <- createNode(graph, "Person", name="Greta", age=24)
kenny <- createNode(graph, "Person", name="Kenny", age=27)
shannon <- createNode(graph, "Person", name="Shannon", age=23)


r1 <- createRel(greta, "LIKES", nicole, weight=7)
r2 <- createRel(nicole, "LIKES", kenny, weight=1)
r3 <- createRel(kenny, "LIKES", shannon, weight=3)
r4 <- createRel(nicole, "LIKES", shannon, weight=5)

query <- "
MATCH (p:Person)-[r:LIKES]->(p2:Person)
RETURN p.name, count(p2)
"

cypher(graph, query)

query <- "
MATCH (p:Person)-[r:LIKES]->(p2:Person)
RETURN p.name, count(p2)
"

cypher(graph, query)

icecream <- createNode(graph, "Food", called = "Ice cream")

r5 <- createRel(nicole, "LIKES", icecream)
r10 <- createRel(shannon, "LIKES", nicole)

query <- "
MATCH (p:Person)-[r:LIKES]->(t)
RETURN p.name, count(t), collect([t.name, t.called]) as persons
"

query <- "
MATCH (p:Person)-[r:LIKES*1..3]->(p)
RETURN p.name
"

query <- "
MATCH (p:Person)-[r:LIKES]->(t)
RETURN p.name, [t.name, t.called] as liked_thing
"

cypher(graph, query)

brusselsprouts <- createNode(graph, "Food", called = "Brussel Sprouts")
r5 <- createRel(nicole, "Hates", icecream)

query <- "
MATCH (n)
RETURN n.name, n.called, ID(n)
"

cypher(graph, query)

query <- "
match (s)-[r]->(t)
return s.name, s.called, id(r) as rel_id, t.name, t.called
"

WHERE ID(p)=5
OPTIONAL MATCH (p)-[r]-()
DELETE p,r

query <- "
MATCH (p:Person {name: 'Nicole'}), (t:Food {called: 'Ice cream'})
CREATE (p)-[:LIKES]->(t)
"





