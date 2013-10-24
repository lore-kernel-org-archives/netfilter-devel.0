From: Florian Westphal <fw@strlen.de>
Subject: [PATCH] bridge: netfilter: orphan skb before invoking ip netfilter hooks
Date: Thu, 24 Oct 2013 21:32:42 +0200
Message-ID: <1382643162-20009-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:43052 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756191Ab3JXTfo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Oct 2013 15:35:44 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pekka Pietik=C3=A4inen reports xt_socket behavioural change after commi=
t
00028aa37098o (netfilter: xt_socket: use IP early demux).

Reason is xt_socket now no longer does an unconditional sk lookup -
it re-uses existing skb->sk if possible, assuming ->sk was set by
tcp early demux.

However, when netfilter is invoked via bridge, this can cause 'bogus'
sockets to be examined by the match, e.g. a 'tun' device socket.

bridge netfilter should orphan the skb just like the routing path
before invoking ipv4/ipv6 netfilter hooks to avoid this.

Reported-and-tested-by: Pekka Pietik=C3=A4inen <pp@ee.oulu.fi>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 878f008..80cad2c 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -559,6 +559,8 @@ static struct net_device *setup_pre_routing(struct =
sk_buff *skb)
 	else if (skb->protocol =3D=3D htons(ETH_P_PPP_SES))
 		nf_bridge->mask |=3D BRNF_PPPoE;
=20
+	/* Must drop socket now because of tproxy. */
+	skb_orphan(skb);
 	return skb->dev;
 }
=20
--=20
1.8.1.5

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
