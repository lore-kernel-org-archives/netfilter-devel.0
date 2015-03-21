From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 5/5] netfilter: nft_hash: indent rhashtable parameters
Date: Sat, 21 Mar 2015 15:19:18 +0000
Message-ID: <1426951158-18168-6-git-send-email-kaber@trash.net>
References: <1426951158-18168-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46430 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbbCUPTZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Mar 2015 11:19:25 -0400
In-Reply-To: <1426951158-18168-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Improve readability by indenting the parameter initialization.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nft_hash.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index 80a6a6d..e815940 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -171,9 +171,9 @@ static unsigned int nft_hash_privsize(const struct nlattr * const nla[])
 }
 
 static const struct rhashtable_params nft_hash_params = {
-	.head_offset = offsetof(struct nft_hash_elem, node),
-	.key_offset = offsetof(struct nft_hash_elem, key),
-	.hashfn = jhash,
+	.head_offset	= offsetof(struct nft_hash_elem, node),
+	.key_offset	= offsetof(struct nft_hash_elem, key),
+	.hashfn		= jhash,
 };
 
 static int nft_hash_init(const struct nft_set *set,
@@ -184,7 +184,7 @@ static int nft_hash_init(const struct nft_set *set,
 	struct rhashtable_params params = nft_hash_params;
 
 	params.nelem_hint = desc->size ?: NFT_HASH_ELEMENT_HINT;
-	params.key_len = set->klen;
+	params.key_len	  = set->klen;
 
 	return rhashtable_init(&priv->ht, &params);
 }
-- 
2.1.0

