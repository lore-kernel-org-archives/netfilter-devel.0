From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 3/4] netfilter: nft_rbtree: introduce nft_rbtree_interval_end() helper
Date: Tue, 12 Apr 2016 23:50:36 +0200
Message-ID: <1460497837-20693-4-git-send-email-pablo@netfilter.org>
References: <1460497837-20693-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59309 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933716AbcDLVuv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2016 17:50:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id AA9C8E666E
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2016 23:50:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 90D08D1D81
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2016 23:50:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0B5DBD1D81
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2016 23:50:47 +0200 (CEST)
In-Reply-To: <1460497837-20693-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add this new nft_rbtree_interval_end() helper function to check in the
end interval is set.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_rbtree.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_rbtree.c b/net/netfilter/nft_rbtree.c
index 1c30f41..29f2ab8 100644
--- a/net/netfilter/nft_rbtree.c
+++ b/net/netfilter/nft_rbtree.c
@@ -29,6 +29,11 @@ struct nft_rbtree_elem {
 	struct nft_set_ext	ext;
 };
 
+static bool nft_rbtree_interval_end(const struct nft_rbtree_elem *rbe)
+{
+	return nft_set_ext_exists(&rbe->ext, NFT_SET_EXT_FLAGS) &&
+	       (*nft_set_ext_flags(&rbe->ext) & NFT_SET_ELEM_INTERVAL_END);
+}
 
 static bool nft_rbtree_lookup(const struct nft_set *set, const u32 *key,
 			      const struct nft_set_ext **ext)
@@ -56,9 +61,7 @@ found:
 				parent = parent->rb_left;
 				continue;
 			}
-			if (nft_set_ext_exists(&rbe->ext, NFT_SET_EXT_FLAGS) &&
-			    *nft_set_ext_flags(&rbe->ext) &
-			    NFT_SET_ELEM_INTERVAL_END)
+			if (nft_rbtree_interval_end(rbe))
 				goto out;
 			spin_unlock_bh(&nft_rbtree_lock);
 
-- 
2.1.4

