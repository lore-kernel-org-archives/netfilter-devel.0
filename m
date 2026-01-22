Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF679273D84;
	Thu, 22 Jan 2026 17:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769104000; cv=none; b=PB57qiujuPSW29EAGxWrgFVKwlpHCXwNade4sigZr3yI7aEs8+/xBUGwoFcLUlgFzp4CkD0DngNWk5AEDYqRrGzjxGAIVZCzyaXXjsGkfzi/xNtk7yFqTQfmUZCN9MzIzFykM3c2Ea1ZDmbioTLCvVvVp2+6h2zg+hfiSARL1Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769104000; c=relaxed/simple;
	bh=EmL6JvAhueJYF4kz9kLX+aW0h/brSDVHJjPYOXFPjhw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RknPEGr/4GPBqIwV/dF4OGAjZdeeB6TDyzg4VF9Fouv1kcPHpiHd+L1XvohjtzptbIiSLg7sxLj+uuzcIL1ayvobj5aUm1nmgzrykyTB74ASuB5haQcxHzdTgUEnvuE9iVoU0QPDMd/NwAJS/9ZjH1UV2g9hLM0Ce+gmyvW55nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qvSBrtzv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qvSBrtzv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4135BC116C6;
	Thu, 22 Jan 2026 17:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769103998;
	bh=EmL6JvAhueJYF4kz9kLX+aW0h/brSDVHJjPYOXFPjhw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=qvSBrtzvnbDY7mr6UGaTDJNEKT6qpUWryU/7ktV7CMe/PJO00nrHeFei0YxbpfRxY
	 Sz3I4HkYbqT0TWIafYAxycr/sGr3mXGUvZfpbrfT1GAaNb+DHOpHRdfZRZyfhbreOP
	 ld5sGOjm16LI5iyGrFbolsjRV0dBM9bi3bWwogu4Xm589qf2v56vCaSjvAxzpfyl3c
	 CsD90sThLhuWaiv/HwQRWvFF/pCNgRKawpoHub3DZB6GX2XDx3qyt5Q4/U5Iwq7aSG
	 Z8mEYjyAg4r6cbNmT93vR6l8nF9Kq5G3wsF+qiv5F+DzJihCrS9KKT2F8GYYrdtJ4c
	 QkJEt9ak8j1Hw==
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Thu, 22 Jan 2026 18:46:14 +0100
Subject: [PATCH nf-next v4 2/5] netfilter: Introduce tunnel metadata info
 in nf_flowtable_ctx struct
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260122-b4-flowtable-offload-ip6ip6-v4-2-ea3dd826c23b@kernel.org>
References: <20260122-b4-flowtable-offload-ip6ip6-v4-0-ea3dd826c23b@kernel.org>
In-Reply-To: <20260122-b4-flowtable-offload-ip6ip6-v4-0-ea3dd826c23b@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, 
 Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
 David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 netdev@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Lorenzo Bianconi <lorenzo@kernel.org>
X-Mailer: b4 0.14.2

Add tunnel hdr_size and tunnel proto fields in nf_flowtable_ctx struct
in order to store IP tunnel header size and protocol used during IPIP
and IP6IP6 tunnel sw offloading decapsulation and avoid recomputing them
during tunnel header pop since this is constant for IPv6.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 net/netfilter/nf_flow_table_ip.c | 41 ++++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 8d3fbeaca2df110180414d44b28475adce8724ae..7d86653478c39cce2e321f3df73dbfde6f7c3e33 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -142,6 +142,18 @@ static bool ip_has_options(unsigned int thoff)
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
@@ -184,12 +196,6 @@ static void nf_flow_tuple_encap(struct sk_buff *skb,
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
@@ -311,20 +317,22 @@ static bool nf_flow_ip4_tunnel_proto(struct nf_flowtable_ctx *ctx,
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
 
@@ -362,7 +370,8 @@ static bool nf_flow_skb_encap_protocol(struct nf_flowtable_ctx *ctx,
 	return ret;
 }
 
-static void nf_flow_encap_pop(struct sk_buff *skb,
+static void nf_flow_encap_pop(struct nf_flowtable_ctx *ctx,
+			      struct sk_buff *skb,
 			      struct flow_offload_tuple_rhash *tuplehash)
 {
 	struct vlan_hdr *vlan_hdr;
@@ -389,7 +398,7 @@ static void nf_flow_encap_pop(struct sk_buff *skb,
 	}
 
 	if (skb->protocol == htons(ETH_P_IP))
-		nf_flow_ip4_tunnel_pop(skb);
+		nf_flow_ip4_tunnel_pop(ctx, skb);
 }
 
 struct nf_flow_xmit {
@@ -459,7 +468,7 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 
 	flow_offload_refresh(flow_table, flow, false);
 
-	nf_flow_encap_pop(skb, tuplehash);
+	nf_flow_encap_pop(ctx, skb, tuplehash);
 	thoff -= ctx->offset;
 
 	iph = ip_hdr(skb);
@@ -874,7 +883,7 @@ static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
 
 	flow_offload_refresh(flow_table, flow, false);
 
-	nf_flow_encap_pop(skb, tuplehash);
+	nf_flow_encap_pop(ctx, skb, tuplehash);
 
 	ip6h = ipv6_hdr(skb);
 	nf_flow_nat_ipv6(flow, skb, dir, ip6h);

-- 
2.52.0

