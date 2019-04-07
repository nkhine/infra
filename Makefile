SHELL += -eu

BLUE	:= \033[0;34m
GREEN	:= \033[0;32m
RED   := \033[0;31m
NC    := \033[0m

build: clean
	${GOPATH}/bin/dep ensure
	@echo "${GREEN}✓ eshot portion of 'make deploy' has completed ${NC}\n"
	env GOARCH=amd64 GOOS=linux go build -o ./bin/status ./src/status
	@echo "${GREEN}✓ upload portion of 'make deploy' has completed ${NC}\n"

init:
	${GOPATH}/bin/dep init -v

test:
	go test -count=1 -v ./src/status

clean:
	rm -rf build bin/* sites/khine.net/build

strip:
	strip bin/*

deploy: build strip
	sls deploy --stage $(stage) --region eu-west-1 --aws-profile $(profile) --verbose

validate: build strip
	sls deploy --noDeploy --stage $(stage) --region eu-west-1 --aws-profile $(profile) --verbose

remove: clean
	sls remove --stage $(stage) --region eu-west-1 --aws-profile $(profile) --verbose

logs:
	sls logs --stage $(stage) --region eu-west-1 --aws-profile $(profile) --function $(f)
