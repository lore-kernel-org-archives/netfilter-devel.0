Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBB3449B10;
	Mon, 10 Aug 2026 19:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786390852; cv=none; b=SEqTW7WGV6yRBRaskvf8F3xivYLcv89/OIVMFUFMJklLwzlYfEptzydlTOtWN5m60W+n3fmot4f5LcJxGQh2SkN8ZkthVcjdcdZa4K9dX4HChttSj+ztWL0JJEdP7Kld+/hM0+5CdffikvPAKvRBghu/HjVlo4MI8zYXsDayAiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786390852; c=relaxed/simple;
	bh=K7Tbly5ZbzfX9MTQGGYV7B6LdOY+pTtJa5u3KjTq3Xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FH1lRZUpAP/9gU9XoOxTWyi8vC+MvavIHVdlCiQVq6llhvJW41KPDt58VRCYvhXshJfP5hKo1h0o9csnhgEj4cjZm6amddLYkZzaxj4W66uWhxfx0aGx2+6I5tyOKTadF2L5Glsd+NTenMT2AYVZOaFR4F7VDNpxskjDZnZdWO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rIuxNlgJ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rIuxNlgJ"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5D50E601BE;
	Mon, 10 Aug 2026 21:40:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786390833;
	bh=t1Jk8tVy/VX68p4WddBAWrLxeePTUSzW1yvTnTASBeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rIuxNlgJEHwqN7tP2pLN5cz0boP/2hcPQ3shT0C7/9ZJqdpvSiBuwgBbVm8rfg2AU
	 sSgh1fbqg9fMS6iOaZFtAy51y94mKfDUiJr5l/yMvcLnaMLP8cj14Q6IIaoLbxch/q
	 blUTOUQh7knXh8KT56g4m11D7D9c+HPBvAl40ZEzcjHsscCJLOo64fKTMDnAYQBh6i
	 4Rm9YxiFeWEF3Gi7IdaJXQn+harpRxDZalKFgycj15lHomOUQKcJFlsTpYWobKToqT
	 z09As99xOkDs2UqREF/j51k4aPy8xZexwD7n11dH85G6ngxlq1b2jKlysaiUxkfMKx
	 p8STXLnycp8Wg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 07/12] netfilter: flowtable: move ipv4 and ipv6 xmit path to function
Date: Mon, 10 Aug 2026 21:40:10 +0200
Message-ID: <20260810194015.932627-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260810194015.932627-1-pablo@netfilter.org>
References: <20260810194015.932627-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the existing ipv4 and ipv6 transmit path to functions in
preparation of the IPv4 over IPv6 and SIT support.

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 92 +++++++++++++++++++-------------
 1 file changed, 54 insertions(+), 38 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 3f417a43bd12..ff45f17f3c4a 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -801,33 +801,17 @@ static unsigned int nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
 	return NF_STOLEN;
 }
 
-unsigned int
-nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
-			const struct nf_hook_state *state)
+static int nf_flow_queue_xmit4(struct sk_buff *skb,
+			       struct flow_offload_tuple_rhash *tuplehash,
+			       const struct nf_hook_state *state)
 {
-	struct flow_offload_tuple_rhash *tuplehash;
-	struct nf_flowtable *flow_table = priv;
 	struct flow_offload_tuple *other_tuple;
 	enum flow_offload_tuple_dir dir;
-	struct nf_flowtable_ctx ctx = {
-		.in	= state->in,
-	};
 	struct nf_flow_xmit xmit = {};
 	struct flow_offload *flow;
 	struct neighbour *neigh;
 	struct rtable *rt;
 	__be32 ip_daddr;
-	int ret;
-
-	tuplehash = nf_flow_offload_lookup(&ctx, flow_table, skb);
-	if (!tuplehash)
-		return NF_ACCEPT;
-
-	ret = nf_flow_offload_forward(&ctx, flow_table, tuplehash, skb);
-	if (ret < 0)
-		return NF_DROP;
-	else if (ret == 0)
-		return NF_ACCEPT;
 
 	if (unlikely(tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM)) {
 		rt = dst_rtable(tuplehash->tuple.dst_cache);
@@ -881,6 +865,30 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 
 	return nf_flow_queue_xmit(state->net, skb, &xmit);
 }
+
+unsigned int
+nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
+			const struct nf_hook_state *state)
+{
+	struct flow_offload_tuple_rhash *tuplehash;
+	struct nf_flowtable *flow_table = priv;
+	struct nf_flowtable_ctx ctx = {
+		.in	= state->in,
+	};
+	int ret;
+
+	tuplehash = nf_flow_offload_lookup(&ctx, flow_table, skb);
+	if (!tuplehash)
+		return NF_ACCEPT;
+
+	ret = nf_flow_offload_forward(&ctx, flow_table, tuplehash, skb);
+	if (ret < 0)
+		return NF_DROP;
+	else if (ret == 0)
+		return NF_ACCEPT;
+
+	return nf_flow_queue_xmit4(skb, tuplehash, state);
+}
 EXPORT_SYMBOL_GPL(nf_flow_offload_ip_hook);
 
 static void nf_flow_nat_ipv6_tcp(struct sk_buff *skb, unsigned int thoff,
@@ -1121,33 +1129,17 @@ nf_flow_offload_ipv6_lookup(struct nf_flowtable_ctx *ctx,
 	return flow_offload_lookup(flow_table, &tuple);
 }
 
-unsigned int
-nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
-			  const struct nf_hook_state *state)
+static int nf_flow_queue_xmit6(struct sk_buff *skb,
+			       struct flow_offload_tuple_rhash *tuplehash,
+			       const struct nf_hook_state *state)
 {
-	struct flow_offload_tuple_rhash *tuplehash;
-	struct nf_flowtable *flow_table = priv;
 	struct flow_offload_tuple *other_tuple;
 	enum flow_offload_tuple_dir dir;
-	struct nf_flowtable_ctx ctx = {
-		.in	= state->in,
-	};
 	struct nf_flow_xmit xmit = {};
 	struct in6_addr *ip6_daddr;
 	struct flow_offload *flow;
 	struct neighbour *neigh;
 	struct rt6_info *rt;
-	int ret;
-
-	tuplehash = nf_flow_offload_ipv6_lookup(&ctx, flow_table, skb);
-	if (tuplehash == NULL)
-		return NF_ACCEPT;
-
-	ret = nf_flow_offload_ipv6_forward(&ctx, flow_table, tuplehash, skb);
-	if (ret < 0)
-		return NF_DROP;
-	else if (ret == 0)
-		return NF_ACCEPT;
 
 	if (unlikely(tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM)) {
 		rt = dst_rt6_info(tuplehash->tuple.dst_cache);
@@ -1202,4 +1194,28 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 
 	return nf_flow_queue_xmit(state->net, skb, &xmit);
 }
+
+unsigned int
+nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
+			  const struct nf_hook_state *state)
+{
+	struct flow_offload_tuple_rhash *tuplehash;
+	struct nf_flowtable *flow_table = priv;
+	struct nf_flowtable_ctx ctx = {
+		.in	= state->in,
+	};
+	int ret;
+
+	tuplehash = nf_flow_offload_ipv6_lookup(&ctx, flow_table, skb);
+	if (!tuplehash)
+		return NF_ACCEPT;
+
+	ret = nf_flow_offload_ipv6_forward(&ctx, flow_table, tuplehash, skb);
+	if (ret < 0)
+		return NF_DROP;
+	else if (ret == 0)
+		return NF_ACCEPT;
+
+	return nf_flow_queue_xmit6(skb, tuplehash, state);
+}
 EXPORT_SYMBOL_GPL(nf_flow_offload_ipv6_hook);
-- 
2.47.3

