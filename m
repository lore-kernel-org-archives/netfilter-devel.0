From: Cedric de Launois <delaunois@info.ucl.ac.be>
Subject: [PATCH] Critical bug fix in ROUTE target
Date: 28 Feb 2003 10:49:10 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1046425749.28135.56.camel@descartes.info.ucl.ac.be>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-E/WqO7KIF1TxUMUstwDI"
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


--=-E/WqO7KIF1TxUMUstwDI
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by info.ucl.ac.be id KAA20362

Here is a patch fixing a critical bug in the ROUTE target, in
the --gw option. A packet was released twice when the target
failed to route it.

Patch against the current cvs tree.

Question for Harald : when do you intend to release a new version
of iptables ? Because iptables-1.2.7a does not support the ROUTE
target contained in the latest pom, and people are complaining to
me :( , and the daily snapshot for iptables is not working for several
month now...

C=E9dric


--=-E/WqO7KIF1TxUMUstwDI
Content-Disposition: attachment; filename=ROUTE.cvs.patch
Content-Type: text/x-patch; name=ROUTE.cvs.patch; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

diff -Nru netfilter.orig/patch-o-matic/extra/ROUTE.patch netfilter/patch-o-matic/extra/ROUTE.patch
--- netfilter.orig/patch-o-matic/extra/ROUTE.patch	Wed Jan  8 10:51:34 2003
+++ netfilter/patch-o-matic/extra/ROUTE.patch	Fri Feb 28 10:14:10 2003
@@ -22,14 +22,16 @@
 +#endif /*_IPT_ROUTE_H_target*/
 diff -Nru linux.orig/net/ipv4/netfilter/ipt_ROUTE.c linux/net/ipv4/netfilter/ipt_ROUTE.c
 --- linux.orig/net/ipv4/netfilter/ipt_ROUTE.c	Thu Jan  1 01:00:00 1970
-+++ linux/net/ipv4/netfilter/ipt_ROUTE.c	Wed Dec 18 12:40:26 2002
-@@ -0,0 +1,365 @@
++++ linux/net/ipv4/netfilter/ipt_ROUTE.c	Wed Feb 26 17:25:39 2003
+@@ -0,0 +1,359 @@
 +/*
 + * This implements the ROUTE target, which enables you to setup unusual
 + * routes not supported by the standard kernel routing table.
 + *
 + * Copyright (C) 2002 Cedric de Launois <delaunois@info.ucl.ac.be>
 + *
++ * v 1.6 2003/02/26
++ *
 + * This software is distributed under GNU GPL v2, 1991
 + */
 +
@@ -92,11 +94,14 @@
 +		return -1;
 +	}
 +	
++	/* Drop old route. */
++	dst_release(skb->dst);
++	skb->dst = NULL;
++
 +	/* Success if no oif specified or if the oif correspond to the 
 +	 * one desired */
 +	if (!ifindex || rt->u.dst.dev->ifindex == ifindex) {
 +		/* Drop old route. */
-+		dst_release(skb->dst);
 +		skb->dst = &rt->u.dst;
 +		skb->dev = skb->dst->dev;
 +		return 1;
@@ -104,8 +109,7 @@
 +	
 +	/* The interface selected by the routing table is not the one
 +	 * specified by the user. This may happen because the dst address
-+	 * is one of our own addresses. This module makes it possible to
-+	 * reroute such packets by forcing the device to use.
++	 * is one of our own addresses.
 +	 */
 +	DEBUGP("ipt_ROUTE: failed to route as desired (oif: %i)", 
 +	       rt->u.dst.dev->ifindex);
@@ -118,33 +122,33 @@
 + * PRE : skb->dev is set to the device we are leaving by
 + *       skb->dst is not NULL
 + * POST: the packet is sent with the link layer header pushed
++ *       the packet is destroyed
 + */
-+static inline int ip_direct_send(struct sk_buff *skb)
++static void ip_direct_send(struct sk_buff *skb)
 +{
 +	struct dst_entry *dst = skb->dst;
-+	struct hh_cache *hh;
++	struct hh_cache *hh = dst->hh;
 +
-+	hh = dst->hh;
 +	if (hh) {
 +		read_lock_bh(&hh->hh_lock);
 +		memcpy(skb->data - 16, hh->hh_data, 16);
 +		read_unlock_bh(&hh->hh_lock);
 +		skb_push(skb, hh->hh_len);
-+		return hh->hh_output(skb);
++		hh->hh_output(skb);
 +	} else if (dst->neighbour)
-+		return dst->neighbour->output(skb);
-+
-+	if (net_ratelimit())
-+		DEBUGP(KERN_DEBUG "ipt_ROUTE: no hdr & no neighbour cache!\n");
-+	kfree_skb(skb);
-+	return -EINVAL;
++		dst->neighbour->output(skb);
++	else {
++		if (net_ratelimit())
++			DEBUGP(KERN_DEBUG "ipt_ROUTE: no hdr & no neighbour cache!\n");
++		kfree_skb(skb);
++	}
 +}
 +
 +
 +/* PRE : skb->dev is set to the device we are leaving by
 + * POST: - the packet is directly sent to the skb->dev device, without 
 + *         pushing the link layer header.
-+ *       - skb has been freed !!
++ *       - the packet is destroyed
 + */
 +static inline int dev_direct_send(struct sk_buff *skb)
 +{
@@ -155,8 +159,9 @@
 +static unsigned int route_oif(const struct ipt_route_target_info *route_info,
 +			      struct sk_buff *skb) 
 +{
-+	struct net_device *dev_out = NULL;
++	int err;
 +	unsigned int ifindex = 0;
++	struct net_device *dev_out = NULL;
 +
 +	/* The user set the interface name to use.
 +	 * Getting the current interface index.
@@ -171,25 +176,25 @@
 +
 +
 +	/* Trying the standard way of routing packets */
-+	if (route(skb, ifindex, route_info)==1) {
++	err = route(skb, ifindex, route_info);
++	if (err==1) {
 +		DEBUGP(KERN_DEBUG "ROUTE oif ok, skb->dev->index=%i\n",
 +		       skb->dev->ifindex);
 +
 +		dev_put(dev_out);
-+		if (ip_direct_send(skb) == -EINVAL) 
-+			return NF_DROP;
-+		else
-+			return NF_STOLEN;
++		ip_direct_send(skb);
++		return NF_STOLEN;
++	}
++
++	if (err) {
++		dev_put(dev_out);
++		return NF_DROP;
 +	}
 +
 +	/* Failed to send to oif. Trying the hard way */
 +
 +	DEBUGP(KERN_DEBUG "HARD ROUTING\n");
 +
-+	/* Drop old route. */
-+	dst_release(skb->dst);
-+	skb->dst = NULL;
-+
 +	/* We have to force the use of an interface.
 +	 * This interface must be a tunnel interface since
 +	 * otherwise we can't guess the hw address for
@@ -203,7 +208,7 @@
 +		return NF_DROP;
 +	}
 +	
-+	/* Send the packet. This will also free skb ! 
++	/* Send the packet. This will also free skb
 +	 * Do not go through the POST_ROUTING hook because 
 +	 * skb->dst is not set and because it will probably
 +	 * get confused by the destination IP address.
@@ -211,7 +216,6 @@
 +	skb->dev = dev_out;
 +	dev_direct_send(skb);
 +	dev_put(dev_out);
-+	
 +	return NF_STOLEN;
 +}
 +
@@ -250,8 +254,7 @@
 +	DEBUGP(KERN_DEBUG "ROUTE gw ok, skb->dev->index=%i\n",
 +	       skb->dev->ifindex);
 +
-+	if (ip_direct_send(skb) == -EINVAL) 
-+		return NF_DROP;
++	ip_direct_send(skb);
 +
 +	return NF_STOLEN;
 +}
@@ -267,21 +270,12 @@
 +	const struct ipt_route_target_info *route_info = targinfo;
 +	struct sk_buff *skb = *pskb;
 +
-+	/* raw socket (tcpdump) may have clone of incoming
-+	 * skb: don't disturb it
-+	 */
-+	if (skb_cloned(skb) && !skb->sk) {
-+		struct sk_buff *nskb = skb_copy(skb, GFP_ATOMIC);
-+		if (!nskb)
-+			return NF_DROP;
-+		kfree_skb(skb);
-+		skb = nskb;
-+	}
-+
-+	/* If we are at PREROUTING hook
++	/* If we are at PREROUTING or INPUT hook
 +	 * the TTL isn't decreased by the IP stack
 +	 */
-+	if (hooknum == NF_IP_PRE_ROUTING) {
++	if (hooknum == NF_IP_PRE_ROUTING ||
++	    hooknum == NF_IP_LOCAL_IN) {
++
 +		struct iphdr *iph = skb->nh.iph;
 +
 +		if (iph->ttl <= 1) {
@@ -322,13 +316,13 @@
 +#endif
 +
 +	if (route_info->oif[0]) 
-+		return route_oif(route_info, skb);
++		return route_oif(route_info, *pskb);
 +	
 +	if (route_info->iif[0]) 
-+		return route_iif(route_info, skb);
++		return route_iif(route_info, *pskb);
 +
 +	if (route_info->gw) 
-+		return route_gw(route_info, skb);
++		return route_gw(route_info, *pskb);
 +
 +	DEBUGP(KERN_DEBUG "ipt_ROUTE: no parameter !\n");
 +	return NF_ACCEPT;

--=-E/WqO7KIF1TxUMUstwDI--
