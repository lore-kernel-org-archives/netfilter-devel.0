From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 06/21] netfilter: nf_tables: rename struct nft_set_estimate class field
Date: Sun, 12 Feb 2017 20:42:38 +0100
Message-ID: <1486928573-24773-7-git-send-email-pablo@netfilter.org>
References: <1486928573-24773-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1486928573-24773-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

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
index 5830f594842e..d76ac2f80a40 100644
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
index 7ae810b03462..fa7cd1679079 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2401,9 +2401,9 @@ nft_select_set_ops(const struct nlattr * const nla[],
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
@@ -2413,15 +2413,15 @@ nft_select_set_ops(const struct nlattr * const nla[],
 
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
index 2f10ac3b1b10..e58e7f02138b 100644
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
index 81b8a4c2c061..2b6ea10c4bbd 100644
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
