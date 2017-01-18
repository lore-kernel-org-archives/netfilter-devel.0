From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 6/7] netfilter: nf_tables: add space notation to sets
Date: Wed, 18 Jan 2017 18:30:12 +0100
Message-ID: <1484760613-17236-7-git-send-email-pablo@netfilter.org>
References: <1484760613-17236-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36678 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752595AbdARRa1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2017 12:30:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 782711392AE
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 18:30:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 65C85A7BF0
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 18:30:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 596B1A825E
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 18:30:22 +0100 (CET)
In-Reply-To: <1484760613-17236-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The space notation allows us to classify the set backend implementation
based on the amount of required memory. This provides an order of the
set representation scalability in terms of memory. The size field is
still left in place so use this if the userspace provides no explicit
number of elements, so we cannot calculate the real memory that this set
needs. This also helps us break ties in the set backend selection
routine, eg. two backend implementations provide the same performance.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c     | 22 +++++++++++++++++-----
 net/netfilter/nft_set_hash.c      |  1 +
 net/netfilter/nft_set_rbtree.c    |  1 +
 4 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 9256a3cba5fe..6f0d087a8c67 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -245,10 +245,12 @@ enum nft_set_class {
  *
  *	@size: required memory
  *	@lookup: lookup performance class
+ *	@space: memory class
  */
 struct nft_set_estimate {
 	unsigned int		size;
 	enum nft_set_class	lookup;
+	enum nft_set_class	space;
 };
 
 struct nft_set_ext;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4f18c027163e..e5c35a222280 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2403,6 +2403,7 @@ nft_select_set_ops(const struct nlattr * const nla[],
 	bops	    = NULL;
 	best.size   = ~0;
 	best.lookup = ~0;
+	best.space  = ~0;
 
 	list_for_each_entry(ops, &nf_tables_set_ops, list) {
 		if ((ops->features & features) != features)
@@ -2414,14 +2415,25 @@ nft_select_set_ops(const struct nlattr * const nla[],
 		case NFT_SET_POL_PERFORMANCE:
 			if (est.lookup < best.lookup)
 				break;
-			if (est.lookup == best.lookup && est.size < best.size)
-				break;
+			if (est.lookup == best.lookup) {
+				if (!desc->size) {
+					if (est.space < best.space)
+						break;
+				} else if (est.size < best.size) {
+					break;
+				}
+			}
 			continue;
 		case NFT_SET_POL_MEMORY:
-			if (est.size < best.size)
-				break;
-			if (est.size == best.size && est.lookup < best.lookup)
+			if (!desc->size) {
+				if (est.space < best.space)
+					break;
+				if (est.space == best.space &&
+				    est.lookup < best.lookup)
+					break;
+			} else if (est.size < best.size) {
 				break;
+			}
 			continue;
 		default:
 			break;
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 2c96bdeb186f..0520b1b9e06f 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -385,6 +385,7 @@ static bool nft_hash_estimate(const struct nft_set_desc *desc, u32 features,
 	}
 
 	est->lookup = NFT_SET_CLASS_O_1;
+	est->space  = NFT_SET_CLASS_O_N;
 
 	return true;
 }
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 9b3ec6a3be2c..47f7cd2b764f 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -292,6 +292,7 @@ static bool nft_rbtree_estimate(const struct nft_set_desc *desc, u32 features,
 		est->size = nsize;
 
 	est->lookup = NFT_SET_CLASS_O_LOG_N;
+	est->space  = NFT_SET_CLASS_O_N;
 
 	return true;
 }
-- 
2.1.4

