From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 3/6] netfilter: nft_hash: indent rhashtable parameters
Date: Wed, 25 Mar 2015 13:07:47 +0000
Message-ID: <1427288870-26336-4-git-send-email-kaber@trash.net>
References: <1427288870-26336-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48264 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbbCYNH4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 09:07:56 -0400
In-Reply-To: <1427288870-26336-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Improve readability by indenting the parameter initialization.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nft_hash.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index a517f84..e35f0b2 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -173,10 +173,10 @@ static unsigned int nft_hash_privsize(const struct nlattr * const nla[])
 }
 
 static const struct rhashtable_params nft_hash_params = {
-	.head_offset = offsetof(struct nft_hash_elem, node),
-	.key_offset = offsetof(struct nft_hash_elem, key),
-	.hashfn = jhash,
-	.automatic_shrinking = true,
+	.head_offset		= offsetof(struct nft_hash_elem, node),
+	.key_offset		= offsetof(struct nft_hash_elem, key),
+	.hashfn			= jhash,
+	.automatic_shrinking	= true,
 };
 
 static int nft_hash_init(const struct nft_set *set,
@@ -187,7 +187,7 @@ static int nft_hash_init(const struct nft_set *set,
 	struct rhashtable_params params = nft_hash_params;
 
 	params.nelem_hint = desc->size ?: NFT_HASH_ELEMENT_HINT;
-	params.key_len = set->klen;
+	params.key_len	  = set->klen;
 
 	return rhashtable_init(&priv->ht, &params);
 }
-- 
2.1.0

