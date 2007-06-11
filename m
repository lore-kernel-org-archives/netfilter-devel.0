From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] add TCP protocol state event groups
Date: Mon, 11 Jun 2007 20:05:31 +0200
Message-ID: <466D8EEB.9080601@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020000050907060008040007"
Cc: Patrick McHardy <kaber@trash.net>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------020000050907060008040007
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This patch adds per-protocol state event groups, so one can only listen
to a certain TCP state change such as ESTABLISHED. Although such
per-state message filtering could be done in userspace, we save CPU
cycles since the kernel does not need to build and delivery messages
that will be later discarded in userspace. This patch is particularly
useful for conntrackd.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------020000050907060008040007
Content-Type: text/x-patch;
 name="proto.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="proto.patch"

[CTNETLINK] add TCP protocol state event groups

This patch adds per-protocol state event groups, so one can only listen to a 
certain TCP state change such as ESTABLISHED. Although such per-state message
filtering could be done in userspace, we save CPU cycles since the kernel does
not need to build and delivery messages that will be later discarded in 
userspace. This patch is particularly useful for conntrackd.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/include/linux/netfilter/nfnetlink.h
===================================================================
--- net-2.6.git.orig/include/linux/netfilter/nfnetlink.h	2007-06-11 02:31:08.000000000 +0200
+++ net-2.6.git/include/linux/netfilter/nfnetlink.h	2007-06-11 02:31:13.000000000 +0200
@@ -27,6 +27,33 @@ enum nfnetlink_groups {
 #define NFNLGRP_CONNTRACK_EXP_UPDATE	NFNLGRP_CONNTRACK_EXP_UPDATE
 	NFNLGRP_CONNTRACK_EXP_DESTROY,
 #define NFNLGRP_CONNTRACK_EXP_DESTROY	NFNLGRP_CONNTRACK_EXP_DESTROY
+
+	/* TCP protocol state groups */
+	NFNLGRP_CONNTRACK_PROTO_TCP_SYN_SENT,
+#define NFNLGRP_CONNTRACK_PROTO_TCP_SYN_SENT \
+	NFNLGRP_CONNTRACK_PROTO_TCP_SYN_SENT
+	NFNLGRP_CONNTRACK_PROTO_TCP_SYN_RECV,
+#define NFNLGRP_CONNTRACK_PROTO_TCP_SYN_RECV \
+	NFNLGRP_CONNTRACK_PROTO_TCP_SYN_RECV
+	NFNLGRP_CONNTRACK_PROTO_TCP_ESTABLISHED,
+#define NFNLGRP_CONNTRACK_PROTO_TCP_ESTABLISHED \
+	NFNLGRP_CONNTRACK_PROTO_TCP_ESTABLISHED
+	NFNLGRP_CONNTRACK_PROTO_TCP_FIN_WAIT,
+#define NFNLGRP_CONNTRACK_PROTO_TCP_FIN_WAIT \
+	NFNLGRP_CONNTRACK_PROTO_TCP_FIN_WAIT
+	NFNLGRP_CONNTRACK_PROTO_TCP_CLOSE_WAIT,
+#define NFNLGRP_CONNTRACK_PROTO_TCP_CLOSE_WAIT \
+	NFNLGRP_CONNTRACK_PROTO_TCP_CLOSE_WAIT
+	NFNLGRP_CONNTRACK_PROTO_TCP_LAST_ACK,
+#define NFNLGRP_CONNTRACK_PROTO_TCP_LAST_ACK \
+	NFNLGRP_CONNTRACK_PROTO_TCP_LAST_ACK
+	NFNLGRP_CONNTRACK_PROTO_TCP_TIME_WAIT,
+#define NFNLGRP_CONNTRACK_PROTO_TCP_TIME_WAIT \
+	NFNLGRP_CONNTRACK_PROTO_TCP_TIME_WAIT
+	NFNLGRP_CONNTRACK_PROTO_TCP_CLOSE,
+#define NFNLGRP_CONNTRACK_PROTO_TCP_CLOSE \
+	NFNLGRP_CONNTRACK_PROTO_TCP_CLOSE
+
 	__NFNLGRP_MAX,
 };
 #define NFNLGRP_MAX	(__NFNLGRP_MAX - 1)
Index: net-2.6.git/include/net/netfilter/nf_conntrack_l4proto.h
===================================================================
--- net-2.6.git.orig/include/net/netfilter/nf_conntrack_l4proto.h	2007-06-11 02:31:08.000000000 +0200
+++ net-2.6.git/include/net/netfilter/nf_conntrack_l4proto.h	2007-06-11 02:31:13.000000000 +0200
@@ -75,6 +75,7 @@ struct nf_conntrack_l4proto
 			       const struct nf_conntrack_tuple *t);
 	int (*nfattr_to_tuple)(struct nfattr *tb[],
 			       struct nf_conntrack_tuple *t);
+	int (*event_group)(const struct nf_conn *ct);
 
 #ifdef CONFIG_SYSCTL
 	struct ctl_table_header	**ctl_table_header;
Index: net-2.6.git/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nf_conntrack_netlink.c	2007-06-11 02:31:08.000000000 +0200
+++ net-2.6.git/net/netfilter/nf_conntrack_netlink.c	2007-06-11 02:38:00.000000000 +0200
@@ -4,7 +4,7 @@
  * (C) 2001 by Jay Schulist <jschlst@samba.org>
  * (C) 2002-2006 by Harald Welte <laforge@gnumonks.org>
  * (C) 2003 by Patrick Mchardy <kaber@trash.net>
- * (C) 2005-2006 by Pablo Neira Ayuso <pablo@eurodev.net>
+ * (C) 2005-2007 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
  * Initial connection tracking via netlink development funded and
  * generally made possible by Network Robots, Inc. (www.networkrobots.com)
@@ -307,6 +307,20 @@ nfattr_failure:
 }
 
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
+static inline int proto_event_group(const struct nf_conn *ct)
+{
+	int ret = NFNLGRP_NONE;
+	u_int16_t npt = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum;
+	u_int16_t l3num = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
+	struct nf_conntrack_l4proto *l4proto;
+
+	l4proto = __nf_ct_l4proto_find(l3num, npt);
+	if (l4proto && l4proto->event_group)
+		ret = l4proto->event_group(ct);
+
+	return ret;
+}
+
 static int ctnetlink_conntrack_event(struct notifier_block *this,
 				     unsigned long events, void *ptr)
 {
@@ -317,7 +331,8 @@ static int ctnetlink_conntrack_event(str
 	struct sk_buff *skb;
 	unsigned int type;
 	sk_buff_data_t b;
-	unsigned int flags = 0, group;
+	unsigned int flags = 0, group, proto_group;
+	bool proto_group_has_listener = false;
 
 	/* ignore our fake conntrack entry */
 	if (ct == &nf_conntrack_untracked)
@@ -336,7 +351,11 @@ static int ctnetlink_conntrack_event(str
 	} else
 		return NOTIFY_DONE;
 
-	if (!nfnetlink_has_listeners(group))
+	proto_group = proto_event_group(ct);
+	if (proto_group != NFNLGRP_NONE && nfnetlink_has_listeners(proto_group))
+		proto_group_has_listener = true;
+
+	if (!proto_group_has_listener && !nfnetlink_has_listeners(group))
 		return NOTIFY_DONE;
 
 	skb = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
@@ -396,7 +415,11 @@ static int ctnetlink_conntrack_event(str
 	}
 
 	nlh->nlmsg_len = skb->tail - b;
+	if (proto_group_has_listener)
+		atomic_inc(&skb->users);
 	nfnetlink_send(skb, 0, group, 0);
+	if (proto_group_has_listener)
+		nfnetlink_send(skb, 0, proto_group, 0);
 	return NOTIFY_DONE;
 
 nlmsg_failure:
Index: net-2.6.git/net/netfilter/nf_conntrack_proto_tcp.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nf_conntrack_proto_tcp.c	2007-06-11 02:31:08.000000000 +0200
+++ net-2.6.git/net/netfilter/nf_conntrack_proto_tcp.c	2007-06-11 02:31:13.000000000 +0200
@@ -1171,6 +1171,22 @@ static int nfattr_to_tcp(struct nfattr *
 
 	return 0;
 }
+
+static int tcp_event_group[TCP_CONNTRACK_MAX] = {
+	[TCP_CONNTRACK_SYN_SENT]    = NFNLGRP_CONNTRACK_PROTO_TCP_SYN_SENT,
+	[TCP_CONNTRACK_SYN_RECV]    = NFNLGRP_CONNTRACK_PROTO_TCP_SYN_RECV,
+	[TCP_CONNTRACK_ESTABLISHED] = NFNLGRP_CONNTRACK_PROTO_TCP_ESTABLISHED,
+	[TCP_CONNTRACK_FIN_WAIT]    = NFNLGRP_CONNTRACK_PROTO_TCP_FIN_WAIT,
+	[TCP_CONNTRACK_CLOSE_WAIT]  = NFNLGRP_CONNTRACK_PROTO_TCP_CLOSE_WAIT,
+	[TCP_CONNTRACK_LAST_ACK]    = NFNLGRP_CONNTRACK_PROTO_TCP_LAST_ACK,
+	[TCP_CONNTRACK_TIME_WAIT]   = NFNLGRP_CONNTRACK_PROTO_TCP_TIME_WAIT,
+	[TCP_CONNTRACK_CLOSE]       = NFNLGRP_CONNTRACK_PROTO_TCP_CLOSE,
+};
+
+static int tcp_proto_event_group(const struct nf_conn *ct)
+{
+	return tcp_event_group[ct->proto.tcp.state];
+}
 #endif
 
 #ifdef CONFIG_SYSCTL
@@ -1400,6 +1416,7 @@ struct nf_conntrack_l4proto nf_conntrack
 	.from_nfattr		= nfattr_to_tcp,
 	.tuple_to_nfattr	= nf_ct_port_tuple_to_nfattr,
 	.nfattr_to_tuple	= nf_ct_port_nfattr_to_tuple,
+	.event_group		= tcp_proto_event_group,
 #endif
 #ifdef CONFIG_SYSCTL
 	.ctl_table_users	= &tcp_sysctl_table_users,
@@ -1429,6 +1446,7 @@ struct nf_conntrack_l4proto nf_conntrack
 	.from_nfattr		= nfattr_to_tcp,
 	.tuple_to_nfattr	= nf_ct_port_tuple_to_nfattr,
 	.nfattr_to_tuple	= nf_ct_port_nfattr_to_tuple,
+	.event_group		= tcp_proto_event_group,
 #endif
 #ifdef CONFIG_SYSCTL
 	.ctl_table_users	= &tcp_sysctl_table_users,

--------------020000050907060008040007--
