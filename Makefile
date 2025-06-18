# Flutter Mobile Development Makefile

.PHONY: help build run shell clean test docs android-build web-build stop logs fix-ownership

# Get current user ID and group ID
USER_ID := $(shell id -u)
GROUP_ID := $(shell id -g)

export USER_ID
export GROUP_ID

## Default target

help: ## Show this help message
    @echo "Available commands:"
    @grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

## Docker commands

build:	## Build the Docker image with proper user mapping
	@echo "Building with USER_ID=$(USER_ID) and GROUP_ID=$(GROUP_ID)"
	docker-compose build --build-arg USER_ID=$(USER_ID) --build-arg GROUP_ID=$(GROUP_ID)

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

## Ownership management

fix-ownership: ## Fix ownership of project files after Docker operations
	@echo "Fixing ownership of project files..."
	sudo chown -R $(USER_ID):$(GROUP_ID) . 2>/dev/null || \
	chown -R $(USER_ID):$(GROUP_ID) . 2>/dev/null || \
	echo "Note: Run 'sudo make fix-ownership' if you get permission errors"

check-ownership: ## Check current ownership of key files
	@echo "Current ownership of key files:"
	@ls -la pubspec.yaml android/app/build.gradle* .dart_tool 2>/dev/null || echo "Some files may not exist yet"

reset-permissions: ## Reset all permissions and ownership
	@echo "Resetting permissions and ownership..."
	sudo chown -R $(USER_ID):$(GROUP_ID) .
	sudo chmod -R u+rw .
	sudo find . -type d -exec chmod u+x {} \;

## Flutter commands (run inside container)

deps: ## Get Flutter dependencies
	docker-compose exec flutter-dev flutter pub get
	@$(MAKE) fix-ownership

test: ## Run Flutter tests
	docker-compose exec flutter-dev flutter test

analyze: ## Run Flutter analyzer
	docker-compose exec flutter-dev flutter analyze

format: ## Format Dart code
	docker-compose exec flutter-dev dart format .
	@$(MAKE) fix-ownership

## Build commands

android-debug: ## Build Android debug APK
	docker-compose exec flutter-dev flutter build apk --debug --split-per-abi
	@$(MAKE) fix-ownership
	@echo "APK built at: android/app/build/outputs/apk/debug/"

android-release: ## Build Android release APK
	docker-compose exec flutter-dev flutter build apk --release --split-per-abi
	@$(MAKE) fix-ownership
	@echo "APK built at: android/app/build/outputs/apk/release/"

web-build: ## Build for web
	docker-compose exec flutter-dev flutter build web
	@$(MAKE) fix-ownership

web-serve: ## Serve web app (accessible at http://localhost:3000)
	docker-compose exec flutter-dev flutter run -d web-server --web-port=3000 --web-hostname=0.0.0.0

## Development helpers

pub-get: deps ## Alias for deps

flutter-doctor: ## Run Flutter doctor
	docker-compose exec flutter-dev flutter doctor

upgrade: ## Upgrade Flutter dependencies
	docker-compose exec flutter-dev flutter pub upgrade
	@$(MAKE) fix-ownership

## Clean commands

flutter-clean: ## Clean Flutter build files
	docker-compose exec flutter-dev flutter clean
	@$(MAKE) fix-ownership

deep-clean: flutter-clean ## Deep clean including Docker rebuild
	@$(MAKE) clean
	@$(MAKE) build

## Setup command for new users

setup: build run deps ## Initial setup for new developers
	@echo "🎉 Setup complete!"
	@echo "Run 'make shell' to enter the development environment"
	@echo "Then run 'flutter doctor' to verify the setup"

## Quick development workflow

dev: run shell ## Start development environment and open shell

## One-command builds

quick-debug: run android-debug ## Quick Android debug build

quick-release: run android-release ## Quick Android release build

## Local development (without Docker)

local-deps: ## Get dependencies locally (without Docker)
	flutter pub get

local-build-debug: ## Build debug APK locally
	flutter build apk --debug --split-per-abi

local-build-release: ## Build release APK locally
	flutter build apk --release --split-per-abi

local-clean: ## Clean local Flutter build
	flutter clean

## Documentation

docs: ## Generate documentation
	docker-compose exec flutter-dev dart doc --output docs/api
	@$(MAKE) fix-ownership

## Troubleshooting

doctor: ## Run comprehensive health check
	@echo "=== Docker Environment ==="
	docker-compose exec flutter-dev flutter doctor -v
	@echo ""
	@echo "=== Permissions Check ==="
	@$(MAKE) check-ownership

troubleshoot: ## Full troubleshooting guide
	@echo "=== Flutter Mobile Development Troubleshooting ==="
	@echo ""
	@echo "1. Permission Issues:"
	@echo "   Run: make fix-ownership"
	@echo ""
	@echo "2. Docker Issues:"
	@echo "   Run: make clean && make build && make run"
	@echo ""
	@echo "3. Flutter Issues:"
	@echo "   Run: make shell"
	@echo "   Then: flutter clean && flutter pub get"
	@echo ""
	@echo "4. Local vs Docker conflicts:"
	@echo "   Run: make reset-permissions"
	@echo ""
	@$(MAKE) check-ownership
