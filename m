From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6/6] netfilter: nft_set_bitmap: incorrect bitmap size
Date: Mon, 27 Feb 2017 12:35:42 +0100
Message-ID: <1488195342-2678-7-git-send-email-pablo@netfilter.org>
References: <1488195342-2678-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48542 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752059AbdB0Lgo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Feb 2017 06:36:44 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6A2C8E63F
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Feb 2017 12:36:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5A422DA804
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Feb 2017 12:36:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 420D1DA81A
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Feb 2017 12:35:58 +0100 (CET)
In-Reply-To: <1488195342-2678-1-git-send-email-pablo@netfilter.org>
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

