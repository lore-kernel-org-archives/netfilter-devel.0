Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E123570C9
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Feb 2026 12:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770899164; cv=none; b=uCgs2hCCUKixbxeExAkHVlnS6UeYo9tBNM2r72oD4xLsqJSigPE7k5jV13vjRpqDN1KLXS9ZfY+VFCqCiznpiQRbvtOkGzUCMt7/JEv9fcSG2o91ujxJmq8gohqQroS8Q8OWBBoDcmjPdsGN+j/Uyo7T3xDBvRxjgumGOaVZtv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770899164; c=relaxed/simple;
	bh=VQqn6a+78QBhypz3cIDDJv+6Rx276H7AhRWsW1CEyHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIc+FarcpwLZd4TR2U2Deu7X5oL1KA0U+0r8pY2qk0XFqvAtgTbHchdl9Nrcsb3I8BP7OenPvgd6Dd8FhVhA9b7UVaX97qsjhmPXskxQvumtnWO1q89HvYafcgWzBW7d3ZMJOa1JRGtiZIwr3WvaqTaNkmWhLsQROHCm6OHcTso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 760946063D; Thu, 12 Feb 2026 13:26:01 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/2] netfilter: nft_fib_ipv6: switch to fib6_lookup
Date: Thu, 12 Feb 2026 13:25:09 +0100
Message-ID: <20260212122547.10437-3-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260212122547.10437-1-fw@strlen.de>
References: <20260212122547.10437-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Existing code works but it requires a temporary dst object that is
released again right away.

Switch to fib6_lookup + RT6_LOOKUP_F_DST_NOREF: no need for temporary dst
objects and refcount overhead anymore.

Provides ~13% improvement in match performance.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv6/netfilter/nft_fib_ipv6.c | 79 +++++++++++++++++++------------
 1 file changed, 49 insertions(+), 30 deletions(-)

diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index 421036a3605b..4272a3f60b11 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -52,7 +52,13 @@ static int nft_fib6_flowi_init(struct flowi6 *fl6, const struct nft_fib *priv,
 	fl6->flowlabel = (*(__be32 *)iph) & IPV6_FLOWINFO_MASK;
 	fl6->flowi6_l3mdev = nft_fib_l3mdev_master_ifindex_rcu(pkt, dev);
 
-	return lookup_flags;
+	return lookup_flags | RT6_LOOKUP_F_DST_NOREF;
+}
+
+static int nft_fib6_lookup(struct net *net, struct flowi6 *fl6,
+			   struct fib6_result *res, int flags)
+{
+	return fib6_lookup(net, fl6->flowi6_oif, fl6, res, flags);
 }
 
 static u32 __nft_fib6_eval_type(const struct nft_fib *priv,
@@ -60,13 +66,14 @@ static u32 __nft_fib6_eval_type(const struct nft_fib *priv,
 				struct ipv6hdr *iph)
 {
 	const struct net_device *dev = NULL;
+	struct fib6_result res = {};
 	int route_err, addrtype;
-	struct rt6_info *rt;
 	struct flowi6 fl6 = {
 		.flowi6_iif = LOOPBACK_IFINDEX,
 		.flowi6_proto = pkt->tprot,
 		.flowi6_uid = sock_net_uid(nft_net(pkt), NULL),
 	};
+	int lookup_flags;
 	u32 ret = 0;
 
 	if (priv->flags & NFTA_FIB_F_IIF)
@@ -74,29 +81,23 @@ static u32 __nft_fib6_eval_type(const struct nft_fib *priv,
 	else if (priv->flags & NFTA_FIB_F_OIF)
 		dev = nft_out(pkt);
 
-	nft_fib6_flowi_init(&fl6, priv, pkt, dev, iph);
+	lookup_flags = nft_fib6_flowi_init(&fl6, priv, pkt, dev, iph);
 
 	if (dev && nf_ipv6_chk_addr(nft_net(pkt), &fl6.daddr, dev, true))
 		ret = RTN_LOCAL;
 
-	route_err = nf_ip6_route(nft_net(pkt), (struct dst_entry **)&rt,
-				 flowi6_to_flowi(&fl6), false);
+	route_err = nft_fib6_lookup(nft_net(pkt), &fl6, &res, lookup_flags);
 	if (route_err)
 		goto err;
 
-	if (rt->rt6i_flags & RTF_REJECT) {
-		route_err = rt->dst.error;
-		dst_release(&rt->dst);
-		goto err;
-	}
+	if (res.fib6_flags & RTF_REJECT)
+		return RTN_PROHIBIT;
 
-	if (ipv6_anycast_destination((struct dst_entry *)rt, &fl6.daddr))
+	if (res.fib6_flags & RTF_ANYCAST)
 		ret = RTN_ANYCAST;
-	else if (!dev && rt->rt6i_flags & RTF_LOCAL)
+	else if (!dev && res.fib6_flags & RTF_LOCAL)
 		ret = RTN_LOCAL;
 
-	dst_release(&rt->dst);
-
 	if (ret)
 		return ret;
 
@@ -152,6 +153,33 @@ static bool nft_fib_v6_skip_icmpv6(const struct sk_buff *skb, u8 next, const str
 	return ipv6_addr_type(&iph->daddr) & IPV6_ADDR_LINKLOCAL;
 }
 
+static bool nft_fib6_info_nh_dev_match(const struct net_device *nh_dev,
+				       const struct net_device *dev)
+{
+	return nh_dev == dev ||
+	       l3mdev_master_ifindex_rcu(nh_dev) == dev->ifindex;
+}
+
+static bool nft_fib6_info_nh_uses_dev(struct fib6_info *rt,
+				      const struct net_device *dev)
+{
+	const struct net_device *nh_dev;
+	struct fib6_info *iter;
+
+	nh_dev = fib6_info_nh_dev(rt);
+	if (nft_fib6_info_nh_dev_match(nh_dev, dev))
+		return true;
+
+	list_for_each_entry(iter, &rt->fib6_siblings, fib6_siblings) {
+		nh_dev = fib6_info_nh_dev(iter);
+
+		if (nft_fib6_info_nh_dev_match(nh_dev, dev))
+			return true;
+	}
+
+	return false;
+}
+
 void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		   const struct nft_pktinfo *pkt)
 {
@@ -160,14 +188,14 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	const struct net_device *found = NULL;
 	const struct net_device *oif = NULL;
 	u32 *dest = &regs->data[priv->dreg];
+	struct fib6_result res = {};
 	struct ipv6hdr *iph, _iph;
 	struct flowi6 fl6 = {
 		.flowi6_iif = LOOPBACK_IFINDEX,
 		.flowi6_proto = pkt->tprot,
 		.flowi6_uid = sock_net_uid(nft_net(pkt), NULL),
 	};
-	struct rt6_info *rt;
-	int lookup_flags;
+	int lookup_flags, ret;
 
 	if (nft_fib_can_skip(pkt)) {
 		nft_fib_store_result(dest, priv, nft_in(pkt));
@@ -193,26 +221,17 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	lookup_flags = nft_fib6_flowi_init(&fl6, priv, pkt, oif, iph);
 
 	*dest = 0;
-	rt = (void *)ip6_route_lookup(nft_net(pkt), &fl6, pkt->skb,
-				      lookup_flags);
-	if (rt->dst.error)
-		goto put_rt_err;
-
-	/* Should not see RTF_LOCAL here */
-	if (rt->rt6i_flags & (RTF_REJECT | RTF_ANYCAST | RTF_LOCAL))
-		goto put_rt_err;
+	ret = nft_fib6_lookup(nft_net(pkt), &fl6, &res, lookup_flags);
+	if (ret || res.fib6_flags & (RTF_REJECT | RTF_ANYCAST | RTF_LOCAL))
+		return;
 
 	if (!oif) {
-		found = rt->rt6i_idev->dev;
+		found = fib6_info_nh_dev(res.f6i);
 	} else {
-		if (oif == rt->rt6i_idev->dev ||
-		    l3mdev_master_ifindex_rcu(rt->rt6i_idev->dev) == oif->ifindex)
+		if (nft_fib6_info_nh_uses_dev(res.f6i, oif))
 			found = oif;
 	}
-
 	nft_fib_store_result(dest, priv, found);
- put_rt_err:
-	ip6_rt_put(rt);
 }
 EXPORT_SYMBOL_GPL(nft_fib6_eval);
 
-- 
2.52.0

