.PHONY: serve build commit-deploy
THEME=cocoa-eh
cm=updates to `git diff --cached --name-only`

serve:
	hugo server --theme=$(THEME) --watch --buildDrafts

build:
	hugo --theme=$(THEME)

commit-deploy:
	git add .
	git commit -m "${cm}"
	git push origin master
	@echo "Travis build will be triggered shortly, viewable at: https://travis-ci.org/havron/min"
