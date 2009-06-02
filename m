From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/7] netfilter: ctnetlink: cleanup message building and size
	calculation
Date: Tue, 02 Jun 2009 13:52:35 +0200
Message-ID: <20090602115235.7677.91307.stgit@Decadence>
References: <20090602114933.7677.25219.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53815 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbZFBMcb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2009 08:32:31 -0400
In-Reply-To: <20090602114933.7677.25219.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch is a cleanup. It removes unneeded verbose information
about the size calculation and it also replaces the old macros
to build Netlink messages with the new nlmsg_*() helper functions.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 include/net/netfilter/nf_conntrack.h |    6 +
 net/netfilter/nf_conntrack_netlink.c |  192 +++++++++++++++-------------------
 2 files changed, 91 insertions(+), 107 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 6c3f964..9aafe70 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -144,6 +144,12 @@ static inline u_int8_t nf_ct_protonum(const struct nf_conn *ct)
 	return ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum;
 }
 
+static inline const struct nf_conntrack_tuple *
+nf_ct_tuple(const struct nf_conn *ct, enum ip_conntrack_dir dir)
+{
+	return &ct->tuplehash[dir].tuple;
+}
+
 /* get master conntrack via master expectation */
 #define master_ct(conntr) (conntr->master)
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 2d7d69f..6931026 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -4,7 +4,7 @@
  * (C) 2001 by Jay Schulist <jschlst@samba.org>
  * (C) 2002-2006 by Harald Welte <laforge@gnumonks.org>
  * (C) 2003 by Patrick Mchardy <kaber@trash.net>
- * (C) 2005-2008 by Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2005-2009 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
  * Initial connection tracking via netlink development funded and
  * generally made possible by Network Robots, Inc. (www.networkrobots.com)
@@ -346,7 +346,6 @@ nla_put_failure:
 	return -1;
 }
 
-#define tuple(ct, dir) (&(ct)->tuplehash[dir].tuple)
 
 static int
 ctnetlink_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
@@ -355,13 +354,14 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
 	struct nlattr *nest_parms;
-	unsigned char *b = skb_tail_pointer(skb);
+	unsigned int flags = pid ? NLM_F_MULTI : 0;
 
 	event |= NFNL_SUBSYS_CTNETLINK << 8;
-	nlh    = NLMSG_PUT(skb, pid, seq, event, sizeof(struct nfgenmsg));
-	nfmsg  = NLMSG_DATA(nlh);
+	nlh = nlmsg_put(skb, pid, seq, event, sizeof(*nfmsg), flags);
+	if (nlh == NULL)
+		goto nlmsg_failure;
 
-	nlh->nlmsg_flags    = pid ? NLM_F_MULTI : 0;
+	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family = nf_ct_l3num(ct);
 	nfmsg->version      = NFNETLINK_V0;
 	nfmsg->res_id	    = 0;
@@ -369,14 +369,14 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
 	nest_parms = nla_nest_start(skb, CTA_TUPLE_ORIG | NLA_F_NESTED);
 	if (!nest_parms)
 		goto nla_put_failure;
-	if (ctnetlink_dump_tuples(skb, tuple(ct, IP_CT_DIR_ORIGINAL)) < 0)
+	if (ctnetlink_dump_tuples(skb, nf_ct_tuple(ct, IP_CT_DIR_ORIGINAL)) < 0)
 		goto nla_put_failure;
 	nla_nest_end(skb, nest_parms);
 
 	nest_parms = nla_nest_start(skb, CTA_TUPLE_REPLY | NLA_F_NESTED);
 	if (!nest_parms)
 		goto nla_put_failure;
-	if (ctnetlink_dump_tuples(skb, tuple(ct, IP_CT_DIR_REPLY)) < 0)
+	if (ctnetlink_dump_tuples(skb, nf_ct_tuple(ct, IP_CT_DIR_REPLY)) < 0)
 		goto nla_put_failure;
 	nla_nest_end(skb, nest_parms);
 
@@ -394,86 +394,65 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
 	    ctnetlink_dump_nat_seq_adj(skb, ct) < 0)
 		goto nla_put_failure;
 
-	nlh->nlmsg_len = skb_tail_pointer(skb) - b;
+	nlmsg_end(skb, nlh);
 	return skb->len;
 
 nlmsg_failure:
 nla_put_failure:
-	nlmsg_trim(skb, b);
+	nlmsg_cancel(skb, nlh);
 	return -1;
 }
 
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
-/*
- * The general structure of a ctnetlink event is
- *
- *  CTA_TUPLE_ORIG
- *    <l3/l4-proto-attributes>
- *  CTA_TUPLE_REPLY
- *    <l3/l4-proto-attributes>
- *  CTA_ID
- *  ...
- *  CTA_PROTOINFO
- *    <l4-proto-attributes>
- *  CTA_TUPLE_MASTER
- *    <l3/l4-proto-attributes>
- *
- * Therefore the formular is
- *
- *   size = sizeof(headers) + sizeof(generic_nlas) + 3 * sizeof(tuple_nlas)
- *		+ sizeof(protoinfo_nlas)
- */
-static struct sk_buff *
-ctnetlink_alloc_skb(const struct nf_conntrack_tuple *tuple, gfp_t gfp)
+static inline size_t
+ctnetlink_proto_size(const struct nf_conn *ct)
 {
 	struct nf_conntrack_l3proto *l3proto;
 	struct nf_conntrack_l4proto *l4proto;
-	int len;
-
-#define NLA_TYPE_SIZE(type)		nla_total_size(sizeof(type))
-
-	/* proto independant part */
-	len = NLMSG_SPACE(sizeof(struct nfgenmsg))
-		+ 3 * nla_total_size(0)		/* CTA_TUPLE_ORIG|REPL|MASTER */
-		+ 3 * nla_total_size(0)		/* CTA_TUPLE_IP */
-		+ 3 * nla_total_size(0)		/* CTA_TUPLE_PROTO */
-		+ 3 * NLA_TYPE_SIZE(u_int8_t)	/* CTA_PROTO_NUM */
-		+ NLA_TYPE_SIZE(u_int32_t)	/* CTA_ID */
-		+ NLA_TYPE_SIZE(u_int32_t)	/* CTA_STATUS */
+	size_t len = 0;
+
+	rcu_read_lock();
+	l3proto = __nf_ct_l3proto_find(nf_ct_l3num(ct));
+	len += l3proto->nla_size;
+
+	l4proto = __nf_ct_l4proto_find(nf_ct_l3num(ct), nf_ct_protonum(ct));
+	len += l4proto->nla_size;
+	rcu_read_unlock();
+
+	return len;
+}
+
+static inline size_t
+ctnetlink_nlmsg_size(const struct nf_conn *ct)
+{
+	return NLMSG_ALIGN(sizeof(struct nfgenmsg))
+	       + 3 * nla_total_size(0) /* CTA_TUPLE_ORIG|REPL|MASTER */
+	       + 3 * nla_total_size(0) /* CTA_TUPLE_IP */
+	       + 3 * nla_total_size(0) /* CTA_TUPLE_PROTO */
+	       + 3 * nla_total_size(sizeof(u_int8_t)) /* CTA_PROTO_NUM */
+	       + nla_total_size(sizeof(u_int32_t)) /* CTA_ID */
+	       + nla_total_size(sizeof(u_int32_t)) /* CTA_STATUS */
 #ifdef CONFIG_NF_CT_ACCT
-		+ 2 * nla_total_size(0)		/* CTA_COUNTERS_ORIG|REPL */
-		+ 2 * NLA_TYPE_SIZE(uint64_t)	/* CTA_COUNTERS_PACKETS */
-		+ 2 * NLA_TYPE_SIZE(uint64_t)	/* CTA_COUNTERS_BYTES */
+	       + 2 * nla_total_size(0) /* CTA_COUNTERS_ORIG|REPL */
+	       + 2 * nla_total_size(sizeof(uint64_t)) /* CTA_COUNTERS_PACKETS */
+	       + 2 * nla_total_size(sizeof(uint64_t)) /* CTA_COUNTERS_BYTES */
 #endif
-		+ NLA_TYPE_SIZE(u_int32_t)	/* CTA_TIMEOUT */
-		+ nla_total_size(0)		/* CTA_PROTOINFO */
-		+ nla_total_size(0)		/* CTA_HELP */
-		+ nla_total_size(NF_CT_HELPER_NAME_LEN)	/* CTA_HELP_NAME */
+	       + nla_total_size(sizeof(u_int32_t)) /* CTA_TIMEOUT */
+	       + nla_total_size(0) /* CTA_PROTOINFO */
+	       + nla_total_size(0) /* CTA_HELP */
+	       + nla_total_size(NF_CT_HELPER_NAME_LEN) /* CTA_HELP_NAME */
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
-		+ NLA_TYPE_SIZE(u_int32_t)	/* CTA_SECMARK */
+	       + nla_total_size(sizeof(u_int32_t)) /* CTA_SECMARK */
 #endif
 #ifdef CONFIG_NF_NAT_NEEDED
-		+ 2 * nla_total_size(0)		/* CTA_NAT_SEQ_ADJ_ORIG|REPL */
-		+ 2 * NLA_TYPE_SIZE(u_int32_t)	/* CTA_NAT_SEQ_CORRECTION_POS */
-		+ 2 * NLA_TYPE_SIZE(u_int32_t)	/* CTA_NAT_SEQ_CORRECTION_BEFORE */
-		+ 2 * NLA_TYPE_SIZE(u_int32_t)	/* CTA_NAT_SEQ_CORRECTION_AFTER */
+	       + 2 * nla_total_size(0) /* CTA_NAT_SEQ_ADJ_ORIG|REPL */
+	       + 6 * nla_total_size(sizeof(u_int32_t)) /* CTA_NAT_SEQ_OFFSET */
 #endif
 #ifdef CONFIG_NF_CONNTRACK_MARK
-		+ NLA_TYPE_SIZE(u_int32_t)	/* CTA_MARK */
+	       + nla_total_size(sizeof(u_int32_t)) /* CTA_MARK */
 #endif
-		;
-
-#undef NLA_TYPE_SIZE
-
-	rcu_read_lock();
-	l3proto = __nf_ct_l3proto_find(tuple->src.l3num);
-	len += l3proto->nla_size;
-
-	l4proto = __nf_ct_l4proto_find(tuple->src.l3num, tuple->dst.protonum);
-	len += l4proto->nla_size;
-	rcu_read_unlock();
-
-	return alloc_skb(len, gfp);
+	       + ctnetlink_proto_size(ct);
+	       ;
 }
 
 static int ctnetlink_conntrack_event(struct notifier_block *this,
@@ -486,7 +465,6 @@ static int ctnetlink_conntrack_event(struct notifier_block *this,
 	struct nf_conn *ct = item->ct;
 	struct sk_buff *skb;
 	unsigned int type;
-	sk_buff_data_t b;
 	unsigned int flags = 0, group;
 
 	/* ignore our fake conntrack entry */
@@ -509,17 +487,16 @@ static int ctnetlink_conntrack_event(struct notifier_block *this,
 	if (!item->report && !nfnetlink_has_listeners(group))
 		return NOTIFY_DONE;
 
-	skb = ctnetlink_alloc_skb(tuple(ct, IP_CT_DIR_ORIGINAL), GFP_ATOMIC);
-	if (!skb)
+	skb = nlmsg_new(ctnetlink_nlmsg_size(ct), GFP_ATOMIC);
+	if (skb == NULL)
 		goto errout;
 
-	b = skb->tail;
-
 	type |= NFNL_SUBSYS_CTNETLINK << 8;
-	nlh   = NLMSG_PUT(skb, item->pid, 0, type, sizeof(struct nfgenmsg));
-	nfmsg = NLMSG_DATA(nlh);
+	nlh = nlmsg_put(skb, item->pid, 0, type, sizeof(*nfmsg), flags);
+	if (nlh == NULL)
+		goto nlmsg_failure;
 
-	nlh->nlmsg_flags    = flags;
+	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family = nf_ct_l3num(ct);
 	nfmsg->version	= NFNETLINK_V0;
 	nfmsg->res_id	= 0;
@@ -528,14 +505,14 @@ static int ctnetlink_conntrack_event(struct notifier_block *this,
 	nest_parms = nla_nest_start(skb, CTA_TUPLE_ORIG | NLA_F_NESTED);
 	if (!nest_parms)
 		goto nla_put_failure;
-	if (ctnetlink_dump_tuples(skb, tuple(ct, IP_CT_DIR_ORIGINAL)) < 0)
+	if (ctnetlink_dump_tuples(skb, nf_ct_tuple(ct, IP_CT_DIR_ORIGINAL)) < 0)
 		goto nla_put_failure;
 	nla_nest_end(skb, nest_parms);
 
 	nest_parms = nla_nest_start(skb, CTA_TUPLE_REPLY | NLA_F_NESTED);
 	if (!nest_parms)
 		goto nla_put_failure;
-	if (ctnetlink_dump_tuples(skb, tuple(ct, IP_CT_DIR_REPLY)) < 0)
+	if (ctnetlink_dump_tuples(skb, nf_ct_tuple(ct, IP_CT_DIR_REPLY)) < 0)
 		goto nla_put_failure;
 	nla_nest_end(skb, nest_parms);
 
@@ -583,12 +560,13 @@ static int ctnetlink_conntrack_event(struct notifier_block *this,
 #endif
 	rcu_read_unlock();
 
-	nlh->nlmsg_len = skb->tail - b;
+	nlmsg_end(skb, nlh);
 	nfnetlink_send(skb, item->pid, group, item->report);
 	return NOTIFY_DONE;
 
 nla_put_failure:
 	rcu_read_unlock();
+	nlmsg_cancel(skb, nlh);
 nlmsg_failure:
 	kfree_skb(skb);
 errout:
@@ -610,7 +588,7 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 	struct nf_conn *ct, *last;
 	struct nf_conntrack_tuple_hash *h;
 	struct hlist_nulls_node *n;
-	struct nfgenmsg *nfmsg = NLMSG_DATA(cb->nlh);
+	struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
 	u_int8_t l3proto = nfmsg->nfgen_family;
 
 	rcu_read_lock();
@@ -790,7 +768,7 @@ ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conntrack_tuple tuple;
 	struct nf_conn *ct;
-	struct nfgenmsg *nfmsg = NLMSG_DATA(nlh);
+	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	u_int8_t u3 = nfmsg->nfgen_family;
 	int err = 0;
 
@@ -845,7 +823,7 @@ ctnetlink_get_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	struct nf_conntrack_tuple tuple;
 	struct nf_conn *ct;
 	struct sk_buff *skb2 = NULL;
-	struct nfgenmsg *nfmsg = NLMSG_DATA(nlh);
+	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	u_int8_t u3 = nfmsg->nfgen_family;
 	int err = 0;
 
@@ -870,8 +848,8 @@ ctnetlink_get_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	ct = nf_ct_tuplehash_to_ctrack(h);
 
 	err = -ENOMEM;
-	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
-	if (!skb2) {
+	skb2 = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (skb2 == NULL) {
 		nf_ct_put(ct);
 		return -ENOMEM;
 	}
@@ -1323,7 +1301,7 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 {
 	struct nf_conntrack_tuple otuple, rtuple;
 	struct nf_conntrack_tuple_hash *h = NULL;
-	struct nfgenmsg *nfmsg = NLMSG_DATA(nlh);
+	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	u_int8_t u3 = nfmsg->nfgen_family;
 	int err = 0;
 
@@ -1505,13 +1483,14 @@ ctnetlink_exp_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
 {
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
-	unsigned char *b = skb_tail_pointer(skb);
+	unsigned int flags = pid ? NLM_F_MULTI : 0;
 
 	event |= NFNL_SUBSYS_CTNETLINK_EXP << 8;
-	nlh    = NLMSG_PUT(skb, pid, seq, event, sizeof(struct nfgenmsg));
-	nfmsg  = NLMSG_DATA(nlh);
+	nlh = nlmsg_put(skb, pid, seq, event, sizeof(*nfmsg), flags);
+	if (nlh == NULL)
+		goto nlmsg_failure;
 
-	nlh->nlmsg_flags    = pid ? NLM_F_MULTI : 0;
+	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family = exp->tuple.src.l3num;
 	nfmsg->version	    = NFNETLINK_V0;
 	nfmsg->res_id	    = 0;
@@ -1519,12 +1498,12 @@ ctnetlink_exp_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
 	if (ctnetlink_exp_dump_expect(skb, exp) < 0)
 		goto nla_put_failure;
 
-	nlh->nlmsg_len = skb_tail_pointer(skb) - b;
+	nlmsg_end(skb, nlh);
 	return skb->len;
 
 nlmsg_failure:
 nla_put_failure:
-	nlmsg_trim(skb, b);
+	nlmsg_cancel(skb, nlh);
 	return -1;
 }
 
@@ -1538,7 +1517,6 @@ static int ctnetlink_expect_event(struct notifier_block *this,
 	struct nf_conntrack_expect *exp = item->exp;
 	struct sk_buff *skb;
 	unsigned int type;
-	sk_buff_data_t b;
 	int flags = 0;
 
 	if (events & IPEXP_NEW) {
@@ -1551,17 +1529,16 @@ static int ctnetlink_expect_event(struct notifier_block *this,
 	    !nfnetlink_has_listeners(NFNLGRP_CONNTRACK_EXP_NEW))
 		return NOTIFY_DONE;
 
-	skb = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
-	if (!skb)
+	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+	if (skb == NULL)
 		goto errout;
 
-	b = skb->tail;
-
 	type |= NFNL_SUBSYS_CTNETLINK_EXP << 8;
-	nlh   = NLMSG_PUT(skb, item->pid, 0, type, sizeof(struct nfgenmsg));
-	nfmsg = NLMSG_DATA(nlh);
+	nlh = nlmsg_put(skb, item->pid, 0, type, sizeof(*nfmsg), flags);
+	if (nlh == NULL)
+		goto nlmsg_failure;
 
-	nlh->nlmsg_flags    = flags;
+	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family = exp->tuple.src.l3num;
 	nfmsg->version	    = NFNETLINK_V0;
 	nfmsg->res_id	    = 0;
@@ -1571,12 +1548,13 @@ static int ctnetlink_expect_event(struct notifier_block *this,
 		goto nla_put_failure;
 	rcu_read_unlock();
 
-	nlh->nlmsg_len = skb->tail - b;
+	nlmsg_end(skb, nlh);
 	nfnetlink_send(skb, item->pid, NFNLGRP_CONNTRACK_EXP_NEW, item->report);
 	return NOTIFY_DONE;
 
 nla_put_failure:
 	rcu_read_unlock();
+	nlmsg_cancel(skb, nlh);
 nlmsg_failure:
 	kfree_skb(skb);
 errout:
@@ -1596,7 +1574,7 @@ ctnetlink_exp_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct net *net = &init_net;
 	struct nf_conntrack_expect *exp, *last;
-	struct nfgenmsg *nfmsg = NLMSG_DATA(cb->nlh);
+	struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
 	struct hlist_node *n;
 	u_int8_t l3proto = nfmsg->nfgen_family;
 
@@ -1649,7 +1627,7 @@ ctnetlink_get_expect(struct sock *ctnl, struct sk_buff *skb,
 	struct nf_conntrack_tuple tuple;
 	struct nf_conntrack_expect *exp;
 	struct sk_buff *skb2;
-	struct nfgenmsg *nfmsg = NLMSG_DATA(nlh);
+	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	u_int8_t u3 = nfmsg->nfgen_family;
 	int err = 0;
 
@@ -1680,8 +1658,8 @@ ctnetlink_get_expect(struct sock *ctnl, struct sk_buff *skb,
 	}
 
 	err = -ENOMEM;
-	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
-	if (!skb2)
+	skb2 = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (skb2 == NULL)
 		goto out;
 
 	rcu_read_lock();
@@ -1709,7 +1687,7 @@ ctnetlink_del_expect(struct sock *ctnl, struct sk_buff *skb,
 	struct nf_conntrack_expect *exp;
 	struct nf_conntrack_tuple tuple;
 	struct nf_conntrack_helper *h;
-	struct nfgenmsg *nfmsg = NLMSG_DATA(nlh);
+	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	struct hlist_node *n, *next;
 	u_int8_t u3 = nfmsg->nfgen_family;
 	unsigned int i;
@@ -1850,7 +1828,7 @@ ctnetlink_new_expect(struct sock *ctnl, struct sk_buff *skb,
 {
 	struct nf_conntrack_tuple tuple;
 	struct nf_conntrack_expect *exp;
-	struct nfgenmsg *nfmsg = NLMSG_DATA(nlh);
+	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	u_int8_t u3 = nfmsg->nfgen_family;
 	int err = 0;
 

