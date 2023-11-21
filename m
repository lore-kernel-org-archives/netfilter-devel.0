Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85625C61D9B
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Nov 2023 12:13:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234606AbjKUMNs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Nov 2023 07:13:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233940AbjKUMNs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Nov 2023 07:13:48 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9327C13D;
        Tue, 21 Nov 2023 04:13:44 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Subject: [PATCH -stable,5.4 05/26] netfilter: nft_set_rbtree: fix null deref on element insertion
Date:   Tue, 21 Nov 2023 13:13:12 +0100
Message-Id: <20231121121333.294238-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231121121333.294238-1-pablo@netfilter.org>
References: <20231121121333.294238-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 61ae320a29b0540c16931816299eb86bf2b66c08 upstream.

There is no guarantee that rb_prev() will not return NULL in nft_rbtree_gc_elem():

general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
 nft_add_set_elem+0x14b0/0x2990
  nf_tables_newsetelem+0x528/0xb30

Furthermore, there is a possible use-after-free while iterating,
'node' can be free'd so we need to cache the next value to use.

Fixes: c9e6978e2725 ("netfilter: nft_set_rbtree: Switch to node list walk for overlap detection")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_rbtree.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 039c75e27e1b..928288138a51 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -220,7 +220,7 @@ static int nft_rbtree_gc_elem(const struct nft_set *__set,
 {
 	struct nft_set *set = (struct nft_set *)__set;
 	struct rb_node *prev = rb_prev(&rbe->node);
-	struct nft_rbtree_elem *rbe_prev;
+	struct nft_rbtree_elem *rbe_prev = NULL;
 	struct nft_set_gc_batch *gcb;
 
 	gcb = nft_set_gc_batch_check(set, NULL, GFP_ATOMIC);
@@ -228,17 +228,21 @@ static int nft_rbtree_gc_elem(const struct nft_set *__set,
 		return -ENOMEM;
 
 	/* search for expired end interval coming before this element. */
-	do {
+	while (prev) {
 		rbe_prev = rb_entry(prev, struct nft_rbtree_elem, node);
 		if (nft_rbtree_interval_end(rbe_prev))
 			break;
 
 		prev = rb_prev(prev);
-	} while (prev != NULL);
+	}
+
+	if (rbe_prev) {
+		rb_erase(&rbe_prev->node, &priv->root);
+		atomic_dec(&set->nelems);
+	}
 
-	rb_erase(&rbe_prev->node, &priv->root);
 	rb_erase(&rbe->node, &priv->root);
-	atomic_sub(2, &set->nelems);
+	atomic_dec(&set->nelems);
 
 	nft_set_gc_batch_add(gcb, rbe);
 	nft_set_gc_batch_complete(gcb);
@@ -267,7 +271,7 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			       struct nft_set_ext **ext)
 {
 	struct nft_rbtree_elem *rbe, *rbe_le = NULL, *rbe_ge = NULL;
-	struct rb_node *node, *parent, **p, *first = NULL;
+	struct rb_node *node, *next, *parent, **p, *first = NULL;
 	struct nft_rbtree *priv = nft_set_priv(set);
 	u8 genmask = nft_genmask_next(net);
 	int d, err;
@@ -306,7 +310,9 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	 * Values stored in the tree are in reversed order, starting from
 	 * highest to lowest value.
 	 */
-	for (node = first; node != NULL; node = rb_next(node)) {
+	for (node = first; node != NULL; node = next) {
+		next = rb_next(node);
+
 		rbe = rb_entry(node, struct nft_rbtree_elem, node);
 
 		if (!nft_set_elem_active(&rbe->ext, genmask))
-- 
2.30.2

