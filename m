Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E6F3ACA6E;
	Tue, 17 Mar 2026 11:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773746981; cv=none; b=q5D6xxd5tYWMwpFp+Zf4BEZ2Zcjh+TGHPxG91cMXcOl/jyMcdVs6w9/OqLJIQuXeIIXQDJB/ogB+X7HUV1oE25n64rSv8J+XbBUG3HT6svMW1xuPfm07YssfK3o4rYe8iUBPpxSLYpJBfDz5udQk3Iy3BRggfS+xkdrn4JG8NRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773746981; c=relaxed/simple;
	bh=YcMXNExaaMbzYzXuoatZbKYSUP12prK3XS8GVq/Vi8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ACmEwO8KxSrTspJoTdLF/KwZ9CkyWq/UlW377qgDbm7ZbHaVJKGdhbF1VrR/3iU8wk6pWPbqOmecrTQHK5qEOC+u37LDDloo4/W1uQPDoUZ26jKGcXKVGxf249SJnj+E5UoY0hVXdRQqnA2fibxKPia+f+ei/4c8Qzzb3Tvk3JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=tTxfDz8C; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="tTxfDz8C"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2BDF960254;
	Tue, 17 Mar 2026 12:29:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773746972;
	bh=ye+4r2HOVohcgA7jp0/Dfr7YZoyhvKR3aFaPXLMXMxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tTxfDz8Ctlwj35w0BeSKLafCg+6V+d6gVNjcnB8pcfD9zlb8oWpFMpYjHr/9MCOFP
	 MPSZQx4J/20AaFJFKgm0W+1hMg+g1db0IxSj369zO8YRACssyPUlvpPV1SrXXiJBZB
	 bTERSy5wqXCxdx0Pa3GuXeIDvTwe4lJSat5ChTHeWji2uo0rj42RGL0X1++wVDd2l/
	 /wFOBACC+9lXPv/TU2PSmjzAHuDbA+6mRC4FixLqL5/Qr/EvuztvqrN9rASKy6+kid
	 aAmEiLmxaGqxwZdK5Th0lV7AUWUjYQLJjGEHQkCSlXVVF38gqJ+ieJknsrScw1dOc4
	 1/+FShigL3Z4Q==
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
Subject: [PATCH net-next,RFC 2/8] netfilter: flowtable: Add IPv6 bulking infrastructure for early ingress hook
Date: Tue, 17 Mar 2026 12:29:11 +0100
Message-ID: <20260317112917.4170466-3-pablo@netfilter.org>
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

Extend bulking infrastructure to support for IPv6. Split skb list in
bulks according to ethertype, output device and next hop. Then, send
each bulk through neighbour layer.

This only implements the flowtable RX bulking. The TX side comes as a
follow up patch in this series.

Co-developed-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h |   2 +
 net/netfilter/nf_flow_table_inet.c    |   2 +
 net/netfilter/nf_flow_table_ip.c      | 173 ++++++++++++++++++++++++++
 3 files changed, 177 insertions(+)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index ee98da9edc1b..3d41c739f634 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -348,6 +348,8 @@ unsigned int nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 				       const struct nf_hook_state *state);
 void __nf_flow_offload_ip_hook_list(void *priv, struct list_head *head,
 				    const struct nf_hook_state *state);
+void __nf_flow_offload_ipv6_hook_list(void *priv, struct list_head *head,
+				      const struct nf_hook_state *state);
 
 #if (IS_BUILTIN(CONFIG_NF_FLOW_TABLE) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) || \
     (IS_MODULE(CONFIG_NF_FLOW_TABLE) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES))
diff --git a/net/netfilter/nf_flow_table_inet.c b/net/netfilter/nf_flow_table_inet.c
index d0e7860c9d08..6efcb26c4523 100644
--- a/net/netfilter/nf_flow_table_inet.c
+++ b/net/netfilter/nf_flow_table_inet.c
@@ -84,6 +84,8 @@ __nf_flow_offload_hook_list(void *priv, struct sk_buff *unused,
 
 	if (flags & (1 << NFPROTO_IPV4) && !list_empty(&skb_ipv4_list))
 		__nf_flow_offload_ip_hook_list(priv, &skb_ipv4_list, state);
+	if (flags & (1 << NFPROTO_IPV6) && !list_empty(&skb_ipv6_list))
+		__nf_flow_offload_ipv6_hook_list(priv, &skb_ipv6_list, state);
 
 	list_splice_tail(&skb_ipv4_list, skb_list);
 	list_splice_tail(&skb_ipv6_list, skb_list);
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 41f4768ce715..98b5d5e022c8 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -1363,3 +1363,176 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	return nf_flow_queue_xmit(state->net, skb, &xmit);
 }
 EXPORT_SYMBOL_GPL(nf_flow_offload_ipv6_hook);
+
+static void nft_flow_v6_push_hdrs_list(struct net *net, struct sk_buff *first,
+				       struct flow_offload_tuple *other_tuple,
+				       struct in6_addr **ip6_daddr, int encap_limit)
+{
+	struct sk_buff *skb, *nskb;
+
+	skb_list_walk_safe(first, skb, nskb) {
+		if (nf_flow_tunnel_v6_push(net, skb, other_tuple, ip6_daddr, encap_limit) < 0) {
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
+static void nft_bulk_ipv6_receive(struct list_head *head, struct sk_buff *skb)
+{
+	const struct in6_addr *daddr;
+	const struct ipv6hdr *ip6h;
+	struct dst_entry *dst;
+	struct xfrm_state *x;
+	struct rt6_info *rt;
+	struct sk_buff *p;
+	int proto;
+
+	ip6h = ipv6_hdr(skb);
+	dst = skb_dst(skb);
+	BUG_ON(!dst);
+
+	rt = (struct rt6_info *)dst;
+	daddr = rt6_nexthop(rt, &ip6h->daddr);
+	x = dst_xfrm(dst);
+	proto = ip6h->nexthdr;
+
+	list_for_each_entry(p, head, list) {
+		const struct in6_addr *daddr2;
+		struct dst_entry *dst2;
+		struct ipv6hdr *ip6h2;
+		struct rt6_info *rt2;
+
+		if (p->protocol != htons(ETH_P_IPV6))
+			continue;
+
+		dst2 = skb_dst(p);
+		rt2 = (struct rt6_info *)dst2;
+		if (dst->dev != dst2->dev)
+			continue;
+
+		ip6h2 = ipv6_hdr(p);
+		daddr2 = rt6_nexthop(rt2, &ip6h2->daddr);
+		if (!ipv6_addr_equal(daddr, daddr2))
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
+
+	return;
+
+}
+
+void __nf_flow_offload_ipv6_hook_list(void *priv, struct list_head *head,
+				      const struct nf_hook_state *state)
+{
+	struct flow_offload_tuple_rhash *tuplehash;
+	struct nf_flowtable *flow_table = priv;
+	struct flow_offload_tuple *other_tuple;
+	enum flow_offload_tuple_dir dir;
+	struct nf_flowtable_ctx ctx = {
+		.in	= state->in,
+	};
+	struct in6_addr *ip6_daddr;
+	struct flow_offload *flow;
+	struct sk_buff *skb, *n;
+	struct neighbour *neigh;
+	LIST_HEAD(bulk_head);
+	LIST_HEAD(bulk_list);
+	LIST_HEAD(acc_list);
+	struct rt6_info *rt;
+	int ret;
+
+	list_for_each_entry_safe(skb, n, head, list) {
+		skb_list_del_init(skb);
+
+		ctx.hdrsize = 0;
+		ctx.offset = 0;
+
+		tuplehash = nf_flow_offload_ipv6_lookup(&ctx, flow_table, skb);
+		if (!tuplehash) {
+			list_add_tail(&skb->list, &acc_list);
+			continue;
+		}
+
+		ret = nf_flow_offload_ipv6_forward(&ctx, flow_table, tuplehash, skb,
+						   IPV6_DEFAULT_TNL_ENCAP_LIMIT);
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
+		nft_bulk_ipv6_receive(&bulk_head, skb);
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
+		rt = (struct rt6_info *)skb_dst(skb);
+
+		dir = tuplehash->tuple.dir;
+		flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
+		other_tuple = &flow->tuplehash[!dir].tuple;
+		ip6_daddr = &other_tuple->src_v6;
+
+		if (other_tuple->tun_num || other_tuple->encap_num)
+			nft_flow_v6_push_hdrs_list(state->net, skb, other_tuple, &ip6_daddr,
+						   IPV6_DEFAULT_TNL_ENCAP_LIMIT);
+
+		neigh = ip_neigh_gw6(rt->dst.dev, rt6_nexthop(rt, ip6_daddr));
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
+EXPORT_SYMBOL_GPL(__nf_flow_offload_ipv6_hook_list);
-- 
2.47.3

