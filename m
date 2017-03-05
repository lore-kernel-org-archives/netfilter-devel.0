From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf 2/2] netfilter: nft_set_bitmap: fix memory leak
Date: Mon,  6 Mar 2017 00:02:53 +0800
Message-ID: <1488729773-48343-2-git-send-email-zlpnobody@163.com>
References: <1488729773-48343-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-15.163.com ([220.181.12.15]:60180 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752290AbdCEQDe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Mar 2017 11:03:34 -0500
In-Reply-To: <1488729773-48343-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

Unlike other set types, we will not link struct nft_set_ext into our
internal structure, so we need to free it after activation, otherwise
the nft_set_ext's memory will be leaked forever.

Also move nf_tables_setelem_notify() to the front of ops->activate, so
we will not hit the use after free error.

Fixes: 665153ff5752 ("netfilter: nf_tables: add bitmap set type")
Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/netfilter/nf_tables_api.c  | 2 +-
 net/netfilter/nft_set_bitmap.c | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5e0ccfd..5b949e0 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4809,10 +4809,10 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		case NFT_MSG_NEWSETELEM:
 			te = (struct nft_trans_elem *)trans->data;
 
-			te->set->ops->activate(net, te->set, &te->elem);
 			nf_tables_setelem_notify(&trans->ctx, te->set,
 						 &te->elem,
 						 NFT_MSG_NEWSETELEM, 0);
+			te->set->ops->activate(net, te->set, &te->elem);
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_DELSETELEM:
diff --git a/net/netfilter/nft_set_bitmap.c b/net/netfilter/nft_set_bitmap.c
index 9b024e2..dfaf299 100644
--- a/net/netfilter/nft_set_bitmap.c
+++ b/net/netfilter/nft_set_bitmap.c
@@ -127,6 +127,11 @@ static void nft_bitmap_activate(const struct net *net,
 	nft_bitmap_location(set, nft_set_ext_key(ext), &idx, &off);
 	/* Enter 11 state. */
 	priv->bitmap[idx] |= (genmask << off);
+
+	/* After the element is active in the bitmap, the dummy extension
+	 * object is not used anymore, free it now.
+	 */
+	nft_set_elem_destroy(set, ext, true);
 }
 
 static bool nft_bitmap_flush(const struct net *net,
-- 
2.5.5


