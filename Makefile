.DEFAULT_GOAL := help

today  = $(shell date "+%Y%m%d")
product_name = update_completions
gpg_pub_key = CCAA9E0638DF9088BB624BC37C0F8AD3FB3938FC

## Create a patch and copy it to windows
.PHONY : patch
patch : clean diff-patch copy2win-patch

## Create a GPG-encrypted patch and copy it to Windows
.PHONY : gpg-patch
gpg-patch : clean diff-patch-gpg copy2win-patch-gpg

## Create a patch
.PHONY : diff-patch-raw
diff-patch-raw :
	bash utils/create-patch.sh

## Create a GPG-encrypted patch
.PHONY : diff-patch-gpg
diff-patch-gpg :
	echo "THIS IS WIP"
	#bash utils/create-patch.sh --use-gpg
	#git diff origin/master | gpg --encrypt --recipient $(gpg_pub_key) > $(product_name).$(today).patch.gpg

## Create a patch
.PHONY : diff-patch
diff-patch : diff-patch-raw

## Create a patch branch
.PHONY : patch-branch
patch-branch :
	git switch -c patch-$(today)

## Switch to master branch
.PHONY : switch-master
switch-master :
	git switch master

## Delete patch branch
.PHONY : delete-branch
delete-branch : clean switch-master
	git branch --list "patch*" | xargs -n 1 git branch -D

## Run clean
.PHONY : clean
clean :
	bash utils/clean.sh

## Run install
.PHONY : install
install : clean
	bash utils/install.sh

## Copy patch to Windows
.PHONY : copy2win-patch-raw
copy2win-patch-raw :
	cp *.patch $$WIN_HOME/Downloads/

## Copy GPG-encrypted patch to Windows
.PHONY : copy2win-patch-gpg
copy2win-patch-gpg :
	cp *.patch.gpg $$WIN_HOME/Downloads/

## Copy patch to Windows
.PHONY : copy2win-patch
copy2win-patch : copy2win-patch-raw

## Run tests
.PHONY : test
test : lint

## Run lints
.PHONY : lint
lint : textlint typo-check shell-lint

## Run textlint
.PHONY : textlint
textlint :
	pnpm run textlint

## Run typos
.PHONY : typo-check
typo-check :
	typos .

## Run shellcheck
.PHONY : shell-lint
shell-lint :
	bash utils/lint.sh

## Run format
.PHONY : fmt
fmt : format

## Run format
.PHONY : format
format : shell-format

## Run shfmt
.PHONY : shell-format
shell-format :
	bash utils/format.sh

## Add commit message up to `origin/master` to CHANGELOG.md
.PHONY : changelog
changelog :
	bash utils/changelog.sh

## Run git cleanfetch
.PHONY : clean-fetch
clean-fetch :
	bash utils/git-clean-fetch.sh

## Run git pull
.PHONY : pull
pull :
	git pull

## Run workday morning routine
.PHONY : morning-routine
morning-routine : clean-fetch delete-branch pull patch-branch

## Show help
.PHONY : help
help :
	@make2help $(MAKEFILE_LIST)
