From: pablo@netfilter.org
Subject: [PATCH 2/3] netfilter: possible unaligned packet header in ip_route_me_harder
Date: Mon, 28 Nov 2011 04:30:59 +0100
Message-ID: <1322451060-4883-3-git-send-email-pablo@netfilter.org>
References: <1322451060-4883-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, Paul Guo <ggang@tilera.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57658 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436Ab1K1DbW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Nov 2011 22:31:22 -0500
In-Reply-To: <1322451060-4883-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Paul Guo <ggang@tilera.com>

This patch tries to fix the following issue in netfilter:
In ip_route_me_harder(), we invoke pskb_expand_head() that
rellocates new header with additional head room which can break
the alignment of the original packet header.

In one of my NAT test case, the NIC port for internal hosts is
configured with vlan and the port for external hosts is with
general configuration. If we ping an external "unknown" hosts from an
internal host, an icmp packet will be sent. We find that in
icmp_send()->...->ip_route_me_harder()->pskb_expand_head(), hh_len=18
and current headroom (skb_headroom(skb)) of the packet is 16. After
calling pskb_expand_head() the packet header becomes to be unaligned
and then our system (arch/tile) panics immediately.

Signed-off-by: Paul Guo <ggang@tilera.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index 9899619..4f47e06 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -64,7 +64,8 @@ int ip_route_me_harder(struct sk_buff *skb, unsigned addr_type)
 	/* Change in oif may mean change in hh_len. */
 	hh_len = skb_dst(skb)->dev->hard_header_len;
 	if (skb_headroom(skb) < hh_len &&
-	    pskb_expand_head(skb, hh_len - skb_headroom(skb), 0, GFP_ATOMIC))
+	    pskb_expand_head(skb, HH_DATA_ALIGN(hh_len - skb_headroom(skb)),
+				0, GFP_ATOMIC))
 		return -1;
 
 	return 0;
-- 
1.7.2.5

