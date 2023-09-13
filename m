Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 796DDEDEC52
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Sep 2023 13:51:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbjIMNvw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Sep 2023 09:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236401AbjIMNvu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Sep 2023 09:51:50 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B8519BF;
        Wed, 13 Sep 2023 06:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rV0PuqmaPkXKamlXO0oFudnZJlZg/wceFTs+DZASskc=; b=E3iZj4wDq2nUxzCoSt5j+jsfSM
        HiNfjR5Lowrgnz9z23GtB9jYkjDx0X4L8PsQgw+CgS9D0Y1XzHHmI0kJEdln5Ni8Fn+8aP9N2LLs+
        Pmhz69SiJjrOxqW5qH4DPYlSXTnL2tJPa9Sz/JB3q09r4MkCo6xL85BPG93WnQNcsNR9dCNNa77n1
        2/6fpd7LY5Xsj+OlsET5JC5GqQPhPNz/iyXE0Vd4Sb/hEyroQXLnQevhtk3bbBuDgpChzJ/DemaWz
        B6NMvU8doG4WdUrflBHmp0Tow4proOb43AvAIosIEd2WK6TE//WK/34jT+iYI8EIem2N6AmpDuhPi
        9UrQ2VFw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qgQHM-0007Dx-Nu; Wed, 13 Sep 2023 15:51:40 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        audit@vger.kernel.org, paul@paul-moore.com, rgb@redhat.com
Subject: [nf PATCH v3 2/2] selftests: netfilter: Test nf_tables audit logging
Date:   Wed, 13 Sep 2023 15:51:37 +0200
Message-ID: <20230913135137.15154-3-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230913135137.15154-1-phil@nwl.cc>
References: <20230913135137.15154-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Compare NETFILTER_CFG type audit logs emitted from kernel upon ruleset
modifications against expected output.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Implement a custom log reader which turns audit logging on/off as
  needed, drop auditd dependency.
- Record required CONFIG_AUDIT in 'config' file.
- Add SPDX license headers.
- Open readonly fd to logfile for continuous reading, shell's redirect
  doesn't like file truncating to clear previous output.
- Use a single 'diff' call for status and error reporting.
- Use ruleset setup commands for audit log testing, too.
- Extend many rules reset test by two more commands.
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
index 4cb887b574138..4b2928e1c19d8 100644
--- a/tools/testing/selftests/netfilter/.gitignore
+++ b/tools/testing/selftests/netfilter/.gitignore
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 nf-queue
 connect_close
+audit_logread
diff --git a/tools/testing/selftests/netfilter/Makefile b/tools/testing/selftests/netfilter/Makefile
index 3686bfa6c58d7..321db8850da00 100644
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
index 0000000000000..a0a880fc2d9de
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
index 4faf2ce021d90..7c42b1b2c69b4 100644
--- a/tools/testing/selftests/netfilter/config
+++ b/tools/testing/selftests/netfilter/config
@@ -6,3 +6,4 @@ CONFIG_NFT_REDIR=m
 CONFIG_NFT_MASQ=m
 CONFIG_NFT_FLOW_OFFLOAD=m
 CONFIG_NF_CT_NETLINK=m
+CONFIG_AUDIT=y
diff --git a/tools/testing/selftests/netfilter/nft_audit.sh b/tools/testing/selftests/netfilter/nft_audit.sh
new file mode 100755
index 0000000000000..93e2bfc204da7
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
2.41.0

