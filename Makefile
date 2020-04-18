.PHONY: test

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
	docker build -t hello-world-printer .
