today = $(shell date "+%Y%m%d")
product_name = update_completions

.PHONY : patch
patch : clean diff-patch copy2win

.PHONY : diff-patch
diff-patch :
	git diff origin/master > $(product_name).$(today).patch

.PHONY : patch-branch
patch-branch :
	git switch -c patch-$(today)

.PHONY : copy2win
copy2win :
	cp *.patch $$WIN_HOME/Downloads/

.PHONY : clean
clean :
	rm -f fmt-*
	rm -f *.patch

.PHONY : install
install :
	bash ./install.sh

.PHONY : lint
lint :
	shellcheck ./*.sh

.PHONY : test
test : lint

.PHONY : format
format :
	bash ./format.sh

.PHONY : fmt
fmt : format
