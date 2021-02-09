PYTHON ?= python

all:

alltests: test coverage typecheck testqml

test:
	PYTHONPATH=./qml/components python3 -m pytest --flake8 --benchmark-disable

testqml:
	qmllint qml/*.qml
	qmllint qml/components/*.qml
	qmllint qml/pages/*.qml
	qmllint qml/cover/*.qml

coverage:
	PYTHONPATH=./qml/components python3 -m pytest --cov=python --benchmark-disable

typecheck:
	mypy --ignore-missing-imports --warn-redundant-casts qml/components
