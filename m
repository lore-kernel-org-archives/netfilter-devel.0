From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC 2/3] netfilter: nfnetlink_queue: get rid of nfnetlink_queue_ct.c
Date: Tue,  8 Sep 2015 18:54:50 +0200
Message-ID: <1441731291-21342-3-git-send-email-pablo@netfilter.org>
References: <1441731291-21342-1-git-send-email-pablo@netfilter.org>
Cc: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37660 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049AbbIHQsZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Sep 2015 12:48:25 -0400
In-Reply-To: <1441731291-21342-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The original intention was to avoid dependencies between nfnetlink_queue and
conntrack without ifdef pollution. However, we can achieve this by moving the
conntrack dependent code into ctnetlink and keep some glue code to access the
nfq_ct indirection from nfqueue.

After this patch, the nfq_ct indirection is always compiled in the netfilter
core to avoid polluting nfqueue with ifdefs. Thus, if nf_conntrack is not
compiled this results in only 8-bytes of memory waste in x86_64.

This patch also adds ctnetlink_nfqueue_seqadj() to avoid that the nf_conn
structure layout if exposed to nf_queue, which creates another dependency with
nf_conntrack at compilation time.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter.h               |   12 ++--
 include/net/netfilter/nfnetlink_queue.h |   51 --------------
 net/netfilter/Makefile                  |    1 -
 net/netfilter/nf_conntrack_netlink.c    |   51 +++++++++++++-
 net/netfilter/nfnetlink_queue_core.c    |   52 ++++++++++----
 net/netfilter/nfnetlink_queue_ct.c      |  113 -------------------------------
 6 files changed, 97 insertions(+), 183 deletions(-)
 delete mode 100644 include/net/netfilter/nfnetlink_queue.h
 delete mode 100644 net/netfilter/nfnetlink_queue_ct.c

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index d788ce6..89bf246 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -371,14 +371,21 @@ nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl, u_int8_t family)
 extern void (*ip_ct_attach)(struct sk_buff *, const struct sk_buff *) __rcu;
 void nf_ct_attach(struct sk_buff *, const struct sk_buff *);
 extern void (*nf_ct_destroy)(struct nf_conntrack *) __rcu;
+#else
+static inline void nf_ct_attach(struct sk_buff *new, struct sk_buff *skb) {}
+#endif
 
 struct nf_conn;
 enum ip_conntrack_info;
 struct nlattr;
 
 struct nfq_ct_hook {
+	struct nf_conn *(*get_ct)(struct sk_buff *skb,
+				  enum ip_conntrack_info *ctinfo);
 	size_t (*build_size)(const struct nf_conn *ct);
-	int (*build)(struct sk_buff *skb, struct nf_conn *ct);
+	int (*build)(struct sk_buff *skb, struct nf_conn *ct,
+		     enum ip_conntrack_info ctinfo,
+		     u_int16_t ct_attr, u_int16_t ct_info_attr);
 	int (*parse)(const struct nlattr *attr, struct nf_conn *ct);
 	int (*attach_expect)(const struct nlattr *attr, struct nf_conn *ct,
 			     u32 portid, u32 report);
@@ -386,9 +393,6 @@ struct nfq_ct_hook {
 			   enum ip_conntrack_info ctinfo, s32 off);
 };
 extern struct nfq_ct_hook __rcu *nfq_ct_hook;
-#else
-static inline void nf_ct_attach(struct sk_buff *new, struct sk_buff *skb) {}
-#endif
 
 /**
  * nf_skb_duplicated - TEE target has sent a packet
diff --git a/include/net/netfilter/nfnetlink_queue.h b/include/net/netfilter/nfnetlink_queue.h
deleted file mode 100644
index aff88ba..0000000
--- a/include/net/netfilter/nfnetlink_queue.h
+++ /dev/null
@@ -1,51 +0,0 @@
-#ifndef _NET_NFNL_QUEUE_H_
-#define _NET_NFNL_QUEUE_H_
-
-#include <linux/netfilter/nf_conntrack_common.h>
-
-struct nf_conn;
-
-#ifdef CONFIG_NETFILTER_NETLINK_QUEUE_CT
-struct nf_conn *nfqnl_ct_get(struct sk_buff *entskb, size_t *size,
-			     enum ip_conntrack_info *ctinfo);
-struct nf_conn *nfqnl_ct_parse(const struct sk_buff *skb,
-			       const struct nlattr *attr,
-			       enum ip_conntrack_info *ctinfo);
-int nfqnl_ct_put(struct sk_buff *skb, struct nf_conn *ct,
-		 enum ip_conntrack_info ctinfo);
-void nfqnl_ct_seq_adjust(struct sk_buff *skb, struct nf_conn *ct,
-			 enum ip_conntrack_info ctinfo, int diff);
-int nfqnl_attach_expect(struct nf_conn *ct, const struct nlattr *attr,
-			u32 portid, u32 report);
-#else
-inline struct nf_conn *
-nfqnl_ct_get(struct sk_buff *entskb, size_t *size, enum ip_conntrack_info *ctinfo)
-{
-	return NULL;
-}
-
-inline struct nf_conn *nfqnl_ct_parse(const struct sk_buff *skb,
-				      const struct nlattr *attr,
-				      enum ip_conntrack_info *ctinfo)
-{
-	return NULL;
-}
-
-inline int
-nfqnl_ct_put(struct sk_buff *skb, struct nf_conn *ct, enum ip_conntrack_info ctinfo)
-{
-	return 0;
-}
-
-inline void nfqnl_ct_seq_adjust(struct sk_buff *skb, struct nf_conn *ct,
-				enum ip_conntrack_info ctinfo, int diff)
-{
-}
-
-inline int nfqnl_attach_expect(struct nf_conn *ct, const struct nlattr *attr,
-			       u32 portid, u32 report)
-{
-	return 0;
-}
-#endif /* NF_CONNTRACK */
-#endif
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 70d026d..4d68e72 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -11,7 +11,6 @@ obj-$(CONFIG_NETFILTER) = netfilter.o
 obj-$(CONFIG_NETFILTER_NETLINK) += nfnetlink.o
 obj-$(CONFIG_NETFILTER_NETLINK_ACCT) += nfnetlink_acct.o
 nfnetlink_queue-y := nfnetlink_queue_core.o
-nfnetlink_queue-$(CONFIG_NETFILTER_NETLINK_QUEUE_CT) += nfnetlink_queue_ct.o
 obj-$(CONFIG_NETFILTER_NETLINK_QUEUE) += nfnetlink_queue.o
 obj-$(CONFIG_NETFILTER_NETLINK_LOG) += nfnetlink_log.o
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 5fd3d48..a13c1c0 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2138,8 +2138,20 @@ ctnetlink_alloc_expect(const struct nlattr *const cda[], struct nf_conn *ct,
 		       struct nf_conntrack_tuple *mask);
 
 #ifdef CONFIG_NETFILTER_NETLINK_QUEUE_CT
+static struct nf_conn *ctnetlink_nfqueue_get_ct(struct sk_buff *skb,
+						enum ip_conntrack_info *ctinfo)
+{
+	struct nf_conn *ct;
+
+	ct = nf_ct_get(skb, ctinfo);
+	if (ct && nf_ct_is_untracked(ct))
+		ct = NULL;
+
+	return ct;
+}
+
 static int
-ctnetlink_nfqueue_build(struct sk_buff *skb, struct nf_conn *ct)
+__ctnetlink_nfqueue_build(struct sk_buff *skb, struct nf_conn *ct)
 {
 	const struct nf_conntrack_zone *zone;
 	struct nlattr *nest_parms;
@@ -2212,6 +2224,31 @@ nla_put_failure:
 }
 
 static int
+ctnetlink_nfqueue_build(struct sk_buff *skb, struct nf_conn *ct,
+			enum ip_conntrack_info ctinfo,
+			u_int16_t ct_attr, u_int16_t ct_info_attr)
+{
+	struct nlattr *nest_parms;
+
+	nest_parms = nla_nest_start(skb, ct_attr | NLA_F_NESTED);
+	if (!nest_parms)
+		goto nla_put_failure;
+
+	if (__ctnetlink_nfqueue_build(skb, ct) < 0)
+		goto nla_put_failure;
+
+	nla_nest_end(skb, nest_parms);
+
+	if (nla_put_be32(skb, ct_info_attr, htonl(ctinfo)))
+		goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	return -ENOSPC;
+}
+
+static int
 ctnetlink_nfqueue_parse_ct(const struct nlattr *cda[], struct nf_conn *ct)
 {
 	int err;
@@ -2326,12 +2363,22 @@ ctnetlink_nfqueue_attach_expect(const struct nlattr *attr, struct nf_conn *ct,
 	return 0;
 }
 
+static void ctnetlink_nfqueue_seqadj(struct sk_buff *skb, struct nf_conn *ct,
+				     enum ip_conntrack_info ctinfo, int diff)
+{
+	if (!(ct->status & IPS_NAT_MASK))
+		return;
+
+	nf_ct_tcp_seqadj_set(skb, ct, ctinfo, diff);
+}
+
 static struct nfq_ct_hook ctnetlink_nfqueue_hook = {
+	.get_ct		= ctnetlink_nfqueue_get_ct,
 	.build_size	= ctnetlink_nlmsg_payload_size,
 	.build		= ctnetlink_nfqueue_build,
 	.parse		= ctnetlink_nfqueue_parse,
 	.attach_expect	= ctnetlink_nfqueue_attach_expect,
-	.seq_adjust	= nf_ct_tcp_seqadj_set,
+	.seq_adjust	= ctnetlink_nfqueue_seqadj,
 };
 #endif /* CONFIG_NETFILTER_NETLINK_QUEUE_CT */
 
diff --git a/net/netfilter/nfnetlink_queue_core.c b/net/netfilter/nfnetlink_queue_core.c
index 685cc6a..801af4e 100644
--- a/net/netfilter/nfnetlink_queue_core.c
+++ b/net/netfilter/nfnetlink_queue_core.c
@@ -28,12 +28,12 @@
 #include <linux/netfilter_bridge.h>
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_queue.h>
+#include <linux/netfilter/nf_conntrack_common.h>
 #include <linux/list.h>
 #include <net/sock.h>
 #include <net/tcp_states.h>
 #include <net/netfilter/nf_queue.h>
 #include <net/netns/generic.h>
-#include <net/netfilter/nfnetlink_queue.h>
 
 #include <linux/atomic.h>
 
@@ -302,6 +302,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 {
 	size_t size;
 	size_t data_len = 0, cap_len = 0;
+	struct nfq_ct_hook *nfq_ct;
 	unsigned int hlen = 0;
 	struct sk_buff *skb;
 	struct nlattr *nla;
@@ -363,8 +364,14 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 		break;
 	}
 
-	if (queue->flags & NFQA_CFG_F_CONNTRACK)
-		ct = nfqnl_ct_get(entskb, &size, &ctinfo);
+	if (queue->flags & NFQA_CFG_F_CONNTRACK) {
+		nfq_ct = rcu_dereference(nfq_ct_hook);
+		if (nfq_ct != NULL) {
+			ct = nfq_ct->get_ct(entskb, &ctinfo);
+			if (ct != NULL)
+				size += nfq_ct->build_size(ct);
+		}
+	}
 
 	if (queue->flags & NFQA_CFG_F_UID_GID) {
 		size +=  (nla_total_size(sizeof(u_int32_t))	/* uid */
@@ -507,7 +514,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	if (seclen && nla_put(skb, NFQA_SECCTX, seclen, secdata))
 		goto nla_put_failure;
 
-	if (ct && nfqnl_ct_put(skb, ct, ctinfo) < 0)
+	if (ct && nfq_ct->build(skb, ct, ctinfo, NFQA_CT, NFQA_CT_INFO) < 0)
 		goto nla_put_failure;
 
 	if (cap_len > data_len &&
@@ -1001,6 +1008,28 @@ nfqnl_recv_verdict_batch(struct sock *ctnl, struct sk_buff *skb,
 	return 0;
 }
 
+static struct nf_conn *nfqnl_ct_parse(struct nfq_ct_hook *nfq_ct,
+				      const struct nlmsghdr *nlh,
+				      const struct nlattr * const nfqa[],
+				      struct nf_queue_entry *entry,
+				      enum ip_conntrack_info *ctinfo)
+{
+	struct nf_conn *ct;
+
+	ct = nfq_ct->get_ct(entry->skb, ctinfo);
+	if (ct == NULL)
+		return NULL;
+
+	if (nfq_ct->parse(nfqa[NFQA_CT], ct) < 0)
+		return NULL;
+
+	if (nfqa[NFQA_EXP])
+		nfq_ct->attach_expect(nfqa[NFQA_EXP], ct,
+				      NETLINK_CB(entry->skb).portid,
+				      nlmsg_report(nlh));
+	return ct;
+}
+
 static int
 nfqnl_recv_verdict(struct sock *ctnl, struct sk_buff *skb,
 		   const struct nlmsghdr *nlh,
@@ -1014,6 +1043,7 @@ nfqnl_recv_verdict(struct sock *ctnl, struct sk_buff *skb,
 	unsigned int verdict;
 	struct nf_queue_entry *entry;
 	enum ip_conntrack_info uninitialized_var(ctinfo);
+	struct nfq_ct_hook *nfq_ct;
 	struct nf_conn *ct = NULL;
 
 	struct net *net = sock_net(ctnl);
@@ -1037,12 +1067,10 @@ nfqnl_recv_verdict(struct sock *ctnl, struct sk_buff *skb,
 		return -ENOENT;
 
 	if (nfqa[NFQA_CT]) {
-		ct = nfqnl_ct_parse(entry->skb, nfqa[NFQA_CT], &ctinfo);
-		if (ct && nfqa[NFQA_EXP]) {
-			nfqnl_attach_expect(ct, nfqa[NFQA_EXP],
-					    NETLINK_CB(skb).portid,
-					    nlmsg_report(nlh));
-		}
+		/* rcu lock already held from nfnl->call_rcu. */
+		nfq_ct = rcu_dereference(nfq_ct_hook);
+		if (nfq_ct != NULL)
+			ct = nfqnl_ct_parse(nfq_ct, nlh, nfqa, entry, &ctinfo);
 	}
 
 	if (nfqa[NFQA_PAYLOAD]) {
@@ -1053,8 +1081,8 @@ nfqnl_recv_verdict(struct sock *ctnl, struct sk_buff *skb,
 				 payload_len, entry, diff) < 0)
 			verdict = NF_DROP;
 
-		if (ct)
-			nfqnl_ct_seq_adjust(entry->skb, ct, ctinfo, diff);
+		if (ct && diff)
+			nfq_ct->seq_adjust(entry->skb, ct, ctinfo, diff);
 	}
 
 	if (nfqa[NFQA_MARK])
diff --git a/net/netfilter/nfnetlink_queue_ct.c b/net/netfilter/nfnetlink_queue_ct.c
deleted file mode 100644
index 96cac50..0000000
--- a/net/netfilter/nfnetlink_queue_ct.c
+++ /dev/null
@@ -1,113 +0,0 @@
-/*
- * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- */
-
-#include <linux/skbuff.h>
-#include <linux/netfilter.h>
-#include <linux/netfilter/nfnetlink.h>
-#include <linux/netfilter/nfnetlink_queue.h>
-#include <net/netfilter/nf_conntrack.h>
-#include <net/netfilter/nfnetlink_queue.h>
-
-struct nf_conn *nfqnl_ct_get(struct sk_buff *entskb, size_t *size,
-			     enum ip_conntrack_info *ctinfo)
-{
-	struct nfq_ct_hook *nfq_ct;
-	struct nf_conn *ct;
-
-	/* rcu_read_lock()ed by __nf_queue already. */
-	nfq_ct = rcu_dereference(nfq_ct_hook);
-	if (nfq_ct == NULL)
-		return NULL;
-
-	ct = nf_ct_get(entskb, ctinfo);
-	if (ct) {
-		if (!nf_ct_is_untracked(ct))
-			*size += nfq_ct->build_size(ct);
-		else
-			ct = NULL;
-	}
-	return ct;
-}
-
-struct nf_conn *
-nfqnl_ct_parse(const struct sk_buff *skb, const struct nlattr *attr,
-	       enum ip_conntrack_info *ctinfo)
-{
-	struct nfq_ct_hook *nfq_ct;
-	struct nf_conn *ct;
-
-	/* rcu_read_lock()ed by __nf_queue already. */
-	nfq_ct = rcu_dereference(nfq_ct_hook);
-	if (nfq_ct == NULL)
-		return NULL;
-
-	ct = nf_ct_get(skb, ctinfo);
-	if (ct && !nf_ct_is_untracked(ct))
-		nfq_ct->parse(attr, ct);
-
-	return ct;
-}
-
-int nfqnl_ct_put(struct sk_buff *skb, struct nf_conn *ct,
-		 enum ip_conntrack_info ctinfo)
-{
-	struct nfq_ct_hook *nfq_ct;
-	struct nlattr *nest_parms;
-	u_int32_t tmp;
-
-	nfq_ct = rcu_dereference(nfq_ct_hook);
-	if (nfq_ct == NULL)
-		return 0;
-
-	nest_parms = nla_nest_start(skb, NFQA_CT | NLA_F_NESTED);
-	if (!nest_parms)
-		goto nla_put_failure;
-
-	if (nfq_ct->build(skb, ct) < 0)
-		goto nla_put_failure;
-
-	nla_nest_end(skb, nest_parms);
-
-	tmp = ctinfo;
-	if (nla_put_be32(skb, NFQA_CT_INFO, htonl(tmp)))
-		goto nla_put_failure;
-
-	return 0;
-
-nla_put_failure:
-	return -1;
-}
-
-void nfqnl_ct_seq_adjust(struct sk_buff *skb, struct nf_conn *ct,
-			 enum ip_conntrack_info ctinfo, int diff)
-{
-	struct nfq_ct_hook *nfq_ct;
-
-	nfq_ct = rcu_dereference(nfq_ct_hook);
-	if (nfq_ct == NULL)
-		return;
-
-	if ((ct->status & IPS_NAT_MASK) && diff)
-		nfq_ct->seq_adjust(skb, ct, ctinfo, diff);
-}
-
-int nfqnl_attach_expect(struct nf_conn *ct, const struct nlattr *attr,
-			u32 portid, u32 report)
-{
-	struct nfq_ct_hook *nfq_ct;
-
-	if (nf_ct_is_untracked(ct))
-		return 0;
-
-	nfq_ct = rcu_dereference(nfq_ct_hook);
-	if (nfq_ct == NULL)
-		return -EOPNOTSUPP;
-
-	return nfq_ct->attach_expect(attr, ct, portid, report);
-}
-- 
1.7.10.4

