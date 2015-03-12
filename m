From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH lnf-ct 2/2] qa: add test for mark event filter
Date: Fri, 13 Mar 2015 07:24:19 +0900
Message-ID: <20150312222418.GC20782@gmail.com>
References: <20150312221826.GA20782@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:45763 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbbCLWY0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Mar 2015 18:24:26 -0400
Received: by padbj1 with SMTP id bj1so23946048pad.12
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2015 15:24:26 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150312221826.GA20782@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

testing mark filter in root by

    # ./qa/ct_mark_filter.sh

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 qa/Makefile.am       |   6 ++-
 qa/ct_mark_filter.c  | 149 +++++++++++++++++++++++++++++++++++++++++++++++++++
 qa/ct_mark_filter.sh |  36 +++++++++++++
 qa/nssocket_env.sh   |   2 +-
 4 files changed, 191 insertions(+), 2 deletions(-)
 create mode 100644 qa/ct_mark_filter.c
 create mode 100755 qa/ct_mark_filter.sh

diff --git a/qa/Makefile.am b/qa/Makefile.am
index b16ab01..3c8a1cb 100644
--- a/qa/Makefile.am
+++ b/qa/Makefile.am
@@ -1,7 +1,7 @@
 include $(top_srcdir)/Make_global.am
 
 check_PROGRAMS = test_api test_filter test_connlabel ct_stress \
-	ct_events_reliable ct_echo_event
+	ct_events_reliable ct_echo_event ct_mark_filter
 
 test_api_SOURCES = test_api.c
 test_api_LDADD = ../src/libnetfilter_conntrack.la
@@ -22,3 +22,7 @@ AM_CFLAGS += -D_GNU_SOURCE
 ct_echo_event_SOURCES = ct_echo_event.c nssocket.c
 ct_echo_event_DEPENDENCIES = ct_echo_event.sh
 ct_echo_event_LDADD = ../src/libnetfilter_conntrack.la -lmnl
+
+ct_mark_filter_SOURCES = ct_mark_filter.c nssocket.c
+ct_mark_filter_DEPENDENCIES = ct_mark_filter.sh
+ct_mark_filter_LDADD = ../src/libnetfilter_conntrack.la -lmnl
diff --git a/qa/ct_mark_filter.c b/qa/ct_mark_filter.c
new file mode 100644
index 0000000..276344a
--- /dev/null
+++ b/qa/ct_mark_filter.c
@@ -0,0 +1,149 @@
+#include <assert.h>
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <netinet/in.h>
+
+#include <libmnl/libmnl.h>
+#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+
+#include "nssocket.h"
+
+static void tcp_echo_before_fin(const struct mnl_socket *nl,
+			       const char *pre, const char *post)
+{
+	u_int8_t proto = IPPROTO_TCP;
+
+	sync_fifo(pre);
+	timeout.tv_sec = INIT_TIMEOUT;
+	handle_qacb(nl, true, cb_tcp_new, &proto);
+	handle_qacb(nl, true, cb_tcp_syn_recv, &proto);
+	handle_qacb(nl, true, cb_tcp_established, &proto);
+	handle_qacb(nl, false, NULL, NULL);
+	sync_fifo(post);
+}
+
+static void tcp_echo_after_fin(const struct mnl_socket *nl,
+			       const char *pre, const char *post)
+{
+	u_int8_t proto = IPPROTO_TCP;
+
+	sync_fifo(pre);
+	timeout.tv_sec = INIT_TIMEOUT;
+	handle_qacb(nl, true, cb_tcp_fin_wait, &proto);
+	handle_qacb(nl, true, cb_tcp_close_wait, &proto);
+	handle_qacb(nl, true, cb_tcp_close, &proto);
+	handle_qacb(nl, true, cb_tcp_destroy, &proto);
+	handle_qacb(nl, false, NULL, NULL);
+	sync_fifo(post);
+}
+
+static void filter_mark_zero(const struct mnl_socket *nl,
+			     const char *pre, const char *post)
+{
+	struct nfct_filter *filter = nfct_filter_create();
+	struct nfct_filter_dump_mark mark = {val: 0, mask: 0};
+
+	nfct_filter_add_attr(filter, NFCT_FILTER_MARK, &mark);
+	assert(nfct_filter_attach(mnl_socket_get_fd(nl), filter) != -1);
+	nfct_filter_destroy(filter);
+	tcp_echo(nl, pre, post);
+	assert(nfct_filter_detach(mnl_socket_get_fd(nl)) != -1);
+}
+
+static void filter_mark_1_1(const struct mnl_socket *nl,
+			    const char *pre, const char *post)
+{
+	struct nfct_filter *filter = nfct_filter_create();
+	struct nfct_filter_dump_mark mark = {val: 1, mask: 1};
+
+	nfct_filter_add_attr(filter, NFCT_FILTER_MARK, &mark);
+	assert(nfct_filter_attach(mnl_socket_get_fd(nl), filter) != -1);
+	nfct_filter_destroy(filter);
+	tcp_echo_after_fin(nl, pre, post);
+	assert(nfct_filter_detach(mnl_socket_get_fd(nl)) != -1);
+}
+
+static void filter_mark_neg_1_1(const struct mnl_socket *nl,
+				const char *pre, const char *post)
+{
+	struct nfct_filter *filter = nfct_filter_create();
+	struct nfct_filter_dump_mark mark = {val: 1, mask: 1};
+
+	nfct_filter_add_attr(filter, NFCT_FILTER_MARK, &mark);
+	assert(nfct_filter_set_logic(filter, NFCT_FILTER_MARK,
+				     NFCT_FILTER_LOGIC_NEGATIVE) != -1);
+	assert(nfct_filter_attach(mnl_socket_get_fd(nl), filter) != -1);
+	nfct_filter_destroy(filter);
+	tcp_echo_before_fin(nl, pre, post);
+	assert(nfct_filter_detach(mnl_socket_get_fd(nl)) != -1);
+}
+
+static void filter_mark_neg_0_fffffffd(const struct mnl_socket *nl,
+				       const char *pre, const char *post)
+{
+	struct nfct_filter *filter = nfct_filter_create();
+	struct nfct_filter_dump_mark mark = {val: 0, mask: 0xfffffffd};
+
+	nfct_filter_add_attr(filter, NFCT_FILTER_MARK, &mark);
+	assert(nfct_filter_set_logic(filter, NFCT_FILTER_MARK,
+				     NFCT_FILTER_LOGIC_NEGATIVE) != -1);
+	assert(nfct_filter_attach(mnl_socket_get_fd(nl), filter) != -1);
+	nfct_filter_destroy(filter);
+	tcp_echo_after_fin(nl, pre, post);
+	assert(nfct_filter_detach(mnl_socket_get_fd(nl)) != -1);
+}
+
+static void filter_mark_max(const struct mnl_socket *nl,
+			    const char *pre, const char *post)
+{
+	struct nfct_filter *filter = nfct_filter_create();
+	struct nfct_filter_dump_mark mark;
+	int i;
+
+	for (i = 0; i < 126; i++) {
+		/* does not match to mark value 3 */
+		mark = (struct nfct_filter_dump_mark){val: 0, mask: 3};
+		nfct_filter_add_attr(filter, NFCT_FILTER_MARK, &mark);
+	}
+
+	/* __FILTER_MARK_MAX      127, should be added */
+	mark = (struct nfct_filter_dump_mark){val: 1, mask: 1};
+	nfct_filter_add_attr(filter, NFCT_FILTER_MARK, &mark);
+
+	/* over __FILTER_MARK_MAX, should be ignored */
+	mark = (struct nfct_filter_dump_mark){val: 0, mask: 0};
+	nfct_filter_add_attr(filter, NFCT_FILTER_MARK, &mark);
+
+	assert(nfct_filter_attach(mnl_socket_get_fd(nl), filter) != -1);
+	nfct_filter_destroy(filter);
+	tcp_echo_after_fin(nl, pre, post);
+	assert(nfct_filter_detach(mnl_socket_get_fd(nl)) != -1);
+}
+
+int main(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	char *pre, *post;
+
+	if (argc != 4) {
+		fprintf(stderr, "usage: %s <netns> <pre_fifo> <post_fifo>\n", argv[0]);
+		exit(EXIT_FAILURE);
+	}
+	pre = argv[2];
+	post = argv[3];
+
+	nl = mnl_event_nssocket(argv[1]);
+	if (nl == NULL) {
+		perror("init_mnl_socket");
+		exit(EXIT_FAILURE);
+	}
+
+	filter_mark_zero(nl, pre, post);
+	filter_mark_1_1(nl, pre, post);
+	filter_mark_neg_1_1(nl, pre, post);
+	filter_mark_neg_0_fffffffd(nl, pre, post);
+	filter_mark_max(nl, pre, post);
+
+	return fini_nssocket();
+}
diff --git a/qa/ct_mark_filter.sh b/qa/ct_mark_filter.sh
new file mode 100755
index 0000000..a2c7fed
--- /dev/null
+++ b/qa/ct_mark_filter.sh
@@ -0,0 +1,36 @@
+#!/bin/sh
+
+. `dirname $0`/nssocket_env.sh
+
+echo "---- TCP echo with ctmark 0/0 [filter_mark_zero]"
+pre_sync
+echo | nc -q 0 $VETH_CHILD_ADDR $DSTPORT
+post_sync
+
+echo "---- iptables CONNMARK settings - ctmark tcp 2/2, tcp fin 1/1"
+ip netns exec $NETNS sh <<EOF
+    iptables -t mangle -I PREROUTING -p tcp -m tcp -j CONNMARK --set-mark 2/2
+    iptables -t mangle -I PREROUTING -p tcp -m tcp --tcp-flags FIN FIN -j CONNMARK --set-mark 1/1
+EOF
+
+echo "---- TCP echo with mark filter 1/1 [filter_mark_1_1]"
+pre_sync
+echo | nc -q 0 $VETH_CHILD_ADDR $DSTPORT
+post_sync
+
+echo "---- TCP echo with mark filter ! 1/1 [filter_mark_neg_1_1]"
+pre_sync
+echo | nc -q 0 $VETH_CHILD_ADDR $DSTPORT
+post_sync
+
+echo "---- TCP echo with mark filter !0/fffffffd [filter_mark_neg_0_fffffffd]"
+pre_sync
+echo | nc -q 0 $VETH_CHILD_ADDR $DSTPORT
+post_sync
+
+echo "---- max mark filter entry [filter_mark_max]"
+pre_sync
+echo | nc -q 0 $VETH_CHILD_ADDR $DSTPORT
+post_sync
+
+fin
diff --git a/qa/nssocket_env.sh b/qa/nssocket_env.sh
index 2bcd74d..1732eb1 100644
--- a/qa/nssocket_env.sh
+++ b/qa/nssocket_env.sh
@@ -11,7 +11,7 @@ DSTPORT="7"
 ICMP_TYPE="8"
 ICMP_CODE="0"
 NF_TIMEOUT=2
-INIT_TIMEOUT=4
+INIT_TIMEOUT=8
 
 dname=`dirname $0`
 bname=`basename $0`
-- 
2.1.4

