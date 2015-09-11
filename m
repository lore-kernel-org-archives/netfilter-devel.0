From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH nf-next 1/3] netfilter: nfnetlink_queue: rename related to
 nfqueue attaching conntrack info
Date: Fri, 11 Sep 2015 12:07:48 +0900
Message-ID: <20150911030748.GB7380@gmail.com>
References: <1441731291-21342-1-git-send-email-pablo@netfilter.org>
 <20150909095042.GA11843@gmail.com>
 <20150910000615.GB5734@salvia>
 <20150911030530.GA7380@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34153 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbbIKDHx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Sep 2015 23:07:53 -0400
Received: by padhy16 with SMTP id hy16so61102964pad.1
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Sep 2015 20:07:53 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150911030530.GA7380@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The idea of this series of patch is to attach conntrack information to
nflog like nfqueue has already done. nfqueue conntrack info attaching
basis is generic, rename those names to generic one, glue.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 include/linux/netfilter.h            |    4 +--
 net/netfilter/core.c                 |    4 +--
 net/netfilter/nf_conntrack_netlink.c |   54 +++++++++++++++++-----------------
 net/netfilter/nfnetlink_queue.c      |   12 ++++----
 4 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 89bf246..6df59f0 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -379,7 +379,7 @@ struct nf_conn;
 enum ip_conntrack_info;
 struct nlattr;
 
-struct nfq_ct_hook {
+struct nfnl_ct_hook {
 	struct nf_conn *(*get_ct)(struct sk_buff *skb,
 				  enum ip_conntrack_info *ctinfo);
 	size_t (*build_size)(const struct nf_conn *ct);
@@ -392,7 +392,7 @@ struct nfq_ct_hook {
 	void (*seq_adjust)(struct sk_buff *skb, struct nf_conn *ct,
 			   enum ip_conntrack_info ctinfo, s32 off);
 };
-extern struct nfq_ct_hook __rcu *nfq_ct_hook;
+extern struct nfnl_ct_hook __rcu *nfnl_ct_hook;
 
 /**
  * nf_skb_duplicated - TEE target has sent a packet
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 0b939b7..83fb9e2 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -385,8 +385,8 @@ void nf_conntrack_destroy(struct nf_conntrack *nfct)
 }
 EXPORT_SYMBOL(nf_conntrack_destroy);
 
-struct nfq_ct_hook __rcu *nfq_ct_hook __read_mostly;
-EXPORT_SYMBOL_GPL(nfq_ct_hook);
+struct nfnl_ct_hook __rcu *nfnl_ct_hook __read_mostly;
+EXPORT_SYMBOL_GPL(nfnl_ct_hook);
 
 #endif /* CONFIG_NF_CONNTRACK */
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index ee7b544..d6a5514 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2139,8 +2139,8 @@ ctnetlink_alloc_expect(const struct nlattr *const cda[], struct nf_conn *ct,
 		       struct nf_conntrack_tuple *mask);
 
 #ifdef CONFIG_NETFILTER_NETLINK_QUEUE_CT
-static struct nf_conn *ctnetlink_nfqueue_get_ct(struct sk_buff *skb,
-						enum ip_conntrack_info *ctinfo)
+static struct nf_conn *ctnetlink_glue_get_ct(struct sk_buff *skb,
+					     enum ip_conntrack_info *ctinfo)
 {
 	struct nf_conn *ct;
 
@@ -2152,7 +2152,7 @@ static struct nf_conn *ctnetlink_nfqueue_get_ct(struct sk_buff *skb,
 }
 
 static int
-__ctnetlink_nfqueue_build(struct sk_buff *skb, struct nf_conn *ct)
+__ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct)
 {
 	const struct nf_conntrack_zone *zone;
 	struct nlattr *nest_parms;
@@ -2225,9 +2225,9 @@ nla_put_failure:
 }
 
 static int
-ctnetlink_nfqueue_build(struct sk_buff *skb, struct nf_conn *ct,
-			enum ip_conntrack_info ctinfo,
-			u_int16_t ct_attr, u_int16_t ct_info_attr)
+ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct,
+		     enum ip_conntrack_info ctinfo,
+		     u_int16_t ct_attr, u_int16_t ct_info_attr)
 {
 	struct nlattr *nest_parms;
 
@@ -2235,7 +2235,7 @@ ctnetlink_nfqueue_build(struct sk_buff *skb, struct nf_conn *ct,
 	if (!nest_parms)
 		goto nla_put_failure;
 
-	if (__ctnetlink_nfqueue_build(skb, ct) < 0)
+	if (__ctnetlink_glue_build(skb, ct) < 0)
 		goto nla_put_failure;
 
 	nla_nest_end(skb, nest_parms);
@@ -2250,7 +2250,7 @@ nla_put_failure:
 }
 
 static int
-ctnetlink_nfqueue_parse_ct(const struct nlattr *cda[], struct nf_conn *ct)
+ctnetlink_glue_parse_ct(const struct nlattr *cda[], struct nf_conn *ct)
 {
 	int err;
 
@@ -2290,7 +2290,7 @@ ctnetlink_nfqueue_parse_ct(const struct nlattr *cda[], struct nf_conn *ct)
 }
 
 static int
-ctnetlink_nfqueue_parse(const struct nlattr *attr, struct nf_conn *ct)
+ctnetlink_glue_parse(const struct nlattr *attr, struct nf_conn *ct)
 {
 	struct nlattr *cda[CTA_MAX+1];
 	int ret;
@@ -2300,16 +2300,16 @@ ctnetlink_nfqueue_parse(const struct nlattr *attr, struct nf_conn *ct)
 		return ret;
 
 	spin_lock_bh(&nf_conntrack_expect_lock);
-	ret = ctnetlink_nfqueue_parse_ct((const struct nlattr **)cda, ct);
+	ret = ctnetlink_glue_parse_ct((const struct nlattr **)cda, ct);
 	spin_unlock_bh(&nf_conntrack_expect_lock);
 
 	return ret;
 }
 
-static int ctnetlink_nfqueue_exp_parse(const struct nlattr * const *cda,
-				       const struct nf_conn *ct,
-				       struct nf_conntrack_tuple *tuple,
-				       struct nf_conntrack_tuple *mask)
+static int ctnetlink_glue_exp_parse(const struct nlattr * const *cda,
+				    const struct nf_conn *ct,
+				    struct nf_conntrack_tuple *tuple,
+				    struct nf_conntrack_tuple *mask)
 {
 	int err;
 
@@ -2323,8 +2323,8 @@ static int ctnetlink_nfqueue_exp_parse(const struct nlattr * const *cda,
 }
 
 static int
-ctnetlink_nfqueue_attach_expect(const struct nlattr *attr, struct nf_conn *ct,
-				u32 portid, u32 report)
+ctnetlink_glue_attach_expect(const struct nlattr *attr, struct nf_conn *ct,
+			     u32 portid, u32 report)
 {
 	struct nlattr *cda[CTA_EXPECT_MAX+1];
 	struct nf_conntrack_tuple tuple, mask;
@@ -2336,7 +2336,7 @@ ctnetlink_nfqueue_attach_expect(const struct nlattr *attr, struct nf_conn *ct,
 	if (err < 0)
 		return err;
 
-	err = ctnetlink_nfqueue_exp_parse((const struct nlattr * const *)cda,
+	err = ctnetlink_glue_exp_parse((const struct nlattr * const *)cda,
 					  ct, &tuple, &mask);
 	if (err < 0)
 		return err;
@@ -2364,8 +2364,8 @@ ctnetlink_nfqueue_attach_expect(const struct nlattr *attr, struct nf_conn *ct,
 	return 0;
 }
 
-static void ctnetlink_nfqueue_seqadj(struct sk_buff *skb, struct nf_conn *ct,
-				     enum ip_conntrack_info ctinfo, int diff)
+static void ctnetlink_glue_seqadj(struct sk_buff *skb, struct nf_conn *ct,
+				  enum ip_conntrack_info ctinfo, int diff)
 {
 	if (!(ct->status & IPS_NAT_MASK))
 		return;
@@ -2373,14 +2373,14 @@ static void ctnetlink_nfqueue_seqadj(struct sk_buff *skb, struct nf_conn *ct,
 	nf_ct_tcp_seqadj_set(skb, ct, ctinfo, diff);
 }
 
-static struct nfq_ct_hook ctnetlink_nfqueue_hook = {
-	.get_ct		= ctnetlink_nfqueue_get_ct,
+static struct nfnl_ct_hook ctnetlink_glue_hook = {
+	.get_ct		= ctnetlink_glue_get_ct,
 	/* extra size - acct and use */
 	.build_size	= ctnetlink_nlmsg_payload_size,
-	.build		= ctnetlink_nfqueue_build,
-	.parse		= ctnetlink_nfqueue_parse,
-	.attach_expect	= ctnetlink_nfqueue_attach_expect,
-	.seq_adjust	= ctnetlink_nfqueue_seqadj,
+	.build		= ctnetlink_glue_build,
+	.parse		= ctnetlink_glue_parse,
+	.attach_expect	= ctnetlink_glue_attach_expect,
+	.seq_adjust	= ctnetlink_glue_seqadj,
 };
 #endif /* CONFIG_NETFILTER_NETLINK_QUEUE_CT */
 
@@ -3368,7 +3368,7 @@ static int __init ctnetlink_init(void)
 	}
 #ifdef CONFIG_NETFILTER_NETLINK_QUEUE_CT
 	/* setup interaction between nf_queue and nf_conntrack_netlink. */
-	RCU_INIT_POINTER(nfq_ct_hook, &ctnetlink_nfqueue_hook);
+	RCU_INIT_POINTER(nfnl_ct_hook, &ctnetlink_glue_hook);
 #endif
 	return 0;
 
@@ -3388,7 +3388,7 @@ static void __exit ctnetlink_exit(void)
 	nfnetlink_subsys_unregister(&ctnl_exp_subsys);
 	nfnetlink_subsys_unregister(&ctnl_subsys);
 #ifdef CONFIG_NETFILTER_NETLINK_QUEUE_CT
-	RCU_INIT_POINTER(nfq_ct_hook, NULL);
+	RCU_INIT_POINTER(nfnl_ct_hook, NULL);
 #endif
 }
 
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 40982c7..3e3a577 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -302,7 +302,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 {
 	size_t size;
 	size_t data_len = 0, cap_len = 0;
-	struct nfq_ct_hook *nfq_ct;
+	struct nfnl_ct_hook *nfq_ct;
 	unsigned int hlen = 0;
 	struct sk_buff *skb;
 	struct nlattr *nla;
@@ -365,7 +365,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	}
 
 	if (queue->flags & NFQA_CFG_F_CONNTRACK) {
-		nfq_ct = rcu_dereference(nfq_ct_hook);
+		nfq_ct = rcu_dereference(nfnl_ct_hook);
 		if (nfq_ct != NULL) {
 			ct = nfq_ct->get_ct(entskb, &ctinfo);
 			if (ct != NULL)
@@ -1008,7 +1008,7 @@ nfqnl_recv_verdict_batch(struct sock *ctnl, struct sk_buff *skb,
 	return 0;
 }
 
-static struct nf_conn *nfqnl_ct_parse(struct nfq_ct_hook *nfq_ct,
+static struct nf_conn *nfqnl_ct_parse(struct nfnl_ct_hook *nfq_ct,
 				      const struct nlmsghdr *nlh,
 				      const struct nlattr * const nfqa[],
 				      struct nf_queue_entry *entry,
@@ -1043,7 +1043,7 @@ nfqnl_recv_verdict(struct sock *ctnl, struct sk_buff *skb,
 	unsigned int verdict;
 	struct nf_queue_entry *entry;
 	enum ip_conntrack_info uninitialized_var(ctinfo);
-	struct nfq_ct_hook *nfq_ct;
+	struct nfnl_ct_hook *nfq_ct;
 	struct nf_conn *ct = NULL;
 
 	struct net *net = sock_net(ctnl);
@@ -1068,7 +1068,7 @@ nfqnl_recv_verdict(struct sock *ctnl, struct sk_buff *skb,
 
 	if (nfqa[NFQA_CT]) {
 		/* rcu lock already held from nfnl->call_rcu. */
-		nfq_ct = rcu_dereference(nfq_ct_hook);
+		nfq_ct = rcu_dereference(nfnl_ct_hook);
 		if (nfq_ct != NULL)
 			ct = nfqnl_ct_parse(nfq_ct, nlh, nfqa, entry, &ctinfo);
 	}
@@ -1225,7 +1225,7 @@ nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 		}
 #endif
 		if (flags & mask & NFQA_CFG_F_CONNTRACK &&
-		    rcu_dereference(nfq_ct_hook) == NULL) {
+		    rcu_dereference(nfnl_ct_hook) == NULL) {
 			ret = -EOPNOTSUPP;
 			goto err_out_unlock;
 		}
-- 
1.7.10.4

