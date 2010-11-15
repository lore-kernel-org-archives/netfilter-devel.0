From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH] ipvs: remove shadow rt variable
Date: Mon, 15 Nov 2010 19:46:33 +0100
Message-ID: <1289846793.2607.118.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Simon Horman <horms@verge.net.au>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56300 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811Ab0KOSqi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Nov 2010 13:46:38 -0500
Received: by wyb28 with SMTP id 28so4708936wyb.19
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Nov 2010 10:46:37 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove a sparse warning about rt variable.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 net/netfilter/ipvs/ip_vs_xmit.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 10bd39c..50b131c 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -188,7 +188,6 @@ __ip_vs_reroute_locally(struct sk_buff *skb)
 			},
 			.mark = skb->mark,
 		};
-		struct rtable *rt;
 
 		if (ip_route_output_key(net, &rt, &fl))
 			return 0;


