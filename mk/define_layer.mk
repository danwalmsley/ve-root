MAKEFILE_LIST:=$(filter-out $(lastword $(MAKEFILE_LIST)), $(MAKEFILE_LIST))
LBASE:=$(realpath $(dir $(lastword $(MAKEFILE_LIST))))
LFILE:=$(realpath $(lastword $(MAKEFILE_LIST)))

ifeq ($(LAYER),)
$(error ERROR: LAYER not defined in $(LFILE))
endif

$(eval L:=L_$(LAYER))
$(eval T:=T_$(LAYER))

LSTAMP:=$(STAMP)/$(L)
.PHONY: $(L)

$(eval BUILD_$(LAYER):=$(BUILD)/$(L))

$(eval BASE_$(LAYER):=$(LBASE))

$(eval SRC_$(LAYER):=$(SOURCE)/$(L))

$(eval depend_previous:=$(lastword $(recipe)))

$(eval recipe += $(L))

.PHONY: $(L).clean

define layer_invalidate
.PHONY: $(L).invalidate $(L).i
$(L).invalidate $(L).i:
	rm -rf $$($(L))

$(L).clean: | $(L).invalidate
$(L).clean: builddir:=$(BUILD_$(LAYER))
$(L).clean: srcdir:=$(SRC_$(LAYER))
$(L).clean: basedir:=$(BASE_$(LAYER))
endef

$(eval $(layer_invalidate))

DEPENDS:=
RUNAFTER:=
