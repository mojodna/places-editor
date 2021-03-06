# See the README for installation instructions.

all: \
	dist/iD.css \
	dist/iD.js \
	dist/iD.min.js \
	dist/presets.js \
	dist/imagery.js \
	dist/img/line-presets.png \
	dist/img/relation-presets.png

DATA_FILES = $(shell find data -type f -name '*.json' -o -name '*.md')
data/data.js: $(DATA_FILES) dist/locales/en.json dist/img/maki-sprite.png data/presets/presets.json data/presets/defaults.json data/presets/categories.json data/presets/fields.json
	@echo "----< $@ >----"
	node build.js

dist/locales/en.json: data/core.yaml data/presets.yaml data/presets/presets.json data/presets/defaults.json data/presets/categories.json data/presets/fields.json
	@echo "----< $@ >----"
	node build.js

npmap:
	@echo "----< $@ >----"
	node npmapInstall.js

dist/iD.js: \
	js/lib/bootstrap-tooltip.js \
	js/lib/d3.v3.js \
	js/lib/d3.combobox.js \
	js/lib/d3.geo.tile.js \
	js/lib/d3.jsonp.js \
	js/lib/d3.keybinding.js \
	js/lib/d3.one.js \
	js/lib/d3.dimensions.js \
	js/lib/d3.trigger.js \
	js/lib/d3.typeahead.js \
	js/lib/d3.curtain.js \
	js/lib/d3.value.js \
	js/lib/diff3.js \
	js/lib/jxon.js \
	js/lib/lodash.js \
	js/lib/osmauth.js \
	js/lib/rbush.js \
	js/lib/sexagesimal.js \
	js/lib/togeojson.js \
	js/lib/marked.js \
	js/id/start.js \
	js/id/id.js \
	js/id/npmap.js \
	js/id/services/*.js \
	js/id/util.js \
	js/id/util/*.js \
	js/id/geo.js \
	js/id/geo/*.js \
	js/id/actions.js \
	js/id/actions/*.js \
	js/id/behavior.js \
	js/id/behavior/*.js \
	js/id/modes.js \
	js/id/modes/*.js \
	js/id/operations.js \
	js/id/operations/*.js \
	js/id/core/*.js \
	js/id/renderer/*.js \
	js/id/svg.js \
	js/id/svg/*.js \
	js/id/ui.js \
	js/id/ui/*.js \
	js/id/ui/preset/*.js \
	js/id/ui/intro/*.js \
	js/id/presets.js \
	js/id/presets/*.js \
	js/id/validate.js \
	js/id/end.js \
	js/lib/locale.js \
	data/introGraph.js

.INTERMEDIATE dist/iD.js: data/data.js

dist/iD.js: npmap node_modules/.install Makefile
	@echo "----< $@ >----"
	@rm -f $@
	cat $(filter %.js,$^) > $@

dist/iD.min.js: dist/iD.js Makefile
	@echo "----< $@ >----"
	@rm -f $@
	node_modules/.bin/uglifyjs $< -c -m -o $@

dist/iD.css: css/*.css dist/img/maki-sprite.png
	@echo "----< $@ >----"
	cat css/reset.css css/map.css css/app.css css/feature-icons.css css/nps.css> $@

node_modules/.install: package.json
	@echo "----< $@ >----"
	npm install && touch node_modules/.install

clean:
	@echo "----< $@ >----"
	rm -f dist/iD*.js dist/iD.css
	rm -f dist/img/maki-sprite.png css/img/maki-sprite.png
	rm -f dist/img/npmaki-sprite.png css/img/npmaki-sprite.png
	rm -f data/presets.yaml data/presets/fields.json data/presets/categories.json data/presets/presets.json dist/img/relation-presets.png dist/img/line-presets.png

translations:
	@echo "----< $@ >----"
	node data/update_locales

imagery:
	@echo "----< $@ >----"
	npm install editor-imagery-index@git://github.com/osmlab/editor-imagery-index.git#gh-pages && node data/update_imagery

suggestions:
	@echo "----< $@ >----"
	npm install name-suggestion-index@git://github.com/osmlab/name-suggestion-index.git
	cp node_modules/name-suggestion-index/name-suggestions.json data/name-suggestions.json

SPRITE = inkscape --export-area-page

dist/img/line-presets.png: svg/line-presets.svg
	@echo "----< $@ >----"
	if [ `which inkscape` ]; then $(SPRITE) --export-png=$@ $<; else echo "Inkscape is not installed"; fi;

dist/img/relation-presets.png: svg/relation-presets.svg
	@echo "----< $@ >----"
	if [ `which inkscape` ]; then $(SPRITE) --export-png=$@ $<; else echo "Inkscape is not installed"; fi;

dist/img/maki-sprite.png: ./node_modules/maki/www/images/maki-sprite.png dist/img/npmaki-sprite.png
	@echo "----< $@ >----"
	node data/maki_sprite
	cp $< $@
	cp $< css/img/

dist/img/npmaki-sprite.png: ./node_modules/npmaki/www/images/maki-sprite.png
	@echo "----< $@ >----"
	cp $< $@
	cp $< css/img/npmaki-sprite.png

data/presets/presets.json:
	@echo "----< $@ >----"
	@echo "{}" > $@

data/presets/categories.json:
	@echo "----< $@ >----"
	@echo "{}" > $@

data/presets/fields.json:
	@echo "----< $@ >----"
	@echo "{}" > $@

data/presets.yaml:
	@echo "----< $@ >----"
	@echo "" > $@

D3_FILES = \
	node_modules/d3/src/start.js \
	node_modules/d3/src/arrays/index.js \
	node_modules/d3/src/behavior/behavior.js \
	node_modules/d3/src/behavior/zoom.js \
	node_modules/d3/src/core/index.js \
	node_modules/d3/src/event/index.js \
	node_modules/d3/src/geo/mercator.js \
	node_modules/d3/src/geo/path.js \
	node_modules/d3/src/geo/stream.js \
	node_modules/d3/src/geom/polygon.js \
	node_modules/d3/src/geom/hull.js \
	node_modules/d3/src/selection/index.js \
	node_modules/d3/src/transition/index.js \
	node_modules/d3/src/xhr/index.js \
	node_modules/d3/src/end.js

js/lib/d3.v3.js: $(D3_FILES)
	echo "----< $@ >----"
	node_modules/.bin/smash $(D3_FILES) > $@
	@echo 'd3 rebuilt. Please reapply 7e2485d, 4da529f, and 223974d'

js/lib/lodash.js:
	node_modules/.bin/lodash --debug --output $@ include="any,assign,bind,clone,compact,contains,debounce,difference,each,every,extend,filter,find,first,forEach,groupBy,indexOf,intersection,isEmpty,isEqual,isFunction,keys,last,map,omit,pairs,pluck,reject,some,throttle,union,uniq,unique,values,without,flatten,value,chain,cloneDeep,merge,pick,reduce" exports="global,node"
