From: Jiri Moravec <jim.lkml@gmail.com>
Subject: xtables-addons example target xt_ECHO was omitted from 2.6.31 skb->dst
 changes
Date: Tue, 21 Jul 2009 19:03:04 +0200
Message-ID: <4A65F4C8.1090106@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-out4.iol.cz ([194.228.2.92]:43586 "EHLO smtp-out4.iol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755532AbZGURcF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jul 2009 13:32:05 -0400
Received: from antivir6.iol.cz (unknown [192.168.30.215])
	by smtp-out4.iol.cz (Postfix) with ESMTP id AF7ECCE4435
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Jul 2009 17:03:16 +0000 (UTC)
Received: from localhost (antivir6.iol.cz [127.0.0.1])
	by antivir6.iol.cz (Postfix) with ESMTP id 987AE720055
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Jul 2009 19:03:16 +0200 (CEST)
Received: from antivir6.iol.cz ([127.0.0.1])
	by localhost (antivir6.iol.cz [127.0.0.1]) (amavisd-new, port 10224)
	with LMTP id GRAYUpoqgffX for <netfilter-devel@vger.kernel.org>;
	Tue, 21 Jul 2009 19:03:16 +0200 (CEST)
Received: from port1.iol.cz (unknown [192.168.30.91])
	by antivir6.iol.cz (Postfix) with ESMTP id 30FAB720059
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Jul 2009 19:03:16 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Probably overlooked in commit fdf42a3a50c9e659c4b9ade5b501ac4c6af589f7.
Have a nice day.

diff -Nupr a/extensions/xt_ECHO.c b/extensions/xt_ECHO.c
--- a/extensions/xt_ECHO.c	2009-07-21 18:22:22.000000000 +0200
+++ b/extensions/xt_ECHO.c	2009-07-21 18:22:22.000000000 +0200
@@ -32,7 +32,7 @@ echo_tg4(struct sk_buff **poldskb, const
 	unsigned int addr_type, data_len;
 	void *payload;
 
-	printk(KERN_INFO "dst_out=%p\n", (*poldskb)->dst->output);
+	printk(KERN_INFO "dst_out=%p\n", skb_dst(*poldskb)->output);
 
 	/* This allows us to do the copy operation in fewer lines of code. */
 	if (skb_linearize(*poldskb) < 0)
@@ -84,18 +84,17 @@ echo_tg4(struct sk_buff **poldskb, const
 #endif
 		addr_type = RTN_LOCAL;
 
-	/* ip_route_me_harder expects skb->dst to be set */
-	dst_hold(oldskb->dst);
-	newskb->dst = oldskb->dst;
+	/* ip_route_me_harder expects skb->_skb_dst to be set */
+	skb_dst_set(newskb, dst_clone(skb_dst(oldskb)));
 
 	if (ip_route_me_harder(&newskb, addr_type) < 0)
 		goto free_nskb;
 
-	newip->ttl        = dst_metric(newskb->dst, RTAX_HOPLIMIT);
+	newip->ttl        = dst_metric(skb_dst(newskb), RTAX_HOPLIMIT);
 	newskb->ip_summed = CHECKSUM_NONE;
 
 	/* "Never happens" (?) */
-	if (newskb->len > dst_mtu(newskb->dst))
+	if (newskb->len > dst_mtu(skb_dst(newskb)))
 		goto free_nskb;
 
 	nf_ct_attach(newskb, *poldskb);


