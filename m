Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B469063C;
	Thu, 15 Aug 2024 14:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731835; cv=none; b=VpNncwsJRi9yzopx2h/L17g6oGURxwoRZ9CdAuCu/1BE6Ci5NvZliLuLlSi8xy0VJC9hlZuuiVdnSkssrtQ40mkKcKjLnQBMiaQIg9MVLc9u2sSvbj14Hqylv82KDNdpwIS4tuZgJ3t4yFLv1nDdzbCNwF/LRT1udj8n1skQnCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731835; c=relaxed/simple;
	bh=mJ5CpE/4qPUmUcZJJlAQXmosgB0rF/kYPUKrGwCud/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sHa/mjRJ2wVT8blJmOrEI3/a/ewjd0Ymoeiz4bYqJz5hxZYdJ3mWK1636ODUo+3IpbPuncl5Wg7O+rh5v4N/yJoaF6seR++GvfLdK+qdYy8SSskr8exlbP/NqAoeX2cgj9K1m4ZD1cjgvAaQcfussGlxIF01maKkhWSfTw1dqlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aBYlaUC3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aBYlaUC3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A580FC32786;
	Thu, 15 Aug 2024 14:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731835;
	bh=mJ5CpE/4qPUmUcZJJlAQXmosgB0rF/kYPUKrGwCud/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aBYlaUC3ZEtHtz4lP1KSDWQGleboZBypvX3QLO7EcdjIPoiUGev3ey32bTjIa86cx
	 gJy/MEvMQ5uxidVr/dekfzFJXczm7ZmDZi67yAogU1514q4Yhz51FWz8p5qFyZe645
	 oOVfDZEnB7NC20WblR0eAUHAKtOWn50DAidS2Q9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 252/259] netfilter: nf_tables: use timestamp to check for set element timeout
Date: Thu, 15 Aug 2024 15:26:25 +0200
Message-ID: <20240815131912.502018874@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 7395dfacfff65e9938ac0889dafa1ab01e987d15 upstream

Add a timestamp field at the beginning of the transaction, store it
in the nftables per-netns area.

Update set backend .insert, .deactivate and sync gc path to use the
timestamp, this avoids that an element expires while control plane
transaction is still unfinished.

.lookup and .update, which are used from packet path, still use the
current time to check if the element has expired. And .get path and dump
also since this runs lockless under rcu read size lock. Then, there is
async gc which also needs to check the current time since it runs
asynchronously from a workqueue.

[ NB: rbtree GC updates has been excluded because GC is asynchronous. ]

Fixes: c3e1b005ed1c ("netfilter: nf_tables: add set element timeout support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_tables.h |   21 +++++++++++++++++++--
 net/netfilter/nf_tables_api.c     |    1 +
 net/netfilter/nft_set_hash.c      |    8 +++++++-
 net/netfilter/nft_set_rbtree.c    |    6 ++++--
 4 files changed, 31 insertions(+), 5 deletions(-)

--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -13,6 +13,7 @@
 #include <net/netfilter/nf_flow_table.h>
 #include <net/netlink.h>
 #include <net/flow_offload.h>
+#include <net/netns/generic.h>
 
 struct module;
 
@@ -656,10 +657,16 @@ static inline struct nft_expr *nft_set_e
 	return nft_set_ext(ext, NFT_SET_EXT_EXPR);
 }
 
-static inline bool nft_set_elem_expired(const struct nft_set_ext *ext)
+static inline bool __nft_set_elem_expired(const struct nft_set_ext *ext,
+					  u64 tstamp)
 {
 	return nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION) &&
-	       time_is_before_eq_jiffies64(*nft_set_ext_expiration(ext));
+	       time_after_eq64(tstamp, *nft_set_ext_expiration(ext));
+}
+
+static inline bool nft_set_elem_expired(const struct nft_set_ext *ext)
+{
+	return __nft_set_elem_expired(ext, get_jiffies_64());
 }
 
 static inline struct nft_set_ext *nft_set_elem_ext(const struct nft_set *set,
@@ -1482,9 +1489,19 @@ struct nftables_pernet {
 	struct list_head	module_list;
 	struct list_head	notify_list;
 	struct mutex		commit_mutex;
+	u64			tstamp;
 	unsigned int		base_seq;
 	u8			validate_state;
 	unsigned int		gc_seq;
 };
 
+extern unsigned int nf_tables_net_id;
+
+static inline u64 nft_net_tstamp(const struct net *net)
+{
+	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+
+	return nft_net->tstamp;
+}
+
 #endif /* _NET_NF_TABLES_H */
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7758,6 +7758,7 @@ static bool nf_tables_valid_genid(struct
 	bool genid_ok;
 
 	mutex_lock(&nft_net->commit_mutex);
+	nft_net->tstamp = get_jiffies_64();
 
 	genid_ok = genid == 0 || nft_net->base_seq == genid;
 	if (!genid_ok)
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -38,6 +38,7 @@ struct nft_rhash_cmp_arg {
 	const struct nft_set		*set;
 	const u32			*key;
 	u8				genmask;
+	u64				tstamp;
 };
 
 static inline u32 nft_rhash_key(const void *data, u32 len, u32 seed)
@@ -64,7 +65,7 @@ static inline int nft_rhash_cmp(struct r
 		return 1;
 	if (nft_set_elem_is_dead(&he->ext))
 		return 1;
-	if (nft_set_elem_expired(&he->ext))
+	if (__nft_set_elem_expired(&he->ext, x->tstamp))
 		return 1;
 	if (!nft_set_elem_active(&he->ext, x->genmask))
 		return 1;
@@ -88,6 +89,7 @@ static bool nft_rhash_lookup(const struc
 		.genmask = nft_genmask_cur(net),
 		.set	 = set,
 		.key	 = key,
+		.tstamp  = get_jiffies_64(),
 	};
 
 	he = rhashtable_lookup(&priv->ht, &arg, nft_rhash_params);
@@ -106,6 +108,7 @@ static void *nft_rhash_get(const struct
 		.genmask = nft_genmask_cur(net),
 		.set	 = set,
 		.key	 = elem->key.val.data,
+		.tstamp  = get_jiffies_64(),
 	};
 
 	he = rhashtable_lookup(&priv->ht, &arg, nft_rhash_params);
@@ -129,6 +132,7 @@ static bool nft_rhash_update(struct nft_
 		.genmask = NFT_GENMASK_ANY,
 		.set	 = set,
 		.key	 = key,
+		.tstamp  = get_jiffies_64(),
 	};
 
 	he = rhashtable_lookup(&priv->ht, &arg, nft_rhash_params);
@@ -172,6 +176,7 @@ static int nft_rhash_insert(const struct
 		.genmask = nft_genmask_next(net),
 		.set	 = set,
 		.key	 = elem->key.val.data,
+		.tstamp	 = nft_net_tstamp(net),
 	};
 	struct nft_rhash_elem *prev;
 
@@ -214,6 +219,7 @@ static void *nft_rhash_deactivate(const
 		.genmask = nft_genmask_next(net),
 		.set	 = set,
 		.key	 = elem->key.val.data,
+		.tstamp	 = nft_net_tstamp(net),
 	};
 
 	rcu_read_lock();
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -315,6 +315,7 @@ static int __nft_rbtree_insert(const str
 	struct nft_rbtree *priv = nft_set_priv(set);
 	u8 cur_genmask = nft_genmask_cur(net);
 	u8 genmask = nft_genmask_next(net);
+	u64 tstamp = nft_net_tstamp(net);
 	int d, err;
 
 	/* Descend the tree to search for an existing element greater than the
@@ -362,7 +363,7 @@ static int __nft_rbtree_insert(const str
 		/* perform garbage collection to avoid bogus overlap reports
 		 * but skip new elements in this transaction.
 		 */
-		if (nft_set_elem_expired(&rbe->ext) &&
+		if (__nft_set_elem_expired(&rbe->ext, tstamp) &&
 		    nft_set_elem_active(&rbe->ext, cur_genmask)) {
 			err = nft_rbtree_gc_elem(set, priv, rbe);
 			if (err < 0)
@@ -537,6 +538,7 @@ static void *nft_rbtree_deactivate(const
 	const struct rb_node *parent = priv->root.rb_node;
 	struct nft_rbtree_elem *rbe, *this = elem->priv;
 	u8 genmask = nft_genmask_next(net);
+	u64 tstamp = nft_net_tstamp(net);
 	int d;
 
 	while (parent != NULL) {
@@ -557,7 +559,7 @@ static void *nft_rbtree_deactivate(const
 				   nft_rbtree_interval_end(this)) {
 				parent = parent->rb_right;
 				continue;
-			} else if (nft_set_elem_expired(&rbe->ext)) {
+			} else if (__nft_set_elem_expired(&rbe->ext, tstamp)) {
 				break;
 			} else if (!nft_set_elem_active(&rbe->ext, genmask)) {
 				parent = parent->rb_left;


