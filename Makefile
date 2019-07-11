.DEFAULT_GOAL := help

.PHONY: build-js build-js-min
.PHONY: test lint check
.PHONY: install-linters format
.PHONY: fix-skycoin-dep help
.PHONY: test-js

build-js: ## Build /skycoin/skycoin.go. The result is saved in the repo root
	go build -o gopherjs-tool go/vendor/github.com/gopherjs/gopherjs/tool.go
	GOOS=linux ./gopherjs-tool build go/skycoin/skycoin.go -o js/skycoin.js

build-js-min: ## Build /skycoin/skycoin.go. The result is minified and saved in the repo root
	go build -o gopherjs-tool go/vendor/github.com/gopherjs/gopherjs/tool.go
	GOOS=linux ./gopherjs-tool build go/skycoin/skycoin.go -m -o js/skycoin.js

test-js: ## Run the Go tests using JavaScript
	go build -o gopherjs-tool go/vendor/github.com/gopherjs/gopherjs/tool.go
	cd go && ./gopherjs-tool test ./skycoin/ -v

test-suite-ts: ## Run the ts version of the cipher test suite. Use a small number of test cases
	cd js && npm run test

test-suite-ts-extensive: ## Run the ts version of the cipher test suite. All the test cases
	cd js && npm run test-extensive

test:
	cd go && go test ./... -timeout=10m -cover

lint: ## Run linters. Use make install-linters first.
	go env -json
	cd go && vendorcheck ./...
	go env -json
	golangci-lint run -c ./.golangci.yml ./go/...
	@# The govet version in golangci-lint is out of date and has spurious warnings, run it separately
	cd go && go vet -all ./...

check: lint test ## Run tests and linters

install-linters: ## Install linters
	go get -u github.com/FiloSottile/vendorcheck
	# For some reason this install method is not recommended, see https://github.com/golangci/golangci-lint#install
	# However, they suggest `curl ... | bash` which we should not do
	go get -u github.com/golangci/golangci-lint/cmd/golangci-lint

format: ## Formats the code. Must have goimports installed (use make install-linters).
	goimports -w -local github.com/skycoin/skycoin-lite ./skycoin
	goimports -w -local github.com/skycoin/skycoin-lite ./liteclient
	goimports -w -local github.com/skycoin/skycoin-lite ./mobile

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
