Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FD9DCE7A90
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Sep 2023 01:38:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjIWBiY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Sep 2023 21:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbjIWBiX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Sep 2023 21:38:23 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B093119C
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Sep 2023 18:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MZpbOr735CmqpzaMeSya++XPWBEYV3QxR11cFMVMnhM=; b=TA+TlHsRAaGXmvccigTMr2v13A
        IMM9OoXLVvw0H6ehZKU9W0FuLi6hefzzv9iSIXl6rx4PKErhzwxHS8PbQuLZjUsppmB23AANHZetM
        zahbOf5oReDThm+iojMqURuG0SaOc1giFRcAkK/73+9qb1LVvDA4MtuygB+Y1yI90AZTcH85o/A3j
        P/XSYuhkVz9g7vV98lcpFS29ZnX7LSg+lmKedTEuNvTxbVU8FYdSMYWGHCx5VyzwVGZwp3gZjdJ7e
        9Nm+9XQjV1piCq9/YTvE0S9uZAzaT3zzcXzT1SR06goj+VyDjoO6wSHxKotsyfQU3US/cl5W9QLo1
        BkW/mcwg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qjrb3-0001wN-2m; Sat, 23 Sep 2023 03:38:13 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [nf PATCH 5/5] netfilter: nf_tables: Add locking for NFT_MSG_GETSETELEM_RESET requests
Date:   Sat, 23 Sep 2023 03:38:07 +0200
Message-ID: <20230923013807.11398-6-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230923013807.11398-1-phil@nwl.cc>
References: <20230923013807.11398-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Introduce dedicated callbacks for nfnetlink and the asynchronous dump
handling which perform the necessary locking.

Extending struct nft_set_dump_ctx by a 'reset' field relieves
nf_tables_dump_set() from having to check the nfnl msg type upon each
call.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 106 ++++++++++++++++++++++++++++------
 1 file changed, 87 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8812d5282ca8f..0e5d9bdba82b8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5723,6 +5723,7 @@ static void audit_log_nft_set_reset(const struct nft_table *table,
 struct nft_set_dump_ctx {
 	const struct nft_set	*set;
 	struct nft_ctx		ctx;
+	bool			reset;
 };
 
 static int nft_set_catchall_dump(struct net *net, struct sk_buff *skb,
@@ -5762,7 +5763,6 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	bool set_found = false;
 	struct nlmsghdr *nlh;
 	struct nlattr *nest;
-	bool reset = false;
 	u32 portid, seq;
 	int event;
 
@@ -5810,12 +5810,9 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	if (nest == NULL)
 		goto nla_put_failure;
 
-	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETSETELEM_RESET)
-		reset = true;
-
 	args.cb			= cb;
 	args.skb		= skb;
-	args.reset		= reset;
+	args.reset		= dump_ctx->reset;
 	args.iter.genmask	= nft_genmask_cur(net);
 	args.iter.skip		= cb->args[0];
 	args.iter.count		= 0;
@@ -5825,14 +5822,10 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 
 	if (!args.iter.err && args.iter.count == cb->args[0])
 		args.iter.err = nft_set_catchall_dump(net, skb, set,
-						      reset, cb->seq);
+						      dump_ctx->reset, cb->seq);
 	nla_nest_end(skb, nest);
 	nlmsg_end(skb, nlh);
 
-	if (reset && args.iter.count > args.iter.skip)
-		audit_log_nft_set_reset(table, cb->seq,
-					args.iter.count - args.iter.skip);
-
 	rcu_read_unlock();
 
 	if (args.iter.err && args.iter.err != -EMSGSIZE)
@@ -5848,6 +5841,24 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	return -ENOSPC;
 }
 
+static int nf_tables_dumpreset_set(struct sk_buff *skb,
+				   struct netlink_callback *cb)
+{
+	struct nftables_pernet *nft_net = nft_pernet(sock_net(skb->sk));
+	struct nft_set_dump_ctx *dump_ctx = cb->data;
+	int ret, skip = cb->args[0];
+
+	spin_lock(&nft_net->reset_lock);
+	ret = nf_tables_dump_set(skb, cb);
+	spin_unlock(&nft_net->reset_lock);
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
@@ -6065,7 +6076,6 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 	struct nft_set *set;
 	struct nlattr *attr;
 	struct nft_ctx ctx;
-	bool reset = false;
 
 	table = nft_table_lookup(net, nla[NFTA_SET_ELEM_LIST_TABLE], family,
 				 genmask, 0);
@@ -6090,6 +6100,7 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 		struct nft_set_dump_ctx dump_ctx = {
 			.set = set,
 			.ctx = ctx,
+			.reset = false,
 		};
 
 		c.data = &dump_ctx;
@@ -6099,21 +6110,78 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 	if (!nla[NFTA_SET_ELEM_LIST_ELEMENTS])
 		return -EINVAL;
 
-	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETSETELEM_RESET)
-		reset = true;
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
+	spin_lock(&nft_net->reset_lock);
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
-		err = nft_get_set_elem(&ctx, set, attr, reset);
+		err = nft_get_set_elem(&ctx, set, attr, true);
 		if (err < 0) {
 			NL_SET_BAD_ATTR(extack, attr);
 			break;
 		}
 		nelems++;
 	}
+	spin_unlock(&nft_net->reset_lock);
 
-	if (reset)
-		audit_log_nft_set_reset(table, nft_pernet(net)->base_seq,
-					nelems);
+	audit_log_nft_set_reset(table, nft_net->base_seq, nelems);
 
 	return err;
 }
@@ -7861,7 +7929,7 @@ static int nf_tables_getobj_reset(struct sk_buff *skb,
 				  const struct nfnl_info *info,
 				  const struct nlattr * const nla[])
 {
-	const struct nftables_pernet *nft_net = nft_pernet(info->net);
+	struct nftables_pernet *nft_net = nft_pernet(info->net);
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_cur(info->net);
 	u8 family = info->nfmsg->nfgen_family;
@@ -9128,7 +9196,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
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

