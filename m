Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53971EE0212
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Sep 2023 21:58:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbjIMV61 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Sep 2023 17:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232883AbjIMV60 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Sep 2023 17:58:26 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8D09E1739;
        Wed, 13 Sep 2023 14:58:22 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 9/9] selftests: netfilter: Test nf_tables audit logging
Date:   Wed, 13 Sep 2023 23:58:00 +0200
Message-Id: <20230913215800.107269-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230913215800.107269-1-pablo@netfilter.org>
References: <20230913215800.107269-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

Compare NETFILTER_CFG type audit logs emitted from kernel upon ruleset
modifications against expected output.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/netfilter/.gitignore  |   1 +
 tools/testing/selftests/netfilter/Makefile    |   4 +-
 .../selftests/netfilter/audit_logread.c       | 165 ++++++++++++++++++
 tools/testing/selftests/netfilter/config      |   1 +
 .../testing/selftests/netfilter/nft_audit.sh  | 108 ++++++++++++
 5 files changed, 277 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/netfilter/audit_logread.c
 create mode 100755 tools/testing/selftests/netfilter/nft_audit.sh

diff --git a/tools/testing/selftests/netfilter/.gitignore b/tools/testing/selftests/netfilter/.gitignore
index 4cb887b57413..4b2928e1c19d 100644
--- a/tools/testing/selftests/netfilter/.gitignore
+++ b/tools/testing/selftests/netfilter/.gitignore
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 nf-queue
 connect_close
+audit_logread
diff --git a/tools/testing/selftests/netfilter/Makefile b/tools/testing/selftests/netfilter/Makefile
index 3686bfa6c58d..321db8850da0 100644
--- a/tools/testing/selftests/netfilter/Makefile
+++ b/tools/testing/selftests/netfilter/Makefile
@@ -6,13 +6,13 @@ TEST_PROGS := nft_trans_stress.sh nft_fib.sh nft_nat.sh bridge_brouter.sh \
 	nft_concat_range.sh nft_conntrack_helper.sh \
 	nft_queue.sh nft_meta.sh nf_nat_edemux.sh \
 	ipip-conntrack-mtu.sh conntrack_tcp_unreplied.sh \
-	conntrack_vrf.sh nft_synproxy.sh rpath.sh
+	conntrack_vrf.sh nft_synproxy.sh rpath.sh nft_audit.sh
 
 HOSTPKG_CONFIG := pkg-config
 
 CFLAGS += $(shell $(HOSTPKG_CONFIG) --cflags libmnl 2>/dev/null)
 LDLIBS += $(shell $(HOSTPKG_CONFIG) --libs libmnl 2>/dev/null || echo -lmnl)
 
-TEST_GEN_FILES =  nf-queue connect_close
+TEST_GEN_FILES =  nf-queue connect_close audit_logread
 
 include ../lib.mk
diff --git a/tools/testing/selftests/netfilter/audit_logread.c b/tools/testing/selftests/netfilter/audit_logread.c
new file mode 100644
index 000000000000..a0a880fc2d9d
--- /dev/null
+++ b/tools/testing/selftests/netfilter/audit_logread.c
@@ -0,0 +1,165 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <poll.h>
+#include <signal.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/socket.h>
+#include <unistd.h>
+#include <linux/audit.h>
+#include <linux/netlink.h>
+
+static int fd;
+
+#define MAX_AUDIT_MESSAGE_LENGTH	8970
+struct audit_message {
+	struct nlmsghdr nlh;
+	union {
+		struct audit_status s;
+		char data[MAX_AUDIT_MESSAGE_LENGTH];
+	} u;
+};
+
+int audit_recv(int fd, struct audit_message *rep)
+{
+	struct sockaddr_nl addr;
+	socklen_t addrlen = sizeof(addr);
+	int ret;
+
+	do {
+		ret = recvfrom(fd, rep, sizeof(*rep), 0,
+			       (struct sockaddr *)&addr, &addrlen);
+	} while (ret < 0 && errno == EINTR);
+
+	if (ret < 0 ||
+	    addrlen != sizeof(addr) ||
+	    addr.nl_pid != 0 ||
+	    rep->nlh.nlmsg_type == NLMSG_ERROR) /* short-cut for now */
+		return -1;
+
+	return ret;
+}
+
+int audit_send(int fd, uint16_t type, uint32_t key, uint32_t val)
+{
+	static int seq = 0;
+	struct audit_message msg = {
+		.nlh = {
+			.nlmsg_len   = NLMSG_SPACE(sizeof(msg.u.s)),
+			.nlmsg_type  = type,
+			.nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK,
+			.nlmsg_seq   = ++seq,
+		},
+		.u.s = {
+			.mask    = key,
+			.enabled = key == AUDIT_STATUS_ENABLED ? val : 0,
+			.pid     = key == AUDIT_STATUS_PID ? val : 0,
+		}
+	};
+	struct sockaddr_nl addr = {
+		.nl_family = AF_NETLINK,
+	};
+	int ret;
+
+	do {
+		ret = sendto(fd, &msg, msg.nlh.nlmsg_len, 0,
+			     (struct sockaddr *)&addr, sizeof(addr));
+	} while (ret < 0 && errno == EINTR);
+
+	if (ret != (int)msg.nlh.nlmsg_len)
+		return -1;
+	return 0;
+}
+
+int audit_set(int fd, uint32_t key, uint32_t val)
+{
+	struct audit_message rep = { 0 };
+	int ret;
+
+	ret = audit_send(fd, AUDIT_SET, key, val);
+	if (ret)
+		return ret;
+
+	ret = audit_recv(fd, &rep);
+	if (ret < 0)
+		return ret;
+	return 0;
+}
+
+int readlog(int fd)
+{
+	struct audit_message rep = { 0 };
+	int ret = audit_recv(fd, &rep);
+	const char *sep = "";
+	char *k, *v;
+
+	if (ret < 0)
+		return ret;
+
+	if (rep.nlh.nlmsg_type != AUDIT_NETFILTER_CFG)
+		return 0;
+
+	/* skip the initial "audit(...): " part */
+	strtok(rep.u.data, " ");
+
+	while ((k = strtok(NULL, "="))) {
+		v = strtok(NULL, " ");
+
+		/* these vary and/or are uninteresting, ignore */
+		if (!strcmp(k, "pid") ||
+		    !strcmp(k, "comm") ||
+		    !strcmp(k, "subj"))
+			continue;
+
+		/* strip the varying sequence number */
+		if (!strcmp(k, "table"))
+			*strchrnul(v, ':') = '\0';
+
+		printf("%s%s=%s", sep, k, v);
+		sep = " ";
+	}
+	if (*sep) {
+		printf("\n");
+		fflush(stdout);
+	}
+	return 0;
+}
+
+void cleanup(int sig)
+{
+	audit_set(fd, AUDIT_STATUS_ENABLED, 0);
+	close(fd);
+	if (sig)
+		exit(0);
+}
+
+int main(int argc, char **argv)
+{
+	struct sigaction act = {
+		.sa_handler = cleanup,
+	};
+
+	fd = socket(PF_NETLINK, SOCK_RAW, NETLINK_AUDIT);
+	if (fd < 0) {
+		perror("Can't open netlink socket");
+		return -1;
+	}
+
+	if (sigaction(SIGTERM, &act, NULL) < 0 ||
+	    sigaction(SIGINT, &act, NULL) < 0) {
+		perror("Can't set signal handler");
+		close(fd);
+		return -1;
+	}
+
+	audit_set(fd, AUDIT_STATUS_ENABLED, 1);
+	audit_set(fd, AUDIT_STATUS_PID, getpid());
+
+	while (1)
+		readlog(fd);
+}
diff --git a/tools/testing/selftests/netfilter/config b/tools/testing/selftests/netfilter/config
index 4faf2ce021d9..7c42b1b2c69b 100644
--- a/tools/testing/selftests/netfilter/config
+++ b/tools/testing/selftests/netfilter/config
@@ -6,3 +6,4 @@ CONFIG_NFT_REDIR=m
 CONFIG_NFT_MASQ=m
 CONFIG_NFT_FLOW_OFFLOAD=m
 CONFIG_NF_CT_NETLINK=m
+CONFIG_AUDIT=y
diff --git a/tools/testing/selftests/netfilter/nft_audit.sh b/tools/testing/selftests/netfilter/nft_audit.sh
new file mode 100755
index 000000000000..83c271b1c735
--- /dev/null
+++ b/tools/testing/selftests/netfilter/nft_audit.sh
@@ -0,0 +1,108 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Check that audit logs generated for nft commands are as expected.
+
+SKIP_RC=4
+RC=0
+
+nft --version >/dev/null 2>&1 || {
+	echo "SKIP: missing nft tool"
+	exit $SKIP_RC
+}
+
+logfile=$(mktemp)
+echo "logging into $logfile"
+./audit_logread >"$logfile" &
+logread_pid=$!
+trap 'kill $logread_pid; rm -f $logfile' EXIT
+exec 3<"$logfile"
+
+do_test() { # (cmd, log)
+	echo -n "testing for cmd: $1 ... "
+	cat <&3 >/dev/null
+	$1 >/dev/null || exit 1
+	sleep 0.1
+	res=$(diff -a -u <(echo "$2") - <&3)
+	[ $? -eq 0 ] && { echo "OK"; return; }
+	echo "FAIL"
+	echo "$res"
+	((RC++))
+}
+
+nft flush ruleset
+
+for table in t1 t2; do
+	do_test "nft add table $table" \
+	"table=$table family=2 entries=1 op=nft_register_table"
+
+	do_test "nft add chain $table c1" \
+	"table=$table family=2 entries=1 op=nft_register_chain"
+
+	do_test "nft add chain $table c2; add chain $table c3" \
+	"table=$table family=2 entries=2 op=nft_register_chain"
+
+	cmd="add rule $table c1 counter"
+
+	do_test "nft $cmd" \
+	"table=$table family=2 entries=1 op=nft_register_rule"
+
+	do_test "nft $cmd; $cmd" \
+	"table=$table family=2 entries=2 op=nft_register_rule"
+
+	cmd=""
+	sep=""
+	for chain in c2 c3; do
+		for i in {1..3}; do
+			cmd+="$sep add rule $table $chain counter"
+			sep=";"
+		done
+	done
+	do_test "nft $cmd" \
+	"table=$table family=2 entries=6 op=nft_register_rule"
+done
+
+do_test 'nft reset rules t1 c2' \
+'table=t1 family=2 entries=3 op=nft_reset_rule'
+
+do_test 'nft reset rules table t1' \
+'table=t1 family=2 entries=3 op=nft_reset_rule
+table=t1 family=2 entries=3 op=nft_reset_rule
+table=t1 family=2 entries=3 op=nft_reset_rule'
+
+do_test 'nft reset rules' \
+'table=t1 family=2 entries=3 op=nft_reset_rule
+table=t1 family=2 entries=3 op=nft_reset_rule
+table=t1 family=2 entries=3 op=nft_reset_rule
+table=t2 family=2 entries=3 op=nft_reset_rule
+table=t2 family=2 entries=3 op=nft_reset_rule
+table=t2 family=2 entries=3 op=nft_reset_rule'
+
+for ((i = 0; i < 500; i++)); do
+	echo "add rule t2 c3 counter accept comment \"rule $i\""
+done | do_test 'nft -f -' \
+'table=t2 family=2 entries=500 op=nft_register_rule'
+
+do_test 'nft reset rules t2 c3' \
+'table=t2 family=2 entries=189 op=nft_reset_rule
+table=t2 family=2 entries=188 op=nft_reset_rule
+table=t2 family=2 entries=126 op=nft_reset_rule'
+
+do_test 'nft reset rules t2' \
+'table=t2 family=2 entries=3 op=nft_reset_rule
+table=t2 family=2 entries=3 op=nft_reset_rule
+table=t2 family=2 entries=186 op=nft_reset_rule
+table=t2 family=2 entries=188 op=nft_reset_rule
+table=t2 family=2 entries=129 op=nft_reset_rule'
+
+do_test 'nft reset rules' \
+'table=t1 family=2 entries=3 op=nft_reset_rule
+table=t1 family=2 entries=3 op=nft_reset_rule
+table=t1 family=2 entries=3 op=nft_reset_rule
+table=t2 family=2 entries=3 op=nft_reset_rule
+table=t2 family=2 entries=3 op=nft_reset_rule
+table=t2 family=2 entries=180 op=nft_reset_rule
+table=t2 family=2 entries=188 op=nft_reset_rule
+table=t2 family=2 entries=135 op=nft_reset_rule'
+
+exit $RC
-- 
2.30.2

