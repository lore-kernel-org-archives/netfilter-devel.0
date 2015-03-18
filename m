From: Bernhard Thaler <bernhard.thaler@wvnet.at>
Subject: [PATCH 3/4] netfilter: bridge: add mtu size reduction to ip6_fragment()
Date: Wed, 18 Mar 2015 22:54:44 +0100
Message-ID: <1426715684-16939-1-git-send-email-bernhard.thaler@wvnet.at>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
	Bernhard Thaler <bernhard.thaler@wvnet.at>
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smarthost1.wvnet.at ([62.212.174.130]:35510 "EHLO
	smarthost2.wvnet.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750905AbbCRWEW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Mar 2015 18:04:22 -0400
Received: from smtp.wvnet.at (localhost [127.0.0.1])
	by smarthost1.wvnet.at (Postfix) with ESMTP id CA98EFD5FE7
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2015 22:55:15 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ip6_fragment() was not called by netfilter bridge code before changes in
"bridge: forward IPv6 fragmented packets when passing" and lacks mtu size
reduction as found in ip_fragment().

Add mtu size reductions based on ip_fragment() code.

Signed-off-by: Bernhard Thaler <bernhard.thaler@wvnet.at>
---
Patch needs further testing in specific scenarios (e.g. fragmented IPv6
packet within PPPoE over bridge) to confirm correct operation.

 net/ipv6/ip6_output.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 0a04a37..9b5aeef 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -40,6 +40,7 @@
 #include <linux/slab.h>
 
 #include <linux/netfilter.h>
+#include <linux/netfilter_bridge.h>
 #include <linux/netfilter_ipv6.h>
 
 #include <net/sock.h>
@@ -578,6 +579,10 @@ int ip6_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
 			mtu = np->frag_size;
 	}
 	mtu -= hlen + sizeof(struct frag_hdr);
+#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	if (skb->nf_bridge)
+		mtu -= nf_bridge_mtu_reduction(skb);
+#endif
 
 	if (skb_has_frag_list(skb)) {
 		int first_len = skb_pagelen(skb);
@@ -717,7 +722,10 @@ slow_path:
 	 */
 
 	*prevhdr = NEXTHDR_FRAGMENT;
-	hroom = LL_RESERVED_SPACE(rt->dst.dev);
+	/* for bridged IP traffic encapsulated inside f.e. a vlan header,
+	 * we need to make room for the encapsulating header
+	 */
+	hroom = LL_RESERVED_SPACE_EXTRA(rt->dst.dev, nf_bridge_pad(skb));
 	troom = rt->dst.dev->needed_tailroom;
 
 	/*
-- 
1.7.10.4

