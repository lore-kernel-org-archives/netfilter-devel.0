From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [PATCH:RFC 1/5] bridge-netfilter: cleanup br_netfilter.c
Date: Tue, 30 Mar 2010 16:15:44 +0200
Message-ID: <4BB20790.6050300@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Stephen Hemminger <shemminger@linux-foundation.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:53197 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab0C3OPp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Mar 2010 10:15:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

bridge-netfilter: cleanup br_netfilter.c

- remove some of the graffiti at the head of br_netfilter.c
- remove __br_dnat_complain()
- remove KERN_INFO messages when CONFIG_NETFILTER_DEBUG is defined

Signed-off-by: Bart De Schuymer <bdschuym@pandora.be>

--- linux-2.6.33/net/bridge/br_netfilter.c	2010-02-24 19:52:17.000000000 +0100
+++ linux-2.6.33-uml/net/bridge/br_netfilter.c	2010-03-30 11:29:51.000000000 +0200
@@ -3,15 +3,8 @@
  *	Linux ethernet bridge
  *
  *	Authors:
- *	Lennert Buytenhek               <buytenh@gnu.org>
- *	Bart De Schuymer (maintainer)	<bdschuym@pandora.be>
- *
- *	Changes:
- *	Apr 29 2003: physdev module support (bdschuym)
- *	Jun 19 2003: let arptables see bridged ARP traffic (bdschuym)
- *	Oct 06 2003: filter encapsulated IP/ARP VLAN traffic on untagged bridge
- *	             (bdschuym)
- *	Sep 01 2004: add IPv6 filtering (bdschuym)
+ *	Lennert Buytenhek		<buytenh@gnu.org>
+ *	Bart De Schuymer		<bdschuym@pandora.be>
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -252,17 +245,6 @@ static int br_nf_pre_routing_finish_ipv6
 	return 0;
 }
 
-static void __br_dnat_complain(void)
-{
-	static unsigned long last_complaint;
-
-	if (jiffies - last_complaint >= 5 * HZ) {
-		printk(KERN_WARNING "Performing cross-bridge DNAT requires IP "
-		       "forwarding to be enabled\n");
-		last_complaint = jiffies;
-	}
-}
-
 /* This requires some explaining. If DNAT has taken place,
  * we will need to fix up the destination Ethernet address,
  * and this is a tricky process.
@@ -378,11 +360,6 @@ static int br_nf_pre_routing_finish(stru
 					skb_dst_set(skb, (struct dst_entry *)rt);
 					goto bridged_dnat;
 				}
-				/* we are sure that forwarding is disabled, so printing
-				 * this message is no problem. Note that the packet could
-				 * still have a martian destination address, in which case
-				 * the packet could be dropped even if forwarding were enabled */
-				__br_dnat_complain();
 				dst_release((struct dst_entry *)rt);
 			}
 free_skb:
@@ -819,17 +796,6 @@ static unsigned int br_nf_post_routing(u
 	struct net_device *realoutdev = bridge_parent(skb->dev);
 	u_int8_t pf;
 
-#ifdef CONFIG_NETFILTER_DEBUG
-	/* Be very paranoid. This probably won't happen anymore, but let's
-	 * keep the check just to be sure... */
-	if (skb_mac_header(skb) < skb->head ||
-	    skb_mac_header(skb) + ETH_HLEN > skb->data) {
-		printk(KERN_CRIT "br_netfilter: Argh!! br_nf_post_routing: "
-		       "bad mac.raw pointer.\n");
-		goto print_error;
-	}
-#endif
-
 	if (!nf_bridge)
 		return NF_ACCEPT;
 
@@ -848,13 +814,6 @@ static unsigned int br_nf_post_routing(u
 	else
 		return NF_ACCEPT;
 
-#ifdef CONFIG_NETFILTER_DEBUG
-	if (skb_dst(skb) == NULL) {
-		printk(KERN_INFO "br_netfilter post_routing: skb->dst == NULL\n");
-		goto print_error;
-	}
-#endif
-
 	/* We assume any code from br_dev_queue_push_xmit onwards doesn't care
 	 * about the value of skb->pkt_type. */
 	if (skb->pkt_type == PACKET_OTHERHOST) {
@@ -869,19 +828,6 @@ static unsigned int br_nf_post_routing(u
 		br_nf_dev_queue_xmit);
 
 	return NF_STOLEN;
-
-#ifdef CONFIG_NETFILTER_DEBUG
-print_error:
-	if (skb->dev != NULL) {
-		printk("[%s]", skb->dev->name);
-		if (realoutdev)
-			printk("[%s]", realoutdev->name);
-	}
-	printk(" head:%p, raw:%p, data:%p\n", skb->head, skb_mac_header(skb),
-	       skb->data);
-	dump_stack();
-	return NF_ACCEPT;
-#endif
 }
 
 /* IP/SABOTAGE *****************************************************/


-- 
Bart De Schuymer
www.artinalgorithms.be
