Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5700442111
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Aug 2026 22:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786055752; cv=none; b=uX9rG3wHmeEnENX75As/kfDUIV9knOULv7e0bnQzlUYNYoQakTLhbr6slsGhx/DiQJ3SNnTF7vQILOtXPrfcRLWyltUBXeJd5ge+Scn/xH+AcJMzWvRLmowwuhBAmVFK/iEK/6T5hW+NDZp3vkIupF7Ercbvp4D7c01rweqixoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786055752; c=relaxed/simple;
	bh=76znoqcVEr5aaRjmLmFODOZ64iV9gdsT74Rr1qr4Aoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gMM3U8jW6C2FKXjY+GUlXPgWZMApkHzcPE/Mf7ZZxyvvmg3WxSVRBqQfXOOwdDgC57Y+W5QVHnpGSFLFdi0wC5lQR9wMQoTLhRGSiqY8dv1Bn2NmBDcP+cfqfQb79PxCBaYiZ1ChdBdVSgTPsNTVlXAf/O6CpNjweUqNt3fGfXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UZ0k+MQ/; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UZ0k+MQ/"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 91D47601BD;
	Fri,  7 Aug 2026 00:35:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786055744;
	bh=doH8wisKXvLtGO1uN8n5XoGU5t/XzKHLc9HXbhx25GA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UZ0k+MQ/sVUHSKjX3HYNTOXdba1bF1HbUfoRt4T5uLFD6PX8Q2YfTVq5LICs0Se6B
	 DUM/cLuSRh+DKloQbPDXxYt3UknQYPMVhfiKbk7XdDx0qtN9uiR8YP1u8j+jFpu7ZM
	 GJJEwA2HhFDHqxJiaAUfW/qx2YCIRLpOIMqvvGkPHXxTTkcx8lgS0wyGKqKUapusU4
	 qqP6f/MSdvEQEuWZd9XRzOzGMo20isKf2zt42thKT4RaWtzbef4Hqy4ktEDGDtPtcZ
	 G1IilLXOtUY8spPkcaQGp90Gqh4nPZ6Jdan7L8wz9ysuW6h9u0j9gpcTBoaWTH/+my
	 44KBI4Fb2pgPA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: lorenzo.bianconi@oss.qualcomm.com,
	lorenzo@kernel.org
Subject: [PATCH nf-next 5/7] netfilter: flowtable: store ethertype in flowtable context
Date: Fri,  7 Aug 2026 00:35:33 +0200
Message-ID: <20260806223535.523098-6-pablo@netfilter.org>
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

Add a new field to store the ethertype of the packet, skipping layer 2
encapsulation. Store the ether_type in the context after parsing the
layer 2 header for the first time and then use it later on.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 47 +++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index ed90809b206e..4437f3a13cb2 100644
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
@@ -376,10 +374,10 @@ static void nf_flow_ip_tunnel_pop(struct nf_flowtable_ctx *ctx,
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
@@ -388,22 +386,27 @@ static bool nf_flow_skb_encap_protocol(struct nf_flowtable_ctx *ctx,
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
@@ -455,7 +458,10 @@ nf_flow_offload_lookup(struct nf_flowtable_ctx *ctx,
 {
 	struct flow_offload_tuple tuple = {};
 
-	if (!nf_flow_skb_encap_protocol(ctx, skb, htons(ETH_P_IP)))
+	if (!nf_flow_skb_encap_protocol(ctx, skb))
+		return NULL;
+
+	if (unlikely(ctx->ether_type != htons(ETH_P_IP)))
 		return NULL;
 
 	if (nf_flow_tuple_ip(ctx, skb, &tuple) < 0)
@@ -1101,7 +1107,10 @@ nf_flow_offload_ipv6_lookup(struct nf_flowtable_ctx *ctx,
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

