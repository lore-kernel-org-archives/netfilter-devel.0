From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH] netfilter: fix a dst leak in ipv6 REJECT
Date: Fri, 02 Jul 2010 09:06:51 +0200
Message-ID: <1278054411.2597.13.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
	stable@kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42395 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab0GBHGz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Jul 2010 03:06:55 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We should release dst if dst->error is set.

Bug introduced in 2.6.14 by commit e104411b82f5c
([XFRM]: Always release dst_entry on error in xfrm_lookup)

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 net/ipv6/netfilter/ip6t_REJECT.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index 47d2277..2933396 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -97,9 +97,11 @@ static void send_reset(struct net *net, struct sk_buff *oldskb)
 	fl.fl_ip_dport = otcph.source;
 	security_skb_classify_flow(oldskb, &fl);
 	dst = ip6_route_output(net, NULL, &fl);
-	if (dst == NULL)
+	if (dst == NULL || dst->error) {
+		dst_release(dst);
 		return;
-	if (dst->error || xfrm_lookup(net, &dst, &fl, NULL, 0))
+	}
+	if (xfrm_lookup(net, &dst, &fl, NULL, 0))
 		return;
 
 	hh_len = (dst->dev->hard_header_len + 15)&~15;


