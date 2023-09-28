Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68E6EE732EA
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Sep 2023 16:52:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbjI1Qwx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Sep 2023 12:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbjI1Qww (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Sep 2023 12:52:52 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955BB1A7
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Sep 2023 09:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lCMyq+V0pj+Z4iIbB0McLZnhrPHr56X3xmOZ1zzURYI=; b=QDcARQI53BxOJ+LmeytwexQg/f
        AL+0dY5AQ+ggs5KmeZ7LmZ85EKsNf2j537plHSDEDsUYToM+xVqhuoVil/iMNjGyAiRk7xQ+SlQIJ
        Ab58oZAp+BaWgb+T16s5UAXjOUS7ApJAmguass8BvdA+sIF17iBaax3u11XHzogqWIYQu572wi+ul
        cEOIFqkWSKINecYRU08nEVLSoxpVN7BVGI/GWZtgjOokUu+vtQPxoSW8OjSrTih3sTYaGwPWMxnoy
        iXYGc3odgNZ0pUtRSQjittCfB10+G/EU0JQMOzQBwfvTuCY/2frdfq+LecrAEbFRzrjOmWqKCyQxK
        +982taQg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qluFs-0004wS-VC; Thu, 28 Sep 2023 18:52:49 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: [nf PATCH v2 8/8] netfilter: nf_tables: Add locking for NFT_MSG_GETSETELEM_RESET requests
Date:   Thu, 28 Sep 2023 18:52:44 +0200
Message-ID: <20230928165244.7168-9-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230928165244.7168-1-phil@nwl.cc>
References: <20230928165244.7168-1-phil@nwl.cc>
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
Changes since v1:
- Improved commit description
- Unrelated chunk moved into a previous patch
---
 net/netfilter/nf_tables_api.c | 105 +++++++++++++++++++++++++++++-----
 1 file changed, 91 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1491d4c65fed9..a855b43fe72db 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5834,10 +5834,6 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	nla_nest_end(skb, nest);
 	nlmsg_end(skb, nlh);
 
-	if (dump_ctx->reset && args.iter.count > args.iter.skip)
-		audit_log_nft_set_reset(table, cb->seq,
-					args.iter.count - args.iter.skip);
-
 	rcu_read_unlock();
 
 	if (args.iter.err && args.iter.err != -EMSGSIZE)
@@ -5853,6 +5849,24 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
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
+	ret = nf_tables_dump_set(skb, cb);
+	mutex_unlock(&nft_net->commit_mutex);
+
+	if (cb->args[0] > skip)
+		audit_log_nft_set_reset(dump_ctx->ctx.table, cb->seq,
+					cb->args[0] - skip);
+
+	return ret;
+}
+
 static int nf_tables_dump_set_start(struct netlink_callback *cb)
 {
 	struct nft_set_dump_ctx *dump_ctx = cb->data;
@@ -6070,7 +6084,6 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 	struct nft_set *set;
 	struct nlattr *attr;
 	struct nft_ctx ctx;
-	bool reset = false;
 
 	table = nft_table_lookup(net, nla[NFTA_SET_ELEM_LIST_TABLE], family,
 				 genmask, 0);
@@ -6085,9 +6098,6 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 
 	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
-	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETSETELEM_RESET)
-		reset = true;
-
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.start = nf_tables_dump_set_start,
@@ -6098,7 +6108,67 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 		struct nft_set_dump_ctx dump_ctx = {
 			.set = set,
 			.ctx = ctx,
-			.reset = reset,
+			.reset = false,
+		};
+
+		c.data = &dump_ctx;
+		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
+	}
+
+	if (!nla[NFTA_SET_ELEM_LIST_ELEMENTS])
+		return -EINVAL;
+
+	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
+		err = nft_get_set_elem(&ctx, set, attr, false);
+		if (err < 0) {
+			NL_SET_BAD_ATTR(extack, attr);
+			break;
+		}
+		nelems++;
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
 		};
 
 		c.data = &dump_ctx;
@@ -6108,18 +6178,25 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 	if (!nla[NFTA_SET_ELEM_LIST_ELEMENTS])
 		return -EINVAL;
 
+	if (!try_module_get(THIS_MODULE))
+		return -EINVAL;
+	rcu_read_unlock();
+	mutex_lock(&nft_net->commit_mutex);
+	rcu_read_lock();
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
-		err = nft_get_set_elem(&ctx, set, attr, reset);
+		err = nft_get_set_elem(&ctx, set, attr, true);
 		if (err < 0) {
 			NL_SET_BAD_ATTR(extack, attr);
 			break;
 		}
 		nelems++;
 	}
+	rcu_read_unlock();
+	mutex_unlock(&nft_net->commit_mutex);
+	rcu_read_lock();
+	module_put(THIS_MODULE);
 
-	if (reset)
-		audit_log_nft_set_reset(table, nft_pernet(net)->base_seq,
-					nelems);
+	audit_log_nft_set_reset(table, nft_net->base_seq, nelems);
 
 	return err;
 }
@@ -9140,7 +9217,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
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

