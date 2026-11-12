# ArchiMate RDF alignment contribution

**Contributor:** Jan Willem van Veen (`jwvveen`)  
**Source:** https://github.com/jwvveen/archimate-rdf  
**Issues:** [#2](https://github.com/archimate-rdf-community/discussions/issues/2), [#4](https://github.com/archimate-rdf-community/discussions/issues/4), [#7](https://github.com/archimate-rdf-community/discussions/issues/7)  
**Status:** Draft candidate mappings for community review; not an independently validated conformance claim.

## Files and scope

The companion [`archimate-alignments.ttl`](archimate-alignments.ttl) is a snapshot of the [upstream generated alignment](https://github.com/jwvveen/archimate-rdf/blob/main/archimate-alignments.ttl). It contains **81 mappings** to Alberto D. Mendoza's ArchiMate 3.2 ontology (`https://purl.org/archimate#`) and **68 mappings** to bp4mc2 archimate2rdf (`http://bp4mc2.org/def/archimate#`). These counts indicate generated mappings, **not validated specification coverage**.

The upstream generator is [`scripts/generate_alignments.py`](https://github.com/jwvveen/archimate-rdf/blob/main/scripts/generate_alignments.py). It uses matching term names for many candidate `skos:exactMatch` statements, and hand-defined naming correspondences for certain `skos:closeMatch` statements. **These mapping types require semantic review:** matching labels or local names do not establish identical OWL semantics, and SKOS mapping properties do not entail `owl:equivalentClass` or `owl:equivalentProperty`.

## ArchiMate 3.2 versus ArchiMate 4.0

The [`archimate.ttl` 4.0 core](https://github.com/jwvveen/archimate-rdf/blob/main/archimate.ttl) introduces layer-generic `Process`, `Function`, `Service`, `Event`, `Role`, and `Collaboration` classes. The [`archimate-profile-3.2.ttl` compatibility profile](https://github.com/jwvveen/archimate-rdf/blob/main/archimate-profile-3.2.ttl) retains specific 3.2 classes:

```turtle
@prefix am: <https://w3id.org/archimate#> .
@prefix owl: <http://www.w3.org/2002/07/owl#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

am:BusinessProcess a owl:Class ;
    rdfs:subClassOf am:Process ;
    am:defaultLayer am:BusinessLayer .
```

A 3.2 specification concept `BusinessProcess` is not an exact match to the more general 4.0 specification concept `Process`: the business-layer information must also be preserved. A mapping between two implementations' explicitly **3.2-specific** `BusinessProcess` classes is a different candidate and must be reviewed on its own terms. Removed or deprecated 3.2 constructs (e.g., `Representation`, `Gap`, interaction variants) must not be counted as native 4.0 concepts.

## Conceptual alignment versus RDF representation mapping

In `archimate-rdf`, ArchiMate relationships are first-class resources:

```turtle
@prefix am: <https://w3id.org/archimate#> .
@prefix ex: <https://example.org/model/> .

ex:relation1 a am:Serving ;
    am:source ex:applicationService ;
    am:target ex:businessProcess .
```

A direct triple such as `ex:applicationService am:serves ex:businessProcess` is a **derived convenience representation**. Other RDF vocabularies may primarily use direct RDF predicates. Conceptual agreement does not imply that a class and a property are structurally equivalent.

A transformation must account for relationship type, direction, source and target, relationship identity where present, parallel relationships, attributes, junctions, and relationships as endpoints. Keep **specification concept alignment** separate from **instance-level representation transformations**.

## Suggested community mapping record

| Field | Meaning |
| --- | --- |
| Specification concept IRI | Implementation-independent reference |
| Specification version | ArchiMate 3.2 or 4.0 |
| Implementation term IRI | Term from a pinned ontology revision |
| RDF term kind | Class, property, individual, other |
| Assessed mapping | Exact, close, broader/narrower, conditional or none |
| Status | Current, legacy/deprecated or extension |
| Transformation rule | E.g., preserve 3.2 layer when mapping to generic 4.0 type |
| Provenance | Source commit, specification reference, reviewer |

Conditional mappings may require a mapping resource with a transformation description rather than a single SKOS triple.

## Proposed review and conformance checks

1. **Syntax:** Parse both contributed Turtle and the community inventory before running conformance queries. The current `conceptInventory.ttl` contains an undeclared `jw:` prefix (it declares `jw4:`) and incomplete statements such as `spec:Model .`.
2. **Inventory completeness:** Establish the normative concept list independently of any one RDF ontology before claiming full coverage.
3. **IRI existence:** Verify mapped terms in pinned versions of each ontology.
4. **Semantic review:** Reassess automatically generated `exactMatch` links, class/property differences, hierarchy changes, and version-dependent concepts.
5. **Behavioral tests:** Use shared models with parallel typed relationships, relationships pointing to relationships, junctions, and 3.2-to-4.0 migrations. Compare relationship validity against **the same specification version**.
6. **Transformation assessment:** Record whether a conversion is lossless, lossy or unsupported; vocabulary coverage alone does not demonstrate interoperability.

The current [`conformanceTests.rq`](conformanceTests.rq) selects `rdfs:Class`, which would not cover specification entries declared solely as `skos:Concept`. Align the query with the inventory's agreed RDF modeling pattern.

## Integration proposal

Keep [`conceptInventory.ttl`](conceptInventory.ttl) independent of any implementation. Use the contributed mapping file as **candidate input** for the `w3id.org/archimate` mapping column after agreeing on stable specification concept IRIs, version metadata and mapping semantics. Preserve autonomous ontologies, document exceptions and conditional transformations explicitly, and add reproducible conformance tests in CI.

**Goal:** Shared version-aware ArchiMate semantics, independently governed RDF vocabularies and executable interoperability evidence.
