Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7869A7462;
	Fri, 16 Aug 2024 01:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723770024; cv=none; b=Wf/6M5MwXUXFhgIlzA3dwQhY+JODjsEpYciME9qEu9+VSBg7riFw6QhEjLLWjQhjHrKTwdkLBjOykrfA5YLef2s4u0Sdm5pmOAFdQND/GccDA45ZJRdbjRU5ONZQzyIS5o4ZnzTxF28BfAH8vsb/ojNCMiZHfQhUMIJd3hPw104=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723770024; c=relaxed/simple;
	bh=oMzbhwYIzypp/BiSMM/MLGgXO+Hp9xkaGeZ0eVSgKYI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dARu28xxIdolCRX6+sE/qwyPbmfl4md/LBJmsbpnDkiH458iuIrU3W65qJIj91D33kJMbiz/oabPKdR+NcyE0O5wTiYo1OA6ku4agHgXumibNV7anGdABMj4/fxXUzPnn9rxxvcW4lut2PaUd5Gsi4dFvqacN2cXMAL5h0EXxSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4WlNsF73Dyz1xtyC;
	Fri, 16 Aug 2024 08:58:25 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 1DC3614010C;
	Fri, 16 Aug 2024 09:00:18 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 16 Aug 2024 09:00:16 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v1 2/4] selftests/landlock: Implement per-syscall microbenchmarks
Date: Fri, 16 Aug 2024 08:59:41 +0800
Message-ID: <20240816005943.1832694-3-ivanov.mikhail1@huawei-partners.com>
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

Microbenchmarking is a simple and most common way to obtain stable
measurement results on operations such as syscalls.

* Add bench/microbench.c script. Each microbenchmark in this script is
  configured with Landlock ruleset and access right required by sandboxer
  and with a simple function that executes syscall in a loop. Currently,
  only openat(2) is supported.

* Add bench/common.c and move there sandboxing-related functions
  from bench/sandboxer.c. This is necessary so that bench/microbench.c can
  directly use sandboxing methods without spawning sandboxer process.

* Support microbenchmarking option in bench/run.sh. In order to
  provide stable metrics, number of syscall samples is dynamically
  increased after run until standard deviation of samples divided by mean
  is less than 0.1%.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
 tools/testing/selftests/landlock/Makefile     |   7 +-
 .../testing/selftests/landlock/bench/common.c | 283 ++++++++++++++++++
 .../testing/selftests/landlock/bench/common.h |  18 ++
 .../selftests/landlock/bench/microbench.c     | 192 ++++++++++++
 tools/testing/selftests/landlock/bench/run.sh | 130 ++++++--
 .../selftests/landlock/bench/sandboxer.c      | 275 +----------------
 6 files changed, 616 insertions(+), 289 deletions(-)
 create mode 100644 tools/testing/selftests/landlock/bench/common.c
 create mode 100644 tools/testing/selftests/landlock/bench/common.h
 create mode 100644 tools/testing/selftests/landlock/bench/microbench.c

diff --git a/tools/testing/selftests/landlock/Makefile b/tools/testing/selftests/landlock/Makefile
index 410e8cd28707..e149ef66841a 100644
--- a/tools/testing/selftests/landlock/Makefile
+++ b/tools/testing/selftests/landlock/Makefile
@@ -10,7 +10,7 @@ src_test := $(wildcard *_test.c)
 
 TEST_GEN_PROGS := $(src_test:.c=)
 
-TEST_GEN_PROGS_EXTENDED := true bench/sandboxer
+TEST_GEN_PROGS_EXTENDED := true bench/sandboxer bench/microbench
 
 TEST_PROGS_EXTENDED := bench/run.sh
 
@@ -20,6 +20,11 @@ $(TEST_GEN_PROGS_EXTENDED): LDFLAGS += -static
 
 include ../lib.mk
 
+$(OUTPUT)/bench/microbench: bench/microbench.c bench/common.c
+$(OUTPUT)/bench/sandboxer: bench/sandboxer.c bench/common.c
+
 # Targets with $(OUTPUT)/ prefix:
 $(TEST_GEN_PROGS): LDLIBS += -lcap
 $(TEST_GEN_PROGS_EXTENDED): LDFLAGS += -static
+
+EXTRA_CLEAN = $(OUTPUT)/common.o
diff --git a/tools/testing/selftests/landlock/bench/common.c b/tools/testing/selftests/landlock/bench/common.c
new file mode 100644
index 000000000000..8f7ff744e606
--- /dev/null
+++ b/tools/testing/selftests/landlock/bench/common.c
@@ -0,0 +1,283 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Methods to configure and apply Landlock ruleset from file.
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
+
+#include "common.h"
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
+static struct {
+	char path[STRBUF_MAXLEN];
+	unsigned long long handled_access;
+} landlock_topologies[LANDLOCK_MAX_RULE] = {};
+
+void set_ruleset_config(enum landlock_rule_type rule_type,
+			const char *topology_file,
+			unsigned long long access_right)
+{
+	strncpy(landlock_topologies[rule_type].path, topology_file,
+		sizeof(landlock_topologies[rule_type].path));
+	landlock_topologies[rule_type].handled_access = access_right;
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
+int landlock_do_sandboxing(void)
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
diff --git a/tools/testing/selftests/landlock/bench/common.h b/tools/testing/selftests/landlock/bench/common.h
new file mode 100644
index 000000000000..bfb53624fbca
--- /dev/null
+++ b/tools/testing/selftests/landlock/bench/common.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef LANDLOCK_BENCH_COMMON_H
+#define LANDLOCK_BENCH_COMMON_H
+
+#include <stdio.h>
+#include <linux/landlock.h>
+
+#define STRBUF_MAXLEN 128
+
+extern void set_ruleset_config(enum landlock_rule_type rule_type,
+			       const char *topology_file,
+			       unsigned long long access_right);
+
+extern int landlock_do_sandboxing(void);
+
+#define pr_warn(fmt, ...) fprintf(stderr, fmt, ##__VA_ARGS__)
+
+#endif
diff --git a/tools/testing/selftests/landlock/bench/microbench.c b/tools/testing/selftests/landlock/bench/microbench.c
new file mode 100644
index 000000000000..6c073eaad7df
--- /dev/null
+++ b/tools/testing/selftests/landlock/bench/microbench.c
@@ -0,0 +1,192 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Microbenchmark syscall workload.
+ *
+ * Copyright © 2024 Huawei Tech. Co., Ltd.
+ */
+
+#include <time.h>
+#define _GNU_SOURCE
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <getopt.h>
+#include <string.h>
+#include <unistd.h>
+#include <time.h>
+#include <linux/landlock.h>
+#include <assert.h>
+
+#include "common.h"
+
+#define SYS_DELIM ","
+
+static const char topology_file[] = ".topology";
+
+static void run_openat(int samples)
+{
+	int fd;
+
+	while (samples--) {
+		fd = open("/dev/zero", O_RDONLY);
+		close(fd);
+	}
+}
+
+static const struct {
+	const char name[STRBUF_MAXLEN];
+	const char descr[STRBUF_MAXLEN];
+	enum landlock_rule_type rule_type;
+	unsigned long long access;
+	const char landlock_topology[10 * STRBUF_MAXLEN];
+	void (*run)(int samples);
+} workload_protos[] = {
+	{
+		.name = "openat",
+		.descr =
+			"open /dev/zero file with O_RDONLY and immediately close it",
+		.rule_type = LANDLOCK_RULE_PATH_BENEATH,
+		.access = LANDLOCK_ACCESS_FS_READ_FILE,
+		.landlock_topology = "1 /dev/zero\n",
+		.run = run_openat,
+	},
+};
+
+static const int n_workload_protos =
+	sizeof(workload_protos) / sizeof(*workload_protos);
+
+static int dump_topology(int n_proto)
+{
+	int err = 0;
+	FILE *fp = NULL;
+	const char *topology;
+	size_t bytes_to_write;
+
+	fp = fopen(topology_file, "w");
+
+	if (!fp) {
+		pr_warn("Unable to open file %s\n", topology_file);
+		goto out;
+	}
+
+	topology = workload_protos[n_proto].landlock_topology;
+	bytes_to_write = strlen(topology);
+
+	if (bytes_to_write !=
+	    fwrite(topology, sizeof(char), bytes_to_write, fp)) {
+		pr_warn("Failed to dump topology into %s\n", topology_file);
+		goto out;
+	}
+
+	err = 0;
+out:
+	fclose(fp);
+	return err;
+}
+
+static int sandbox_proto(int n_proto)
+{
+	int err = 1;
+
+	err = dump_topology(n_proto);
+	if (err)
+		goto out;
+
+	set_ruleset_config(workload_protos[n_proto].rule_type, topology_file,
+			   workload_protos[n_proto].access);
+
+	err = landlock_do_sandboxing();
+	if (err)
+		goto out;
+
+	err = 0;
+out:
+	return err;
+}
+
+int main(const int argc, char *const argv[])
+{
+	int c, samples = -1, err = 1;
+	int is_sandbox = 0;
+	const char *strsys = NULL;
+	struct timespec start, finish;
+	unsigned long long duration, sample_duration;
+
+	while ((c = getopt(argc, argv, "n:e:sh")) != -1) {
+		switch (c) {
+		case 'n':
+			/* errno is set in atoi() on error. */
+			errno = 0;
+			samples = atoi(optarg);
+			if (errno) {
+				pr_warn("atoi() failed on %s\n", optarg);
+				goto out;
+			}
+			break;
+		case 'e':
+			strsys = optarg;
+			break;
+		case 's':
+			is_sandbox = 1;
+			break;
+		case 'h':
+			pr_warn("Usage: %s [OPTIONS]\n"
+				"\n"
+				"Options:\n"
+				"  -n SAMPLES            number of syscall samples to execute\n"
+				"  -e SYSCALL_LIST       specify syscalls which would be used as workload\n"
+				"\n"
+				"Following cases are implemented:\n",
+				argv[0]);
+
+			for (int i = 0; i < n_workload_protos; i++) {
+				pr_warn("* %s\t%s\n", workload_protos[i].name,
+					workload_protos[i].descr);
+			}
+			pr_warn("\n");
+			goto out;
+		}
+	}
+
+	if (!strsys) {
+		pr_warn("Syscalls are not specified\n");
+		goto out;
+	}
+
+	if (samples < 1) {
+		pr_warn("Samples are not specified\n");
+		goto out;
+	}
+
+	for (int i = 0; i < n_workload_protos; i++) {
+		if (strcmp(strsys, workload_protos[i].name) == 0) {
+
+			if (is_sandbox) {
+				if (sandbox_proto(i))
+					goto out;
+			}
+
+			assert(clock_gettime(CLOCK_PROCESS_CPUTIME_ID,
+					     &start) == 0);
+			workload_protos[i].run(samples);
+			assert(clock_gettime(CLOCK_PROCESS_CPUTIME_ID,
+					     &finish) == 0);
+
+			duration = finish.tv_sec - start.tv_sec;
+			duration *= 1000000000ULL;
+			duration += finish.tv_nsec - start.tv_nsec;
+
+			sample_duration = duration / samples;
+
+			pr_warn("%llu ns/sample\n", sample_duration);
+			break;
+		}
+	}
+
+	err = 0;
+out:
+	return err;
+}
diff --git a/tools/testing/selftests/landlock/bench/run.sh b/tools/testing/selftests/landlock/bench/run.sh
index afbcbb2ba6aa..582313f689ad 100755
--- a/tools/testing/selftests/landlock/bench/run.sh
+++ b/tools/testing/selftests/landlock/bench/run.sh
@@ -15,6 +15,8 @@ KSFT_SKIP=4
 REL_DIR=$(dirname $(realpath $0))
 PERF_BIN=/usr/bin/perf
 SANDBOXER_BIN=$REL_DIR/sandboxer
+MICROBENCH_BIN=$REL_DIR/microbench
+CUSTOM_TRACER_BIN=$REL_DIR/tracer
 TASKSET=/usr/bin/taskset
 NICE=/usr/bin/nice
 
@@ -27,6 +29,7 @@ OUTPUT=
 SANDBOXER_ARGS=
 ACCESS=
 TRACED_SYSCALLS=
+MICROBENCH=false
 WORKLOAD=
 SILENCE=false
 TRACE_CMD=
@@ -34,6 +37,8 @@ TRACE_CMD=
 CPU_AFFINITY=0
 SANDBOX_DELAY=300 # msecs
 REPEAT=5
+MICROBENCH_INITIAL_ITERATIONS=10000000
+STDDEV_STABLE=0.1 # %
 
 err()
 {
@@ -44,10 +49,12 @@ err()
 help()
 {
 	echo "Usage: $0 [OPTIONS] [WORKLOAD_CMD]"
+	echo "   or: $0 [OPTIONS] -m"
 	echo "Measure overhead of Landlock hooks for the specified workload."
 	echo
 	echo "Options:"
 	echo "  -e TRACED_SYSCALLS  specify syscalls which would be traced while benchmarking"
+	echo "  -m                  run microbenchmark workload for TRACED_SYSCALLS"
 	echo "  -p PERF_BINARY      use PERF_BINARY instead of /usr/bin/perf"
 	echo "  -D MSECS            wait MSECS msecs before tracing sandboxed workload"
 	echo "                      (default: $SANDBOX_DELAY)"
@@ -83,10 +90,11 @@ add_sandboxer_args()
 
 parse_and_check_arguments()
 {
-	while getopts smp:e:r:o:t:D:c:h arg
+	while getopts smbp:e:r:o:t:D:c:h arg
 	do
 		case $arg in
 			e) TRACED_SYSCALLS=$OPTARG ;;
+			m) MICROBENCH=true ;;
 			t) add_sandboxer_args $OPTARG ;;
 			p) PERF_BIN=`realpath $OPTARG` ;;
 			D) SANDBOX_DELAY=$OPTARG ;;
@@ -105,8 +113,13 @@ parse_and_check_arguments()
 		err Sandboxer binary does not exist
 	fi
 
-	if [ -z "$WORKLOAD" ]; then
-		err Specify workload cmd
+	# At least one must be present.
+	if [ -z "$WORKLOAD" ] && ! $MICROBENCH ; then
+		err Specify workload cmd or -m flag
+	fi
+
+	if [ $MICROBENCH ] && [ ! -f $SANDBOXER_BIN ]; then
+		err Binary of microbenchmarking script does not exist
 	fi
 
 	if [ -z "$TRACED_SYSCALLS" ]; then
@@ -198,14 +211,6 @@ print_overhead()
 	dump_avg_durations $BASE_TRACE_DUMP > $TMP_BUF && mv $TMP_BUF $BASE_TRACE_DUMP
 	dump_avg_durations $LL_TRACE_DUMP > $TMP_BUF && mv $TMP_BUF $LL_TRACE_DUMP
 
-	print "\nTracing results\n"
-	print "===============\n"
-	print "cmd: "
-	print "%s " $WORKLOAD
-	print "\n"
-	print "syscalls: %s\n" $TRACED_SYSCALLS
-	print "access: %s\n" $ACCESS
-
 	print "overhead:\n"
 	print "    %-20s %10s %10s %23s\n" "syscall" "bcalls" "scalls" "duration+overhead(us)"
 	print "    %-20s %10s %10s %23s\n" "=======" "======" "======" "====================="
@@ -237,14 +242,48 @@ print_overhead()
 	done < $BASE_TRACE_DUMP
 }
 
+print_overhead_workload()
+{
+	print "\nTracing results\n"
+	print "===============\n"
+	print "cmd: "
+	print "%s " $WORKLOAD
+	print "\n"
+	print "syscalls: %s\n" $TRACED_SYSCALLS
+	print "access: %s\n" $ACCESS
+
+	print_overhead
+}
+
+print_overhead_microbench()
+{
+	print "\nTracing results\n"
+	print "===============\n"
+	print "cmd: Microbenchmarks\n"
+	print "syscalls: %s\n" $TRACED_SYSCALLS
+
+	print_overhead
+}
+
+form_trace_cmd()
+{
+	trace_cmd=$TRACE_CMD
+	trace_cmd+=" -e $1 -D $SANDBOX_DELAY -o $TMP_BUF"
+	trace_cmd+=" $TASKSET -c $CPU_AFFINITY"
+	trace_cmd+=" $NICE -n -19"
+
+	echo $trace_cmd
+}
+
 run_traced_workload()
 {
+	trace_cmd=$(form_trace_cmd $TRACED_SYSCALLS)
+
 	if [ $1 == 0 ]; then
 		output=$BASE_TRACE_DUMP
-		sandbox_cmd=
 	else
 		output=$LL_TRACE_DUMP
-		sandbox_cmd="$SANDBOXER_BIN $SANDBOXER_ARGS"
+		trace_cmd+="$SANDBOXER_BIN $SANDBOXER_ARGS"
 	fi
 
 	echo '' > $output
@@ -254,9 +293,9 @@ run_traced_workload()
 	for i in $(seq 1 $REPEAT);
 	do
 		if $SILENCE; then
-			$TRACE_CMD $sandbox_cmd $WORKLOAD > /dev/null
+			$trace_cmd $WORKLOAD > /dev/null
 		else
-			$TRACE_CMD $sandbox_cmd $WORKLOAD
+			$trace_cmd $WORKLOAD
 		fi
 
 		res=$?
@@ -278,6 +317,47 @@ run_traced_workload()
 	echo "${sec}.${msec}s elapsed"
 }
 
+run_traced_microbench()
+{
+	if [ $1 == 0 ]; then
+		output=$BASE_TRACE_DUMP
+		sandbox_opt=
+	else
+		output=$LL_TRACE_DUMP
+		sandbox_opt=-s
+	fi
+
+	echo '' > $output
+
+	syscalls_to_parse=$(echo $TRACED_SYSCALLS | sed 's/,/\n/g')
+
+	for syscall in $syscalls_to_parse; do
+		n_iters=$MICROBENCH_INITIAL_ITERATIONS
+		trace_cmd=$(form_trace_cmd $syscall)
+
+		while
+			$trace_cmd $MICROBENCH_BIN -e $syscall -n $n_iters $sandbox_opt
+			res=$?
+			if [ $res != 0 ]; then
+				exit $KSFT_FAIL
+			fi
+
+			rm_headers $TMP_BUF
+			output_avg="$(dump_avg_durations_epoch $TMP_BUF)"
+			echo "$output_avg" > $TMP_BUF2
+
+			stddev=$(cat $TMP_BUF | sed 's/ \+ / /g' | cut -d " " -f $stddev_col)
+			stddev=${stddev::-1}
+
+			echo syscall: $syscall, stddev: $stddev%, iterations: $n_iters
+
+			n_iters=$(bc -l <<< "$n_iters*2")
+		[ $(bc -l <<< "$stddev < $STDDEV_STABLE") == 0 ]
+		do true; done
+		cat $TMP_BUF2 >> $output
+	done
+}
+
 trap "exit $KSFT_SKIP" INT
 
 parse_and_check_arguments $@
@@ -286,9 +366,11 @@ if [ ! -z "$OUTPUT" ]; then
 	echo '' > $OUTPUT
 fi
 
-TRACE_CMD="$PERF_BIN trace -s -e $TRACED_SYSCALLS -D $SANDBOX_DELAY -o $TMP_BUF"
-TRACE_CMD+=" $TASKSET -c $CPU_AFFINITY"
-TRACE_CMD+=" $NICE -n -19"
+if $CUSTOM_TRACER; then
+	TRACE_CMD=$CUSTOM_TRACER_BIN
+else
+	TRACE_CMD="$PERF_BIN trace -s"
+fi
 
 if [ ! -z "$WORKLOAD" ]; then
 	echo "Tracing baseline workload..."
@@ -297,5 +379,15 @@ if [ ! -z "$WORKLOAD" ]; then
 	echo "Tracing sandboxed workload..."
 	run_traced_workload 1
 
-	print_overhead
+	print_overhead_workload
+fi
+
+if $MICROBENCH; then
+	echo "Tracing baseline microbenchmarks..."
+	run_traced_microbench 0
+
+	echo "Tracing sandboxed microbenchmarks..."
+	run_traced_microbench 1
+
+	print_overhead_microbench
 fi
diff --git a/tools/testing/selftests/landlock/bench/sandboxer.c b/tools/testing/selftests/landlock/bench/sandboxer.c
index 73dfd7b8b196..dc41e48d7bf5 100644
--- a/tools/testing/selftests/landlock/bench/sandboxer.c
+++ b/tools/testing/selftests/landlock/bench/sandboxer.c
@@ -9,69 +9,17 @@
 #define _GNU_SOURCE
 
 #include <linux/landlock.h>
-#include <stdio.h>
-#include <sys/prctl.h>
-#include <fcntl.h>
-#include <stdbool.h>
-#include <stdlib.h>
-#include <sys/stat.h>
-#include <sys/types.h>
-#include <sys/syscall.h>
-#include <errno.h>
-#include <string.h>
 #include <unistd.h>
-#include <assert.h>
-#include <err.h>
 #include <getopt.h>
+#include <string.h>
+#include <errno.h>
+#include <assert.h>
+#include <stdlib.h>
 
-#ifndef landlock_create_ruleset
-static inline int
-landlock_create_ruleset(const struct landlock_ruleset_attr *const attr,
-			const size_t size, const __u32 flags)
-{
-	return syscall(__NR_landlock_create_ruleset, attr, size, flags);
-}
-#endif
-
-#ifndef landlock_add_rule
-static inline int landlock_add_rule(const int ruleset_fd,
-				    const enum landlock_rule_type rule_type,
-				    const void *const rule_attr,
-				    const __u32 flags)
-{
-	return syscall(__NR_landlock_add_rule, ruleset_fd, rule_type, rule_attr,
-		       flags);
-}
-#endif
-
-#ifndef landlock_restrict_self
-static inline int landlock_restrict_self(const int ruleset_fd,
-					 const __u32 flags)
-{
-	return syscall(__NR_landlock_restrict_self, ruleset_fd, flags);
-}
-#endif
-
-#define ACCESS_FILE                                                   \
-	(LANDLOCK_ACCESS_FS_EXECUTE | LANDLOCK_ACCESS_FS_WRITE_FILE | \
-	 LANDLOCK_ACCESS_FS_READ_FILE | LANDLOCK_ACCESS_FS_TRUNCATE | \
-	 LANDLOCK_ACCESS_FS_IOCTL_DEV)
-
-/* Cf. security/landlock/limits.h */
-#define LANDLOCK_MAX_NUM_LAYERS 16
-#define LANDLOCK_MAX_RULE (LANDLOCK_RULE_NET_PORT + 1)
+#include "common.h"
 
 #define STRTOPOLOGY_DELIM ":"
 
-#define pr_warn(fmt, ...) fprintf(stderr, fmt, ##__VA_ARGS__)
-
-#define STRBUF_MAXLEN 128
-
-static struct {
-	char path[STRBUF_MAXLEN];
-	unsigned long long handled_access;
-} landlock_topologies[LANDLOCK_MAX_RULE] = {};
-
 static int get_ruleset_data_source(enum landlock_rule_type rule_type,
 				   const char *strtopology)
 {
@@ -89,9 +37,6 @@ static int get_ruleset_data_source(enum landlock_rule_type rule_type,
 		goto out;
 	}
 
-	strncpy(landlock_topologies[rule_type].path, str_file,
-		sizeof(landlock_topologies[rule_type].path));
-
 	/* errno is set in strtol() on error. */
 	errno = 0;
 	handled_access = (unsigned long long)strtol(str_access, NULL, 16);
@@ -100,221 +45,13 @@ static int get_ruleset_data_source(enum landlock_rule_type rule_type,
 			str_access);
 		goto out;
 	}
-	landlock_topologies[rule_type].handled_access = handled_access;
-
-	return 0;
-out:
-	return 1;
-}
-
-static int add_rule_from_str_fs(const char *strkey, const int ruleset_fd)
-{
-	int err = 1;
-	struct stat statbuf;
-	struct landlock_path_beneath_attr path_beneath;
-
-	path_beneath.parent_fd = open(strkey, O_PATH | O_CLOEXEC);
-
-	if (path_beneath.parent_fd < 0) {
-		pr_warn("Failed to open \"%s\": %s\n", strkey, strerror(errno));
-		goto cleanup;
-	}
-	if (fstat(path_beneath.parent_fd, &statbuf)) {
-		pr_warn("Failed to stat \"%s\": %s\n", strkey, strerror(errno));
-		goto cleanup;
-	}
-	path_beneath.allowed_access =
-		landlock_topologies[LANDLOCK_RULE_PATH_BENEATH].handled_access;
-
-	if (!S_ISDIR(statbuf.st_mode))
-		path_beneath.allowed_access &= ACCESS_FILE;
-
-	if (landlock_add_rule(ruleset_fd, LANDLOCK_RULE_PATH_BENEATH,
-			      &path_beneath, 0)) {
-		pr_warn("Failed to update the ruleset with \"%s\": %s\n",
-			strkey, strerror(errno));
-		goto cleanup;
-	}
-	err = 0;
-cleanup:
-	close(path_beneath.parent_fd);
-	return err;
-}
-
-static int add_rule_from_str_net(const char *strkey, const int ruleset_fd)
-{
-	struct landlock_net_port_attr net_port;
-	int port;
-
-	/* errno is set in atoi() on error. */
-	errno = 0;
-	port = atoi(strkey);
-	if (errno) {
-		pr_warn("atoi() failed on %s\n", strkey);
-		goto out;
-	}
-
-	net_port.port = port;
-	net_port.allowed_access =
-		landlock_topologies[LANDLOCK_RULE_NET_PORT].handled_access;
 
-	if (landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT, &net_port,
-			      0)) {
-		pr_warn("Failed to update the ruleset with \"%s\": %s\n",
-			strkey, strerror(errno));
-		goto out;
-	}
+	set_ruleset_config(rule_type, str_file, handled_access);
 	return 0;
 out:
 	return 1;
 }
 
-static int landlock_init_topology_layer(const int ruleset_fd,
-					enum landlock_rule_type rule_type,
-					FILE *topology_fp, unsigned int n_layer,
-					bool *changed)
-{
-	int err = 1;
-	char *strrule = NULL, *strrule_parsed, *strrule_next;
-	char *newline;
-	size_t file_pos = 0;
-	int n_rule_layer;
-	int (*add_rule_from_str)(const char *strkey, const int ruleset_fd);
-
-	switch (rule_type) {
-	case LANDLOCK_RULE_PATH_BENEATH:
-		add_rule_from_str = add_rule_from_str_fs;
-		break;
-	case LANDLOCK_RULE_NET_PORT:
-		add_rule_from_str = add_rule_from_str_net;
-		break;
-	default:
-		assert(0 && "Incorrect rule_type");
-	}
-
-	fseek(topology_fp, 0, SEEK_SET);
-
-	while (getline(&strrule, &file_pos, topology_fp) != -1) {
-		strrule_parsed = strrule;
-
-		newline = strchr(strrule_parsed, '\n');
-		if (newline)
-			*newline = 0;
-
-		strrule_next = strsep(&strrule_parsed, " ");
-		if (!strrule_next) {
-			pr_warn("Failed to parse rule: \"%s\"\n", strrule);
-			goto cleanup;
-		}
-
-		/* errno is set in atoi() on error. */
-		errno = 0;
-		n_rule_layer = atoi(strrule_next);
-		if (errno) {
-			pr_warn("atoi() failed on %s\n", strrule_next);
-			goto cleanup;
-		}
-
-		if (n_rule_layer != n_layer)
-			continue;
-		if (n_rule_layer >= LANDLOCK_MAX_NUM_LAYERS) {
-			pr_warn("Layer number exceeds the allowed value for the key: %s\n",
-				strrule_next);
-			goto cleanup;
-		}
-
-		if (add_rule_from_str(strrule_parsed, ruleset_fd))
-			goto cleanup;
-
-		*changed = true;
-	}
-
-	if (!feof(topology_fp)) {
-		pr_warn("Failed to read lines from \"%s\"\n",
-			landlock_topologies[rule_type].path);
-		goto cleanup;
-	}
-
-	err = 0;
-cleanup:
-	free(strrule);
-	return err;
-}
-
-static int landlock_do_sandboxing(void)
-{
-	int err = 1;
-	int ruleset_fd;
-	FILE *fp[LANDLOCK_MAX_RULE] = {};
-	const char *path;
-	unsigned int n_layer = 1;
-	bool changed = true;
-
-	struct landlock_ruleset_attr ruleset_attr = {
-		.handled_access_fs =
-			landlock_topologies[LANDLOCK_RULE_PATH_BENEATH]
-				.handled_access,
-		.handled_access_net =
-			landlock_topologies[LANDLOCK_RULE_NET_PORT]
-				.handled_access,
-	};
-
-	ruleset_fd =
-		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
-	if (ruleset_fd < 0) {
-		pr_warn("Failed to create a ruleset: %s\n", strerror(errno));
-		return 1;
-	}
-
-	for (int rule_type = 0; rule_type < LANDLOCK_MAX_RULE; rule_type++) {
-		if (!landlock_topologies[rule_type].handled_access)
-			continue;
-		path = landlock_topologies[rule_type].path;
-		fp[rule_type] = fopen(path, "r");
-		if (!fp[rule_type]) {
-			fprintf(stderr,
-				"Failed to open topology fp \"%s\": %s\n", path,
-				strerror(errno));
-			goto cleanup;
-		}
-	}
-
-	while (changed) {
-		changed = false;
-
-		for (int rule_type = 0; rule_type < LANDLOCK_MAX_RULE;
-		     rule_type++) {
-			if (!landlock_topologies[rule_type].handled_access)
-				continue;
-			if (landlock_init_topology_layer(ruleset_fd, rule_type,
-							 fp[rule_type], n_layer,
-							 &changed))
-				goto cleanup;
-		}
-
-		if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
-			pr_warn("Failed to restrict privileges: %s\n",
-				strerror(errno));
-			goto cleanup;
-		}
-		if (landlock_restrict_self(ruleset_fd, 0)) {
-			pr_warn("Failed to enforce ruleset\n");
-			goto cleanup;
-		}
-		n_layer++;
-	}
-
-	err = 0;
-cleanup:
-	for (int rule_type = 0; rule_type < LANDLOCK_MAX_RULE; rule_type++) {
-		if (fp[rule_type])
-			fclose(fp[rule_type]);
-	}
-
-	close(ruleset_fd);
-	return err;
-}
-
 int main(const int argc, char *const argv[])
 {
 	int c, longind = -1;
-- 
2.34.1

