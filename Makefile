BIN = dochroot

all: clean lint test

test: testdeps
	go test -v ./...

build: deps
	go build -o $(BIN) ./cmd

LINT_RET = .golint.txt
lint: testdeps
	go vet
	rm -f $(LINT_RET)
	golint ./... | tee .golint.txt
	test ! -s $(LINT_RET)

deps:
	go get -d -v ./...

testdeps:
	go get -d -v -t .
	go get golang.org/x/tools/cmd/vet
	go get github.com/golang/lint/golint
	go get golang.org/x/tools/cmd/cover
	go get github.com/axw/gocov/gocov
	go get github.com/mattn/goveralls

clean:
	rm -fr build
	go clean

cover: testdeps
	goveralls

.PHONY: test build lint deps testdeps clean cover