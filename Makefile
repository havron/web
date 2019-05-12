.PHONY: server build commit-deploy cs.cornell.edu havron.xyz clean
THEME=cocoa-eh
cm=":pencil::octocat:"
DISTRIBUTION_ID=EBRLR8UIL2LHP
RSYNCARGS = --compress --recursive --checksum --itemize-changes \
	--delete -e ssh
RSYNCDEST = sgh65@cslinux.cs.cornell.edu:/people/sgh65/


server:
	hugo server --theme=$(THEME) --watch --buildDrafts

build:
	hugo --theme=$(THEME)

commit-deploy: cs.cornell.edu havron.xyz
	git add .
	git commit -m "${cm}"
	git push origin master
	@echo "Travis build for havron.dev will be triggered shortly, viewable at: https://travis-ci.org/havron/min"

cs.cornell.edu: clean
	@# todo: add a check for connection to campus network before attempting to check for vpn.
	nmcli con show --active | grep -q tun0 || sudo vpnc-connect
	@echo "Building content for $@"
	sed -i 's/.*baseurl.*/baseurl = "https:\/\/www.$@\/~havron\/"/g' config.toml
	hugo --theme=$(THEME)
	@echo "Deploying $@"
	rsync $(RSYNCARGS) public/ $(RSYNCDEST)

havron.xyz: clean
	@echo "Building content for $@"
	sed -i 's/.*baseurl.*/baseurl = "https:\/\/$@\/"/g' config.toml
	hugo --theme=$(THEME)
	@echo "Deploying $@"
	aws s3 cp --recursive --acl public-read --sse AES256 public/ s3://$@/ 
	aws s3 sync --acl public-read --sse AES256 public/ s3://$@/ --delete
	aws cloudfront create-invalidation --distribution-id ${DISTRIBUTION_ID} --paths /\*
	@ # ^^^ not ideal! should only invalidate modified files...

clean:
	rm -rf public/
