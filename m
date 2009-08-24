From: Balazs Scheidler <bazsi@balabit.hu>
Subject: [PATCH 07/11] TProxy: implement IPv6 "local" routing type
Date: Mon, 24 Aug 2009 14:47:53 +0200
Message-ID: <841ce89583303bb001af85ba8a0bcbd7a5a1fc9c.1251295408.git.bazsi@balabit.hu>
References: <cover.1251295408.git.bazsi@balabit.hu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: Harry Mason <harry.mason@smoothwall.net>
To: netfilter-devel@vger.kernel.org, tproxy@lists.balabit.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from support.balabit.hu ([195.70.41.86]:58544 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751926AbZH2Pu0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Aug 2009 11:50:26 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id C217C13A207
	for <netfilter-devel@vger.kernel.org>; Sat, 29 Aug 2009 17:21:38 +0200 (CEST)
In-Reply-To: <cover.1251295408.git.bazsi@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

IPv4 policy routing (and the ip command) allows to add a routing rule
with 'local' type, however this did not work with IPv6. This
patch implements the 'local' routing type by redirecting all such packets
to the local IP stack.

Signed-off-by: Balazs Scheidler <bazsi@balabit.hu>
---
 net/ipv6/route.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 1473ee0..9491579 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1174,6 +1174,8 @@ int ip6_route_add(struct fib6_config *cfg)
 
 	if (addr_type & IPV6_ADDR_MULTICAST)
 		rt->u.dst.input = ip6_mc_input;
+	else if (cfg->fc_flags & RTF_LOCAL)
+		rt->u.dst.input = ip6_input;
 	else
 		rt->u.dst.input = ip6_forward;
 
@@ -1195,7 +1197,7 @@ int ip6_route_add(struct fib6_config *cfg)
 	   they would result in kernel looping; promote them to reject routes
 	 */
 	if ((cfg->fc_flags & RTF_REJECT) ||
-	    (dev && (dev->flags&IFF_LOOPBACK) && !(addr_type&IPV6_ADDR_LOOPBACK))) {
+	    (((cfg->fc_flags & RTF_LOCAL) == 0) && (dev && (dev->flags&IFF_LOOPBACK) && !(addr_type&IPV6_ADDR_LOOPBACK)))) {
 		/* hold loopback dev/idev if we haven't done so. */
 		if (dev != net->loopback_dev) {
 			if (dev) {
@@ -2086,6 +2088,8 @@ static int rtm_to_fib6_config(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	if (rtm->rtm_type == RTN_UNREACHABLE)
 		cfg->fc_flags |= RTF_REJECT;
+        else if (rtm->rtm_type == RTN_LOCAL)
+		cfg->fc_flags |= RTF_LOCAL;
 
 	cfg->fc_nlinfo.pid = NETLINK_CB(skb).pid;
 	cfg->fc_nlinfo.nlh = nlh;
-- 
1.6.0.4


