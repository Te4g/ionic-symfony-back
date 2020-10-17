##
## Project
## -------
##

install: ## Install project
	# Download the latest versions of the pre-built images.
	docker-compose pull
	# Rebuild images.
	docker-compose up --build -d

kill:
	docker-compose kill
	docker-compose down --volumes --remove-orphans

reset: ## Stop and start a fresh install of the project
reset: kill install

start: ## Start the project
	docker-compose up -d --remove-orphans --no-recreate

stop: ## Stop the project
	docker-compose stop

clean: ## Stop the project and remove generated files
clean: kill
	rm -rf .env.local vendor node_modules

##
## Back specific
## -----
##
back-ssh: ## Connect to the container in ssh
	docker exec -it php sh

db: ## Reset the database and load fixtures
	docker-compose exec php bin/console doctrine:database:drop --if-exists --force
	docker-compose exec php bin/console doctrine:database:create --if-not-exists
	docker-compose exec php bin/console doctrine:migrations:migrate --no-interaction --allow-no-migration
	docker-compose exec php bin/console hautelook:fixtures:load --no-interaction --purge-with-truncate

db-reset-fixtures: ## Reload fresh fixtures
	docker-compose exec php bin/console hautelook:fixtures:load --no-interaction --purge-with-truncate

db-schema-validate: ## Validate the doctrine ORM mapping
	docker-compose exec php bin/console doctrine:schema:validate

migration: ## Generate a new doctrine migration
	docker-compose exec php bin/console doctrine:migrations:diff

cc: ## Clear cache
	docker-compose exec php bin/console c:c

##
## Front specific
## -----
##
front-ssh: ## Connect to the container in ssh
	docker exec -it client sh

front-lint: ## Run Webpack Encore to compile assets
	docker-compose exec client yarn lint --fix

##
## Tests
## -----
##
phpunit: ## Run unit tests
	docker-compose exec php ./vendor/bin/simple-phpunit

##
## Quality assurance
## -----------------
##
cs-fix: ## apply php-cs-fixer fixes
	docker-compose exec php ./vendor/bin/php-cs-fixer fix

stan: ## Run php stan
	docker-compose exec php ./vendor/bin/phpstan analyse src tests --level 5

tests: ## Run php stan + cs-fix + phpunit
	docker-compose exec php ./vendor/bin/php-cs-fixer fix
	docker-compose exec php ./vendor/bin/phpstan analyse src tests --level 5
	docker-compose exec php ./vendor/bin/simple-phpunit

eslint: ## eslint (https://eslint.org/)
eslint: node_modules
	$(EXEC_JS) node_modules/.bin/eslint --fix-dry-run assets/js/**

.DEFAULT_GOAL := help
help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
.PHONY: help