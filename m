Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26458369993;
	Thu, 29 Jan 2026 10:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769684079; cv=none; b=swyqD1dgjdz5p0qo54Dm38HfG6bsnHPe2TpqaKfBop+ON6xQ5WRn8LBPfc3iKtyl71y9YiCtZqPKQOHjRYzOOPP3rVw5Z41x0GSjRY6TH294qmCMEEwNoXzuwVJyR01pa5Q7CfZuL13TVg9JsZEaJMJK3Uwn3U/5MRt20cPcAhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769684079; c=relaxed/simple;
	bh=HpH5+4DmjTcC1TVMcaAlHFnX4oLnGUrwTKXPABThgPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tDYtgGxfk8swSJNy4cH1Tnre2z5w5Wg6Li6K2+d8YybC5KIFQHMq7wEuHylUZvcHhfTgJMN1aMoffWBRT4Lg331qxo9NaWlw9zqqR96zf5vDomKEVEYZdbGEwLcan7x//0690CzMHzLbROSQTLPnTsEykdru6zrk5K/t/teVwt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1F7F660516; Thu, 29 Jan 2026 11:54:36 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH v2 net-next 1/7] netfilter: Add ctx pointer in nf_flow_skb_encap_protocol/nf_flow_ip4_tunnel_proto signature
Date: Thu, 29 Jan 2026 11:54:21 +0100
Message-ID: <20260129105427.12494-2-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260129105427.12494-1-fw@strlen.de>
References: <20260129105427.12494-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lorenzo Bianconi <lorenzo@kernel.org>

Rely on nf_flowtable_ctx struct pointer in nf_flow_ip4_tunnel_proto and
nf_flow_skb_encap_protocol routine signature. This is a preliminary patch
to introduce IP6IP6 flowtable acceleration since nf_flowtable_ctx will
be used to store IP6IP6 tunnel info.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_flow_table_ip.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 11da560f38bf..283b3fe61919 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -295,15 +295,16 @@ static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
 	return NF_STOLEN;
 }
 
-static bool nf_flow_ip4_tunnel_proto(struct sk_buff *skb, u32 *psize)
+static bool nf_flow_ip4_tunnel_proto(struct nf_flowtable_ctx *ctx,
+				     struct sk_buff *skb)
 {
 	struct iphdr *iph;
 	u16 size;
 
-	if (!pskb_may_pull(skb, sizeof(*iph) + *psize))
+	if (!pskb_may_pull(skb, sizeof(*iph) + ctx->offset))
 		return false;
 
-	iph = (struct iphdr *)(skb_network_header(skb) + *psize);
+	iph = (struct iphdr *)(skb_network_header(skb) + ctx->offset);
 	size = iph->ihl << 2;
 
 	if (ip_is_fragment(iph) || unlikely(ip_has_options(size)))
@@ -313,7 +314,7 @@ static bool nf_flow_ip4_tunnel_proto(struct sk_buff *skb, u32 *psize)
 		return false;
 
 	if (iph->protocol == IPPROTO_IPIP)
-		*psize += size;
+		ctx->offset += size;
 
 	return true;
 }
@@ -329,8 +330,8 @@ static void nf_flow_ip4_tunnel_pop(struct sk_buff *skb)
 	skb_reset_network_header(skb);
 }
 
-static bool nf_flow_skb_encap_protocol(struct sk_buff *skb, __be16 proto,
-				       u32 *offset)
+static bool nf_flow_skb_encap_protocol(struct nf_flowtable_ctx *ctx,
+				       struct sk_buff *skb, __be16 proto)
 {
 	__be16 inner_proto = skb->protocol;
 	struct vlan_ethhdr *veth;
@@ -343,7 +344,7 @@ static bool nf_flow_skb_encap_protocol(struct sk_buff *skb, __be16 proto,
 
 		veth = (struct vlan_ethhdr *)skb_mac_header(skb);
 		if (veth->h_vlan_encapsulated_proto == proto) {
-			*offset += VLAN_HLEN;
+			ctx->offset += VLAN_HLEN;
 			inner_proto = proto;
 			ret = true;
 		}
@@ -351,14 +352,14 @@ static bool nf_flow_skb_encap_protocol(struct sk_buff *skb, __be16 proto,
 	case htons(ETH_P_PPP_SES):
 		if (nf_flow_pppoe_proto(skb, &inner_proto) &&
 		    inner_proto == proto) {
-			*offset += PPPOE_SES_HLEN;
+			ctx->offset += PPPOE_SES_HLEN;
 			ret = true;
 		}
 		break;
 	}
 
 	if (inner_proto == htons(ETH_P_IP))
-		ret = nf_flow_ip4_tunnel_proto(skb, offset);
+		ret = nf_flow_ip4_tunnel_proto(ctx, skb);
 
 	return ret;
 }
@@ -416,7 +417,7 @@ nf_flow_offload_lookup(struct nf_flowtable_ctx *ctx,
 {
 	struct flow_offload_tuple tuple = {};
 
-	if (!nf_flow_skb_encap_protocol(skb, htons(ETH_P_IP), &ctx->offset))
+	if (!nf_flow_skb_encap_protocol(ctx, skb, htons(ETH_P_IP)))
 		return NULL;
 
 	if (nf_flow_tuple_ip(ctx, skb, &tuple) < 0)
@@ -897,7 +898,7 @@ nf_flow_offload_ipv6_lookup(struct nf_flowtable_ctx *ctx,
 	struct flow_offload_tuple tuple = {};
 
 	if (skb->protocol != htons(ETH_P_IPV6) &&
-	    !nf_flow_skb_encap_protocol(skb, htons(ETH_P_IPV6), &ctx->offset))
+	    !nf_flow_skb_encap_protocol(ctx, skb, htons(ETH_P_IPV6)))
 		return NULL;
 
 	if (nf_flow_tuple_ipv6(ctx, skb, &tuple) < 0)
-- 
2.52.0

