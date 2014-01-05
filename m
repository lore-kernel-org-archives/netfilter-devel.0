From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/3] netfilter: nft_hash: use set->maxelems to calculate number of buckets
Date: Sun,  5 Jan 2014 22:18:48 +0100
Message-ID: <1388956728-6754-4-git-send-email-pablo@netfilter.org>
References: <1388956728-6754-1-git-send-email-pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52014 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbaAEVTB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jan 2014 16:19:01 -0500
In-Reply-To: <1388956728-6754-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use set->maxelems to calculate the number of buckets that holds a
load factor of 0.75.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_hash.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index f640c1c..99e4742 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -169,9 +169,7 @@ static int nft_hash_init(const struct nft_set *set,
 	}
 
 	/* Aim for a load factor of 0.75 */
-	// FIXME: temporarily broken until we have set descriptions
-	cnt = 100;
-	cnt = cnt * 4 / 3;
+	cnt = set->maxelems * 4 / 3;
 
 	priv->hash = kcalloc(cnt, sizeof(struct hlist_head), GFP_KERNEL);
 	if (priv->hash == NULL)
-- 
1.7.10.4

