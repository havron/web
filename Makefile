.PHONY: server build commit-deploy cs.cornell.edu havron.xyz clean
$V.SILENT:
THEME=cocoa-eh
cm=":pencil::octocat:"
DISTRIBUTION_ID=E21GS4JRVEWGVS
RSYNCARGS = --compress --recursive --checksum --itemize-changes \
	--delete -e ssh
RSYNCUSER = sgh65@cslinux
RSYNCDEST = /people/sgh65/

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
	@#nmcli con show --active | grep -q tun0 || sudo vpnc-connect
	curl -s -o /dev/null -w "%{http_code}" http://cuonly.$@/ | grep -q 200 || sudo vpnc-connect
	@echo "Building content for $@..."
	sed -i 's/.*baseurl.*/baseurl = "https:\/\/www.$@\/~havron\/"/g' config.toml
	hugo --theme=$(THEME)
	@echo "Deploying $@..."
	rsync $(RSYNCARGS) public/ $(RSYNCUSER).$@:$(RSYNCDEST)
	@echo "Deployed $@"

havron.xyz: clean
	@echo "Building content for $@..."
	sed -i 's/.*baseurl.*/baseurl = "https:\/\/$@\/"/g' config.toml
	hugo --theme=$(THEME)
	@echo "Deploying $@..."
	aws s3 cp --recursive --acl public-read --sse AES256 public/ s3://$@/ 
	aws s3 sync --acl public-read --sse AES256 public/ s3://$@/ --delete
	aws cloudfront create-invalidation --distribution-id ${DISTRIBUTION_ID} --paths /\*
	@echo "Deployed $@"
	@ # ^^^ not ideal! should only invalidate modified files...

clean:
	rm -rf public/
