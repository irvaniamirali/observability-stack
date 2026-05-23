.PHONY: help up down restart logs status clean backup

help: ## Show this help message
	@grep -E '^[a-z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-18s %s\n", $$1, $$2}'

up: ## Start all monitoring services
	docker-compose up -d
	@echo "Prometheus: http://localhost:9090"
	@echo "Grafana:    http://localhost:3000 (admin/admin)"
	@echo "AlertManager: http://localhost:9093"

down: ## Stop all services
	docker-compose down

restart: down up ## Restart all services

logs: ## View live logs from all services
	docker-compose logs -f

status: ## Show container status
	docker-compose ps

clean: down ## Remove containers and volumes
	docker-compose down -v

backup: ## Export Grafana dashboards
	@mkdir -p backups
	docker exec grafana curl -s -u admin:admin http://localhost:3000/api/search > backups/dashboards-$$(date +%Y%m%d-%H%M%S).json
