.PHONY: fmt-check
fmt-check:
	terraform fmt -recursive -check

.PHONY: fmt-write
fmt-write:
	terraform fmt -recursive

PHONY: lint
lint:
	for d in ./*/*/ ; do (tflint -f compact `$d`); done && for d in ./*/ ; do (tflint -f compact `$d`); done

