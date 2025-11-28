Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82AA221B195;
	Fri, 28 Nov 2025 00:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764289443; cv=none; b=Idm9sKt1BNgAJSSe01J7cmGEatbsxK8CX1DKiaVGxdohntr+0zFBcdn5WH+ivIdLNNwyQPOb5B/UTnA6clZ56H+YktBnqL318RhOrUuJ3cwdijXjVONOPlRJU71oizhntn73X76yo/soBGWLm1g66RG6i50JaIrmKpYnz4Xc/xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764289443; c=relaxed/simple;
	bh=Ew3/BmsMMV+xYnvwwSEvwsY24q5acbuAkVBEmxR5DKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uaFyyaAW/ZvMBsdQrftBW5NRe7+zg6x1Afo6CHqP328sajoQVXexRjDEYV9AvAzzw5QLX7k9lIcegMpzMd20c2V58gjShFBjnO9OLdRC8+fVBBLtrvl+JMU2yZeqFUSxE2VHfdfA7f5TQsMStNa6aprS/stgGB9GlRicyiPHmi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FHX6YPqK; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FHX6YPqK"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E7FD46027A;
	Fri, 28 Nov 2025 01:23:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1764289438;
	bh=wuFbqKGRKpiClPqm543i1emDC716+1qL2PxM7mQPeVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FHX6YPqKHzuh+KZHmmOPMj7NZNVerk3obdUjFcUqee2269ecTH3e5J9dnU39KxxvU
	 6oITp9FhPAqyYPhf8Eu9o5oKRnsvHfTnNsx3X8V8zGpYxllogZdGrBkn4Zsginr0er
	 U3Z0rln6IbKkPBcnwgOGqXptFQQge7qs1G12zdEp7oCKPPHsNkCWAGGZue4QDSrEck
	 EePgG9ydLo1IdOHNsfGIRmwhGDPNg2FHBDbhMmzChTHGL1faRSD14xSj2zlsFVA6Xc
	 SU5qSmtyKJQ4llDpwyaXwbC3Q6Q+f8/pBX+/Uffu8H2DtE+LV5zosO+LeXxgs9Y0b2
	 8J+xhMnsAO6BA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 07/17] netfilter: flowtable: use tuple address to calculate next hop
Date: Fri, 28 Nov 2025 00:23:34 +0000
Message-ID: <20251128002345.29378-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251128002345.29378-1-pablo@netfilter.org>
References: <20251128002345.29378-1-pablo@netfilter.org>
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
index ee6ec63257d1..083ceb64ac17 100644
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

