From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 29/31] netfilter: nf_tables: use rhashtable_lookup() instead of rhashtable_lookup_fast()
Date: Tue,  9 Oct 2018 01:01:23 +0200
Message-ID: <20181008230125.2330-30-pablo@netfilter.org>
References: <20181008230125.2330-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181008230125.2330-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

Internally, rhashtable_lookup_fast() calls rcu_read_lock() then,
calls rhashtable_lookup(). so that in places where are guaranteed
by rcu read lock, rhashtable_lookup() is enough.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 4 ++--
 net/netfilter/nft_set_hash.c       | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index da3044482317..185c633b6872 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -233,8 +233,8 @@ flow_offload_lookup(struct nf_flowtable *flow_table,
 	struct flow_offload *flow;
 	int dir;
 
-	tuplehash = rhashtable_lookup_fast(&flow_table->rhashtable, tuple,
-					   nf_flow_offload_rhash_params);
+	tuplehash = rhashtable_lookup(&flow_table->rhashtable, tuple,
+				      nf_flow_offload_rhash_params);
 	if (!tuplehash)
 		return NULL;
 
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 4f9c01715856..339a9dd1c832 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -88,7 +88,7 @@ static bool nft_rhash_lookup(const struct net *net, const struct nft_set *set,
 		.key	 = key,
 	};
 
-	he = rhashtable_lookup_fast(&priv->ht, &arg, nft_rhash_params);
+	he = rhashtable_lookup(&priv->ht, &arg, nft_rhash_params);
 	if (he != NULL)
 		*ext = &he->ext;
 
@@ -106,7 +106,7 @@ static void *nft_rhash_get(const struct net *net, const struct nft_set *set,
 		.key	 = elem->key.val.data,
 	};
 
-	he = rhashtable_lookup_fast(&priv->ht, &arg, nft_rhash_params);
+	he = rhashtable_lookup(&priv->ht, &arg, nft_rhash_params);
 	if (he != NULL)
 		return he;
 
@@ -129,7 +129,7 @@ static bool nft_rhash_update(struct nft_set *set, const u32 *key,
 		.key	 = key,
 	};
 
-	he = rhashtable_lookup_fast(&priv->ht, &arg, nft_rhash_params);
+	he = rhashtable_lookup(&priv->ht, &arg, nft_rhash_params);
 	if (he != NULL)
 		goto out;
 
@@ -217,7 +217,7 @@ static void *nft_rhash_deactivate(const struct net *net,
 	};
 
 	rcu_read_lock();
-	he = rhashtable_lookup_fast(&priv->ht, &arg, nft_rhash_params);
+	he = rhashtable_lookup(&priv->ht, &arg, nft_rhash_params);
 	if (he != NULL &&
 	    !nft_rhash_flush(net, set, he))
 		he = NULL;
-- 
2.11.0
