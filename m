Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27B46C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Feb 2022 11:01:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238994AbiBYLCF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Feb 2022 06:02:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234247AbiBYLCF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Feb 2022 06:02:05 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89A922F977
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Feb 2022 03:01:31 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nNYLp-00025b-L7; Fri, 25 Feb 2022 12:01:29 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf] selftests: netfilter: add nfqueue TCP_NEW_SYN_RECV socket race test
Date:   Fri, 25 Feb 2022 12:01:23 +0100
Message-Id: <20220225110123.4615-1-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

causes:
BUG: KASAN: slab-out-of-bounds in sk_free+0x25/0x80
Write of size 4 at addr ffff888106df0284 by task nf-queue/1459
 sk_free+0x25/0x80
 nf_queue_entry_release_refs+0x143/0x1a0
 nf_reinject+0x233/0x770

... without 'netfilter: nf_queue: don't assume sk is full socket'.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: add connect_close to .gitignore, no other changes.

 tools/testing/selftests/netfilter/.gitignore  |   1 +
 tools/testing/selftests/netfilter/Makefile    |   2 +-
 .../selftests/netfilter/connect_close.c       | 136 ++++++++++++++++++
 .../testing/selftests/netfilter/nft_queue.sh  |  19 +++
 4 files changed, 157 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/netfilter/connect_close.c

diff --git a/tools/testing/selftests/netfilter/.gitignore b/tools/testing/selftests/netfilter/.gitignore
index 8448f74adfec..4cb887b57413 100644
--- a/tools/testing/selftests/netfilter/.gitignore
+++ b/tools/testing/selftests/netfilter/.gitignore
@@ -1,2 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
 nf-queue
+connect_close
diff --git a/tools/testing/selftests/netfilter/Makefile b/tools/testing/selftests/netfilter/Makefile
index e4f845dd942b..7e81c9a7fff9 100644
--- a/tools/testing/selftests/netfilter/Makefile
+++ b/tools/testing/selftests/netfilter/Makefile
@@ -9,6 +9,6 @@ TEST_PROGS := nft_trans_stress.sh nft_fib.sh nft_nat.sh bridge_brouter.sh \
 	conntrack_vrf.sh nft_synproxy.sh
 
 LDLIBS = -lmnl
-TEST_GEN_FILES =  nf-queue
+TEST_GEN_FILES =  nf-queue connect_close
 
 include ../lib.mk
diff --git a/tools/testing/selftests/netfilter/connect_close.c b/tools/testing/selftests/netfilter/connect_close.c
new file mode 100644
index 000000000000..1c3b0add54c4
--- /dev/null
+++ b/tools/testing/selftests/netfilter/connect_close.c
@@ -0,0 +1,136 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <fcntl.h>
+#include <string.h>
+#include <unistd.h>
+#include <signal.h>
+
+#include <arpa/inet.h>
+#include <sys/socket.h>
+
+#define PORT 12345
+#define RUNTIME 10
+
+static struct {
+	unsigned int timeout;
+	unsigned int port;
+} opts = {
+	.timeout = RUNTIME,
+	.port = PORT,
+};
+
+static void handler(int sig)
+{
+	_exit(sig == SIGALRM ? 0 : 1);
+}
+
+static void set_timeout(void)
+{
+	struct sigaction action = {
+		.sa_handler = handler,
+	};
+
+	sigaction(SIGALRM, &action, NULL);
+
+	alarm(opts.timeout);
+}
+
+static void do_connect(const struct sockaddr_in *dst)
+{
+	int s = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
+
+	if (s >= 0)
+		fcntl(s, F_SETFL, O_NONBLOCK);
+
+	connect(s, (struct sockaddr *)dst, sizeof(*dst));
+	close(s);
+}
+
+static void do_accept(const struct sockaddr_in *src)
+{
+	int c, one = 1, s = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
+
+	if (s < 0)
+		return;
+
+	setsockopt(s, SOL_SOCKET, SO_REUSEADDR, &one, sizeof(one));
+	setsockopt(s, SOL_SOCKET, SO_REUSEPORT, &one, sizeof(one));
+
+	bind(s, (struct sockaddr *)src, sizeof(*src));
+
+	listen(s, 16);
+
+	c = accept(s, NULL, NULL);
+	if (c >= 0)
+		close(c);
+
+	close(s);
+}
+
+static int accept_loop(void)
+{
+	struct sockaddr_in src = {
+		.sin_family = AF_INET,
+		.sin_port = htons(opts.port),
+	};
+
+	inet_pton(AF_INET, "127.0.0.1", &src.sin_addr);
+
+	set_timeout();
+
+	for (;;)
+		do_accept(&src);
+
+	return 1;
+}
+
+static int connect_loop(void)
+{
+	struct sockaddr_in dst = {
+		.sin_family = AF_INET,
+		.sin_port = htons(opts.port),
+	};
+
+	inet_pton(AF_INET, "127.0.0.1", &dst.sin_addr);
+
+	set_timeout();
+
+	for (;;)
+		do_connect(&dst);
+
+	return 1;
+}
+
+static void parse_opts(int argc, char **argv)
+{
+	int c;
+
+	while ((c = getopt(argc, argv, "t:p:")) != -1) {
+		switch (c) {
+		case 't':
+			opts.timeout = atoi(optarg);
+			break;
+		case 'p':
+			opts.port = atoi(optarg);
+			break;
+		}
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	pid_t p;
+
+	parse_opts(argc, argv);
+
+	p = fork();
+	if (p < 0)
+		return 111;
+
+	if (p > 0)
+		return accept_loop();
+
+	return connect_loop();
+}
diff --git a/tools/testing/selftests/netfilter/nft_queue.sh b/tools/testing/selftests/netfilter/nft_queue.sh
index 7d27f1f3bc01..e12729753351 100755
--- a/tools/testing/selftests/netfilter/nft_queue.sh
+++ b/tools/testing/selftests/netfilter/nft_queue.sh
@@ -113,6 +113,7 @@ table inet $name {
 	chain output {
 		type filter hook output priority $prio; policy accept;
 		tcp dport 12345 queue num 3
+		tcp sport 23456 queue num 3
 		jump nfq
 	}
 	chain post {
@@ -296,6 +297,23 @@ test_tcp_localhost()
 	wait 2>/dev/null
 }
 
+test_tcp_localhost_connectclose()
+{
+	tmpfile=$(mktemp) || exit 1
+
+	ip netns exec ${nsrouter} ./connect_close -p 23456 -t $timeout &
+
+	ip netns exec ${nsrouter} ./nf-queue -q 3 -t $timeout &
+	local nfqpid=$!
+
+	sleep 1
+	rm -f "$tmpfile"
+
+	wait $rpid
+	[ $? -eq 0 ] && echo "PASS: tcp via loopback with connect/close"
+	wait 2>/dev/null
+}
+
 test_tcp_localhost_requeue()
 {
 ip netns exec ${nsrouter} nft -f /dev/stdin <<EOF
@@ -424,6 +442,7 @@ test_queue 20
 
 test_tcp_forward
 test_tcp_localhost
+test_tcp_localhost_connectclose
 test_tcp_localhost_requeue
 test_icmp_vrf
 
-- 
2.34.1

