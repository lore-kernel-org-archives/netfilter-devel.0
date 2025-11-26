Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9348F320A0D
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Nov 2025 11:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764157641; cv=none; b=fZAojzzU2lDNkbq/9KYUXDzi2ebHvze8d2+aNOZKLi9X1YxbNBNMF7sdDGXlrZMKX+4ylHj7TxmWz4EGLCXMYT5NyZfQXOugMUCseF6E58FeUJAdcx2zPgeApKlu9I1vepPFBIzIG+mku7U93gWUm6LxSoKbXu+ky+c8g41GMlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764157641; c=relaxed/simple;
	bh=m5NKispOHu/x+PonWgG9I8yAem9haGZK3Y0wn6aGihE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jwkGbHrtkDQy6C/qG26QQqfYw9rKWuyehT8b5wI8sJwT5lzJbeaH1x1svggq3Y8AwiGPB3iSkd6PAJH08N43jo0nlx7lHySwys7hTHwbJwQvcmsxwQC18LHkbZkIJ0awyr/MhYZUDYMppq37VExVlW389z5I2DTpJwycAJTqrD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6DD506042D; Wed, 26 Nov 2025 12:47:15 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: hamzamahfooz@linux.microsoft.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: nf_tables: avoid chain re-validation if possible
Date: Wed, 26 Nov 2025 12:47:00 +0100
Message-ID: <20251126114703.8826-1-fw@strlen.de>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Consider:
  input -> j2 -> j3
  input -> j2 -> j3
  input -> j1 -> j2 -> j3

Then the second rule does not need to revalidate j2, and, by extension j3.
We need to validate it only for rule 3.

This is needed because chain loop detection also ensures we do not
exceed the jump stack: Just because we know that j2 is cycle free, its
last jump might now exceed the allowed stack.  We also need to update
the new largest call depth for all the reachable nodes.

Care has to be taken to revalidate even if the chain depth won't be an
issue, as the chain validation also ensures that expressions are not
called from invalid context (e.g., masquerade from a filter chain
or NAT prerouting hook).

Therefore we also need to stash the base chain context (type, hooknum)
and revalidate if the chain became reachable from a different hook or type.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Not urgent, can be deferred to next cycle.

 include/net/netfilter/nf_tables.h | 30 +++++++++----
 net/netfilter/nf_tables_api.c     | 70 +++++++++++++++++++++++++++++--
 2 files changed, 88 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index fab7dc73f738..3f91a4f0dcaa 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1091,6 +1091,26 @@ struct nft_rule_blob {
 		__attribute__((aligned(__alignof__(struct nft_rule_dp))));
 };
 
+enum nft_chain_types {
+	NFT_CHAIN_T_DEFAULT = 0,
+	NFT_CHAIN_T_ROUTE,
+	NFT_CHAIN_T_NAT,
+	NFT_CHAIN_T_MAX
+};
+
+/**
+ *	struct nft_chain_validate_state - cache validation state
+ *
+ *	@depth: chain was validated for call level <= depth
+ *	@basetype_mask: chain receives packets from basetypes
+ *	@hook_mask: chain receives packets from hook numbers
+ */
+struct nft_chain_validate_state {
+	u8			basetype_mask;
+	u8			hook_mask[NFT_CHAIN_T_MAX];
+	u8			depth;
+};
+
 /**
  *	struct nft_chain - nf_tables chain
  *
@@ -1128,9 +1148,10 @@ struct nft_chain {
 
 	/* Only used during control plane commit phase: */
 	struct nft_rule_blob		*blob_next;
+	struct nft_chain_validate_state vstate;
 };
 
-int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain);
+int nft_chain_validate(const struct nft_ctx *ctx, struct nft_chain *chain);
 int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
 			 const struct nft_set_iter *iter,
 			 struct nft_elem_priv *elem_priv);
@@ -1138,13 +1159,6 @@ int nft_set_catchall_validate(const struct nft_ctx *ctx, struct nft_set *set);
 int nf_tables_bind_chain(const struct nft_ctx *ctx, struct nft_chain *chain);
 void nf_tables_unbind_chain(const struct nft_ctx *ctx, struct nft_chain *chain);
 
-enum nft_chain_types {
-	NFT_CHAIN_T_DEFAULT = 0,
-	NFT_CHAIN_T_ROUTE,
-	NFT_CHAIN_T_NAT,
-	NFT_CHAIN_T_MAX
-};
-
 /**
  * 	struct nft_chain_type - nf_tables chain type info
  *
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f3de2f9bbebf..763690850a39 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -123,6 +123,30 @@ static void nft_validate_state_update(struct nft_table *table, u8 new_validate_s
 
 	table->validate_state = new_validate_state;
 }
+
+static bool nft_chain_vstate_valid(const struct nft_ctx *ctx,
+				   const struct nft_chain *chain)
+{
+	const struct nft_base_chain *base_chain;
+	enum nft_chain_types type;
+	u8 hooknum;
+
+	if (!nft_is_base_chain(ctx->chain))
+		return false;
+
+	base_chain = nft_base_chain(ctx->chain);
+	hooknum = base_chain->ops.hooknum;
+	type = base_chain->type->type;
+
+	/* chain is already validated for this call depth */
+	if (chain->vstate.depth >= ctx->level &&
+	    chain->vstate.basetype_mask & BIT(type) &&
+	    chain->vstate.hook_mask[type] & BIT(hooknum))
+		return true;
+
+	return false;
+}
+
 static void nf_tables_trans_destroy_work(struct work_struct *w);
 
 static void nft_trans_gc_work(struct work_struct *work);
@@ -4079,6 +4103,29 @@ static void nf_tables_rule_release(const struct nft_ctx *ctx, struct nft_rule *r
 	nf_tables_rule_destroy(ctx, rule);
 }
 
+static void nft_chain_vstate_update(const struct nft_ctx *ctx, struct nft_chain *chain)
+{
+	const struct nft_base_chain *base_chain;
+	enum nft_chain_types type;
+	u8 hooknum;
+
+	if (!nft_is_base_chain(ctx->chain)) {
+		memset(&chain->vstate, 0, sizeof(chain->vstate));
+		return;
+	}
+
+	base_chain = nft_base_chain(ctx->chain);
+	hooknum = base_chain->ops.hooknum;
+	type = base_chain->type->type;
+
+	BUILD_BUG_ON(BIT(NF_INET_NUMHOOKS) > U8_MAX);
+
+	chain->vstate.basetype_mask |= BIT(type);
+	chain->vstate.hook_mask[type] |= BIT(hooknum);
+	if (chain->vstate.depth < ctx->level)
+		chain->vstate.depth = ctx->level;
+}
+
 /** nft_chain_validate - loop detection and hook validation
  *
  * @ctx: context containing call depth and base chain
@@ -4088,15 +4135,25 @@ static void nf_tables_rule_release(const struct nft_ctx *ctx, struct nft_rule *r
  * and set lookups until either the jump limit is hit or all reachable
  * chains have been validated.
  */
-int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
+int nft_chain_validate(const struct nft_ctx *ctx, struct nft_chain *chain)
 {
 	struct nft_expr *expr, *last;
 	struct nft_rule *rule;
 	int err;
 
+	BUILD_BUG_ON(NFT_JUMP_STACK_SIZE > 255);
 	if (ctx->level == NFT_JUMP_STACK_SIZE)
 		return -EMLINK;
 
+	if (ctx->level > 0) {
+		/* jumps to base chains are not allowed. */
+		if (nft_is_base_chain(chain))
+			return -ELOOP;
+
+		if (nft_chain_vstate_valid(ctx, chain))
+			return 0;
+	}
+
 	list_for_each_entry(rule, &chain->rules, list) {
 		if (fatal_signal_pending(current))
 			return -EINTR;
@@ -4117,6 +4174,7 @@ int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
 		}
 	}
 
+	nft_chain_vstate_update(ctx, chain);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(nft_chain_validate);
@@ -4128,7 +4186,7 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
 		.net	= net,
 		.family	= table->family,
 	};
-	int err;
+	int err = 0;
 
 	list_for_each_entry(chain, &table->chains, list) {
 		if (!nft_is_base_chain(chain))
@@ -4137,12 +4195,16 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
 		ctx.chain = chain;
 		err = nft_chain_validate(&ctx, chain);
 		if (err < 0)
-			return err;
+			goto err;
 
 		cond_resched();
 	}
 
-	return 0;
+err:
+	list_for_each_entry(chain, &table->chains, list)
+		memset(&chain->vstate, 0, sizeof(chain->vstate));
+
+	return err;
 }
 
 int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
-- 
2.51.2

