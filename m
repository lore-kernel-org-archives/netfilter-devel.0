From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf 3/3] netfilter: nf_tables: fix race when create new element in dynset
Date: Sat, 22 Oct 2016 18:51:26 +0800
Message-ID: <1477133486-60686-4-git-send-email-zlpnobody@163.com>
References: <1477133486-60686-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:33512 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S937312AbcJVKwS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 22 Oct 2016 06:52:18 -0400
In-Reply-To: <1477133486-60686-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

Packets may race when create the new element in nft_hash_update:
       CPU0                 CPU1
  lookup_fast - fail     lookup_fast - fail
       new - ok             new - ok
     insert - ok         insert - fail(EEXIST)

So when race happened, we reuse the existing element. Otherwise,
these *racing* packets will not be handled properly.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/netfilter/nft_set_hash.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 88d9fc8..a3dface 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -98,7 +98,7 @@ static bool nft_hash_update(struct nft_set *set, const u32 *key,
 			    const struct nft_set_ext **ext)
 {
 	struct nft_hash *priv = nft_set_priv(set);
-	struct nft_hash_elem *he;
+	struct nft_hash_elem *he, *prev;
 	struct nft_hash_cmp_arg arg = {
 		.genmask = NFT_GENMASK_ANY,
 		.set	 = set,
@@ -112,9 +112,18 @@ static bool nft_hash_update(struct nft_set *set, const u32 *key,
 	he = new(set, expr, regs);
 	if (he == NULL)
 		goto err1;
-	if (rhashtable_lookup_insert_key(&priv->ht, &arg, &he->node,
-					 nft_hash_params))
+
+	prev = rhashtable_lookup_get_insert_key(&priv->ht, &arg, &he->node,
+						nft_hash_params);
+	if (IS_ERR(prev))
 		goto err2;
+
+	/* Another cpu may race to insert the element with the same key */
+	if (prev) {
+		nft_set_elem_destroy(set, he, true);
+		he = prev;
+	}
+
 out:
 	*ext = &he->ext;
 	return true;
-- 
2.5.5


