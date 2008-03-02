From: Patrick McHardy <kaber@trash.net>
Subject: netlink socket filtering
Date: Sun, 02 Mar 2008 14:36:14 +0100
Message-ID: <47CAAD4E.3020508@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080008030609060102070607"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep20-int.chello.at ([62.179.121.40]:35826 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbYCBNgT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 2 Mar 2008 08:36:19 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080008030609060102070607
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Out of interest how feasible it would be to do ctnetlink
message filtering using socket filters I've hacked together
these two patches for the kernel and libnl to filter on
the TCP_CONNTRACK_ESTABLISHED state.

The filtering works well, but it brought up a question that
I think also affects the patches you've posted earlier.
You mentioned that for synchronization you want to filter
on ESTABLISHED states. Since BPF only gets the final message
it can't filter on the previous conntrack state when
transitioning, but only on the current state. This means
that a filter on TCP_CONNTRACK_ESTABLISHED won't let
a message for a transition from TCP_CONNTRACK_ESTABLISHED
to TCP_CONNTRACK_CLOSED pass.

Your patches add a new table, at which point the conntrack
will also already have performed the transistion and filtering
using state matches will also only see the new state. So I'm
wondering, what are the exact filtering needs for replication
and would something like this work?



--------------080008030609060102070607
Content-Type: text/x-patch;
 name="libnl-skfilter.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libnl-skfilter.diff"

diff --git a/src/nf-monitor.c b/src/nf-monitor.c
index 2bc58c9..8614924 100644
--- a/src/nf-monitor.c
+++ b/src/nf-monitor.c
@@ -13,6 +13,9 @@
 
 #include "utils.h"
 #include <netlink/netfilter/nfnl.h>
+#include <linux/netfilter/nfnetlink_conntrack.h>
+#include <linux/netfilter/nf_conntrack_tcp.h>
+#include <linux/filter.h>
 
 static void obj_input(struct nl_object *obj, void *arg)
 {
@@ -34,6 +37,116 @@ static int event_input(struct nl_msg *msg, void *arg)
 	return NL_STOP;
 }
 
+#define SKF_AD_NLATTR	12
+
+#define FILTER_ACCEPT	0xFFFE
+#define FILTER_REJECT	0xFFFF
+
+static int sk_set_filter(int fd)
+{
+	struct sock_filter filter[] = {
+		{
+			/* A = sizeof(struct nlmsghdr) + sizeof(struct nfgenmsg) */
+			.code	= BPF_LD|BPF_IMM,
+			.k	= sizeof(struct nlmsghdr) + sizeof(struct nfgenmsg),
+		},
+		{
+			/* X = CTA_PROTOINFO */
+			.code	= BPF_LDX|BPF_IMM,
+			.k	= CTA_PROTOINFO,
+		},
+		{
+			/* A = netlink attribute offset */
+			.code	= BPF_LD|BPF_B|BPF_ABS,
+			.k	= SKF_AD_OFF + SKF_AD_NLATTR,
+		},
+		{
+			/* Reject if not found (A == 0) */
+			.code	= BPF_JMP|BPF_JEQ|BPF_K,
+			.k	= 0,
+			.jt	= 20 - 3 - 1,
+		},
+
+		{
+			/* A += sizeof(struct nlattr) */
+			.code	= BPF_ALU|BPF_ADD|BPF_K,
+			.k	= sizeof(struct nlattr),
+		},
+		{
+			/* X = CTA_PROTOINFO_TCP */
+			.code	= BPF_LDX|BPF_IMM,
+			.k	= CTA_PROTOINFO_TCP,
+		},
+		{
+			/* A = netlink attribute offset */
+			.code	= BPF_LD|BPF_B|BPF_ABS,
+			.k	= SKF_AD_OFF + SKF_AD_NLATTR,
+		},
+		{
+			/* Reject if not found (A == 0) */
+			.code	= BPF_JMP|BPF_JEQ|BPF_K,
+			.k	= 0,
+			.jt	= 20 - 7 - 1,
+		},
+
+		{
+			/* A += sizeof(struct nlattr) */
+			.code	= BPF_ALU|BPF_ADD|BPF_K,
+			.k	= sizeof(struct nlattr),
+		},
+		{
+			/* X = CTA_PROTOINFO_TCP_STATE */
+			.code	= BPF_LDX|BPF_IMM,
+			.k	= CTA_PROTOINFO_TCP_STATE,
+		},
+		{
+			/* A = netlink attribute offset */
+			.code	= BPF_LD|BPF_B|BPF_ABS,
+			.k	= SKF_AD_OFF + SKF_AD_NLATTR,
+		},
+		{
+			/* Reject if not found (A == 0) */
+			.code	= BPF_JMP|BPF_JEQ|BPF_K,
+			.k	= 0,
+			.jt	= 20 - 11 - 1,
+		},
+
+		{
+			/* X = A */
+			.code	= BPF_MISC|BPF_TAX,
+		},
+		{
+			/* A = skb->data[X + k] */
+			.code	= BPF_LD|BPF_B|BPF_IND,
+			.k	= sizeof(struct nlattr),
+		},
+		{
+			/* Reject if A != TCA_CONNTRACK_ESTABLISHED */
+			.code	= BPF_JMP|BPF_JEQ|BPF_K,
+			.k	= TCP_CONNTRACK_ESTABLISHED,
+			.jf	= 20 - 14 - 1,
+		},
+
+		{
+			/* Accept */
+			.code	= BPF_RET|BPF_K,
+			.k	= 1,
+		},
+		[20]	= {
+			/* Reject */
+			.code	= BPF_RET|BPF_K,
+			.k	= 0,
+		},
+	};
+	struct sock_fprog fprog = {
+		.len		= sizeof(filter) / sizeof(filter[0]),
+		.filter		= filter,
+	};
+
+	return setsockopt(fd, SOL_SOCKET, SO_ATTACH_FILTER,
+			  &fprog, sizeof(fprog));
+}
+
 int main(int argc, char *argv[])
 {
 	struct nl_handle *nlh;
@@ -92,6 +205,11 @@ int main(int argc, char *argv[])
 			fprintf(stderr, "Warning: Unknown group: %s\n", argv[idx]);
 	}
 
+	if (sk_set_filter(nl_socket_get_fd(nlh)) < 0) {
+		perror("setsockopt(SO_ATTACH_FILTER)");
+		goto errout;
+	}
+
 	while (1) {
 		fd_set rfds;
 		int fd, retval;

--------------080008030609060102070607
Content-Type: text/x-patch;
 name="linux-skfilter.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-skfilter.diff"

diff --git a/include/linux/filter.h b/include/linux/filter.h
index ddfa037..0e39016 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -136,7 +136,8 @@ static inline unsigned int sk_filter_len(struct sk_filter *fp)
 #define SKF_AD_PROTOCOL 0
 #define SKF_AD_PKTTYPE 	4
 #define SKF_AD_IFINDEX 	8
-#define SKF_AD_MAX 	12
+#define SKF_AD_NLATTR	12
+#define SKF_AD_MAX 	16
 #define SKF_NET_OFF   (-0x100000)
 #define SKF_LL_OFF    (-0x200000)
 
diff --git a/net/core/filter.c b/net/core/filter.c
index e0a0694..20ed056 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -27,6 +27,7 @@
 #include <linux/if_packet.h>
 #include <net/ip.h>
 #include <net/protocol.h>
+#include <net/netlink.h>
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <linux/errno.h>
@@ -268,6 +269,22 @@ load_b:
 		case SKF_AD_IFINDEX:
 			A = skb->dev->ifindex;
 			continue;
+		case SKF_AD_NLATTR: {
+			struct nlattr *nla;
+
+			if (skb_is_nonlinear(skb))
+				return 0;
+			if (A > skb->len - sizeof(struct nlattr))
+				return 0;
+
+			nla = nla_find((struct nlattr *)&skb->data[A],
+				       skb->len - A, X);
+			if (nla)
+				A = (void *)nla - (void *)skb->data;
+			else
+				A = 0;
+			continue;
+		}
 		default:
 			return 0;
 		}
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 524e826..6f68f2b 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -919,6 +919,17 @@ static inline int netlink_broadcast_deliver(struct sock *sk,
 					    struct sk_buff *skb)
 {
 	struct netlink_sock *nlk = nlk_sk(sk);
+	struct sk_filter *filter;
+	unsigned int len = skb->len;
+
+	rcu_read_lock_bh();
+	filter = rcu_dereference(sk->sk_filter);
+	if (filter)
+		len = sk_run_filter(skb, filter->insns, filter->len);
+	rcu_read_unlock_bh();
+
+	if (len == 0)
+		return 0;
 
 	if (atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf &&
 	    !test_bit(0, &nlk->state)) {

--------------080008030609060102070607--
