From: Cedric de Launois <delaunois@info.ucl.ac.be>
Subject: [PATCH] ROUTE target with ARP lookups
Date: 24 Mar 2003 16:33:15 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1048519994.27352.149.camel@descartes.info.ucl.ac.be>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-Vdqu7vo1gihTQTOnxjdu"
Cc: John Duke <johnyduke@yahoo.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-Vdqu7vo1gihTQTOnxjdu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by info.ucl.ac.be id h2OFWT0f028917

Here is a patch for the --oif option of the ROUTE target.
When sending to a destination through an interface, the target
now performs ARP cache lookup & ARP request (excepted if the
device is a tunnel). This should now enable "Transparent broadband
network connectivity (IP PnP)" as John said.

The patch is against the current CVS tree.

C=E9dric


--=-Vdqu7vo1gihTQTOnxjdu
Content-Disposition: attachment; filename=ROUTE.cvs.patch
Content-Type: text/x-patch; name=ROUTE.cvs.patch; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

diff -Nru netfilter.orig/patch-o-matic/extra/ROUTE.patch netfilter/patch-o-matic/extra/ROUTE.patch
--- netfilter.orig/patch-o-matic/extra/ROUTE.patch	2003-03-02 11:05:08.000000000 +0100
+++ netfilter/patch-o-matic/extra/ROUTE.patch	2003-03-24 16:26:25.000000000 +0100
@@ -1,6 +1,6 @@
 diff -Nru linux.orig/include/linux/netfilter_ipv4/ipt_ROUTE.h linux/include/linux/netfilter_ipv4/ipt_ROUTE.h
---- linux.orig/include/linux/netfilter_ipv4/ipt_ROUTE.h	Thu Jan  1 01:00:00 1970
-+++ linux/include/linux/netfilter_ipv4/ipt_ROUTE.h	Tue Dec 17 16:49:04 2002
+--- linux.orig/include/linux/netfilter_ipv4/ipt_ROUTE.h	1970-01-01 01:00:00.000000000 +0100
++++ linux/include/linux/netfilter_ipv4/ipt_ROUTE.h	2002-12-17 16:49:04.000000000 +0100
 @@ -0,0 +1,18 @@
 +/* Header file for iptables ipt_ROUTE target
 + *
@@ -21,16 +21,16 @@
 +
 +#endif /*_IPT_ROUTE_H_target*/
 diff -Nru linux.orig/net/ipv4/netfilter/ipt_ROUTE.c linux/net/ipv4/netfilter/ipt_ROUTE.c
---- linux.orig/net/ipv4/netfilter/ipt_ROUTE.c	Thu Jan  1 01:00:00 1970
-+++ linux/net/ipv4/netfilter/ipt_ROUTE.c	Wed Feb 26 17:25:39 2003
-@@ -0,0 +1,359 @@
+--- linux.orig/net/ipv4/netfilter/ipt_ROUTE.c	1970-01-01 01:00:00.000000000 +0100
++++ linux/net/ipv4/netfilter/ipt_ROUTE.c	2003-03-24 16:25:00.000000000 +0100
+@@ -0,0 +1,352 @@
 +/*
 + * This implements the ROUTE target, which enables you to setup unusual
 + * routes not supported by the standard kernel routing table.
 + *
 + * Copyright (C) 2002 Cedric de Launois <delaunois@info.ucl.ac.be>
 + *
-+ * v 1.6 2003/02/26
++ * v 1.7 2003/03/20
 + *
 + * This software is distributed under GNU GPL v2, 1991
 + */
@@ -42,6 +42,7 @@
 +#include <linux/netfilter_ipv4/ipt_ROUTE.h>
 +#include <linux/netdevice.h>
 +#include <linux/route.h>
++#include <net/neighbour.h>
 +#include <net/ip.h>
 +#include <net/route.h>
 +#include <net/icmp.h>
@@ -53,67 +54,34 @@
 +#endif
 +
 +
-+/* Try to route the packet according to the routing keys specified in
-+ * route_info. Keys are :
-+ *  - ifindex : 
-+ *      0 if no oif prefered, 
-+ *      otherwise set to the index of the desired oif
-+ *  - route_info->gw :
-+ *      0 if no gateway specified,
-+ *      otherwise set to the next host to which the pkt must be routed
-+ * If success, skb->dev is the output device to which the packet must 
-+ * be sent and skb->dst is not NULL
-+ *
-+ * RETURN: -1 if an error occured
-+ *          1 if the packet was succesfully routed to the 
-+ *            destination desired
-+ *          0 if the kernel routing table could not route the packet
-+ *            according to the keys specified
++/* Route a packet according as if its destination address was 'gateway'
++ * POST: skb->dst and skb->dev are set
++ * Returns 0 if success, an error < 0 otherwise
 + */
-+static int route(struct sk_buff *skb,
-+		 unsigned int ifindex,
-+		 const struct ipt_route_target_info *route_info)
++static int route(struct sk_buff *skb, unsigned int gateway)
 +{
 +	int err;
 +	struct rtable *rt;
 +	struct iphdr *iph = skb->nh.iph;
 +	struct rt_key key = { 
-+		dst:iph->daddr,
++		dst:gateway,
 +		src:0,
-+		oif:ifindex, 
++		oif:0,
 +		tos:RT_TOS(iph->tos) 
 +	};
 +	
-+	/* The destination address may be overloaded by the target */
-+	if (route_info->gw)
-+		key.dst = route_info->gw;
-+	
-+	/* Trying to route the packet with the standard routing table. */
-+	if ((err = ip_route_output_key(&rt, &key))) {
-+		DEBUGP("ipt_ROUTE: couldn't route pkt (err: %i)",err);
-+		return -1;
-+	}
-+	
-+	/* Drop old route. */
-+	dst_release(skb->dst);
-+	skb->dst = NULL;
++	/* Route the packet with the standard routing table */
++	err = ip_route_output_key(&rt, &key);
 +
-+	/* Success if no oif specified or if the oif correspond to the 
-+	 * one desired */
-+	if (!ifindex || rt->u.dst.dev->ifindex == ifindex) {
-+		/* Drop old route. */
-+		skb->dst = &rt->u.dst;
-+		skb->dev = skb->dst->dev;
-+		return 1;
++	if (err) {
++		DEBUGP("ipt_ROUTE: couldn't route pkt (err: %i)", err);
++		return err;
 +	}
 +	
-+	/* The interface selected by the routing table is not the one
-+	 * specified by the user. This may happen because the dst address
-+	 * is one of our own addresses.
-+	 */
-+	DEBUGP("ipt_ROUTE: failed to route as desired (oif: %i)", 
-+	       rt->u.dst.dev->ifindex);
-+	
++	/* Drop old route */
++	dst_release(skb->dst);
++	skb->dst = &rt->u.dst;
++	skb->dev = skb->dst->dev;
 +	return 0;
 +}
 +
@@ -145,70 +113,100 @@
 +}
 +
 +
-+/* PRE : skb->dev is set to the device we are leaving by
-+ * POST: - the packet is directly sent to the skb->dev device, without 
-+ *         pushing the link layer header.
-+ *       - the packet is destroyed
++static int arp_lookup(unsigned char *haddr, u32 paddr, struct sk_buff *skb)
++{
++	struct net_device *dev = skb->dev;
++	struct neighbour *n;
++
++	switch (inet_addr_type(paddr)) {
++	case RTN_LOCAL:
++		memcpy(haddr, dev->dev_addr, dev->addr_len);
++		return 0;
++	case RTN_BROADCAST:
++		memcpy(haddr, dev->broadcast, dev->addr_len);
++		return 0;
++	}
++
++	n = __neigh_lookup(&arp_tbl, &paddr, dev, 1);
++	if (n) {
++		n->used = jiffies;
++		if (n->nud_state&NUD_VALID || neigh_event_send(n, skb) == 0) {
++			read_lock_bh(&n->lock);
++ 			memcpy(haddr, n->ha, dev->addr_len);
++			read_unlock_bh(&n->lock);
++			neigh_release(n);
++			return 0;
++		}
++		neigh_release(n);
++	} else 
++		kfree_skb(skb);
++
++	return -1;
++}
++
++
++/* Try to send a packet through the interface skb->dev, without routing it.
++ * PRE : skb->dev must be set
++ * POST: - Builds the ethernet header, looks for the hw dst 
++ *         address in the ARP cache and sends an ARP request if not found.
++ *       - The packet is sent and destroyed
++ * We can't use here the routing table destination cache since this target
++ * aims to force the dev to use, whatever the routing table says.
 + */
-+static inline int dev_direct_send(struct sk_buff *skb)
++static int dev_direct_send(struct sk_buff *skb)
 +{
++	int err;
++	struct ethhdr *eth;
++	struct net_device *dev = skb->dev;
++
++	/* No need to build hw header if the device is a tunnel */
++	if ((dev->type == ARPHRD_TUNNEL)
++	    || (dev->type == ARPHRD_IPGRE)
++	    || (dev->type == ARPHRD_SIT)) {
++		return dev_queue_xmit(skb);
++	}
++
++	__skb_pull(skb, skb->nh.raw - skb->data);
++
++	/* Build ethernet header */
++	if (dev->hard_header)
++		dev->hard_header(skb, dev, ntohs(skb->protocol), NULL, NULL, skb->len);
++	else
++		goto fatal;
++
++	eth = (struct ethhdr *)skb->data;
++	err = arp_lookup(eth->h_dest, skb->nh.iph->daddr, skb);
++	if (err) 
++		return 0;
++
 +	return dev_queue_xmit(skb);
++
++ fatal:
++	DEBUGP(KERN_DEBUG "ipt_ROUTE: can't build hw header\n");
++	kfree_skb(skb);
++	return -1;
 +}
 +
 +
 +static unsigned int route_oif(const struct ipt_route_target_info *route_info,
 +			      struct sk_buff *skb) 
 +{
-+	int err;
 +	unsigned int ifindex = 0;
 +	struct net_device *dev_out = NULL;
 +
 +	/* The user set the interface name to use.
 +	 * Getting the current interface index.
 +	 */
-+	if ((dev_out = dev_get_by_name(route_info->oif)))
++	dev_out = dev_get_by_name(route_info->oif);
++
++	if (dev_out)
 +		ifindex = dev_out->ifindex;
 +	else 
 +		/* Unknown interface name : packet dropped */
 +		return NF_DROP;
-+	
-+	DEBUGP(KERN_DEBUG "oif index of %s is %i\n", route_info->oif, ifindex);
-+
-+
-+	/* Trying the standard way of routing packets */
-+	err = route(skb, ifindex, route_info);
-+	if (err==1) {
-+		DEBUGP(KERN_DEBUG "ROUTE oif ok, skb->dev->index=%i\n",
-+		       skb->dev->ifindex);
-+
-+		dev_put(dev_out);
-+		ip_direct_send(skb);
-+		return NF_STOLEN;
-+	}
 +
-+	if (err) {
-+		dev_put(dev_out);
-+		return NF_DROP;
-+	}
-+
-+	/* Failed to send to oif. Trying the hard way */
-+
-+	DEBUGP(KERN_DEBUG "HARD ROUTING\n");
-+
-+	/* We have to force the use of an interface.
-+	 * This interface must be a tunnel interface since
-+	 * otherwise we can't guess the hw address for
-+	 * the packet. For a tunnel interface, no hw address
-+	 * is needed.
-+	 */
-+	if ((dev_out->type != ARPHRD_TUNNEL)
-+	    && (dev_out->type != ARPHRD_IPGRE)) {
-+		DEBUGP("ipt_ROUTE: can't guess the hw addr !\n");
-+		dev_put(dev_out);
-+		return NF_DROP;
-+	}
 +	
-+	/* Send the packet. This will also free skb
++	/* Sends the packet. This will also free skb
 +	 * Do not go through the POST_ROUTING hook because 
 +	 * skb->dst is not set and because it will probably
 +	 * get confused by the destination IP address.
@@ -233,8 +231,6 @@
 +		/* Unknown interface name : packet dropped */
 +		return NF_DROP;
 +
-+	DEBUGP(KERN_DEBUG "iif index of %s is %i\n", route_info->iif, ifindex);
-+
 +	skb->dev = dev_out;
 +	dst_release(skb->dst);
 +	skb->dst = NULL;
@@ -248,12 +244,9 @@
 +static unsigned int route_gw(const struct ipt_route_target_info *route_info,
 +			     struct sk_buff *skb) 
 +{
-+	if (route(skb, 0, route_info)!=1)
++	if (route(skb, route_info->gw)!=1)
 +		return NF_DROP;
 +
-+	DEBUGP(KERN_DEBUG "ROUTE gw ok, skb->dev->index=%i\n",
-+	       skb->dev->ifindex);
-+
 +	ip_direct_send(skb);
 +
 +	return NF_STOLEN;
@@ -324,7 +317,7 @@
 +	if (route_info->gw) 
 +		return route_gw(route_info, *pskb);
 +
-+	DEBUGP(KERN_DEBUG "ipt_ROUTE: no parameter !\n");
++	printk("ipt_ROUTE: no parameter !\n");
 +	return NF_ACCEPT;
 +}
 +

--=-Vdqu7vo1gihTQTOnxjdu--
