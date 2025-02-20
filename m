Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7E21A8F6D
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Feb 2025 13:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740057829; cv=none; b=qUVhNxKxnFh2ndZ9BweHsELAmlirnswzUL/zZX5UnwRIlOAfy8n+9M0bF4VQDvpX5wBBhO58V5OvBTnbw1KsuZQlm7Ewhf9doukODXW5VwAfl2h7JNsUU3cVafJLv//5nL6rhUF7kn2c+AxX/UYyUQ6aV/X0U6Cvl1OoIF4UKFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740057829; c=relaxed/simple;
	bh=YaBpJJxM0TpfPZMpo8kxTKT817VsxhvcGSaHxa19kLI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oZhtMwFv/Rh1iR8AsrnuxjwqanxuT2ayf2w3/xjotrUDxnJU/ZIo5Wl/P6nUU06VKXT/6nA8t6WwhFzDwzU3n8zaNtYor3h3L+KjBBjxN3thqFEh47bbrRLfSxO2P3qKSl33IIMS3uy8hmASjaGQHXsQsYTpV5nujQRS2X/xAMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tl6We-00008F-JJ; Thu, 20 Feb 2025 14:23:36 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: fib: avoid lookup if socket is available
Date: Thu, 20 Feb 2025 14:07:01 +0100
Message-ID: <20250220130703.2043-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In case the fib match is used from the input hook we can avoid the fib
lookup if early demux assigned a socket for us: check that the input
interface matches sk-cached one.

Rework the existing 'lo bypass' logic to first check sk, then
for loopback interface type to elide the fib lookup.

This speeds up fib matching a little, before:
93.08 GBit/s (no rules at all)
75.1  GBit/s ("fib saddr . iif oif missing drop" in prerouting)
75.62 GBit/s ("fib saddr . iif oif missing drop" in input)

After:
92.48 GBit/s (no rules at all)
75.62 GBit/s (fib rule in prerouting)
90.37 GBit/s (fib rule in input).

Numbers for the 'no rules' and 'prerouting' are expected to
closely match in-between runs, the 3rd/input test case exercises the
the 'avoid lookup if cached ifindex in sk matches' case.

Test used iperf3 via veth interface, lo can't be used due to existing
loopback test.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nft_fib.h   | 21 +++++++++++++++++++++
 net/ipv4/netfilter/nft_fib_ipv4.c | 11 +++++------
 net/ipv6/netfilter/nft_fib_ipv6.c | 19 ++++++++++---------
 3 files changed, 36 insertions(+), 15 deletions(-)

diff --git a/include/net/netfilter/nft_fib.h b/include/net/netfilter/nft_fib.h
index 38cae7113de4..6e202ed5e63f 100644
--- a/include/net/netfilter/nft_fib.h
+++ b/include/net/netfilter/nft_fib.h
@@ -18,6 +18,27 @@ nft_fib_is_loopback(const struct sk_buff *skb, const struct net_device *in)
 	return skb->pkt_type == PACKET_LOOPBACK || in->flags & IFF_LOOPBACK;
 }
 
+static inline bool nft_fib_can_skip(const struct nft_pktinfo *pkt)
+{
+	const struct net_device *indev = nft_in(pkt);
+	const struct sock *sk;
+
+	switch (nft_hook(pkt)) {
+	case NF_INET_PRE_ROUTING:
+	case NF_INET_INGRESS:
+	case NF_INET_LOCAL_IN:
+		break;
+	default:
+		return false;
+	}
+
+	sk = pkt->skb->sk;
+	if (sk && sk_fullsock(sk))
+	       return sk->sk_rx_dst_ifindex == indev->ifindex;
+
+	return nft_fib_is_loopback(pkt->skb, indev);
+}
+
 int nft_fib_dump(struct sk_buff *skb, const struct nft_expr *expr, bool reset);
 int nft_fib_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		 const struct nlattr * const tb[]);
diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index 625adbc42037..9082ca17e845 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -71,6 +71,11 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	const struct net_device *oif;
 	const struct net_device *found;
 
+	if (nft_fib_can_skip(pkt)) {
+		nft_fib_store_result(dest, priv, nft_in(pkt));
+		return;
+	}
+
 	/*
 	 * Do not set flowi4_oif, it restricts results (for example, asking
 	 * for oif 3 will get RTN_UNICAST result even if the daddr exits
@@ -85,12 +90,6 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	else
 		oif = NULL;
 
-	if (nft_hook(pkt) == NF_INET_PRE_ROUTING &&
-	    nft_fib_is_loopback(pkt->skb, nft_in(pkt))) {
-		nft_fib_store_result(dest, priv, nft_in(pkt));
-		return;
-	}
-
 	iph = skb_header_pointer(pkt->skb, noff, sizeof(_iph), &_iph);
 	if (!iph) {
 		regs->verdict.code = NFT_BREAK;
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index c9f1634b3838..7fd9d7b21cd4 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -170,6 +170,11 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	struct rt6_info *rt;
 	int lookup_flags;
 
+	if (nft_fib_can_skip(pkt)) {
+		nft_fib_store_result(dest, priv, nft_in(pkt));
+		return;
+	}
+
 	if (priv->flags & NFTA_FIB_F_IIF)
 		oif = nft_in(pkt);
 	else if (priv->flags & NFTA_FIB_F_OIF)
@@ -181,17 +186,13 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		return;
 	}
 
-	lookup_flags = nft_fib6_flowi_init(&fl6, priv, pkt, oif, iph);
-
-	if (nft_hook(pkt) == NF_INET_PRE_ROUTING ||
-	    nft_hook(pkt) == NF_INET_INGRESS) {
-		if (nft_fib_is_loopback(pkt->skb, nft_in(pkt)) ||
-		    nft_fib_v6_skip_icmpv6(pkt->skb, pkt->tprot, iph)) {
-			nft_fib_store_result(dest, priv, nft_in(pkt));
-			return;
-		}
+	if (nft_fib_v6_skip_icmpv6(pkt->skb, pkt->tprot, iph)) {
+		nft_fib_store_result(dest, priv, nft_in(pkt));
+		return;
 	}
 
+	lookup_flags = nft_fib6_flowi_init(&fl6, priv, pkt, oif, iph);
+
 	*dest = 0;
 	rt = (void *)ip6_route_lookup(nft_net(pkt), &fl6, pkt->skb,
 				      lookup_flags);
-- 
2.45.3

