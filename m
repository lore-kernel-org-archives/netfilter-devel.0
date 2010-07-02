From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH nf-next-2.6] netfilter: ipt_REJECT: avoid touching dst ref
Date: Fri, 02 Jul 2010 15:17:49 +0200
Message-ID: <1278076669.2530.33.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54514 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757Ab0GBNRy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Jul 2010 09:17:54 -0400
Received: by fxm14 with SMTP id 14so2347549fxm.19
        for <netfilter-devel@vger.kernel.org>; Fri, 02 Jul 2010 06:17:52 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We can avoid a pair of atomic ops in ipt_REJECT send_reset()

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---

diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index f5f4a88..bbbd273 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -109,7 +109,7 @@ static void send_reset(struct sk_buff *oldskb, int hook)
 		addr_type = RTN_LOCAL;
 
 	/* ip_route_me_harder expects skb->dst to be set */
-	skb_dst_set(nskb, dst_clone(skb_dst(oldskb)));
+	skb_dst_set_noref(nskb, skb_dst(oldskb));
 
 	if (ip_route_me_harder(nskb, addr_type))
 		goto free_nskb;


