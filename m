Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442107;
	b=E8bsYCeHQFYoPZOAsbjfsGektTInf8oRhHDHV72AyAzI0cqqh2liOfZQtUdJAIwa+mU6
	 tX0KYXBLk2pxodZ638WlkvJygYlCdMM0gS1m+dyq0/EW2oSpLiuj+/BoICU0v79ontVpQ
	 a8G5ioz7wYoOrs/huWzVewsi3yQY6wJ5+gkGkNzP5EdHB3kJMXb1A3KRLgnqR/AaiowaH
	 o+jxLQ0yhiOj2WZTekihMMyHLAvO7yRCiBBqFhW2G+Yi7W7cngbFYwqBNdzUFm3ul8T24
	 K8ScKb97w2AQni5xqkbs8LmvwEdWJLs0ElqTNIFY3+8X2K+Po/mepssU9atIgVhaagg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442107;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=QvrbKCuFZKn+ULd3Q0YZ3BsxW7qfdkSFiStNK7DWrTA=;
	b=gz4wrmN34QpMKOjLdscLBh275EnfBaKJVip/wzPjVkAjTR4yjDxweEVkXKI5fEWrr9MC
	 UB7TbRXd7J2GCeJCqY5Bh/6ZJ9ynqYV+R+q/hkRC90ePhXOtmw6SAPeSkYl6kQy4e8ZfM
	 inHXIyRYbfr75q+Lvb9sG9KVe25thbZGq6FNFNnZq3RpV9EWakQ6FP7dlWjOlA+ben7Ce
	 sWX4AEzacXXmniGEt/d8RtVaT2uW3eZrCpQItR28Pb3l4bYl+5xEw0hFGJtDAAFbqhUdY
	 Ccg16y/tCe/HlLc9chcdl3QFAGYfJzUqRl2n+r9tWhiJTKSPgeYFPywycN8OEUrpnpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=k7hF3hJm;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C5E606A327;
	Mon, 23 Nov 2026 13:55:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50C5E606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=k7hF3hJm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795442103;
	bh=QvrbKCuFZKn+ULd3Q0YZ3BsxW7qfdkSFiStNK7DWrTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k7hF3hJm00PkvpKuTNjqdUHgiAThVkcKK4Xb9M7VIrB7Izi/jokhgVxiWpYu2Ax06
	 gfqxUrrohArhUqjyE0yYX/GVV2skLIJcClag63c6I96SWIaiB43E+MI9K4C25wPmzk
	 abtHas/UiusW3fL4zHRpOx4e6kaw1RQqAVGsBt52+twCMgiSsKYsTODf5Xq2cQDK8g
	 /gYewSW0KJJ3lP1xICzaMFP0prspGA2FZfs+ZBg15xO7dt2p00TZOf1ne4uLThv/Jp
	 Qi6LE6ORodCskG9tm9WqVgPtwgJ2XH3bn7EjJrXEJZyH9N5PQq6qKV343QDnFRobgX
	 yzdy8zRoa4T5g==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5EDA6602D7;
	Mon, 23 Nov 2026 14:55:02 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 09/15] netfilter: nft_ct: validate hook and priority for ct zone set
Date: Mon, 23 Nov 2026 14:54:36 +0100
Message-ID: <20261123135442.3940372-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123135442.3940372-1-pablo@netfilter.org>
References: <20261123135442.3940372-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
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
index d2cd9b31507e..707a9006537d 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1198,6 +1198,11 @@ __nf_conntrack_confirm(struct sk_buff *skb)
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
index 8b94b5e7dbdb..a13b970ee1bd 100644
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
@@ -2782,6 +2789,25 @@ int nft_chain_add(struct nft_table *table, struct nft_chain *chain)
 
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
@@ -2850,6 +2876,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 policy,
 	}
 	ctx->chain = chain;
 
+	nft_chain_vstate_init(&chain->vstate);
 	INIT_LIST_HEAD(&chain->rules);
 	chain->handle = nf_tables_alloc_handle(table);
 	chain->table = table;
@@ -4181,15 +4208,21 @@ static void nf_tables_rule_release(const struct nft_ctx *ctx, struct nft_rule *r
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
 
@@ -4202,6 +4235,13 @@ static void nft_chain_vstate_update(const struct nft_ctx *ctx, struct nft_chain
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
@@ -4280,7 +4320,7 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
 
 err:
 	list_for_each_entry(chain, &table->chains, list)
-		memset(&chain->vstate, 0, sizeof(chain->vstate));
+		nft_chain_vstate_reinit(&chain->vstate);
 
 	return err;
 }
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index a19a839a0fc0..9ed9cad090e4 100644
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
2.47.3

