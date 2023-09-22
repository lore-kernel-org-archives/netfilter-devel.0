Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36787CD4853
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Sep 2023 17:01:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbjIVRBg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Sep 2023 13:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232697AbjIVRBf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Sep 2023 13:01:35 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 93A421A1;
        Fri, 22 Sep 2023 10:01:28 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        sashal@kernel.org
Subject: [PATCH -stable,5.10 07/17] netfilter: nf_tables: don't fail inserts if duplicate has expired
Date:   Fri, 22 Sep 2023 19:01:08 +0200
Message-Id: <20230922170118.152420-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230922170118.152420-1-pablo@netfilter.org>
References: <20230922170118.152420-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 7845914f45f066497ac75b30c50dbc735e84e884 upstream.

nftables selftests fail:
run-tests.sh testcases/sets/0044interval_overlap_0
Expected: 0-2 . 0-3, got:
W: [FAILED]     ./testcases/sets/0044interval_overlap_0: got 1

Insertion must ignore duplicate but expired entries.

Moreover, there is a strange asymmetry in nft_pipapo_activate:

It refetches the current element, whereas the other ->activate callbacks
(bitmap, hash, rhash, rbtree) use elem->priv.
Same for .remove: other set implementations take elem->priv,
nft_pipapo_remove fetches elem->priv, then does a relookup,
remove this.

I suspect this was the reason for the change that prompted the
removal of the expired check in pipapo_get() in the first place,
but skipping exired elements there makes no sense to me, this helper
is used for normal get requests, insertions (duplicate check)
and deactivate callback.

In first two cases expired elements must be skipped.

For ->deactivate(), this gets called for DELSETELEM, so it
seems to me that expired elements should be skipped as well, i.e.
delete request should fail with -ENOENT error.

Fixes: 24138933b97b ("netfilter: nf_tables: don't skip expired elements during walk")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo.c | 25 +++++--------------------
 1 file changed, 5 insertions(+), 20 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 63d0723950d3..80440ac5d44c 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -566,6 +566,8 @@ static struct nft_pipapo_elem *pipapo_get(const struct net *net,
 			goto out;
 
 		if (last) {
+			if (nft_set_elem_expired(&f->mt[b].e->ext))
+				goto next_match;
 			if ((genmask &&
 			     !nft_set_elem_active(&f->mt[b].e->ext, genmask)))
 				goto next_match;
@@ -600,17 +602,8 @@ static struct nft_pipapo_elem *pipapo_get(const struct net *net,
 static void *nft_pipapo_get(const struct net *net, const struct nft_set *set,
 			    const struct nft_set_elem *elem, unsigned int flags)
 {
-	struct nft_pipapo_elem *ret;
-
-	ret = pipapo_get(net, set, (const u8 *)elem->key.val.data,
-			 nft_genmask_cur(net));
-	if (IS_ERR(ret))
-		return ret;
-
-	if (nft_set_elem_expired(&ret->ext))
-		return ERR_PTR(-ENOENT);
-
-	return ret;
+	return pipapo_get(net, set, (const u8 *)elem->key.val.data,
+			  nft_genmask_cur(net));
 }
 
 /**
@@ -1737,11 +1730,7 @@ static void nft_pipapo_activate(const struct net *net,
 				const struct nft_set *set,
 				const struct nft_set_elem *elem)
 {
-	struct nft_pipapo_elem *e;
-
-	e = pipapo_get(net, set, (const u8 *)elem->key.val.data, 0);
-	if (IS_ERR(e))
-		return;
+	struct nft_pipapo_elem *e = elem->priv;
 
 	nft_set_elem_change_active(net, set, &e->ext);
 }
@@ -1955,10 +1944,6 @@ static void nft_pipapo_remove(const struct net *net, const struct nft_set *set,
 
 	data = (const u8 *)nft_set_ext_key(&e->ext);
 
-	e = pipapo_get(net, set, data, 0);
-	if (IS_ERR(e))
-		return;
-
 	while ((rules_f0 = pipapo_rules_same_key(m->f, first_rule))) {
 		union nft_pipapo_map_bucket rulemap[NFT_PIPAPO_MAX_FIELDS];
 		const u8 *match_start, *match_end;
-- 
2.30.2

