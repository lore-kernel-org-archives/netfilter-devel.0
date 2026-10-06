Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87544F55C1
	for <netfilter-devel@vger.kernel.org>; Tue,  6 Oct 2026 23:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791328352; cv=none; b=NYDhQJOJveCanZSr3Y55jbdFFuJBiPbYmusXQ2d3XBSXjLfWdIq+XnlbDrnz7za2Ff40eaVh7+e7XeFDCs+6PBCqhiYtzN6G1uTP3CkgxzR6hyye65D2Y/UAsNEQ5+QTMMcDe9ORLrYWfIN9Vd9Z0OwYKJrXZGuCobJCtmFfI74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791328352; c=relaxed/simple;
	bh=C76vUfOQ9+E2hwhogsWwua2ZJp0THsjSBBdkgZwylNw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ld8ojWt0Qyba62+Ya/SFAXa5mAQVt4mIFfl/xivm4V97hDpU7IK4AecIEoDXQadfES6YZ8xqKs8QJnLqTxPj+YcLwLx2nJKUsJQBpv8VIYc1g6PUC+OZkqZznJzErRBfbqPm0qv3mtJnfgWcgAZyY9ns3L9kNR8jzg5BOlkbGF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 217886059E; Wed, 07 Oct 2026 01:12:26 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: nft_ct: validate hook and priority for ct zone set
Date: Wed,  7 Oct 2026 01:12:16 +0200
Message-ID: <20261006231216.5570-1-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Setting a conntrack zone template via "ct zone set" only makes sense
before the real conntrack hook runs: nft_ct_set_zone_eval() attaches a
shared per-cpu template conntrack entry to the skb so that both defrag
engine and nf_conntrack_in() can pick up the requested zone when creating
the real connection.

NAT chain types are therefore nonsensical, they only run for new
conntracks to configure the nat mapping: the eval function will
be a no-op because of the already-attached conntrack entry.

Add a validate callback to reject NAT type chains.

Also, mirror what classic xtables CT target is doing: CT target is
restricted to the 'raw' table and therefore automatically tied to
the 'before conntrack' priority implied by the raw table.

This mirrors why the classic xtables CT target is restricted to the
raw table (PREROUTING/OUTPUT, ahead of conntrack). Add a .validate
callback restricting the expression to PREROUTING/OUTPUT, to base
chains with priority before conntrack, to non-NAT chain types, and to
families where that hook/priority namespace is actually meaningful
(ip, ip6, inet, bridge).

Bridge is further limited to prerouting only: locally originating
traffic is tracked at the IP layer already.

Other families are rejected.

Normally the "ct already set" check in nft_ct_set_zone_eval() makes uses
in the wrong chain priority a no-op, but on paths where no conntrack hook
runs for the skb afterwards, the unconfirmed per-cpu template can reach
the conntrack confirm hook and get inserted into the global hash table as
if it were a genuine connection.

Fixes: edee4f1e9245 ("netfilter: nft_ct: add zone id set support")
Assisted-by: LLM
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 This isn't nice/ideal, because this causes a test failure in
 tests/py (already resolved in master branch now).
 So, there is a risk of breakage.
 However, attaching the zone template after conntrack
 makes no sense at all and is actually harmful.

 Alternatively this could be routed via nf as well.

 include/net/netfilter/nf_tables.h |  4 +++
 net/netfilter/nf_conntrack_core.c |  5 ++++
 net/netfilter/nf_tables_api.c     | 48 ++++++++++++++++++++++++++++---
 net/netfilter/nft_ct.c            | 42 +++++++++++++++++++++++++++
 4 files changed, 95 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 9d597482363d..a1ab2701bc4a 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1106,10 +1106,14 @@ enum nft_chain_types {
  *
  *	@hook_mask: the hook numbers and locations the chain is linked to
  *	@depth: the deepest call chain level the chain is linked to
+ *	@prio_min: lowest priority the chain was validated with
+ *	@prio_max: highest priority the chain was validated with
  */
 struct nft_chain_validate_state {
 	u8			hook_mask[NFT_CHAIN_T_MAX];
 	u8			depth;
+	s32			prio_min;
+	s32			prio_max;
 };
 
 /**
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index d0d9e5ea84a0..e3fcebaadc29 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1199,6 +1199,11 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	if (CTINFO2DIR(ctinfo) != IP_CT_DIR_ORIGINAL)
 		return NF_ACCEPT;
 
+	if (unlikely(nf_ct_is_template(ct))) {
+		DEBUG_NET_WARN_ON_ONCE(1);
+		return NF_ACCEPT;
+	}
+
 	zone = nf_ct_zone(ct);
 	local_bh_disable();
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b59628e6240c..7160d83e3e84 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -123,6 +123,12 @@ static void nft_validate_state_update(struct nft_table *table, u8 new_validate_s
 	table->validate_state = new_validate_state;
 }
 
+static bool nft_chain_vstate_valid_prio(const struct nft_chain_validate_state *v,
+					s32 priority)
+{
+	return v->prio_min <= priority && priority <= v->prio_max;
+}
+
 static bool nft_chain_vstate_valid(const struct nft_ctx *ctx,
 				   const struct nft_chain *chain)
 {
@@ -137,9 +143,10 @@ static bool nft_chain_vstate_valid(const struct nft_ctx *ctx,
 	hooknum = base_chain->ops.hooknum;
 	type = base_chain->type->type;
 
-	/* chain is already validated for this call depth */
+	/* chain is already validated for this call depth and priority */
 	if (chain->vstate.depth >= ctx->level &&
-	    chain->vstate.hook_mask[type] & BIT(hooknum))
+	    chain->vstate.hook_mask[type] & BIT(hooknum) &&
+	    nft_chain_vstate_valid_prio(&chain->vstate, base_chain->ops.priority))
 		return true;
 
 	return false;
@@ -2750,6 +2757,25 @@ int nft_chain_add(struct nft_table *table, struct nft_chain *chain)
 
 static u64 chain_id;
 
+static void nft_chain_vstate_init(struct nft_chain_validate_state *v)
+{
+	memset(v, 0, sizeof(*v));
+
+	/* Inverted.  A chain at priority P can skip valiation
+	 * if min <= P <= max.
+	 *
+	 * The inverted start fails the test for all values of P.
+	 * nft_chain_vstate_update() will shrink prio_min to P
+	 * and grow prio_max to P, so that after first run:
+	 * prio_min == prio_max == P.  A subsequent validation
+	 * request will only skip if P1 == P2 amd revalidate
+	 * otherwise, including an update of either prio_min or
+	 * prio_max.
+	 */
+	v->prio_min = INT_MAX;
+	v->prio_max = INT_MIN;
+}
+
 static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 policy,
 			      u32 flags, struct netlink_ext_ack *extack)
 {
@@ -2818,6 +2844,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 policy,
 	}
 	ctx->chain = chain;
 
+	nft_chain_vstate_init(&chain->vstate);
 	INIT_LIST_HEAD(&chain->rules);
 	chain->handle = nf_tables_alloc_handle(table);
 	chain->table = table;
@@ -4149,15 +4176,21 @@ static void nf_tables_rule_release(const struct nft_ctx *ctx, struct nft_rule *r
 	nf_tables_rule_destroy(ctx, rule);
 }
 
+static void nft_chain_vstate_reinit(struct nft_chain_validate_state *v)
+{
+	nft_chain_vstate_init(v);
+}
+
 static void nft_chain_vstate_update(const struct nft_ctx *ctx, struct nft_chain *chain)
 {
 	const struct nft_base_chain *base_chain;
 	enum nft_chain_types type;
 	u8 hooknum;
+	s32 prio;
 
 	/* ctx->chain must hold the calling base chain. */
 	if (WARN_ON_ONCE(!nft_is_base_chain(ctx->chain))) {
-		memset(&chain->vstate, 0, sizeof(chain->vstate));
+		nft_chain_vstate_reinit(&chain->vstate);
 		return;
 	}
 
@@ -4170,6 +4203,13 @@ static void nft_chain_vstate_update(const struct nft_ctx *ctx, struct nft_chain
 	chain->vstate.hook_mask[type] |= BIT(hooknum);
 	if (chain->vstate.depth < ctx->level)
 		chain->vstate.depth = ctx->level;
+
+	prio = base_chain->ops.priority;
+	if (prio < chain->vstate.prio_min)
+		chain->vstate.prio_min = prio;
+	if (prio > chain->vstate.prio_max)
+		chain->vstate.prio_max = prio;
+
 }
 
 /** nft_chain_validate - loop detection and hook validation
@@ -4248,7 +4288,7 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
 
 err:
 	list_for_each_entry(chain, &table->chains, list)
-		memset(&chain->vstate, 0, sizeof(chain->vstate));
+		nft_chain_vstate_reinit(&chain->vstate);
 
 	return err;
 }
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 9dbf127df9c8..cea849781d85 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
+#include <linux/netfilter_ipv4.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_conntrack.h>
@@ -755,6 +756,46 @@ static const struct nft_expr_ops nft_ct_set_ops = {
 };
 
 #ifdef CONFIG_NF_CONNTRACK_ZONES
+static int nft_ct_set_zone_validate(const struct nft_ctx *ctx,
+				    const struct nft_expr *expr)
+{
+	unsigned int hooks;
+	int err;
+
+	/* Setting the zone template only makes sense before conntrack has
+	 * assigned a zone to the packet, i.e. in prerouting and output,
+	 * and only if this rule runs before the conntrack hook itself.
+	 * Locally originated bridge traffic is conntrack'd by the IP stack,
+	 * not on the bridge, so only prerouting applies there.
+	 */
+	switch (ctx->family) {
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+	case NFPROTO_INET:
+		hooks = (1 << NF_INET_PRE_ROUTING) | (1 << NF_INET_LOCAL_OUT);
+		break;
+	case NFPROTO_BRIDGE:
+		hooks = (1 << NF_INET_PRE_ROUTING);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	err = nft_chain_validate_hooks(ctx->chain, hooks);
+	if (err)
+		return err;
+
+	if (nft_is_base_chain(ctx->chain)) {
+		const struct nft_base_chain *basechain = nft_base_chain(ctx->chain);
+
+		if (basechain->type->type == NFT_CHAIN_T_NAT ||
+		    basechain->ops.priority >= NF_IP_PRI_CONNTRACK)
+			return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static const struct nft_expr_ops nft_ct_set_zone_ops = {
 	.type		= &nft_ct_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_ct)),
@@ -762,6 +803,7 @@ static const struct nft_expr_ops nft_ct_set_zone_ops = {
 	.init		= nft_ct_set_init,
 	.destroy	= nft_ct_set_destroy,
 	.dump		= nft_ct_set_dump,
+	.validate	= nft_ct_set_zone_validate,
 };
 #endif
 
-- 
2.55.0

