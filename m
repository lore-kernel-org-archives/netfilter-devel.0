From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] netfilter: nft_set_bitmap: incorrect bitmap size
Date: Sun, 26 Feb 2017 21:01:53 +0100
Message-ID: <1488139313-1119-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48484 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751253AbdBZUKW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Feb 2017 15:10:22 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 36028ED90E
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Feb 2017 21:02:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1E43ADA725
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Feb 2017 21:02:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7BE5DDA725
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Feb 2017 21:01:58 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

priv->bitmap_size stores the real bitmap size, instead of the full
struct nft_bitmap object.

Fixes: 665153ff5752 ("netfilter: nf_tables: add bitmap set type")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_bitmap.c b/net/netfilter/nft_set_bitmap.c
index 97f9649bcc7e..152d226552c1 100644
--- a/net/netfilter/nft_set_bitmap.c
+++ b/net/netfilter/nft_set_bitmap.c
@@ -258,7 +258,7 @@ static int nft_bitmap_init(const struct nft_set *set,
 {
 	struct nft_bitmap *priv = nft_set_priv(set);
 
-	priv->bitmap_size = nft_bitmap_total_size(set->klen);
+	priv->bitmap_size = nft_bitmap_size(set->klen);
 
 	return 0;
 }
-- 
2.1.4

