Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FD2DC61DA7
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Nov 2023 12:13:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234206AbjKUMNu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Nov 2023 07:13:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234609AbjKUMNt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Nov 2023 07:13:49 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C5FD112C;
        Tue, 21 Nov 2023 04:13:45 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Subject: [PATCH -stable,5.4 07/26] netfilter: nf_tables: don't skip expired elements during walk
Date:   Tue, 21 Nov 2023 13:13:14 +0100
Message-Id: <20231121121333.294238-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231121121333.294238-1-pablo@netfilter.org>
References: <20231121121333.294238-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 24138933b97b055d486e8064b4a1721702442a9b upstream.

There is an asymmetry between commit/abort and preparation phase if the
following conditions are met:

1. set is a verdict map ("1.2.3.4 : jump foo")
2. timeouts are enabled

In this case, following sequence is problematic:

1. element E in set S refers to chain C
2. userspace requests removal of set S
3. kernel does a set walk to decrement chain->use count for all elements
   from preparation phase
4. kernel does another set walk to remove elements from the commit phase
   (or another walk to do a chain->use increment for all elements from
    abort phase)

If E has already expired in 1), it will be ignored during list walk, so its use count
won't have been changed.

Then, when set is culled, ->destroy callback will zap the element via
nf_tables_set_elem_destroy(), but this function is only safe for
elements that have been deactivated earlier from the preparation phase:
lack of earlier deactivate removes the element but leaks the chain use
count, which results in a WARN splat when the chain gets removed later,
plus a leak of the nft_chain structure.

Update pipapo_get() not to skip expired elements, otherwise flush
command reports bogus ENOENT errors.

Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Fixes: 8d8540c4f5e0 ("netfilter: nft_set_rbtree: add timeout support")
Fixes: 9d0982927e79 ("netfilter: nft_hash: add support for timeouts")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c  | 4 ++++
 net/netfilter/nft_set_hash.c   | 2 --
 net/netfilter/nft_set_rbtree.c | 2 --
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 6e1fa13d37c0..18dc926d552e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4258,8 +4258,12 @@ static int nf_tables_dump_setelem(const struct nft_ctx *ctx,
 				  const struct nft_set_iter *iter,
 				  struct nft_set_elem *elem)
 {
+	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
 	struct nft_set_dump_args *args;
 
+	if (nft_set_elem_expired(ext))
+		return 0;
+
 	args = container_of(iter, struct nft_set_dump_args, iter);
 	return nf_tables_fill_setelem(args->skb, set, elem);
 }
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 7f66eeb97947..34ab10847b93 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -277,8 +277,6 @@ static void nft_rhash_walk(const struct nft_ctx *ctx, struct nft_set *set,
 
 		if (iter->count < iter->skip)
 			goto cont;
-		if (nft_set_elem_expired(&he->ext))
-			goto cont;
 		if (!nft_set_elem_active(&he->ext, iter->genmask))
 			goto cont;
 
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index f456db3d786d..03264f63064f 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -553,8 +553,6 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
 
 		if (iter->count < iter->skip)
 			goto cont;
-		if (nft_set_elem_expired(&rbe->ext))
-			goto cont;
 		if (!nft_set_elem_active(&rbe->ext, iter->genmask))
 			goto cont;
 
-- 
2.30.2

