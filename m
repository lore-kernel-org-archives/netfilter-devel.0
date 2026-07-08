Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8EF41169C
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Jul 2026 09:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783503193; cv=none; b=WfMoLdADibiu1ewHqqkql96H2SSaXVY3cITflB7bq3DoF2rvckH/k0JzJJpuDlO5Ogok05k47QoNYazd+aNDB0xdiqVEy/IfIyFymN/yyCg6YKhKJ7bWp3h2MryZa0DVZIAavT+HsNc9y3vnc5dD4GXU5y3dMwJtSRlHde28Ur8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783503193; c=relaxed/simple;
	bh=Jx5JFG/1vdHS9RjnlFqAzAZwAUQkmi4lOrvbTd8zVXc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vFi2rSU+egCVYqe6FwP2Ako98jEV8zscj7/QrCaeav3P0jOJE7DIZHX94/QMimLYir0X6v/6eFojSEcGVLP5+f0ahhbhgtAyxEUnj6O7bARSGU5JQBfrxDkya/GsZSgHBiUE5rk9Urz0QCGKZC97ocPz542ZTk0VLlYwlWxeWFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cUdho4Yc; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cUdho4Yc"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 507B160580
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Jul 2026 11:32:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1783503179;
	bh=DOlUOb29S33YyG0MehE6WDsOO7YK1xk2hRHIBSIsf6g=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=cUdho4Yce6g3jOqqwPLAFg1z5QLjTc8aTPfj7lfr21TPP2shlQNSrvacYlm9LzkO/
	 QACAJosxS8TXCdLDRU0scSP7mo5oxUt3X3rvR7FtzVr2ndk+dNJcBA96eUchVE7Jqb
	 Rlz7ypBie5tOHV3UTYUmnpE95vLqh2fxDDLabEtedOwphF+IeFUBAou0ZZ/65oFaze
	 wCGZagmJ91B6fIBeZWsuiy+DGPL59MbIULwsEf90KEpiFhI/FHUjj5zKvNIt+LEcs1
	 Em8zuSGGwpdykguykrkqcyQGzbsr7Ql6JjR0Jom0W8ZxHQbYAMFFkVU5ks3hK+NAEG
	 JgR5IgzkMLAew==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v1 4/4] netfilter: flowtable: initial bridge support
Date: Wed,  8 Jul 2026 11:32:50 +0200
Message-ID: <20260708093250.1187068-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708093250.1187068-1-pablo@netfilter.org>
References: <20260708093250.1187068-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds bridge flowtable support, this allows to define a
shortcut between two bridge ports. This is complementary to the
existing inet family flowtable support.

Set up does not require userspace updates, an example ruleset to
enable the flowtable in the bridge family is provided here below:

 table bridge x {
        flowtable y {
                hook ingress priority 0
                devices = { veth0, veth1 }
        }
        chain forward {
                type filter hook forward priority 0
                ip protocol tcp flow add @y counter
                counter
        }
 }

I decided to add an explicit nft_flow_offload_bridge_eval() instead of
recycling the existing inet function by adding branches to skip the
routing part which is obviously not needed in the bridge path. I
consider this mostly boiler plate for feature extensibility and better
maintability is better to keep it separated. Similarly, the bridge hook
that represents the flowtable bridge datapath is implemented in a
separated function.

Although connection tracking in the bridge does not support the tracking
of IP flows encapsulated in PPPoE and VLAN tracking yet, there are
scenarios that involved PPPoE and VLAN that can be supported already,
such as those where packets flows through the bridge with no tagging,
eg. a VLAN device is used as a bridge port which decapsulates the
packets at the ingress path.

Tested with:
- Plain forwarding between bridge ports with no VLAN tagging.
- VLAN device used in bridged ports.

The bridge vlan filtering supported is untested at this stage based on
previous work by Eric Woudstra.

Hardware offload is disabled until there is a driver supporting this.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v1: Different approach to what Eric Woudstra proposes:
    - Instead of extending the existing _eval() and _hook() function
      that represent the flowtable offload stage and datapath, add new
      specific functions. It is more code, but it is boilerplate code
      and it might help to make it more maintainable as new specific
      bridge features are added, I believe.
    - As noted in the commit description, bridge vlan filtering support
      is untested, I have used the existing code posted by Eric Woudstra
      in this regard.
   
 include/net/netfilter/nf_flow_table.h |   7 ++
 net/netfilter/nf_flow_table_inet.c    |  12 +++
 net/netfilter/nf_flow_table_ip.c      | 134 ++++++++++++++++++++++++++
 net/netfilter/nf_flow_table_offload.c |   8 +-
 net/netfilter/nf_flow_table_path.c    |  95 ++++++++++++++++++
 net/netfilter/nft_flow_offload.c      |  88 ++++++++++++++++-
 6 files changed, 340 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index ce414118962f..6e76a6879ff3 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -248,6 +248,8 @@ struct nft_pktinfo;
 int nft_flow_route(const struct nft_pktinfo *pkt, const struct nf_conn *ct,
 		   struct nf_flow_route *route, enum ip_conntrack_dir dir,
 		   struct nft_flowtable *ft);
+int nft_flow_bridge(struct flow_offload *flow, const struct nft_pktinfo *pkt,
+		    enum ip_conntrack_dir dir, struct nft_flowtable *ft);
 
 static inline int
 nf_flow_table_offload_add_cb(struct nf_flowtable *flow_table,
@@ -342,6 +344,8 @@ unsigned int nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 				     const struct nf_hook_state *state);
 unsigned int nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 				       const struct nf_hook_state *state);
+unsigned int nf_flow_offload_bridge_hook(void *priv, struct sk_buff *skb,
+					 const struct nf_hook_state *state);
 
 #if (IS_BUILTIN(CONFIG_NF_FLOW_TABLE) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) || \
     (IS_MODULE(CONFIG_NF_FLOW_TABLE) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES))
@@ -377,6 +381,9 @@ int nf_flow_rule_route_ipv4(struct net *net, struct flow_offload *flow,
 int nf_flow_rule_route_ipv6(struct net *net, struct flow_offload *flow,
 			    enum flow_offload_tuple_dir dir,
 			    struct nf_flow_rule *flow_rule);
+int nf_flow_rule_bridge(struct net *net, struct flow_offload *flow,
+			enum flow_offload_tuple_dir dir,
+			struct nf_flow_rule *flow_rule);
 
 int nf_flow_table_offload_init(void);
 void nf_flow_table_offload_exit(void);
diff --git a/net/netfilter/nf_flow_table_inet.c b/net/netfilter/nf_flow_table_inet.c
index b0f199171932..44790a0d3012 100644
--- a/net/netfilter/nf_flow_table_inet.c
+++ b/net/netfilter/nf_flow_table_inet.c
@@ -65,6 +65,15 @@ static int nf_flow_rule_route_inet(struct net *net,
 	return err;
 }
 
+static struct nf_flowtable_type flowtable_bridge = {
+	.family		= NFPROTO_BRIDGE,
+	.init		= nf_flow_table_init,
+	.setup		= nf_flow_table_offload_setup,
+	.free		= nf_flow_table_free,
+	.hook		= nf_flow_offload_bridge_hook,
+	.owner		= THIS_MODULE,
+};
+
 static struct nf_flowtable_type flowtable_inet = {
 	.family		= NFPROTO_INET,
 	.init		= nf_flow_table_init,
@@ -97,6 +106,7 @@ static struct nf_flowtable_type flowtable_ipv6 = {
 
 static int __init nf_flow_inet_module_init(void)
 {
+	nft_register_flowtable_type(&flowtable_bridge);
 	nft_register_flowtable_type(&flowtable_ipv4);
 	nft_register_flowtable_type(&flowtable_ipv6);
 	nft_register_flowtable_type(&flowtable_inet);
@@ -109,6 +119,7 @@ static void __exit nf_flow_inet_module_exit(void)
 	nft_unregister_flowtable_type(&flowtable_inet);
 	nft_unregister_flowtable_type(&flowtable_ipv6);
 	nft_unregister_flowtable_type(&flowtable_ipv4);
+	nft_unregister_flowtable_type(&flowtable_bridge);
 }
 
 module_init(nf_flow_inet_module_init);
@@ -118,5 +129,6 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
 MODULE_ALIAS_NF_FLOWTABLE(AF_INET);
 MODULE_ALIAS_NF_FLOWTABLE(AF_INET6);
+MODULE_ALIAS_NF_FLOWTABLE(AF_BRIDGE);
 MODULE_ALIAS_NF_FLOWTABLE(1); /* NFPROTO_INET */
 MODULE_DESCRIPTION("Netfilter flow table mixed IPv4/IPv6 module");
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 44f4d74f2982..ce4998ac44fe 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -1172,3 +1172,137 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	return nf_flow_queue_xmit(state->net, skb, &xmit);
 }
 EXPORT_SYMBOL_GPL(nf_flow_offload_ipv6_hook);
+
+static int nf_flow_bridge_xmit(struct net *net,
+			       struct nf_flowtable *flow_table,
+			       struct flow_offload *flow,
+			       enum flow_offload_tuple_dir dir,
+			       struct sk_buff *skb)
+{
+	struct flow_offload_tuple *other_tuple = &flow->tuplehash[!dir].tuple;
+	struct flow_offload_tuple *this_tuple = &flow->tuplehash[dir].tuple;
+	struct nf_flow_xmit xmit = {};
+
+	xmit.outdev = dev_get_by_index_rcu(net, this_tuple->out.ifidx);
+	if (!xmit.outdev) {
+		flow_offload_teardown(flow);
+		return NF_DROP;
+	}
+
+	if (flow_table->flags & NF_FLOWTABLE_COUNTER)
+		nf_ct_acct_update(flow->ct, dir, skb->len);
+
+	xmit.dest = this_tuple->out.h_dest;
+	xmit.source = this_tuple->out.h_source;
+	xmit.tuple = other_tuple;
+	xmit.needs_gso_segment = this_tuple->needs_gso_segment;
+
+	return nf_flow_queue_xmit(net, skb, &xmit);
+}
+
+static unsigned int
+nf_flow_offload_ip_bridge(void *priv, struct sk_buff *skb,
+			  const struct nf_hook_state *state)
+{
+	struct flow_offload_tuple_rhash *tuplehash;
+	struct nf_flowtable *flow_table = priv;
+	enum flow_offload_tuple_dir dir;
+	struct nf_flowtable_ctx ctx = {
+		.in	= state->in,
+	};
+	struct flow_offload *flow;
+	unsigned int thoff;
+	struct iphdr *iph;
+
+	tuplehash = nf_flow_offload_lookup(&ctx, flow_table, skb);
+	if (!tuplehash)
+		return NF_ACCEPT;
+
+	dir = tuplehash->tuple.dir;
+	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
+
+	iph = (struct iphdr *)(skb_network_header(skb) + ctx.offset);
+	thoff = (iph->ihl * 4) + ctx.offset;
+	if (nf_flow_state_check(flow, iph->protocol, skb, thoff))
+		return NF_ACCEPT;
+
+	if (skb_ensure_writable(skb, thoff + ctx.hdrsize))
+		return NF_DROP;
+
+	flow_offload_refresh(flow_table, flow, false);
+	nf_flow_encap_pop(&ctx, skb, tuplehash);
+	skb_clear_tstamp(skb);
+
+	return nf_flow_bridge_xmit(state->net, flow_table, flow, dir, skb);
+}
+
+static unsigned int
+nf_flow_offload_ipv6_bridge(void *priv, struct sk_buff *skb,
+			    const struct nf_hook_state *state)
+{
+	struct flow_offload_tuple_rhash *tuplehash;
+	struct nf_flowtable *flow_table = priv;
+	enum flow_offload_tuple_dir dir;
+	struct nf_flowtable_ctx ctx = {
+		.in	= state->in,
+	};
+	struct flow_offload *flow;
+	struct ipv6hdr *ip6h;
+	unsigned int thoff;
+
+	tuplehash = nf_flow_offload_ipv6_lookup(&ctx, flow_table, skb);
+	if (!tuplehash)
+		return NF_ACCEPT;
+
+	dir = tuplehash->tuple.dir;
+	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
+
+	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + ctx.offset);
+	thoff = sizeof(*ip6h) + ctx.offset;
+	if (nf_flow_state_check(flow, ip6h->nexthdr, skb, thoff))
+		return NF_ACCEPT;
+
+	if (skb_ensure_writable(skb, thoff + ctx.hdrsize))
+		return NF_DROP;
+
+	flow_offload_refresh(flow_table, flow, false);
+	nf_flow_encap_pop(&ctx, skb, tuplehash);
+	skb_clear_tstamp(skb);
+
+	return nf_flow_bridge_xmit(state->net, flow_table, flow, dir, skb);
+}
+
+unsigned int
+nf_flow_offload_bridge_hook(void *priv, struct sk_buff *skb,
+			    const struct nf_hook_state *state)
+{
+	struct vlan_ethhdr *veth;
+	__be16 proto;
+
+	switch (skb->protocol) {
+	case htons(ETH_P_8021Q):
+		if (!pskb_may_pull(skb, skb_mac_offset(skb) + sizeof(*veth)))
+			return NF_ACCEPT;
+
+		veth = (struct vlan_ethhdr *)skb_mac_header(skb);
+		proto = veth->h_vlan_encapsulated_proto;
+		break;
+	case htons(ETH_P_PPP_SES):
+		if (!nf_flow_pppoe_proto(skb, &proto))
+			return NF_ACCEPT;
+		break;
+	default:
+		proto = skb->protocol;
+		break;
+	}
+
+	switch (proto) {
+	case htons(ETH_P_IP):
+		return nf_flow_offload_ip_bridge(priv, skb, state);
+	case htons(ETH_P_IPV6):
+		return nf_flow_offload_ipv6_bridge(priv, skb, state);
+	}
+
+	return NF_ACCEPT;
+}
+EXPORT_SYMBOL_GPL(nf_flow_offload_bridge_hook);
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index d26874f1b15f..81c6313f660c 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1101,9 +1101,11 @@ nf_flow_offload_work_alloc(struct nf_flowtable *flowtable,
 	return offload;
 }
 
-static bool nf_flow_offload_unsupported(struct flow_offload *flow)
+static bool nf_flow_offload_unsupported(struct nf_flowtable *flowtable,
+					struct flow_offload *flow)
 {
-	if (flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.tun_num ||
+	if (flowtable->type->family == NFPROTO_BRIDGE ||
+	    flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.tun_num ||
 	    flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.tun_num)
 		return true;
 
@@ -1125,7 +1127,7 @@ void nf_flow_offload_refresh(struct nf_flowtable *flowtable,
 void nf_flow_offload_add(struct nf_flowtable *flowtable,
 			 struct flow_offload *flow)
 {
-	if (nf_flow_offload_unsupported(flow))
+	if (nf_flow_offload_unsupported(flowtable, flow))
 		return;
 
 	__set_bit(NF_FLOW_HW, &flow->flags);
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 007e9781902a..119eecd4b1db 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -8,6 +8,7 @@
 #include <linux/spinlock.h>
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <linux/netfilter/nf_tables.h>
+#include <linux/if_vlan.h>
 #include <net/ip.h>
 #include <net/inet_dscp.h>
 #include <net/netfilter/nf_tables.h>
@@ -360,3 +361,97 @@ int nft_flow_route(const struct nft_pktinfo *pkt, const struct nf_conn *ct,
 	return -ENOENT;
 }
 EXPORT_SYMBOL_GPL(nft_flow_route);
+
+static int nft_dev_fill_br_vlan_path(struct net_device_path_ctx *ctx,
+				     struct net_device_path_stack *stack,
+				     const struct net_device *dev)
+{
+	const struct net_device *br_dev;
+	struct net_device_path *path;
+
+	if (!netif_is_bridge_port(dev))
+		return -1;
+
+	br_dev = netdev_master_upper_dev_get_rcu((struct net_device *)dev);
+	if (!br_dev || !br_dev->netdev_ops->ndo_fill_forward_path)
+		return -1;
+
+	path = dev_fwd_path(stack);
+	if (!path)
+		return -1;
+
+	memset(path, 0, sizeof(struct net_device_path));
+	ctx->dev = dev;
+
+	if (br_dev->netdev_ops->ndo_fill_forward_path(ctx, path) < 0)
+		return -1;
+
+	return 0;
+}
+
+static int nft_dev_fill_bridge_path(struct flow_offload *flow,
+				    struct nft_flowtable *ft,
+				    enum ip_conntrack_dir dir,
+				    const struct net_device *dev,
+				    unsigned char *src_ha,
+				    unsigned char *dst_ha)
+{
+	struct flow_offload_tuple *this_tuple = &flow->tuplehash[dir].tuple;
+	struct net_device_path_stack stack;
+	struct nft_forward_info info = {};
+	struct net_device_path_ctx ctx;
+	int i, j = 0;
+
+	nft_dev_fill_forward_path_init(&ctx, dev, dst_ha);
+
+	if (dev_fill_forward_path(&ctx, &stack) < 0 ||
+	    nft_dev_fill_br_vlan_path(&ctx, &stack, dev) < 0 ||
+	    nft_dev_path_info(&stack, &info, dst_ha, &ft->data) < 0)
+		return -1;
+
+	if (!nft_flowtable_find_dev(info.indev, ft))
+		return -1;
+
+	this_tuple->iifidx = info.indev->ifindex;
+	for (i = info.num_encaps - 1; i >= 0; i--) {
+		this_tuple->encap[j].id = info.encap[i].id;
+		this_tuple->encap[j].proto = info.encap[i].proto;
+		if (info.ingress_vlans & BIT(i))
+			this_tuple->in_vlan_ingress |= BIT(j);
+		j++;
+	}
+	this_tuple->encap_num = info.num_encaps;
+
+	ether_addr_copy(this_tuple->out.h_source, src_ha);
+	ether_addr_copy(this_tuple->out.h_dest, dst_ha);
+	this_tuple->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
+
+	return 0;
+}
+
+int nft_flow_bridge(struct flow_offload *flow, const struct nft_pktinfo *pkt,
+		    enum ip_conntrack_dir dir, struct nft_flowtable *ft)
+{
+	struct flow_offload_tuple *other_tuple = &flow->tuplehash[!dir].tuple;
+	struct flow_offload_tuple *this_tuple = &flow->tuplehash[dir].tuple;
+	const struct net_device *outdev = nft_out(pkt);
+	const struct net_device *indev = nft_in(pkt);
+	struct ethhdr *eth = eth_hdr(pkt->skb);
+	int err;
+
+	err = nft_dev_fill_bridge_path(flow, ft, dir, indev,
+				       eth->h_source, eth->h_dest);
+	if (err < 0)
+		return err;
+
+	err = nft_dev_fill_bridge_path(flow, ft, !dir, outdev,
+				       eth->h_dest, eth->h_source);
+	if (err < 0)
+		return err;
+
+	this_tuple->out.ifidx = other_tuple->iifidx;
+	other_tuple->out.ifidx = this_tuple->iifidx;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nft_flow_bridge);
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 32b4281038dd..d1f145a401d1 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -135,6 +135,64 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	regs->verdict.code = NFT_BREAK;
 }
 
+static void nft_flow_offload_bridge_eval(const struct nft_expr *expr,
+					 struct nft_regs *regs,
+					 const struct nft_pktinfo *pkt)
+{
+	struct nft_flow_offload *priv = nft_expr_priv(expr);
+	struct nf_flowtable *flowtable = &priv->flowtable->data;
+	struct tcphdr _tcph, *tcph = NULL;
+	enum ip_conntrack_info ctinfo;
+	struct flow_offload *flow;
+	enum ip_conntrack_dir dir;
+	struct nf_conn *ct;
+	int ret;
+
+	/* Is this an IP packet? If not, skip. */
+	if (!pkt->flags)
+		goto out;
+
+	ct = nf_ct_get(pkt->skb, &ctinfo);
+	if (!ct || !nf_ct_is_confirmed(ct))
+		goto out;
+
+	switch (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum) {
+	case IPPROTO_TCP:
+		tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt),
+					  sizeof(_tcph), &_tcph);
+		if (unlikely(!tcph || tcph->fin || tcph->rst ||
+			     !nf_conntrack_tcp_established(ct)))
+			goto out;
+		break;
+	case IPPROTO_UDP:
+		break;
+	}
+
+	if (test_and_set_bit(IPS_OFFLOAD_BIT, &ct->status))
+		goto out;
+
+	flow = flow_offload_alloc(ct);
+	if (!flow)
+		goto err_flow_forward;
+
+	dir = CTINFO2DIR(ctinfo);
+	if (nft_flow_bridge(flow, pkt, dir, priv->flowtable) < 0)
+		goto err_flow_add;
+
+	ret = flow_offload_add(flowtable, flow);
+	if (ret < 0)
+		goto err_flow_add;
+
+	return;
+
+err_flow_add:
+	flow_offload_free(flow);
+err_flow_forward:
+	clear_bit(IPS_OFFLOAD_BIT, &ct->status);
+out:
+	regs->verdict.code = NFT_BREAK;
+}
+
 static int nft_flow_offload_validate(const struct nft_ctx *ctx,
 				     const struct nft_expr *expr)
 {
@@ -142,7 +200,8 @@ static int nft_flow_offload_validate(const struct nft_ctx *ctx,
 
 	if (ctx->family != NFPROTO_IPV4 &&
 	    ctx->family != NFPROTO_IPV6 &&
-	    ctx->family != NFPROTO_INET)
+	    ctx->family != NFPROTO_INET &&
+	    ctx->family != NFPROTO_BRIDGE)
 		return -EOPNOTSUPP;
 
 	return nft_chain_validate_hooks(ctx->chain, hook_mask);
@@ -235,6 +294,27 @@ static struct nft_expr_type nft_flow_offload_type __read_mostly = {
 	.owner		= THIS_MODULE,
 };
 
+static const struct nft_expr_ops nft_flow_offload_bridge_ops = {
+	.type		= &nft_flow_offload_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_flow_offload)),
+	.eval		= nft_flow_offload_bridge_eval,
+	.init		= nft_flow_offload_init,
+	.activate	= nft_flow_offload_activate,
+	.deactivate	= nft_flow_offload_deactivate,
+	.destroy	= nft_flow_offload_destroy,
+	.validate	= nft_flow_offload_validate,
+	.dump		= nft_flow_offload_dump,
+};
+
+static struct nft_expr_type nft_flow_offload_bridge_type __read_mostly = {
+	.name		= "flow_offload",
+	.family		= NFPROTO_BRIDGE,
+	.ops		= &nft_flow_offload_bridge_ops,
+	.policy		= nft_flow_offload_policy,
+	.maxattr	= NFTA_FLOW_MAX,
+	.owner		= THIS_MODULE,
+};
+
 static int flow_offload_netdev_event(struct notifier_block *this,
 				     unsigned long event, void *ptr)
 {
@@ -264,8 +344,14 @@ static int __init nft_flow_offload_module_init(void)
 	if (err < 0)
 		goto register_expr;
 
+	err = nft_register_expr(&nft_flow_offload_bridge_type);
+	if (err < 0)
+		goto register_bridge_expr;
+
 	return 0;
 
+register_bridge_expr:
+	nft_unregister_expr(&nft_flow_offload_type);
 register_expr:
 	unregister_netdevice_notifier(&flow_offload_netdev_notifier);
 err:
-- 
2.47.3

