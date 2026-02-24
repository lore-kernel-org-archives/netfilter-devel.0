Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3494730C619
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Feb 2026 06:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771916002; cv=none; b=D+fsmhJpLgkUlhK+Qq3wfJdzjqY+OYLOBEWNfROPNMBDJAEXhPbgWS7Ns8Kl8u3Z5fLW/VjChH1bwWi3P3hy7h6kEF573YhvzpwHE3eKY1OuEw9ywX8UDhMbUPmnD0wped3C9VNPH/QD7sZzL1Wb1l/6C7O+XkFfNmuBNf8izoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771916002; c=relaxed/simple;
	bh=cZOvplO+acrDIC/bdnPngpv5Yz9c1Kq3wtTg6un4bYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ofm18zIJXZazLKYY/+IpUU/LpunZGBO2WGlYxX5gqAI3uKlu4aDYqhmkqjzzLiDcnjwxLIijfhNuEVmcS2tbRtMVLvPMD8Qx1zUMDr+cDjw2s1Sr9BYXPabGyp+dLbl/pPW94/rhe5k7RLuLjl559OXJCf5cTXumqAiptkN2jKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TWr464KO; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TWr464KO"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-65a26c220b6so6577110a12.0
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Feb 2026 22:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771916000; x=1772520800; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gAePdTgx4rGcv9Ww6vpjOV8zuSULm275AmiWMO10ySE=;
        b=TWr464KOoJPJgp/rweydHBIzDMB1mlTQOCsi6Ua1kUmWEFYkM2NG9GreM5MFggK5g6
         /G8PhyaTy9n6cU1LH+7MpUoywfeNMzMQ7dPWLTbfNaIK7pwoq9OrIrpoEZ6q2JWmpork
         /QQvfvlCJRR0VzRNftgSiLIKXoHT+r7aBP3RGYDOrHLWb6g95/H1caT9KZfBr13+cb/N
         7y4PDuHdLdJmPpr2ksxmpqHDcKdPmjLw6ThWpIJBpQhvGPtSJsLWj+u8Czily6ZwzaHD
         qHEbRBAdqYS1MWuUDpmhy2VTISiz1AB6MJXJg5GrGTiCBnuf6CQIlYpAecG+CD5CeZER
         m3MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771916000; x=1772520800;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gAePdTgx4rGcv9Ww6vpjOV8zuSULm275AmiWMO10ySE=;
        b=iUq2nnS57Hng4PnU5UQFo7I2xLDODStFawy1froULcFmch0O1kofLx0zQVaznKtv9L
         yVVBlPXoNuJ3zXK7N4sSQXywF9sjoeugD6mpN6oLbj/8/ANxDfY4sDcFAlofTdOG6kG0
         7GCyrjErx0ytYGtowJlTE41JPA7OdwijxW3enxHtA5gW4jnE+iMUObFexM4tb3igwPTM
         i+8Ks6/eCTKDfXL3gwywotIKfF4deWfUhvEFU8plnvyoCBsSGMHgJ77YP/XA/G1+QgMd
         1M+I78nJ07daRKNARXBiBvLbmw7P9qiZMxDoTchReV54rSE8jveqTVdTd+Lg9FFO0Ud0
         lqAg==
X-Forwarded-Encrypted: i=1; AJvYcCWaTLmeKKVuez/1Xz4i3fcKWepowQ81dNaCYtWuWwHDeBTgBCBs7uJ/pdhr9bTC0E8p8a6qT4LutNg4vOVGkL4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzNepGruHwY+jUq3un2Dzx36kjV0dbJlgQZtT9ilfPGug97nxF
	YlnSTAuJgBBGWkui2icvfJ4//l/Z+vYsq/FWd13yxb7QBCq6ne+zaKB1
X-Gm-Gg: ATEYQzzV2lw6eyJTXjjl5VIBG6GxnRlc3PWOVuZ6wFkjMYOz/HqoXWTdCl3/teRF9Zr
	NhSCW1YtC55am4bYlj4Tr+PbcP43Ra4FDelDBM6YrdfkhpuPkTdUJrpkulovUcixH8/5+9mVi7v
	/Ia2Mn4BAUS1k9dhhXJbq0ikKtIl5RxSAOcUFLSiCzxKVyRrSeBTEuApvQ8og62WHTfuQbH3duA
	jNl37wKH3kw1xjBkICjBsrTPFUeZ4oEpP4Tk4QRyYuYMzScs1B+mCmTt/1GxxnzZcVRJO7I5BGX
	SqL8w0R/4KxhHO37l98lfndsfCf26cwyQg4OLaSiZN6nxHrCcPT/FwmCjD0GoN4uJTQc3WmgUwm
	BuU2KM3OYlyuHPrldHzJlDCRPQIzFnz1HyisYBVJZN8ojXJwEdSrAXg/EWNa0erDaZfTsa+tFSV
	RG9RlovoN31jgb2FfRzEona14LMNg/w5yOqN4uAzuJZQT1AyjNJZIAKdkovxthIGvJ/Wk2FHeqr
	8MOnM9IVvCe2aKbBT/Yj/luAN23QCdivAEnFDGnSJYDWCTtKRiOzV4=
X-Received: by 2002:a05:6402:27cd:b0:65a:46a2:ed23 with SMTP id 4fb4d7f45d1cf-65ea4f0bc61mr7428081a12.28.1771915999554;
        Mon, 23 Feb 2026 22:53:19 -0800 (PST)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-65eaba13866sm3096698a12.18.2026.02.23.22.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 22:53:19 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Michal Ostrowski <mostrows@earthlink.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v19 nf-next 4/5] netfilter: nft_set_pktinfo_ipv4/6_validate: Add nhoff argument
Date: Tue, 24 Feb 2026 07:53:05 +0100
Message-ID: <20260224065307.120768-5-ericwouds@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260224065307.120768-1-ericwouds@gmail.com>
References: <20260224065307.120768-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add specifying an offset when calling nft_set_pktinfo_ipv4/6_validate()
for cases where the ip(v6) header is not located at skb_network_header().

When an offset is specified other then zero, do not set pkt->tprot and
the corresponding pkt->flags to not change rule processing. It does make
the offsets in pktinfo available for code that is not checking pkt->flags
to use the offsets, like nft_flow_offload_eval().

Existing behaviour for a rule like "tcp dport 22 accept" is not changed
when, for instance, a PPPoE packet is being matched inside a bridge.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 include/net/netfilter/nf_tables_ipv4.h | 21 +++++++++++++--------
 include/net/netfilter/nf_tables_ipv6.h | 21 +++++++++++++--------
 net/netfilter/nft_chain_filter.c       |  8 ++++----
 3 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/include/net/netfilter/nf_tables_ipv4.h b/include/net/netfilter/nf_tables_ipv4.h
index fcf967286e37..bd354937134f 100644
--- a/include/net/netfilter/nf_tables_ipv4.h
+++ b/include/net/netfilter/nf_tables_ipv4.h
@@ -16,12 +16,12 @@ static inline void nft_set_pktinfo_ipv4(struct nft_pktinfo *pkt)
 	pkt->fragoff = ntohs(ip->frag_off) & IP_OFFSET;
 }
 
-static inline int __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt)
+static inline int __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt, u32 nhoff)
 {
 	struct iphdr *iph, _iph;
 	u32 len, thoff, skb_len;
 
-	iph = skb_header_pointer(pkt->skb, skb_network_offset(pkt->skb),
+	iph = skb_header_pointer(pkt->skb, skb_network_offset(pkt->skb) + nhoff,
 				 sizeof(*iph), &_iph);
 	if (!iph)
 		return -1;
@@ -31,7 +31,7 @@ static inline int __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt)
 
 	len = iph_totlen(pkt->skb, iph);
 	thoff = iph->ihl * 4;
-	skb_len = pkt->skb->len - skb_network_offset(pkt->skb);
+	skb_len = pkt->skb->len - skb_network_offset(pkt->skb) - nhoff;
 
 	if (skb_len < len)
 		return -1;
@@ -40,17 +40,22 @@ static inline int __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt)
 	else if (thoff < sizeof(*iph))
 		return -1;
 
-	pkt->flags = NFT_PKTINFO_L4PROTO;
-	pkt->tprot = iph->protocol;
-	pkt->thoff = skb_network_offset(pkt->skb) + thoff;
+	if (!nhoff) {
+		pkt->flags = NFT_PKTINFO_L4PROTO;
+		pkt->tprot = iph->protocol;
+	} else {
+		pkt->flags = 0;
+		pkt->tprot = 0;
+	}
+	pkt->thoff = skb_network_offset(pkt->skb) + nhoff + thoff;
 	pkt->fragoff = ntohs(iph->frag_off) & IP_OFFSET;
 
 	return 0;
 }
 
-static inline void nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt)
+static inline void nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt, u32 nhoff)
 {
-	if (__nft_set_pktinfo_ipv4_validate(pkt) < 0)
+	if (__nft_set_pktinfo_ipv4_validate(pkt, nhoff) < 0)
 		nft_set_pktinfo_unspec(pkt);
 }
 
diff --git a/include/net/netfilter/nf_tables_ipv6.h b/include/net/netfilter/nf_tables_ipv6.h
index c53ac00bb974..1e84a891f268 100644
--- a/include/net/netfilter/nf_tables_ipv6.h
+++ b/include/net/netfilter/nf_tables_ipv6.h
@@ -24,17 +24,17 @@ static inline void nft_set_pktinfo_ipv6(struct nft_pktinfo *pkt)
 	pkt->fragoff = frag_off;
 }
 
-static inline int __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt)
+static inline int __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt, u32 nhoff)
 {
 #if IS_ENABLED(CONFIG_IPV6)
 	unsigned int flags = IP6_FH_F_AUTH;
 	struct ipv6hdr *ip6h, _ip6h;
-	unsigned int thoff = 0;
+	unsigned int thoff = nhoff;
 	unsigned short frag_off;
 	u32 pkt_len, skb_len;
 	int protohdr;
 
-	ip6h = skb_header_pointer(pkt->skb, skb_network_offset(pkt->skb),
+	ip6h = skb_header_pointer(pkt->skb, skb_network_offset(pkt->skb) + nhoff,
 				  sizeof(*ip6h), &_ip6h);
 	if (!ip6h)
 		return -1;
@@ -43,7 +43,7 @@ static inline int __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt)
 		return -1;
 
 	pkt_len = ipv6_payload_len(pkt->skb, ip6h);
-	skb_len = pkt->skb->len - skb_network_offset(pkt->skb);
+	skb_len = pkt->skb->len - skb_network_offset(pkt->skb) - nhoff;
 	if (pkt_len + sizeof(*ip6h) > skb_len)
 		return -1;
 
@@ -51,8 +51,13 @@ static inline int __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt)
 	if (protohdr < 0 || thoff > U16_MAX)
 		return -1;
 
-	pkt->flags = NFT_PKTINFO_L4PROTO;
-	pkt->tprot = protohdr;
+	if (!nhoff) {
+		pkt->flags = NFT_PKTINFO_L4PROTO;
+		pkt->tprot = protohdr;
+	} else {
+		pkt->flags = 0;
+		pkt->tprot = 0;
+	}
 	pkt->thoff = thoff;
 	pkt->fragoff = frag_off;
 
@@ -62,9 +67,9 @@ static inline int __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt)
 #endif
 }
 
-static inline void nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt)
+static inline void nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt, u32 nhoff)
 {
-	if (__nft_set_pktinfo_ipv6_validate(pkt) < 0)
+	if (__nft_set_pktinfo_ipv6_validate(pkt, nhoff) < 0)
 		nft_set_pktinfo_unspec(pkt);
 }
 
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index b16185e9a6dd..d4d5eadaba9c 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -238,10 +238,10 @@ nft_do_chain_bridge(void *priv,
 
 	switch (eth_hdr(skb)->h_proto) {
 	case htons(ETH_P_IP):
-		nft_set_pktinfo_ipv4_validate(&pkt);
+		nft_set_pktinfo_ipv4_validate(&pkt, 0);
 		break;
 	case htons(ETH_P_IPV6):
-		nft_set_pktinfo_ipv6_validate(&pkt);
+		nft_set_pktinfo_ipv6_validate(&pkt, 0);
 		break;
 	default:
 		nft_set_pktinfo_unspec(&pkt);
@@ -293,10 +293,10 @@ static unsigned int nft_do_chain_netdev(void *priv, struct sk_buff *skb,
 
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
-		nft_set_pktinfo_ipv4_validate(&pkt);
+		nft_set_pktinfo_ipv4_validate(&pkt, 0);
 		break;
 	case htons(ETH_P_IPV6):
-		nft_set_pktinfo_ipv6_validate(&pkt);
+		nft_set_pktinfo_ipv6_validate(&pkt, 0);
 		break;
 	default:
 		nft_set_pktinfo_unspec(&pkt);
-- 
2.53.0

