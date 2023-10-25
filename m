Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4042C25B71
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Oct 2023 21:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbjJYV0R (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Oct 2023 17:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbjJYV0N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2023 17:26:13 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C0FA6184;
        Wed, 25 Oct 2023 14:26:10 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, fw@strlen.de
Subject: [PATCH net-next 15/19] netfilter: nf_tables: set backend .flush always succeeds
Date:   Wed, 25 Oct 2023 23:25:51 +0200
Message-Id: <20231025212555.132775-16-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231025212555.132775-1-pablo@netfilter.org>
References: <20231025212555.132775-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

.flush is always successful since this results from iterating over the
set elements to toggle mark the element as inactive in the next
generation.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 2 +-
 net/netfilter/nf_tables_api.c     | 9 +--------
 net/netfilter/nft_set_bitmap.c    | 4 +---
 net/netfilter/nft_set_hash.c      | 7 ++-----
 net/netfilter/nft_set_pipapo.c    | 4 +---
 net/netfilter/nft_set_rbtree.c    | 4 +---
 6 files changed, 7 insertions(+), 23 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 8de040d2d2cf..d0f5c477c254 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -449,7 +449,7 @@ struct nft_set_ops {
 	void *				(*deactivate)(const struct net *net,
 						      const struct nft_set *set,
 						      const struct nft_set_elem *elem);
-	bool				(*flush)(const struct net *net,
+	void				(*flush)(const struct net *net,
 						 const struct nft_set *set,
 						 void *priv);
 	void				(*remove)(const struct net *net,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ecb251f6c6a6..35db40857bc6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7146,17 +7146,13 @@ static int nft_setelem_flush(const struct nft_ctx *ctx,
 			     struct nft_set_elem *elem)
 {
 	struct nft_trans *trans;
-	int err;
 
 	trans = nft_trans_alloc_gfp(ctx, NFT_MSG_DELSETELEM,
 				    sizeof(struct nft_trans_elem), GFP_ATOMIC);
 	if (!trans)
 		return -ENOMEM;
 
-	if (!set->ops->flush(ctx->net, set, elem->priv)) {
-		err = -ENOENT;
-		goto err1;
-	}
+	set->ops->flush(ctx->net, set, elem->priv);
 	set->ndeact++;
 
 	nft_setelem_data_deactivate(ctx->net, set, elem);
@@ -7165,9 +7161,6 @@ static int nft_setelem_flush(const struct nft_ctx *ctx,
 	nft_trans_commit_list_add_tail(ctx->net, trans);
 
 	return 0;
-err1:
-	kfree(trans);
-	return err;
 }
 
 static int __nft_set_catchall_flush(const struct nft_ctx *ctx,
diff --git a/net/netfilter/nft_set_bitmap.c b/net/netfilter/nft_set_bitmap.c
index 1e5e7a181e0b..2ee6e3672b41 100644
--- a/net/netfilter/nft_set_bitmap.c
+++ b/net/netfilter/nft_set_bitmap.c
@@ -174,7 +174,7 @@ static void nft_bitmap_activate(const struct net *net,
 	nft_set_elem_change_active(net, set, &be->ext);
 }
 
-static bool nft_bitmap_flush(const struct net *net,
+static void nft_bitmap_flush(const struct net *net,
 			     const struct nft_set *set, void *_be)
 {
 	struct nft_bitmap *priv = nft_set_priv(set);
@@ -186,8 +186,6 @@ static bool nft_bitmap_flush(const struct net *net,
 	/* Enter 10 state, similar to deactivation. */
 	priv->bitmap[idx] &= ~(genmask << off);
 	nft_set_elem_change_active(net, set, &be->ext);
-
-	return true;
 }
 
 static void *nft_bitmap_deactivate(const struct net *net,
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 2013de934cef..e758b887ad86 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -192,14 +192,12 @@ static void nft_rhash_activate(const struct net *net, const struct nft_set *set,
 	nft_set_elem_change_active(net, set, &he->ext);
 }
 
-static bool nft_rhash_flush(const struct net *net,
+static void nft_rhash_flush(const struct net *net,
 			    const struct nft_set *set, void *priv)
 {
 	struct nft_rhash_elem *he = priv;
 
 	nft_set_elem_change_active(net, set, &he->ext);
-
-	return true;
 }
 
 static void *nft_rhash_deactivate(const struct net *net,
@@ -590,13 +588,12 @@ static void nft_hash_activate(const struct net *net, const struct nft_set *set,
 	nft_set_elem_change_active(net, set, &he->ext);
 }
 
-static bool nft_hash_flush(const struct net *net,
+static void nft_hash_flush(const struct net *net,
 			   const struct nft_set *set, void *priv)
 {
 	struct nft_hash_elem *he = priv;
 
 	nft_set_elem_change_active(net, set, &he->ext);
-	return true;
 }
 
 static void *nft_hash_deactivate(const struct net *net,
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index bea63aa2df4b..dba073aa9ad6 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1809,14 +1809,12 @@ static void *nft_pipapo_deactivate(const struct net *net,
  *
  * Return: true if element was found and deactivated.
  */
-static bool nft_pipapo_flush(const struct net *net, const struct nft_set *set,
+static void nft_pipapo_flush(const struct net *net, const struct nft_set *set,
 			     void *elem)
 {
 	struct nft_pipapo_elem *e = elem;
 
 	nft_set_elem_change_active(net, set, &e->ext);
-
-	return true;
 }
 
 /**
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 7d1004f9e7d2..60ff591eb265 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -535,14 +535,12 @@ static void nft_rbtree_activate(const struct net *net,
 	nft_set_elem_change_active(net, set, &rbe->ext);
 }
 
-static bool nft_rbtree_flush(const struct net *net,
+static void nft_rbtree_flush(const struct net *net,
 			     const struct nft_set *set, void *priv)
 {
 	struct nft_rbtree_elem *rbe = priv;
 
 	nft_set_elem_change_active(net, set, &rbe->ext);
-
-	return true;
 }
 
 static void *nft_rbtree_deactivate(const struct net *net,
-- 
2.30.2

