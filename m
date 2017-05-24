From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 6/9] netfilter: nft_set_hash: add nft_hash_buckets()
Date: Wed, 24 May 2017 11:50:50 +0200
Message-ID: <1495619453-22307-7-git-send-email-pablo@netfilter.org>
References: <1495619453-22307-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41514 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935851AbdEXJvx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 May 2017 05:51:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7943B1EC2CB
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 11:51:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 620AFFF6FC
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 11:51:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2ACBDFF137
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 11:51:00 +0200 (CEST)
In-Reply-To: <1495619453-22307-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add nft_hash_buckets() helper function to calculate the number of
hashtable buckets based on the elements. This function can be reused
from the follow up patch to add non-resizable hashtables.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_hash.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 455a11ce8cd0..466cb7092dfa 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -363,12 +363,17 @@ static void nft_rhash_destroy(const struct nft_set *set)
 				    (void *)set);
 }
 
+static u32 nft_hash_buckets(u32 size)
+{
+	return roundup_pow_of_two(size * 4 / 3);
+}
+
 static bool nft_rhash_estimate(const struct nft_set_desc *desc, u32 features,
 			       struct nft_set_estimate *est)
 {
 	if (desc->size)
 		est->size = sizeof(struct nft_rhash) +
-			    roundup_pow_of_two(desc->size * 4 / 3) *
+			    nft_hash_buckets(desc->size) *
 			    sizeof(struct nft_rhash_elem *) +
 			    desc->size * sizeof(struct nft_rhash_elem);
 	else
-- 
2.1.4

