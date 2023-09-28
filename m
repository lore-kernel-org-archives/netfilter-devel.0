Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E4BCE732DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Sep 2023 14:49:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbjI1Otl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Sep 2023 10:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbjI1Otj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Sep 2023 10:49:39 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D621A3;
        Thu, 28 Sep 2023 07:49:37 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qlsKb-0005Uw-3m; Thu, 28 Sep 2023 16:49:33 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Phil Sutter <phil@nwl.cc>
Subject: [PATCH net-next 3/4] netfilter: nf_tables: missing extended netlink error in lookup functions
Date:   Thu, 28 Sep 2023 16:49:00 +0200
Message-ID: <20230928144916.18339-4-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230928144916.18339-1-fw@strlen.de>
References: <20230928144916.18339-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

Set netlink extended error reporting for several lookup functions which
allows userspace to infer what is the error cause.

Reported-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4356189360fb..f993c237afd0 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4695,8 +4695,10 @@ static int nf_tables_getset(struct sk_buff *skb, const struct nfnl_info *info,
 		return -EINVAL;
 
 	set = nft_set_lookup(table, nla[NFTA_SET_NAME], genmask);
-	if (IS_ERR(set))
+	if (IS_ERR(set)) {
+		NL_SET_BAD_ATTR(extack, nla[NFTA_SET_NAME]);
 		return PTR_ERR(set);
+	}
 
 	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (skb2 == NULL)
@@ -6025,8 +6027,10 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 	}
 
 	set = nft_set_lookup(table, nla[NFTA_SET_ELEM_LIST_SET], genmask);
-	if (IS_ERR(set))
+	if (IS_ERR(set)) {
+		NL_SET_BAD_ATTR(extack, nla[NFTA_SET_ELEM_LIST_SET]);
 		return PTR_ERR(set);
+	}
 
 	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
@@ -6919,8 +6923,10 @@ static int nf_tables_newsetelem(struct sk_buff *skb,
 
 	set = nft_set_lookup_global(net, table, nla[NFTA_SET_ELEM_LIST_SET],
 				    nla[NFTA_SET_ELEM_LIST_SET_ID], genmask);
-	if (IS_ERR(set))
+	if (IS_ERR(set)) {
+		NL_SET_BAD_ATTR(extack, nla[NFTA_SET_ELEM_LIST_SET]);
 		return PTR_ERR(set);
+	}
 
 	if (!list_empty(&set->bindings) &&
 	    (set->flags & (NFT_SET_CONSTANT | NFT_SET_ANONYMOUS)))
@@ -7195,8 +7201,10 @@ static int nf_tables_delsetelem(struct sk_buff *skb,
 	}
 
 	set = nft_set_lookup(table, nla[NFTA_SET_ELEM_LIST_SET], genmask);
-	if (IS_ERR(set))
+	if (IS_ERR(set)) {
+		NL_SET_BAD_ATTR(extack, nla[NFTA_SET_ELEM_LIST_SET]);
 		return PTR_ERR(set);
+	}
 
 	if (nft_set_is_anonymous(set))
 		return -EOPNOTSUPP;
@@ -8680,6 +8688,7 @@ static int nf_tables_getflowtable(struct sk_buff *skb,
 				  const struct nfnl_info *info,
 				  const struct nlattr * const nla[])
 {
+	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_cur(info->net);
 	u8 family = info->nfmsg->nfgen_family;
 	struct nft_flowtable *flowtable;
@@ -8705,13 +8714,17 @@ static int nf_tables_getflowtable(struct sk_buff *skb,
 
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
2.41.0

