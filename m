From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nft_hash: fix nft_hash_deactivate
Date: Thu,  2 Nov 2017 19:04:47 +0100
Message-ID: <20171102180447.28064-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60242 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933025AbdKBSEb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2017 14:04:31 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jindřich Makovička says:
  The logical OR looks fishy to me. Shouldn't be && there instead?

Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1199
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 9c0d5a7ce5f9..fcd51e819d72 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -494,7 +494,7 @@ static void *nft_hash_deactivate(const struct net *net,
 	hash = reciprocal_scale(hash, priv->buckets);
 	hlist_for_each_entry(he, &priv->table[hash], node) {
 		if (!memcmp(nft_set_ext_key(&this->ext), &elem->key.val,
-			    set->klen) ||
+			    set->klen) &&
 		    nft_set_elem_active(&he->ext, genmask)) {
 			nft_set_elem_change_active(net, set, &he->ext);
 			return he;
-- 
2.13.6

