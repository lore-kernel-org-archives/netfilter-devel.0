Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186D043C7B5;
	Mon, 10 Aug 2026 19:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786388809; cv=none; b=Yoh2/LikP3eIbnA41MyZFCWLHBb3sPiwFvx2BPdiv0ACjm98n4vXxKFE/0dlEz5ZUFQ9SHCxwEZYPU5xJvMUmWDNsM3Q3beCWR7frdd86R9LUrHKWrlJv6z3ni5J8oanob88LmbcBXlWbOQu384Q5rvI+SOQTHwxLgj2vLGps0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786388809; c=relaxed/simple;
	bh=7PpGWqTECjkvabFCWNkXlpfmhF3Ch9myM4T4ovihGG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GnoDmQz1PDrLPJiEKWVlANooqeZOZxVJ/gkufujMgy/p9VyymhVAEGsjKrox6U/BBllyRABrv6TDRL96IjzSzcSYN7wgAT40MKs8nVqEv7zbWaHnN2jS8t0htgDdV9A/YpsJENd0hvkwsBFLr5PwOHNDxY/X9+aiqgPNtV9S+bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=JvL/+fcq; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="JvL/+fcq"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C1F906028B;
	Mon, 10 Aug 2026 21:06:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786388806;
	bh=2/iyOKQKOdWkD259vMgf9M4AMTI97tZ3zU5U3cidqbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JvL/+fcqonaiOwGdi1vKsIWa0/Lj4t5VB+zHuuD58kwO/Rrnqa+m//iXsQ/KurnR6
	 FcKPwCp3vCDnWjeF/shnhJ7pKJe/SDrVKoOmj+q56bJzi5Y6gpVFKQibcbOpA0DNzi
	 hHA9E2JV1NERlkxwhopXYWWJC7ybbd5AWhj8zka88YVQqIszXOCckk0us6baOE5NJk
	 1Frg/QbROEt9aThtfPGQjsWFwB0PhCpGNtC09fXScQyIbbKyTAOnJ2PCYk4cfMo4v7
	 baRySZeoU4IQUiZ9NPFKfg2OsUtV00FdCe+S3ofkaDe7JKj+NxCUbSFWnMuavEEcpA
	 kvUlfNi/LkpiA==
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
Subject: [PATCH net 09/13] ipvs: revalidate ihl to prevent out-of-bounds access
Date: Mon, 10 Aug 2026 21:06:17 +0200
Message-ID: <20260810190621.894119-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260810190621.894119-1-pablo@netfilter.org>
References: <20260810190621.894119-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Julian Anastasov <ja@ssi.bg>

While the outer IP header is already pulled into the skb head,
we must be careful and revalidate the embedded headers after
reading them from the skb frags to prevent out-of-bounds
access.

One such place reported by Sashiko is ip_vs_nat_icmp() where
local process can change the ihl field and after
skb_ensure_writable() we can see larger value which is a
problem for the ip_send_check(cih) calls.

Add check to drop the packet if the ihl field is changed.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://sashiko.dev/#/patchset/20260730183506.87473-1-ja%40ssi.bg
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/ip_vs.h             |  2 +-
 net/netfilter/ipvs/ip_vs_core.c | 11 +++++++++--
 net/netfilter/ipvs/ip_vs_xmit.c |  3 ++-
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index fc2ef5ef31a6..be3a6617adf4 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -2068,7 +2068,7 @@ static inline bool ip_vs_conn_use_hash2(struct ip_vs_conn *cp)
 	       !(cp->flags & IP_VS_CONN_F_TEMPLATE);
 }
 
-void ip_vs_nat_icmp(struct sk_buff *skb, struct ip_vs_protocol *pp,
+bool ip_vs_nat_icmp(struct sk_buff *skb, struct ip_vs_protocol *pp,
 		    struct ip_vs_conn *cp, int dir, unsigned int toff,
 		    bool has_ports, struct ip_vs_iphdr *ciph);
 
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index a46e7acdd8e1..eb806813292a 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -923,7 +923,7 @@ static int ip_vs_route_me_harder(struct netns_ipvs *ipvs, int af,
  * Packet has been made sufficiently writable in caller
  * - inout: 1=in->out, 0=out->in
  */
-void ip_vs_nat_icmp(struct sk_buff *skb, struct ip_vs_protocol *pp,
+bool ip_vs_nat_icmp(struct sk_buff *skb, struct ip_vs_protocol *pp,
 		    struct ip_vs_conn *cp, int inout, unsigned int toff,
 		    bool has_ports, struct ip_vs_iphdr *ciph)
 {
@@ -931,6 +931,11 @@ void ip_vs_nat_icmp(struct sk_buff *skb, struct ip_vs_protocol *pp,
 	struct icmphdr *icmph	 = (struct icmphdr *)(skb->data + toff);
 	struct iphdr *cih	 = (struct iphdr *)(icmph + 1);
 
+	/* Before now we may used ihl from skb frag, revalidate it after
+	 * copying it into skb head to prevent out-of-bounds access
+	 */
+	if (cih->ihl * 4 != ciph->len - ciph->off)
+		return false;
 	if (inout) {
 		iph->saddr = cp->vaddr.ip;
 		ip_send_check(iph);
@@ -964,6 +969,7 @@ void ip_vs_nat_icmp(struct sk_buff *skb, struct ip_vs_protocol *pp,
 	else
 		IP_VS_DBG_PKT(11, AF_INET, pp, skb, ciph->off,
 			      "Forwarding altered incoming ICMP");
+	return true;
 }
 
 #ifdef CONFIG_IP_VS_IPV6
@@ -1055,7 +1061,8 @@ static int handle_response_icmp(int af, struct sk_buff *skb,
 		ip_vs_nat_icmp_v6(skb, pp, cp, 1, toff, has_ports, ciph);
 	else
 #endif
-		ip_vs_nat_icmp(skb, pp, cp, 1, toff, has_ports, ciph);
+		if (!ip_vs_nat_icmp(skb, pp, cp, 1, toff, has_ports, ciph))
+			goto out;
 
 	if (ip_vs_route_me_harder(cp->ipvs, af, skb, hooknum))
 		goto out;
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index fc7403186394..04450a48f01a 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -1580,7 +1580,8 @@ ip_vs_icmp_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 	if (skb_cow(skb, rt->dst.dev->hard_header_len))
 		goto tx_error;
 
-	ip_vs_nat_icmp(skb, pp, cp, 0, toff, has_ports, ciph);
+	if (!ip_vs_nat_icmp(skb, pp, cp, 0, toff, has_ports, ciph))
+		goto tx_error;
 
 	/* Another hack: avoid icmp_send in ip_fragment */
 	skb->ignore_df = 1;
-- 
2.47.3

