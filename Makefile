PYTHON ?= python

all:

alltests: test coverage typecheck testqml

test:
	PYTHONPATH=./qml/components python3 -m pytest --flake8 --benchmark-disable

testqml:
	qmllint-qt5 qml/*.qml
	qmllint-qt5 qml/components/*.qml
	qmllint-qt5 qml/pages/*.qml
	qmllint-qt5 qml/cover/*.qml

coverage:
	PYTHONPATH=./qml/components python3 -m pytest --cov=python --benchmark-disable

typecheck:
	mypy --ignore-missing-imports --warn-redundant-casts qml/components
