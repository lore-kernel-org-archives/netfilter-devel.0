Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86AD202960;
	Sun, 23 Mar 2025 10:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742724578; cv=none; b=nhoCSJBwbL34rxRkj8SCGhLAXtXxNOdzxiXY+63nnHQ+go/oYC1fW8UJtmA7wILe5M+A1F2w8CPn3Y27UybvO1IbOhAbiIDXJnsYGLZvMSQS4ef5fXocW80nAggRn/Z6Vn428oYJXEreVFNMMqAwKNC/mvoLMKobIEtCLaM1iaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742724578; c=relaxed/simple;
	bh=jHRQI1afRCduUTVINkX4kzU0h6QsudO5WWIJG2tq5SE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CB9IMUe6h1BfjZYaR3straZPBIlIJUhwbHep8naaZkSqaOxTOEQU/6Vt95G+sbMkv+YtbXOKdfIVyIxJnn4L7wP9D4lhS/oK1fxxan+G+2pZOrLbKKZQmOGzln4wWJFqbEJEHQyVV7LxSLakFsI4SPNL2wTT/1iPvAFfDYolx7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=wJ3elm7D; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rGdNDddr; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="wJ3elm7D";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rGdNDddr"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 274B76037B; Sun, 23 Mar 2025 11:09:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742724575;
	bh=nKuBMBTjSQWadtU3KjEOfqhEgNBodhsp4nQpaPd9hX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wJ3elm7DSe+2nvF0UBIW+CWbDT74KnrfLXLcY66KXS3mxH3HbRilSawg0k4WpZyzS
	 pVcnh+LDVBVW8ZFdGz1GmvjaHot4LCV+nVpgKRLyImlL+4yU9xCxGogJy0XhDUDYvH
	 5a0j+bw7ig54qYrs+kivjRB4I7W78c3rYSmzvu1Rwx6Vm3F+TzRW7XfM8wPAYWewr1
	 NqsWGZKlEkF3s+kQ/C9hnc9weSqECP6MgLBuw+MlQQcWZnyP+nspGWvLYgAFvhSwn3
	 cKyColoEEWo4VFaGHvRAHIxC1QGscMe3k8XgEXO/veJyC6VaR3OJRIqzC8mt+jdsiK
	 /zfc8AZNXvI7g==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D08F06037B;
	Sun, 23 Mar 2025 11:09:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742724569;
	bh=nKuBMBTjSQWadtU3KjEOfqhEgNBodhsp4nQpaPd9hX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rGdNDddrrdGAXVqWz5JDuU8tyiezq+oDFQwjvIOVjVhYIU++ovujUpEJb83tLl+89
	 Xp5fFlVY3qAGS4tlJ18Kku+e4UwG8rNoBstIfBR6p/ZktGxMFqL0LHWrBHYdG2LaSy
	 2JiuOsfRlD0/7EN6t63F6tBZedbgvseyssmUiKgP9kNy9zyrbHg1G6b+6ZEZxLy55Z
	 HLhoKz1ENgIUonq5Nb5GkaFUMKEapZE0fiFmOVx6McPixnZ+cLBfzi7oOWSuvAVeNH
	 fAxYMPYPvIEG0U2PQmD6FRHoEzxOoNfDT1bYHb8PIw3H/XA0ivzQMczrfQags79avf
	 LAxyw811wxcIg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 3/7] netfilter: fib: avoid lookup if socket is available
Date: Sun, 23 Mar 2025 11:09:18 +0100
Message-Id: <20250323100922.59983-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250323100922.59983-1-pablo@netfilter.org>
References: <20250323100922.59983-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.30.2

