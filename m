Return-Path: <SRS0=TDc5=UZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8BF9C48BD6
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 14:16:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2A7B2147A
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 14:16:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbfFZOQw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jun 2019 10:16:52 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:41354 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726131AbfFZOQw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jun 2019 10:16:52 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hg8j8-0002ii-C7; Wed, 26 Jun 2019 16:16:46 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] selftests: netfilter: add nfqueue test case
Date:   Wed, 26 Jun 2019 16:18:26 +0200
Message-Id: <20190626141826.5810-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a test case to check nf queue infrastructure.
Could be extended in the future to also cover serialization of
conntrack, uid and secctx attributes in nfqueue.

For now, this checks that 'queue bypass' works, that a queue rule with
no bypass option blocks traffic and that userspace receives the expected
number of packets.
For this we add two queues and hook all of
prerouting/input/forward/output/postrouting.

Packets get queued twice with a dummy base chain in between:
This passes with current nf tree, but reverting
commit 946c0d8e6ed4 ("netfilter: nf_queue: fix reinject verdict handling")
makes this trip (it processes 30 instead of expected 20 packets).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tools/testing/selftests/netfilter/.gitignore  |   1 +
 tools/testing/selftests/netfilter/Makefile    |   5 +-
 tools/testing/selftests/netfilter/nf-queue.c  | 281 ++++++++++++++++++
 .../testing/selftests/netfilter/nft_queue.sh  | 274 +++++++++++++++++
 4 files changed, 560 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/netfilter/.gitignore
 create mode 100644 tools/testing/selftests/netfilter/nf-queue.c
 create mode 100755 tools/testing/selftests/netfilter/nft_queue.sh

diff --git a/tools/testing/selftests/netfilter/.gitignore b/tools/testing/selftests/netfilter/.gitignore
new file mode 100644
index 000000000000..03c4a7b5d153
--- /dev/null
+++ b/tools/testing/selftests/netfilter/.gitignore
@@ -0,0 +1 @@
+nf-queue
diff --git a/tools/testing/selftests/netfilter/Makefile b/tools/testing/selftests/netfilter/Makefile
index 4144984ebee5..0f6f6530030d 100644
--- a/tools/testing/selftests/netfilter/Makefile
+++ b/tools/testing/selftests/netfilter/Makefile
@@ -2,6 +2,9 @@
 # Makefile for netfilter selftests
 
 TEST_PROGS := nft_trans_stress.sh nft_nat.sh bridge_brouter.sh \
-	conntrack_icmp_related.sh nft_flowtable.sh
+	conntrack_icmp_related.sh nft_flowtable.sh nft_queue.sh
+
+LDLIBS = -lmnl
+TEST_GEN_FILES =  nf-queue
 
 include ../lib.mk
diff --git a/tools/testing/selftests/netfilter/nf-queue.c b/tools/testing/selftests/netfilter/nf-queue.c
new file mode 100644
index 000000000000..897274bd6f4a
--- /dev/null
+++ b/tools/testing/selftests/netfilter/nf-queue.c
@@ -0,0 +1,281 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <errno.h>
+#include <stdio.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+#include <time.h>
+#include <arpa/inet.h>
+
+#include <libmnl/libmnl.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nfnetlink_queue.h>
+
+static int parse_attr_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	/* skip unsupported attribute in user-space */
+	if (mnl_attr_type_valid(attr, NFQA_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch (type) {
+	case NFQA_MARK:
+	case NFQA_IFINDEX_INDEV:
+	case NFQA_IFINDEX_OUTDEV:
+	case NFQA_IFINDEX_PHYSINDEV:
+	case NFQA_IFINDEX_PHYSOUTDEV:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
+			perror("mnl_attr_validate");
+			return MNL_CB_ERROR;
+		}
+		break;
+	case NFQA_TIMESTAMP:
+		if (mnl_attr_validate2(attr, MNL_TYPE_UNSPEC,
+		    sizeof(struct nfqnl_msg_packet_timestamp)) < 0) {
+			perror("mnl_attr_validate2");
+			return MNL_CB_ERROR;
+		}
+		break;
+	case NFQA_HWADDR:
+		if (mnl_attr_validate2(attr, MNL_TYPE_UNSPEC,
+		    sizeof(struct nfqnl_msg_packet_hw)) < 0) {
+			perror("mnl_attr_validate2");
+			return MNL_CB_ERROR;
+		}
+		break;
+	case NFQA_PAYLOAD:
+		break;
+	}
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static unsigned int queue_stats[5];
+
+static int queue_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nlattr *tb[NFQA_MAX+1] = { 0 };
+	struct nfqnl_msg_packet_hdr *ph = NULL;
+	uint32_t id = 0;
+
+	(void)data;
+
+	mnl_attr_parse(nlh, sizeof(struct nfgenmsg), parse_attr_cb, tb);
+	if (tb[NFQA_PACKET_HDR]) {
+		uint32_t skbinfo;
+
+		ph = mnl_attr_get_payload(tb[NFQA_PACKET_HDR]);
+		id = ntohl(ph->packet_id);
+
+		printf("packet hook=%u, hwproto 0x%x",
+			ntohs(ph->hw_protocol), ph->hook);
+
+		if (ph->hook >= 5) {
+			fprintf(stderr, "Unknown hook %d\n", ph->hook);
+			return MNL_CB_ERROR;
+		}
+
+		queue_stats[ph->hook]++;
+
+		skbinfo = 0;
+		if (tb[NFQA_SKB_INFO])
+			skbinfo = ntohl(mnl_attr_get_u32(tb[NFQA_SKB_INFO]));
+		if (skbinfo & NFQA_SKB_CSUMNOTREADY)
+			printf(" csumnotready");
+		if (skbinfo & NFQA_SKB_GSO)
+			printf(" gso");
+		if (skbinfo & NFQA_SKB_CSUM_NOTVERIFIED)
+			printf(" csumnotverified");
+
+		puts("");
+	}
+
+	return MNL_CB_OK + id;
+}
+
+static struct nlmsghdr *
+nfq_build_cfg_request(char *buf, uint8_t command, int queue_num)
+{
+	struct nlmsghdr *nlh = mnl_nlmsg_put_header(buf);
+	struct nfqnl_msg_config_cmd cmd = {
+		.command = command,
+		.pf = htons(AF_INET),
+	};
+	struct nfgenmsg *nfg;
+
+	nlh->nlmsg_type	= (NFNL_SUBSYS_QUEUE << 8) | NFQNL_MSG_CONFIG;
+	nlh->nlmsg_flags = NLM_F_REQUEST;
+
+	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
+
+	nfg->nfgen_family = AF_UNSPEC;
+	nfg->version = NFNETLINK_V0;
+	nfg->res_id = htons(queue_num);
+
+	mnl_attr_put(nlh, NFQA_CFG_CMD, sizeof(cmd), &cmd);
+
+	return nlh;
+}
+
+static struct nlmsghdr *
+nfq_build_cfg_params(char *buf, uint8_t mode, int range, int queue_num)
+{
+	struct nlmsghdr *nlh = mnl_nlmsg_put_header(buf);
+	struct nfqnl_msg_config_params params = {
+		.copy_range = htonl(range),
+		.copy_mode = mode,
+	};
+	struct nfgenmsg *nfg;
+
+	nlh->nlmsg_type	= (NFNL_SUBSYS_QUEUE << 8) | NFQNL_MSG_CONFIG;
+	nlh->nlmsg_flags = NLM_F_REQUEST;
+
+	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
+	nfg->nfgen_family = AF_UNSPEC;
+	nfg->version = NFNETLINK_V0;
+	nfg->res_id = htons(queue_num);
+
+	mnl_attr_put(nlh, NFQA_CFG_PARAMS, sizeof(params), &params);
+
+	return nlh;
+}
+
+static struct nlmsghdr *
+nfq_build_verdict(char *buf, int id, int queue_num, int verd)
+{
+	struct nfqnl_msg_verdict_hdr vh = {
+		.verdict = htonl(verd),
+		.id = htonl(id),
+	};
+	struct nlmsghdr *nlh;
+	struct nfgenmsg *nfg;
+
+	nlh = mnl_nlmsg_put_header(buf);
+	nlh->nlmsg_type = (NFNL_SUBSYS_QUEUE << 8) | NFQNL_MSG_VERDICT;
+	nlh->nlmsg_flags = NLM_F_REQUEST;
+	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
+	nfg->nfgen_family = AF_UNSPEC;
+	nfg->version = NFNETLINK_V0;
+	nfg->res_id = htons(queue_num);
+
+	mnl_attr_put(nlh, NFQA_VERDICT_HDR, sizeof(vh), &vh);
+
+	return nlh;
+}
+
+static int print_stats(void)
+{
+	unsigned int last, total;
+	int i, ret = 0;
+
+	total = 0;
+	last = queue_stats[0];
+
+	for (i = 0; i < 5; i++) {
+		if (last != queue_stats[i])
+			ret = 1;
+		printf("hook %d packets %08u\n", i, queue_stats[i]);
+		last = queue_stats[i];
+		total += last;
+	}
+
+	printf("%u packets total\n", total);
+	return ret;
+}
+
+int main(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	int ret;
+	unsigned int portid, queue_num;
+	uint32_t flags;
+	struct timeval tv;
+
+	if (argc != 2) {
+		printf("Usage: %s [queue_num]\n", argv[0]);
+		exit(EXIT_FAILURE);
+	}
+	queue_num = atoi(argv[1]);
+
+	nl = mnl_socket_open(NETLINK_NETFILTER);
+	if (nl == NULL) {
+		perror("mnl_socket_open");
+		exit(EXIT_FAILURE);
+	}
+
+	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
+		perror("mnl_socket_bind");
+		exit(EXIT_FAILURE);
+	}
+	portid = mnl_socket_get_portid(nl);
+
+	nlh = nfq_build_cfg_request(buf, NFQNL_CFG_CMD_BIND, queue_num);
+
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+		perror("mnl_socket_sendto");
+		exit(EXIT_FAILURE);
+	}
+
+	nlh = nfq_build_cfg_params(buf, NFQNL_COPY_PACKET, 0xFFFF, queue_num);
+
+	flags = NFQA_CFG_F_GSO | NFQA_CFG_F_UID_GID;
+	mnl_attr_put_u32(nlh, NFQA_CFG_FLAGS, htonl(flags));
+	mnl_attr_put_u32(nlh, NFQA_CFG_MASK, htonl(flags));
+
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+		perror("mnl_socket_sendto");
+		exit(EXIT_FAILURE);
+	}
+
+
+	memset(&tv, 0, sizeof(tv));
+	tv.tv_sec = 3;
+	if (setsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_RCVTIMEO,
+			&tv, sizeof(tv))) {
+		perror("setsockopt(SO_RCVTIMEO)");
+		exit(EXIT_FAILURE);
+	}
+
+	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	if (ret == -1) {
+		perror("mnl_socket_recvfrom");
+		exit(EXIT_FAILURE);
+	}
+	while (ret > 0) {
+		uint32_t id;
+
+		ret = mnl_cb_run(buf, ret, 0, portid, queue_cb, NULL);
+		if (ret < 0) {
+			perror("mnl_cb_run");
+			exit(EXIT_FAILURE);
+		}
+
+		id = ret - MNL_CB_OK;
+		nlh = nfq_build_verdict(buf, id, queue_num, NF_ACCEPT);
+		if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+			perror("mnl_socket_sendto");
+			exit(EXIT_FAILURE);
+		}
+
+		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+		if (ret == -1) {
+			if (errno == EAGAIN) {
+				ret = print_stats();
+				break;
+			}
+			perror("mnl_socket_recvfrom");
+			exit(EXIT_FAILURE);
+		}
+	}
+
+	mnl_socket_close(nl);
+
+	return ret;
+}
diff --git a/tools/testing/selftests/netfilter/nft_queue.sh b/tools/testing/selftests/netfilter/nft_queue.sh
new file mode 100755
index 000000000000..3e271dcd6841
--- /dev/null
+++ b/tools/testing/selftests/netfilter/nft_queue.sh
@@ -0,0 +1,274 @@
+#!/bin/bash
+#
+# This tests nf_queue:
+# 1. can process packets from all hooks
+# 2. support running nfqueue from more than one base chain
+#
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+ret=0
+
+cleanup()
+{
+	for i in 1 2; do ip netns del ns$i;done
+	ip netns del nsrouter
+	rm -f "$TMPFILE0"
+	rm -f "$TMPFILE1"
+}
+
+nft --version > /dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run test without nft tool"
+	exit $ksft_skip
+fi
+
+ip -Version > /dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run test without ip tool"
+	exit $ksft_skip
+fi
+
+ip netns add nsrouter
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not create net namespace"
+	exit $ksft_skip
+fi
+
+TMPFILE0=$(mktemp)
+TMPFILE1=$(mktemp)
+trap cleanup EXIT
+
+ip netns add ns1
+ip netns add ns2
+
+ip link add veth0 netns nsrouter type veth peer name eth0 netns ns1 > /dev/null 2>&1
+if [ $? -ne 0 ];then
+    echo "SKIP: No virtual ethernet pair device support in kernel"
+    exit $ksft_skip
+fi
+ip link add veth1 netns nsrouter type veth peer name eth0 netns ns2
+
+ip -net nsrouter link set lo up
+ip -net nsrouter link set veth0 up
+ip -net nsrouter addr add 10.0.1.1/24 dev veth0
+ip -net nsrouter addr add dead:1::1/64 dev veth0
+
+ip -net nsrouter link set veth1 up
+ip -net nsrouter addr add 10.0.2.1/24 dev veth1
+ip -net nsrouter addr add dead:2::1/64 dev veth1
+
+for i in 1 2; do
+  ip -net ns$i link set lo up
+  ip -net ns$i link set eth0 up
+  ip -net ns$i addr add 10.0.$i.99/24 dev eth0
+  ip -net ns$i route add default via 10.0.$i.1
+  ip -net ns$i addr add dead:$i::99/64 dev eth0
+  ip -net ns$i route add default via dead:$i::1
+done
+
+load_ruleset() {
+	local name=$1
+	local prio=$2
+
+ip netns exec nsrouter nft -f - <<EOF
+table inet $name {
+	chain nfq {
+		ip protocol icmp queue bypass
+		icmpv6 type { "echo-request", "echo-reply" } queue num 1 bypass
+	}
+	chain pre {
+		type filter hook prerouting priority $prio; policy accept;
+		jump nfq
+	}
+	chain input {
+		type filter hook input priority $prio; policy accept;
+		jump nfq
+	}
+	chain forward {
+		type filter hook forward priority $prio; policy accept;
+		jump nfq
+	}
+	chain output {
+		type filter hook output priority $prio; policy accept;
+		jump nfq
+	}
+	chain post {
+		type filter hook postrouting priority $prio; policy accept;
+		jump nfq
+	}
+}
+EOF
+}
+
+load_counter_ruleset() {
+	local prio=$1
+
+ip netns exec nsrouter nft -f - <<EOF
+table inet countrules {
+	chain pre {
+		type filter hook prerouting priority $prio; policy accept;
+		counter
+	}
+	chain input {
+		type filter hook input priority $prio; policy accept;
+		counter
+	}
+	chain forward {
+		type filter hook forward priority $prio; policy accept;
+		counter
+	}
+	chain output {
+		type filter hook output priority $prio; policy accept;
+		counter
+	}
+	chain post {
+		type filter hook postrouting priority $prio; policy accept;
+		counter
+	}
+}
+EOF
+}
+
+test_ping() {
+  ip netns exec ns1 ping -c 1 -q 10.0.2.99 > /dev/null
+  if [ $? -ne 0 ];then
+	return 1
+  fi
+
+  ip netns exec ns1 ping -c 1 -q dead:2::99 > /dev/null
+  if [ $? -ne 0 ];then
+	return 1
+  fi
+
+  return 0
+}
+
+test_ping_router() {
+  ip netns exec ns1 ping -c 1 -q 10.0.2.1 > /dev/null
+  if [ $? -ne 0 ];then
+	return 1
+  fi
+
+  ip netns exec ns1 ping -c 1 -q dead:2::1 > /dev/null
+  if [ $? -ne 0 ];then
+	return 1
+  fi
+
+  return 0
+}
+
+test_queue_blackhole() {
+	local proto=$1
+
+ip netns exec nsrouter nft -f - <<EOF
+table $proto blackh {
+	chain forward {
+	type filter hook forward priority 0; policy accept;
+		queue num 600
+	}
+}
+EOF
+	if [ $proto = "ip" ] ;then
+		ip netns exec ns1 ping -c 1 -q 10.0.2.99 > /dev/null
+		lret=$?
+	elif [ $proto = "ip6" ]; then
+		ip netns exec ns1 ping -c 1 -q dead:2::99 > /dev/null
+		lret=$?
+	else
+		lret=111
+	fi
+
+	# queue without bypass keyword should drop traffic if no listener exists.
+	if [ $lret -eq 0 ];then
+		echo "FAIL: $proto expected failure, got $lret" 1>&2
+		exit 1
+	fi
+
+	ip netns exec nsrouter nft delete table $proto blackh
+	if [ $? -ne 0 ] ;then
+	        echo "FAIL: $proto: Could not delete blackh table"
+	        exit 1
+	fi
+
+        echo "PASS: $proto: statement with no listener results in packet drop"
+}
+
+test_queue()
+{
+	local expected=$1
+	local last=""
+
+	# spawn nf-queue listeners
+	ip netns exec nsrouter ./nf-queue 0 > "$TMPFILE0" &
+	ip netns exec nsrouter ./nf-queue 1 > "$TMPFILE1" &
+	sleep 1
+	test_ping
+	ret=$?
+	if [ $ret -ne 0 ];then
+		echo "FAIL: netns routing/connectivity with active listener on queue $queue: $ret" 1>&2
+		exit $ret
+	fi
+
+	test_ping_router
+	ret=$?
+	if [ $ret -ne 0 ];then
+		echo "FAIL: netns router unreachable listener on queue $queue: $ret" 1>&2
+		exit $ret
+	fi
+
+	wait
+	ret=$?
+
+	for file in $TMPFILE0 $TMPFILE1; do
+		last=$(tail -n1 "$file")
+		if [ x"$last" != x"$expected packets total" ]; then
+			echo "FAIL: Expected $expected packets total, but got $last" 1>&2
+			cat "$file" 1>&2
+
+			ip netns exec nsrouter nft list ruleset
+			exit 1
+		fi
+	done
+
+	echo "PASS: Expected and received $last"
+}
+
+ip netns exec nsrouter sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
+ip netns exec nsrouter sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
+ip netns exec nsrouter sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
+
+load_ruleset "filter" 0
+
+sleep 3
+test_ping
+
+test_ping
+ret=$?
+if [ $ret -eq 0 ];then
+	# queue bypass works (rules were skipped, no listener)
+	echo "PASS: ns1 can reach ns2"
+else
+	echo "FAIL: ns1 cannot reach ns2: $ret" 1>&2
+	exit $ret
+fi
+
+test_queue_blackhole ip
+test_queue_blackhole ip6
+
+# dummy ruleset to add base chains between the
+# queueing rules.  We don't want the second reinject
+# to re-execute the old hooks.
+load_counter_ruleset 10
+
+# we are hooking all: prerouting/input/forward/output/postrouting.
+# we ping ns2 from ns1 via nsrouter using ipv4 and ipv6, so:
+# 1x icmp prerouting,forward,postrouting -> 3 queue events (6 incl. reply).
+# 1x icmp prerouting,input,output postrouting -> 4 queue events incl. reply.
+# so we expect that userspace program receives 10 packets.
+test_queue 10
+
+# same.  We queue to a second program as well.
+load_ruleset "filter2" 20
+test_queue 20
+
+exit $ret
-- 
2.21.0

