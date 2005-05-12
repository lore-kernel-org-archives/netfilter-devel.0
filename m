From: Max Kellermann <max@duempel.org>
Subject: [PATCH pom-ng] port TARPIT to linux 2.6.12
Date: Thu, 12 May 2005 20:20:24 +0200
Message-ID: <20050512182024.GA23331@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="opJtzjQTFsWo+cga"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

the following two mini patches port the TARPIT target to linux
2.6.12.

tarpit-01-fix_indent.patch
- fix the indentation in the source file (tabs)

tarpit-02-linux_2_6_12_api.patch
- call dst_mtu() instead of dst_pmtu() on 2.6.12 (conditional)


Max

--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="tarpit-01-fix_indent.patch"

Thu May 12 20:17:45 CEST 2005  max@duempel.org
  * fixed indent
diff -rN -u old-tarpit-0/TARPIT/linux-2.6/net/ipv4/netfilter/ipt_TARPIT.c new-tarpit-0/TARPIT/linux-2.6/net/ipv4/netfilter/ipt_TARPIT.c
--- old-tarpit-0/TARPIT/linux-2.6/net/ipv4/netfilter/ipt_TARPIT.c	2005-05-12 20:19:09.000000000 +0200
+++ new-tarpit-0/TARPIT/linux-2.6/net/ipv4/netfilter/ipt_TARPIT.c	2005-05-12 20:19:09.000000000 +0200
@@ -1,12 +1,12 @@
-/* 
- * Kernel module to capture and hold incoming TCP connections using 
+/*
+ * Kernel module to capture and hold incoming TCP connections using
  * no local per-connection resources.
- * 
- * Based on ipt_REJECT.c and offering functionality similar to 
+ *
+ * Based on ipt_REJECT.c and offering functionality similar to
  * LaBrea <http://www.hackbusters.net/LaBrea/>.
- * 
+ *
  * Copyright (c) 2002 Aaron Hopkins <tools@die.net>
- * 
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
@@ -20,13 +20,13 @@
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- * 
+ *
  * Goal:
  * - Allow incoming TCP connections to be established.
- * - Passing data should result in the connection being switched to the 
- *   persist state (0 byte window), in which the remote side stops sending 
+ * - Passing data should result in the connection being switched to the
+ *   persist state (0 byte window), in which the remote side stops sending
  *   data and asks to continue every 60 seconds.
- * - Attempts to shut down the connection should be ignored completely, so 
+ * - Attempts to shut down the connection should be ignored completely, so
  *   the remote side ends up having to time it out.
  *
  * This means:
@@ -62,19 +62,19 @@
 	struct dst_entry *dst = skb->dst;
 	struct hh_cache *hh = dst->hh;
 
-	if (hh) {    
+	if (hh) {
 		read_lock_bh(&hh->hh_lock);
 		memcpy(skb->data - 16, hh->hh_data, 16);
-                read_unlock_bh(&hh->hh_lock);
-                skb_push(skb, hh->hh_len);
-                return hh->hh_output(skb);
-        } else if (dst->neighbour)
-                return dst->neighbour->output(skb);
+		read_unlock_bh(&hh->hh_lock);
+		skb_push(skb, hh->hh_len);
+		return hh->hh_output(skb);
+	} else if (dst->neighbour)
+		return dst->neighbour->output(skb);
 
 	if (net_ratelimit())
 		printk(KERN_DEBUG "TARPIT ip_direct_send: no header cache and no neighbor!\n");
-        kfree_skb(skb);
-        return -EINVAL;
+	kfree_skb(skb);
+	return -EINVAL;
 }
 
 
@@ -92,8 +92,8 @@
 	if (oskb->len < (oskb->nh.iph->ihl*4) + sizeof(struct tcphdr))
 		return;
 
-	otcph = (struct tcphdr *)((u_int32_t*)oskb->nh.iph 
-                                  + oskb->nh.iph->ihl);
+	otcph = (struct tcphdr *)((u_int32_t*)oskb->nh.iph
+				  + oskb->nh.iph->ihl);
 	otcplen = oskb->len - oskb->nh.iph->ihl*4;
 
 	/* No replies for RST or FIN */
@@ -139,11 +139,11 @@
 	ntcph->dest = tmp;
 
 	/* Use supplied sequence number or make a new one */
-	ntcph->seq = otcph->ack ? otcph->ack_seq 
-                     : htonl(secure_tcp_sequence_number(nskb->nh.iph->saddr, 
-						        nskb->nh.iph->daddr, 
-						        ntcph->source, 
-			     			        ntcph->dest));
+	ntcph->seq = otcph->ack ? otcph->ack_seq
+		: htonl(secure_tcp_sequence_number(nskb->nh.iph->saddr,
+						   nskb->nh.iph->daddr,
+						   ntcph->source,
+						   ntcph->dest));
 
 	/* Our SYN-ACKs must have a >0 window */
 	ntcph->window = (otcph->syn && !otcph->ack) ? htons(5) : 0;
@@ -179,7 +179,7 @@
 
 	/* Adjust IP checksum */
 	nskb->nh.iph->check = 0;
-	nskb->nh.iph->check = ip_fast_csum((unsigned char *)nskb->nh.iph, 
+	nskb->nh.iph->check = ip_fast_csum((unsigned char *)nskb->nh.iph,
 					   nskb->nh.iph->ihl);
 
 	fl.nl_u.ip4_u.daddr = nskb->nh.iph->daddr;
@@ -220,22 +220,22 @@
 	if (!rt)
 		return NF_DROP;
 
-        /* No replies to physical multicast/broadcast */
-        if (skb->pkt_type != PACKET_HOST && skb->pkt_type != PACKET_OTHERHOST)
-     		return NF_DROP;
+	/* No replies to physical multicast/broadcast */
+	if (skb->pkt_type != PACKET_HOST && skb->pkt_type != PACKET_OTHERHOST)
+		return NF_DROP;
 
-        /* Now check at the protocol level */
+	/* Now check at the protocol level */
 	if (rt->rt_flags&(RTCF_BROADCAST|RTCF_MULTICAST))
-                return NF_DROP;
+		return NF_DROP;
 
 	/* Our naive response construction doesn't deal with IP
            options, and probably shouldn't try. */
 	if (skb->nh.iph->ihl*4 != sizeof(struct iphdr))
 		return NF_DROP;
 
-        /* We aren't interested in fragments */
+	/* We aren't interested in fragments */
 	if (skb->nh.iph->frag_off & htons(IP_OFFSET))
-                return NF_DROP;
+		return NF_DROP;
 
 	tarpit_tcp(skb,rt,hooknum == NF_IP_LOCAL_IN);
 
@@ -254,8 +254,8 @@
 		DEBUGP("TARPIT: bad table %s'.\n", tablename);
 		return 0;
 	}
-	if ((hook_mask & ~((1 << NF_IP_LOCAL_IN) 
-                           | (1 << NF_IP_FORWARD))) != 0) {
+	if ((hook_mask & ~((1 << NF_IP_LOCAL_IN)
+			   | (1 << NF_IP_FORWARD))) != 0) {
 		DEBUGP("TARPIT: bad hook mask %X\n", hook_mask);
 		return 0;
 	}
@@ -269,7 +269,7 @@
 	return 1;
 }
 
-static struct ipt_target ipt_tarpit_reg = { 
+static struct ipt_target ipt_tarpit_reg = {
 	.name = "TARPIT",
 	.target = tarpit,
 	.checkentry = check,


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="tarpit-02-linux_2_6_12_api.patch"

Thu May 12 20:18:48 CEST 2005  max@duempel.org
  * support linux 2.6.12
diff -rN -u old-tarpit-0/TARPIT/linux-2.6/net/ipv4/netfilter/ipt_TARPIT.c new-tarpit-0/TARPIT/linux-2.6/net/ipv4/netfilter/ipt_TARPIT.c
--- old-tarpit-0/TARPIT/linux-2.6/net/ipv4/netfilter/ipt_TARPIT.c	2005-05-12 20:19:23.000000000 +0200
+++ new-tarpit-0/TARPIT/linux-2.6/net/ipv4/netfilter/ipt_TARPIT.c	2005-05-12 20:18:23.000000000 +0200
@@ -36,6 +36,7 @@
  */
 
 #include <linux/config.h>
+#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/ip.h>
@@ -194,7 +195,11 @@
 	nskb->dst = &nrt->u.dst;
 
 	/* "Never happens" */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,12)
+	if (nskb->len > dst_mtu(nskb->dst))
+#else
 	if (nskb->len > dst_pmtu(nskb->dst))
+#endif
 		goto free_nskb;
 
 	ip_direct_send (nskb);


--opJtzjQTFsWo+cga--
