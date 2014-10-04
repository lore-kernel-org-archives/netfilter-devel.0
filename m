From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCHv2 lnfct] qa: build unshared nfct environment
Date: Sat, 4 Oct 2014 23:13:10 +0900
Message-ID: <20141004141310.GA10095@gmail.com>
References: <20140930090222.GA8470@gmail.com>
 <20140930101656.GE11709@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:40547 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbaJDONS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 4 Oct 2014 10:13:18 -0400
Received: by mail-pa0-f42.google.com with SMTP id bj1so2958871pad.1
        for <netfilter-devel@vger.kernel.org>; Sat, 04 Oct 2014 07:13:17 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140930101656.GE11709@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nssocket forks and change netns pre-establishd by ip(8), serves its
socket descriptor to parent via nssocket().  Since this socket is
isolated, it can be used to create regression tests for conntrack.

This also adds a conntrack event testcase as a first user.
A ct_echo_event.sh script is provided to build and run this test
automatically:

  # ./qa/ct_echo_event.sh
  make: Entering directory...
  ...debug output like:
      [NEW] tcp      6 2 SYN_SENT src=10.255.255.249 dst=10.255.255.250 sport...
   [UPDATE] tcp      6 2 SYN_RECV src=10.255.255.249 dst=10.255.255.250 sport...
  ...
  [DESTROY] icmp     1 src=10.255.255.249 dst=10.255.255.250 type=8 code=0...
  # echo $?
  0

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 .gitignore          |   1 +
 configure.ac        |   3 +
 qa/Makefile.am      |   8 +-
 qa/ct_echo_event.c  | 383 +++++++++++++++++++++++++++++++++++++++++++++++
 qa/ct_echo_event.sh |  81 ++++++++++
 qa/inetd.conf       |   7 +
 qa/nssocket.c       | 423 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 qa/nssocket.h       |  66 ++++++++
 8 files changed, 971 insertions(+), 1 deletion(-)
 create mode 100644 qa/ct_echo_event.c
 create mode 100755 qa/ct_echo_event.sh
 create mode 100644 qa/inetd.conf
 create mode 100644 qa/nssocket.c
 create mode 100644 qa/nssocket.h

diff --git a/.gitignore b/.gitignore
index f4938e9..e90dec6 100644
--- a/.gitignore
+++ b/.gitignore
@@ -12,6 +12,7 @@ Makefile.in
 /config.*
 /configure
 /libtool
+/stamp-h1
 
 /doxygen.cfg
 /*.pc
diff --git a/configure.ac b/configure.ac
index 1edfd66..5050ef6 100644
--- a/configure.ac
+++ b/configure.ac
@@ -3,6 +3,7 @@ dnl Process this file with autoconf to create configure.
 AC_INIT([libnetfilter_conntrack], [1.0.4])
 AC_CONFIG_AUX_DIR([build-aux])
 AC_CANONICAL_HOST
+AC_CONFIG_HEADER([config.h])
 AC_CONFIG_MACRO_DIR([m4])
 
 AM_INIT_AUTOMAKE([-Wall foreign subdir-objects
@@ -30,6 +31,8 @@ PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
 AC_CHECK_HEADERS(arpa/inet.h)
 dnl Check for inet_ntop
 AC_CHECK_FUNCS(inet_ntop)
+dnl Check for setns used in qa
+AC_CHECK_FUNCS(setns)
 dnl Again, some systems have it, but not IPv6
 if test "$ac_cv_func_inet_ntop" = "yes" ; then
 AC_MSG_CHECKING(if inet_ntop supports IPv6)
diff --git a/qa/Makefile.am b/qa/Makefile.am
index abe063f..b16ab01 100644
--- a/qa/Makefile.am
+++ b/qa/Makefile.am
@@ -1,6 +1,7 @@
 include $(top_srcdir)/Make_global.am
 
-check_PROGRAMS = test_api test_filter test_connlabel ct_stress ct_events_reliable
+check_PROGRAMS = test_api test_filter test_connlabel ct_stress \
+	ct_events_reliable ct_echo_event
 
 test_api_SOURCES = test_api.c
 test_api_LDADD = ../src/libnetfilter_conntrack.la
@@ -16,3 +17,8 @@ ct_stress_LDADD = ../src/libnetfilter_conntrack.la
 
 ct_events_reliable_SOURCES = ct_events_reliable.c
 ct_events_reliable_LDADD = ../src/libnetfilter_conntrack.la
+
+AM_CFLAGS += -D_GNU_SOURCE
+ct_echo_event_SOURCES = ct_echo_event.c nssocket.c
+ct_echo_event_DEPENDENCIES = ct_echo_event.sh
+ct_echo_event_LDADD = ../src/libnetfilter_conntrack.la -lmnl
diff --git a/qa/ct_echo_event.c b/qa/ct_echo_event.c
new file mode 100644
index 0000000..227a61a
--- /dev/null
+++ b/qa/ct_echo_event.c
@@ -0,0 +1,383 @@
+#include <assert.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <arpa/inet.h>
+#include <signal.h>
+#include <string.h>
+#include <sys/select.h>
+#include <sys/socket.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <unistd.h>
+#include <netinet/in.h>
+
+#include <libmnl/libmnl.h>
+#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+#include <libnetfilter_conntrack/libnetfilter_conntrack_tcp.h>
+
+#include "nssocket.h"
+
+/* tv_sec will update every cb */
+struct timeval timeout;
+
+static void sigabrt_handler(int signum)
+{
+	fini_nssocket();
+}
+
+static void assert_proto(const struct nf_conntrack *ct,
+			 u_int8_t l3proto, u_int8_t l4proto)
+{
+	assert(nfct_get_attr_u8(ct, ATTR_ORIG_L3PROTO) == l3proto);
+	assert(nfct_get_attr_u8(ct, ATTR_REPL_L3PROTO) == l3proto);
+	assert(nfct_get_attr_u8(ct, ATTR_ORIG_L4PROTO) == l4proto);
+	assert(nfct_get_attr_u8(ct, ATTR_REPL_L4PROTO) == l4proto);
+}
+
+static void assert_inaddr(const struct nf_conntrack *ct,
+			  const char *src, const char *dst)
+{
+	struct in_addr addr;
+	assert(inet_aton((src), &addr) != 0);
+	assert(nfct_get_attr_u32((ct), ATTR_ORIG_IPV4_SRC) == addr.s_addr);
+	assert(nfct_get_attr_u32((ct), ATTR_REPL_IPV4_DST) == addr.s_addr);
+	assert(inet_aton((dst), &addr) != 0);
+	assert(nfct_get_attr_u32((ct), ATTR_ORIG_IPV4_DST) == addr.s_addr);
+	assert(nfct_get_attr_u32((ct), ATTR_REPL_IPV4_SRC) == addr.s_addr);
+}
+
+static void assert_port(const struct nf_conntrack *ct,
+			u_int16_t src, u_int16_t dst)
+{
+	if ((src)) {
+		assert(nfct_get_attr_u16((ct), ATTR_ORIG_PORT_SRC) == htons((src)));
+		assert(nfct_get_attr_u16((ct), ATTR_REPL_PORT_DST) == htons((src)));
+	}
+	if ((dst)) {
+		assert(nfct_get_attr_u16((ct), ATTR_ORIG_PORT_DST) == htons((dst)));
+		assert(nfct_get_attr_u16((ct), ATTR_REPL_PORT_SRC) == htons((dst)));
+	}
+}
+
+static void assert_typecode(const struct nf_conntrack *ct,
+			    u_int8_t type, u_int8_t code)
+{
+	assert(nfct_get_attr_u8((ct), ATTR_ICMP_TYPE) == type);
+	assert(nfct_get_attr_u8((ct), ATTR_ICMP_CODE) == code);
+}
+
+static struct nf_conntrack *author_new(const struct nlmsghdr *nlh,
+				       void *data)
+{
+	struct nf_conntrack *ct;
+
+	assert((nlh->nlmsg_type & 0xFF) == IPCTNL_MSG_CT_NEW);
+	assert(nlh->nlmsg_flags == (NLM_F_CREATE | NLM_F_EXCL));
+	ct = nfct_new();
+	assert(ct != NULL);
+	assert(nfct_nlmsg_parse((nlh), ct) == 0);
+	assert_proto(ct, AF_INET, *(u_int8_t *) data);
+	assert_inaddr(ct, VETH_PARENT_ADDR, VETH_CHILD_ADDR);
+	assert((nfct_get_attr_u32(ct, ATTR_STATUS) & IPS_SEEN_REPLY) == 0);
+	timeout.tv_sec = nfct_get_attr_u32(ct, ATTR_TIMEOUT) + 1;
+
+	return ct;
+}
+
+static struct nf_conntrack *author_update(const struct nlmsghdr *nlh,
+					  void *data)
+{
+	struct nf_conntrack *ct;
+
+	assert((nlh->nlmsg_type & 0xFF) == IPCTNL_MSG_CT_NEW);
+	assert(nlh->nlmsg_flags == 0);
+	ct = nfct_new();
+	assert(ct != NULL);
+	assert(nfct_nlmsg_parse((nlh), ct) == 0);
+	assert_proto(ct, AF_INET, *(u_int8_t *) data);
+	assert_inaddr(ct, VETH_PARENT_ADDR, VETH_CHILD_ADDR);
+	assert((nfct_get_attr_u32(ct, ATTR_STATUS) & IPS_SEEN_REPLY));
+	timeout.tv_sec = nfct_get_attr_u32(ct, ATTR_TIMEOUT) + 1;
+
+	return ct;
+}
+
+static struct nf_conntrack *author_destroy(const struct nlmsghdr *nlh,
+					   void *data)
+{
+	struct nf_conntrack *ct;
+
+	assert((nlh->nlmsg_type & 0xFF) == IPCTNL_MSG_CT_DELETE);
+	assert(nlh->nlmsg_flags == 0);
+	ct = nfct_new();
+	assert(ct != NULL);
+	assert(nfct_nlmsg_parse((nlh), ct) == 0);
+	assert_proto(ct, AF_INET, *(u_int8_t *) data);
+	assert_inaddr(ct, VETH_PARENT_ADDR, VETH_CHILD_ADDR);
+	assert((nfct_get_attr_u32(ct, ATTR_STATUS) & IPS_SEEN_REPLY));
+
+	return ct;
+}
+
+static int cb_icmp_new(const struct nlmsghdr *nlh, void *data)
+{
+	struct nf_conntrack *ct = author_new(nlh, data);
+	assert_typecode(ct, ICMP_TYPE, ICMP_CODE);
+	nfct_destroy(ct);
+	return MNL_CB_OK;
+}
+
+static int cb_icmp_update(const struct nlmsghdr *nlh, void *data)
+{
+	struct nf_conntrack *ct = author_update(nlh, data);
+	assert_typecode(ct, ICMP_TYPE, ICMP_CODE);
+	nfct_destroy(ct);
+	return MNL_CB_OK;
+}
+
+static int cb_icmp_destroy(const struct nlmsghdr *nlh, void *data)
+{
+	struct nf_conntrack *ct = author_destroy(nlh, data);
+	assert_typecode(ct, ICMP_TYPE, ICMP_CODE);
+	nfct_destroy(ct);
+	return MNL_CB_OK;
+}
+
+static int cb_udp_new(const struct nlmsghdr *nlh, void *data)
+{
+	struct nf_conntrack *ct = author_new(nlh, data);
+	assert_port(ct, 0, DSTPORT);
+	nfct_destroy(ct);
+	return MNL_CB_OK;
+}
+
+static int cb_udp_update(const struct nlmsghdr *nlh, void *data)
+{
+	struct nf_conntrack *ct = author_update(nlh, data);
+	assert_port(ct, 0, DSTPORT);
+	nfct_destroy(ct);
+	return MNL_CB_OK;
+}
+
+static int cb_udp_destroy(const struct nlmsghdr *nlh, void *data)
+{
+	struct nf_conntrack *ct = author_destroy(nlh, data);
+	assert_port(ct, 0, DSTPORT);
+	nfct_destroy(ct);
+	return MNL_CB_OK;
+}
+
+static int cb_tcp_new(const struct nlmsghdr *nlh, void *data)
+{
+	struct nf_conntrack *ct = author_new(nlh, data);
+	assert_port(ct, 0, DSTPORT);
+	assert(nfct_get_attr_u8(ct, ATTR_TCP_STATE) == TCP_CONNTRACK_SYN_SENT);
+	nfct_destroy(ct);
+	return MNL_CB_OK;
+}
+
+static int cb_tcp_syn_recv(const struct nlmsghdr *nlh, void *data)
+{
+	struct nf_conntrack *ct = author_update(nlh, data);
+	assert_port(ct, 0, DSTPORT);
+	assert(nfct_get_attr_u8(ct, ATTR_TCP_STATE) == TCP_CONNTRACK_SYN_RECV);
+	nfct_destroy(ct);
+	return MNL_CB_OK;
+}
+
+static int cb_tcp_established(const struct nlmsghdr *nlh, void *data)
+{
+	struct nf_conntrack *ct = author_update(nlh, data);
+	assert_port(ct, 0, DSTPORT);
+	assert(nfct_get_attr_u8(ct, ATTR_TCP_STATE) == TCP_CONNTRACK_ESTABLISHED);
+	assert((nfct_get_attr_u32(ct, ATTR_STATUS) & IPS_ASSURED));
+	nfct_destroy(ct);
+	return MNL_CB_OK;
+}
+
+static int cb_tcp_fin_wait(const struct nlmsghdr *nlh, void *data)
+{
+	struct nf_conntrack *ct = author_update(nlh, data);
+	assert_port(ct, 0, DSTPORT);
+	assert(nfct_get_attr_u8(ct, ATTR_TCP_STATE) == TCP_CONNTRACK_FIN_WAIT);
+	assert((nfct_get_attr_u32(ct, ATTR_STATUS) & IPS_ASSURED));
+	nfct_destroy(ct);
+	return MNL_CB_OK;
+}
+
+static int cb_tcp_close_wait(const struct nlmsghdr *nlh, void *data)
+{
+	struct nf_conntrack *ct = author_update(nlh, data);
+	assert_port(ct, 0, DSTPORT);
+	assert(nfct_get_attr_u8(ct, ATTR_TCP_STATE) == TCP_CONNTRACK_CLOSE_WAIT);
+	assert((nfct_get_attr_u32(ct, ATTR_STATUS) & IPS_ASSURED));
+	nfct_destroy(ct);
+	return MNL_CB_OK;
+}
+
+static int cb_tcp_close(const struct nlmsghdr *nlh, void *data)
+{
+	struct nf_conntrack *ct = author_update(nlh, data);
+	assert_port(ct, 0, DSTPORT);
+	assert(nfct_get_attr_u8(ct, ATTR_TCP_STATE) == TCP_CONNTRACK_CLOSE);
+	assert((nfct_get_attr_u32(ct, ATTR_STATUS) & IPS_ASSURED));
+	nfct_destroy(ct);
+	return MNL_CB_OK;
+}
+
+static int cb_tcp_destroy(const struct nlmsghdr *nlh, void *data)
+{
+	struct nf_conntrack *ct = author_destroy(nlh, data);
+	assert_port(ct, 0, DSTPORT);
+	assert(nfct_attr_is_set(ct, ATTR_TCP_STATE) == 0);
+	assert((nfct_get_attr_u32(ct, ATTR_STATUS) & IPS_ASSURED));
+	nfct_destroy(ct);
+	return MNL_CB_OK;
+}
+
+int handle_qacb(struct mnl_socket *nl, bool should_receive,
+		  int(*cb)(const struct nlmsghdr *nlh, void *data), void *data)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	fd_set rfds;
+	int ret, fd = mnl_socket_get_fd(nl);
+	bool receive_nfnl;
+
+	FD_ZERO(&rfds);
+	FD_SET(fd, &rfds);
+	if (select(fd + 1, &rfds, NULL, NULL, &timeout) < 0)
+		child_exit("select", EXIT_FAILURE);
+	receive_nfnl = FD_ISSET(fd, &rfds);
+	if (should_receive) {
+		assert(receive_nfnl == true);
+	} else {
+		assert(receive_nfnl == false);
+		return MNL_CB_ERROR;
+	}
+
+	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	if (ret == -1)
+		child_exit("mnl_socket_recvfrom", EXIT_FAILURE);
+	mnl_cb_run(buf, ret, 0, 0, debug_nfct_cb, NULL);
+	if (cb != NULL) {
+		ret = mnl_cb_run(buf, ret, 0, 0, cb, data);
+		if (ret == -1)
+			child_exit("mnl_cb_run", EXIT_FAILURE);
+		return ret;
+	}
+
+	return MNL_CB_OK;
+}
+
+struct mnl_socket *mnl_event_nssocket(const char *nsname)
+{
+	struct mnl_socket *nl;
+	struct sigaction sa;
+
+	sigemptyset(&sa.sa_mask);
+	sa.sa_flags = 0;
+	sa.sa_handler = sigabrt_handler;
+	if (sigaction(SIGABRT, &sa, NULL) == -1)
+		return NULL;
+
+	if (init_nssocket(nsname) == -1)
+		return NULL;
+
+	nl = mnl_nssocket_open(NETLINK_NETFILTER);
+	if (nl == NULL)
+		return NULL;
+	if (mnl_socket_bind(nl, NF_NETLINK_CONNTRACK_NEW |
+			    NF_NETLINK_CONNTRACK_UPDATE |
+			    NF_NETLINK_CONNTRACK_DESTROY,
+			    MNL_SOCKET_AUTOPID) < 0) {
+		parent_fail("mnl_socket_bind");
+		mnl_socket_close(nl);
+		return NULL;
+	}
+
+	return nl;
+}
+
+void sync_fifo(const char *name)
+{
+	struct stat statbuf;
+	int fd = open(name, O_WRONLY);
+	if (fd == -1) {
+		parent_fail("open fifo");
+		exit(EXIT_FAILURE);
+	}
+	if (fstat(fd, &statbuf) == -1) {
+		parent_fail("fstat fifo");
+		exit(EXIT_FAILURE);
+	}
+	if (!S_ISFIFO(statbuf.st_mode)) {
+		parent_fail("S_ISFIFO");
+		exit(EXIT_FAILURE);
+	}
+	close(fd);
+}
+
+int main(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	char *pre, *post;
+	u_int8_t proto;
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
+	/*
+	 * TCP echo
+	 */
+	sync_fifo(pre);
+	timeout.tv_sec = INIT_TIMEOUT;
+	proto = IPPROTO_TCP;
+	handle_qacb(nl, true, cb_tcp_new, &proto);
+	handle_qacb(nl, true, cb_tcp_syn_recv, &proto);
+	handle_qacb(nl, true, cb_tcp_established, &proto);
+	handle_qacb(nl, true, cb_tcp_fin_wait, &proto);
+	handle_qacb(nl, true, cb_tcp_close_wait, &proto);
+	handle_qacb(nl, true, cb_tcp_close, &proto);
+	handle_qacb(nl, true, cb_tcp_destroy, &proto);
+	handle_qacb(nl, false, NULL, NULL);
+	sync_fifo(post);
+
+	/*
+	 * UDP echo
+	 */
+	sync_fifo(pre);
+	timeout.tv_sec = INIT_TIMEOUT;
+	proto = IPPROTO_UDP;
+	handle_qacb(nl, true, cb_udp_new, &proto);
+	handle_qacb(nl, true, cb_udp_update, &proto);
+	handle_qacb(nl, true, cb_udp_destroy, &proto);
+	handle_qacb(nl, false, NULL, NULL);
+	sync_fifo(post);
+
+	/*
+	 * ICMP echo
+	 */
+	sync_fifo(pre);
+	timeout.tv_sec = INIT_TIMEOUT;
+	proto = IPPROTO_ICMP;
+	handle_qacb(nl, true, cb_icmp_new, &proto);
+	handle_qacb(nl, true, cb_icmp_update, &proto);
+	handle_qacb(nl, true, cb_icmp_destroy, &proto);
+	handle_qacb(nl, false, NULL, NULL);
+	sync_fifo(post);
+
+	return fini_nssocket();
+}
diff --git a/qa/ct_echo_event.sh b/qa/ct_echo_event.sh
new file mode 100755
index 0000000..a0295fa
--- /dev/null
+++ b/qa/ct_echo_event.sh
@@ -0,0 +1,81 @@
+#!/bin/sh
+
+NETNS="lnfct_qa"
+VETH_NAME="veth_qa0"
+VETH_PEER="veth_qa1"
+DUMMY_DEV="dummy_qa0"
+VETH_PARENT_ADDR="10.255.255.249"
+VETH_CHILD_ADDR="10.255.255.250"
+VETH_MASK="30"
+DSTPORT="7"
+ICMP_TYPE="8"
+ICMP_CODE="0"
+PRE_FIFO="qa_pre_fifo"
+POST_FIFO="qa_post_fifo"
+NF_TIMEOUT=2
+INIT_TIMEOUT=4
+
+dname=`dirname $0`
+make -C $dname \
+    CFLAGS="-DVETH_PARENT_ADDR=\\\"$VETH_PARENT_ADDR\\\" \
+            -DVETH_CHILD_ADDR=\\\"$VETH_CHILD_ADDR\\\" \
+            -DDSTPORT=$DSTPORT -DICMP_TYPE=$ICMP_TYPE -DICMP_CODE=$ICMP_CODE \
+            -DINIT_TIMEOUT=$INIT_TIMEOUT" \
+    ct_echo_event || exit 1
+
+[ -z `which ip` ]    && echo "ip(8) required" >&2 && exit 1
+[ -z `which inetd` ] && echo "inetd required" >&2 && exit 1
+[ -z `which nc` ]    && echo "nc required"    >&2 && exit 1
+modprobe nf_conntrack_ipv4	|| exit 1
+modprobe nfnetlink_cttimeout	|| exit 1
+
+# parent / client
+ip netns add $NETNS
+trap "ip netns del $NETNS; exit 1" 1 2 15
+ip link ls $VETH_NAME  > /dev/null 2>&1 && ip link del $VETH_NAME
+ip link add $VETH_NAME type veth peer name $VETH_PEER
+ip link set $VETH_PEER netns $NETNS
+ip link set $VETH_NAME up
+ip addr add ${VETH_PARENT_ADDR}/${VETH_MASK} dev $VETH_NAME
+
+# child / server
+ip netns exec $NETNS sh <<EOF
+echo 1 > /proc/sys/net/ipv4/ip_forward
+for f in /proc/sys/net/netfilter/*timeout*; do echo $NF_TIMEOUT > "\$f"; done
+ip link set lo up
+ip link set $VETH_PEER up
+ip addr add ${VETH_CHILD_ADDR}/${VETH_MASK} dev $VETH_PEER
+ip link add ${DUMMY_DEV} up type dummy
+ip route add default dev ${DUMMY_DEV}
+EOF
+ip netns exec $NETNS /usr/sbin/inetd -d $dname/inetd.conf > /dev/null 2>&1 &
+inetd_pid=$!
+trap "rm -f $PRE_FIFO $POST_FIFO; kill $inetd_pid; ip netns del $NETNS; exit 1" 1 2 15
+
+rm -f $PRE_FIFO $POST_FIFO
+mkfifo $PRE_FIFO
+mkfifo $POST_FIFO
+${dname}/ct_echo_event $NETNS $PRE_FIFO $POST_FIFO || \
+    (rm -f $PRE_FIFO $POST_FIFO; kill -9 $inetd_pid; ip netns del $NETNS; kill -9 $$) &
+qa_pid=$!
+
+# TCP echo
+exec 8< $PRE_FIFO && exec 8>&-
+echo | nc -q 0 $VETH_CHILD_ADDR $DSTPORT
+exec 8< $POST_FIFO && exec 8>&-
+
+# UDP echo
+exec 8< $PRE_FIFO && exec 8>&-
+echo | nc -q 0 -u $VETH_CHILD_ADDR $DSTPORT
+exec 8< $POST_FIFO && exec 8>&-
+
+# ICMP echo
+exec 8< $PRE_FIFO && exec 8>&-
+ping -c 1 $VETH_CHILD_ADDR > /dev/null 2>&1
+exec 8< $POST_FIFO && exec 8>&-
+
+# cleanup
+wait $qa_pid
+rm -f $PRE_FIFO $POST_FIFO
+kill $inetd_pid > /dev/null 2>&1
+ip netns del $NETNS > /dev/null 2>&1
diff --git a/qa/inetd.conf b/qa/inetd.conf
new file mode 100644
index 0000000..0216b7d
--- /dev/null
+++ b/qa/inetd.conf
@@ -0,0 +1,7 @@
+#:INTERNAL: Internal services
+echo		stream	tcp	nowait	root	internal
+echo		dgram	udp	wait	root	internal
+#discard		stream	tcp	nowait	root	internal
+#discard		dgram	udp	wait	root	internal
+#daytime		stream	tcp	nowait	root	internal
+#time		stream	tcp	nowait	root	internal
diff --git a/qa/nssocket.c b/qa/nssocket.c
new file mode 100644
index 0000000..1c22e3f
--- /dev/null
+++ b/qa/nssocket.c
@@ -0,0 +1,423 @@
+#include <arpa/inet.h>
+#include <assert.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <sched.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mount.h>
+#include <sys/param.h>
+#include <sys/socket.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <time.h>
+#include <unistd.h>
+
+#include <libmnl/libmnl.h>
+#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+#include "config.h"
+#include "nssocket.h"
+
+int fdpair[2];
+#define PARENT_FD (fdpair[0])
+#define CHILD_FD (fdpair[1])
+
+pid_t child_pid;
+
+void add_child(pid_t pid)
+{
+	/* XXX: check excess MAX_CHILD */
+	children[nchild++] = pid;
+}
+
+static int get_unaligned_int(const void *s)
+{
+	int x;
+	memcpy(&x, s, sizeof(x));
+	return x;
+}
+
+static void put_unaligned_int(void *d, int x)
+{
+	memcpy(d, &x, sizeof(x));
+}
+
+/*
+ * message exchange via socketpair using send/recv msg()
+ *
+ * - use cdata:
+ *   cdata represents a file descriptor
+ *   cmd[0] means -errno
+ *
+ * - without cdata:
+ *   cmd[0] means:
+ *   > 0:  command
+ *   == 0: sync, echo
+ *   < 0:  -errno
+ *
+ * it's an given fact that tx() and rx() never fail.
+ */
+ssize_t tx(int fd, int *cmd, uint8_t cmdlen, int cdata)
+{
+	struct msghdr msg;
+	struct iovec iov[cmdlen];
+	size_t cmsglen = CMSG_SPACE(sizeof(int));
+	char control[CMSG_SPACE(sizeof(int))];
+	struct cmsghdr *cmsg;
+	int i;
+
+	memset(&msg, 0, sizeof(struct msghdr));
+	memset(iov, 0, sizeof(struct iovec) * cmdlen);
+
+	msg.msg_iov = iov;
+	msg.msg_iovlen = cmdlen;
+	for (i = 0; i < cmdlen; i++) {
+		iov[i].iov_len = sizeof(int);
+		iov[i].iov_base = &cmd[i];
+	}
+	if (cdata) {
+		msg.msg_control = control;
+		msg.msg_controllen = cmsglen;
+		cmsg = CMSG_FIRSTHDR(&msg);
+		cmsg->cmsg_len = CMSG_LEN(sizeof(int));
+		cmsg->cmsg_level = SOL_SOCKET;
+		cmsg->cmsg_type = SCM_RIGHTS;
+		put_unaligned_int(CMSG_DATA(cmsg), cdata);
+	}
+
+	return sendmsg(fd, &msg, 0);
+}
+
+ssize_t rx(int fd, int *cmd, uint8_t cmdlen, int *cdata)
+{
+	struct msghdr msg;
+	struct iovec iov[cmdlen];
+	size_t cmsglen = CMSG_SPACE(sizeof(int));
+	char control[CMSG_SPACE(sizeof(int))];
+	struct cmsghdr *cmsg;
+	ssize_t ret;
+	int i;
+
+	memset(&msg, 0, sizeof(struct msghdr));
+	memset(iov, 0, sizeof(struct iovec));
+
+	msg.msg_iov = iov;
+	msg.msg_iovlen = cmdlen;
+	for (i = 0; i < cmdlen; i++) {
+		iov[i].iov_len = sizeof(int);
+		iov[i].iov_base = &cmd[i];
+	}
+	if (cdata != NULL) {
+		msg.msg_control = control;
+		msg.msg_controllen = cmsglen;
+	}
+
+	ret = recvmsg(fd, &msg, 0);
+	if (ret == -1) {
+		perror("recvmsg");
+		return ret;
+	}
+
+	if (cdata == NULL)
+		return ret;
+
+	cmsg = CMSG_FIRSTHDR(&msg);
+	if (cmsg == NULL || cmsg->cmsg_len != CMSG_LEN(sizeof(int))
+	    || cmsg->cmsg_level != SOL_SOCKET
+	    || cmsg->cmsg_type != SCM_RIGHTS) {
+		errno = EBADMSG;
+		return -1;
+	}
+	*cdata = get_unaligned_int(CMSG_DATA(cmsg));
+
+	return ret;
+}
+
+int tx_cmd(int fd, int cmd)
+{
+	return tx(fd, &cmd, 1, 0);
+}
+
+int rx_cmd(int fd)
+{
+	int cmd;
+	if (rx((fd), &cmd, 1, NULL) == -1)
+		return -1;
+	return cmd;
+}
+
+int tx_fd(int fd1, int fd2, int e)
+{
+	return tx(fd1, &e, 1, fd2);
+}
+
+int rx_fd(int fd1)
+{
+	int e, fd2;
+
+	if (rx(fd1, &e, 1, &fd2) == -1)
+		return -1;
+
+	errno = -e;
+	return fd2;
+}
+
+/*
+ * copy from ip/ipnetns.c::iproute2
+ */
+#ifndef HAVE_SETNS
+#include <sys/syscall.h>
+static int setns(int fd, int nstype)
+{
+#ifdef __NR_setns
+	return syscall(__NR_setns, fd, nstype);
+#else
+	errno = ENOSYS;
+	return -1;
+#endif
+}
+#endif /* HAVE_SETNS */
+
+#define NETNS_RUN_DIR "/var/run/netns"
+static int netns_setup(const char *name)
+{
+	/* Setup the proper environment for apps that are not netns
+	 * aware, and execute a program in that environment.
+	 */
+	char net_path[MAXPATHLEN];
+	int netns;
+
+	snprintf(net_path, sizeof(net_path), "%s/%s", NETNS_RUN_DIR, name);
+	netns = open(net_path, O_RDONLY | O_CLOEXEC);
+	if (netns < 0) {
+		fprintf(stderr, "Cannot open network namespace \"%s\": %s\n",
+			name, strerror(errno));
+		return -1;
+	}
+
+	if (setns(netns, CLONE_NEWNET) < 0) {
+		fprintf(stderr, "setting the network namespace \"%s\" failed: %s\n",
+			name, strerror(errno));
+		return -1;
+	}
+
+	if (unshare(CLONE_NEWNS) < 0) {
+		fprintf(stderr, "unshare failed: %s\n", strerror(errno));
+		return -1;
+	}
+	/* Don't let any mounts propagate back to the parent */
+	if (mount("", "/", "none", MS_SLAVE | MS_REC, NULL)) {
+		fprintf(stderr, "\"mount --make-rslave /\" failed: %s\n",
+			strerror(errno));
+		return -1;
+	}
+	/* Mount a version of /sys that describes the network namespace */
+	if (umount2("/sys", MNT_DETACH) < 0) {
+		fprintf(stderr, "umount of /sys failed: %s\n", strerror(errno));
+		return -1;
+	}
+	if (mount(name, "/sys", "sysfs", 0, NULL) < 0) {
+		fprintf(stderr, "mount of /sys failed: %s\n",strerror(errno));
+		return -1;
+	}
+
+	return 0;
+}
+
+static void child(const char *nsname)
+{
+	int cmd = CMD_SYNC;
+	int params[3]; /* XXX: magic number, see enum CALL_ */
+	int sockfd;
+
+	if (netns_setup(nsname) == -1)
+		child_exit("netns_setup", EXIT_FAILURE);
+
+	/* sync with parent */
+	if (tx_cmd(CHILD_FD, CMD_SYNC) == -1)
+		child_exit("tx_cmd", EXIT_FAILURE);
+
+	/* waiting cmd */
+	while (1) {
+		debug_ns("child waiting for cmd...\n");
+		cmd = rx_cmd(CHILD_FD);
+		switch (cmd) {
+		case CMD_DONE:
+			debug_ns("child received CMD_DONE - exiting\n");
+			close(CHILD_FD);
+			child_exit("receive CMD_DONE", EXIT_SUCCESS);
+			break;
+		case CMD_SOCKET:
+			if (rx(CHILD_FD, params, 3, NULL) == -1)
+				child_exit("rx", EXIT_FAILURE);
+			debug_ns("child received CMD_SOCKET -"
+				 " domain: %d, type: %d, protocol: %d\n",
+				 params[0], params[1], params[2]);
+			sockfd = socket(params[0], params[1], params[2]);
+			if (tx_fd(CHILD_FD, sockfd, -errno) == -1)
+				child_exit("tx_fd", EXIT_FAILURE);
+			break;
+		default:
+			debug_ns("child received unknown cmd: %d\n", cmd);
+			child_exit("receive unknown cmd", EXIT_FAILURE);
+			break;
+		}
+	}
+}
+
+/*
+ * kill all the other registered child by SIGKILL
+ *
+ * SIGCHLD will not be raised if child has killed in SIGABRT handler
+ */
+static void sigchld_handler(int signum)
+{
+	pid_t pid;
+	int status, i, fail = 0;
+
+	while ((pid = waitpid(-1, &status, WNOHANG)) > 0) {
+		debug_ns("receive SIGCHLD - pid: %d\n", pid);
+		if (WIFEXITED(status))
+			fail |= WEXITSTATUS(status);
+		else if (WIFSIGNALED(status) || WCOREDUMP(status))
+			fail |= status;
+		if (pid == child_pid)
+			child_pid = 0;
+		for (i = 0; i < nchild; i++)
+			if (children[i] == pid)
+				children[i] = 0;
+			else
+				kill(children[i], SIGKILL);
+	}
+	if (pid == -1 && errno != ECHILD)
+		fail |= errno;
+
+	/* overdoing? kill myself
+	 * if (fail) kill(0, SIGKILL);
+	 */
+}
+
+/*
+ * core public API
+ */
+int init_nssocket(const char *nsname)
+{
+	pid_t pid;
+	struct sigaction sa;
+
+	if (socketpair(AF_UNIX, SOCK_STREAM, 0, fdpair) == -1)
+		return -1;
+
+	sigemptyset(&sa.sa_mask);
+	sa.sa_handler = sigchld_handler;
+	sa.sa_flags = SA_NOCLDSTOP;
+	if (sigaction(SIGCHLD, &sa, NULL) == -1)
+		return -1;
+
+	fflush(stdout);
+	pid = fork();
+	switch (pid) {
+	case -1:
+		return -1;
+		break;
+	case 0:
+		child(nsname); /* not return */
+		break;
+	default:
+		child_pid = pid;
+		add_child(pid);
+		if (rx_cmd(PARENT_FD) < 0) {
+			parent_fail("rx_cmd");
+			return -1;
+		}
+		break;
+	}
+
+	return 0;
+}
+
+int fini_nssocket(void)
+{
+	int status;
+	sigset_t block_mask;
+	pid_t pid;
+
+	sigemptyset(&block_mask);
+	sigaddset(&block_mask, SIGCHLD);
+	if (sigprocmask(SIG_SETMASK, &block_mask, NULL) == -1)
+		return -1;
+	tx_cmd(PARENT_FD, CMD_DONE);
+	close(PARENT_FD);
+	pid = waitpid(child_pid, &status, 0);
+	child_pid = 0;
+	if (pid < 0)
+		return -1;
+	if (WIFEXITED(status) && WEXITSTATUS(status) == 0)
+		return 0;
+
+	return status;
+}
+
+int nssocket(int domain, int type, int protocol)
+{
+	int cmd[] = {CMD_SOCKET, domain, type, protocol};
+
+	if (child_pid == 0 || kill(child_pid, 0) == -1) {
+		errno = ECHILD;
+		return -1;
+	}
+	tx(PARENT_FD, cmd, 4, 0);
+	return rx_fd(PARENT_FD);
+}
+
+/*
+ * utils API
+ */
+int debug_nfct_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nf_conntrack *ct;
+	uint32_t type = NFCT_T_UNKNOWN;
+	char buf[4096];
+
+	switch(nlh->nlmsg_type & 0xFF) {
+	case IPCTNL_MSG_CT_NEW:
+		if (nlh->nlmsg_flags & (NLM_F_CREATE|NLM_F_EXCL))
+			type = NFCT_T_NEW;
+		else
+			type = NFCT_T_UPDATE;
+		break;
+	case IPCTNL_MSG_CT_DELETE:
+		type = NFCT_T_DESTROY;
+		break;
+	}
+
+	ct = nfct_new();
+	if (ct == NULL)
+		return MNL_CB_OK;
+
+	nfct_nlmsg_parse(nlh, ct);
+	nfct_snprintf(buf, sizeof(buf), ct, type, NFCT_O_DEFAULT, 0);
+	debug("%s\n", buf);
+	nfct_destroy(ct);
+
+	return MNL_CB_OK;
+}
+
+struct mnl_socket *mnl_nssocket_open(int bus)
+{
+	int fd;
+	struct mnl_socket *nl;
+
+	fd = nssocket(AF_NETLINK, SOCK_RAW, bus);
+	if (fd == -1)
+		return NULL;
+
+	nl = mnl_socket_fdopen(fd);
+	if (nl == NULL) {
+		close(fd);
+		return NULL;
+	}
+	return nl;
+}
diff --git a/qa/nssocket.h b/qa/nssocket.h
new file mode 100644
index 0000000..52a4a24
--- /dev/null
+++ b/qa/nssocket.h
@@ -0,0 +1,66 @@
+#ifndef _QA_NSSOCKET_H_
+#define _QA_NSSOCKET_H_
+
+#include <libmnl/libmnl.h>
+
+/* ipc command */
+enum {
+	CMD_SYNC,
+	CMD_SOCKET, /* int domain, int type, int protocol */
+	CMD_DONE,
+	CMD_ERREXIT,
+};
+
+int init_nssocket(const char *nsname);
+int fini_nssocket(void);
+int nssocket(int domain, int type, int protocol);
+struct mnl_socket *mnl_nssocket_open(int bus);
+
+ssize_t tx(int fd, int *cmd, uint8_t cmdlen, int cdata);
+ssize_t rx(int fd, int *cmd, uint8_t cmdlen, int *cdata);
+int tx_cmd(int fd, int cmd);
+int rx_cmd(int fd);
+int tx_fd(int fd1, int fd2, int e);
+int rx_fd(int fd1);
+int debug_nfct_cb(const struct nlmsghdr *nlh, void *data);
+
+/* #define DEBUG_NS */
+#define DEBUG
+
+#ifdef DEBUG
+#include <stdarg.h>
+#define debug(...) do { fprintf(stderr, ##__VA_ARGS__); } while (0)
+#else
+#define debug(...)
+#endif
+
+#ifdef DEBUG_NS
+#include <stdarg.h>
+#define debug_ns(...) do { fprintf(stderr, ##__VA_ARGS__); } while (0)
+#else
+#define debug_ns(...)
+#endif
+
+#define child_exit(msg, code)						\
+	do {								\
+		if (code)						\
+			fprintf(stderr, "child exiting - %s:%d %s() %s: %s\n", \
+				__FILE__, __LINE__, __func__, (msg), strerror(errno)); \
+		_exit((code));						\
+	} while (0)
+
+#define MAX_CHILD 64
+pid_t children[MAX_CHILD]; /* kill if not 0 */
+int nchild;
+void add_child(pid_t pid);
+
+#define parent_fail(msg) do {						\
+	int i;								\
+	fprintf(stderr, "parent fail - %s:%d %s() %s: %s\n",		\
+		__FILE__, __LINE__, __func__, (msg), strerror(errno));	\
+	for (i = 0; i < nchild; i++)					\
+		if (children[i])					\
+			kill(children[i], SIGKILL);			\
+	} while (0)
+
+#endif /* _QA_NSSOCKET_H_ */
-- 
2.1.1

