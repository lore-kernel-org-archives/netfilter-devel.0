From: Philip Craig <philipc@snapgear.com>
Subject: [PATCH] support --physdev-out for routed packets
Date: Thu, 12 Jul 2007 16:40:56 +1000
Message-ID: <4695CCF8.1010202@snapgear.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090003090406030905020804"
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------090003090406030905020804
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

My most common use of bridging is a transparent firewall between
the LAN and the WAN.  This requires the ability to filter based on
the outgoing port, which the current physdev match supports.

However, I often also terminate VPN connections on this firewall,
and I want to filter/NAT packets arriving over the VPN based on the
outgoing port, which is no longer possible with the physdev match.

A similar situation is a bridged WAN and DMZ, and non-bridged LAN,
and again I want to filter/NAT packets from the LAN based on the
outgoing port.

So here is an ugly, inefficient, flawed, and barely tested patch
which lets me do this.  I have no expectation of this being suitable
for mainline kernels, but maybe someone else is interested in it or
wants to comment on the approach.

The patch digs into the bridge internals too much, causes an extra
bridge fdb lookup, ignores some const attributes, and probably has
broken locking.  And if there are no ARP or bridge fdb entries, then
it doesn't match any ports.

On the other hand, the modifications are quite self contained and
only have an effect if you try to use --physdev-out without
--physdev-is-bridged.

--------------090003090406030905020804
Content-Type: text/x-diff;
 name="xt_physdev_out.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xt_physdev_out.patch"

Allow use of --physdev-out for routed packets by querying the bridge fdb.

Signed-off-by: Philip Craig <philipc@snapgear.com>

--- linux-2.6.x/net/netfilter/xt_physdev.c	26 Apr 2007 11:17:49 -0000	1.1.1.6
+++ linux-2.6.x/net/netfilter/xt_physdev.c	12 Jul 2007 06:09:19 -0000
@@ -14,6 +14,10 @@
 #include <linux/netfilter/xt_physdev.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_bridge.h>
+#include <linux/etherdevice.h>
+#include <net/dst.h>
+#include <net/neighbour.h>
+#include "../bridge/br_private.h"
 #define MATCH   1
 #define NOMATCH 0
 
@@ -23,6 +27,42 @@ MODULE_DESCRIPTION("iptables bridge phys
 MODULE_ALIAS("ipt_physdev");
 MODULE_ALIAS("ip6t_physdev");
 
+static inline struct nf_bridge_info *nf_bridge_alloc(struct sk_buff *skb)
+{
+	skb->nf_bridge = kzalloc(sizeof(struct nf_bridge_info), GFP_ATOMIC);
+	if (likely(skb->nf_bridge))
+		atomic_set(&(skb->nf_bridge->use), 1);
+
+	return skb->nf_bridge;
+}
+
+static void get_outdev(const struct sk_buff* skb, const struct net_device *out)
+{
+	struct neighbour *neigh;
+	struct nf_bridge_info *nf_bridge;
+	const unsigned char *dest;
+	struct net_bridge_fdb_entry *fdb;
+
+	nf_bridge = skb->nf_bridge;
+	if ((nf_bridge && nf_bridge->physoutdev) ||
+	    !out || out->hard_start_xmit != br_dev_xmit || !br_fdb_get_hook)
+		return;
+
+	if (!nf_bridge && !(nf_bridge = nf_bridge_alloc(skb)))
+		return;
+	nf_bridge->physoutdev = out; /* so that --physdev-is-out matches */
+
+	neigh = skb->dst->neighbour;
+	if (!neigh || neigh_event_send(neigh, NULL))
+		return;
+	dest = neigh->ha;
+	if (!is_multicast_ether_addr(dest) &&
+	    (fdb = br_fdb_get_hook(netdev_priv(out), dest)) != NULL) {
+		nf_bridge->physoutdev = fdb->dst->dev;
+		br_fdb_put_hook(fdb);
+	}
+}
+
 static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
@@ -51,16 +91,10 @@ match(const struct sk_buff *skb,
 		if ((info->bitmask & XT_PHYSDEV_OP_ISIN) &&
 		    !(info->invert & XT_PHYSDEV_OP_ISIN))
 			return NOMATCH;
-		if ((info->bitmask & XT_PHYSDEV_OP_ISOUT) &&
-		    !(info->invert & XT_PHYSDEV_OP_ISOUT))
-			return NOMATCH;
 		if ((info->bitmask & XT_PHYSDEV_OP_IN) &&
 		    !(info->invert & XT_PHYSDEV_OP_IN))
 			return NOMATCH;
-		if ((info->bitmask & XT_PHYSDEV_OP_OUT) &&
-		    !(info->invert & XT_PHYSDEV_OP_OUT))
-			return NOMATCH;
-		return MATCH;
+		goto match_outdev;
 	}
 
 	/* This only makes sense in the FORWARD and POSTROUTING chains */
@@ -69,10 +103,8 @@ match(const struct sk_buff *skb,
 	    !(info->invert & XT_PHYSDEV_OP_BRIDGED)))
 		return NOMATCH;
 
-	if ((info->bitmask & XT_PHYSDEV_OP_ISIN &&
-	    (!nf_bridge->physindev ^ !!(info->invert & XT_PHYSDEV_OP_ISIN))) ||
-	    (info->bitmask & XT_PHYSDEV_OP_ISOUT &&
-	    (!nf_bridge->physoutdev ^ !!(info->invert & XT_PHYSDEV_OP_ISOUT))))
+	if (info->bitmask & XT_PHYSDEV_OP_ISIN &&
+	    (!nf_bridge->physindev ^ !!(info->invert & XT_PHYSDEV_OP_ISIN)))
 		return NOMATCH;
 
 	if (!(info->bitmask & XT_PHYSDEV_OP_IN))
@@ -88,8 +120,26 @@ match(const struct sk_buff *skb,
 		return NOMATCH;
 
 match_outdev:
-	if (!(info->bitmask & XT_PHYSDEV_OP_OUT))
+	if (!(info->bitmask & (XT_PHYSDEV_OP_ISOUT | XT_PHYSDEV_OP_OUT)))
+		return MATCH;
+	get_outdev(skb, out);
+	if (!(nf_bridge = skb->nf_bridge)) {
+		if ((info->bitmask & XT_PHYSDEV_OP_ISOUT) &&
+		    !(info->invert & XT_PHYSDEV_OP_ISOUT))
+			return NOMATCH;
+		if ((info->bitmask & XT_PHYSDEV_OP_OUT) &&
+		    !(info->invert & XT_PHYSDEV_OP_OUT))
+			return NOMATCH;
 		return MATCH;
+	}
+
+	if (info->bitmask & XT_PHYSDEV_OP_ISOUT &&
+	    (!nf_bridge->physoutdev ^ !!(info->invert & XT_PHYSDEV_OP_ISOUT)))
+		return NOMATCH;
+
+	if (!(info->bitmask & XT_PHYSDEV_OP_IN))
+		return MATCH;
+		goto match_outdev;
 	outdev = nf_bridge->physoutdev ?
 		 nf_bridge->physoutdev->name : nulldevname;
 	for (i = 0, ret = 0; i < IFNAMSIZ/sizeof(unsigned int); i++) {
@@ -113,17 +163,6 @@ checkentry(const char *tablename,
 	if (!(info->bitmask & XT_PHYSDEV_OP_MASK) ||
 	    info->bitmask & ~XT_PHYSDEV_OP_MASK)
 		return 0;
-	if (info->bitmask & XT_PHYSDEV_OP_OUT &&
-	    (!(info->bitmask & XT_PHYSDEV_OP_BRIDGED) ||
-	     info->invert & XT_PHYSDEV_OP_BRIDGED) &&
-	    hook_mask & ((1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_FORWARD) |
-			 (1 << NF_IP_POST_ROUTING))) {
-		printk(KERN_WARNING "physdev match: using --physdev-out in the "
-		       "OUTPUT, FORWARD and POSTROUTING chains for non-bridged "
-		       "traffic is not supported anymore.\n");
-		if (hook_mask & (1 << NF_IP_LOCAL_OUT))
-			return 0;
-	}
 	return 1;
 }
 

--------------090003090406030905020804--
