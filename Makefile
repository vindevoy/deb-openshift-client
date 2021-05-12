SHELL=/bin/bash 

OKD_NAME=openshift-client
OKD_VERSION=4.7.0
OKD_REVISION=0
OKD_TS=2021-04-24-103438

NAME=$(OKD_NAME)
VERSION=$(OKD_VERSION)
ITERATION=$(OKD_REVISION)
ARCHITECTURE=all

TAR_FILE=$(OKD_NAME)-linux-$(OKD_VERSION)-$(OKD_REVISION).okd-$(OKD_TS).tar.gz
SHA_FILE=sha256sum.txt

clean: 
	rm -rf ./tmp ./src 

init: clean
	mkdir -p ./src ./target ./tmp 

download: init 
	wget https://github.com/openshift/okd/releases/download/$(OKD_VERSION)-$(OKD_REVISION).okd-$(OKD_TS)/$(TAR_FILE) -P ./tmp
	wget https://github.com/openshift/okd/releases/download/$(OKD_VERSION)-$(OKD_REVISION).okd-$(OKD_TS)/$(SHA_FILE) -P ./tmp

verify: download
	cd ./tmp && cat $(SHA_FILE) | grep $(NAME)-linux | sha256sum --check && cd ..

build: verify
	tar -zxvf ./tmp/$(TAR_FILE) -C ./src
	rm -f ./src/README.md
	fpm --input-type dir \
		--output-type deb \
		--name $(NAME) \
		--version $(VERSION) \
		--iteration $(ITERATION) \
		--architecture $(ARCHITECTURE) \
		--chdir ./src \
		--package ./target/ \
		--maintainer yves.vindevogel@asynchrone.com \
		--prefix /usr/local/bin \
		--force 

install: build 
	apt install ./target/$(NAME)_$(VERSION)-$(ITERATION)_$(ARCHITECTURE).deb

remove: 
	apt remove -y $(NAME)


