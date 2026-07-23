Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D000374169;
	Thu, 23 Jul 2026 16:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784824794; cv=none; b=dRJCulpD3/9CSW43wV7h+IbE68OK5pyMDCr8Ts79rfVLJBorNBztpgEoWvwIUR7Fk4nYqqtykhvgp4kv8kLwcTX/+5wwXFY/s9eumXSOPQVXSGVQIgBIYBL9WqeOwCX0keeGsudEA/yMtVLpCQBJIvckL20mWHs3dihNXLOnvSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784824794; c=relaxed/simple;
	bh=8g1/RV51XX9LeNzuoK6ttDh2e0oww3MFQH9qpfJnCbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FqVUbu+I+mwWKdMcWygWt01IzGoHFpWuPvBNKNu0/+By7mFOwUeJgWPC+jUzreJx287cclIdfIYJb8J245JU+hWP2uKHSm95ipu9d7ASts+uXNo9fjOBQjZ06fxe7z7YTQyuQjM+YMWDIVxUjljIcq4d9FJQG1gM/bhvEALRGYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=bLFD/rGJ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="bLFD/rGJ"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 36893601C4;
	Thu, 23 Jul 2026 18:39:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784824782;
	bh=SfN2ybKuT/bWF+UL8QF5UakHXDv6F2gLLOiPYOwioOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bLFD/rGJdvtImVRMtNShhiy9uMiWs5/EhLTLbjpFXtssAdUcfq0U9z0q9hJwkvB8f
	 RwxiBPdJm3eUIsj5hJdtXvTkrCeVl0pODljyeq7RifTlIAKw2o+acDbPKHHGtr/A01
	 4RK09PH03dOj3exkg80OXKN1lsrSugbcMDYsP5b0xWNtM80/umvr8DXYrAV/heUK4m
	 TWiSBHTEZZ8gzlLsKRa9vLfmBOFKnjDsThThI56Gbg7xW0ANfd+PPle+LSA5dNLb9b
	 Vv6Ph/TAx4WMAJlKlrhbCp2b83iuU3hkw1CpV3eDiowaijP8BXgf8R5BR/FHWbW9GN
	 rSO2yqZ2k1ZsA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 11/13] ipvs: do not mangle ICMP replies for non-first fragments
Date: Thu, 23 Jul 2026 18:39:08 +0200
Message-ID: <20260723163910.274695-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260723163910.274695-1-pablo@netfilter.org>
References: <20260723163910.274695-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Julian Anastasov <ja@ssi.bg>

Sashiko warns that ip_vs_nat_icmp() unconditionally mangles the
payload for embedded non-first IPv4 fragments. The problem is
in the very old inverted pp->dont_defrag check which should not
continue when embedded is a non-first TCP/UDP/SCTP fragment.

Check for embedded non-first fragment is also missing from
ip_vs_out_icmp_v6(), it is needed before any connection
lookups that expect ports after the network headers.

Drop the blocking code from ip_vs_in_icmp_v6() which prevents
ICMPv6 from local clients to use non-MASQ forwarding.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://sashiko.dev/#/patchset/20260720201122.79882-1-ja%40ssi.bg
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/ip_vs.h             | 11 +++---
 net/netfilter/ipvs/ip_vs_core.c | 61 ++++++++++++---------------------
 net/netfilter/ipvs/ip_vs_xmit.c | 28 +++++++++++----
 3 files changed, 48 insertions(+), 52 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 4a10a01d6e2f..e6ca930a3507 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -1975,8 +1975,7 @@ int ip_vs_dr_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 		  struct ip_vs_protocol *pp, struct ip_vs_iphdr *iph);
 int ip_vs_icmp_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 		    struct ip_vs_protocol *pp, unsigned int toff,
-		    unsigned int wlen, unsigned int hooknum,
-		    struct ip_vs_iphdr *ciph);
+		    unsigned int hooknum, struct ip_vs_iphdr *ciph);
 void ip_vs_dest_dst_rcu_free(struct rcu_head *head);
 
 #ifdef CONFIG_IP_VS_IPV6
@@ -1990,8 +1989,7 @@ int ip_vs_dr_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 		     struct ip_vs_protocol *pp, struct ip_vs_iphdr *iph);
 int ip_vs_icmp_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 		       struct ip_vs_protocol *pp, unsigned int toff,
-		       unsigned int wlen, unsigned int hooknum,
-		       struct ip_vs_iphdr *ciph);
+		       unsigned int hooknum, struct ip_vs_iphdr *ciph);
 #endif
 
 #ifdef CONFIG_SYSCTL
@@ -2063,12 +2061,13 @@ static inline bool ip_vs_conn_use_hash2(struct ip_vs_conn *cp)
 }
 
 void ip_vs_nat_icmp(struct sk_buff *skb, struct ip_vs_protocol *pp,
-		    struct ip_vs_conn *cp, int dir, unsigned int toff);
+		    struct ip_vs_conn *cp, int dir, unsigned int toff,
+		    bool has_ports);
 
 #ifdef CONFIG_IP_VS_IPV6
 void ip_vs_nat_icmp_v6(struct sk_buff *skb, struct ip_vs_protocol *pp,
 		       struct ip_vs_conn *cp, int dir, unsigned int toff,
-		       struct ip_vs_iphdr *ciph);
+		       bool has_ports, struct ip_vs_iphdr *ciph);
 #endif
 
 static inline __wsum ip_vs_check_diff4(__be32 old, __be32 new, __wsum oldsum)
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index cd5eb71543ec..7efa209a517b 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -924,7 +924,8 @@ static int ip_vs_route_me_harder(struct netns_ipvs *ipvs, int af,
  * - inout: 1=in->out, 0=out->in
  */
 void ip_vs_nat_icmp(struct sk_buff *skb, struct ip_vs_protocol *pp,
-		    struct ip_vs_conn *cp, int inout, unsigned int toff)
+		    struct ip_vs_conn *cp, int inout, unsigned int toff,
+		    bool has_ports)
 {
 	struct iphdr *iph	 = ip_hdr(skb);
 	struct icmphdr *icmph	 = (struct icmphdr *)(skb->data + toff);
@@ -944,8 +945,7 @@ void ip_vs_nat_icmp(struct sk_buff *skb, struct ip_vs_protocol *pp,
 	}
 
 	/* the TCP/UDP/SCTP port */
-	if (IPPROTO_TCP == ciph->protocol || IPPROTO_UDP == ciph->protocol ||
-	    IPPROTO_SCTP == ciph->protocol) {
+	if (has_ports) {
 		__be16 *ports = (void *)ciph + ciph->ihl*4;
 
 		if (inout)
@@ -970,18 +970,15 @@ void ip_vs_nat_icmp(struct sk_buff *skb, struct ip_vs_protocol *pp,
 #ifdef CONFIG_IP_VS_IPV6
 void ip_vs_nat_icmp_v6(struct sk_buff *skb, struct ip_vs_protocol *pp,
 		       struct ip_vs_conn *cp, int inout, unsigned int toff,
-		       struct ip_vs_iphdr *ciph)
+		       bool has_ports, struct ip_vs_iphdr *ciph)
 {
 	struct ipv6hdr *iph	 = ipv6_hdr(skb);
-	int protocol;
 	struct icmp6hdr *icmph;
 	struct ipv6hdr *cih;
 
 	icmph = (struct icmp6hdr *)(skb->data + toff);
 	cih = (struct ipv6hdr *)(skb->data + ciph->off);
 
-	protocol = ciph->protocol;
-
 	if (inout) {
 		iph->saddr = cp->vaddr.in6;
 		cih->daddr = cp->vaddr.in6;
@@ -991,9 +988,7 @@ void ip_vs_nat_icmp_v6(struct sk_buff *skb, struct ip_vs_protocol *pp,
 	}
 
 	/* the TCP/UDP/SCTP port */
-	if (!ciph->fragoffs &&
-	    (protocol == IPPROTO_TCP  || protocol == IPPROTO_UDP ||
-	     protocol == IPPROTO_SCTP)) {
+	if (has_ports) {
 		__be16 *ports = (void *)(skb->data + ciph->len);
 
 		IP_VS_DBG(11, "%s() changed port %d to %d\n", __func__,
@@ -1035,6 +1030,7 @@ static int handle_response_icmp(int af, struct sk_buff *skb,
 	int iproto = af == AF_INET6 ? IPPROTO_ICMPV6 : IPPROTO_ICMP;
 	unsigned int verdict = NF_DROP;
 	unsigned int ctoff = ciph->len;
+	bool has_ports = false;
 
 	if (IP_VS_FWD_METHOD(cp) != IP_VS_CONN_F_MASQ)
 		goto after_nat;
@@ -1048,17 +1044,19 @@ static int handle_response_icmp(int af, struct sk_buff *skb,
 	}
 
 	if (ciph->protocol == IPPROTO_TCP || ciph->protocol == IPPROTO_UDP ||
-	    ciph->protocol == IPPROTO_SCTP)
+	    ciph->protocol == IPPROTO_SCTP) {
 		ctoff += 2 * sizeof(__u16);
+		has_ports = true;
+	}
 	if (skb_ensure_writable(skb, ctoff))
 		goto out;
 
 #ifdef CONFIG_IP_VS_IPV6
 	if (af == AF_INET6)
-		ip_vs_nat_icmp_v6(skb, pp, cp, 1, toff, ciph);
+		ip_vs_nat_icmp_v6(skb, pp, cp, 1, toff, has_ports, ciph);
 	else
 #endif
-		ip_vs_nat_icmp(skb, pp, cp, 1, toff);
+		ip_vs_nat_icmp(skb, pp, cp, 1, toff, has_ports);
 
 	if (ip_vs_route_me_harder(cp->ipvs, af, skb, hooknum))
 		goto out;
@@ -1142,8 +1140,7 @@ static int ip_vs_out_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb,
 		return NF_ACCEPT;
 
 	/* Is the embedded protocol header present? */
-	if (unlikely(cih->frag_off & htons(IP_OFFSET) &&
-		     pp->dont_defrag))
+	if (unlikely(cih->frag_off & htons(IP_OFFSET) && !pp->dont_defrag))
 		return NF_ACCEPT;
 
 	IP_VS_DBG_PKT(11, AF_INET, pp, skb, offset,
@@ -1207,6 +1204,10 @@ static int ip_vs_out_icmp_v6(struct netns_ipvs *ipvs, struct sk_buff *skb,
 	if (!pp)
 		return NF_ACCEPT;
 
+	/* Is the embedded protocol header present? */
+	if (unlikely(ciph.fragoffs && !pp->dont_defrag))
+		return NF_ACCEPT;
+
 	/* The embedded headers contain source and dest in reverse order */
 	cp = INDIRECT_CALL_1(pp->conn_out_get, ip_vs_conn_out_get_proto,
 			     ipvs, AF_INET6, skb, &ciph);
@@ -1865,8 +1866,7 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 	pp = pd->pp;
 
 	/* Is the embedded protocol header present? */
-	if (unlikely(cih->frag_off & htons(IP_OFFSET) &&
-		     pp->dont_defrag))
+	if (unlikely(cih->frag_off & htons(IP_OFFSET) && !pp->dont_defrag))
 		return NF_ACCEPT;
 
 	IP_VS_DBG_PKT(11, AF_INET, pp, skb, offset,
@@ -1874,7 +1874,6 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 
 	offset2 = offset;
 	ip_vs_fill_iph_skb_icmp(AF_INET, skb, offset, !tunnel, &ciph);
-	offset = ciph.len;
 
 	/* The embedded headers contain source and dest in reverse order.
 	 * For IPIP/UDP/GRE tunnel this is error for request, not for reply.
@@ -1968,11 +1967,7 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 
 	/* do the statistics and put it back */
 	ip_vs_in_stats(cp, skb);
-	if (IPPROTO_TCP == cih->protocol || IPPROTO_UDP == cih->protocol ||
-	    IPPROTO_SCTP == cih->protocol)
-		offset += 2 * sizeof(__u16);
-	verdict = ip_vs_icmp_xmit(skb, cp, pp, iph->len, offset, hooknum,
-				  &ciph);
+	verdict = ip_vs_icmp_xmit(skb, cp, pp, iph->len, hooknum, &ciph);
 
 out:
 	if (likely(!new_cp))
@@ -2032,8 +2027,8 @@ static int ip_vs_in_icmp_v6(struct netns_ipvs *ipvs, struct sk_buff *skb,
 		return NF_ACCEPT;
 	pp = pd->pp;
 
-	/* Cannot handle fragmented embedded protocol */
-	if (ciph.fragoffs)
+	/* Is the embedded protocol header present? */
+	if (ciph.fragoffs && !pp->dont_defrag)
 		return NF_ACCEPT;
 
 	IP_VS_DBG_PKT(11, AF_INET6, pp, skb, offset,
@@ -2057,13 +2052,6 @@ static int ip_vs_in_icmp_v6(struct netns_ipvs *ipvs, struct sk_buff *skb,
 		new_cp = true;
 	}
 
-	/* VS/TUN, VS/DR and LOCALNODE just let it go */
-	if ((hooknum == NF_INET_LOCAL_OUT) &&
-	    (IP_VS_FWD_METHOD(cp) != IP_VS_CONN_F_MASQ)) {
-		verdict = NF_ACCEPT;
-		goto out;
-	}
-
 	verdict = NF_DROP;
 
 	/* Ensure the checksum is correct */
@@ -2079,14 +2067,7 @@ static int ip_vs_in_icmp_v6(struct netns_ipvs *ipvs, struct sk_buff *skb,
 	/* do the statistics and put it back */
 	ip_vs_in_stats(cp, skb);
 
-	/* Need to mangle contained IPv6 header in ICMPv6 packet */
-	offset = ciph.len;
-	if (IPPROTO_TCP == ciph.protocol || IPPROTO_UDP == ciph.protocol ||
-	    IPPROTO_SCTP == ciph.protocol)
-		offset += 2 * sizeof(__u16); /* Also mangle ports */
-
-	verdict = ip_vs_icmp_xmit_v6(skb, cp, pp, iph->len, offset, hooknum,
-				     &ciph);
+	verdict = ip_vs_icmp_xmit_v6(skb, cp, pp, iph->len, hooknum, &ciph);
 
 out:
 	if (likely(!new_cp))
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index c23401c789de..0b0c5304993a 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -1503,13 +1503,14 @@ ip_vs_dr_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 int
 ip_vs_icmp_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 		struct ip_vs_protocol *pp, unsigned int toff,
-		unsigned int wlen, unsigned int hooknum,
-		struct ip_vs_iphdr *ciph)
+		unsigned int hooknum, struct ip_vs_iphdr *ciph)
 {
 	struct rtable	*rt;	/* Route to the other host */
 	int rc;
 	int local;
 	int rt_mode, was_input;
+	bool has_ports = false;
+	unsigned int wlen;
 
 	/* The ICMP packet for VS/TUN, VS/DR and LOCALNODE will be
 	   forwarded directly here, because there is no need to
@@ -1565,6 +1566,13 @@ ip_vs_icmp_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 		goto tx_error;
 	}
 
+	wlen = ciph->len;
+	if (ciph->protocol == IPPROTO_TCP || ciph->protocol == IPPROTO_UDP ||
+	    ciph->protocol == IPPROTO_SCTP) {
+		wlen += 2 * sizeof(__u16); /* Also mangle ports */
+		has_ports = true;
+	}
+
 	/* copy-on-write the packet before mangling it */
 	if (skb_ensure_writable(skb, wlen))
 		goto tx_error;
@@ -1572,7 +1580,7 @@ ip_vs_icmp_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 	if (skb_cow(skb, rt->dst.dev->hard_header_len))
 		goto tx_error;
 
-	ip_vs_nat_icmp(skb, pp, cp, 0, toff);
+	ip_vs_nat_icmp(skb, pp, cp, 0, toff, has_ports);
 
 	/* Another hack: avoid icmp_send in ip_fragment */
 	skb->ignore_df = 1;
@@ -1589,10 +1597,11 @@ ip_vs_icmp_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 int
 ip_vs_icmp_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 		struct ip_vs_protocol *pp, unsigned int toff,
-		unsigned int wlen, unsigned int hooknum,
-		struct ip_vs_iphdr *ciph)
+		unsigned int hooknum, struct ip_vs_iphdr *ciph)
 {
+	bool has_ports = false;
 	struct rt6_info	*rt;	/* Route to the other host */
+	unsigned int wlen;
 	int rc;
 	int local;
 	int rt_mode;
@@ -1650,6 +1659,13 @@ ip_vs_icmp_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 		goto tx_error;
 	}
 
+	wlen = ciph->len;
+	if (ciph->protocol == IPPROTO_TCP || ciph->protocol == IPPROTO_UDP ||
+	    ciph->protocol == IPPROTO_SCTP) {
+		wlen += 2 * sizeof(__u16); /* Also mangle ports */
+		has_ports = true;
+	}
+
 	/* copy-on-write the packet before mangling it */
 	if (skb_ensure_writable(skb, wlen))
 		goto tx_error;
@@ -1657,7 +1673,7 @@ ip_vs_icmp_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 	if (skb_cow(skb, rt->dst.dev->hard_header_len))
 		goto tx_error;
 
-	ip_vs_nat_icmp_v6(skb, pp, cp, 0, toff, ciph);
+	ip_vs_nat_icmp_v6(skb, pp, cp, 0, toff, has_ports, ciph);
 
 	/* Another hack: avoid icmp_send in ip_fragment */
 	skb->ignore_df = 1;
-- 
2.47.3

