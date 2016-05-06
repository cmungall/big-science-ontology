T = imports.owl
all: $(T) cat

%.jsonld: %.yaml
	yaml2json.pl $< > $@
.PRECIOUS: %.jsonld

%.nt: %.jsonld context.jsonld
	riot --base=http://purl.obolibrary.org/obo/ --strict --check -q  $< > $@.tmp && mv $@.tmp $@ && egrep '(WARN|ERROR)' $@ && exit 1 || echo ok

%.ttl: %.nt
	rdfcat -out ttl $< > $@.tmp && mv $@.tmp $@

%.owl: %.nt
	rdfcat -out RDF/XML $< > $@.tmp && mv $@.tmp $@


cat:
	cat $(T)
