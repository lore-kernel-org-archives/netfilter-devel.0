Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6BD7C7EE24
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 May 2023 05:35:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbjEKFfw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 May 2023 01:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235708AbjEKFfw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 May 2023 01:35:52 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 922351BEE
        for <netfilter-devel@vger.kernel.org>; Wed, 10 May 2023 22:35:50 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2 3/3] netfilter: flowtable: split IPv6 datapath in helper functions
Date:   Thu, 11 May 2023 07:35:35 +0200
Message-Id: <20230511053535.2571-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230511053535.2571-1-pablo@netfilter.org>
References: <20230511053535.2571-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add context structure and helper functions to look up for a matching
IPv6 entry in the flowtable and to forward packets.

No functional changes are intended.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: v2: fix crash in nf_flow_offload_ipv6_hook()

 net/netfilter/nf_flow_table_ip.c | 112 ++++++++++++++++++++-----------
 1 file changed, 71 insertions(+), 41 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 3fb476167d1d..d248763917ad 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -570,32 +570,31 @@ static void nf_flow_nat_ipv6(const struct flow_offload *flow,
 	}
 }
 
-static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
-			      struct flow_offload_tuple *tuple, u32 *hdrsize,
-			      u32 offset)
+static int nf_flow_tuple_ipv6(struct nf_flowtable_ctx *ctx, struct sk_buff *skb,
+			      struct flow_offload_tuple *tuple)
 {
 	struct flow_ports *ports;
 	struct ipv6hdr *ip6h;
 	unsigned int thoff;
 	u8 nexthdr;
 
-	thoff = sizeof(*ip6h) + offset;
+	thoff = sizeof(*ip6h) + ctx->offset;
 	if (!pskb_may_pull(skb, thoff))
 		return -1;
 
-	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + offset);
+	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + ctx->offset);
 
 	nexthdr = ip6h->nexthdr;
 	switch (nexthdr) {
 	case IPPROTO_TCP:
-		*hdrsize = sizeof(struct tcphdr);
+		ctx->hdrsize = sizeof(struct tcphdr);
 		break;
 	case IPPROTO_UDP:
-		*hdrsize = sizeof(struct udphdr);
+		ctx->hdrsize = sizeof(struct udphdr);
 		break;
 #ifdef CONFIG_NF_CT_PROTO_GRE
 	case IPPROTO_GRE:
-		*hdrsize = sizeof(struct gre_base_hdr);
+		ctx->hdrsize = sizeof(struct gre_base_hdr);
 		break;
 #endif
 	default:
@@ -605,7 +604,7 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 	if (ip6h->hop_limit <= 1)
 		return -1;
 
-	if (!pskb_may_pull(skb, thoff + *hdrsize))
+	if (!pskb_may_pull(skb, thoff + ctx->hdrsize))
 		return -1;
 
 	switch (nexthdr) {
@@ -625,65 +624,47 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 	}
 	}
 
-	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + offset);
+	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + ctx->offset);
 
 	tuple->src_v6		= ip6h->saddr;
 	tuple->dst_v6		= ip6h->daddr;
 	tuple->l3proto		= AF_INET6;
 	tuple->l4proto		= nexthdr;
-	tuple->iifidx		= dev->ifindex;
+	tuple->iifidx		= ctx->in->ifindex;
 	nf_flow_tuple_encap(skb, tuple);
 
 	return 0;
 }
 
-unsigned int
-nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
-			  const struct nf_hook_state *state)
+static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
+					struct nf_flowtable *flow_table,
+					struct flow_offload_tuple_rhash *tuplehash,
+					struct sk_buff *skb)
 {
-	struct flow_offload_tuple_rhash *tuplehash;
-	struct nf_flowtable *flow_table = priv;
-	struct flow_offload_tuple tuple = {};
 	enum flow_offload_tuple_dir dir;
-	const struct in6_addr *nexthop;
 	struct flow_offload *flow;
-	struct net_device *outdev;
 	unsigned int thoff, mtu;
-	u32 hdrsize, offset = 0;
 	struct ipv6hdr *ip6h;
-	struct rt6_info *rt;
-	int ret;
-
-	if (skb->protocol != htons(ETH_P_IPV6) &&
-	    !nf_flow_skb_encap_protocol(skb, htons(ETH_P_IPV6), &offset))
-		return NF_ACCEPT;
-
-	if (nf_flow_tuple_ipv6(skb, state->in, &tuple, &hdrsize, offset) < 0)
-		return NF_ACCEPT;
-
-	tuplehash = flow_offload_lookup(flow_table, &tuple);
-	if (tuplehash == NULL)
-		return NF_ACCEPT;
 
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 
-	mtu = flow->tuplehash[dir].tuple.mtu + offset;
+	mtu = flow->tuplehash[dir].tuple.mtu + ctx->offset;
 	if (unlikely(nf_flow_exceeds_mtu(skb, mtu)))
-		return NF_ACCEPT;
+		return 0;
 
-	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + offset);
-	thoff = sizeof(*ip6h) + offset;
+	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + ctx->offset);
+	thoff = sizeof(*ip6h) + ctx->offset;
 	if (nf_flow_state_check(flow, ip6h->nexthdr, skb, thoff))
-		return NF_ACCEPT;
+		return 0;
 
 	if (!nf_flow_dst_check(&tuplehash->tuple)) {
 		flow_offload_teardown(flow);
-		return NF_ACCEPT;
+		return 0;
 	}
 
-	if (skb_try_make_writable(skb, thoff + hdrsize))
-		return NF_DROP;
+	if (skb_try_make_writable(skb, thoff + ctx->hdrsize))
+		return -1;
 
 	flow_offload_refresh(flow_table, flow);
 
@@ -698,6 +679,52 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	if (flow_table->flags & NF_FLOWTABLE_COUNTER)
 		nf_ct_acct_update(flow->ct, tuplehash->tuple.dir, skb->len);
 
+	return 1;
+}
+
+static struct flow_offload_tuple_rhash *
+nf_flow_offload_ipv6_lookup(struct nf_flowtable_ctx *ctx,
+			    struct nf_flowtable *flow_table,
+			    struct sk_buff *skb)
+{
+	struct flow_offload_tuple tuple = {};
+
+	if (skb->protocol != htons(ETH_P_IPV6) &&
+	    !nf_flow_skb_encap_protocol(skb, htons(ETH_P_IPV6), &ctx->offset))
+		return NULL;
+
+	if (nf_flow_tuple_ipv6(ctx, skb, &tuple) < 0)
+		return NULL;
+
+	return flow_offload_lookup(flow_table, &tuple);
+}
+
+unsigned int
+nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
+			  const struct nf_hook_state *state)
+{
+	struct flow_offload_tuple_rhash *tuplehash;
+	struct nf_flowtable *flow_table = priv;
+	enum flow_offload_tuple_dir dir;
+	struct nf_flowtable_ctx ctx = {
+		.in	= state->in,
+	};
+	const struct in6_addr *nexthop;
+	struct flow_offload *flow;
+	struct net_device *outdev;
+	struct rt6_info *rt;
+	int ret;
+
+	tuplehash = nf_flow_offload_ipv6_lookup(&ctx, flow_table, skb);
+	if (tuplehash == NULL)
+		return NF_ACCEPT;
+
+	ret = nf_flow_offload_ipv6_forward(&ctx, flow_table, tuplehash, skb);
+	if (ret < 0)
+		return NF_DROP;
+	else if (ret == 0)
+		return NF_ACCEPT;
+
 	if (unlikely(tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM)) {
 		rt = (struct rt6_info *)tuplehash->tuple.dst_cache;
 		memset(skb->cb, 0, sizeof(struct inet6_skb_parm));
@@ -706,6 +733,9 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 		return nf_flow_xmit_xfrm(skb, state, &rt->dst);
 	}
 
+	dir = tuplehash->tuple.dir;
+	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
+
 	switch (tuplehash->tuple.xmit_type) {
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		rt = (struct rt6_info *)tuplehash->tuple.dst_cache;
-- 
2.30.2

