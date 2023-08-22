Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA2C4EE4993
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Aug 2023 17:11:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjHVRLZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Aug 2023 13:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjHVRLY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Aug 2023 13:11:24 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AB484E5A
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Aug 2023 10:11:22 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nf-next] netfilter: nf_tables: missing extended netlink error in lookup functions
Date:   Tue, 22 Aug 2023 19:11:17 +0200
Message-Id: <20230822171117.3614-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Set netlink extended error reporting for several lookup functions which
allows userspace to infer what is the error cause.

Reported-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index eb8b1167dced..42d9e76d679c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4657,8 +4657,10 @@ static int nf_tables_getset(struct sk_buff *skb, const struct nfnl_info *info,
 		return -EINVAL;
 
 	set = nft_set_lookup(table, nla[NFTA_SET_NAME], genmask);
-	if (IS_ERR(set))
+	if (IS_ERR(set)) {
+		NL_SET_BAD_ATTR(extack, nla[NFTA_SET_NAME]);
 		return PTR_ERR(set);
+	}
 
 	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (skb2 == NULL)
@@ -5968,8 +5970,10 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 	}
 
 	set = nft_set_lookup(table, nla[NFTA_SET_ELEM_LIST_SET], genmask);
-	if (IS_ERR(set))
+	if (IS_ERR(set)) {
+		NL_SET_BAD_ATTR(extack, nla[NFTA_SET_ELEM_LIST_SET]);
 		return PTR_ERR(set);
+	}
 
 	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
@@ -6857,8 +6861,10 @@ static int nf_tables_newsetelem(struct sk_buff *skb,
 
 	set = nft_set_lookup_global(net, table, nla[NFTA_SET_ELEM_LIST_SET],
 				    nla[NFTA_SET_ELEM_LIST_SET_ID], genmask);
-	if (IS_ERR(set))
+	if (IS_ERR(set)) {
+		NL_SET_BAD_ATTR(extack, nla[NFTA_SET_ELEM_LIST_SET]);
 		return PTR_ERR(set);
+	}
 
 	if (!list_empty(&set->bindings) &&
 	    (set->flags & (NFT_SET_CONSTANT | NFT_SET_ANONYMOUS)))
@@ -7133,8 +7139,10 @@ static int nf_tables_delsetelem(struct sk_buff *skb,
 	}
 
 	set = nft_set_lookup(table, nla[NFTA_SET_ELEM_LIST_SET], genmask);
-	if (IS_ERR(set))
+	if (IS_ERR(set)) {
+		NL_SET_BAD_ATTR(extack, nla[NFTA_SET_ELEM_LIST_SET]);
 		return PTR_ERR(set);
+	}
 
 	if (!list_empty(&set->bindings) &&
 	    (set->flags & (NFT_SET_CONSTANT | NFT_SET_ANONYMOUS)))
@@ -8616,6 +8624,7 @@ static int nf_tables_getflowtable(struct sk_buff *skb,
 				  const struct nfnl_info *info,
 				  const struct nlattr * const nla[])
 {
+	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_cur(info->net);
 	u8 family = info->nfmsg->nfgen_family;
 	struct nft_flowtable *flowtable;
@@ -8641,13 +8650,17 @@ static int nf_tables_getflowtable(struct sk_buff *skb,
 
 	table = nft_table_lookup(net, nla[NFTA_FLOWTABLE_TABLE], family,
 				 genmask, 0);
-	if (IS_ERR(table))
+	if (IS_ERR(table)) {
+		NL_SET_BAD_ATTR(extack, nla[NFTA_FLOWTABLE_TABLE]);
 		return PTR_ERR(table);
+	}
 
 	flowtable = nft_flowtable_lookup(table, nla[NFTA_FLOWTABLE_NAME],
 					 genmask);
-	if (IS_ERR(flowtable))
+	if (IS_ERR(flowtable)) {
+		NL_SET_BAD_ATTR(extack, nla[NFTA_FLOWTABLE_NAME]);
 		return PTR_ERR(flowtable);
+	}
 
 	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (!skb2)
-- 
2.30.2

