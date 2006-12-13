From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: bridge-netfilter: remove deferred hooks
Date: Wed, 13 Dec 2006 06:21:01 +0100
Message-ID: <457F8DBD.7050104@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030403090600090801030202"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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
--------------030403090600090801030202
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

This patch removes the bridge netfilter deferred hooks, a bit
earlier than scheduled, but in January we'll probably already
be to late in the release cycle for 2.6.20.

Tested in a purely bridged setup with VLAN and ethernet,
brouter+DNAT setup is untested but should work fine.

Please apply, thanks.


--------------030403090600090801030202
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: bridge-netfilter: remove deferred hooks

Remove the deferred hooks and all related code as scheduled in
feature-removal-schedule.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 68df071a201f06b08cdc07111c6d4af918e64edd
tree c5374b8335712fc3e5eed4513f05b632101c6df3
parent 55cf35800329b56edc1f8f41214942e39de5bef9
author Patrick McHardy <kaber@trash.net> Wed, 13 Dec 2006 06:12:22 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 13 Dec 2006 06:12:22 +0100

 Documentation/feature-removal-schedule.txt |   16 --
 include/linux/netfilter_bridge.h           |    1 
 include/linux/netfilter_ipv4.h             |    2 
 include/linux/netfilter_ipv6.h             |    2 
 net/bridge/br_netfilter.c                  |  188 ++--------------------------
 net/netfilter/xt_physdev.c                 |   12 +-
 6 files changed, 20 insertions(+), 201 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 46f2a55..654d42c 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -227,22 +227,6 @@ Who:	Jean Delvare <khali@linux-fr.org>
 
 ---------------------------
 
-What:	Bridge netfilter deferred IPv4/IPv6 output hook calling
-When:	January 2007
-Why:	The deferred output hooks are a layering violation causing unusual
-	and broken behaviour on bridge devices. Examples of things they
-	break include QoS classifation using the MARK or CLASSIFY targets,
-	the IPsec policy match and connection tracking with VLANs on a
-	bridge. Their only use is to enable bridge output port filtering
-	within iptables with the physdev match, which can also be done by
-	combining iptables and ebtables using netfilter marks. Until it
-	will get removed the hook deferral is disabled by default and is
-	only enabled when needed.
-
-Who:	Patrick McHardy <kaber@trash.net>
-
----------------------------
-
 What:	PHYSDEVPATH, PHYSDEVBUS, PHYSDEVDRIVER in the uevent environment
 When:	October 2008
 Why:	The stacking of class devices makes these values misleading and
diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
index 6c4613f..55689f3 100644
--- a/include/linux/netfilter_bridge.h
+++ b/include/linux/netfilter_bridge.h
@@ -68,7 +68,6 @@ struct bridge_skb_cb {
 	} daddr;
 };
 
-extern int brnf_deferred_hooks;
 #else
 #define nf_bridge_maybe_copy_header(skb)	(0)
 #define nf_bridge_pad(skb)			(0)
diff --git a/include/linux/netfilter_ipv4.h b/include/linux/netfilter_ipv4.h
index 5821eb5..ceae87a 100644
--- a/include/linux/netfilter_ipv4.h
+++ b/include/linux/netfilter_ipv4.h
@@ -57,10 +57,8 @@ enum nf_ip_hook_priorities {
 	NF_IP_PRI_RAW = -300,
 	NF_IP_PRI_SELINUX_FIRST = -225,
 	NF_IP_PRI_CONNTRACK = -200,
-	NF_IP_PRI_BRIDGE_SABOTAGE_FORWARD = -175,
 	NF_IP_PRI_MANGLE = -150,
 	NF_IP_PRI_NAT_DST = -100,
-	NF_IP_PRI_BRIDGE_SABOTAGE_LOCAL_OUT = -50,
 	NF_IP_PRI_FILTER = 0,
 	NF_IP_PRI_NAT_SRC = 100,
 	NF_IP_PRI_SELINUX_LAST = 225,
diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index ab81a6d..66ca8e3 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -62,10 +62,8 @@ enum nf_ip6_hook_priorities {
 	NF_IP6_PRI_CONNTRACK_DEFRAG = -400,
 	NF_IP6_PRI_SELINUX_FIRST = -225,
 	NF_IP6_PRI_CONNTRACK = -200,
-	NF_IP6_PRI_BRIDGE_SABOTAGE_FORWARD = -175,
 	NF_IP6_PRI_MANGLE = -150,
 	NF_IP6_PRI_NAT_DST = -100,
-	NF_IP6_PRI_BRIDGE_SABOTAGE_LOCAL_OUT = -50,
 	NF_IP6_PRI_FILTER = 0,
 	NF_IP6_PRI_NAT_SRC = 100,
 	NF_IP6_PRI_SELINUX_LAST = 225,
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index bd221ad..ea3337a 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -61,9 +61,6 @@ #else
 #define brnf_filter_vlan_tagged 1
 #endif
 
-int brnf_deferred_hooks;
-EXPORT_SYMBOL_GPL(brnf_deferred_hooks);
-
 static __be16 inline vlan_proto(const struct sk_buff *skb)
 {
 	return vlan_eth_hdr(skb)->h_vlan_encapsulated_proto;
@@ -685,110 +682,50 @@ #endif
 	return NF_STOLEN;
 }
 
-/* PF_BRIDGE/LOCAL_OUT ***********************************************/
-static int br_nf_local_out_finish(struct sk_buff *skb)
-{
-	if (skb->protocol == htons(ETH_P_8021Q)) {
-		skb_push(skb, VLAN_HLEN);
-		skb->nh.raw -= VLAN_HLEN;
-	}
-
-	NF_HOOK_THRESH(PF_BRIDGE, NF_BR_LOCAL_OUT, skb, NULL, skb->dev,
-		       br_forward_finish, NF_BR_PRI_FIRST + 1);
-
-	return 0;
-}
-
-/* This function sees both locally originated IP packets and forwarded
+/* PF_BRIDGE/LOCAL_OUT ***********************************************
+ *
+ * This function sees both locally originated IP packets and forwarded
  * IP packets (in both cases the destination device is a bridge
  * device). It also sees bridged-and-DNAT'ed packets.
- * To be able to filter on the physical bridge devices (with the physdev
- * module), we steal packets destined to a bridge device away from the
- * PF_INET/FORWARD and PF_INET/OUTPUT hook functions, and give them back later,
- * when we have determined the real output device. This is done in here.
  *
  * If (nf_bridge->mask & BRNF_BRIDGED_DNAT) then the packet is bridged
  * and we fake the PF_BRIDGE/FORWARD hook. The function br_nf_forward()
  * will then fake the PF_INET/FORWARD hook. br_nf_local_out() has priority
  * NF_BR_PRI_FIRST, so no relevant PF_BRIDGE/INPUT functions have been nor
  * will be executed.
- * Otherwise, if nf_bridge->physindev is NULL, the bridge-nf code never touched
- * this packet before, and so the packet was locally originated. We fake
- * the PF_INET/LOCAL_OUT hook.
- * Finally, if nf_bridge->physindev isn't NULL, then the packet was IP routed,
- * so we fake the PF_INET/FORWARD hook. ip_sabotage_out() makes sure
- * even routed packets that didn't arrive on a bridge interface have their
- * nf_bridge->physindev set. */
+ */
 static unsigned int br_nf_local_out(unsigned int hook, struct sk_buff **pskb,
 				    const struct net_device *in,
 				    const struct net_device *out,
 				    int (*okfn)(struct sk_buff *))
 {
-	struct net_device *realindev, *realoutdev;
+	struct net_device *realindev;
 	struct sk_buff *skb = *pskb;
 	struct nf_bridge_info *nf_bridge;
-	int pf;
 
 	if (!skb->nf_bridge)
 		return NF_ACCEPT;
 
-	if (skb->protocol == htons(ETH_P_IP) || IS_VLAN_IP(skb))
-		pf = PF_INET;
-	else
-		pf = PF_INET6;
-
 	nf_bridge = skb->nf_bridge;
-	nf_bridge->physoutdev = skb->dev;
-	realindev = nf_bridge->physindev;
+	if (!(nf_bridge->mask & BRNF_BRIDGED_DNAT))
+		return NF_ACCEPT;
 
 	/* Bridged, take PF_BRIDGE/FORWARD.
 	 * (see big note in front of br_nf_pre_routing_finish) */
-	if (nf_bridge->mask & BRNF_BRIDGED_DNAT) {
-		if (nf_bridge->mask & BRNF_PKT_TYPE) {
-			skb->pkt_type = PACKET_OTHERHOST;
-			nf_bridge->mask ^= BRNF_PKT_TYPE;
-		}
-		if (skb->protocol == htons(ETH_P_8021Q)) {
-			skb_push(skb, VLAN_HLEN);
-			skb->nh.raw -= VLAN_HLEN;
-		}
+	nf_bridge->physoutdev = skb->dev;
+	realindev = nf_bridge->physindev;
 
-		NF_HOOK(PF_BRIDGE, NF_BR_FORWARD, skb, realindev,
-			skb->dev, br_forward_finish);
-		goto out;
+	if (nf_bridge->mask & BRNF_PKT_TYPE) {
+		skb->pkt_type = PACKET_OTHERHOST;
+		nf_bridge->mask ^= BRNF_PKT_TYPE;
 	}
-	realoutdev = bridge_parent(skb->dev);
-	if (!realoutdev)
-		return NF_DROP;
-
-#if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
-	/* iptables should match -o br0.x */
-	if (nf_bridge->netoutdev)
-		realoutdev = nf_bridge->netoutdev;
-#endif
 	if (skb->protocol == htons(ETH_P_8021Q)) {
-		skb_pull(skb, VLAN_HLEN);
-		(*pskb)->nh.raw += VLAN_HLEN;
-	}
-	/* IP forwarded traffic has a physindev, locally
-	 * generated traffic hasn't. */
-	if (realindev != NULL) {
-		if (!(nf_bridge->mask & BRNF_DONT_TAKE_PARENT)) {
-			struct net_device *parent = bridge_parent(realindev);
-			if (parent)
-				realindev = parent;
-		}
-
-		NF_HOOK_THRESH(pf, NF_IP_FORWARD, skb, realindev,
-			       realoutdev, br_nf_local_out_finish,
-			       NF_IP_PRI_BRIDGE_SABOTAGE_FORWARD + 1);
-	} else {
-		NF_HOOK_THRESH(pf, NF_IP_LOCAL_OUT, skb, realindev,
-			       realoutdev, br_nf_local_out_finish,
-			       NF_IP_PRI_BRIDGE_SABOTAGE_LOCAL_OUT + 1);
+		skb_push(skb, VLAN_HLEN);
+		skb->nh.raw -= VLAN_HLEN;
 	}
 
-out:
+	NF_HOOK(PF_BRIDGE, NF_BR_FORWARD, skb, realindev, skb->dev,
+		br_forward_finish);
 	return NF_STOLEN;
 }
 
@@ -894,69 +831,6 @@ static unsigned int ip_sabotage_in(unsig
 	return NF_ACCEPT;
 }
 
-/* Postpone execution of PF_INET(6)/FORWARD, PF_INET(6)/LOCAL_OUT
- * and PF_INET(6)/POST_ROUTING until we have done the forwarding
- * decision in the bridge code and have determined nf_bridge->physoutdev. */
-static unsigned int ip_sabotage_out(unsigned int hook, struct sk_buff **pskb,
-				    const struct net_device *in,
-				    const struct net_device *out,
-				    int (*okfn)(struct sk_buff *))
-{
-	struct sk_buff *skb = *pskb;
-
-	if ((out->hard_start_xmit == br_dev_xmit &&
-	     okfn != br_nf_forward_finish &&
-	     okfn != br_nf_local_out_finish && okfn != br_nf_dev_queue_xmit)
-#if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
-	    || ((out->priv_flags & IFF_802_1Q_VLAN) &&
-		VLAN_DEV_INFO(out)->real_dev->hard_start_xmit == br_dev_xmit)
-#endif
-	    ) {
-		struct nf_bridge_info *nf_bridge;
-
-		if (!skb->nf_bridge) {
-#ifdef CONFIG_SYSCTL
-			/* This code is executed while in the IP(v6) stack,
-			   the version should be 4 or 6. We can't use
-			   skb->protocol because that isn't set on
-			   PF_INET(6)/LOCAL_OUT. */
-			struct iphdr *ip = skb->nh.iph;
-
-			if (ip->version == 4 && !brnf_call_iptables)
-				return NF_ACCEPT;
-			else if (ip->version == 6 && !brnf_call_ip6tables)
-				return NF_ACCEPT;
-			else if (!brnf_deferred_hooks)
-				return NF_ACCEPT;
-#endif
-			if (hook == NF_IP_POST_ROUTING)
-				return NF_ACCEPT;
-			if (!nf_bridge_alloc(skb))
-				return NF_DROP;
-		}
-
-		nf_bridge = skb->nf_bridge;
-
-		/* This frame will arrive on PF_BRIDGE/LOCAL_OUT and we
-		 * will need the indev then. For a brouter, the real indev
-		 * can be a bridge port, so we make sure br_nf_local_out()
-		 * doesn't use the bridge parent of the indev by using
-		 * the BRNF_DONT_TAKE_PARENT mask. */
-		if (hook == NF_IP_FORWARD && nf_bridge->physindev == NULL) {
-			nf_bridge->mask |= BRNF_DONT_TAKE_PARENT;
-			nf_bridge->physindev = (struct net_device *)in;
-		}
-#if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
-		/* the iptables outdev is br0.x, not br0 */
-		if (out->priv_flags & IFF_802_1Q_VLAN)
-			nf_bridge->netoutdev = (struct net_device *)out;
-#endif
-		return NF_STOP;
-	}
-
-	return NF_ACCEPT;
-}
-
 /* For br_nf_local_out we need (prio = NF_BR_PRI_FIRST), to insure that innocent
  * PF_BRIDGE/NF_BR_LOCAL_OUT functions don't get bridged traffic as input.
  * For br_nf_post_routing, we need (prio = NF_BR_PRI_LAST), because
@@ -1002,36 +876,6 @@ static struct nf_hook_ops br_nf_ops[] = 
 	  .pf = PF_INET6,
 	  .hooknum = NF_IP6_PRE_ROUTING,
 	  .priority = NF_IP6_PRI_FIRST, },
-	{ .hook = ip_sabotage_out,
-	  .owner = THIS_MODULE,
-	  .pf = PF_INET,
-	  .hooknum = NF_IP_FORWARD,
-	  .priority = NF_IP_PRI_BRIDGE_SABOTAGE_FORWARD, },
-	{ .hook = ip_sabotage_out,
-	  .owner = THIS_MODULE,
-	  .pf = PF_INET6,
-	  .hooknum = NF_IP6_FORWARD,
-	  .priority = NF_IP6_PRI_BRIDGE_SABOTAGE_FORWARD, },
-	{ .hook = ip_sabotage_out,
-	  .owner = THIS_MODULE,
-	  .pf = PF_INET,
-	  .hooknum = NF_IP_LOCAL_OUT,
-	  .priority = NF_IP_PRI_BRIDGE_SABOTAGE_LOCAL_OUT, },
-	{ .hook = ip_sabotage_out,
-	  .owner = THIS_MODULE,
-	  .pf = PF_INET6,
-	  .hooknum = NF_IP6_LOCAL_OUT,
-	  .priority = NF_IP6_PRI_BRIDGE_SABOTAGE_LOCAL_OUT, },
-	{ .hook = ip_sabotage_out,
-	  .owner = THIS_MODULE,
-	  .pf = PF_INET,
-	  .hooknum = NF_IP_POST_ROUTING,
-	  .priority = NF_IP_PRI_FIRST, },
-	{ .hook = ip_sabotage_out,
-	  .owner = THIS_MODULE,
-	  .pf = PF_INET6,
-	  .hooknum = NF_IP6_POST_ROUTING,
-	  .priority = NF_IP6_PRI_FIRST, },
 };
 
 #ifdef CONFIG_SYSCTL
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index fd8f954..b9b3ffc 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -113,20 +113,16 @@ checkentry(const char *tablename,
 	if (!(info->bitmask & XT_PHYSDEV_OP_MASK) ||
 	    info->bitmask & ~XT_PHYSDEV_OP_MASK)
 		return 0;
-	if (brnf_deferred_hooks == 0 &&
-	    info->bitmask & XT_PHYSDEV_OP_OUT &&
+	if (info->bitmask & XT_PHYSDEV_OP_OUT &&
 	    (!(info->bitmask & XT_PHYSDEV_OP_BRIDGED) ||
 	     info->invert & XT_PHYSDEV_OP_BRIDGED) &&
 	    hook_mask & ((1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_FORWARD) |
 	                 (1 << NF_IP_POST_ROUTING))) {
 		printk(KERN_WARNING "physdev match: using --physdev-out in the "
 		       "OUTPUT, FORWARD and POSTROUTING chains for non-bridged "
-		       "traffic is deprecated and breaks other things, it will "
-		       "be removed in January 2007. See Documentation/"
-		       "feature-removal-schedule.txt for details. This doesn't "
-		       "affect you in case you're using it for purely bridged "
-		       "traffic.\n");
-		brnf_deferred_hooks = 1;
+		       "traffic is not supported anymore.\n");
+		if (hook_mask & (1 << NF_IP_LOCAL_OUT))
+			return 0;
 	}
 	return 1;
 }

--------------030403090600090801030202--
