From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/2] netfilter: ipt_LOG/ip6t_LOG: remove comparison within
 loop
Date: Fri, 25 Jun 2010 13:39:07 +0200
Message-ID: <4C24955B.2000109@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090209050301030200060505"
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56435 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab0FYLjJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jun 2010 07:39:09 -0400
Received: from [IPv6:2001:6f8:974:0:21b:21ff:fe04:7b28] (unknown [IPv6:2001:6f8:974:0:21b:21ff:fe04:7b28])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by stinky.trash.net (Postfix) with ESMTPSA id DF1DDB2C49
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Jun 2010 13:39:07 +0200 (MEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090209050301030200060505
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Updated patchset incorporating Jan's suggestions.



--------------090209050301030200060505
Content-Type: text/x-diff;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

commit bc4836711abb7695375acc9ade379c730a87684e
Author: Patrick McHardy <kaber@trash.net>
Date:   Fri Jun 25 13:20:23 2010 +0200

    netfilter: ipt_LOG/ip6t_LOG: remove comparison within loop
    
    Remove the comparison within the loop to print the macheader by prepending
    the colon to all but the first printk.
    
    Based on suggestion by Jan Engelhardt <jengelh@medozas.de>.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index 5234f4f..0a452a5 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -411,12 +411,12 @@ ipt_log_packet(u_int8_t pf,
 		    skb->mac_header != skb->network_header) {
 			int i;
 			const unsigned char *p = skb_mac_header(skb);
-			for (i = 0; i < skb->dev->hard_header_len; i++,p++)
-				printk("%02x%c", *p,
-				       i==skb->dev->hard_header_len - 1
-				       ? ' ':':');
-		} else
-			printk(" ");
+
+			printk("%02x", *p++);
+			for (i = 1; i < skb->dev->hard_header_len; i++, p++)
+				printk(":%02x", *p);
+		}
+		printk(" ");
 	}
 
 	dump_packet(loginfo, skb, 0);
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index af4ee11..4c7ddac 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -414,9 +414,9 @@ ip6t_log_packet(u_int8_t pf,
 				p = NULL;
 
 			if (p != NULL) {
-				for (i = 0; i < len; i++)
-					printk("%02x%s", p[i],
-					       i == len - 1 ? "" : ":");
+				printk("%02x", *p++);
+				for (i = 1; i < len; i++)
+					printk(":%02x", p[i]);
 			}
 			printk(" ");
 

--------------090209050301030200060505--
