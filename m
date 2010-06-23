From: Patrick McHardy <kaber@trash.net>
Subject: netfilter: ipt_LOG/ip6t_LOG: add option to print decoded MAC header
Date: Wed, 23 Jun 2010 18:11:58 +0200
Message-ID: <4C22324E.2060404@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060409020905030808060400"
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44151 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab0FWQMB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jun 2010 12:12:01 -0400
Received: from [IPv6:2001:6f8:974:0:215:f2ff:fe24:91f8] (unknown [IPv6:2001:6f8:974:0:215:f2ff:fe24:91f8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by stinky.trash.net (Postfix) with ESMTPSA id D33E3B2C46
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Jun 2010 18:11:58 +0200 (MEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060409020905030808060400
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit



--------------060409020905030808060400
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

commit 49923434ad6b90532bdea297a1bc70ae048f3450
Author: Patrick McHardy <kaber@trash.net>
Date:   Wed Jun 23 18:10:03 2010 +0200

    netfilter: ipt_LOG/ip6t_LOG: add option to print decoded MAC header
    
    The LOG targets print the entire MAC header as one long string, which is not
    readable very well:
    
    IN=eth0 OUT= MAC=00:15:f2:24:91:f8:00:1b:24:dc:61:e6:08:00 ...
    
    Add an option to decode known header formats (currently just ARPHRD_ETHER devices)
    in their individual fields:
    
    IN=eth0 OUT= MACSRC=00:1b:24:dc:61:e6 MACDST=00:15:f2:24:91:f8 MACPROTO=0800 ...
    IN=eth0 OUT= MACSRC=00:1b:24:dc:61:e6 MACDST=00:15:f2:24:91:f8 MACPROTO=86dd ...
    
    The option needs to be explicitly enabled by userspace to avoid breaking
    existing parsers.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/linux/netfilter_ipv4/ipt_LOG.h b/include/linux/netfilter_ipv4/ipt_LOG.h
index 90fa652..dcdbadf 100644
--- a/include/linux/netfilter_ipv4/ipt_LOG.h
+++ b/include/linux/netfilter_ipv4/ipt_LOG.h
@@ -7,7 +7,8 @@
 #define IPT_LOG_IPOPT		0x04	/* Log IP options */
 #define IPT_LOG_UID		0x08	/* Log UID owning local socket */
 #define IPT_LOG_NFLOG		0x10	/* Unsupported, don't reuse */
-#define IPT_LOG_MASK		0x1f
+#define IPT_LOG_MACDECODE	0x20	/* Decode MAC header */
+#define IPT_LOG_MASK		0x2f
 
 struct ipt_log_info {
 	unsigned char level;
diff --git a/include/linux/netfilter_ipv6/ip6t_LOG.h b/include/linux/netfilter_ipv6/ip6t_LOG.h
index 0d0119b..9dd5579 100644
--- a/include/linux/netfilter_ipv6/ip6t_LOG.h
+++ b/include/linux/netfilter_ipv6/ip6t_LOG.h
@@ -7,7 +7,8 @@
 #define IP6T_LOG_IPOPT		0x04	/* Log IP options */
 #define IP6T_LOG_UID		0x08	/* Log UID owning local socket */
 #define IP6T_LOG_NFLOG		0x10	/* Unsupported, don't use */
-#define IP6T_LOG_MASK		0x1f
+#define IP6T_LOG_MACDECODE	0x20	/* Decode MAC header */
+#define IP6T_LOG_MASK		0x2f
 
 struct ip6t_log_info {
 	unsigned char level;
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index 5234f4f..778771f 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/skbuff.h>
+#include <linux/if_arp.h>
 #include <linux/ip.h>
 #include <net/icmp.h>
 #include <net/udp.h>
@@ -363,6 +364,42 @@ static void dump_packet(const struct nf_loginfo *info,
 	/* maxlen = 230+   91  + 230 + 252 = 803 */
 }
 
+static void dump_mac_header(const struct nf_loginfo *info,
+			    const struct sk_buff *skb)
+{
+	struct net_device *dev = skb->dev;
+	unsigned int logflags = 0;
+
+	if (info->type == NF_LOG_TYPE_LOG)
+		logflags = info->u.log.logflags;
+
+	if (!(logflags & IPT_LOG_MACDECODE))
+		goto fallback;
+
+	switch (dev->type) {
+	case ARPHRD_ETHER:
+		printk("MACSRC=%pM MACDST=%pM MACPROTO=%.4x ",
+		       eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest,
+		       ntohs(eth_hdr(skb)->h_proto));
+		return;
+	default:
+		break;
+	}
+
+fallback:
+	printk("MAC=");
+	if (dev->hard_header_len &&
+	    skb->mac_header != skb->network_header) {
+		const unsigned char *p = skb_mac_header(skb);
+		unsigned int i;
+
+		for (i = 0; i < dev->hard_header_len; i++, p++)
+			printk("%02x%c", *p,
+			       i == dev->hard_header_len - 1 ? ' ' : ':');
+	} else
+		printk(" ");
+}
+
 static struct nf_loginfo default_loginfo = {
 	.type	= NF_LOG_TYPE_LOG,
 	.u = {
@@ -404,20 +441,9 @@ ipt_log_packet(u_int8_t pf,
 	}
 #endif
 
-	if (in && !out) {
-		/* MAC logging for input chain only. */
-		printk("MAC=");
-		if (skb->dev && skb->dev->hard_header_len &&
-		    skb->mac_header != skb->network_header) {
-			int i;
-			const unsigned char *p = skb_mac_header(skb);
-			for (i = 0; i < skb->dev->hard_header_len; i++,p++)
-				printk("%02x%c", *p,
-				       i==skb->dev->hard_header_len - 1
-				       ? ' ':':');
-		} else
-			printk(" ");
-	}
+	/* MAC logging for input chain only. */
+	if (in && !out)
+		dump_mac_header(loginfo, skb);
 
 	dump_packet(loginfo, skb, 0);
 	printk("\n");
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index af4ee11..8fd1d68 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -373,6 +373,55 @@ static void dump_packet(const struct nf_loginfo *info,
 		printk("MARK=0x%x ", skb->mark);
 }
 
+static void dump_mac_header(const struct nf_loginfo *info,
+			    const struct sk_buff *skb)
+{
+	struct net_device *dev = skb->dev;
+	unsigned int logflags = 0;
+
+	if (info->type == NF_LOG_TYPE_LOG)
+		logflags = info->u.log.logflags;
+
+	if (!(logflags & IP6T_LOG_MACDECODE))
+		goto fallback;
+
+	switch (dev->type) {
+	case ARPHRD_ETHER:
+		printk("MACSRC=%pM MACDST=%pM MACPROTO=%.4x ",
+		       eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest,
+		       ntohs(eth_hdr(skb)->h_proto));
+		return;
+	default:
+		break;
+	}
+
+fallback:
+	printk("MAC=");
+	if (dev->hard_header_len &&
+	    skb->mac_header != skb->network_header) {
+		const unsigned char *p = skb_mac_header(skb);
+		unsigned int len = dev->hard_header_len;
+		unsigned int i;
+
+		if (dev->type == ARPHRD_SIT &&
+		    (p -= ETH_HLEN) < skb->head)
+			p = NULL;
+
+		if (p != NULL) {
+			for (i = 0; i < len; i++)
+				printk("%02x%s", p[i], i == len - 1 ? "" : ":");
+		}
+		printk(" ");
+
+		if (dev->type == ARPHRD_SIT) {
+			const struct iphdr *iph =
+				(struct iphdr *)skb_mac_header(skb);
+			printk("TUNNEL=%pI4->%pI4 ", &iph->saddr, &iph->daddr);
+		}
+	} else
+		printk(" ");
+}
+
 static struct nf_loginfo default_loginfo = {
 	.type	= NF_LOG_TYPE_LOG,
 	.u = {
@@ -400,35 +449,10 @@ ip6t_log_packet(u_int8_t pf,
 		prefix,
 		in ? in->name : "",
 		out ? out->name : "");
-	if (in && !out) {
-		unsigned int len;
-		/* MAC logging for input chain only. */
-		printk("MAC=");
-		if (skb->dev && (len = skb->dev->hard_header_len) &&
-		    skb->mac_header != skb->network_header) {
-			const unsigned char *p = skb_mac_header(skb);
-			int i;
-
-			if (skb->dev->type == ARPHRD_SIT &&
-			    (p -= ETH_HLEN) < skb->head)
-				p = NULL;
-
-			if (p != NULL) {
-				for (i = 0; i < len; i++)
-					printk("%02x%s", p[i],
-					       i == len - 1 ? "" : ":");
-			}
-			printk(" ");
 
-			if (skb->dev->type == ARPHRD_SIT) {
-				const struct iphdr *iph =
-					(struct iphdr *)skb_mac_header(skb);
-				printk("TUNNEL=%pI4->%pI4 ",
-				       &iph->saddr, &iph->daddr);
-			}
-		} else
-			printk(" ");
-	}
+	/* MAC logging for input chain only. */
+	if (in && !out)
+		dump_mac_header(loginfo, skb);
 
 	dump_packet(loginfo, skb, skb_network_offset(skb), 1);
 	printk("\n");

--------------060409020905030808060400--
