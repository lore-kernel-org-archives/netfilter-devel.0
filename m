From: Paul Guo <ggang@tilera.com>
Subject: [PATCH] possible unaligned packet header caused by ip_route_me_harder()->pskb_expand_head()
Date: Mon, 14 Nov 2011 16:33:24 +0800
Message-ID: <4EC0D254.7060503@tilera.com>
References: <4EB9449D.8020701@tilera.com> <1320771494.3444.8.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <4EBA48F3.8040906@tilera.com> <1320832102.2315.10.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <4EBB7E3C.9030402@tilera.com> <20111113170233.GA16851@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from usmamail.tilera.com ([206.83.70.75]:28066 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab1KNIdd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Nov 2011 03:33:33 -0500
In-Reply-To: <20111113170233.GA16851@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> git://1984.lsi.us.es/net/.git

OK. Here is the patch based on above git tree.


Signed-off-by: Paul Guo <ggang@tilera.com>
---
 net/ipv4/netfilter.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index 929b27b..0dcb0fa 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -63,7 +63,8 @@ int ip_route_me_harder(struct sk_buff *skb, unsigned addr_type)
 	/* Change in oif may mean change in hh_len. */
 	hh_len = skb_dst(skb)->dev->hard_header_len;
 	if (skb_headroom(skb) < hh_len &&
-	    pskb_expand_head(skb, hh_len - skb_headroom(skb), 0, GFP_ATOMIC))
+	    pskb_expand_head(skb, HH_DATA_ALIGN(hh_len - skb_headroom(skb)),
+	    		     0, GFP_ATOMIC))
 		return -1;
 
 	return 0;
-- 
1.6.5.2
