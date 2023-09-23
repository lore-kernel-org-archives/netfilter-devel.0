Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A66ECE7A81
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Sep 2023 01:38:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjIWBiW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Sep 2023 21:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjIWBiV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Sep 2023 21:38:21 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6F54F1
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Sep 2023 18:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=28+B2Fzg+l17g5rPixYKnxdNpmTyQ4uwa4b2nEkvXlw=; b=ZQ+XNqT/Cnc6yp/Bmdp6JGNbwW
        XEc1Zubf6QytYyl0NV0V3uZyGDIrUPmp+kTrjcwedhpZJxF1LKV0GP4cuCvcp2izUG22yL3WtkrZT
        og8Bo8RRf31/zTHXwwVu4hjXgr7XQGoA7B4q0qeY1pJKCZzKi63oQKv/VQhsC7bp+L+nGyFgvXSTv
        bdYsbsMCoVMKkXhTzHV/qJm1ZYzgnfPDjkMxvow8zDbndx4ezGd6nFvAIZRXe4XEDVAWiVIS5ge7W
        UnK8kVu/Samx+UviiLh22eWmVYOBiTlSLB4up7m7jvyL2jg8gzx04QFW/kZf1d1EFLfGCTM1s7GAm
        wKV22/dQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qjrb1-0001w1-QC; Sat, 23 Sep 2023 03:38:11 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [nf PATCH 2/5] netfilter: nf_tables: Add locking for NFT_MSG_GETRULE_RESET requests
Date:   Sat, 23 Sep 2023 03:38:04 +0200
Message-ID: <20230923013807.11398-3-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230923013807.11398-1-phil@nwl.cc>
References: <20230923013807.11398-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Rule reset is not protected by the commit mutex, so multiple reset
requests could run for the same data. Expressions' dump'n'reset routines
are not concurrency-safe, though. With nft_counter for instance, if
nft_counter_do_dump() runs twice at the same time, the old value may be
subtracted twice and thus the value underruns.

Solve this via introduction of a reset spinlock which ensures exclusive
access. To avoid conditional lock/unlock calls, introduce a dedicated
callback for nfnetlink, and for the asynchronous netlink dump (which by
itself must run unlocked).

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/net/netfilter/nf_tables.h |   1 +
 net/netfilter/nf_tables_api.c     | 138 ++++++++++++++++++++++--------
 2 files changed, 104 insertions(+), 35 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 7c816359d5a98..bd6849f4c46e3 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1732,6 +1732,7 @@ struct nftables_pernet {
 	struct list_head	module_list;
 	struct list_head	notify_list;
 	struct mutex		commit_mutex;
+	spinlock_t		reset_lock;
 	u64			table_handle;
 	unsigned int		base_seq;
 	unsigned int		gc_seq;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 511508407867d..4bccd15a67105 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3552,6 +3552,19 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 	return skb->len;
 }
 
+static int nf_tables_dumpreset_rules(struct sk_buff *skb,
+				     struct netlink_callback *cb)
+{
+	struct nftables_pernet *nft_net = nft_pernet(sock_net(skb->sk));
+	int ret;
+
+	spin_lock(&nft_net->reset_lock);
+	ret = nf_tables_dump_rules(skb, cb);
+	spin_unlock(&nft_net->reset_lock);
+
+	return ret;
+}
+
 static int nf_tables_dump_rules_start(struct netlink_callback *cb)
 {
 	struct nft_rule_dump_ctx *ctx = (void *)cb->ctx;
@@ -3571,12 +3584,18 @@ static int nf_tables_dump_rules_start(struct netlink_callback *cb)
 			return -ENOMEM;
 		}
 	}
-	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETRULE_RESET)
-		ctx->reset = true;
-
 	return 0;
 }
 
+static int nf_tables_dumpreset_rules_start(struct netlink_callback *cb)
+{
+	struct nft_rule_dump_ctx *ctx = (void *)cb->ctx;
+
+	ctx->reset = true;
+
+	return nf_tables_dump_rules_start(cb);
+}
+
 static int nf_tables_dump_rules_done(struct netlink_callback *cb)
 {
 	struct nft_rule_dump_ctx *ctx = (void *)cb->ctx;
@@ -3587,8 +3606,9 @@ static int nf_tables_dump_rules_done(struct netlink_callback *cb)
 }
 
 /* called with rcu_read_lock held */
-static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
-			     const struct nlattr * const nla[])
+static struct sk_buff *
+nf_tables_getrule_single(u32 portid, const struct nfnl_info *info,
+			 const struct nlattr * const nla[], bool reset)
 {
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_cur(info->net);
@@ -3598,60 +3618,107 @@ static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
 	struct net *net = info->net;
 	struct nft_table *table;
 	struct sk_buff *skb2;
-	bool reset = false;
 	int err;
 
-	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
-		struct netlink_dump_control c = {
-			.start= nf_tables_dump_rules_start,
-			.dump = nf_tables_dump_rules,
-			.done = nf_tables_dump_rules_done,
-			.module = THIS_MODULE,
-			.data = (void *)nla,
-		};
-
-		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
-	}
-
 	table = nft_table_lookup(net, nla[NFTA_RULE_TABLE], family, genmask, 0);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_TABLE]);
-		return PTR_ERR(table);
+		return ERR_CAST(table);
 	}
 
 	chain = nft_chain_lookup(net, table, nla[NFTA_RULE_CHAIN], genmask);
 	if (IS_ERR(chain)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_CHAIN]);
-		return PTR_ERR(chain);
+		return ERR_CAST(chain);
 	}
 
 	rule = nft_rule_lookup(chain, nla[NFTA_RULE_HANDLE]);
 	if (IS_ERR(rule)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_HANDLE]);
-		return PTR_ERR(rule);
+		return ERR_CAST(rule);
 	}
 
 	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (!skb2)
-		return -ENOMEM;
-
-	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETRULE_RESET)
-		reset = true;
+		return ERR_PTR(-ENOMEM);
 
-	err = nf_tables_fill_rule_info(skb2, net, NETLINK_CB(skb).portid,
+	err = nf_tables_fill_rule_info(skb2, net, portid,
 				       info->nlh->nlmsg_seq, NFT_MSG_NEWRULE, 0,
 				       family, table, chain, rule, 0, reset);
-	if (err < 0)
-		goto err_fill_rule_info;
+	if (err < 0) {
+		kfree_skb(skb2);
+		return ERR_PTR(err);
+	}
 
-	if (reset)
-		audit_log_rule_reset(table, nft_pernet(net)->base_seq, 1);
+	return skb2;
+}
 
-	return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
+static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
+			     const struct nlattr * const nla[])
+{
+	u32 portid = NETLINK_CB(skb).portid;
+	struct sk_buff *skb2;
 
-err_fill_rule_info:
-	kfree_skb(skb2);
-	return err;
+	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
+		struct netlink_dump_control c = {
+			.start= nf_tables_dump_rules_start,
+			.dump = nf_tables_dump_rules,
+			.done = nf_tables_dump_rules_done,
+			.module = THIS_MODULE,
+			.data = (void *)nla,
+		};
+
+		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
+	}
+
+	skb2 = nf_tables_getrule_single(portid, info, nla, false);
+	if (IS_ERR(skb2))
+		return PTR_ERR(skb2);
+
+	return nfnetlink_unicast(skb2, info->net, portid);
+}
+
+static int nf_tables_getrule_reset(struct sk_buff *skb,
+				   const struct nfnl_info *info,
+				   const struct nlattr * const nla[])
+{
+	struct nftables_pernet *nft_net = nft_pernet(info->net);
+	u8 family = info->nfmsg->nfgen_family;
+	u32 portid = NETLINK_CB(skb).portid;
+	char *tablename, *buf;
+	struct sk_buff *skb2;
+
+	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
+		struct netlink_dump_control c = {
+			.start= nf_tables_dumpreset_rules_start,
+			.dump = nf_tables_dumpreset_rules,
+			.done = nf_tables_dump_rules_done,
+			.module = THIS_MODULE,
+			.data = (void *)nla,
+		};
+
+		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
+	}
+
+	if (!nla[NFTA_RULE_TABLE])
+		return -EINVAL;
+
+	tablename = nla_strdup(nla[NFTA_RULE_TABLE], GFP_ATOMIC);
+	if (!tablename)
+		return -ENOMEM;
+
+	spin_lock(&nft_net->reset_lock);
+	skb2 = nf_tables_getrule_single(portid, info, nla, true);
+	spin_unlock(&nft_net->reset_lock);
+	if (IS_ERR(skb2))
+		return PTR_ERR(skb2);
+
+	buf = kasprintf(GFP_ATOMIC, "%s:%u", tablename, nft_net->base_seq);
+	audit_log_nfcfg(buf, family, 1, AUDIT_NFT_OP_RULE_RESET, GFP_ATOMIC);
+	kfree(buf);
+	kfree(tablename);
+
+	return nfnetlink_unicast(skb2, info->net, portid);
 }
 
 void nf_tables_rule_destroy(const struct nft_ctx *ctx, struct nft_rule *rule)
@@ -8950,7 +9017,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_rule_policy,
 	},
 	[NFT_MSG_GETRULE_RESET] = {
-		.call		= nf_tables_getrule,
+		.call		= nf_tables_getrule_reset,
 		.type		= NFNL_CB_RCU,
 		.attr_count	= NFTA_RULE_MAX,
 		.policy		= nft_rule_policy,
@@ -11191,6 +11258,7 @@ static int __net_init nf_tables_init_net(struct net *net)
 	INIT_LIST_HEAD(&nft_net->module_list);
 	INIT_LIST_HEAD(&nft_net->notify_list);
 	mutex_init(&nft_net->commit_mutex);
+	spin_lock_init(&nft_net->reset_lock);
 	nft_net->base_seq = 1;
 	nft_net->gc_seq = 0;
 	nft_net->validate_state = NFT_VALIDATE_SKIP;
-- 
2.41.0

