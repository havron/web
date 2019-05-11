.PHONY: serve build cu-pages commit-deploy
THEME=cocoa-eh
RSYNCARGS := --compress --recursive --checksum --itemize-changes \
	--delete -e ssh
CU := sgh65@cslinux.cs.cornell.edu:/people/sgh65/
cm=":pencil:"

serve:
	hugo server --theme=$(THEME) --watch --buildDrafts

build:
	hugo --theme=$(THEME)

cu-pages: 
	# vpnc-connect, first, if not on campus
	hugo --theme=$(THEME) --config config.cu.toml
	rsync $(RSYNCARGS) public/ $(CU)

commit-deploy:
	git add .
	git commit -m "${cm}"
	git push origin master
	@echo "Travis build will be triggered shortly, viewable at: https://travis-ci.org/havron/min"

clean:
	rm -rf public/
