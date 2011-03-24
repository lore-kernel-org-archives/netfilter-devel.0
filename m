From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 3/3] netfilter: xt_addrtype: replace rt6_lookup with nf_afinfo->route
Date: Thu, 24 Mar 2011 21:29:57 +0100
Message-ID: <1300998597-2018-3-git-send-email-fw@strlen.de>
References: <1300998597-2018-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:32795 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756417Ab1CXUgV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:36:21 -0400
In-Reply-To: <1300998597-2018-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This avoids pulling in the ipv6 module when using (ipv4-only) iptables -m addrtype.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 rebased on top of nf-2.6.git.

 Tested briefly with:
 [0:0] -A INPUT -m addrtype --src-type LOCAL
 [16:1552] -A INPUT -m addrtype --dst-type LOCAL
 [10:928] -A INPUT -m addrtype --dst-type LOCAL --limit-iface-in

 net/netfilter/Kconfig       |    1 -
 net/netfilter/xt_addrtype.c |   42 ++++++++++++++++++++++++++++--------------
 2 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index c3f988a..32bff6d 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -652,7 +652,6 @@ comment "Xtables matches"
 config NETFILTER_XT_MATCH_ADDRTYPE
 	tristate '"addrtype" address type match support'
 	depends on NETFILTER_ADVANCED
-	depends on (IPV6 || IPV6=n)
 	---help---
 	  This option allows you to match what routing thinks of an address,
 	  eg. UNICAST, LOCAL, BROADCAST, ...
diff --git a/net/netfilter/xt_addrtype.c b/net/netfilter/xt_addrtype.c
index 2220b85..b77d383 100644
--- a/net/netfilter/xt_addrtype.c
+++ b/net/netfilter/xt_addrtype.c
@@ -32,11 +32,32 @@ MODULE_ALIAS("ipt_addrtype");
 MODULE_ALIAS("ip6t_addrtype");
 
 #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
-static u32 xt_addrtype_rt6_to_type(const struct rt6_info *rt)
+static u32 match_lookup_rt6(struct net *net, const struct net_device *dev,
+			    const struct in6_addr *addr)
 {
+	const struct nf_afinfo *afinfo;
+	struct flowi6 flow;
+	struct rt6_info *rt;
 	u32 ret;
+	int route_err;
 
-	if (!rt)
+	memset(&flow, 0, sizeof(flow));
+	ipv6_addr_copy(&flow.daddr, addr);
+	if (dev)
+		flow.flowi6_oif = dev->ifindex;
+
+	rcu_read_lock();
+
+	afinfo = nf_get_afinfo(NFPROTO_IPV6);
+	if (afinfo != NULL)
+		route_err = afinfo->route(net, (struct dst_entry **)&rt,
+					flowi6_to_flowi(&flow), !!dev);
+	else
+		route_err = 1;
+
+	rcu_read_unlock();
+
+	if (route_err)
 		return XT_ADDRTYPE_UNREACHABLE;
 
 	if (rt->rt6i_flags & RTF_REJECT)
@@ -48,6 +69,9 @@ static u32 xt_addrtype_rt6_to_type(const struct rt6_info *rt)
 		ret |= XT_ADDRTYPE_LOCAL;
 	if (rt->rt6i_flags & RTF_ANYCAST)
 		ret |= XT_ADDRTYPE_ANYCAST;
+
+
+	dst_release(&rt->dst);
 	return ret;
 }
 
@@ -65,18 +89,8 @@ static bool match_type6(struct net *net, const struct net_device *dev,
 		return false;
 
 	if ((XT_ADDRTYPE_LOCAL | XT_ADDRTYPE_ANYCAST |
-	     XT_ADDRTYPE_UNREACHABLE) & mask) {
-		struct rt6_info *rt;
-		u32 type;
-		int ifindex = dev ? dev->ifindex : 0;
-
-		rt = rt6_lookup(net, addr, NULL, ifindex, !!dev);
-
-		type = xt_addrtype_rt6_to_type(rt);
-
-		dst_release(&rt->dst);
-		return !!(mask & type);
-	}
+	     XT_ADDRTYPE_UNREACHABLE) & mask)
+		return !!(mask & match_lookup_rt6(net, dev, addr));
 	return true;
 }
 
-- 
1.7.3.4

