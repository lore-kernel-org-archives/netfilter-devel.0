Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7B0DC4167D
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Nov 2023 15:00:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjKBPAI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Nov 2023 11:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjKBPAH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2023 11:00:07 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC34138
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Nov 2023 07:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=X3R6jm1dvOyr5OdH/pvakqtgSqRvRb+9Pn+jjvk6txA=; b=l8kqGmfFo+tCF2X6r3wnYeUcSs
        zuAYZj0rLR59H5bSAQNBvkxDhA3D2VP6+HZRX9WT7Iuv4VSzqQDWNiHRcBZ0qAsMqeVfXyCY3HDBU
        sfmc+zpnpr6q7fHKMcKxFAxDDJLW9pIrGWxE69mz+YWPblPOlAWO78WwuXXwaFFFTcH7LfGy6yYL8
        VGR9CVbnmd2Qrlcj2HsRdALYecNSY65tnmIfqzfCOarxivWAHz3jCnnJewdcdCLTnOVfDP5kFpGKy
        n6Cd6A0rp4kufLliCQz8cf65LgrW1ymzg+WCFwCt7/B27Co81+I3yGEeyN+QD4N/JEutSaGDiAKA0
        j36TpX+A==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qyZAr-0004h2-3a; Thu, 02 Nov 2023 15:59:57 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [nf-next PATCH v3] netfilter: nf_tables: Add locking for NFT_MSG_GETSETELEM_RESET requests
Date:   Thu,  2 Nov 2023 15:59:53 +0100
Message-ID: <20231102145953.2467-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Set expressions' dump callbacks are not concurrency-safe per-se with
reset bit set. If two CPUs reset the same element at the same time,
values may underrun at least with element-attached counters and quotas.

Prevent this by introducing dedicated callbacks for nfnetlink and the
asynchronous dump handling to serialize access.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v2:
- Move the audit_log_nft_set_reset() call into the critical section to
  protect the table pointer dereference.
- Drop unused nelems variable from (non-reset) nf_tables_getsetelem().
---
 net/netfilter/nf_tables_api.c | 109 +++++++++++++++++++++++++++++-----
 1 file changed, 94 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 245a2c5be082..fbf18a3b0915 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5816,10 +5816,6 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	nla_nest_end(skb, nest);
 	nlmsg_end(skb, nlh);
 
-	if (dump_ctx->reset && args.iter.count > args.iter.skip)
-		audit_log_nft_set_reset(table, cb->seq,
-					args.iter.count - args.iter.skip);
-
 	rcu_read_unlock();
 
 	if (args.iter.err && args.iter.err != -EMSGSIZE)
@@ -5835,6 +5831,26 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	return -ENOSPC;
 }
 
+static int nf_tables_dumpreset_set(struct sk_buff *skb,
+				   struct netlink_callback *cb)
+{
+	struct nftables_pernet *nft_net = nft_pernet(sock_net(skb->sk));
+	struct nft_set_dump_ctx *dump_ctx = cb->data;
+	int ret, skip = cb->args[0];
+
+	mutex_lock(&nft_net->commit_mutex);
+
+	ret = nf_tables_dump_set(skb, cb);
+
+	if (cb->args[0] > skip)
+		audit_log_nft_set_reset(dump_ctx->ctx.table, cb->seq,
+					cb->args[0] - skip);
+
+	mutex_unlock(&nft_net->commit_mutex);
+
+	return ret;
+}
+
 static int nf_tables_dump_set_start(struct netlink_callback *cb)
 {
 	struct nft_set_dump_ctx *dump_ctx = cb->data;
@@ -6046,13 +6062,12 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_cur(info->net);
 	u8 family = info->nfmsg->nfgen_family;
-	int rem, err = 0, nelems = 0;
 	struct net *net = info->net;
 	struct nft_table *table;
 	struct nft_set *set;
 	struct nlattr *attr;
 	struct nft_ctx ctx;
-	bool reset = false;
+	int rem, err = 0;
 
 	table = nft_table_lookup(net, nla[NFTA_SET_ELEM_LIST_TABLE], family,
 				 genmask, 0);
@@ -6069,9 +6084,6 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 
 	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
-	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETSETELEM_RESET)
-		reset = true;
-
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.start = nf_tables_dump_set_start,
@@ -6082,7 +6094,7 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 		struct nft_set_dump_ctx dump_ctx = {
 			.set = set,
 			.ctx = ctx,
-			.reset = reset,
+			.reset = false,
 		};
 
 		c.data = &dump_ctx;
@@ -6093,17 +6105,84 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 		return -EINVAL;
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
-		err = nft_get_set_elem(&ctx, set, attr, reset);
+		err = nft_get_set_elem(&ctx, set, attr, false);
+		if (err < 0) {
+			NL_SET_BAD_ATTR(extack, attr);
+			break;
+		}
+	}
+
+	return err;
+}
+
+static int nf_tables_getsetelem_reset(struct sk_buff *skb,
+				      const struct nfnl_info *info,
+				      const struct nlattr * const nla[])
+{
+	struct nftables_pernet *nft_net = nft_pernet(info->net);
+	struct netlink_ext_ack *extack = info->extack;
+	u8 genmask = nft_genmask_cur(info->net);
+	u8 family = info->nfmsg->nfgen_family;
+	int rem, err = 0, nelems = 0;
+	struct net *net = info->net;
+	struct nft_table *table;
+	struct nft_set *set;
+	struct nlattr *attr;
+	struct nft_ctx ctx;
+
+	table = nft_table_lookup(net, nla[NFTA_SET_ELEM_LIST_TABLE], family,
+				 genmask, 0);
+	if (IS_ERR(table)) {
+		NL_SET_BAD_ATTR(extack, nla[NFTA_SET_ELEM_LIST_TABLE]);
+		return PTR_ERR(table);
+	}
+
+	set = nft_set_lookup(table, nla[NFTA_SET_ELEM_LIST_SET], genmask);
+	if (IS_ERR(set))
+		return PTR_ERR(set);
+
+	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
+
+	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
+		struct netlink_dump_control c = {
+			.start = nf_tables_dump_set_start,
+			.dump = nf_tables_dumpreset_set,
+			.done = nf_tables_dump_set_done,
+			.module = THIS_MODULE,
+		};
+		struct nft_set_dump_ctx dump_ctx = {
+			.set = set,
+			.ctx = ctx,
+			.reset = true,
+		};
+
+		c.data = &dump_ctx;
+		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
+	}
+
+	if (!nla[NFTA_SET_ELEM_LIST_ELEMENTS])
+		return -EINVAL;
+
+	if (!try_module_get(THIS_MODULE))
+		return -EINVAL;
+	rcu_read_unlock();
+	mutex_lock(&nft_net->commit_mutex);
+	rcu_read_lock();
+
+	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
+		err = nft_get_set_elem(&ctx, set, attr, true);
 		if (err < 0) {
 			NL_SET_BAD_ATTR(extack, attr);
 			break;
 		}
 		nelems++;
 	}
+	audit_log_nft_set_reset(table, nft_net->base_seq, nelems);
 
-	if (reset)
-		audit_log_nft_set_reset(table, nft_pernet(net)->base_seq,
-					nelems);
+	rcu_read_unlock();
+	mutex_unlock(&nft_net->commit_mutex);
+	rcu_read_lock();
+	module_put(THIS_MODULE);
 
 	return err;
 }
@@ -9128,7 +9207,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_set_elem_list_policy,
 	},
 	[NFT_MSG_GETSETELEM_RESET] = {
-		.call		= nf_tables_getsetelem,
+		.call		= nf_tables_getsetelem_reset,
 		.type		= NFNL_CB_RCU,
 		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
 		.policy		= nft_set_elem_list_policy,
-- 
2.41.0

