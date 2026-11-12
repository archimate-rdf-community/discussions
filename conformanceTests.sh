PREFIX spec:  <urn:archimate:spec:>
PREFIX skos:  <http://www.w3.org/2004/02/skos/core#>
PREFIX rdfs:  <http://www.w3.org/2000/01/rdf-schema#>

# Find spec concepts with NO mapping to a given namespace
# Run once per namespace — swap the filter string for w3id.org/archimate#, meta.linked.archi/archimate3/, etc. 
# An empty result set means full coverage. Any rows returned are gaps.

SELECT ?specConcept WHERE {
  ?specConcept a rdfs:Class .
  FILTER(STRSTARTS(STR(?specConcept), STR(spec:)))
  
  FILTER NOT EXISTS {
    ?specConcept skos:exactMatch|skos:closeMatch ?mapped .
    FILTER(STRSTARTS(STR(?mapped), "https://purl.org/archimate#"))
  }
}
