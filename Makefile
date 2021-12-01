THEME=cocoa-eh
cm=":pencil::octocat:"
.PHONY: server build commit-deploy cs.cornell.edu havron.xyz clean

server:
	hugo server --theme=$(THEME) --watch --buildDrafts

build:
	hugo --theme=$(THEME)

commit-deploy: cs.cornell.edu
	git add .
	git commit -m "${cm}"
	git push origin master
	@echo "Travis build for havron.dev will be triggered shortly, viewable at: https://travis-ci.org/havron/min"

RSYNCARGS = --compress --recursive --checksum --itemize-changes \
	--delete -e ssh
RSYNCUSER = sgh65@cslinux
RSYNCDEST = /people/sgh65/
cs.cornell.edu: clean
	@#nmcli con show --active | grep -q tun0 || sudo vpnc-connect
	curl -s -o /dev/null -w "%{http_code}" http://cuonly.$@/ | grep -q 200 || sudo vpnc-connect
	@echo "Building content for $@..."
	sed -i 's/.*baseurl.*/baseurl = "https:\/\/www.$@\/~havron\/"/g' config.toml
	hugo --theme=$(THEME)
	@echo "Deploying $@..."
	rsync $(RSYNCARGS) public/ $(RSYNCUSER).$@:$(RSYNCDEST)
	@echo "Deployed $@"

RSYNCARGS = --compress --recursive --checksum --itemize-changes \
	--delete -e ssh
RSYNCUSER = sgh65@cslinux
RSYNCDEST = /people/sgh65/
cornell-redirect:
	curl -s -o /dev/null -w "%{http_code}" http://cuonly.cs.cornell.edu/ | grep -q 200 || sudo vpnc-connect
	@echo "Deploying $@..."
	rsync $(RSYNCARGS) redirect/ $(RSYNCUSER).cs.cornell.edu:$(RSYNCDEST)
	@echo "Deployed $@"

DISTRIBUTION_ID=E21GS4JRVEWGVS
havron.xyz: clean
	@echo "Building content for $@..."
	sed -i 's/.*baseurl.*/baseurl = "https:\/\/$@\/"/g' config.toml
	hugo --theme=$(THEME)
	@echo "Deploying $@..."
	aws s3 cp --recursive --acl public-read --sse AES256 public/ s3://$@/ 
	aws s3 sync --acl public-read --sse AES256 public/ s3://$@/ --delete
	aws cloudfront create-invalidation --distribution-id ${DISTRIBUTION_ID} --paths /\*
	@echo "Deployed $@"

clean:
	rm -rf public/
