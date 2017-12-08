From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/3] netfilter: core: only allow one nat hook per hook point
Date: Fri,  8 Dec 2017 17:01:54 +0100
Message-ID: <20171208160155.968-3-fw@strlen.de>
References: <20171208160155.968-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:52224 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754510AbdLHQC0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Dec 2017 11:02:26 -0500
In-Reply-To: <20171208160155.968-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The netfilter NAT core cannot deal with more than one NAT hook per hook
location (prerouting, input ...), because the NAT hooks install a NAT null
binding in case the iptables nat table (iptable_nat hooks) or the
corresponding nftables chain (nft nat hooks) doesn't specify a nat
transformation.

Null bindings are needed to detect port collsisions between NAT-ed and
non-NAT-ed connections.

This causes nftables NAT rules to not work when iptable_nat module is
loaded, and vice versa because nat binding has already been attached
when the second nat hook is consulted.

The netfilter core is not really the correct location to handle this
(hooks are just hooks, the core has no notion of what kinds of side
 effects a hook implements), but its the only place where we can check
for conflicts between both iptables hooks and nftables hooks without
adding dependencies.

So add nat annotation to hook_ops to describe those hooks that will
add NAT bindings and then make core reject if such a hook already exists.
The annotation fills a padding hole, in case further restrictions appar
we might change this to a 'u8 type' instead of bool.

iptables error if nft nat hook active:
iptables -t nat -A POSTROUTING -j MASQUERADE
iptables v1.4.21: can't initialize iptables table `nat': File exists
Perhaps iptables or your kernel needs to be upgraded.

nftables error if iptables nat table present:
nft -f /etc/nftables/ipv4-nat
/usr/etc/nftables/ipv4-nat:3:1-2: Error: Could not process rule: File exists
table nat {
^^

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter.h         | 1 +
 net/ipv4/netfilter/iptable_nat.c  | 4 ++++
 net/ipv6/netfilter/ip6table_nat.c | 4 ++++
 net/netfilter/core.c              | 6 ++++++
 net/netfilter/nf_tables_api.c     | 2 ++
 5 files changed, 17 insertions(+)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 9dcbcdfa3b82..579b1ba86ee6 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -67,6 +67,7 @@ struct nf_hook_ops {
 	struct net_device	*dev;
 	void			*priv;
 	u_int8_t		pf;
+	bool			nat_hook;
 	unsigned int		hooknum;
 	/* Hooks are ordered in ascending priority. */
 	int			priority;
diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
index a1a07b338ccf..0f7255cc65ee 100644
--- a/net/ipv4/netfilter/iptable_nat.c
+++ b/net/ipv4/netfilter/iptable_nat.c
@@ -72,6 +72,7 @@ static const struct nf_hook_ops nf_nat_ipv4_ops[] = {
 	{
 		.hook		= iptable_nat_ipv4_in,
 		.pf		= NFPROTO_IPV4,
+		.nat_hook	= true,
 		.hooknum	= NF_INET_PRE_ROUTING,
 		.priority	= NF_IP_PRI_NAT_DST,
 	},
@@ -79,6 +80,7 @@ static const struct nf_hook_ops nf_nat_ipv4_ops[] = {
 	{
 		.hook		= iptable_nat_ipv4_out,
 		.pf		= NFPROTO_IPV4,
+		.nat_hook	= true,
 		.hooknum	= NF_INET_POST_ROUTING,
 		.priority	= NF_IP_PRI_NAT_SRC,
 	},
@@ -86,6 +88,7 @@ static const struct nf_hook_ops nf_nat_ipv4_ops[] = {
 	{
 		.hook		= iptable_nat_ipv4_local_fn,
 		.pf		= NFPROTO_IPV4,
+		.nat_hook	= true,
 		.hooknum	= NF_INET_LOCAL_OUT,
 		.priority	= NF_IP_PRI_NAT_DST,
 	},
@@ -93,6 +96,7 @@ static const struct nf_hook_ops nf_nat_ipv4_ops[] = {
 	{
 		.hook		= iptable_nat_ipv4_fn,
 		.pf		= NFPROTO_IPV4,
+		.nat_hook	= true,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP_PRI_NAT_SRC,
 	},
diff --git a/net/ipv6/netfilter/ip6table_nat.c b/net/ipv6/netfilter/ip6table_nat.c
index 991512576c8c..47306e45a80a 100644
--- a/net/ipv6/netfilter/ip6table_nat.c
+++ b/net/ipv6/netfilter/ip6table_nat.c
@@ -74,6 +74,7 @@ static const struct nf_hook_ops nf_nat_ipv6_ops[] = {
 	{
 		.hook		= ip6table_nat_in,
 		.pf		= NFPROTO_IPV6,
+		.nat_hook	= true,
 		.hooknum	= NF_INET_PRE_ROUTING,
 		.priority	= NF_IP6_PRI_NAT_DST,
 	},
@@ -81,6 +82,7 @@ static const struct nf_hook_ops nf_nat_ipv6_ops[] = {
 	{
 		.hook		= ip6table_nat_out,
 		.pf		= NFPROTO_IPV6,
+		.nat_hook	= true,
 		.hooknum	= NF_INET_POST_ROUTING,
 		.priority	= NF_IP6_PRI_NAT_SRC,
 	},
@@ -88,12 +90,14 @@ static const struct nf_hook_ops nf_nat_ipv6_ops[] = {
 	{
 		.hook		= ip6table_nat_local_fn,
 		.pf		= NFPROTO_IPV6,
+		.nat_hook	= true,
 		.hooknum	= NF_INET_LOCAL_OUT,
 		.priority	= NF_IP6_PRI_NAT_DST,
 	},
 	/* After packet filtering, change source */
 	{
 		.hook		= ip6table_nat_fn,
+		.nat_hook	= true,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP6_PRI_NAT_SRC,
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index a6eaaf303be8..6c263efed2b6 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -160,6 +160,12 @@ nf_hook_entries_grow(const struct nf_hook_entries *old,
 			++i;
 			continue;
 		}
+
+		if (reg->nat_hook && orig_ops[i]->nat_hook) {
+			kvfree(new);
+			return ERR_PTR(-EEXIST);
+		}
+
 		if (inserted || reg->priority > orig_ops[i]->priority) {
 			new_ops[nhooks] = (void *)orig_ops[i];
 			new->hooks[nhooks] = old->hooks[i];
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d8327b43e4dc..f000d4399c7a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1400,6 +1400,8 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 				ops->hook = hookfn;
 			if (afi->hook_ops_init)
 				afi->hook_ops_init(ops, i);
+			if (basechain->type->type == NFT_CHAIN_T_NAT)
+				ops->nat_hook = true;
 		}
 
 		chain->flags |= NFT_BASE_CHAIN;
-- 
2.13.6

