TOP:=$(shell cd ../..; pwd)

EXTRACT=$(TOP)/common/scripts/sts_extract.pl
INSERT=$(TOP)/common/scripts/sts_insert.pl

GENERATED=$(TOP)/generated

FILES_WITH_GEN_CODE += $(TOP)/rtl/cores/nanorv32_parameters.v
FILES_WITH_GEN_CODE += $(TOP)/rtl/cores/nanorv32.v
FILES_WITH_GEN_CODE += $(TOP)/rtl/cores/nanorv32_urom.v
FILES_WITH_GEN_CODE += $(TOP)/rtl/cores/nanorv32_decoder.v
FILES_WITH_GEN_CODE += $(TOP)/rtl/cores/nanorv32_csr.v
FILES_WITH_GEN_CODE += $(TOP)/common/spec/nanorv32_simulator.py
FILES_WITH_GEN_CODE += $(TOP)/common/spec/inst_decod.py
# FILES_WITH_GEN_CODE += $(TOP)/hdl/sync/j2_core.v


gen_files:
	python nanorv32_gen.py

extract:
	$(foreach FILE, $(FILES_WITH_GEN_CODE), $(EXTRACT) --output_dir=$(GENERATED) $(FILE); )

insert:
	$(foreach FILE, $(FILES_WITH_GEN_CODE), $(INSERT) --input_dir=$(GENERATED) $(FILE); )

emacs_auto:
	emacs --batch   $(TOP)/rtl/cores/nanorv32_decoder.v -f verilog-batch-auto

# AHB Multilayer interconnect
# Note : sbt must be in the PATH
ahbmli:
	make -C $(TOP)/ml-ahb-gen all JSON=$(TOP)/common/spec/nanorv32_ahbmli.json
	cp $(TOP)/ml-ahb-gen/chisel/Ahbmli.v $(TOP)/rtl/ips
	sed -i "s/SYNTHESIS/AHBMLI_SYNTHESIS/" $(TOP)/rtl/ips/Ahbmli.v
	cd $(TOP)/rtl/ips && $(TOP)/common/scripts/hdl_splitlib.pl $(TOP)/rtl/ips/Ahbmli.v


check_simu:
	@cat $(TOP)/common/instructions/rv32e_base.txt | xargs -n1 -IXXX  ./nanorv32_simulator.py  --hex2=../../sim/verilog/XXX.hex2

test1:
	$(TOP)/common/scripts/hdl_splitlib.pl $(TOP)/rtl/ips/Ahbmli.v
