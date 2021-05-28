Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AD91C47087
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 May 2021 22:53:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DDA7611F0
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 May 2021 22:53:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbhE1Wyc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 May 2021 18:54:32 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60892 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbhE1Wya (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 May 2021 18:54:30 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 866276439D;
        Sat, 29 May 2021 00:51:50 +0200 (CEST)
Date:   Sat, 29 May 2021 00:52:51 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     kernel test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [nf-next:master 4/14] net/netfilter/nft_set_pipapo.c:412:6:
 error: static declaration of 'nft_pipapo_lookup' follows non-static
 declaration
Message-ID: <20210528225251.GA28391@salvia>
References: <202105290441.yixDLttm-lkp@intel.com>
 <20210528213001.GA10732@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
In-Reply-To: <20210528213001.GA10732@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Fri, May 28, 2021 at 11:30:01PM +0200, Florian Westphal wrote:
> kernel test robot <lkp@intel.com> wrote:
> > All errors (new ones prefixed by >>):
> > 
> > >> net/netfilter/nft_set_pipapo.c:412:6: error: static declaration of 'nft_pipapo_lookup' follows non-static declaration
> >      412 | bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
> >          |      ^~~~~~~~~~~~~~~~~
> >    In file included from net/netfilter/nft_set_pipapo.c:343:
> >    net/netfilter/nft_set_pipapo.h:181:6: note: previous declaration of 'nft_pipapo_lookup' was here
> >      181 | bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
> >          |      ^~~~~~~~~~~~~~~~~
> > 
> > 
> > vim +/nft_pipapo_lookup +412 net/netfilter/nft_set_pipapo.c
> > 
> > 3c4287f62044a9 Stefano Brivio   2020-01-22  399  
> > 3c4287f62044a9 Stefano Brivio   2020-01-22  400  /**
> > 3c4287f62044a9 Stefano Brivio   2020-01-22  401   * nft_pipapo_lookup() - Lookup function
> > 3c4287f62044a9 Stefano Brivio   2020-01-22  402   * @net:	Network namespace
> > 3c4287f62044a9 Stefano Brivio   2020-01-22  403   * @set:	nftables API set representation
> > 3db86c397f608b Andrew Lunn      2020-07-13  404   * @key:	nftables API element representation containing key data
> > 3c4287f62044a9 Stefano Brivio   2020-01-22  405   * @ext:	nftables API extension pointer, filled with matching reference
> > 3c4287f62044a9 Stefano Brivio   2020-01-22  406   *
> > 3c4287f62044a9 Stefano Brivio   2020-01-22  407   * For more details, see DOC: Theory of Operation.
> > 3c4287f62044a9 Stefano Brivio   2020-01-22  408   *
> > 3c4287f62044a9 Stefano Brivio   2020-01-22  409   * Return: true on match, false otherwise.
> > 3c4287f62044a9 Stefano Brivio   2020-01-22  410   */
> > a890630241c76a Florian Westphal 2021-05-13  411  INDIRECT_CALLABLE_SCOPE
> 
> This line needs to be dropped after the nf merge.

And

bool nft_pipapo_lookup(...)

needs to be moved away from #ifdef CONFIG_RETPOLINE in
nf_tables_core.h

I'm attaching the patch I have here after this changes.

However, this is exacty what Stephen Rothwell suggested to fix but
Stefano mentioned this is not the right fix...

--jI8keyz6grp/JLjh
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="0001-netfilter-nf_tables-prefer-direct-calls-for-set-look.patch"

From 4fdcdd409dda1b2cd96d763cf614ef44772167e3 Mon Sep 17 00:00:00 2001
From: Florian Westphal <fw@strlen.de>
Date: Thu, 13 May 2021 22:29:56 +0200
Subject: [PATCH] netfilter: nf_tables: prefer direct calls for set lookups

Extend nft_set_do_lookup() to use direct calls when retpoline feature
is enabled.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables_core.h | 24 ++++++++++++++++++++
 net/netfilter/nft_lookup.c             | 31 ++++++++++++++++++++++++++
 net/netfilter/nft_set_bitmap.c         |  5 +++--
 net/netfilter/nft_set_hash.c           | 17 ++++++++------
 net/netfilter/nft_set_pipapo.h         |  2 --
 net/netfilter/nft_set_pipapo_avx2.h    |  2 --
 net/netfilter/nft_set_rbtree.c         |  5 +++--
 7 files changed, 71 insertions(+), 15 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 5eb699454490..c75bc6e83d9c 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -3,6 +3,7 @@
 #define _NET_NF_TABLES_CORE_H
 
 #include <net/netfilter/nf_tables.h>
+#include <linux/indirect_call_wrapper.h>
 
 extern struct nft_expr_type nft_imm_type;
 extern struct nft_expr_type nft_cmp_type;
@@ -88,12 +89,35 @@ extern const struct nft_set_type nft_set_bitmap_type;
 extern const struct nft_set_type nft_set_pipapo_type;
 extern const struct nft_set_type nft_set_pipapo_avx2_type;
 
+bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
+		       const u32 *key, const struct nft_set_ext **ext);
+
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
diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipapo.h
index d84afb8fa79a..25a75591583e 100644
--- a/net/netfilter/nft_set_pipapo.h
+++ b/net/netfilter/nft_set_pipapo.h
@@ -178,8 +178,6 @@ struct nft_pipapo_elem {
 
 int pipapo_refill(unsigned long *map, int len, int rules, unsigned long *dst,
 		  union nft_pipapo_map_bucket *mt, bool match_only);
-bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
-		       const u32 *key, const struct nft_set_ext **ext);
 
 /**
  * pipapo_and_field_buckets_4bit() - Intersect 4-bit buckets
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
2.30.2


--jI8keyz6grp/JLjh--
