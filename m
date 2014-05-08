From: Sergey Popovich <popovich_sergei@mail.ru>
Subject: [PATCH] netfilter: Fix potential use after free in ip6_route_me_harder()
Date: Thu,  8 May 2014 16:22:35 +0300
Message-ID: <1399555355-7677-1-git-send-email-popovich_sergei@mail.ru>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fallback4.mail.ru ([94.100.176.42]:44816 "EHLO
	fallback4.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbaEHN0u (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 May 2014 09:26:50 -0400
Received: from smtp15.mail.ru (smtp15.mail.ru [94.100.176.133])
	by fallback4.mail.ru (mPOP.Fallback_MX) with ESMTP id 5D62226F603F
	for <netfilter-devel@vger.kernel.org>; Thu,  8 May 2014 17:26:45 +0400 (MSK)
Received: from [195.234.68.4] (port=39322 helo=tuxracer.skif.com.ua)
	by smtp15.mail.ru with esmtpa (envelope-from <popovich_sergei@mail.ru>)
	id 1WiOHY-00011Z-4b
	for netfilter-devel@vger.kernel.org; Thu, 08 May 2014 17:22:40 +0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dst is released one line before we access it again with dst->error.

Fixes: 58e35d147128 netfilter: ipv6: propagate routing errors from
ip6_route_me_harder()

Signed-off-by: Sergey Popovich <popovich_sergei@mail.ru>
---
 net/ipv6/netfilter.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 95f3f1d..d38e6a8 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -30,13 +30,15 @@ int ip6_route_me_harder(struct sk_buff *skb)
 		.daddr = iph->daddr,
 		.saddr = iph->saddr,
 	};
+	int err;
 
 	dst = ip6_route_output(net, skb->sk, &fl6);
-	if (dst->error) {
+	err = dst->error;
+	if (err) {
 		IP6_INC_STATS(net, ip6_dst_idev(dst), IPSTATS_MIB_OUTNOROUTES);
 		LIMIT_NETDEBUG(KERN_DEBUG "ip6_route_me_harder: No more route.\n");
 		dst_release(dst);
-		return dst->error;
+		return err;
 	}
 
 	/* Drop old route. */
-- 
1.8.3.4

