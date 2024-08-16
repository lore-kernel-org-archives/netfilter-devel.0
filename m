Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8873ECC;
	Fri, 16 Aug 2024 01:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723770022; cv=none; b=YeDkwKWfnR5i6c4+GfdoC5gMFeUSZ1ytzPgWXkcWGwKRS3MeuDIAsJRP8ygDgLxBDyYaCSffMHgE1a/+uzKp4JXx4YloUyoN9FS55PkQ/SuLALm5WC8PaCtZcvE3kowIOW1Rud4zJx2ielF5fYbOrUGK2S7+Hztt8ALd2TCl0Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723770022; c=relaxed/simple;
	bh=2CECiWeAA90jrbNdHJdmbnWtyf7ajzRswu+VOL4S2EA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eobj42IjF/Gr2xW0wZC4+uTZTXyo0zShNxOmmS5gyCWJyCIFNhJupisOwogKkq7AuMkEBDBsaxzYaNlqijnaSC9L5GofoiTZDSzcRPOqj8NfaK2vFLHNIr7aGyHdZgaeqnOPCGqy5CUP1ztY5wU+cwmC2u9yB8NaUBNtW5xpsTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WlNqp1SQcz1HGYc;
	Fri, 16 Aug 2024 08:57:10 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 5129B14010C;
	Fri, 16 Aug 2024 09:00:16 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 16 Aug 2024 09:00:14 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v1 1/4] selftests/landlock: Implement performance impact measurement tool
Date: Fri, 16 Aug 2024 08:59:40 +0800
Message-ID: <20240816005943.1832694-2-ivanov.mikhail1@huawei-partners.com>
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

Motivation
===========
Landlock LSM hooks are executed with many operations on Linux internal
objects (files, sockets). This hooks can noticeably affect performance
of such operations as it was demonstrated in the filesystem caching
patchset [1]. Having ability to calculate Landlock performance overhead
allows to compare kernel changes and estimate the acceptability
of new features (e.g. [2], [3], [4]).

Implementation design
=====================
Calling LSM hooks in userspace mostly expected while using syscalls.
Therefore, syscall duration can be used as a metric. Calculation of this
is performed by gathering timestamps in per-syscall enter/exit tracepoints
while executing some workload command. Landlock overhead for syscall X
is defined as the difference between duration of X in sandboxed environment
and non-sandboxed duration of X.

Syscall duration measurement
============================
perf trace is used to measure syscall duration as more efficient version
of strace. This tool uses per-syscall raw tracepoints as perf events for
gathering syscalls time statistics for specified workload.

In order to reduce noise during measurement following mechanisms are used:
* CPU affinity
* CPU isolation
* Tickless mode (nohz_full)
* SMT disable
* cpufreq disable

CPU 0 is isolated and used for benchmarking.

To provide stability of measurement results and to be safe from anomaly
ones workload is executed in N iterations (N is set by the user of the
tool). Average value from this iterations is taken to represent final
result.

Sandboxing workload
===================
Proposed mechanism allows to test different sandbox scenarios. Ruleset of
sandboxed workload can be configured with following entities:

* List of rule keys and ruleset layers corresponding to the keys.
  This entity is useful to benchmark different ruleset configurations
  which affects performance of the hooks (e.g. big number of layers or
  rules). This list should be stored in a text file.

* Access right common for each key. Configuring access right is useful to
  control what hooks should be triggered during measurement.
  handled_access of ruleset is also set with this number.

First entitity is called a Landlock topology. These 2 entities are passed
to sandboxer with a command arguments.

For example following command will generate a topology in which keys
are linux source files and layer of each key is assigned with the depth of
the file:
    $FIND $LINUX_PATH -maxdepth 5 -fprintf $TOPOLOGY_FILE '%d %p\n'

Example
=======
Following operation measures Landlock overhead for openat(2) syscall
for workload that uses find tool on linux source files (with depth 5).
Landlock ruleset uses read access right.

    # Topology creation for FS ruleset (results in .topology file)
    ./bench/run.sh -t fs:.topology:4 -e openat -s \
        $FIND $LINUX_SRC -mindepth 5 -maxdepth 5 -exec file '{}' \;

Implementation structure
========================
* Create folder 'bench' in Landlock selftests where all scripts
  and workloads dedicated to measurement are located.
* Add bench/run.sh which is the main script that launches workload,
  measures syscalls duration and provides result numbers.
* Add bench/sandboxer.c which is a program that sandboxes with specified
  configuration and runs specified workload.
* Add CONFIG_CMDLINE="isolcpus=0 nohz_full=0 nosmt cpufreq.off=1" in the
  config file.

=====
[1] https://lore.kernel.org/all/20210630224856.1313928-1-mic@digikod.net/
[2] https://github.com/landlock-lsm/linux/issues/10
[3] https://github.com/landlock-lsm/linux/issues/19
[4] https://github.com/landlock-lsm/linux/issues/1

Closes: https://github.com/landlock-lsm/linux/issues/24
Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
 tools/testing/selftests/landlock/Makefile     |   4 +-
 tools/testing/selftests/landlock/bench/run.sh | 301 ++++++++++++++
 .../selftests/landlock/bench/sandboxer.c      | 380 ++++++++++++++++++
 tools/testing/selftests/landlock/config       |   2 +
 4 files changed, 686 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/landlock/bench/run.sh
 create mode 100644 tools/testing/selftests/landlock/bench/sandboxer.c

diff --git a/tools/testing/selftests/landlock/Makefile b/tools/testing/selftests/landlock/Makefile
index 348e2dbdb4e0..410e8cd28707 100644
--- a/tools/testing/selftests/landlock/Makefile
+++ b/tools/testing/selftests/landlock/Makefile
@@ -10,7 +10,9 @@ src_test := $(wildcard *_test.c)
 
 TEST_GEN_PROGS := $(src_test:.c=)
 
-TEST_GEN_PROGS_EXTENDED := true
+TEST_GEN_PROGS_EXTENDED := true bench/sandboxer
+
+TEST_PROGS_EXTENDED := bench/run.sh
 
 # Short targets:
 $(TEST_GEN_PROGS): LDLIBS += -lcap
diff --git a/tools/testing/selftests/landlock/bench/run.sh b/tools/testing/selftests/landlock/bench/run.sh
new file mode 100755
index 000000000000..afbcbb2ba6aa
--- /dev/null
+++ b/tools/testing/selftests/landlock/bench/run.sh
@@ -0,0 +1,301 @@
+#!/usr/bin/env bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright © 2024 Huawei Tech. Co., Ltd.
+#
+# Measure overhead of Landlock hooks for the specified workload.
+
+# cf. tools/testing/selftests/kselftest.h
+KSFT_PASS=0
+KSFT_FAIL=1
+KSFT_XFAIL=2
+KSFT_XPASS=3
+KSFT_SKIP=4
+
+REL_DIR=$(dirname $(realpath $0))
+PERF_BIN=/usr/bin/perf
+SANDBOXER_BIN=$REL_DIR/sandboxer
+TASKSET=/usr/bin/taskset
+NICE=/usr/bin/nice
+
+LL_TRACE_DUMP=.tmp.ll
+BASE_TRACE_DUMP=.tmp.base
+TMP_BUF=.tmp.buf
+TMP_BUF2=.tmp.buf2
+OUTPUT=
+
+SANDBOXER_ARGS=
+ACCESS=
+TRACED_SYSCALLS=
+WORKLOAD=
+SILENCE=false
+TRACE_CMD=
+
+CPU_AFFINITY=0
+SANDBOX_DELAY=300 # msecs
+REPEAT=5
+
+err()
+{
+	echo $@ >&2
+	exit $KSFT_SKIP
+}
+
+help()
+{
+	echo "Usage: $0 [OPTIONS] [WORKLOAD_CMD]"
+	echo "Measure overhead of Landlock hooks for the specified workload."
+	echo
+	echo "Options:"
+	echo "  -e TRACED_SYSCALLS  specify syscalls which would be traced while benchmarking"
+	echo "  -p PERF_BINARY      use PERF_BINARY instead of /usr/bin/perf"
+	echo "  -D MSECS            wait MSECS msecs before tracing sandboxed workload"
+	echo "                      (default: $SANDBOX_DELAY)"
+	echo "  -r COUNT            repeat WORKLOAD_CMD for COUNT times, show avg and stddev"
+	echo "                      (default: $REPEAT)"
+	echo "  -o FILE             save result into FILE"
+	echo "  -c CPU              use CPU affinity (default: $CPU_AFFINITY)"
+	echo "  -s                  hide stdout output for WORKLOAD_CMD"
+	echo "  -h                  show this help message"
+	echo
+	echo "  -t {fs|net}:FILE:ACCESS"
+	echo "                      add Landlock topology which describes how workload"
+	echo "                      should be sandboxed by Landlock."
+	echo "                      * FILE contains lines of following format: \"NR KEY\\n\""
+	echo "                        (e.g. \"1 /usr/bin/find\n\").  When sandboxing, a rule"
+	echo "                        on the NR layer with ACCESS access_mask will be added"
+	echo "                        for each key KEY"
+	echo "                      * ACCESS has binary string format. Sets ruleset"
+	echo "                        handled_access and access_mask for each key."
+	echo
+
+	exit $KSFT_XFAIL
+}
+
+add_sandboxer_args()
+{
+	ACCESS=$(echo $1 | cut -d':' -f3)
+
+	rule_type=$(echo $1 | cut -d':' -f1)
+	args=$(echo $1 | cut -d':' -f2,3)
+	SANDBOXER_ARGS+=$(echo ' '--$rule_type $args)
+}
+
+parse_and_check_arguments()
+{
+	while getopts smp:e:r:o:t:D:c:h arg
+	do
+		case $arg in
+			e) TRACED_SYSCALLS=$OPTARG ;;
+			t) add_sandboxer_args $OPTARG ;;
+			p) PERF_BIN=`realpath $OPTARG` ;;
+			D) SANDBOX_DELAY=$OPTARG ;;
+			r) REPEAT=$OPTARG ;;
+			o) OUTPUT=$OPTARG ;;
+			c) CPU_AFFINITY=$OPTARG ;;
+			s) SILENCE=true ;;
+			h) help ;;
+		esac
+	done
+
+	shift $(($OPTIND - 1))
+	WORKLOAD=$@
+
+	if [ ! -f $SANDBOXER_BIN ]; then
+		err Sandboxer binary does not exist
+	fi
+
+	if [ -z "$WORKLOAD" ]; then
+		err Specify workload cmd
+	fi
+
+	if [ -z "$TRACED_SYSCALLS" ]; then
+		err Specify traced syscalls
+	fi
+
+	if [ ! -z "$WORKLOAD" ] && [ ! -f $PERF_BIN ]; then
+		err Perf binary does not exist
+	fi
+	if [ ! -z "$WORKLOAD" ] && [ -z "$SANDBOXER_ARGS" ]; then
+		err Landlock topology is not specified
+	fi
+}
+
+# perf trace
+header='/^[[:space:]]*$/d;'
+header+=';/^.* ([0-9]*), [0-9]* events, .*%$/d;'
+header+=';/^   syscall            calls  errors  total       min       avg       max       stddev$/d'
+header+=';/^                                     (msec)    (msec)    (msec)    (msec)        (%)$/d'
+header+=';/^   --------------- --------  ------ -------- --------- --------- ---------     ------$/d'
+header+=';/^ Summary of events:$/d'
+
+rm_headers()
+{
+	sed -i "$header" $1
+}
+
+print()
+{
+	fmt=$1
+	shift 1
+	if [ ! -z "$OUTPUT" ]; then
+		printf "$fmt" $@ >> $OUTPUT
+	else
+		printf "$fmt" $@
+	fi
+}
+
+dump_avg_durations_epoch()
+{
+	awk '{
+		calls[$1]+=$2
+		durations[$1]+=$4
+	}
+	END {
+		for(i in calls) {
+			if (calls[i] != 0 && durations[i] != 0) {
+				print i, durations[i] / calls[i] * 1000, calls[i]
+			}
+		}
+	}' $1
+}
+
+dump_avg_durations()
+{
+	awk '{
+		count[$1]+=1
+		dur[$1, count[$1]]+=$2
+		calls[$1]+=$3
+	}
+	END {
+		for(sys in calls) {
+			if (calls[sys] == 0 || count[sys] == 0)
+				continue
+			min = 1000000000
+			max = 0
+			total = 0
+			for (i = 1; i <= count[sys]; i++) {
+				min = (min < dur[sys, i]) ? min : dur[sys, i]
+				max = (max > dur[sys, i]) ? max : dur[sys, i]
+				total += dur[sys, i]
+			}
+			stddev = 0
+			avg = total / count[sys]
+			for (i = 1; i <= count[sys]; i++) {
+				stddev += (dur[sys, i] - avg) * (dur[sys, i] - avg)
+			}
+			if (total && count[sys] > 1 && avg)
+				stddev = sqrt(stddev / (count[sys] - 1)) / avg * 100
+
+			printf("%-20s %8d %7.2Lf %7.2Lf %7.2Lf %5.2Lf%%\n",
+				sys, calls[sys], avg, min, max, stddev);
+		}
+	}' $1
+}
+
+print_overhead()
+{
+	dump_avg_durations $BASE_TRACE_DUMP > $TMP_BUF && mv $TMP_BUF $BASE_TRACE_DUMP
+	dump_avg_durations $LL_TRACE_DUMP > $TMP_BUF && mv $TMP_BUF $LL_TRACE_DUMP
+
+	print "\nTracing results\n"
+	print "===============\n"
+	print "cmd: "
+	print "%s " $WORKLOAD
+	print "\n"
+	print "syscalls: %s\n" $TRACED_SYSCALLS
+	print "access: %s\n" $ACCESS
+
+	print "overhead:\n"
+	print "    %-20s %10s %10s %23s\n" "syscall" "bcalls" "scalls" "duration+overhead(us)"
+	print "    %-20s %10s %10s %23s\n" "=======" "======" "======" "====================="
+
+	while read -r base_line
+	do
+		base_line=$(echo "$base_line" | sed 's/ \+ / /g')
+		sys_name=$(echo "$base_line" | cut -d " " -f 1)
+		ll_line=$(cat $LL_TRACE_DUMP | grep -w $sys_name | sed 's/ \+ / /g')
+
+		base_duration=$(echo "$base_line" | cut -d " " -f 3)
+		base_calls=$(echo "$base_line" | cut -d " " -f 2)
+
+		ll_duration=$(echo "$ll_line" | cut -d " " -f 3)
+		ll_calls=$(echo "$ll_line" | cut -d " " -f 2)
+
+		overhead=$(bc -l <<< "scale=2; $ll_duration/$base_duration*100 - 100")
+		overhead_us=$(bc -l <<< "scale=2; $ll_duration - $base_duration")
+
+		if (( $(bc -l <<< "$overhead < 0") )); then
+			overhead_str=$(printf "%.2Lf%.2Lf(%.1Lf%%)" \
+									$base_duration $overhead_us $overhead)
+		else
+			overhead_str=$(printf "%.2Lf+%.2Lf(+%.1Lf%%)" \
+									$base_duration $overhead_us $overhead)
+		fi
+
+		print "    %-20s %10d %10d %23s\n" $sys_name $base_calls $ll_calls $overhead_str
+	done < $BASE_TRACE_DUMP
+}
+
+run_traced_workload()
+{
+	if [ $1 == 0 ]; then
+		output=$BASE_TRACE_DUMP
+		sandbox_cmd=
+	else
+		output=$LL_TRACE_DUMP
+		sandbox_cmd="$SANDBOXER_BIN $SANDBOXER_ARGS"
+	fi
+
+	echo '' > $output
+
+	start=$(date +%s%3N)
+
+	for i in $(seq 1 $REPEAT);
+	do
+		if $SILENCE; then
+			$TRACE_CMD $sandbox_cmd $WORKLOAD > /dev/null
+		else
+			$TRACE_CMD $sandbox_cmd $WORKLOAD
+		fi
+
+		res=$?
+		if [ $res != 0 ]; then
+			exit $KSFT_FAIL
+		fi
+
+		rm_headers $TMP_BUF
+		output_avg="$(dump_avg_durations_epoch $TMP_BUF)"
+		echo "$output_avg" >> $output
+	done
+
+	end=$(date +%s%3N)
+
+	duration=$((end - start))
+	sec=$((duration / 1000))
+	msec=$((duration % 1000))
+
+	echo "${sec}.${msec}s elapsed"
+}
+
+trap "exit $KSFT_SKIP" INT
+
+parse_and_check_arguments $@
+
+if [ ! -z "$OUTPUT" ]; then
+	echo '' > $OUTPUT
+fi
+
+TRACE_CMD="$PERF_BIN trace -s -e $TRACED_SYSCALLS -D $SANDBOX_DELAY -o $TMP_BUF"
+TRACE_CMD+=" $TASKSET -c $CPU_AFFINITY"
+TRACE_CMD+=" $NICE -n -19"
+
+if [ ! -z "$WORKLOAD" ]; then
+	echo "Tracing baseline workload..."
+	run_traced_workload 0
+
+	echo "Tracing sandboxed workload..."
+	run_traced_workload 1
+
+	print_overhead
+fi
diff --git a/tools/testing/selftests/landlock/bench/sandboxer.c b/tools/testing/selftests/landlock/bench/sandboxer.c
new file mode 100644
index 000000000000..73dfd7b8b196
--- /dev/null
+++ b/tools/testing/selftests/landlock/bench/sandboxer.c
@@ -0,0 +1,380 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Restrict and execute specified command.
+ * Run with -h flag to see sandboxer rules insertion format and supported
+ * rule types.
+ *
+ * Copyright © 2024 Huawei Tech. Co., Ltd.
+ */
+#define _GNU_SOURCE
+
+#include <linux/landlock.h>
+#include <stdio.h>
+#include <sys/prctl.h>
+#include <fcntl.h>
+#include <stdbool.h>
+#include <stdlib.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <sys/syscall.h>
+#include <errno.h>
+#include <string.h>
+#include <unistd.h>
+#include <assert.h>
+#include <err.h>
+#include <getopt.h>
+
+#ifndef landlock_create_ruleset
+static inline int
+landlock_create_ruleset(const struct landlock_ruleset_attr *const attr,
+			const size_t size, const __u32 flags)
+{
+	return syscall(__NR_landlock_create_ruleset, attr, size, flags);
+}
+#endif
+
+#ifndef landlock_add_rule
+static inline int landlock_add_rule(const int ruleset_fd,
+				    const enum landlock_rule_type rule_type,
+				    const void *const rule_attr,
+				    const __u32 flags)
+{
+	return syscall(__NR_landlock_add_rule, ruleset_fd, rule_type, rule_attr,
+		       flags);
+}
+#endif
+
+#ifndef landlock_restrict_self
+static inline int landlock_restrict_self(const int ruleset_fd,
+					 const __u32 flags)
+{
+	return syscall(__NR_landlock_restrict_self, ruleset_fd, flags);
+}
+#endif
+
+#define ACCESS_FILE                                                   \
+	(LANDLOCK_ACCESS_FS_EXECUTE | LANDLOCK_ACCESS_FS_WRITE_FILE | \
+	 LANDLOCK_ACCESS_FS_READ_FILE | LANDLOCK_ACCESS_FS_TRUNCATE | \
+	 LANDLOCK_ACCESS_FS_IOCTL_DEV)
+
+/* Cf. security/landlock/limits.h */
+#define LANDLOCK_MAX_NUM_LAYERS 16
+#define LANDLOCK_MAX_RULE (LANDLOCK_RULE_NET_PORT + 1)
+
+#define STRTOPOLOGY_DELIM ":"
+
+#define pr_warn(fmt, ...) fprintf(stderr, fmt, ##__VA_ARGS__)
+
+#define STRBUF_MAXLEN 128
+
+static struct {
+	char path[STRBUF_MAXLEN];
+	unsigned long long handled_access;
+} landlock_topologies[LANDLOCK_MAX_RULE] = {};
+
+static int get_ruleset_data_source(enum landlock_rule_type rule_type,
+				   const char *strtopology)
+{
+	unsigned long long handled_access;
+	char strtopology_buf[STRBUF_MAXLEN], *str_access, *str_file;
+
+	assert(strlen(strtopology) < STRBUF_MAXLEN);
+
+	strcpy(strtopology_buf, strtopology);
+	str_access = strtopology_buf;
+	str_file = strsep(&str_access, STRTOPOLOGY_DELIM);
+
+	if (!str_file) {
+		pr_warn("Landlock topology is partially specified\n");
+		goto out;
+	}
+
+	strncpy(landlock_topologies[rule_type].path, str_file,
+		sizeof(landlock_topologies[rule_type].path));
+
+	/* errno is set in strtol() on error. */
+	errno = 0;
+	handled_access = (unsigned long long)strtol(str_access, NULL, 16);
+	if (errno) {
+		pr_warn("Failed trying to parse handled_access: %s\n",
+			str_access);
+		goto out;
+	}
+	landlock_topologies[rule_type].handled_access = handled_access;
+
+	return 0;
+out:
+	return 1;
+}
+
+static int add_rule_from_str_fs(const char *strkey, const int ruleset_fd)
+{
+	int err = 1;
+	struct stat statbuf;
+	struct landlock_path_beneath_attr path_beneath;
+
+	path_beneath.parent_fd = open(strkey, O_PATH | O_CLOEXEC);
+
+	if (path_beneath.parent_fd < 0) {
+		pr_warn("Failed to open \"%s\": %s\n", strkey, strerror(errno));
+		goto cleanup;
+	}
+	if (fstat(path_beneath.parent_fd, &statbuf)) {
+		pr_warn("Failed to stat \"%s\": %s\n", strkey, strerror(errno));
+		goto cleanup;
+	}
+	path_beneath.allowed_access =
+		landlock_topologies[LANDLOCK_RULE_PATH_BENEATH].handled_access;
+
+	if (!S_ISDIR(statbuf.st_mode))
+		path_beneath.allowed_access &= ACCESS_FILE;
+
+	if (landlock_add_rule(ruleset_fd, LANDLOCK_RULE_PATH_BENEATH,
+			      &path_beneath, 0)) {
+		pr_warn("Failed to update the ruleset with \"%s\": %s\n",
+			strkey, strerror(errno));
+		goto cleanup;
+	}
+	err = 0;
+cleanup:
+	close(path_beneath.parent_fd);
+	return err;
+}
+
+static int add_rule_from_str_net(const char *strkey, const int ruleset_fd)
+{
+	struct landlock_net_port_attr net_port;
+	int port;
+
+	/* errno is set in atoi() on error. */
+	errno = 0;
+	port = atoi(strkey);
+	if (errno) {
+		pr_warn("atoi() failed on %s\n", strkey);
+		goto out;
+	}
+
+	net_port.port = port;
+	net_port.allowed_access =
+		landlock_topologies[LANDLOCK_RULE_NET_PORT].handled_access;
+
+	if (landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT, &net_port,
+			      0)) {
+		pr_warn("Failed to update the ruleset with \"%s\": %s\n",
+			strkey, strerror(errno));
+		goto out;
+	}
+	return 0;
+out:
+	return 1;
+}
+
+static int landlock_init_topology_layer(const int ruleset_fd,
+					enum landlock_rule_type rule_type,
+					FILE *topology_fp, unsigned int n_layer,
+					bool *changed)
+{
+	int err = 1;
+	char *strrule = NULL, *strrule_parsed, *strrule_next;
+	char *newline;
+	size_t file_pos = 0;
+	int n_rule_layer;
+	int (*add_rule_from_str)(const char *strkey, const int ruleset_fd);
+
+	switch (rule_type) {
+	case LANDLOCK_RULE_PATH_BENEATH:
+		add_rule_from_str = add_rule_from_str_fs;
+		break;
+	case LANDLOCK_RULE_NET_PORT:
+		add_rule_from_str = add_rule_from_str_net;
+		break;
+	default:
+		assert(0 && "Incorrect rule_type");
+	}
+
+	fseek(topology_fp, 0, SEEK_SET);
+
+	while (getline(&strrule, &file_pos, topology_fp) != -1) {
+		strrule_parsed = strrule;
+
+		newline = strchr(strrule_parsed, '\n');
+		if (newline)
+			*newline = 0;
+
+		strrule_next = strsep(&strrule_parsed, " ");
+		if (!strrule_next) {
+			pr_warn("Failed to parse rule: \"%s\"\n", strrule);
+			goto cleanup;
+		}
+
+		/* errno is set in atoi() on error. */
+		errno = 0;
+		n_rule_layer = atoi(strrule_next);
+		if (errno) {
+			pr_warn("atoi() failed on %s\n", strrule_next);
+			goto cleanup;
+		}
+
+		if (n_rule_layer != n_layer)
+			continue;
+		if (n_rule_layer >= LANDLOCK_MAX_NUM_LAYERS) {
+			pr_warn("Layer number exceeds the allowed value for the key: %s\n",
+				strrule_next);
+			goto cleanup;
+		}
+
+		if (add_rule_from_str(strrule_parsed, ruleset_fd))
+			goto cleanup;
+
+		*changed = true;
+	}
+
+	if (!feof(topology_fp)) {
+		pr_warn("Failed to read lines from \"%s\"\n",
+			landlock_topologies[rule_type].path);
+		goto cleanup;
+	}
+
+	err = 0;
+cleanup:
+	free(strrule);
+	return err;
+}
+
+static int landlock_do_sandboxing(void)
+{
+	int err = 1;
+	int ruleset_fd;
+	FILE *fp[LANDLOCK_MAX_RULE] = {};
+	const char *path;
+	unsigned int n_layer = 1;
+	bool changed = true;
+
+	struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_fs =
+			landlock_topologies[LANDLOCK_RULE_PATH_BENEATH]
+				.handled_access,
+		.handled_access_net =
+			landlock_topologies[LANDLOCK_RULE_NET_PORT]
+				.handled_access,
+	};
+
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	if (ruleset_fd < 0) {
+		pr_warn("Failed to create a ruleset: %s\n", strerror(errno));
+		return 1;
+	}
+
+	for (int rule_type = 0; rule_type < LANDLOCK_MAX_RULE; rule_type++) {
+		if (!landlock_topologies[rule_type].handled_access)
+			continue;
+		path = landlock_topologies[rule_type].path;
+		fp[rule_type] = fopen(path, "r");
+		if (!fp[rule_type]) {
+			fprintf(stderr,
+				"Failed to open topology fp \"%s\": %s\n", path,
+				strerror(errno));
+			goto cleanup;
+		}
+	}
+
+	while (changed) {
+		changed = false;
+
+		for (int rule_type = 0; rule_type < LANDLOCK_MAX_RULE;
+		     rule_type++) {
+			if (!landlock_topologies[rule_type].handled_access)
+				continue;
+			if (landlock_init_topology_layer(ruleset_fd, rule_type,
+							 fp[rule_type], n_layer,
+							 &changed))
+				goto cleanup;
+		}
+
+		if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
+			pr_warn("Failed to restrict privileges: %s\n",
+				strerror(errno));
+			goto cleanup;
+		}
+		if (landlock_restrict_self(ruleset_fd, 0)) {
+			pr_warn("Failed to enforce ruleset\n");
+			goto cleanup;
+		}
+		n_layer++;
+	}
+
+	err = 0;
+cleanup:
+	for (int rule_type = 0; rule_type < LANDLOCK_MAX_RULE; rule_type++) {
+		if (fp[rule_type])
+			fclose(fp[rule_type]);
+	}
+
+	close(ruleset_fd);
+	return err;
+}
+
+int main(const int argc, char *const argv[])
+{
+	int c, longind = -1;
+	const char *cmd = NULL;
+	enum landlock_rule_type rule_type;
+
+	static struct option options[] = {
+		{ "fs", required_argument, NULL, 'f' },
+		{ "net", required_argument, NULL, 'n' },
+		{ "help", optional_argument, NULL, 'h' },
+		{ NULL, 0, NULL, 0 },
+	};
+
+	while ((c = getopt_long(argc, argv, "f:n:h", options, &longind)) !=
+	       -1) {
+		if (longind == -1) {
+			pr_warn("%s: invalid option -- \'%s\'\n", argv[0],
+				argv[optind - 1]);
+			goto out;
+		}
+		switch (c) {
+		case 'f':
+			rule_type = LANDLOCK_RULE_PATH_BENEATH;
+			get_ruleset_data_source(rule_type, optarg);
+			break;
+		case 'n':
+			rule_type = LANDLOCK_RULE_NET_PORT;
+			get_ruleset_data_source(rule_type, optarg);
+			break;
+		case 'h':
+			pr_warn("Usage: %s [-{fs|net} FILE:ACCESS]\n"
+				"\n"
+				"* FILE contains lines of following format: \"NR KEY\\n\" (e.g. \"1 /usr/bin/find\").\n"
+				"  When sandboxing, a rule on the NR layer with ACCESS access_mask will be added\n"
+				"  for each key KEY\n"
+				"* ACCESS is a binary string. Sets handled_access for ruleset and access_mask\n"
+				"  for each key\n",
+				argv[0]);
+			goto out;
+		}
+
+		/* Next argument is workload. */
+		if (optind < argc && *argv[optind] != '-')
+			break;
+		longind = -1;
+	}
+
+	if (optind >= argc) {
+		pr_warn("Command is not specified\n");
+		goto out;
+	}
+	if (landlock_do_sandboxing())
+		goto out;
+
+	cmd = argv[optind];
+	execv(cmd, argv + optind);
+
+	pr_warn("Failed to execute \"%s\": %s\n", cmd, strerror(errno));
+	pr_warn("Hint: access to the binary, the interpreter or "
+		"shared libraries may be denied.\n");
+out:
+	return 1;
+}
diff --git a/tools/testing/selftests/landlock/config b/tools/testing/selftests/landlock/config
index 29af19c4e9f9..e4bf29cf935f 100644
--- a/tools/testing/selftests/landlock/config
+++ b/tools/testing/selftests/landlock/config
@@ -1,5 +1,7 @@
 CONFIG_CGROUPS=y
 CONFIG_CGROUP_SCHED=y
+CONFIG_CMDLINE="isolcpus=0 nohz_full=0 nosmt cpufreq.off=1"
+CONFIG_CMDLINE_BOOL=y
 CONFIG_INET=y
 CONFIG_IPV6=y
 CONFIG_KEYS=y
-- 
2.34.1

