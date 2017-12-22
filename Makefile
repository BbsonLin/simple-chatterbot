app:
	rm -rf public/
	pip install -r requirements.txt
	cd frontend && yarn install --force && yarn build
	mkdir public && mkdir public/templates/
	cp -rf frontend/dist/static/ public/
	cp -rf frontend/dist/index.html public/templates/
	cp -rf app.py public/ && python public/app.py
