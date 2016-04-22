From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH] netfilter: ip6t_SYNPROXY: unnecessary to check whether ip6_route_output returns NULL
Date: Fri, 22 Apr 2016 02:56:57 -0700
Message-ID: <1461319017-3421-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m50-135.163.com ([123.125.50.135]:44320 "EHLO m50-135.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbcDVJ5a (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Apr 2016 05:57:30 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

ip6_route_output() will never return a NULL pointer, so there's no need
to check it.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/ipv6/netfilter/ip6t_SYNPROXY.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter/ip6t_SYNPROXY.c b/net/ipv6/netfilter/ip6t_SYNPROXY.c
index 5d778dd..06bed74 100644
--- a/net/ipv6/netfilter/ip6t_SYNPROXY.c
+++ b/net/ipv6/netfilter/ip6t_SYNPROXY.c
@@ -60,7 +60,7 @@ synproxy_send_tcp(struct net *net,
 	fl6.fl6_dport = nth->dest;
 	security_skb_classify_flow((struct sk_buff *)skb, flowi6_to_flowi(&fl6));
 	dst = ip6_route_output(net, NULL, &fl6);
-	if (dst == NULL || dst->error) {
+	if (dst->error) {
 		dst_release(dst);
 		goto free_nskb;
 	}
-- 
1.7.9.5


