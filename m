Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF02BC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  8 Jan 2022 22:26:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbiAHW0r (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 8 Jan 2022 17:26:47 -0500
Received: from mail.netfilter.org ([217.70.188.207]:40114 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbiAHW0p (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 8 Jan 2022 17:26:45 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8F0786428C
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Jan 2022 23:23:56 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2 01/14] netfilter: nft_connlimit: move stateful fields out of expression data
Date:   Sat,  8 Jan 2022 23:26:25 +0100
Message-Id: <20220108222638.36037-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220108222638.36037-1-pablo@netfilter.org>
References: <20220108222638.36037-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In preparation for the rule blob representation.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_connlimit.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index 7d0761fad37e..58dcafe8bf79 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -14,7 +14,7 @@
 #include <net/netfilter/nf_conntrack_zones.h>
 
 struct nft_connlimit {
-	struct nf_conncount_list	list;
+	struct nf_conncount_list	*list;
 	u32				limit;
 	bool				invert;
 };
@@ -43,12 +43,12 @@ static inline void nft_connlimit_do_eval(struct nft_connlimit *priv,
 		return;
 	}
 
-	if (nf_conncount_add(nft_net(pkt), &priv->list, tuple_ptr, zone)) {
+	if (nf_conncount_add(nft_net(pkt), priv->list, tuple_ptr, zone)) {
 		regs->verdict.code = NF_DROP;
 		return;
 	}
 
-	count = priv->list.count;
+	count = priv->list->count;
 
 	if ((count > priv->limit) ^ priv->invert) {
 		regs->verdict.code = NFT_BREAK;
@@ -76,7 +76,11 @@ static int nft_connlimit_do_init(const struct nft_ctx *ctx,
 			invert = true;
 	}
 
-	nf_conncount_list_init(&priv->list);
+	priv->list = kmalloc(sizeof(*priv->list), GFP_KERNEL);
+	if (!priv->list)
+		return -ENOMEM;
+
+	nf_conncount_list_init(priv->list);
 	priv->limit	= limit;
 	priv->invert	= invert;
 
@@ -87,7 +91,8 @@ static void nft_connlimit_do_destroy(const struct nft_ctx *ctx,
 				     struct nft_connlimit *priv)
 {
 	nf_ct_netns_put(ctx->net, ctx->family);
-	nf_conncount_cache_free(&priv->list);
+	nf_conncount_cache_free(priv->list);
+	kfree(priv->list);
 }
 
 static int nft_connlimit_do_dump(struct sk_buff *skb,
@@ -200,7 +205,11 @@ static int nft_connlimit_clone(struct nft_expr *dst, const struct nft_expr *src)
 	struct nft_connlimit *priv_dst = nft_expr_priv(dst);
 	struct nft_connlimit *priv_src = nft_expr_priv(src);
 
-	nf_conncount_list_init(&priv_dst->list);
+	priv_dst->list = kmalloc(sizeof(*priv_dst->list), GFP_ATOMIC);
+	if (priv_dst->list)
+		return -ENOMEM;
+
+	nf_conncount_list_init(priv_dst->list);
 	priv_dst->limit	 = priv_src->limit;
 	priv_dst->invert = priv_src->invert;
 
@@ -212,7 +221,8 @@ static void nft_connlimit_destroy_clone(const struct nft_ctx *ctx,
 {
 	struct nft_connlimit *priv = nft_expr_priv(expr);
 
-	nf_conncount_cache_free(&priv->list);
+	nf_conncount_cache_free(priv->list);
+	kfree(priv->list);
 }
 
 static bool nft_connlimit_gc(struct net *net, const struct nft_expr *expr)
@@ -221,7 +231,7 @@ static bool nft_connlimit_gc(struct net *net, const struct nft_expr *expr)
 	bool ret;
 
 	local_bh_disable();
-	ret = nf_conncount_gc_list(net, &priv->list);
+	ret = nf_conncount_gc_list(net, priv->list);
 	local_bh_enable();
 
 	return ret;
-- 
2.30.2

