Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878A034C806
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Feb 2026 14:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771596375; cv=none; b=R9jFKXDJna+C8geypKf+Wsnt84UqeSfidjOLOzITug8FQjJkDjCxxG1YolGxHsKVnLvPDh9MweSXI0O0FLJz2C+qi6oQK+NE63HM3BHkWpfjmAV01Um8pO8iggOjm2/4wr9vyZ9Zgf5azR+C3QT2l8RVysEdsSiCJjmgxZDZ3+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771596375; c=relaxed/simple;
	bh=Qjm4OiegaImTM6Wvnh4vdsay+zWcdKyi9KIlRneHFyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jsDizUL/Iy1fGpvVbqNR+6AUU4GCu2rvKzHRhbr3XPirdnBGhh/BqT8SeUY+MAtLKVskUWdZNVh+q3H9/wohuHaIeEkGyIkqgEpK6H7wFiEdoderGv7LTp1JUIZddtGrxi1zF5wHXsqj0gtgM2vMkN3nkTVFSxTd1umhUZZzwQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1CDDF6090A; Fri, 20 Feb 2026 15:06:13 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/3] netfilter: nf_tables: drop obsolete EXPORT_SYMBOLs
Date: Fri, 20 Feb 2026 15:05:42 +0100
Message-ID: <20260220140553.21155-3-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260220140553.21155-1-fw@strlen.de>
References: <20260220140553.21155-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These are no longer required, calling objects are nowadays
baked into nf_tables.ko itself.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0c5a4855b97d..23ef775897a4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4128,7 +4128,6 @@ int nft_chain_validate(const struct nft_ctx *ctx, struct nft_chain *chain)
 	nft_chain_vstate_update(ctx, chain);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(nft_chain_validate);
 
 static int nft_table_validate(struct net *net, const struct nft_table *table)
 {
@@ -4745,7 +4744,6 @@ struct nft_set *nft_set_lookup_global(const struct net *net,
 	}
 	return set;
 }
-EXPORT_SYMBOL_GPL(nft_set_lookup_global);
 
 static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
 				    const char *name)
@@ -5818,7 +5816,6 @@ int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(nf_tables_bind_set);
 
 static void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
 				 struct nft_set_binding *binding, bool event)
@@ -5898,7 +5895,6 @@ void nf_tables_activate_set(const struct nft_ctx *ctx, struct nft_set *set)
 
 	nft_use_inc_restore(&set->use);
 }
-EXPORT_SYMBOL_GPL(nf_tables_activate_set);
 
 void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
 			      struct nft_set_binding *binding,
@@ -5938,14 +5934,12 @@ void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
 				     phase == NFT_TRANS_COMMIT);
 	}
 }
-EXPORT_SYMBOL_GPL(nf_tables_deactivate_set);
 
 void nf_tables_destroy_set(const struct nft_ctx *ctx, struct nft_set *set)
 {
 	if (list_empty(&set->bindings) && nft_set_is_anonymous(set))
 		nft_set_destroy(ctx, set);
 }
-EXPORT_SYMBOL_GPL(nf_tables_destroy_set);
 
 const struct nft_set_ext_type nft_set_ext_types[] = {
 	[NFT_SET_EXT_KEY]		= {
@@ -6783,7 +6777,6 @@ void nft_set_elem_destroy(const struct nft_set *set,
 
 	__nft_set_elem_destroy(&ctx, set, elem_priv, destroy_expr);
 }
-EXPORT_SYMBOL_GPL(nft_set_elem_destroy);
 
 /* Drop references and destroy. Called from abort path. */
 static void nft_trans_set_elem_destroy(const struct nft_ctx *ctx, struct nft_trans_elem *te)
@@ -6910,7 +6903,6 @@ struct nft_set_ext *nft_set_catchall_lookup(const struct net *net,
 
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(nft_set_catchall_lookup);
 
 static int nft_setelem_catchall_insert(const struct net *net,
 				       struct nft_set *set,
@@ -8038,7 +8030,6 @@ struct nft_object *nft_obj_lookup(const struct net *net,
 	rcu_read_unlock();
 	return ERR_PTR(-ENOENT);
 }
-EXPORT_SYMBOL_GPL(nft_obj_lookup);
 
 static struct nft_object *nft_obj_lookup_byhandle(const struct nft_table *table,
 						  const struct nlattr *nla,
@@ -11860,7 +11851,6 @@ void nft_data_release(const struct nft_data *data, enum nft_data_types type)
 		WARN_ON(1);
 	}
 }
-EXPORT_SYMBOL_GPL(nft_data_release);
 
 int nft_data_dump(struct sk_buff *skb, int attr, const struct nft_data *data,
 		  enum nft_data_types type, unsigned int len)
@@ -11887,7 +11877,6 @@ int nft_data_dump(struct sk_buff *skb, int attr, const struct nft_data *data,
 	nla_nest_end(skb, nest);
 	return err;
 }
-EXPORT_SYMBOL_GPL(nft_data_dump);
 
 static void __nft_release_hook(struct net *net, struct nft_table *table)
 {
-- 
2.52.0

