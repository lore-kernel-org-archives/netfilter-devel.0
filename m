From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 5/7] netfilter: nf_tables: rename struct nft_set_estimate class field
Date: Wed, 18 Jan 2017 18:30:11 +0100
Message-ID: <1484760613-17236-6-git-send-email-pablo@netfilter.org>
References: <1484760613-17236-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36664 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752592AbdARRa0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2017 12:30:26 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E84621392A4
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 18:30:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D4BAAA7BF0
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 18:30:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8EA89FF123
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 18:30:21 +0100 (CET)
In-Reply-To: <1484760613-17236-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use lookup as field name instead, to prepare the introduction of the
memory class in a follow up patch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  4 ++--
 net/netfilter/nf_tables_api.c     | 12 ++++++------
 net/netfilter/nft_set_hash.c      |  2 +-
 net/netfilter/nft_set_rbtree.c    |  2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index deff701137e8..9256a3cba5fe 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -244,11 +244,11 @@ enum nft_set_class {
  *				  characteristics
  *
  *	@size: required memory
- *	@class: lookup performance class
+ *	@lookup: lookup performance class
  */
 struct nft_set_estimate {
 	unsigned int		size;
-	enum nft_set_class	class;
+	enum nft_set_class	lookup;
 };
 
 struct nft_set_ext;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b5f6cb70d3df..4f18c027163e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2400,9 +2400,9 @@ nft_select_set_ops(const struct nlattr * const nla[],
 		features &= NFT_SET_INTERVAL | NFT_SET_MAP | NFT_SET_TIMEOUT;
 	}
 
-	bops	   = NULL;
-	best.size  = ~0;
-	best.class = ~0;
+	bops	    = NULL;
+	best.size   = ~0;
+	best.lookup = ~0;
 
 	list_for_each_entry(ops, &nf_tables_set_ops, list) {
 		if ((ops->features & features) != features)
@@ -2412,15 +2412,15 @@ nft_select_set_ops(const struct nlattr * const nla[],
 
 		switch (policy) {
 		case NFT_SET_POL_PERFORMANCE:
-			if (est.class < best.class)
+			if (est.lookup < best.lookup)
 				break;
-			if (est.class == best.class && est.size < best.size)
+			if (est.lookup == best.lookup && est.size < best.size)
 				break;
 			continue;
 		case NFT_SET_POL_MEMORY:
 			if (est.size < best.size)
 				break;
-			if (est.size == best.size && est.class < best.class)
+			if (est.size == best.size && est.lookup < best.lookup)
 				break;
 			continue;
 		default:
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index f9e69e8a8dc3..2c96bdeb186f 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -384,7 +384,7 @@ static bool nft_hash_estimate(const struct nft_set_desc *desc, u32 features,
 		est->size = esize + 2 * sizeof(struct nft_hash_elem *);
 	}
 
-	est->class = NFT_SET_CLASS_O_1;
+	est->lookup = NFT_SET_CLASS_O_1;
 
 	return true;
 }
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 46504c2c65d7..9b3ec6a3be2c 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -291,7 +291,7 @@ static bool nft_rbtree_estimate(const struct nft_set_desc *desc, u32 features,
 	else
 		est->size = nsize;
 
-	est->class = NFT_SET_CLASS_O_LOG_N;
+	est->lookup = NFT_SET_CLASS_O_LOG_N;
 
 	return true;
 }
-- 
2.1.4

