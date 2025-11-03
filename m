Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE94191F84
	for <netfilter-devel@vger.kernel.org>; Mon,  3 Nov 2025 21:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762204684; cv=none; b=Sk0/yn3jj3YWMvoRn2gTlbfZGD6u+yqS+0fu7l/W7vy/3f5ljo6jOArgaMq1BboFLz6QajqYJxaMgWGgH3NTYgMMa5TASwcN3Fjxi5AXLAaDOBJzrIC1OPu6ybmaMIFGAzQno72zsHoi9FYDRlwVQK9ln1ByZKelZGQ5zEcNKZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762204684; c=relaxed/simple;
	bh=TjJex6anbMa4ETNbIIA3nDQopLuhJvWdtFZa4aZszQ0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Y7zhklujJnY4O6oQle3lhPo3+aAYEZ4/ma4+qBusl8oXr/jvB5ztIda2ndzSmmnH5aVMbXjGPobeoo5kC0KbEcyIWnWQ+lOwHY4dpiIwogJBmiEA5a053DiURKCKjHnJiOoo5evqOt6VhGWOulDJ+zCZjAjkyvwxbo8Os7WS4Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=n3GKLv5s; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="n3GKLv5s"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 97EE360589;
	Mon,  3 Nov 2025 22:17:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1762204673;
	bh=/VdGYVDzopl0x4lBgui+R/caQWfcRkMKwk5KYmgjDdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n3GKLv5stnp5OXFMLOu3BogKHThuEZwiHPrLmMugDq+nPYdxCjokF49u4ZotHXvpq
	 IOmYaFO0hy+rfTrRY0YC+ia8+uu4Mo8C6NcIHr2dUopEpKjAqyqVnlxhDOkoyuyFhS
	 y8O5Fa8MOKSgcvQlTsAGXP0OVMU4k267xG2fXEYN2xPBqx99hw3z022xk9xBku7bJz
	 GP9RLNGvG7hMngFwgoZnPMBBKEnMC+gS79cajtQKGSjvu4GZ99DzM4tqzIfP5uGN/d
	 ROuuFAnj5Hyn1FxkfnFozeW0KedyI1VfpIjdqT7hWd6g+QV1/fdxl4kchpEtOj0Amv
	 nvGTz73GtOvjw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fmancera@suse.de,
	fw@strlen.de,
	brady.1345@gmail.com
Subject: [PATCH nf-next,v1 2/2] selftests: netfilter: add test for nf_tables_jumps_max_netns sysctl
Date: Mon,  3 Nov 2025 22:17:44 +0100
Message-Id: <20251103211744.6613-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20251103211744.6613-1-pablo@netfilter.org>
References: <20251103211744.6613-1-pablo@netfilter.org>
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
v1: cosmetic changes.

 .../testing/selftests/net/netfilter/Makefile  |   2 +
 .../net/netfilter/gen_ruleset_many_jumps.c    | 146 ++++++++++++++++++
 .../net/netfilter/nft_ruleset_many_jumps.sh   | 118 ++++++++++++++
 3 files changed, 266 insertions(+)
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
index 000000000000..0f5944b34e20
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/gen_ruleset_many_jumps.c
@@ -0,0 +1,146 @@
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
+#define MAX_JUMPS_PER_LEVEL 4
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
+		rules[i] = (random() % MAX_JUMPS_PER_LEVEL) + 1;
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

