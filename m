Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37BE3446CC;
	Wed, 26 Nov 2025 20:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764190591; cv=none; b=thejFaLyYub37Vc3n2IUzCLZ4TUv3NQLwOzhJG8JIK8ycAbOSyinrDkXUo1hf/qy32R8bN1ygnbx/lWdCDVLj0RsP6OihzJvwJGyfJc6bndYbh42q8MCYpBvu+Zr5R39F8V8mhjiE3t4VJ7sbbkQEp0GLDUNtD1jVoHnCGOvUJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764190591; c=relaxed/simple;
	bh=/XVYGizZcqYyyyNVwTp6ok3l73Hw2vEFagWoFSMANZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uy+D1bJf1KyIr87YMR+C5Ww44CdxvgrRVB1X4MOuqb6s/9xSyFvGlPL1URcjB8NfFT14lmFqeomrEkeQi/5ladKfBOPdxN9gkJP0ut8Il/zH3xDeXZlN4xaOs+wSX0U0/lCJ6h34sjRVgTN41PoShZgilcSe6BUxrgDZ+B22CrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lkvuaiZX; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lkvuaiZX"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4C68E60276;
	Wed, 26 Nov 2025 21:56:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1764190587;
	bh=84TTsxGk2nyN0iv48tSJGXNgPxKrWmE9Jmkl2573eTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lkvuaiZXaaWs7pm0LvzuK20vpY8PH6WrdWmag3OcyzOQTJjR+9VCCElTjlSt0Ia83
	 AmTReUlQvtES+b17QnJuD8NTonL1qq3JLvrRkBnIqzHRdqqWvJXlvUut7fhDJFKT9h
	 Fu0FO5Edb6hFl8uB1l/Xjdcqq5M0nxGnUIA2xWe3Cp+kp8FB2SvzZ09hTAQwY75ACq
	 rA/pGFJSkTG1x4+xSUmNn8y2LfDDWpxfdbzusijFK8d3eRHfUIAIIprqYy6M/ovIcn
	 xoOk4U7h4fZsg9OtsDnFshIqoPtHlBnhORLo+oWJSL4ysBfuaNNa7HKVnF3ekO0eWn
	 vU++sjMzcynQg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 06/16] netfilter: flowtable: use tuple address to calculate next hop
Date: Wed, 26 Nov 2025 20:56:01 +0000
Message-ID: <20251126205611.1284486-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251126205611.1284486-1-pablo@netfilter.org>
References: <20251126205611.1284486-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This simplifies IPIP tunnel support coming in follow up patches.

No function changes are intended.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 61ab3102c8ec..ac6641a866e0 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -480,6 +480,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 {
 	struct flow_offload_tuple_rhash *tuplehash;
 	struct nf_flowtable *flow_table = priv;
+	struct flow_offload_tuple *other_tuple;
 	enum flow_offload_tuple_dir dir;
 	struct nf_flowtable_ctx ctx = {
 		.in	= state->in,
@@ -488,6 +489,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	struct flow_offload *flow;
 	struct neighbour *neigh;
 	struct rtable *rt;
+	__be32 ip_daddr;
 	int ret;
 
 	tuplehash = nf_flow_offload_lookup(&ctx, flow_table, skb);
@@ -510,8 +512,10 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
+	other_tuple = &flow->tuplehash[!dir].tuple;
+	ip_daddr = other_tuple->src_v4.s_addr;
 
-	if (nf_flow_encap_push(skb, &flow->tuplehash[!dir].tuple) < 0)
+	if (nf_flow_encap_push(skb, other_tuple) < 0)
 		return NF_DROP;
 
 	switch (tuplehash->tuple.xmit_type) {
@@ -522,7 +526,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 			flow_offload_teardown(flow);
 			return NF_DROP;
 		}
-		neigh = ip_neigh_gw4(rt->dst.dev, rt_nexthop(rt, flow->tuplehash[!dir].tuple.src_v4.s_addr));
+		neigh = ip_neigh_gw4(rt->dst.dev, rt_nexthop(rt, ip_daddr));
 		if (IS_ERR(neigh)) {
 			flow_offload_teardown(flow);
 			return NF_DROP;
@@ -787,11 +791,13 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 {
 	struct flow_offload_tuple_rhash *tuplehash;
 	struct nf_flowtable *flow_table = priv;
+	struct flow_offload_tuple *other_tuple;
 	enum flow_offload_tuple_dir dir;
 	struct nf_flowtable_ctx ctx = {
 		.in	= state->in,
 	};
 	struct nf_flow_xmit xmit = {};
+	struct in6_addr *ip6_daddr;
 	struct flow_offload *flow;
 	struct neighbour *neigh;
 	struct rt6_info *rt;
@@ -817,8 +823,10 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
+	other_tuple = &flow->tuplehash[!dir].tuple;
+	ip6_daddr = &other_tuple->src_v6;
 
-	if (nf_flow_encap_push(skb, &flow->tuplehash[!dir].tuple) < 0)
+	if (nf_flow_encap_push(skb, other_tuple) < 0)
 		return NF_DROP;
 
 	switch (tuplehash->tuple.xmit_type) {
@@ -829,7 +837,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 			flow_offload_teardown(flow);
 			return NF_DROP;
 		}
-		neigh = ip_neigh_gw6(rt->dst.dev, rt6_nexthop(rt, &flow->tuplehash[!dir].tuple.src_v6));
+		neigh = ip_neigh_gw6(rt->dst.dev, rt6_nexthop(rt, ip6_daddr));
 		if (IS_ERR(neigh)) {
 			flow_offload_teardown(flow);
 			return NF_DROP;
-- 
2.47.3

