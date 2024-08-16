Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0702618EBF;
	Fri, 16 Aug 2024 01:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723770025; cv=none; b=bkgvM47FRIJ17XdjdnYvwR9YGIM949sxTGQg2mjweMaQu1LY/APJJzyCBAdiV4NO7Luapx8Dk78yl6tAzw9BoMYsZwC+A4eTG4VeyApTRbrKgP7b33MQXL0xL5yhOI8XnmbDRWc8nk9fMau/yy13HLNl6aD1jUNtzTJzGqN0p5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723770025; c=relaxed/simple;
	bh=+wpXQQQV4TiocJY760Wvz00MxfgK30C4VktuhNrp8pk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sQIt04oJgbzXPK9t3WMA0J7qFPnvQo6ofkrTlm79BW25xVi3usxqm1KtNEMBYf0G83wOgBP5qTFMx8rQ75D0vxC3zroV39Ie4d0uTFJZJVEF3G/b1OhACEJHEvZONAY/1aEJ6cU5UHiVbTrbrM7M2tpkTPpEecjYEc/oIb/Hpww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WlNv672hrzcd58;
	Fri, 16 Aug 2024 09:00:02 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id A8F9B18006C;
	Fri, 16 Aug 2024 09:00:19 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 16 Aug 2024 09:00:18 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v1 3/4] selftests/landlock: Implement custom libbpf-based tracer
Date: Fri, 16 Aug 2024 08:59:42 +0800
Message-ID: <20240816005943.1832694-4-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240816005943.1832694-1-ivanov.mikhail1@huawei-partners.com>
References: <20240816005943.1832694-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 dggpemm500020.china.huawei.com (7.185.36.49)

perf trace can show imprecise values of syscalls durations. It doesn't
affect real overhead value, but it shows the wrong proportion of overhead
relative to syscall baseline duration. Moreover, using perf trace causes
some measurement noise.

Using custom and more simple tracing mechanism leads to increase of
accuracy and more precise control of the tracing.

* Implement BPF programs for per-syscall entry/exit raw tracepoints. This
  programs gather timestamps using bpf_ktime_get_ns() helper [1] and
  calculate some statistics for target processes.

* Implement simple libbpf-based tracer that attaches BPF programs to
  tracepoints, launches workload and shows gathered statistics. Currently
  this tracer doesn't support syscall name tables, therefore syscall
  number is shown instead of the name.

* Create separate Makefile for performance measurement programs. It is
  required in order to not mess up current selftests Makefile with libbpf
  build logic.

* Support custom tracer in bench/run.sh.

Consider following results (produced on linux v5.15):

    # for i in $(seq 1 3);
    # do
    # 	./bench/run.sh -e openat -m
    # done
    ...
    overhead:
        syscall                  bcalls     scalls   duration+overhead(us)
        =======                  ======     ======   =====================
        openat                  9978464    9979092        2.40+0.01(+0.0%)
    ...
        openat                  9981513    9981200        2.40+0.06(+2.0%)
    ...
        openat                  9977238    9980300        2.47-0.02(-1.0%)

    # for i in $(seq 1 3);
    # do
    # 	./bench/run.sh -e openat -m -b
    # done
    ...
    overhead:
        syscall                  bcalls     scalls   duration+overhead(us)
        =======                  ======     ======   =====================
        syscall-257            40000000   20000003        0.95+0.06(+6.0%)
    ...
        syscall-257            40000000   20000003        0.95+0.05(+5.0%)
    ...
        syscall-257            20000000   20000003        0.95+0.06(+6.0%)

[1] https://man7.org/linux/man-pages/man7/bpf-helpers.7.html

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/landlock/Makefile     |   9 +-
 .../testing/selftests/landlock/bench/Makefile | 179 +++++++++++
 tools/testing/selftests/landlock/bench/config |  10 +
 .../selftests/landlock/bench/progs/tracer.c   | 126 ++++++++
 tools/testing/selftests/landlock/bench/run.sh |  16 +
 .../testing/selftests/landlock/bench/tracer.c | 278 ++++++++++++++++++
 .../selftests/landlock/bench/tracer_common.h  |  15 +
 tools/testing/selftests/landlock/config       |   2 -
 9 files changed, 626 insertions(+), 10 deletions(-)
 create mode 100644 tools/testing/selftests/landlock/bench/Makefile
 create mode 100644 tools/testing/selftests/landlock/bench/config
 create mode 100644 tools/testing/selftests/landlock/bench/progs/tracer.c
 create mode 100644 tools/testing/selftests/landlock/bench/tracer.c
 create mode 100644 tools/testing/selftests/landlock/bench/tracer_common.h

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index bc8fe9e8f7f2..5ee2fc668f39 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -47,6 +47,7 @@ TARGETS += kcmp
 TARGETS += kexec
 TARGETS += kvm
 TARGETS += landlock
+TARGETS += landlock/bench
 TARGETS += lib
 TARGETS += livepatch
 TARGETS += lkdtm
diff --git a/tools/testing/selftests/landlock/Makefile b/tools/testing/selftests/landlock/Makefile
index e149ef66841a..348e2dbdb4e0 100644
--- a/tools/testing/selftests/landlock/Makefile
+++ b/tools/testing/selftests/landlock/Makefile
@@ -10,9 +10,7 @@ src_test := $(wildcard *_test.c)
 
 TEST_GEN_PROGS := $(src_test:.c=)
 
-TEST_GEN_PROGS_EXTENDED := true bench/sandboxer bench/microbench
-
-TEST_PROGS_EXTENDED := bench/run.sh
+TEST_GEN_PROGS_EXTENDED := true
 
 # Short targets:
 $(TEST_GEN_PROGS): LDLIBS += -lcap
@@ -20,11 +18,6 @@ $(TEST_GEN_PROGS_EXTENDED): LDFLAGS += -static
 
 include ../lib.mk
 
-$(OUTPUT)/bench/microbench: bench/microbench.c bench/common.c
-$(OUTPUT)/bench/sandboxer: bench/sandboxer.c bench/common.c
-
 # Targets with $(OUTPUT)/ prefix:
 $(TEST_GEN_PROGS): LDLIBS += -lcap
 $(TEST_GEN_PROGS_EXTENDED): LDFLAGS += -static
-
-EXTRA_CLEAN = $(OUTPUT)/common.o
diff --git a/tools/testing/selftests/landlock/bench/Makefile b/tools/testing/selftests/landlock/bench/Makefile
new file mode 100644
index 000000000000..4187b4983b9c
--- /dev/null
+++ b/tools/testing/selftests/landlock/bench/Makefile
@@ -0,0 +1,179 @@
+# SPDX-License-Identifier: GPL-2.0
+
+# based on tools/testing/selftest/bpf/Makefile
+include ../../../../build/Build.include
+include ../../../../scripts/Makefile.arch
+include ../../../../scripts/Makefile.include
+
+CFLAGS += -g -rdynamic -Wall -Werror -I$(OUTPUT)
+# CFLAGS += -I$(OUTPUT)/tools/include
+
+LDLIBS += -lelf -lz -lrt -lpthread -lm
+
+# Silence some warnings when compiled with clang
+ifneq ($(LLVM),)
+CFLAGS += -Wno-unused-command-line-argument
+endif
+
+LOCAL_HDRS += common.h tracer_common.h
+
+# Order correspond to 'make run_tests' order
+TEST_GEN_PROGS_EXTENDED := tracer sandboxer microbench
+
+TEST_PROGS_EXTENDED := run.sh
+
+# Emit succinct information message describing current building step
+# $1 - generic step name (e.g., CC, LINK, etc);
+# $2 - optional "flavor" specifier; if provided, will be emitted as [flavor];
+# $3 - target (assumed to be file); only file name will be emitted;
+# $4 - optional extra arg, emitted as-is, if provided.
+ifeq ($(V),1)
+Q =
+msg =
+else
+Q = @
+msg = @printf '  %-8s%s %s%s\n' "$(1)" "$(if $(2), [$(2)])" "$(notdir $(3))" "$(if $(4), $(4))";
+MAKEFLAGS += --no-print-directory
+submake_extras := feature_display=0
+endif
+
+# override lib.mk's default rules
+OVERRIDE_TARGETS := 1
+override define CLEAN
+	$(call msg,CLEAN)
+	$(Q)$(RM) -r $(TEST_GEN_PROGS)
+	$(Q)$(RM) -r $(EXTRA_CLEAN)
+endef
+
+include ../../lib.mk
+
+TOOLSDIR := $(top_srcdir)/tools
+LIBDIR := $(TOOLSDIR)/lib
+BPFDIR := $(LIBDIR)/bpf
+BPFTOOLDIR := $(TOOLSDIR)/bpf/bpftool
+SCRATCH_DIR := $(OUTPUT)/tools
+BUILD_DIR := $(SCRATCH_DIR)/build
+INCLUDE_DIR := $(SCRATCH_DIR)/include
+BPFOBJ := $(BUILD_DIR)/libbpf/libbpf.a
+
+VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)				\
+		     $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)	\
+		     /sys/kernel/btf/vmlinux				\
+		     ../../../../../vmlinux				\
+		     /boot/vmlinux-$(shell uname -r)
+VMLINUX_BTF ?= $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS))))
+ifeq ($(VMLINUX_BTF),)
+$(error Cannot find a vmlinux for VMLINUX_BTF at any of "$(VMLINUX_BTF_PATHS)")
+endif
+
+# Define simple and short `make test_progs`, `make test_sysctl`, etc targets
+# to build individual tests.
+# NOTE: Semicolon at the end is critical to override lib.mk's default static
+# rule for binaries.
+$(notdir $(TEST_GEN_PROGS)): %: $(OUTPUT)/% ;
+
+# sort removes libbpf duplicates when not cross-building
+MAKE_DIRS := $(sort $(BUILD_DIR)/libbpf 		\
+	       $(BUILD_DIR)/bpftool  $(INCLUDE_DIR))
+
+$(MAKE_DIRS):
+	$(call msg,MKDIR,,$@)
+	$(Q)mkdir -p $@
+
+DEFAULT_BPFTOOL := $(SCRATCH_DIR)/sbin/bpftool
+
+TEST_GEN_PROGS_EXTENDED += $(DEFAULT_BPFTOOL)
+
+$(TEST_GEN_PROGS_EXTENDED): $(BPFOBJ)
+
+BPFTOOL ?= $(DEFAULT_BPFTOOL)
+$(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)    \
+		    $(BPFOBJ) | $(BUILD_DIR)/bpftool
+	$(Q)$(MAKE) $(submake_extras)  -C $(BPFTOOLDIR)			       \
+		    ARCH= CROSS_COMPILE= CC="$(HOSTCC)" LD="$(HOSTLD)" 	       \
+		    EXTRA_CFLAGS='-g'			       \
+		    OUTPUT=$(BUILD_DIR)/bpftool/			       \
+		    LIBBPF_OUTPUT=$(BUILD_DIR)/libbpf/		       \
+		    LIBBPF_DESTDIR=$(SCRATCH_DIR)/			       \
+		    prefix= DESTDIR=$(SCRATCH_DIR)/ install-bin
+
+$(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)		       \
+	   | $(BUILD_DIR)/libbpf
+	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=$(BUILD_DIR)/libbpf/ \
+		    EXTRA_CFLAGS='-g'	       \
+		    DESTDIR=$(SCRATCH_DIR) prefix= all install_headers
+
+$(INCLUDE_DIR)/vmlinux.h: $(VMLINUX_BTF) $(BPFTOOL) | $(INCLUDE_DIR)
+ifeq ($(VMLINUX_H),)
+	$(call msg,GEN,,$@)
+	$(Q)$(BPFTOOL) btf dump file $(VMLINUX_BTF) format c > $@
+else
+	$(call msg,CP,,$@)
+	$(Q)cp "$(VMLINUX_H)" $@
+endif
+
+# Get Clang's default includes on this system, as opposed to those seen by
+# '--target=bpf'. This fixes "missing" files on some architectures/distros,
+# such as asm/byteorder.h, asm/socket.h, asm/sockios.h, sys/cdefs.h etc.
+#
+# Use '-idirafter': Don't interfere with include mechanics except where the
+# build would have failed anyways.
+define get_sys_includes
+$(shell $(1) -v -E - </dev/null 2>&1 \
+	| sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }') \
+$(shell $(1) -dM -E - </dev/null | grep '__riscv_xlen ' | awk '{printf("-D__riscv_xlen=%d -D__BITS_PER_LONG=%d", $$3, $$3)}')
+endef
+
+# Determine target endianness.
+IS_LITTLE_ENDIAN = $(shell $(CC) -dM -E - </dev/null | \
+			grep 'define __BYTE_ORDER__ __ORDER_LITTLE_ENDIAN__')
+MENDIAN=$(if $(IS_LITTLE_ENDIAN),-mlittle-endian,-mbig-endian)
+
+CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
+BPF_CFLAGS = -g -Werror -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN) 		\
+	     -I$(INCLUDE_DIR)
+
+CLANG_CFLAGS = $(CLANG_SYS_INCLUDES) \
+	       -Wno-compare-distinct-pointer-types
+
+# Build BPF object using Clang
+# $1 - input .c file
+# $2 - output .o file
+# $3 - CFLAGS
+define CLANG_BPF_BUILD_RULE
+	$(call msg,CLNG-BPF,,$2)
+	$(Q)$(CLANG) $3 -O2 --target=bpf -c $1 -mcpu=v3 -o $2
+endef
+
+BPF_PROGS_DIR := progs
+BPF_BUILD_RULE := CLANG_BPF_BUILD_RULE
+BPF_SRCS := $(notdir $(wildcard $(BPF_PROGS_DIR)/*.c))
+BPF_OBJS := $(patsubst %.c,$(OUTPUT)/%.bpf.o, $(BPF_SRCS))
+BPF_SKELS := $(patsubst %.c,$(OUTPUT)/%.skel.h, $(BPF_SRCS))
+
+TEST_GEN_FILES += $(BPF_OBJS)
+
+$(BPF_PROGS_DIR)-bpfobjs := y
+$(BPF_OBJS): $(OUTPUT)/%.bpf.o:				\
+	     $(BPF_PROGS_DIR)/%.c			\
+	     $(wildcard $(BPF_PROGS_DIR)/*.h)		\
+	     $(INCLUDE_DIR)/vmlinux.h				\
+	     $(wildcard $(BPFDIR)/*.bpf.h)			\
+	     | $(OUTPUT) $(BPFOBJ)
+	$(call $(BPF_BUILD_RULE),$<,$@, $(BPF_CFLAGS))
+
+$(BPF_SKELS): %.skel.h: %.bpf.o $(BPFTOOL) | $(OUTPUT)
+	$(call msg,GEN-SKEL,$(BINARY),$@)
+	$(Q)$(BPFTOOL) gen object $(<:.o=.linked1.o) $<
+	$(Q)$(BPFTOOL) gen skeleton $(<:.o=.linked1.o) name $(notdir $(<:.bpf.o=)) > $@
+
+$(OUTPUT)/%.o: %.c $(BPF_SKELS)
+	$(call msg,CC,,$@)
+	$(Q)$(CC) $(CFLAGS) -c $(filter %.c,$^) $(LDLIBS) -o $@
+
+$(OUTPUT)/%: $(OUTPUT)/%.o common.c
+	$(call msg,BINARY,,$@)
+	$(Q)$(LINK.c) $^ $(LDLIBS) -o $@
+
+EXTRA_CLEAN := $(SCRATCH_DIR) feature bpftool	\
+	$(addprefix $(OUTPUT)/,*.o *.skel.h) common.o
diff --git a/tools/testing/selftests/landlock/bench/config b/tools/testing/selftests/landlock/bench/config
new file mode 100644
index 000000000000..d7353ef77ff2
--- /dev/null
+++ b/tools/testing/selftests/landlock/bench/config
@@ -0,0 +1,10 @@
+CONFIG_BPF=y
+CONFIG_BPF_EVENTS=y
+CONFIG_BPF_SYSCALL=y
+CONFIG_CMDLINE="isolcpus=0 nohz_full=0 nosmt cpufreq.off=1"
+CONFIG_CMDLINE_BOOL=y
+CONFIG_DEBUG_INFO=y
+CONFIG_DEBUG_INFO_BTF=y
+CONFIG_DEBUG_INFO_DWARF4=y
+CONFIG_SECURITY=y
+CONFIG_SECURITY_LANDLOCK=y
diff --git a/tools/testing/selftests/landlock/bench/progs/tracer.c b/tools/testing/selftests/landlock/bench/progs/tracer.c
new file mode 100644
index 000000000000..3bd71d541b03
--- /dev/null
+++ b/tools/testing/selftests/landlock/bench/progs/tracer.c
@@ -0,0 +1,126 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * BPF programs for benchmarking data collection.
+ *
+ * Copyright © 2024 Huawei Tech. Co., Ltd.
+ */
+
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_core_read.h>
+
+#include "../tracer_common.h"
+
+void bpf_rcu_read_lock(void) __ksym;
+void bpf_rcu_read_unlock(void) __ksym;
+
+char _license[] SEC("license") = "GPL";
+
+struct syscall_enter_args {
+	unsigned long long common_tp_fields;
+	long syscall_nr;
+	unsigned long args[6];
+};
+
+struct syscall_exit_args {
+	unsigned long long common_tp_fields;
+	long syscall_nr;
+	long ret;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__type(key, int);
+	__type(value, struct tracer_stat_data);
+	__uint(max_entries, NR_SYSCALLS);
+} sys_stats SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, pid_t);
+	__type(value, unsigned long long);
+	__uint(max_entries, MAX_TASKS);
+} sys_enter_timestamp SEC(".maps");
+
+int target_pid;
+
+static inline bool is_target(struct task_struct *task)
+{
+	bool res = false;
+
+	bpf_rcu_read_lock();
+
+	/* Accumulates data only for target process or it's child. */
+	while (task && task->pid != target_pid)
+		task = task->real_parent;
+	if (task)
+		res = true;
+
+	bpf_rcu_read_unlock();
+	return res;
+}
+
+SEC("tp/raw_syscalls/sys_enter")
+int sys_enter(struct syscall_enter_args *args)
+{
+	pid_t pid;
+	unsigned long long timestamp;
+	struct task_struct *task;
+
+	task = bpf_get_current_task_btf();
+
+	if (!is_target(task))
+		return 0;
+
+	pid = task->pid;
+	timestamp = bpf_ktime_get_ns();
+	bpf_map_update_elem(&sys_enter_timestamp, &pid, &timestamp, 0);
+	return 0;
+}
+
+SEC("tp/raw_syscalls/sys_exit")
+int sys_exit(struct syscall_exit_args *args)
+{
+	pid_t pid;
+	struct tracer_stat_data *stat;
+	unsigned long long *enter_timestamp, exit_timestamp, duration;
+	long long delta;
+	long syscall_nr;
+	struct task_struct *task;
+
+	exit_timestamp = bpf_ktime_get_ns();
+
+	task = bpf_get_current_task_btf();
+	if (!is_target(task))
+		return 0;
+
+	pid = task->pid;
+	enter_timestamp = bpf_map_lookup_elem(&sys_enter_timestamp, &pid);
+	if (!enter_timestamp)
+		return 0;
+
+	syscall_nr = args->syscall_nr;
+
+	stat = bpf_map_lookup_elem(&sys_stats, &syscall_nr);
+	if (stat) {
+		duration = exit_timestamp - *enter_timestamp;
+
+		/* Cf. tools/perf/util/stat.c */
+		stat->samples++;
+
+		delta = (long long)duration - stat->mean;
+
+		stat->duration += duration;
+
+		/* EBPF doesn't support signed division */
+		if (delta > 0)
+			stat->mean += (unsigned long long)delta / stat->samples;
+		else
+			stat->mean -= (unsigned long long)(-delta) / stat->samples;
+
+		stat->M2 += delta * (duration - stat->mean);
+		bpf_map_update_elem(&sys_stats, &syscall_nr, stat, 0);
+	}
+	return 0;
+}
diff --git a/tools/testing/selftests/landlock/bench/run.sh b/tools/testing/selftests/landlock/bench/run.sh
index 582313f689ad..6a8022b44ece 100755
--- a/tools/testing/selftests/landlock/bench/run.sh
+++ b/tools/testing/selftests/landlock/bench/run.sh
@@ -31,6 +31,7 @@ ACCESS=
 TRACED_SYSCALLS=
 MICROBENCH=false
 WORKLOAD=
+CUSTOM_TRACER=false
 SILENCE=false
 TRACE_CMD=
 
@@ -55,6 +56,7 @@ help()
 	echo "Options:"
 	echo "  -e TRACED_SYSCALLS  specify syscalls which would be traced while benchmarking"
 	echo "  -m                  run microbenchmark workload for TRACED_SYSCALLS"
+	echo "  -b                  trace via custom tracer"
 	echo "  -p PERF_BINARY      use PERF_BINARY instead of /usr/bin/perf"
 	echo "  -D MSECS            wait MSECS msecs before tracing sandboxed workload"
 	echo "                      (default: $SANDBOX_DELAY)"
@@ -95,6 +97,7 @@ parse_and_check_arguments()
 		case $arg in
 			e) TRACED_SYSCALLS=$OPTARG ;;
 			m) MICROBENCH=true ;;
+			b) CUSTOM_TRACER=true ;;
 			t) add_sandboxer_args $OPTARG ;;
 			p) PERF_BIN=`realpath $OPTARG` ;;
 			D) SANDBOX_DELAY=$OPTARG ;;
@@ -132,6 +135,10 @@ parse_and_check_arguments()
 	if [ ! -z "$WORKLOAD" ] && [ -z "$SANDBOXER_ARGS" ]; then
 		err Landlock topology is not specified
 	fi
+
+	if [ ! -f "$CUSTOM_TRACER_BIN" ] && $CUSTOM_TRACER ; then
+		err Tracer binary does not exist
+	fi
 }
 
 # perf trace
@@ -142,6 +149,9 @@ header+=';/^                                     (msec)    (msec)    (msec)    (
 header+=';/^   --------------- --------  ------ -------- --------- --------- ---------     ------$/d'
 header+=';/^ Summary of events:$/d'
 
+# custom tracer
+header+=';/^                                           samples  duration AVG(ns)  duration(ms)     stddev(%)$/d'
+
 rm_headers()
 {
 	sed -i "$header" $1
@@ -327,6 +337,12 @@ run_traced_microbench()
 		sandbox_opt=-s
 	fi
 
+	if $CUSTOM_TRACER; then
+		stddev_col=5
+	else
+		stddev_col=9
+	fi
+
 	echo '' > $output
 
 	syscalls_to_parse=$(echo $TRACED_SYSCALLS | sed 's/,/\n/g')
diff --git a/tools/testing/selftests/landlock/bench/tracer.c b/tools/testing/selftests/landlock/bench/tracer.c
new file mode 100644
index 000000000000..fe48e1b6db45
--- /dev/null
+++ b/tools/testing/selftests/landlock/bench/tracer.c
@@ -0,0 +1,278 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Attach BPF programs to syscall tracepoints, launch workload and show
+ * gathered statistics.
+ *
+ * Copyright © 2024 Huawei Tech. Co., Ltd.
+ */
+
+#include <bpf/libbpf.h>
+#define _GNU_SOURCE
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/syscall.h>
+#include <sys/stat.h>
+#include <sys/wait.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <assert.h>
+#include <getopt.h>
+#include <time.h>
+#include <linux/bpf.h>
+#include <math.h>
+
+#include "tracer.skel.h"
+#include "common.h"
+#include "tracer_common.h"
+
+#define ARG_MAX 32
+
+#define max(x, y) ((x) > (y) ? (x) : (y))
+#define ns2ms(ns) ((long double)(ns) / (1000 * 1000))
+
+#define pr_warn(fmt, ...) fprintf(stderr, fmt, ##__VA_ARGS__)
+
+#define SYS_ENTER_PREFIX "sys_enter_"
+#define SYS_EXIT_PREFIX "sys_exit_"
+#define SYS_PREFIX_MAXLEN sizeof(SYS_ENTER_PREFIX)
+
+#define SYS_DELIM ","
+
+static int attach_bpf_progs(struct tracer *skel, const char *strsys)
+{
+	struct bpf_link *bpf_link;
+	char strsys_buf[STRBUF_MAXLEN], *strsys_parsed, *strsys_next;
+	char str_tracepoint[STRBUF_MAXLEN + SYS_PREFIX_MAXLEN];
+
+	assert(strlen(strsys) < STRBUF_MAXLEN);
+	strcpy(strsys_buf, strsys);
+	strsys_parsed = strsys_buf;
+
+	while ((strsys_next = strsep(&strsys_parsed, SYS_DELIM))) {
+		strcpy(str_tracepoint, SYS_ENTER_PREFIX);
+		strcat(str_tracepoint, strsys_next);
+		bpf_link = bpf_program__attach_tracepoint(
+			skel->progs.sys_enter, "syscalls", str_tracepoint);
+		if (!bpf_link) {
+			pr_warn("BPF attaching failed for syscall \"%s\": %s\n",
+				strsys_next, strerror(errno));
+			goto err_out;
+		}
+
+		strcpy(str_tracepoint, SYS_EXIT_PREFIX);
+		strcat(str_tracepoint, strsys_next);
+		bpf_link = bpf_program__attach_tracepoint(
+			skel->progs.sys_exit, "syscalls", str_tracepoint);
+		if (!bpf_link) {
+			pr_warn("BPF attaching failed for syscall \"%s\": %s\n",
+				strsys_next, strerror(errno));
+			goto err_out;
+		}
+	}
+
+	return 0;
+
+err_out:
+	return 1;
+}
+
+static const char col_entity_name[] = "";
+static const char col_samples_name[] = "samples";
+static const char col_duration_avg_name[] = "duration AVG(ns)";
+static const char col_duration_name[] = "duration(ms)";
+static const char col_stddev_name[] = "stddev(%)";
+
+static const int col_entity_pad = 35;
+static const int col_samples_pad = max(14, sizeof(col_samples_name));
+static const int col_duration_avg_pad = max(12, sizeof(col_duration_avg_name));
+static const int col_duration_pad = max(13, sizeof(col_duration_name));
+static const int col_stddev_pad = max(10, sizeof(col_duration_name));
+
+void show_stat_header(FILE *output)
+{
+	fprintf(output, "%*s %*s %*s %*s %*s\n", col_entity_pad,
+		col_entity_name, col_samples_pad, col_samples_name,
+		col_duration_avg_pad, col_duration_avg_name, col_duration_pad,
+		col_duration_name, col_stddev_pad, col_stddev_name);
+}
+
+void show_syscall_stat(FILE *output, long syscall_nr,
+		       struct tracer_stat_data *stat)
+{
+	char name[STRBUF_MAXLEN];
+	double variance, variance_mean;
+	double stddev = 0;
+
+	assert(snprintf(name, sizeof(name), "syscall-%ld", syscall_nr) >= 0);
+
+	/* Cf. tools/perf/util/stat.c */
+	if (stat->samples >= 2 && stat->mean) {
+		variance = (double)stat->M2 / (stat->samples - 1);
+		variance_mean = variance / stat->samples;
+
+		stddev = 100.0 * sqrt(variance_mean) / stat->mean;
+	}
+
+	fprintf(output, "%-*s %*u %*llu %*.3Lf %*.2lf%%\n", col_entity_pad,
+		name, col_samples_pad, stat->samples, col_duration_avg_pad,
+		stat->mean, col_duration_pad - 1, ns2ms(stat->duration),
+		col_stddev_pad, stddev);
+}
+
+static int dump_bench_results(struct tracer *skel, const char *output)
+{
+	int err = 1;
+	int sys_map_fd;
+	struct tracer_stat_data sys_stat;
+	FILE *output_file;
+
+	if (!output)
+		output_file = stderr;
+	else {
+		output_file = fopen(output, "w");
+		if (!output_file) {
+			pr_warn("Failed to open output file \"%s\": %s\n",
+				output, strerror(errno));
+			goto out;
+		}
+	}
+
+	sys_map_fd = bpf_map__fd(skel->maps.sys_stats);
+	if (sys_map_fd < 0) {
+		pr_warn("Failed to get fd from BPF map \"sys_stats\"\n");
+		goto out;
+	}
+
+	show_stat_header(output_file);
+	for (int syscall_nr = 0; syscall_nr < NR_SYSCALLS; syscall_nr++) {
+		err = bpf_map__lookup_elem(skel->maps.sys_stats, &syscall_nr,
+					   sizeof(syscall_nr), &sys_stat,
+					   sizeof(sys_stat), 0);
+		if (err) {
+			pr_warn("Failed to extract stat from BPF map \"sys_stat\" for syscall[%d]\n",
+				syscall_nr);
+			goto out;
+		}
+		if (!sys_stat.samples)
+			continue;
+
+		show_syscall_stat(output_file, syscall_nr, &sys_stat);
+	}
+	err = 0;
+out:
+	if (output_file && output_file != stderr)
+		fclose(output_file);
+	return err;
+}
+
+int msleep(int msec)
+{
+	int err;
+	struct timespec ts;
+
+	ts.tv_sec = msec / 1000;
+	ts.tv_nsec = (msec % 1000) * 1000000;
+
+	do {
+		err = nanosleep(&ts, &ts);
+	} while (err && errno == EINTR);
+
+	if (err)
+		pr_warn("nanosleep failed: %s\n", strerror(errno));
+	return err;
+}
+
+// TODO: syscalls to string
+
+int main(const int argc, char *const argv[])
+{
+	int c, child, status;
+	const char *strsys = NULL, *output = NULL, *cmd;
+	struct tracer *skel = NULL;
+	int init_duration = 0;
+
+	while ((c = getopt(argc, argv, "e:o:D:h")) != -1) {
+		switch (c) {
+		case 'e':
+			strsys = optarg;
+			break;
+		case 'o':
+			output = optarg;
+			break;
+		case 'D':
+			errno = 0;
+			init_duration = atoi(optarg);
+			if (errno) {
+				pr_warn("atoi() failed on %s\n", optarg);
+				goto cleanup;
+			}
+			break;
+		case 'h':
+			pr_warn("Usage: %s [OPTIONS] [WORKLOAD_CMD]\n"
+				"Run WORKLOAD_CMD and trace number and duration of syscalls\n"
+				"\n"
+				"Options:\n"
+				"  -e TRACED_SYSCALLS  specify syscalls which would be traced while benchmarking\n"
+				"  -o FILE             redirect result output into FILE\n"
+				"  -D MSECS            wait MSECS msecs before tracing sandboxed workload\n",
+				argv[0]);
+			break;
+		}
+
+		/* Next argument is workload. */
+		if (optind < argc && *argv[optind] != '-')
+			break;
+	}
+
+	if (optind >= argc) {
+		pr_warn("Command is not specified\n");
+		goto cleanup;
+	}
+
+	if (!strsys) {
+		pr_warn("Syscall list is not specified\n");
+		goto cleanup;
+	}
+
+	skel = tracer__open_and_load();
+	if (!skel) {
+		pr_warn("BPF skeleton loading failed: %s\n", strerror(errno));
+		goto cleanup;
+	}
+
+	cmd = argv[optind];
+
+	child = fork();
+	if (child < 0) {
+		pr_warn("Failed to fork child workload process: \"%s\"\n",
+			strerror(errno));
+		goto cleanup;
+	}
+
+	if (child == 0) {
+		skel->bss->target_pid = getpid();
+
+		execv(cmd, argv + optind);
+
+		pr_warn("Failed to execute \"%s\": %s\n", cmd, strerror(errno));
+		_exit(EXIT_FAILURE);
+	}
+
+	if (msleep(init_duration))
+		goto cleanup;
+
+	if (attach_bpf_progs(skel, strsys))
+		goto cleanup;
+
+	if (waitpid(child, &status, 0) != child)
+		pr_warn("\"%s\" execution failed: %s\n", cmd, strerror(errno));
+
+	if (dump_bench_results(skel, output))
+		goto cleanup;
+	return 0;
+cleanup:
+	tracer__destroy(skel);
+	return 1;
+}
diff --git a/tools/testing/selftests/landlock/bench/tracer_common.h b/tools/testing/selftests/landlock/bench/tracer_common.h
new file mode 100644
index 000000000000..e5c9ae72632e
--- /dev/null
+++ b/tools/testing/selftests/landlock/bench/tracer_common.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef LANDLOCK_BENCH_TRACER_COMMON_H
+#define LANDLOCK_BENCH_TRACER_COMMON_H
+
+#define NR_SYSCALLS 1024
+#define MAX_TASKS 100000
+
+struct tracer_stat_data {
+	long long M2;
+	long long mean;
+	unsigned long long duration;
+	unsigned int samples;
+};
+
+#endif
diff --git a/tools/testing/selftests/landlock/config b/tools/testing/selftests/landlock/config
index e4bf29cf935f..29af19c4e9f9 100644
--- a/tools/testing/selftests/landlock/config
+++ b/tools/testing/selftests/landlock/config
@@ -1,7 +1,5 @@
 CONFIG_CGROUPS=y
 CONFIG_CGROUP_SCHED=y
-CONFIG_CMDLINE="isolcpus=0 nohz_full=0 nosmt cpufreq.off=1"
-CONFIG_CMDLINE_BOOL=y
 CONFIG_INET=y
 CONFIG_IPV6=y
 CONFIG_KEYS=y
-- 
2.34.1

