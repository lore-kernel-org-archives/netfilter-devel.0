From: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH net-next] netfilter: remove double colon
Date: Wed, 15 Jan 2014 08:12:50 -0800
Message-ID: <20140115081250.56958f9a@nehalam.linuxnetplumber.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:48833 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbaAOQMx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 11:12:53 -0500
Received: by mail-pa0-f54.google.com with SMTP id fa1so1343187pad.27
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Jan 2014 08:12:53 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is C not shell script

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>

--- a/net/ipv4/netfilter.c	2013-12-31 17:45:31.993942921 -0800
+++ b/net/ipv4/netfilter.c	2014-01-15 08:10:49.793785943 -0800
@@ -61,7 +61,7 @@ int ip_route_me_harder(struct sk_buff *s
 		skb_dst_set(skb, NULL);
 		dst = xfrm_lookup(net, dst, flowi4_to_flowi(&fl4), skb->sk, 0);
 		if (IS_ERR(dst))
-			return PTR_ERR(dst);;
+			return PTR_ERR(dst);
 		skb_dst_set(skb, dst);
 	}
 #endif
