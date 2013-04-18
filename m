From: Florian Westphal <fw@strlen.de>
Subject: [PATCH V2 1/2] netfilter: rpfilter: skip locally generated bcast, too
Date: Thu, 18 Apr 2013 10:45:24 +0200
Message-ID: <1366274725-16286-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50388 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753310Ab3DRInU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Apr 2013 04:43:20 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alex Efros reported rpfilter module doesn't match following packets:
IN=br.qemu SRC=192.168.2.1 DST=192.168.2.255 [ .. ]
(netfilter bugzilla #814).

Problem is that network stack arranges for the locally generated broadcasts
to appear on the interface they were sent out, so the IFF_LOOPBACK check
doesn't trigger.

As -m rpfilter is restricted to PREROUTING, we can check for existing
rtable instead, it catches locally-generated broad/multicast case, too.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Pablo,

 I did have a look at nf_conntrack_broadcast, but
 1. I cannot check skb->sk (TPROXY can set that for incoming packets)
 2. I don't want to test conntrack info to avoid dependency on conntrack

 So, this is pretty much the very same patch as V1, except that this
 also checks for _LOCAL flag instead of just checking for presence of
 skb_dst().

 Is this ok, or did you have something else in mind?

 net/ipv4/netfilter/ipt_rpfilter.c  |    8 +++++++-
 net/ipv6/netfilter/ip6t_rpfilter.c |    8 +++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_rpfilter.c b/net/ipv4/netfilter/ipt_rpfilter.c
index c301300..faa35b7 100644
--- a/net/ipv4/netfilter/ipt_rpfilter.c
+++ b/net/ipv4/netfilter/ipt_rpfilter.c
@@ -66,6 +66,12 @@ static bool rpfilter_lookup_reverse(struct flowi4 *fl4,
 	return dev_match;
 }
 
+static bool is_local(const struct sk_buff *skb)
+{
+	const struct rtable *rt = skb_rtable(skb);
+	return rt && (rt->rt_flags & RTCF_LOCAL);
+}
+
 static bool rpfilter_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_rpfilter_info *info;
@@ -76,7 +82,7 @@ static bool rpfilter_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	info = par->matchinfo;
 	invert = info->flags & XT_RPFILTER_INVERT;
 
-	if (par->in->flags & IFF_LOOPBACK)
+	if (is_local(skb))
 		return true ^ invert;
 
 	iph = ip_hdr(skb);
diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
index 5060d54..43114010 100644
--- a/net/ipv6/netfilter/ip6t_rpfilter.c
+++ b/net/ipv6/netfilter/ip6t_rpfilter.c
@@ -71,6 +71,12 @@ static bool rpfilter_lookup_reverse6(const struct sk_buff *skb,
 	return ret;
 }
 
+static bool is_local(const struct sk_buff *skb)
+{
+	const struct rt6_info *rt = (const void *) skb_dst(skb);
+	return rt && (rt->rt6i_flags & RTF_LOCAL);
+}
+
 static bool rpfilter_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_rpfilter_info *info = par->matchinfo;
@@ -78,7 +84,7 @@ static bool rpfilter_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	struct ipv6hdr *iph;
 	bool invert = info->flags & XT_RPFILTER_INVERT;
 
-	if (par->in->flags & IFF_LOOPBACK)
+	if (is_local(skb))
 		return true ^ invert;
 
 	iph = ipv6_hdr(skb);
-- 
1.7.8.6

