
cur_dir:=$(realpath .)
toolchain_dir:=$(realpath ./riscv-gnu-toolchain)

NUM_BUILD_THREADS:=$(shell nproc)
OUTPUT_DIR?=$(cur_dir)/output
TOOLCHAIN_TAR?=riscv-unknown-elf.tar.gz

all: $(TOOLCHAIN_TAR)

$(TOOLCHAIN_TAR): riscv-toolchain
	tar czf $@ --directory=$(OUTPUT_DIR) .

riscv-toolchain: | $(OUTPUT_DIR)
	cd $(toolchain_dir) && \
		./configure --prefix=$(OUTPUT_DIR) \
		--enable-multilib \
		--with-cmodel=medany
	cd $(toolchain_dir) && \
		make -j$(NUM_BUILD_THREADS)

$(OUTPUT_DIR):
	mkdir $(OUTPUT_DIR)
