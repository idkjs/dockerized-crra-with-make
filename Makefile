IMAGE_NAME     := reason-web

install:
	@yarn install

start:
	@yarn run start

.started:
	@docker-compose build
	@docker-compose up -d
	@touch .started
	@echo "Docker containers are now running."

start-docker-image: .started

# Alias for watch
serve: watch

# Start the website on port 3000
watch: .started
	@docker-compose exec $(IMAGE_NAME) make install
	@docker-compose exec $(IMAGE_NAME) make start

stop:
	@docker-compose kill
	@docker-compose stop
	@docker-compose down --rmi local
	@docker-compose rm -f
	-@rm .started
