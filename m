Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 461B2C4708F
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 May 2021 23:29:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20D60610CE
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 May 2021 23:29:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbhE2XbG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 May 2021 19:31:06 -0400
Received: from mail.netfilter.org ([217.70.188.207]:51040 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbhE2XbF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 May 2021 19:31:05 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id D728B6440A
        for <netfilter-devel@vger.kernel.org>; Sun, 30 May 2021 01:28:23 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2 2/3] netfilter: nf_tables: remove nft_ctx_init_from_elemattr()
Date:   Sun, 30 May 2021 01:29:22 +0200
Message-Id: <20210529232923.19799-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210529232923.19799-1-pablo@netfilter.org>
References: <20210529232923.19799-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Replace nft_ctx_init_from_elemattr() by nft_table_lookup() and set up
the context structure right before it is really needed.

Moreover, nft_ctx_init_from_elemattr() is setting up the context
structure for codepaths where this is not really needed at all.

This helper function is also not helping to consolidate code, removing
it saves us 4 LoC.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: fix crash on nf_tables_getsetelem()

 net/netfilter/nf_tables_api.c | 72 +++++++++++++++++------------------
 1 file changed, 34 insertions(+), 38 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 689f892e9028..9ffa51b9967e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4702,28 +4702,6 @@ static const struct nla_policy nft_set_elem_list_policy[NFTA_SET_ELEM_LIST_MAX +
 	[NFTA_SET_ELEM_LIST_SET_ID]	= { .type = NLA_U32 },
 };
 
-static int nft_ctx_init_from_elemattr(struct nft_ctx *ctx, struct net *net,
-				      const struct sk_buff *skb,
-				      const struct nlmsghdr *nlh,
-				      const struct nlattr * const nla[],
-				      struct netlink_ext_ack *extack,
-				      u8 genmask, u32 nlpid)
-{
-	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	int family = nfmsg->nfgen_family;
-	struct nft_table *table;
-
-	table = nft_table_lookup(net, nla[NFTA_SET_ELEM_LIST_TABLE], family,
-				 genmask, nlpid);
-	if (IS_ERR(table)) {
-		NL_SET_BAD_ATTR(extack, nla[NFTA_SET_ELEM_LIST_TABLE]);
-		return PTR_ERR(table);
-	}
-
-	nft_ctx_init(ctx, net, skb, nlh, family, table, NULL, nla);
-	return 0;
-}
-
 static int nft_set_elem_expr_dump(struct sk_buff *skb,
 				  const struct nft_set *set,
 				  const struct nft_set_ext *ext)
@@ -5181,21 +5159,27 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 {
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_cur(info->net);
+	int family = info->nfmsg->nfgen_family;
 	struct net *net = info->net;
+	struct nft_table *table;
 	struct nft_set *set;
 	struct nlattr *attr;
 	struct nft_ctx ctx;
 	int rem, err = 0;
 
-	err = nft_ctx_init_from_elemattr(&ctx, net, skb, info->nlh, nla, extack,
-					 genmask, NETLINK_CB(skb).portid);
-	if (err < 0)
-		return err;
+	table = nft_table_lookup(net, nla[NFTA_SET_ELEM_LIST_TABLE], family,
+				 genmask, NETLINK_CB(skb).portid);
+	if (IS_ERR(table)) {
+		NL_SET_BAD_ATTR(extack, nla[NFTA_SET_ELEM_LIST_TABLE]);
+		return PTR_ERR(table);
+	}
 
-	set = nft_set_lookup(ctx.table, nla[NFTA_SET_ELEM_LIST_SET], genmask);
+	set = nft_set_lookup(table, nla[NFTA_SET_ELEM_LIST_SET], genmask);
 	if (IS_ERR(set))
 		return PTR_ERR(set);
 
+	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
+
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.start = nf_tables_dump_set_start,
@@ -5964,8 +5948,10 @@ static int nf_tables_newsetelem(struct sk_buff *skb,
 	struct nftables_pernet *nft_net = nft_pernet(info->net);
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_next(info->net);
+	int family = info->nfmsg->nfgen_family;
 	struct net *net = info->net;
 	const struct nlattr *attr;
+	struct nft_table *table;
 	struct nft_set *set;
 	struct nft_ctx ctx;
 	int rem, err;
@@ -5973,12 +5959,14 @@ static int nf_tables_newsetelem(struct sk_buff *skb,
 	if (nla[NFTA_SET_ELEM_LIST_ELEMENTS] == NULL)
 		return -EINVAL;
 
-	err = nft_ctx_init_from_elemattr(&ctx, net, skb, info->nlh, nla, extack,
-					 genmask, NETLINK_CB(skb).portid);
-	if (err < 0)
-		return err;
+	table = nft_table_lookup(net, nla[NFTA_SET_ELEM_LIST_TABLE], family,
+				 genmask, NETLINK_CB(skb).portid);
+	if (IS_ERR(table)) {
+		NL_SET_BAD_ATTR(extack, nla[NFTA_SET_ELEM_LIST_TABLE]);
+		return PTR_ERR(table);
+	}
 
-	set = nft_set_lookup_global(net, ctx.table, nla[NFTA_SET_ELEM_LIST_SET],
+	set = nft_set_lookup_global(net, table, nla[NFTA_SET_ELEM_LIST_SET],
 				    nla[NFTA_SET_ELEM_LIST_SET_ID], genmask);
 	if (IS_ERR(set))
 		return PTR_ERR(set);
@@ -5986,6 +5974,8 @@ static int nf_tables_newsetelem(struct sk_buff *skb,
 	if (!list_empty(&set->bindings) && set->flags & NFT_SET_CONSTANT)
 		return -EBUSY;
 
+	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
+
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
 		err = nft_add_set_elem(&ctx, set, attr, info->nlh->nlmsg_flags);
 		if (err < 0)
@@ -5993,7 +5983,7 @@ static int nf_tables_newsetelem(struct sk_buff *skb,
 	}
 
 	if (nft_net->validate_state == NFT_VALIDATE_DO)
-		return nft_table_validate(net, ctx.table);
+		return nft_table_validate(net, table);
 
 	return 0;
 }
@@ -6231,23 +6221,29 @@ static int nf_tables_delsetelem(struct sk_buff *skb,
 {
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_next(info->net);
+	int family = info->nfmsg->nfgen_family;
 	struct net *net = info->net;
 	const struct nlattr *attr;
+	struct nft_table *table;
 	struct nft_set *set;
 	struct nft_ctx ctx;
 	int rem, err = 0;
 
-	err = nft_ctx_init_from_elemattr(&ctx, net, skb, info->nlh, nla, extack,
-					 genmask, NETLINK_CB(skb).portid);
-	if (err < 0)
-		return err;
+	table = nft_table_lookup(net, nla[NFTA_SET_ELEM_LIST_TABLE], family,
+				 genmask, NETLINK_CB(skb).portid);
+	if (IS_ERR(table)) {
+		NL_SET_BAD_ATTR(extack, nla[NFTA_SET_ELEM_LIST_TABLE]);
+		return PTR_ERR(table);
+	}
 
-	set = nft_set_lookup(ctx.table, nla[NFTA_SET_ELEM_LIST_SET], genmask);
+	set = nft_set_lookup(table, nla[NFTA_SET_ELEM_LIST_SET], genmask);
 	if (IS_ERR(set))
 		return PTR_ERR(set);
 	if (!list_empty(&set->bindings) && set->flags & NFT_SET_CONSTANT)
 		return -EBUSY;
 
+	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
+
 	if (!nla[NFTA_SET_ELEM_LIST_ELEMENTS])
 		return nft_set_flush(&ctx, set, genmask);
 
-- 
2.30.2

