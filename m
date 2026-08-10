Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E213E442B1B;
	Mon, 10 Aug 2026 19:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786390845; cv=none; b=dA/BHhPrXyBPChEtvkXMNQxvo/Ad+5ceoTfjQzkzZx03V4b3Iz3HZudmm1iM1IGc0eQ4AxB2XM4FGrHi2ihDvoDv9mbketKRv10jKqjS3KSZIj3enqJK34gIQeO0Cmkh71VADCTaI3+VSkEwHbc2sQBN+Yq7aTfVDvXy4ojvH4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786390845; c=relaxed/simple;
	bh=sGPbjTrK4sfewwkXmOq80OnQGjDW5MFnDkBGPtxFKNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5Diodi5fK4C1UK3LYVANOKnn8MFwSwyWC0TMTVQ6ZVxVqMno2P+4nZAizFP82QFy8YF8WM0ba7LbFSCJdN8HlX9RtftzY7Y5qx5fh1FJAyUK7pOVDEjS6V7n8QmFPxgzkASme18UeJVkP1B7Duvns3kEtrm3vCrMrdbEVKPQL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=fmfLvGpe; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="fmfLvGpe"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0E502601BD;
	Mon, 10 Aug 2026 21:40:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786390832;
	bh=G9Y4FyXuFhfiAsTmqiYFEpl7tfVhC0cTvGw0sND/AaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fmfLvGpepu1EW903lcrSR5QrnNw7062NpyWe+aPnzm3WXYC8CeVq9CUZ8iLTOglNd
	 eCZlSeC3EnHPIIIyrGkL3PAdJAsAMxVaTL4do1Mn/5f3c82EodYi4Gb5tGJUbIAidM
	 N4aoMAjpJ2K1/eUxF7BIooy2bATS5eQPlJs6CFudWMUpMDNkp2QLQRRj4wLRIXdNHL
	 /MH0llstPvpAXZwK7kNpx8+y6NdAhWxDhc2NoGbsLIAZHth5F0pyOvh+OFP4zzUu2f
	 Xp2bgFPtaUfj5J9NuPWh3DDvsN75X1blD+1qAavFCHKfj2tWQ/peMLezZS6ExcbKLU
	 12Xgt/ed9C7Gg==
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
Subject: [PATCH net-next 06/12] netfilter: flowtable: store ethertype in flowtable context
Date: Mon, 10 Aug 2026 21:40:09 +0200
Message-ID: <20260810194015.932627-7-pablo@netfilter.org>
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

Add a new field to store the ethertype of the packet, skipping layer 2
encapsulation. Store the ether_type in the context after parsing the
layer 2 header for the first time and then use it later on.

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 47 +++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 7692ae7aa853..3f417a43bd12 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -147,6 +147,7 @@ static bool ip_has_options(unsigned int thoff)
 
 struct nf_flowtable_ctx {
 	const struct net_device	*in;
+	__be16			ether_type;
 	u32			offset;
 	u32			hdrsize;
 	struct {
@@ -161,7 +162,6 @@ static void nf_flow_tuple_encap(struct nf_flowtable_ctx *ctx,
 				struct sk_buff *skb,
 				struct flow_offload_tuple *tuple)
 {
-	__be16 inner_proto = skb->protocol;
 	struct vlan_ethhdr *veth;
 	struct pppoe_hdr *phdr;
 	struct ipv6hdr *ip6h;
@@ -179,19 +179,17 @@ static void nf_flow_tuple_encap(struct nf_flowtable_ctx *ctx,
 		veth = (struct vlan_ethhdr *)skb_mac_header(skb);
 		tuple->encap[i].id = ntohs(veth->h_vlan_TCI);
 		tuple->encap[i].proto = skb->protocol;
-		inner_proto = veth->h_vlan_encapsulated_proto;
 		offset += VLAN_HLEN;
 		break;
 	case htons(ETH_P_PPP_SES):
 		phdr = (struct pppoe_hdr *)skb_network_header(skb);
 		tuple->encap[i].id = ntohs(phdr->sid);
 		tuple->encap[i].proto = skb->protocol;
-		inner_proto = *((__be16 *)(phdr + 1));
 		offset += PPPOE_SES_HLEN;
 		break;
 	}
 
-	switch (inner_proto) {
+	switch (ctx->ether_type) {
 	case htons(ETH_P_IP):
 		iph = (struct iphdr *)(skb_network_header(skb) + offset);
 		if (ctx->tun.inner_proto == IPPROTO_IPIP) {
@@ -377,10 +375,10 @@ static void nf_flow_ip_tunnel_pop(struct nf_flowtable_ctx *ctx,
 }
 
 static bool nf_flow_skb_encap_protocol(struct nf_flowtable_ctx *ctx,
-				       struct sk_buff *skb, __be16 proto)
+				       struct sk_buff *skb)
 {
-	__be16 inner_proto = skb->protocol;
 	struct vlan_ethhdr *veth;
+	__be16 ether_type;
 	bool ret = false;
 
 	switch (skb->protocol) {
@@ -389,22 +387,27 @@ static bool nf_flow_skb_encap_protocol(struct nf_flowtable_ctx *ctx,
 			return false;
 
 		veth = (struct vlan_ethhdr *)skb_mac_header(skb);
-		if (veth->h_vlan_encapsulated_proto == proto) {
-			ctx->offset += VLAN_HLEN;
-			inner_proto = proto;
-			ret = true;
-		}
+		ctx->ether_type = veth->h_vlan_encapsulated_proto;
+		ctx->offset += VLAN_HLEN;
+		ret = true;
 		break;
 	case htons(ETH_P_PPP_SES):
-		if (nf_flow_pppoe_proto(skb, &inner_proto) &&
-		    inner_proto == proto) {
-			ctx->offset += PPPOE_SES_HLEN;
-			ret = true;
-		}
+		if (!nf_flow_pppoe_proto(skb, &ether_type))
+			return false;
+
+		ctx->ether_type = ether_type;
+		ctx->offset += PPPOE_SES_HLEN;
+		ret = true;
+		break;
+	case htons(ETH_P_IP):
+	case htons(ETH_P_IPV6):
+		ctx->ether_type = skb->protocol;
 		break;
+	default:
+		return false;
 	}
 
-	switch (inner_proto) {
+	switch (ctx->ether_type) {
 	case htons(ETH_P_IP):
 		ret = nf_flow_ip4_tunnel_proto(ctx, skb);
 		break;
@@ -456,7 +459,10 @@ nf_flow_offload_lookup(struct nf_flowtable_ctx *ctx,
 {
 	struct flow_offload_tuple tuple = {};
 
-	if (!nf_flow_skb_encap_protocol(ctx, skb, htons(ETH_P_IP)))
+	if (!nf_flow_skb_encap_protocol(ctx, skb))
+		return NULL;
+
+	if (unlikely(ctx->ether_type != htons(ETH_P_IP)))
 		return NULL;
 
 	if (nf_flow_tuple_ip(ctx, skb, &tuple) < 0)
@@ -1103,7 +1109,10 @@ nf_flow_offload_ipv6_lookup(struct nf_flowtable_ctx *ctx,
 {
 	struct flow_offload_tuple tuple = {};
 
-	if (!nf_flow_skb_encap_protocol(ctx, skb, htons(ETH_P_IPV6)))
+	if (!nf_flow_skb_encap_protocol(ctx, skb))
+		return NULL;
+
+	if (unlikely(ctx->ether_type != htons(ETH_P_IPV6)))
 		return NULL;
 
 	if (nf_flow_tuple_ipv6(ctx, skb, &tuple) < 0)
-- 
2.47.3

