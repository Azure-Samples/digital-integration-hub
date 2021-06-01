function_dir = src/function
workflow_dir = logic

.PHONY: init
init: 
	cp .devcontainer/content/function.local.settings.json $(function_dir)/local.settings.json
	cp .devcontainer/content/function.local.settings.json $(workflow_dir)/local.settings.json
	make seed_db

.PHONY: test
test : build
	npm run test --prefix $(function_dir)

.PHONY: start
start : build
	npm run start --prefix $(function_dir)

.PHONY: clean
clean :
	rm -r $(function_dir)/node_modules
	rm -r $(function_dir)/dist

.PHONY: build
build : install
	npm run build --prefix $(function_dir)

.PHONY: install
install :
	npm install --prefix $(function_dir) & \
	wait

.PHONY: migrate_db
migrate_db : build
	npm run migrate_db --prefix $(function_dir)

.PHONY: seed_db
seed_db : migrate_db
	npm run seed_db --prefix $(function_dir)

.PHONY: remove_db
remove_db :
	dropdb postgres && createdb postgres

.PHONY: zip_it
zip_it :
	./src/zip_it.sh