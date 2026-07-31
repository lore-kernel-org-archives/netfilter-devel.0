Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7B5438FED;
	Fri, 31 Jul 2026 15:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785511106; cv=none; b=Jbz5a4CVOs++1Px22J3NegJW/vlRv5q3meGvVq4hBluTOxSpTaloipwXoEsZ+04riichhxHN2RO22AQF/kfJB1ygz/mD0pr6dh1QiWvVpJJlj/sr4GkdqO6q8KDol2wG2Os+LT0f83jzUMaBCzsksqEn8T40x/uCwI+zlxHLNFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785511106; c=relaxed/simple;
	bh=8Y+zAvg4pMxyrxYbecomCNaOnnRfeFnnG/MfE5MH7KU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ep7Kz/ljsLIBQzicC18Zv4U3xqyKCbSeOgwPBRwExOV3hLUddp6Tlegesc2KVoBNsIuWv2g7NlMp9X0FLkFjnv50tj6TrmJyeCbZc60ZaAXxNUfRKPCCRhc5C8v7c0ihXJpiTB0ptqfZe4O/dmiLWT6mmDl88wdjVNyKO5P6o+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DIq5eBVj; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DIq5eBVj"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 11A776028D;
	Fri, 31 Jul 2026 17:18:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785511102;
	bh=a6s20pRSESdeDAS2nEwzYmbRhYJOQdmsT82r637Mapk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DIq5eBVjswoM7JPF2kBPQuT/sPnZCOjIVyTfXxubYkOs/ogPa6HgyCY7VU7fRW/Nx
	 s9+66G74u/qKhluyBDU6outQv34RMf+E3vHXrbId1EIClmzKGpjPa/nxY/5leNdEYg
	 +BY9346upgeWn5k2XRz5ozywtDXS7NeJ3u1Go/KgASEYOggtLWgPx3uLQ+aV8lELHr
	 iZsCmWhnIMteuntWaHyLx+afQZki5zwyYihEJL4GDCfG/W6q4TVQDecku9eOzIgg/m
	 /ERTm0i119f7u7jce5MkFrgGQHdOlX45XPyo2Z1tOVTJcU9UFgkemg+rCEn/XL/v1s
	 9H5gED0zfCxGA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 08/10] ipvs: avoid out-of-bounds write in ip_vs_nat_icmp
Date: Fri, 31 Jul 2026 17:18:04 +0200
Message-ID: <20260731151806.849724-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260731151806.849724-1-pablo@netfilter.org>
References: <20260731151806.849724-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Julian Anastasov <ja@ssi.bg>

Sashiko warns that local attacker can modify the packet
while it is processed by IPVS. Some places read the
IP ihl field multiple times which can cause out-of-bounds
access. One such place is ip_vs_nat_icmp where we
can write after the validated area.

Fix it by providing ciph argument just like it is done for
IPv6 and use ciph->len as offset to the embedded transport
header.

Modify some IPv4 header checks by reading the ihl field
only once.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://sashiko.dev/#/patchset/20260722101517.36313-1-ja%40ssi.bg
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/ip_vs.h             |  2 +-
 net/netfilter/ipvs/ip_vs_core.c | 67 +++++++++++++++++----------------
 net/netfilter/ipvs/ip_vs_xmit.c |  2 +-
 3 files changed, 36 insertions(+), 35 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index e6ca930a3507..1235f1934e94 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -2062,7 +2062,7 @@ static inline bool ip_vs_conn_use_hash2(struct ip_vs_conn *cp)
 
 void ip_vs_nat_icmp(struct sk_buff *skb, struct ip_vs_protocol *pp,
 		    struct ip_vs_conn *cp, int dir, unsigned int toff,
-		    bool has_ports);
+		    bool has_ports, struct ip_vs_iphdr *ciph);
 
 #ifdef CONFIG_IP_VS_IPV6
 void ip_vs_nat_icmp_v6(struct sk_buff *skb, struct ip_vs_protocol *pp,
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 6b79e0c4d9e2..0bdaeb4ed61e 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -925,28 +925,27 @@ static int ip_vs_route_me_harder(struct netns_ipvs *ipvs, int af,
  */
 void ip_vs_nat_icmp(struct sk_buff *skb, struct ip_vs_protocol *pp,
 		    struct ip_vs_conn *cp, int inout, unsigned int toff,
-		    bool has_ports)
+		    bool has_ports, struct ip_vs_iphdr *ciph)
 {
 	struct iphdr *iph	 = ip_hdr(skb);
 	struct icmphdr *icmph	 = (struct icmphdr *)(skb->data + toff);
-	struct iphdr *ciph	 = (struct iphdr *)(icmph + 1);
-	unsigned int coff __maybe_unused = toff + sizeof(struct icmphdr);
+	struct iphdr *cih	 = (struct iphdr *)(icmph + 1);
 
 	if (inout) {
 		iph->saddr = cp->vaddr.ip;
 		ip_send_check(iph);
-		ciph->daddr = cp->vaddr.ip;
-		ip_send_check(ciph);
+		cih->daddr = cp->vaddr.ip;
+		ip_send_check(cih);
 	} else {
 		iph->daddr = cp->daddr.ip;
 		ip_send_check(iph);
-		ciph->saddr = cp->daddr.ip;
-		ip_send_check(ciph);
+		cih->saddr = cp->daddr.ip;
+		ip_send_check(cih);
 	}
 
 	/* the TCP/UDP/SCTP port */
 	if (has_ports) {
-		__be16 *ports = (void *)ciph + ciph->ihl*4;
+		__be16 *ports = (void *)(skb->data + ciph->len);
 
 		if (inout)
 			ports[1] = cp->vport;
@@ -960,10 +959,10 @@ void ip_vs_nat_icmp(struct sk_buff *skb, struct ip_vs_protocol *pp,
 	skb->ip_summed = CHECKSUM_UNNECESSARY;
 
 	if (inout)
-		IP_VS_DBG_PKT(11, AF_INET, pp, skb, coff,
+		IP_VS_DBG_PKT(11, AF_INET, pp, skb, ciph->off,
 			      "Forwarding altered outgoing ICMP");
 	else
-		IP_VS_DBG_PKT(11, AF_INET, pp, skb, coff,
+		IP_VS_DBG_PKT(11, AF_INET, pp, skb, ciph->off,
 			      "Forwarding altered incoming ICMP");
 }
 
@@ -1056,7 +1055,7 @@ static int handle_response_icmp(int af, struct sk_buff *skb,
 		ip_vs_nat_icmp_v6(skb, pp, cp, 1, toff, has_ports, ciph);
 	else
 #endif
-		ip_vs_nat_icmp(skb, pp, cp, 1, toff, has_ports);
+		ip_vs_nat_icmp(skb, pp, cp, 1, toff, has_ports, ciph);
 
 	if (ip_vs_route_me_harder(cp->ipvs, af, skb, hooknum))
 		goto out;
@@ -1092,7 +1091,7 @@ static int ip_vs_out_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb,
 	struct ip_vs_iphdr ciph;
 	struct ip_vs_conn *cp;
 	struct ip_vs_protocol *pp;
-	unsigned int offset, ihl;
+	unsigned int offset;
 	union nf_inet_addr snet;
 
 	*related = 1;
@@ -1105,7 +1104,6 @@ static int ip_vs_out_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb,
 			return NF_ACCEPT;
 	}
 
-	ihl = ipvsh->len;
 	offset = ipvsh->len;
 	ic = skb_header_pointer(skb, offset, sizeof(_icmph), &_icmph);
 	if (ic == NULL)
@@ -1131,11 +1129,15 @@ static int ip_vs_out_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb,
 
 	/* Now find the contained IP header */
 	offset += sizeof(_icmph);
+	if (!ip_vs_fill_iph_skb_icmp(AF_INET, skb, offset, true, &ciph))
+		return NF_ACCEPT; /* The packet looks wrong, ignore */
+
 	cih = skb_header_pointer(skb, offset, sizeof(_ciph), &_ciph);
-	if (!(cih && cih->version == 4 && cih->ihl >= 5))
+	if (!(cih && cih->version == 4 &&
+	      ciph.len - ciph.off >= sizeof(struct iphdr)))
 		return NF_ACCEPT; /* The packet looks wrong, ignore */
 
-	pp = ip_vs_proto_get(cih->protocol);
+	pp = ip_vs_proto_get(ciph.protocol);
 	if (!pp)
 		return NF_ACCEPT;
 
@@ -1146,8 +1148,6 @@ static int ip_vs_out_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb,
 	IP_VS_DBG_PKT(11, AF_INET, pp, skb, offset,
 		      "Checking outgoing ICMP for");
 
-	ip_vs_fill_iph_skb_icmp(AF_INET, skb, offset, true, &ciph);
-
 	/* The embedded headers contain source and dest in reverse order */
 	cp = INDIRECT_CALL_1(pp->conn_out_get, ip_vs_conn_out_get_proto,
 			     ipvs, AF_INET, skb, &ciph);
@@ -1155,8 +1155,8 @@ static int ip_vs_out_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb,
 		return NF_ACCEPT;
 
 	snet.ip = ipvsh->saddr.ip;
-	return handle_response_icmp(AF_INET, skb, &snet, cp, pp, &ciph, ihl,
-				    hooknum);
+	return handle_response_icmp(AF_INET, skb, &snet, cp, pp, &ciph,
+				    ipvsh->len, hooknum);
 }
 
 #ifdef CONFIG_IP_VS_IPV6
@@ -1803,10 +1803,12 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 	/* Now find the contained IP header */
 	offset += sizeof(_icmph);
 	cih = skb_header_pointer(skb, offset, sizeof(_ciph), &_ciph);
-	if (!(cih && cih->version == 4 && cih->ihl >= 5))
+	if (!cih)
 		return NF_ACCEPT; /* The packet looks wrong, ignore */
-	raddr = (union nf_inet_addr *)&cih->daddr;
 	hlen_ipip = cih->ihl * 4;
+	if (!(cih->version == 4 && hlen_ipip >= sizeof(struct iphdr)))
+		return NF_ACCEPT; /* The packet looks wrong, ignore */
+	raddr = (union nf_inet_addr *)&cih->daddr;
 
 	/* Special case for errors for IPIP/UDP/GRE tunnel packets */
 	tunnel = false;
@@ -1823,9 +1825,6 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 		if (!dest || dest->tun_type != IP_VS_CONN_F_TUNNEL_TYPE_IPIP)
 			return NF_ACCEPT;
 		offset += hlen_ipip;
-		cih = skb_header_pointer(skb, offset, sizeof(_ciph), &_ciph);
-		if (!(cih && cih->version == 4 && cih->ihl >= 5))
-			return NF_ACCEPT; /* The packet looks wrong, ignore */
 		tunnel = true;
 	} else if ((cih->protocol == IPPROTO_UDP ||	/* Can be UDP encap */
 		    cih->protocol == IPPROTO_GRE) &&	/* Can be GRE encap */
@@ -1850,21 +1849,25 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 			/* Skip IP and UDP/GRE tunnel headers */
 			offset = offset2 + ulen;
 			/* Now we should be at the original IP header */
-			cih = skb_header_pointer(skb, offset, sizeof(_ciph),
-						 &_ciph);
-			if (cih && cih->version == 4 && cih->ihl >= 5 &&
-			    iproto == IPPROTO_IPIP)
+			if (iproto == IPPROTO_IPIP)
 				tunnel = true;
 			else
 				return NF_ACCEPT;
 		}
 	}
 
-	pd = ip_vs_proto_data_get(ipvs, cih->protocol);
+	if (!ip_vs_fill_iph_skb_icmp(AF_INET, skb, offset, !tunnel, &ciph))
+		return NF_ACCEPT;
+	pd = ip_vs_proto_data_get(ipvs, ciph.protocol);
 	if (!pd)
 		return NF_ACCEPT;
 	pp = pd->pp;
 
+	cih = skb_header_pointer(skb, offset, sizeof(_ciph), &_ciph);
+	if (!(cih && cih->version == 4 &&
+	      ciph.len - ciph.off >= sizeof(struct iphdr)))
+		return NF_ACCEPT; /* The packet looks wrong, ignore */
+
 	/* Is the embedded protocol header present? */
 	if (unlikely(cih->frag_off & htons(IP_OFFSET) && !pp->dont_defrag))
 		return NF_ACCEPT;
@@ -1872,9 +1875,6 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 	IP_VS_DBG_PKT(11, AF_INET, pp, skb, offset,
 		      "Checking incoming ICMP for");
 
-	offset2 = offset;
-	ip_vs_fill_iph_skb_icmp(AF_INET, skb, offset, !tunnel, &ciph);
-
 	/* The embedded headers contain source and dest in reverse order.
 	 * For IPIP/UDP/GRE tunnel this is error for request, not for reply.
 	 */
@@ -1904,11 +1904,12 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 	}
 
 	if (tunnel) {
-		unsigned int hlen_orig = cih->ihl * 4;
+		unsigned int hlen_orig = ciph.len - ciph.off;
 		__be32 info = ic->un.gateway;
 		__u8 type = ic->type;
 		__u8 code = ic->code;
 
+		offset2 = offset;
 		/* Update the MTU */
 		if (ic->type == ICMP_DEST_UNREACH &&
 		    ic->code == ICMP_FRAG_NEEDED) {
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 0b0c5304993a..c4508f3f43dd 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -1580,7 +1580,7 @@ ip_vs_icmp_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 	if (skb_cow(skb, rt->dst.dev->hard_header_len))
 		goto tx_error;
 
-	ip_vs_nat_icmp(skb, pp, cp, 0, toff, has_ports);
+	ip_vs_nat_icmp(skb, pp, cp, 0, toff, has_ports, ciph);
 
 	/* Another hack: avoid icmp_send in ip_fragment */
 	skb->ignore_df = 1;
-- 
2.47.3

