LIBDIR := lib
include $(LIBDIR)/main.mk

$(LIBDIR)/main.mk:
ifneq (,$(shell grep "path *= *$(LIBDIR)" .gitmodules 2>/dev/null))
	git submodule sync
	git submodule update $(CLONE_ARGS) --init
else
	git clone -q --depth 10 $(CLONE_ARGS) \
	    -b main https://github.com/martinthomson/i-d-template $(LIBDIR)
endif

rfc-http-validate ?= rfc-http-validate.py
.PHONY: http-lint
http-lint: $(drafts_xml) http-lint-install
	$(rfc-http-validate) $(filter-out http-lint-install,$^)

.PHONY: http-lint-install
http-lint-install:
	@hash rfc-http-validate.py 2>/dev/null || pip3 install rfc-http-validate