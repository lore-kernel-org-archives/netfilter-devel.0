From: Florian Westphal <fw@strlen.de>
Subject: [PATCH] netfilter: rpfilter: skip locally generated bcast, too
Date: Fri, 12 Apr 2013 22:51:31 +0200
Message-ID: <1365799891-7731-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:60020 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753920Ab3DLUvt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Apr 2013 16:51:49 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alex Efros reported rpfilter module doesn't match following packets:
IN=br.qemu SRC=192.168.2.1 DST=192.168.2.255 [ .. ]
(netfilter bugzilla #814).

Problem is that network stack arranges for the locally generated broadcasts
to appear on the interface they were sent out, so the IFF_LOOPBACK check
doesn't trigger.

As -m rpfilter is restricted to PREROUTING, we can check for existing
skb_dst instead, it catches locally-generated broad/multicast case, too.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/ipt_rpfilter.c  |    2 +-
 net/ipv6/netfilter/ip6t_rpfilter.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_rpfilter.c b/net/ipv4/netfilter/ipt_rpfilter.c
index c301300..601abf2 100644
--- a/net/ipv4/netfilter/ipt_rpfilter.c
+++ b/net/ipv4/netfilter/ipt_rpfilter.c
@@ -76,7 +76,7 @@ static bool rpfilter_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	info = par->matchinfo;
 	invert = info->flags & XT_RPFILTER_INVERT;
 
-	if (par->in->flags & IFF_LOOPBACK)
+	if (skb_dst(skb)) /* locally generated? */
 		return true ^ invert;
 
 	iph = ip_hdr(skb);
diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
index 5060d54..8767991 100644
--- a/net/ipv6/netfilter/ip6t_rpfilter.c
+++ b/net/ipv6/netfilter/ip6t_rpfilter.c
@@ -78,7 +78,7 @@ static bool rpfilter_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	struct ipv6hdr *iph;
 	bool invert = info->flags & XT_RPFILTER_INVERT;
 
-	if (par->in->flags & IFF_LOOPBACK)
+	if (skb_dst(skb)) /* locally generated? */
 		return true ^ invert;
 
 	iph = ipv6_hdr(skb);
-- 
1.7.8.6

