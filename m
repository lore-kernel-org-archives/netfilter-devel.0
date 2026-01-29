Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02AB3793DD;
	Thu, 29 Jan 2026 10:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769684083; cv=none; b=oYNzAm/SwK5Bmn5tQ3EGiBDAHbHZ1eEclQ+aZoA7/CwJSiEBi2q6nX3f7Y6z8qkV3ifc13T4HQZg/gVamImf2wb072XawTqfbUibxkCPnH7V76OAI1hXXgsUt15hHKqFtsFj9aELwp4JFes7wpB5ONV3Ewqeaox2OWNFo7bBOjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769684083; c=relaxed/simple;
	bh=wSGFSN1nQHmQTTeW7+DBe1vH+md+OrxzQ1xLStgYkzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XzW6fybV+Lrq6sR46XYZsg53or4+A2ZVYJ26GVSgnbqPraj4gjKywADfVNUGWdW24SBaXH83rcjou1U31NeVuFcjE5iedVFKr9KUrSCT3MujKncSIccY5XCcCwzg6/X9ZcDYNy15SPDj+fk5NVA5i3HUXOa/lxSDoV70cMFr8+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 72E4160577; Thu, 29 Jan 2026 11:54:40 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH v2 net-next 2/7] netfilter: Introduce tunnel metadata info in nf_flowtable_ctx struct
Date: Thu, 29 Jan 2026 11:54:22 +0100
Message-ID: <20260129105427.12494-3-fw@strlen.de>
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

Add tunnel hdr_size and tunnel proto fields in nf_flowtable_ctx struct
in order to store IP tunnel header size and protocol used during IPIP
and IP6IP6 tunnel sw offloading decapsulation and avoid recomputing them
during tunnel header pop since this is constant for IPv6.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_flow_table_ip.c | 41 +++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 283b3fe61919..ddfaddfa57be 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -144,6 +144,18 @@ static bool ip_has_options(unsigned int thoff)
 	return thoff != sizeof(struct iphdr);
 }
 
+struct nf_flowtable_ctx {
+	const struct net_device	*in;
+	u32			offset;
+	u32			hdrsize;
+	struct {
+		/* Tunnel IP header size */
+		u32 hdr_size;
+		/* IP tunnel protocol */
+		u8 proto;
+	} tun;
+};
+
 static void nf_flow_tuple_encap(struct sk_buff *skb,
 				struct flow_offload_tuple *tuple)
 {
@@ -186,12 +198,6 @@ static void nf_flow_tuple_encap(struct sk_buff *skb,
 	}
 }
 
-struct nf_flowtable_ctx {
-	const struct net_device	*in;
-	u32			offset;
-	u32			hdrsize;
-};
-
 static int nf_flow_tuple_ip(struct nf_flowtable_ctx *ctx, struct sk_buff *skb,
 			    struct flow_offload_tuple *tuple)
 {
@@ -313,20 +319,22 @@ static bool nf_flow_ip4_tunnel_proto(struct nf_flowtable_ctx *ctx,
 	if (iph->ttl <= 1)
 		return false;
 
-	if (iph->protocol == IPPROTO_IPIP)
+	if (iph->protocol == IPPROTO_IPIP) {
+		ctx->tun.proto = IPPROTO_IPIP;
+		ctx->tun.hdr_size = size;
 		ctx->offset += size;
+	}
 
 	return true;
 }
 
-static void nf_flow_ip4_tunnel_pop(struct sk_buff *skb)
+static void nf_flow_ip4_tunnel_pop(struct nf_flowtable_ctx *ctx,
+				   struct sk_buff *skb)
 {
-	struct iphdr *iph = (struct iphdr *)skb_network_header(skb);
-
-	if (iph->protocol != IPPROTO_IPIP)
+	if (ctx->tun.proto != IPPROTO_IPIP)
 		return;
 
-	skb_pull(skb, iph->ihl << 2);
+	skb_pull(skb, ctx->tun.hdr_size);
 	skb_reset_network_header(skb);
 }
 
@@ -364,7 +372,8 @@ static bool nf_flow_skb_encap_protocol(struct nf_flowtable_ctx *ctx,
 	return ret;
 }
 
-static void nf_flow_encap_pop(struct sk_buff *skb,
+static void nf_flow_encap_pop(struct nf_flowtable_ctx *ctx,
+			      struct sk_buff *skb,
 			      struct flow_offload_tuple_rhash *tuplehash)
 {
 	struct vlan_hdr *vlan_hdr;
@@ -391,7 +400,7 @@ static void nf_flow_encap_pop(struct sk_buff *skb,
 	}
 
 	if (skb->protocol == htons(ETH_P_IP))
-		nf_flow_ip4_tunnel_pop(skb);
+		nf_flow_ip4_tunnel_pop(ctx, skb);
 }
 
 struct nf_flow_xmit {
@@ -461,7 +470,7 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 
 	flow_offload_refresh(flow_table, flow, false);
 
-	nf_flow_encap_pop(skb, tuplehash);
+	nf_flow_encap_pop(ctx, skb, tuplehash);
 	thoff -= ctx->offset;
 
 	iph = ip_hdr(skb);
@@ -876,7 +885,7 @@ static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
 
 	flow_offload_refresh(flow_table, flow, false);
 
-	nf_flow_encap_pop(skb, tuplehash);
+	nf_flow_encap_pop(ctx, skb, tuplehash);
 
 	ip6h = ipv6_hdr(skb);
 	nf_flow_nat_ipv6(flow, skb, dir, ip6h);
-- 
2.52.0

