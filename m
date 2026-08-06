Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA132435521
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Aug 2026 22:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786055751; cv=none; b=u4wLbucbcBLTX5xJNmilUgnk3vVI14qerfVjor15x/5XUP0Nir4QFdU4YPlRyKjogPbZpOoIMR4dTTZ4gB2mEOwE1TJJEJ39oNQAZcqGQuQRAteUQv8JV49ASJf/i8L9DBTuUwdtrSiFxsYvEodyTs7eJwS1sjVs9nBwCkzETJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786055751; c=relaxed/simple;
	bh=nTOXwoStV2YGLIoXMR9eAFLcV0sEKsxSlVw8XEGlDeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8m6BJgWvtFq9JAEjDAD4D2y4jrk7wfPHmbnHrNmKM1dLvUivDj8b2/qua8Z42fD/dlLUvdJlEclZzin1c13sjbXZALtCTzNGMq/gkO0edl8NUC6YlWFTFwayVvZVs1FmnvxBkQZkd7v28R63BGEAPS9zCwfhfvuT8ecip+luTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=e9wVmH4u; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="e9wVmH4u"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6B442601BE;
	Fri,  7 Aug 2026 00:35:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786055745;
	bh=jd0wPBvS//xdDiqAaqixvEPjv6ogQ2gIvwJ92ox0VbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e9wVmH4u5AaKq6riAYBnc0O/kgEMJcdYZLAZht2Kxv/wUlX5IkUb9Zv56EIwWMeut
	 geP3XfyirggDaxr4qfltSsrKHGgQwRYNOzJwkB+OyPjGX4ZRkzRN19P7pwhEbH5X8N
	 hqCx5pjDh0A0wntV88hDnrbQqwaMygRdoKnA98J6aHQy0KH0V2WRKTOrE/7xrxstFL
	 5zfs3Bt1sGhystuBvzrdd6T0g0Gvrn13vxt2nVjkIiuiUgb6R+qvyJeIYupHbFXi22
	 tWq4a5OBQZV98hI5cbLhUwFIJ5oApZfirH6vxKUw3iU4C8b+9ilKgUk/+P6BRyAgE3
	 984ylJ57vBPGg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: lorenzo.bianconi@oss.qualcomm.com,
	lorenzo@kernel.org
Subject: [PATCH nf-next 6/7] netfilter: flowtable: move ipv4 and ipv6 xmit path to function
Date: Fri,  7 Aug 2026 00:35:34 +0200
Message-ID: <20260806223535.523098-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260806223535.523098-1-pablo@netfilter.org>
References: <20260806223535.523098-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the existing ipv4 and ipv6 transmit path to functions in
preparation of the IPv4 over IPv6 and SIT support.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 92 +++++++++++++++++++-------------
 1 file changed, 54 insertions(+), 38 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 4437f3a13cb2..18febca1dcef 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -800,33 +800,17 @@ static unsigned int nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
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
@@ -879,6 +863,30 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 
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
@@ -1119,33 +1127,17 @@ nf_flow_offload_ipv6_lookup(struct nf_flowtable_ctx *ctx,
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
@@ -1199,4 +1191,28 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 
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

