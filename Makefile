# Flutter Mobile Development Makefile

.PHONY: help build run shell clean test docs android-build web-build stop logs

## Default target

help: ## Show this help message
    @echo "Available commands:"
    @grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

## Docker commands

build:	## Build the Docker image
	docker-compose build

run: ## Start the development environment
	@echo "Starting Flutter development environment..."
	docker-compose up -d
	@echo "Environment started. Use 'make shell' to enter the container."

shell: ## Open a shell in the container
	docker-compose exec flutter-dev bash

stop: ## Stop the development environment
	docker-compose down

logs: ## Show container logs
	docker-compose logs -f flutter-dev

clean: ## Clean Docker containers and images
	docker-compose down -v
	docker system prune -f

## Flutter commands (run inside container)

deps: ## Get Flutter dependencies
	docker-compose exec flutter-dev flutter pub get

test: ## Run Flutter tests
	docker-compose exec flutter-dev flutter test

analyze: ## Run Flutter analyzer
	docker-compose exec flutter-dev flutter analyze

format: ## Format Dart code
	docker-compose exec flutter-dev dart format .

## Build commands

android-debug: ## Build Android debug APK
	docker-compose exec flutter-dev flutter build apk --debug

android-release: ## Build Android release APK
	docker-compose exec flutter-dev flutter build apk --release

web-build: ## Build for web
	docker-compose exec flutter-dev flutter build web

web-serve: ## Serve web app (accessible at http://localhost:3000)
	docker-compose exec flutter-dev flutter run -d web-server --web-port=3000 --web-hostname=0.0.0.0

## Documentation

docs: ## Generate documentation
	docker-compose exec flutter-dev dart doc --output docs/api

## Development helpers

pub-get: deps ## Alias for deps

flutter-doctor: ## Run Flutter doctor
	docker-compose exec flutter-dev flutter doctor

upgrade: ## Upgrade Flutter dependencies
	docker-compose exec flutter-dev flutter pub upgrade

## Clean commands

flutter-clean: ## Clean Flutter build files
	docker-compose exec flutter-dev flutter clean

## Setup command for new users

setup: build run ## Initial setup for new developers
	@echo "🎉 Setup complete!"
	@echo "Run 'make shell' to enter the development environment"
	@echo "Then run 'flutter doctor' to verify the setup"

## Quick development workflow

dev: run shell ## Start development environment and open shell

## One-command build

quick-build: run android-debug ## Quick Android debug build
