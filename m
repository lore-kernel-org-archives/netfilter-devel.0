Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349CE40DFAD
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2026 09:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773223143; cv=none; b=hv4XoLZ++d3s7MZLlTnQ/DusuZnsok3URaD9S1lWz5yw1Wgb+N/GQEcRkqt93taDuevyMny/HaHlB8YWDa+1QIAHRVisoJZs1wzFOVWDVKOAcsJuKBchBfCQiBfWjRCsuS2sjiEAKa5ODJKDQLndphLH1Iy2YJIUpqxCS6P01Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773223143; c=relaxed/simple;
	bh=dTVVDh0vkkcAbmcEL/sRsIDZYbzvPp0Nz4WOEdZzSpc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GqsCM5wgMWvdRbWgGUlV2O68JEpmFpGhtTP63w5IL4vT4O4UBVe05wzifwTsObb3OEtr1+wLU4dSr0QTndJdCzJAvxsYiYGF0Rkxh9sgWP8rdgCoF6of4VI0lPnHtyBagYpPQpFBxlKKiyVh7OjsfvNzDTY1XGXjCsKexWmhEd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MjQrk5Lu; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MjQrk5Lu"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EDC7960563;
	Wed, 11 Mar 2026 10:58:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773223140;
	bh=lTbLbJNlJYZOz7CQiLSLue3aJ1mv0eDYV7vD0v/rf10=;
	h=From:To:Cc:Subject:Date:From;
	b=MjQrk5LudAWUozV7kysv+ZV03s0tbnYOKOoxGEVNWU8MgnmQL+hQYfCq8pHCNuwmM
	 o4k+kQ2FowvEM/KKZnz3Be9Y5WIjyOeAxdHlZHZ/9F3NtUlyNTm2gV8wNFLd72PjX2
	 xWqRFNSakygm6lvJPv0RSeChcdyAHDmYDWW+pRdMAKJ3NvvSEQG43ayms9fhpWTYyO
	 0Gvj9oRsNO86wjahIN4X18/YIp5X1L7cFJ27puaQSVqNNe3+DTAxHoVPL30kHn/6dm
	 OHXARrtpmVX3WKY3hL+Je6hqhDvbmwXu6dnErrBGWKCM0pW6cwLClOHSphSVl3x9Fo
	 k9wYDDDjRA1fw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: ericwouds@gmail.com,
	fw@strlen.de
Subject: [PATCH nf-next] netfilter: nft_meta: add double-tagged vlan and pppoe support
Date: Wed, 11 Mar 2026 10:58:54 +0100
Message-ID: <20260311095854.3421659-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently:

  add rule netdev x y ip saddr 1.1.1.1

does not work with neither double-tagged vlan nor pppoe packets. This is
because the network and transport header offset are not pointing to the
IP and transport protocol headers in the stack.

This patch expands NFT_META_PROTOCOL and NFT_META_L4PROTO to parse
double-tagged vlan and pppoe packets so matching network and transport
header fields becomes possible with the existing userspace generated
bytecode.

NFT_META_PROTOCOL is used by bridge and netdev family as an implicit
dependency in the bytecode to match on network header fields.
Similarly, there is also NFT_META_L4PROTO, which is also used as an
implicit dependency when matching on the transport protocol header
fields.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Hi,

There is patch floating on the mailing to support which add support for
bridge only and that have a strong dependency on conntrack to work.

This approach is more generic, allowing to match for the bridge and
netdev families, with either stateless and stateful rulesets
(ie. w and w/o conntrack).

 include/net/netfilter/nf_tables.h      |  4 ++
 include/net/netfilter/nf_tables_ipv4.h | 18 +++++---
 include/net/netfilter/nf_tables_ipv6.h | 17 +++++---
 net/netfilter/nf_tables_core.c         |  2 +-
 net/netfilter/nft_meta.c               | 60 +++++++++++++++++++++++++-
 net/netfilter/nft_payload.c            |  2 +-
 6 files changed, 88 insertions(+), 15 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index ea6f29ad7888..566df9e7dcb7 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -31,7 +31,9 @@ struct nft_pktinfo {
 	const struct nf_hook_state	*state;
 	u8				flags;
 	u8				tprot;
+	__be16				ethertype;
 	u16				fragoff;
+	u16				nhoff;
 	u16				thoff;
 	u16				inneroff;
 };
@@ -83,6 +85,8 @@ static inline void nft_set_pktinfo_unspec(struct nft_pktinfo *pkt)
 {
 	pkt->flags = 0;
 	pkt->tprot = 0;
+	pkt->ethertype = pkt->skb->protocol;
+	pkt->nhoff = 0;
 	pkt->thoff = 0;
 	pkt->fragoff = 0;
 }
diff --git a/include/net/netfilter/nf_tables_ipv4.h b/include/net/netfilter/nf_tables_ipv4.h
index fcf967286e37..9a8ae8580616 100644
--- a/include/net/netfilter/nf_tables_ipv4.h
+++ b/include/net/netfilter/nf_tables_ipv4.h
@@ -12,17 +12,19 @@ static inline void nft_set_pktinfo_ipv4(struct nft_pktinfo *pkt)
 	ip = ip_hdr(pkt->skb);
 	pkt->flags = NFT_PKTINFO_L4PROTO;
 	pkt->tprot = ip->protocol;
+	pkt->ethertype = pkt->skb->protocol;
+	pkt->nhoff = 0;
 	pkt->thoff = ip_hdrlen(pkt->skb);
 	pkt->fragoff = ntohs(ip->frag_off) & IP_OFFSET;
 }
 
-static inline int __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt)
+static inline int __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt,
+						  int nhoff)
 {
 	struct iphdr *iph, _iph;
 	u32 len, thoff, skb_len;
 
-	iph = skb_header_pointer(pkt->skb, skb_network_offset(pkt->skb),
-				 sizeof(*iph), &_iph);
+	iph = skb_header_pointer(pkt->skb, nhoff, sizeof(*iph), &_iph);
 	if (!iph)
 		return -1;
 
@@ -31,7 +33,7 @@ static inline int __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt)
 
 	len = iph_totlen(pkt->skb, iph);
 	thoff = iph->ihl * 4;
-	skb_len = pkt->skb->len - skb_network_offset(pkt->skb);
+	skb_len = pkt->skb->len - nhoff;
 
 	if (skb_len < len)
 		return -1;
@@ -42,7 +44,9 @@ static inline int __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt)
 
 	pkt->flags = NFT_PKTINFO_L4PROTO;
 	pkt->tprot = iph->protocol;
-	pkt->thoff = skb_network_offset(pkt->skb) + thoff;
+	pkt->ethertype = pkt->skb->protocol;
+	pkt->nhoff = nhoff;
+	pkt->thoff = nhoff + thoff;
 	pkt->fragoff = ntohs(iph->frag_off) & IP_OFFSET;
 
 	return 0;
@@ -50,7 +54,7 @@ static inline int __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt)
 
 static inline void nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt)
 {
-	if (__nft_set_pktinfo_ipv4_validate(pkt) < 0)
+	if (__nft_set_pktinfo_ipv4_validate(pkt, skb_network_offset(pkt->skb)) < 0)
 		nft_set_pktinfo_unspec(pkt);
 }
 
@@ -78,6 +82,8 @@ static inline int nft_set_pktinfo_ipv4_ingress(struct nft_pktinfo *pkt)
 	}
 
 	pkt->flags = NFT_PKTINFO_L4PROTO;
+	pkt->ethertype = pkt->skb->protocol;
+	pkt->nhoff = 0;
 	pkt->tprot = iph->protocol;
 	pkt->thoff = thoff;
 	pkt->fragoff = ntohs(iph->frag_off) & IP_OFFSET;
diff --git a/include/net/netfilter/nf_tables_ipv6.h b/include/net/netfilter/nf_tables_ipv6.h
index c53ac00bb974..289aa221eb4f 100644
--- a/include/net/netfilter/nf_tables_ipv6.h
+++ b/include/net/netfilter/nf_tables_ipv6.h
@@ -20,22 +20,23 @@ static inline void nft_set_pktinfo_ipv6(struct nft_pktinfo *pkt)
 
 	pkt->flags = NFT_PKTINFO_L4PROTO;
 	pkt->tprot = protohdr;
+	pkt->ethertype = pkt->skb->protocol;
+	pkt->nhoff = 0;
 	pkt->thoff = thoff;
 	pkt->fragoff = frag_off;
 }
 
-static inline int __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt)
+static inline int __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt, int nhoff)
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
-				  sizeof(*ip6h), &_ip6h);
+	ip6h = skb_header_pointer(pkt->skb, nhoff, sizeof(*ip6h), &_ip6h);
 	if (!ip6h)
 		return -1;
 
@@ -43,7 +44,7 @@ static inline int __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt)
 		return -1;
 
 	pkt_len = ipv6_payload_len(pkt->skb, ip6h);
-	skb_len = pkt->skb->len - skb_network_offset(pkt->skb);
+	skb_len = pkt->skb->len - nhoff;
 	if (pkt_len + sizeof(*ip6h) > skb_len)
 		return -1;
 
@@ -53,6 +54,8 @@ static inline int __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt)
 
 	pkt->flags = NFT_PKTINFO_L4PROTO;
 	pkt->tprot = protohdr;
+	pkt->ethertype = pkt->skb->protocol;
+	pkt->nhoff = nhoff;
 	pkt->thoff = thoff;
 	pkt->fragoff = frag_off;
 
@@ -64,7 +67,7 @@ static inline int __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt)
 
 static inline void nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt)
 {
-	if (__nft_set_pktinfo_ipv6_validate(pkt) < 0)
+	if (__nft_set_pktinfo_ipv6_validate(pkt, skb_network_offset(pkt->skb)) < 0)
 		nft_set_pktinfo_unspec(pkt);
 }
 
@@ -99,6 +102,8 @@ static inline int nft_set_pktinfo_ipv6_ingress(struct nft_pktinfo *pkt)
 
 	pkt->flags = NFT_PKTINFO_L4PROTO;
 	pkt->tprot = protohdr;
+	pkt->ethertype = pkt->skb->protocol;
+	pkt->nhoff = 0;
 	pkt->thoff = thoff;
 	pkt->fragoff = frag_off;
 
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 6557a4018c09..5ddd5b6e135f 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -151,7 +151,7 @@ static bool nft_payload_fast_eval(const struct nft_expr *expr,
 	unsigned char *ptr;
 
 	if (priv->base == NFT_PAYLOAD_NETWORK_HEADER)
-		ptr = skb_network_header(skb);
+		ptr = skb_network_header(skb) + pkt->nhoff;
 	else {
 		if (!(pkt->flags & NFT_PKTINFO_L4PROTO))
 			return false;
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 05cd1e6e6a2f..60b84e21d225 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -23,6 +23,8 @@
 #include <net/tcp_states.h> /* for TCP_TIME_WAIT */
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
+#include <net/netfilter/nf_tables_ipv4.h>
+#include <net/netfilter/nf_tables_ipv6.h>
 #include <net/netfilter/nft_meta.h>
 #include <net/netfilter/nf_tables_offload.h>
 
@@ -306,6 +308,61 @@ nft_meta_get_eval_sdifname(u32 *dest, const struct nft_pktinfo *pkt)
 	nft_meta_store_ifname(dest, dev);
 }
 
+static void nft_meta_pktinfo_may_update(struct nft_pktinfo *pkt)
+{
+	struct sk_buff *skb = pkt->skb;
+	struct vlan_ethhdr *veth;
+	__be16 ethertype;
+	int nhoff;
+
+	/* Is this an IP packet? Then, skip. */
+	if (pkt->flags)
+		return;
+
+	/* ... else maybe an IP packer over PPPoE or Q-in-Q? */
+	switch (skb->protocol) {
+	case htons(ETH_P_8021Q):
+		if (!pskb_may_pull(skb, skb_mac_offset(skb) + sizeof(*veth)))
+			return;
+
+		veth = (struct vlan_ethhdr *)skb_mac_header(skb);
+		nhoff = VLAN_HLEN;
+		ethertype = veth->h_vlan_encapsulated_proto;
+		break;
+	case htons(ETH_P_PPP_SES):
+		if (!nf_flow_pppoe_proto(skb, &ethertype))
+			return;
+
+		nhoff = PPPOE_SES_HLEN;
+		break;
+	default:
+		return;
+	}
+
+	nhoff += skb_network_offset(skb);
+	switch (ethertype) {
+	case htons(ETH_P_IP):
+		if (__nft_set_pktinfo_ipv4_validate(pkt, nhoff))
+			nft_set_pktinfo_unspec(pkt);
+		break;
+	case htons(ETH_P_IPV6):
+		if (__nft_set_pktinfo_ipv6_validate(pkt, nhoff))
+			nft_set_pktinfo_unspec(pkt);
+		break;
+	default:
+		break;
+	}
+
+	pkt->ethertype = ethertype;
+}
+
+static void nft_meta_protocol_store(u32 *dest, struct nft_pktinfo *pkt)
+{
+	nft_meta_pktinfo_may_update(pkt);
+
+	nft_reg_store16(dest, (__force u16)pkt->ethertype);
+}
+
 void nft_meta_get_eval(const struct nft_expr *expr,
 		       struct nft_regs *regs,
 		       const struct nft_pktinfo *pkt)
@@ -319,12 +376,13 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 		*dest = skb->len;
 		break;
 	case NFT_META_PROTOCOL:
-		nft_reg_store16(dest, (__force u16)skb->protocol);
+		nft_meta_protocol_store(dest, (struct nft_pktinfo *)pkt);
 		break;
 	case NFT_META_NFPROTO:
 		nft_reg_store8(dest, nft_pf(pkt));
 		break;
 	case NFT_META_L4PROTO:
+		nft_meta_pktinfo_may_update((struct nft_pktinfo *)pkt);
 		if (!(pkt->flags & NFT_PKTINFO_L4PROTO))
 			goto err;
 		nft_reg_store8(dest, pkt->tprot);
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index b0214418f75a..c334dd0ff86c 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -183,7 +183,7 @@ void nft_payload_eval(const struct nft_expr *expr,
 		offset = skb_mac_header(skb) - skb->data;
 		break;
 	case NFT_PAYLOAD_NETWORK_HEADER:
-		offset = skb_network_offset(skb);
+		offset = skb_network_offset(skb) + pkt->nhoff;
 		break;
 	case NFT_PAYLOAD_TRANSPORT_HEADER:
 		if (!(pkt->flags & NFT_PKTINFO_L4PROTO) || pkt->fragoff)
-- 
2.47.3

