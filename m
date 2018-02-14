From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: don't set F_IFACE on ipv6 fib lookups
Date: Thu, 15 Feb 2018 00:23:05 +0100
Message-ID: <20180214232305.1047-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:44860 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1032135AbeBNXaM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Feb 2018 18:30:12 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

"fib" starts to behave strangely when an ipv6 default route is
added - the FIB lookup returns a route using 'oif' in this case.

This behaviour was inherited from ip6tables rpfilter so change
this as well.

Bugzilla: https://bugzilla.netfilter.org/show_bug.cgi?id=1221
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv6/netfilter/ip6t_rpfilter.c |  4 ----
 net/ipv6/netfilter/nft_fib_ipv6.c  | 12 ++----------
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
index 94deb69bbbda..91ed25a24b79 100644
--- a/net/ipv6/netfilter/ip6t_rpfilter.c
+++ b/net/ipv6/netfilter/ip6t_rpfilter.c
@@ -48,10 +48,6 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
 	}
 
 	fl6.flowi6_mark = flags & XT_RPFILTER_VALID_MARK ? skb->mark : 0;
-	if ((flags & XT_RPFILTER_LOOSE) == 0) {
-		fl6.flowi6_oif = dev->ifindex;
-		lookup_flags |= RT6_LOOKUP_F_IFACE;
-	}
 
 	rt = (void *) ip6_route_lookup(net, &fl6, lookup_flags);
 	if (rt->dst.error)
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index cc5174c7254c..62fc84d7bdff 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -180,7 +180,6 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	}
 
 	*dest = 0;
- again:
 	rt = (void *)ip6_route_lookup(nft_net(pkt), &fl6, lookup_flags);
 	if (rt->dst.error)
 		goto put_rt_err;
@@ -189,15 +188,8 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	if (rt->rt6i_flags & (RTF_REJECT | RTF_ANYCAST | RTF_LOCAL))
 		goto put_rt_err;
 
-	if (oif && oif != rt->rt6i_idev->dev) {
-		/* multipath route? Try again with F_IFACE */
-		if ((lookup_flags & RT6_LOOKUP_F_IFACE) == 0) {
-			lookup_flags |= RT6_LOOKUP_F_IFACE;
-			fl6.flowi6_oif = oif->ifindex;
-			ip6_rt_put(rt);
-			goto again;
-		}
-	}
+	if (oif && oif != rt->rt6i_idev->dev)
+		goto put_rt_err;
 
 	switch (priv->result) {
 	case NFT_FIB_RESULT_OIF:
-- 
2.16.1

