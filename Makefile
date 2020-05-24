SERVICE_NAME=hello-world-printer
DOCKER_IMG_NAME=$(SERVICE_NAME)
.PHONY: test
.DEFAULT_GOAL := test

deps:
	pip install -r requirements.txt; \
	pip install -r test_requirements.txt

lint:
	flake8 hello_world

run:
	PYTHONPATH=. FLASK_APP=hello_world flask run

test:
	PYTHONPATH=. py.test --verbose -s

docker_build:
	docker build -t $(DOCKER_IMG_NAME) .

docker_run: docker_build
	docker run \
	--name $(SERVICE_NAME)-dev \
	-p 5000:5000 \
	-d $(DOCKER_IMG_NAME)

docker_stop:
	docker stop $(SERVICE_NAME)-dev

USERNAME=atesterwsb
TAG=$(USERNAME)/hello-world-printer

docker_push: docker_build
	@docker login --username $(USERNAME) --password $${DOCKER_PASSWORD}; \
	docker tag hello-world-printer $(TAG); \
	docker push $(TAG); \
	docker logout;

test_cov:
	PYTHONPATH=. py.test --verbose -s --cov=.

test_xunit:
	PYTHONPATH=. py.test -s --cov=. --cov-report xml --junit-xml=test_results.xml
