Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BA73C433B4
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 May 2021 20:30:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D57561421
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 May 2021 20:30:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbhEMUbZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 13 May 2021 16:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232521AbhEMUbW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 May 2021 16:31:22 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DAC4C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 13 May 2021 13:30:12 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lhHyF-00037u-4V; Thu, 13 May 2021 22:30:11 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/2] netfilter: nf_tables: prefer direct calls for set lookups
Date:   Thu, 13 May 2021 22:29:56 +0200
Message-Id: <20210513202956.22709-3-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210513202956.22709-1-fw@strlen.de>
References: <20210513202956.22709-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Extend nft_set_do_lookup() to use direct calls when retpoline feature
is enabled.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables_core.h | 23 +++++++++++++++++++
 net/netfilter/nft_lookup.c             | 31 ++++++++++++++++++++++++++
 net/netfilter/nft_set_bitmap.c         |  5 +++--
 net/netfilter/nft_set_hash.c           | 17 ++++++++------
 net/netfilter/nft_set_pipapo.c         |  5 +++--
 net/netfilter/nft_set_pipapo_avx2.h    |  2 --
 net/netfilter/nft_set_rbtree.c         |  5 +++--
 7 files changed, 73 insertions(+), 15 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 5eb699454490..789e9eadd76d 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -3,6 +3,7 @@
 #define _NET_NF_TABLES_CORE_H
 
 #include <net/netfilter/nf_tables.h>
+#include <linux/indirect_call_wrapper.h>
 
 extern struct nft_expr_type nft_imm_type;
 extern struct nft_expr_type nft_cmp_type;
@@ -88,12 +89,34 @@ extern const struct nft_set_type nft_set_bitmap_type;
 extern const struct nft_set_type nft_set_pipapo_type;
 extern const struct nft_set_type nft_set_pipapo_avx2_type;
 
+#ifdef CONFIG_RETPOLINE
+bool nft_rhash_lookup(const struct net *net, const struct nft_set *set,
+		      const u32 *key, const struct nft_set_ext **ext);
+bool nft_rbtree_lookup(const struct net *net, const struct nft_set *set,
+		       const u32 *key, const struct nft_set_ext **ext);
+bool nft_bitmap_lookup(const struct net *net, const struct nft_set *set,
+		       const u32 *key, const struct nft_set_ext **ext);
+bool nft_hash_lookup_fast(const struct net *net,
+			  const struct nft_set *set,
+			  const u32 *key, const struct nft_set_ext **ext);
+bool nft_hash_lookup(const struct net *net, const struct nft_set *set,
+		     const u32 *key, const struct nft_set_ext **ext);
+bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
+			    const u32 *key, const struct nft_set_ext **ext);
+bool nft_set_do_lookup(const struct net *net, const struct nft_set *set,
+		       const u32 *key, const struct nft_set_ext **ext);
+#else
 static inline bool
 nft_set_do_lookup(const struct net *net, const struct nft_set *set,
 		  const u32 *key, const struct nft_set_ext **ext)
 {
 	return set->ops->lookup(net, set, key, ext);
 }
+#endif
+
+/* called from nft_pipapo.c */
+bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
+			    const u32 *key, const struct nft_set_ext **ext);
 
 struct nft_expr;
 struct nft_regs;
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 1a8581879af5..90becbf5bff3 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -23,6 +23,37 @@ struct nft_lookup {
 	struct nft_set_binding		binding;
 };
 
+#ifdef CONFIG_RETPOLINE
+bool nft_set_do_lookup(const struct net *net, const struct nft_set *set,
+		       const u32 *key, const struct nft_set_ext **ext)
+{
+	if (set->ops == &nft_set_hash_fast_type.ops)
+		return nft_hash_lookup_fast(net, set, key, ext);
+	if (set->ops == &nft_set_hash_type.ops)
+		return nft_hash_lookup(net, set, key, ext);
+
+	if (set->ops == &nft_set_rhash_type.ops)
+		return nft_rhash_lookup(net, set, key, ext);
+
+	if (set->ops == &nft_set_bitmap_type.ops)
+		return nft_bitmap_lookup(net, set, key, ext);
+
+	if (set->ops == &nft_set_pipapo_type.ops)
+		return nft_pipapo_lookup(net, set, key, ext);
+#if defined(CONFIG_X86_64) && !defined(CONFIG_UML)
+	if (set->ops == &nft_set_pipapo_avx2_type.ops)
+		return nft_pipapo_avx2_lookup(net, set, key, ext);
+#endif
+
+	if (set->ops == &nft_set_rbtree_type.ops)
+		return nft_rbtree_lookup(net, set, key, ext);
+
+	WARN_ON_ONCE(1);
+	return set->ops->lookup(net, set, key, ext);
+}
+EXPORT_SYMBOL_GPL(nft_set_do_lookup);
+#endif
+
 void nft_lookup_eval(const struct nft_expr *expr,
 		     struct nft_regs *regs,
 		     const struct nft_pktinfo *pkt)
diff --git a/net/netfilter/nft_set_bitmap.c b/net/netfilter/nft_set_bitmap.c
index 2a81ea421819..e7ae5914971e 100644
--- a/net/netfilter/nft_set_bitmap.c
+++ b/net/netfilter/nft_set_bitmap.c
@@ -73,8 +73,9 @@ nft_bitmap_active(const u8 *bitmap, u32 idx, u32 off, u8 genmask)
 	return (bitmap[idx] & (0x3 << off)) & (genmask << off);
 }
 
-static bool nft_bitmap_lookup(const struct net *net, const struct nft_set *set,
-			      const u32 *key, const struct nft_set_ext **ext)
+INDIRECT_CALLABLE_SCOPE
+bool nft_bitmap_lookup(const struct net *net, const struct nft_set *set,
+		       const u32 *key, const struct nft_set_ext **ext)
 {
 	const struct nft_bitmap *priv = nft_set_priv(set);
 	u8 genmask = nft_genmask_cur(net);
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 7b3d0a78c569..df40314de21f 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -74,8 +74,9 @@ static const struct rhashtable_params nft_rhash_params = {
 	.automatic_shrinking	= true,
 };
 
-static bool nft_rhash_lookup(const struct net *net, const struct nft_set *set,
-			     const u32 *key, const struct nft_set_ext **ext)
+INDIRECT_CALLABLE_SCOPE
+bool nft_rhash_lookup(const struct net *net, const struct nft_set *set,
+		      const u32 *key, const struct nft_set_ext **ext)
 {
 	struct nft_rhash *priv = nft_set_priv(set);
 	const struct nft_rhash_elem *he;
@@ -446,8 +447,9 @@ struct nft_hash_elem {
 	struct nft_set_ext		ext;
 };
 
-static bool nft_hash_lookup(const struct net *net, const struct nft_set *set,
-			    const u32 *key, const struct nft_set_ext **ext)
+INDIRECT_CALLABLE_SCOPE
+bool nft_hash_lookup(const struct net *net, const struct nft_set *set,
+		     const u32 *key, const struct nft_set_ext **ext)
 {
 	struct nft_hash *priv = nft_set_priv(set);
 	u8 genmask = nft_genmask_cur(net);
@@ -484,9 +486,10 @@ static void *nft_hash_get(const struct net *net, const struct nft_set *set,
 	return ERR_PTR(-ENOENT);
 }
 
-static bool nft_hash_lookup_fast(const struct net *net,
-				 const struct nft_set *set,
-				 const u32 *key, const struct nft_set_ext **ext)
+INDIRECT_CALLABLE_SCOPE
+bool nft_hash_lookup_fast(const struct net *net,
+			  const struct nft_set *set,
+			  const u32 *key, const struct nft_set_ext **ext)
 {
 	struct nft_hash *priv = nft_set_priv(set);
 	u8 genmask = nft_genmask_cur(net);
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 528a2d7ca991..9addc0b447f7 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -408,8 +408,9 @@ int pipapo_refill(unsigned long *map, int len, int rules, unsigned long *dst,
  *
  * Return: true on match, false otherwise.
  */
-static bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
-			      const u32 *key, const struct nft_set_ext **ext)
+INDIRECT_CALLABLE_SCOPE
+bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
+		       const u32 *key, const struct nft_set_ext **ext)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
 	unsigned long *res_map, *fill_map;
diff --git a/net/netfilter/nft_set_pipapo_avx2.h b/net/netfilter/nft_set_pipapo_avx2.h
index 394bcb704db7..dbb6aaca8a7a 100644
--- a/net/netfilter/nft_set_pipapo_avx2.h
+++ b/net/netfilter/nft_set_pipapo_avx2.h
@@ -5,8 +5,6 @@
 #include <asm/fpu/xstate.h>
 #define NFT_PIPAPO_ALIGN	(XSAVE_YMM_SIZE / BITS_PER_BYTE)
 
-bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
-			    const u32 *key, const struct nft_set_ext **ext);
 bool nft_pipapo_avx2_estimate(const struct nft_set_desc *desc, u32 features,
 			      struct nft_set_estimate *est);
 #endif /* defined(CONFIG_X86_64) && !defined(CONFIG_UML) */
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 9e36eb4a7429..d600a566da32 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -107,8 +107,9 @@ static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set
 	return false;
 }
 
-static bool nft_rbtree_lookup(const struct net *net, const struct nft_set *set,
-			      const u32 *key, const struct nft_set_ext **ext)
+INDIRECT_CALLABLE_SCOPE
+bool nft_rbtree_lookup(const struct net *net, const struct nft_set *set,
+		       const u32 *key, const struct nft_set_ext **ext)
 {
 	struct nft_rbtree *priv = nft_set_priv(set);
 	unsigned int seq = read_seqcount_begin(&priv->count);
-- 
2.26.3

