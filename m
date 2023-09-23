Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8830ACE7A88
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Sep 2023 01:38:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjIWBiW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Sep 2023 21:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjIWBiV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Sep 2023 21:38:21 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6EABE8
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Sep 2023 18:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4Fqq60X11KXbWkbdOmZKnCT4E8MPaUpx8ZNL0svwweM=; b=bumEa6sKhf1nuP/HX/aYPJkSY9
        36YZgi6BwlK0VVTIapZkUS5Ij4ExzHB1Xn0MK4OUfezb/bTaHkzE3u4yhG8cfYcKQu0Afman7UMHb
        rUJsNm7Q/DmVwlmZUKVG9ra9OhCsVa+CEPBEP8j88kwwpP+k6c9AdQXW4DEc147JKqXjAv0aixVe8
        PgVlN2yZzWha1NovSG5k0b9GuojuE2d+k5OMyeVJ3jMQKGFZ7gWGzl5VDrgAvB03GT9iwe4tC/Lix
        7udYuIbG2ZQYFWxtVC9fHFy2Nf9ytvUqdSwLE8Doq2LVfTYeKp7tiWYjhRcmrXF/wdMgkKsZoEyov
        oN0FO4AA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qjrb1-0001vx-Fp; Sat, 23 Sep 2023 03:38:11 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [nf PATCH 3/5] netfilter: nf_tables: Introduce struct nft_obj_dump_ctx
Date:   Sat, 23 Sep 2023 03:38:05 +0200
Message-ID: <20230923013807.11398-4-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230923013807.11398-1-phil@nwl.cc>
References: <20230923013807.11398-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Convert struct nft_obj_filter into a dump context data structure
equivalent to nft_rule_dump_ctx. Make it reside inside struct
netlink_callback::ctx scratch area so there's no need to allocate and
free it. Also carry the 'reset' boolean instead of determining this upon
each call to nf_tables_dump_obj() by inspecting the nlmsg_type.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 66 ++++++++++++++---------------------
 1 file changed, 26 insertions(+), 40 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4bccd15a67105..f6d8edcf0b9d5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7665,25 +7665,23 @@ static int nf_tables_fill_obj_info(struct sk_buff *skb, struct net *net,
 	return -1;
 }
 
-struct nft_obj_filter {
+struct nft_obj_dump_ctx {
+	unsigned int	s_idx;
 	char		*table;
 	u32		type;
+	bool		reset;
 };
 
 static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
-	const struct nft_table *table;
-	unsigned int idx = 0, s_idx = cb->args[0];
-	struct nft_obj_filter *filter = cb->data;
+	struct nft_obj_dump_ctx *ctx = (void *)cb->ctx;
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
 	struct nftables_pernet *nft_net;
+	const struct nft_table *table;
 	struct nft_object *obj;
-	bool reset = false;
-
-	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
-		reset = true;
+	unsigned int idx = 0;
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
@@ -7696,19 +7694,14 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 		list_for_each_entry_rcu(obj, &table->objects, list) {
 			if (!nft_is_active(net, obj))
 				goto cont;
-			if (idx < s_idx)
+			if (idx < ctx->s_idx)
 				goto cont;
-			if (idx > s_idx)
-				memset(&cb->args[1], 0,
-				       sizeof(cb->args) - sizeof(cb->args[0]));
-			if (filter && filter->table &&
-			    strcmp(filter->table, table->name))
+			if (ctx->table && strcmp(ctx->table, table->name))
 				goto cont;
-			if (filter &&
-			    filter->type != NFT_OBJECT_UNSPEC &&
-			    obj->ops->type->type != filter->type)
+			if (ctx->type != NFT_OBJECT_UNSPEC &&
+			    obj->ops->type->type != ctx->type)
 				goto cont;
-			if (reset) {
+			if (ctx->reset) {
 				char *buf = kasprintf(GFP_ATOMIC,
 						      "%s:%u",
 						      table->name,
@@ -7727,7 +7720,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 						    NFT_MSG_NEWOBJ,
 						    NLM_F_MULTI | NLM_F_APPEND,
 						    table->family, table,
-						    obj, reset) < 0)
+						    obj, ctx->reset) < 0)
 				goto done;
 
 			nl_dump_check_consistent(cb, nlmsg_hdr(skb));
@@ -7738,44 +7731,37 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 done:
 	rcu_read_unlock();
 
-	cb->args[0] = idx;
+	ctx->s_idx = idx;
 	return skb->len;
 }
 
 static int nf_tables_dump_obj_start(struct netlink_callback *cb)
 {
+	struct nft_obj_dump_ctx *ctx = (void *)cb->ctx;
 	const struct nlattr * const *nla = cb->data;
-	struct nft_obj_filter *filter = NULL;
 
-	if (nla[NFTA_OBJ_TABLE] || nla[NFTA_OBJ_TYPE]) {
-		filter = kzalloc(sizeof(*filter), GFP_ATOMIC);
-		if (!filter)
+	BUILD_BUG_ON(sizeof(*ctx) > sizeof(cb->ctx));
+
+	if (nla[NFTA_OBJ_TABLE]) {
+		ctx->table = nla_strdup(nla[NFTA_OBJ_TABLE], GFP_ATOMIC);
+		if (!ctx->table)
 			return -ENOMEM;
+	}
 
-		if (nla[NFTA_OBJ_TABLE]) {
-			filter->table = nla_strdup(nla[NFTA_OBJ_TABLE], GFP_ATOMIC);
-			if (!filter->table) {
-				kfree(filter);
-				return -ENOMEM;
-			}
-		}
+	if (nla[NFTA_OBJ_TYPE])
+		ctx->type = ntohl(nla_get_be32(nla[NFTA_OBJ_TYPE]));
 
-		if (nla[NFTA_OBJ_TYPE])
-			filter->type = ntohl(nla_get_be32(nla[NFTA_OBJ_TYPE]));
-	}
+	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
+		ctx->reset = true;
 
-	cb->data = filter;
 	return 0;
 }
 
 static int nf_tables_dump_obj_done(struct netlink_callback *cb)
 {
-	struct nft_obj_filter *filter = cb->data;
+	struct nft_obj_dump_ctx *ctx = (void *)cb->ctx;
 
-	if (filter) {
-		kfree(filter->table);
-		kfree(filter);
-	}
+	kfree(ctx->table);
 
 	return 0;
 }
-- 
2.41.0

