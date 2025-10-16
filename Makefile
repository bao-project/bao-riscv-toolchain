
cur_dir:=$(realpath .)
toolchain_dir:=$(realpath ./riscv-gnu-toolchain)

NUM_BUILD_THREADS?=1
RV32_OUTPUT_DIR?=$(cur_dir)/riscv32-unknown-elf
RV64_OUTPUT_DIR?=$(cur_dir)/riscv64-unknown-elf
TOOLCHAIN_TAR?=riscv-unknown-elf.tar.gz

all: $(TOOLCHAIN_TAR)

$(TOOLCHAIN_TAR): riscv32-toolchain riscv64-toolchain
	tar czf $@ $(RV32_OUTPUT_DIR) $(RV64_OUTPUT_DIR)

riscv64-toolchain: | $(RV64_OUTPUT_DIR) 
	cd $(toolchain_dir) && \
		$(MAKE) distclean
	cd $(toolchain_dir) && \
		./configure --prefix=$(RV64_OUTPUT_DIR) \
		--with-arch=rv64gc \
		--with-cmodel=medany \
		--enable-multilib \
		--enable-default-pie
	cd $(toolchain_dir) && \
		$(MAKE) -j$(NUM_BUILD_THREADS) newlib linux

riscv32-toolchain: | $(RV32_OUTPUT_DIR)
	cd $(toolchain_dir) && \
		$(MAKE) distclean
	cd $(toolchain_dir) && \
		./configure --prefix=$(RV32_OUTPUT_DIR) \
		--with-arch=rv32gc \
		--with-cmodel=medany \
		--enable-multilib \
		--enable-default-pie
	cd $(toolchain_dir) && \
		$(MAKE) -j$(NUM_BUILD_THREADS) newlib linux

$(RV32_OUTPUT_DIR) $(RV64_OUTPUT_DIR):
	mkdir $@

clean:
	rm -rf $(RV32_OUTPUT_DIR) $(RV64_OUTPUT_DIR)
	$(MAKE) -C $(toolchain_dir) distclean

.PHONY: riscv32-toolchain riscv64-toolchain
