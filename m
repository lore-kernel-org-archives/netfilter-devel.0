Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F231221D011
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Oct 2025 22:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761603461; cv=none; b=OsnJZrP0oAWVh2Jv27HnvaievVWTh0MH3EviWmvbSFgSKjXDWOWz2lSHJ9MewQGPBAQdcI70gR4P/TBZYBxOglmnZSNP4Kbdrhwhkib7vMRx8UjcureaebjHaDL8ozBY+JMe5vUfGuSFSO7AlqBMOP5L9XiiPdstBThmdky6Plc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761603461; c=relaxed/simple;
	bh=MOwaQDjw9C4nrIOUjb2XNsiMQTnZDd+xRj06gWdab9Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=az1tJ4zwGvVVghvweMvyRDf5Mvph4iV1ozgLyHqrhADQC9B/lTfvrR6OFK2TEsIAu6DnsMW8Pz5mIXjYuhbVbPJVzfA29pX7Fak5SPkmsOZVc00/IdQQsqqRwRAMEgnCE28cQF6FSaxtLPQFbVN5h0oFTO1LaEwL80aOz+OT5rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Iwrg+poR; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Iwrg+poR"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D3D3A605AB;
	Mon, 27 Oct 2025 23:17:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1761603451;
	bh=vdMKgwJo3l6ywS8zsmF3VHgyMCyFJD+yDSGFbeY1ZlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iwrg+poRJAPDEXyYZxeGYrBVyO2zcCv8tieaJHl2+kqFj1KRgNPpN0IvD2sHPctaS
	 lwbll0mwqA3W6w9EOImTzWKPsH9+IwWmklkHL/tO4tv3oIaNcbgttJ7EXHkYYiKMKj
	 eB3/8opcfmUa2ZGL6EqDQ9FhccQTborss67kV3DPMKhEBGqNE/XiYS4OMsDbHmfOV6
	 WYUUx7WZ6IO4viZcIx+Uiy2mfvHbvzkli1W1RUtEIF0Kkhc6yi4yvQHZpimKi39IU8
	 iDnnHtyxCIoVYsm6tf9jYOlG7VYiCvgPvIn95M1Zd1wt3gV/P0C1gJxZ2yvwOCwfPb
	 CvBB8CxRHG6zw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	ffmancera@suse.de,
	brady.1345@gmail.com
Subject: [PATCH nf 2/2] selftests: netfilter: add test for nf_tables_jumps_max_netns sysctl
Date: Mon, 27 Oct 2025 23:17:22 +0100
Message-Id: <20251027221722.183398-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20251027221722.183398-1-pablo@netfilter.org>
References: <20251027221722.183398-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds gen_ruleset_many_jumps.c which is a program that
generates a random ruleset with many jumps and it estimates the number
of jumps that results from its evaluation.

nft_ruleset_many_jumps.sh creates the ruleset and tests if it loads or
fail as expected according to the estimated number of jumps.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: new in this series, in gen_ruleset_many_jumps.c:
    - create_ruleset() represents jump rules per chain at different levels
      in an array.
    - count_jumps() provides an estimation of the number of jumps in the worst
      case scenario which is similar to the DFS-based count that the kernel
      performs. This code can be generalised later on to make a tool for tuning
      nf_tables_jumps_max_netns, if user really ever needs to.

 .../testing/selftests/net/netfilter/Makefile  |   2 +
 .../net/netfilter/gen_ruleset_many_jumps.c    | 145 ++++++++++++++++++
 .../net/netfilter/nft_ruleset_many_jumps.sh   | 118 ++++++++++++++
 3 files changed, 265 insertions(+)
 create mode 100644 tools/testing/selftests/net/netfilter/gen_ruleset_many_jumps.c
 create mode 100755 tools/testing/selftests/net/netfilter/nft_ruleset_many_jumps.sh

diff --git a/tools/testing/selftests/net/netfilter/Makefile b/tools/testing/selftests/net/netfilter/Makefile
index ee2d1a5254f8..dc1b328be31d 100644
--- a/tools/testing/selftests/net/netfilter/Makefile
+++ b/tools/testing/selftests/net/netfilter/Makefile
@@ -31,6 +31,7 @@ TEST_PROGS := \
 	nft_meta.sh \
 	nft_nat.sh \
 	nft_nat_zones.sh \
+	nft_ruleset_many_jumps.sh \
 	nft_queue.sh \
 	nft_synproxy.sh \
 	nft_tproxy_tcp.sh \
@@ -48,6 +49,7 @@ TEST_GEN_FILES = \
 	connect_close \
 	conntrack_dump_flush \
 	conntrack_reverse_clash \
+	gen_ruleset_many_jumps \
 	nf_queue \
 	sctp_collision \
 	udpclash \
diff --git a/tools/testing/selftests/net/netfilter/gen_ruleset_many_jumps.c b/tools/testing/selftests/net/netfilter/gen_ruleset_many_jumps.c
new file mode 100644
index 000000000000..ddc150131bc7
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/gen_ruleset_many_jumps.c
@@ -0,0 +1,145 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <stdio.h>
+#include <time.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/time.h>
+#include <errno.h>
+
+#define MAX_LEVELS 10
+
+static void create_ruleset(int *rules, int *depth)
+{
+	struct timeval tv;
+	int levels;
+	int i;
+
+	gettimeofday(&tv, NULL);
+	srand(tv.tv_usec);
+
+	levels = (random() % (MAX_LEVELS - 1)) + 2;
+	rules[0] = 1;
+	for (i = 1; i < levels; i++)
+		rules[i] = (random() % 4) + 1;
+
+	*depth = levels;
+
+#if DEBUG_RULESET
+	for (i = 0; i < depth; i++)
+		printf("%u : %u\n", i, depth);
+#endif
+}
+
+static void count_jumps(int *count, int *rules, int depth)
+{
+	int tmp[MAX_LEVELS] = {};
+	int i = 0;
+
+	while (1) {
+		if (tmp[i]++ < rules[i]) {
+			(*count)++;
+			if (i < depth - 1)
+				i++;
+		} else {
+			tmp[i] = 0;
+			if (--i <= 0)
+				break;
+		}
+	}
+}
+
+static int print_ruleset(int *rules, int depth, int jump_count, char *filename)
+{
+	int fd, i, j;
+	FILE *fp;
+
+	fd = mkstemp(filename);
+	if (fd < 0) {
+		fprintf(stderr, "failed to create temporary ruleset file: %s\n", strerror(errno));
+		return -1;
+	}
+
+	fp = fdopen(fd, "w+");
+	if (!fp) {
+		close(fd);
+		fprintf(stderr, "failed to create temporary ruleset file\n");
+		return -1;
+	}
+
+	fprintf(fp, "# jump_count %d\n", jump_count);
+	fprintf(fp, "table ip x {\n");
+	fprintf(fp, "\tchain y%u {\n", depth);
+	fprintf(fp, "\t}\n");
+
+	for (i = depth - 1; i >= 1; i--) {
+		fprintf(fp, "\tchain y%u {\n", i);
+		for (j = 0; j < rules[i]; j++)
+			fprintf(fp, "\t\tjump y%d\n", i+1);
+
+		fprintf(fp, "\t}\n");
+	}
+	fprintf(fp, "\tchain y0 {\n", i);
+	fprintf(fp, "\t\ttype filter hook input priority 0;\n");
+	fprintf(fp, "\t\tjump y1\n");
+	fprintf(fp, "\t}\n");
+	fprintf(fp, "}\n");
+
+	return 0;
+}
+
+enum {
+	RANDOM = 0,
+	FAIL,
+	OK,
+};
+
+int main(int argc, const char *argv[])
+{
+	unsigned int type, nf_tables_jumps_max_netns;
+	int rules[10], depth, i, jump_count = 0;
+	char filename[] = "/tmp/rulesetXXXXXX";
+
+	if (argc == 3) {
+		if (!strcmp(argv[1], "ok"))
+			type = OK;
+		else if (!strcmp(argv[1], "fail"))
+			type = FAIL;
+
+		nf_tables_jumps_max_netns = atoi(argv[2]);
+	} else {
+		type = RANDOM;
+	}
+
+	switch (type) {
+	case RANDOM:
+		memset(rules, 0, sizeof(rules));
+		create_ruleset(rules, &depth);
+		count_jumps(&jump_count, rules, depth);
+		break;
+	case OK:
+		while (1) {
+			memset(rules, 0, sizeof(rules));
+			create_ruleset(rules, &depth);
+			count_jumps(&jump_count, rules, depth);
+			if (jump_count <= nf_tables_jumps_max_netns)
+				break;
+
+			jump_count = 0;
+		}
+		break;
+	case FAIL:
+		while (1) {
+			memset(rules, 0, sizeof(rules));
+			create_ruleset(rules, &depth);
+			count_jumps(&jump_count, rules, depth);
+			if (jump_count > nf_tables_jumps_max_netns)
+				break;
+
+			jump_count = 0;
+		}
+		break;
+	}
+	print_ruleset(rules, depth, jump_count, filename);
+	printf("%s\n", filename);
+}
diff --git a/tools/testing/selftests/net/netfilter/nft_ruleset_many_jumps.sh b/tools/testing/selftests/net/netfilter/nft_ruleset_many_jumps.sh
new file mode 100755
index 000000000000..c25bf0dbe054
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/nft_ruleset_many_jumps.sh
@@ -0,0 +1,118 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+SYSCTL_MAX_JUMPS=32
+DEFAULT_SYSCTL=65536
+
+rnd=$(mktemp -u XXXXXXXX)
+ns="nft-$rnd"
+
+cleanup() {
+        ip netns del $ns 2>/dev/null || true
+        rm -f $ruleset
+}
+
+trap cleanup EXIT
+
+set_max_jumps()
+{
+        local max_jumps=$1
+
+        sysctl -w net.netfilter.nf_tables_jumps_max_netns=$max_jumps 2>&1 >/dev/null
+        new_value=$(sysctl -n net.netfilter.nf_tables_jumps_max_netns)
+}
+
+get_max_jumps()
+{
+        local init_net_value=$(sysctl -n net.netfilter.nf_tables_jumps_max_netns)
+        echo "$init_net_value"
+}
+
+load_ruleset()
+{
+	local ruleset=$1
+
+	jumps=$(head -1 $ruleset | cut -f3 -d' ')
+
+	ip netns exec $ns nft -f $ruleset &> /dev/null
+	if [ "$?" -eq 0 ];then
+		if [ $jumps -gt $SYSCTL_MAX_JUMPS ];then
+			echo "FAIL: $jumps > $SYSCTL_MAX_JUMPS but ruleset loads"
+			cat $ruleset > /tmp/ruleset.nft
+			exit 1
+		fi
+		echo "OK: good ruleset with $jumps jump loads as expected"
+	else
+		if [ $jumps -lt $SYSCTL_MAX_JUMPS ];then
+			echo "FAIL: $jumps < $SYSCTL_MAX_JUMPS but ruleset does not load"
+			cat $ruleset > /tmp/ruleset.nft
+			exit 1
+		fi
+		echo "OK: bad ruleset with $jumps jumps fails as expected"
+	fi
+}
+
+load_ruleset_basic()
+{
+	ruleset=$(mktemp nft-tempXXXXXXXX.nft)
+	echo "table ip x {" > $ruleset
+	echo "	chain y0 {" >> $ruleset
+	echo "		type filter hook input priority 0;" >> $ruleset
+	echo "	}" >> $ruleset
+	echo "}" >> $ruleset
+
+	ip netns exec $ns nft -f $ruleset &> /dev/null
+	if [ "$?" -ne 0 ];then
+		echo "FAIL: cannot load basic ruleset"
+		exit 1
+	fi
+}
+
+flush_ruleset()
+{
+	local ruleset=$1
+
+	ip netns exec $ns nft flush ruleset
+	if [ "$?" -ne 0 ];then
+		echo "FAIL: cannot flush ruleset"
+		cat $ruleset > /tmp/ruleset.nft
+		exit 1
+	fi
+	rm -f $ruleset
+}
+
+pre_max_jumps=$(get_max_jumps)
+set_max_jumps $SYSCTL_MAX_JUMPS
+
+ip netns add $ns
+
+for ((i=0;i<10;i++))
+do
+	echo "=== iteration $i ==="
+	filename=$(./gen_ruleset_many_jumps)
+	load_ruleset $filename
+	flush_ruleset $filename
+done
+
+echo "Testing abort path with initial table w/o jumps"
+
+for ((i=0;i<10;i++))
+do
+	echo "=== iteration $i ==="
+	load_ruleset_basic
+	filename=$(./gen_ruleset_many_jumps fail $SYSCTL_MAX_JUMPS)
+	load_ruleset $filename
+	filename=$(./gen_ruleset_many_jumps ok $SYSCTL_MAX_JUMPS)
+	load_ruleset $filename
+	flush_ruleset $filename
+done
+
+set_max_jumps $pre_max_jumps
+post_max_jumps=$(get_max_jumps)
+
+if [ "$pre_max_jumps" -ne "$post_max_jumps" ];then
+	echo "Fail: Does not init default value: $init_net_value"
+	exit 1
+fi
+
+exit 0
-- 
2.30.2

