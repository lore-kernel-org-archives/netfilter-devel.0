Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B159288530;
	Tue, 17 Mar 2026 11:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773746981; cv=none; b=VaqRO1SDcD83ajY1EABYhyb8F+CIPOiEBSr+Z1toZkmeZRRRAArrafeolyccHOAPQmGHdvUNxKFNuqLmMFhY4ez0sriu4Les88DNjyAjHUbbLOSvOXnvOAGH/OshQpRTZUcPFzNxOX2Dcm1bf+NQnbdW1g02YWNRGI70i4Du2ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773746981; c=relaxed/simple;
	bh=qfvyVpTQD6Wh0H95LNXK+Hxa2uWVELx/tCfc+b+4pqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ofkc+hSaUimtTiKW2UQcN7xyE0hwmhAxlkyzBRGIEzWWbxT2UpAm8665V1uOSaMG0Di/fM/Hx3jPRGpwpRULxBzfzwERP/qcpBluaUDC7spYjaHwywEPkrsBvvKF4ukJQ91cKRXKD7FbIBxJni1kWSlKFA/LA/AZd6QjA0nawvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=wID5qgsy; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="wID5qgsy"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6ECD360253;
	Tue, 17 Mar 2026 12:29:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773746971;
	bh=OE0NvHCUam29DswxS4IyA1Fdh2MJgYdvcKg12p/TpJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wID5qgsyyXexeqzbGVpOzbGc8m2wz50HDMKqKE1Q3Pzw4BbOs5wzq8/hKVMs4RjP6
	 Z/fUuOCPzKOO/PzvjptgZsn38FY5FMgBn9yNqScIlDkkWsPns7OaOwl4wi598DxQtz
	 vebM4guRWFQCAb4VfnUh/qwkAzZg0F2nNGskaZMsvV5UGgcOtOhvF/8u+ZVYYtAy62
	 ALQT/mYe144P9IjpcfxESuJYfIuhnc9sRGuhVPUox7UOFrcg41AbVSpfvCnmFWv8H+
	 cxA+MXKAw8EnIbYjvKPjt6xIPJgug4d5FOfltXqKO44XyXPZYAdCjmPLmsOPQA596U
	 FO6xjjgfqSGzA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org,
	steffen.klassert@secunet.com,
	antony.antony@secunet.com
Subject: [PATCH net-next,RFC 1/8] netfilter: flowtable: Add basic bulking infrastructure for early ingress hook
Date: Tue, 17 Mar 2026 12:29:10 +0100
Message-ID: <20260317112917.4170466-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260317112917.4170466-1-pablo@netfilter.org>
References: <20260317112917.4170466-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for registering an early_ingress hook for the flowtable to
deal with the skb list. Split initial this list in bulks according to
ethertype, output device, next hop and tos.

Then, send each skb bulk through neighbour layer. The xmit path is not
yet listified, ie. the bulk is splitted in individual skbuffs that are
sent to xmit path, one by one, at this stage.

This only implements the flowtable RX bulking. The TX side comes as a
follow up patch in this series.

Co-developed-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h |  11 +-
 net/netfilter/nf_flow_table_inet.c    |  79 ++++++++++
 net/netfilter/nf_flow_table_ip.c      | 209 ++++++++++++++++++++++++++
 3 files changed, 298 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index b09c11c048d5..ee98da9edc1b 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -18,6 +18,13 @@ struct nf_flow_rule;
 struct flow_offload;
 enum flow_offload_tuple_dir;
 
+struct nft_bulk_cb {
+	struct sk_buff *last;
+	struct flow_offload_tuple_rhash *tuplehash;
+};
+
+#define NFT_BULK_CB(skb) ((struct nft_bulk_cb *)(skb)->cb)
+
 struct nf_flow_key {
 	struct flow_dissector_key_meta			meta;
 	struct flow_dissector_key_control		control;
@@ -65,6 +72,7 @@ struct nf_flowtable_type {
 	void				(*get)(struct nf_flowtable *ft);
 	void				(*put)(struct nf_flowtable *ft);
 	nf_hookfn			*hook;
+	nf_hookfn			*hook_list;
 	struct module			*owner;
 };
 
@@ -77,7 +85,6 @@ struct nf_flowtable {
 	unsigned int			flags;		/* readonly in datapath */
 	int				priority;	/* control path (padding hole) */
 	struct rhashtable		rhashtable;	/* datapath, read-mostly members come first */
-
 	struct list_head		list;		/* slowpath parts */
 	const struct nf_flowtable_type	*type;
 	struct delayed_work		gc_work;
@@ -339,6 +346,8 @@ unsigned int nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 				     const struct nf_hook_state *state);
 unsigned int nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 				       const struct nf_hook_state *state);
+void __nf_flow_offload_ip_hook_list(void *priv, struct list_head *head,
+				    const struct nf_hook_state *state);
 
 #if (IS_BUILTIN(CONFIG_NF_FLOW_TABLE) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) || \
     (IS_MODULE(CONFIG_NF_FLOW_TABLE) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES))
diff --git a/net/netfilter/nf_flow_table_inet.c b/net/netfilter/nf_flow_table_inet.c
index b0f199171932..d0e7860c9d08 100644
--- a/net/netfilter/nf_flow_table_inet.c
+++ b/net/netfilter/nf_flow_table_inet.c
@@ -42,6 +42,82 @@ nf_flow_offload_inet_hook(void *priv, struct sk_buff *skb,
 	return NF_ACCEPT;
 }
 
+static unsigned int
+__nf_flow_offload_hook_list(void *priv, struct sk_buff *unused,
+			    const struct nf_hook_state *state, u32 flags)
+{
+	struct list_head *skb_list = state->skb_list;
+	struct sk_buff *skb, *next;
+	struct vlan_ethhdr *veth;
+	LIST_HEAD(skb_ipv4_list);
+	LIST_HEAD(skb_ipv6_list);
+	__be16 proto;
+
+	list_for_each_entry_safe(skb, next, skb_list, list) {
+		skb_reset_network_header(skb);
+		if (!skb_transport_header_was_set(skb))
+			skb_reset_transport_header(skb);
+		skb_reset_mac_len(skb);
+
+		switch (skb->protocol) {
+		case htons(ETH_P_8021Q):
+			veth = (struct vlan_ethhdr *)skb_mac_header(skb);
+			proto = veth->h_vlan_encapsulated_proto;
+			break;
+		case htons(ETH_P_PPP_SES):
+			nf_flow_pppoe_proto(skb, &proto);
+			break;
+		default:
+			proto = skb->protocol;
+			break;
+		}
+
+		switch (proto) {
+		case htons(ETH_P_IP):
+			list_move_tail(&skb->list, &skb_ipv4_list);
+			break;
+		case htons(ETH_P_IPV6):
+			list_move_tail(&skb->list, &skb_ipv6_list);
+			break;
+		}
+	}
+
+	if (flags & (1 << NFPROTO_IPV4) && !list_empty(&skb_ipv4_list))
+		__nf_flow_offload_ip_hook_list(priv, &skb_ipv4_list, state);
+
+	list_splice_tail(&skb_ipv4_list, skb_list);
+	list_splice_tail(&skb_ipv6_list, skb_list);
+
+	if (!list_empty(skb_list))
+		return NF_ACCEPT;
+
+	return NF_STOLEN;
+}
+
+static unsigned int
+nf_flow_offload_ip_hook_list(void *priv, struct sk_buff *unused,
+			     const struct nf_hook_state *state)
+{
+	return __nf_flow_offload_hook_list(priv, unused, state,
+					   1 << NFPROTO_IPV4);
+}
+
+static unsigned int
+nf_flow_offload_ipv6_hook_list(void *priv, struct sk_buff *unused,
+				 const struct nf_hook_state *state)
+{
+	return __nf_flow_offload_hook_list(priv, unused, state,
+					   1 << NFPROTO_IPV6);
+}
+
+static unsigned int
+nf_flow_offload_inet_hook_list(void *priv, struct sk_buff *unused,
+			       const struct nf_hook_state *state)
+{
+	return __nf_flow_offload_hook_list(priv, unused, state,
+					   (1 << NFPROTO_IPV4) | (1 << NFPROTO_IPV6));
+}
+
 static int nf_flow_rule_route_inet(struct net *net,
 				   struct flow_offload *flow,
 				   enum flow_offload_tuple_dir dir,
@@ -72,6 +148,7 @@ static struct nf_flowtable_type flowtable_inet = {
 	.action		= nf_flow_rule_route_inet,
 	.free		= nf_flow_table_free,
 	.hook		= nf_flow_offload_inet_hook,
+	.hook_list	= nf_flow_offload_inet_hook_list,
 	.owner		= THIS_MODULE,
 };
 
@@ -82,6 +159,7 @@ static struct nf_flowtable_type flowtable_ipv4 = {
 	.action		= nf_flow_rule_route_ipv4,
 	.free		= nf_flow_table_free,
 	.hook		= nf_flow_offload_ip_hook,
+	.hook_list	= nf_flow_offload_ip_hook_list,
 	.owner		= THIS_MODULE,
 };
 
@@ -92,6 +170,7 @@ static struct nf_flowtable_type flowtable_ipv6 = {
 	.action		= nf_flow_rule_route_ipv6,
 	.free		= nf_flow_table_free,
 	.hook		= nf_flow_offload_ipv6_hook,
+	.hook_list	= nf_flow_offload_ipv6_hook_list,
 	.owner		= THIS_MODULE,
 };
 
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 3fdb10d9bf7f..41f4768ce715 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -752,6 +752,215 @@ static int nf_flow_encap_push(struct sk_buff *skb,
 	return 0;
 }
 
+static void nft_flow_v4_push_hdrs_list(struct net *net, struct sk_buff *first,
+				       struct flow_offload_tuple *other_tuple,
+				       __be32 *ip_daddr)
+{
+	struct sk_buff *skb, *nskb;
+
+	skb_list_walk_safe(first, skb, nskb) {
+		if (nf_flow_tunnel_v4_push(net, skb, other_tuple, ip_daddr) < 0) {
+			skb_mark_not_on_list(skb);
+			kfree_skb(skb);
+			continue;
+		}
+		if (nf_flow_encap_push(skb, other_tuple) < 0) {
+			skb_mark_not_on_list(skb);
+			kfree_skb(skb);
+			continue;
+		}
+	}
+}
+
+static void nft_bulk_receive(struct list_head *head, struct sk_buff *skb)
+{
+	const struct iphdr *iph;
+	struct dst_entry *dst;
+	struct xfrm_state *x;
+	struct sk_buff *p;
+	struct rtable *rt;
+	__be32 daddr;
+	int proto;
+	__u8 tos;
+
+	iph = ip_hdr(skb);
+	dst = skb_dst(skb);
+	BUG_ON(!dst);
+
+	rt = (struct rtable *)dst;
+	daddr = rt_nexthop(rt, iph->daddr);
+	x = dst_xfrm(dst);
+	proto = iph->protocol;
+	tos = iph->tos;
+
+	list_for_each_entry(p, head, list) {
+		struct dst_entry *dst2;
+		struct rtable *rt2;
+		struct iphdr *iph2;
+		__be32 daddr2;
+
+		if (p->protocol != htons(ETH_P_IP))
+			continue;
+
+		dst2 = skb_dst(p);
+		rt2 = (struct rtable *)dst2;
+		if (dst->dev != dst2->dev)
+			continue;
+
+		iph2 = ip_hdr(p);
+		daddr2 = rt_nexthop(rt2, iph2->daddr);
+		if (daddr != daddr2)
+			continue;
+
+		if (tos != iph2->tos)
+			continue;
+
+		if (x != dst_xfrm(dst2))
+			continue;
+
+		goto found;
+	}
+
+	goto out;
+
+found:
+	if (NFT_BULK_CB(p)->last == p)
+		skb_shinfo(p)->frag_list = skb;
+	else
+		NFT_BULK_CB(p)->last->next = skb;
+
+	NFT_BULK_CB(p)->last = skb;
+
+	return;
+out:
+	/* First skb */
+	NFT_BULK_CB(skb)->last = skb;
+	list_add_tail(&skb->list, head);
+	skb->priority = rt_tos2priority(iph->tos);
+
+	return;
+}
+
+static void nf_flow_neigh_xmit_list(struct sk_buff *skb, struct net_device *outdev, const void *daddr)
+{
+	struct sk_buff *iter = skb->next;
+	int hlen;
+
+	skb->dev = outdev;
+	hlen = dev_hard_header(skb, outdev, ntohs(skb->protocol), daddr, NULL, skb->len);
+	if (hlen < 0) {
+		kfree_skb_list(skb);
+		return;
+	}
+
+	skb_reset_mac_header(skb);
+
+	while (iter) {
+		iter->dev = outdev;
+		skb_push(iter, hlen);
+		skb_copy_to_linear_data(iter, skb->data, hlen);
+		skb_reset_mac_header(iter);
+		iter = iter->next;
+	}
+
+	iter = skb;
+	while (iter) {
+		struct sk_buff *next;
+
+		next = iter->next;
+		iter->next = NULL;
+		dev_queue_xmit(iter);
+		iter = next;
+	}
+}
+
+void __nf_flow_offload_ip_hook_list(void *priv, struct list_head *head,
+				    const struct nf_hook_state *state)
+{
+	struct flow_offload_tuple_rhash *tuplehash;
+	struct nf_flowtable *flow_table = priv;
+	struct flow_offload_tuple *other_tuple;
+	enum flow_offload_tuple_dir dir;
+	struct nf_flowtable_ctx ctx = {
+		.in	= state->in,
+	};
+	struct flow_offload *flow;
+	struct sk_buff *skb, *n;
+	struct neighbour *neigh;
+	LIST_HEAD(bulk_head);
+	LIST_HEAD(bulk_list);
+	LIST_HEAD(acc_list);
+	struct rtable *rt;
+	__be32 ip_daddr;
+	int ret;
+
+	list_for_each_entry_safe(skb, n, head, list) {
+		skb_list_del_init(skb);
+
+		ctx.hdrsize = 0;
+		ctx.offset = 0;
+
+		tuplehash = nf_flow_offload_lookup(&ctx, flow_table, skb);
+		if (!tuplehash) {
+			list_add_tail(&skb->list, &acc_list);
+			continue;
+		}
+
+		ret = nf_flow_offload_forward(&ctx, flow_table, tuplehash, skb);
+		if (ret < 0) {
+			kfree_skb(skb);
+			continue;
+		} else if (ret == 0) {
+			list_add_tail(&skb->list, &acc_list);
+			continue;
+		}
+
+		skb_dst_set_noref(skb, tuplehash->tuple.dst_cache);
+		memset(skb->cb, 0, sizeof(struct nft_bulk_cb));
+		NFT_BULK_CB(skb)->tuplehash = tuplehash;
+
+		list_add_tail(&skb->list, &bulk_list);
+	}
+
+	list_splice_init(&acc_list, head);
+
+	list_for_each_entry_safe(skb, n, &bulk_list, list) {
+		skb_list_del_init(skb);
+		nft_bulk_receive(&bulk_head, skb);
+	}
+
+	list_for_each_entry_safe(skb, n, &bulk_head, list) {
+
+		list_del_init(&skb->list);
+
+		skb->next = skb_shinfo(skb)->frag_list;
+		skb_shinfo(skb)->frag_list = NULL;
+
+		tuplehash = NFT_BULK_CB(skb)->tuplehash;
+		skb_dst_set_noref(skb, tuplehash->tuple.dst_cache);
+		rt = (struct rtable *)skb_dst(skb);
+
+		dir = tuplehash->tuple.dir;
+		flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
+		other_tuple = &flow->tuplehash[!dir].tuple;
+		ip_daddr = other_tuple->src_v4.s_addr;
+
+		if (other_tuple->tun_num || other_tuple->encap_num)
+			nft_flow_v4_push_hdrs_list(state->net, skb, other_tuple, &ip_daddr);
+
+		neigh = ip_neigh_gw4(rt->dst.dev, rt_nexthop(rt, ip_daddr));
+		if (IS_ERR(neigh)) {
+			kfree_skb_list(skb);
+			continue;
+		}
+
+		nf_flow_neigh_xmit_list(skb, rt->dst.dev, neigh->ha);
+	}
+
+	BUG_ON(!list_empty(&bulk_head));
+}
+EXPORT_SYMBOL_GPL(__nf_flow_offload_ip_hook_list);
+
 unsigned int
 nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 			const struct nf_hook_state *state)
-- 
2.47.3

