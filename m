From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [PATCH] Let arptables see bridged arp traffic
Date: Thu, 19 Jun 2003 21:24:34 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200306192124.34286.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David S.Miller <davem@redhat.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Dave,

The patch below introduces the NF_ARP_FORWARD hook to let arptables see
bridged arp traffic, as discussed in a previous mail.

Please apply, if there are no objections...
Bart


--- linux-2.5.72/net/bridge/br_netfilter.c.old	2003-06-19 20:40:57.000000000 +0200
+++ linux-2.5.72/net/bridge/br_netfilter.c	2003-06-19 21:09:52.000000000 +0200
@@ -22,6 +22,7 @@
 #include <linux/if_ether.h>
 #include <linux/netfilter_bridge.h>
 #include <linux/netfilter_ipv4.h>
+#include <linux/netfilter_arp.h>
 #include <linux/in_route.h>
 #include <net/ip.h>
 #include <asm/uaccess.h>
@@ -304,31 +305,36 @@ static unsigned int br_nf_local_in(unsig
 	return NF_ACCEPT;
 }

-
 /* PF_BRIDGE/FORWARD *************************************************/
 static int br_nf_forward_finish(struct sk_buff *skb)
 {
 	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
+	struct net_device *in;

 #ifdef CONFIG_NETFILTER_DEBUG
 	skb->nf_debug ^= (1 << NF_BR_FORWARD);
 #endif

-	if (nf_bridge->mask & BRNF_PKT_TYPE) {
-		skb->pkt_type = PACKET_OTHERHOST;
-		nf_bridge->mask ^= BRNF_PKT_TYPE;
+	if (skb->protocol == __constant_htons(ETH_P_IP)) {
+		in = nf_bridge->physindev;
+		if (nf_bridge->mask & BRNF_PKT_TYPE) {
+			skb->pkt_type = PACKET_OTHERHOST;
+			nf_bridge->mask ^= BRNF_PKT_TYPE;
+		}
+	} else {
+		in = *((struct net_device **)(skb->cb));
 	}

-	NF_HOOK_THRESH(PF_BRIDGE, NF_BR_FORWARD, skb, nf_bridge->physindev,
+	NF_HOOK_THRESH(PF_BRIDGE, NF_BR_FORWARD, skb, in,
 			skb->dev, br_forward_finish, 1);
-
 	return 0;
 }

-/* This is the 'purely bridged' case.  We pass the packet to
+/* This is the 'purely bridged' case.  For IP, we pass the packet to
  * netfilter with indev and outdev set to the bridge device,
  * but we are still able to filter on the 'real' indev/outdev
- * because of the ipt_physdev.c module.
+ * because of the ipt_physdev.c module. For ARP, indev and outdev are the
+ * bridge ports.
  */
 static unsigned int br_nf_forward(unsigned int hook, struct sk_buff **pskb,
    const struct net_device *in, const struct net_device *out,
@@ -337,24 +343,33 @@ static unsigned int br_nf_forward(unsign
 	struct sk_buff *skb = *pskb;
 	struct nf_bridge_info *nf_bridge;

-	if (skb->protocol != __constant_htons(ETH_P_IP))
+	if (skb->protocol != __constant_htons(ETH_P_IP) &&
+	    skb->protocol != __constant_htons(ETH_P_ARP))
 		return NF_ACCEPT;

 #ifdef CONFIG_NETFILTER_DEBUG
 	skb->nf_debug ^= (1 << NF_BR_FORWARD);
 #endif
+	if (skb->protocol == __constant_htons(ETH_P_IP)) {
+		nf_bridge = skb->nf_bridge;
+		if (skb->pkt_type == PACKET_OTHERHOST) {
+			skb->pkt_type = PACKET_HOST;
+			nf_bridge->mask |= BRNF_PKT_TYPE;
+		}

-	nf_bridge = skb->nf_bridge;
-	if (skb->pkt_type == PACKET_OTHERHOST) {
-		skb->pkt_type = PACKET_HOST;
-		nf_bridge->mask |= BRNF_PKT_TYPE;
-	}
+		/* The physdev module checks on this */
+		nf_bridge->mask |= BRNF_BRIDGED;
+		nf_bridge->physoutdev = skb->dev;

-	nf_bridge->mask |= BRNF_BRIDGED; /* The physdev module checks on this */
-	nf_bridge->physoutdev = skb->dev;
+		NF_HOOK(PF_INET, NF_IP_FORWARD, skb, bridge_parent(in),
+			bridge_parent(out), br_nf_forward_finish);
+	} else {
+		struct net_device **d = (struct net_device **)(skb->cb);

-	NF_HOOK(PF_INET, NF_IP_FORWARD, skb, bridge_parent(nf_bridge->physindev),
-			bridge_parent(skb->dev), br_nf_forward_finish);
+		*d = (struct net_device *)in;
+		NF_HOOK(NF_ARP, NF_ARP_FORWARD, skb, (struct net_device *)in,
+			(struct net_device *)out, br_nf_forward_finish);
+	}

 	return NF_STOLEN;
 }
--- linux-2.5.72/net/ipv4/netfilter/arptable_filter.c.old	2003-06-19 20:41:07.000000000 +0200
+++ linux-2.5.72/net/ipv4/netfilter/arptable_filter.c	2003-06-19 20:41:26.000000000 +0200
@@ -8,7 +8,8 @@
 #include <linux/module.h>
 #include <linux/netfilter_arp/arp_tables.h>
 
-#define FILTER_VALID_HOOKS ((1 << NF_ARP_IN) | (1 << NF_ARP_OUT))
+#define FILTER_VALID_HOOKS ((1 << NF_ARP_IN) | (1 << NF_ARP_OUT) | \
+			   (1 << NF_ARP_FORWARD))
 
 /* Standard entry. */
 struct arpt_standard
@@ -32,15 +33,17 @@ struct arpt_error
 static struct
 {
 	struct arpt_replace repl;
-	struct arpt_standard entries[2];
+	struct arpt_standard entries[3];
 	struct arpt_error term;
 } initial_table __initdata
-= { { "filter", FILTER_VALID_HOOKS, 3,
-      sizeof(struct arpt_standard) * 2 + sizeof(struct arpt_error),
+= { { "filter", FILTER_VALID_HOOKS, 4,
+      sizeof(struct arpt_standard) * 3 + sizeof(struct arpt_error),
       { [NF_ARP_IN] = 0,
-	[NF_ARP_OUT] = sizeof(struct arpt_standard) },
+	[NF_ARP_OUT] = sizeof(struct arpt_standard),
+	[NF_ARP_FORWARD] = 2 * sizeof(struct arpt_standard), },
       { [NF_ARP_IN] = 0,
-	[NF_ARP_OUT] = sizeof(struct arpt_standard), },
+	[NF_ARP_OUT] = sizeof(struct arpt_standard),
+	[NF_ARP_FORWARD] = 2 * sizeof(struct arpt_standard), },
       0, NULL, { } },
     {
 	    /* ARP_IN */
@@ -84,6 +87,27 @@ static struct
 			    { 0, 0 }, { } },
 		    { { { { ARPT_ALIGN(sizeof(struct arpt_standard_target)), "" } }, { } },
 		      -NF_ACCEPT - 1 }
+	    },
+	    /* ARP_FORWARD */
+	    {
+		    {
+			    {
+				    { 0 }, { 0 }, { 0 }, { 0 },
+				    0, 0,
+				    { { 0, }, { 0, } },
+				    { { 0, }, { 0, } },
+				    0, 0,
+				    0, 0,
+				    0, 0,
+				    "", "", { 0 }, { 0 },
+				    0, 0
+			    },
+			    sizeof(struct arpt_entry),
+			    sizeof(struct arpt_standard),
+			    0,
+			    { 0, 0 }, { } },
+		    { { { { ARPT_ALIGN(sizeof(struct arpt_standard_target)), "" } }, { } },
+		      -NF_ACCEPT - 1 }
 	    }
     },
     /* ERROR */
@@ -142,35 +166,34 @@ static struct nf_hook_ops arpt_ops[] = {
 		.owner		= THIS_MODULE,
 		.pf		= NF_ARP,
 		.hooknum	= NF_ARP_OUT,
-	}
+	},
+	{
+		.hook		= arpt_hook,
+		.owner		= THIS_MODULE,
+		.pf		= NF_ARP,
+		.hooknum	= NF_ARP_FORWARD,
+	},
 };
 
 static int __init init(void)
 {
-	int ret;
+	int ret, i;
 
 	/* Register table */
 	ret = arpt_register_table(&packet_filter);
 	if (ret < 0)
 		return ret;
 
-	/* Register hooks */
-	ret = nf_register_hook(&arpt_ops[0]);
-	if (ret < 0)
-		goto cleanup_table;
-
-	ret = nf_register_hook(&arpt_ops[1]);
-	if (ret < 0)
-		goto cleanup_hook0;
-
+	for (i = 0; i < ARRAY_SIZE(arpt_ops); i++)
+		if ((ret = nf_register_hook(&arpt_ops[i])) < 0)
+			goto cleanup_hooks;
 	return ret;
 
-cleanup_hook0:
-	nf_unregister_hook(&arpt_ops[0]);
+cleanup_hooks:
+	while (--i >= 0)
+		nf_unregister_hook(&arpt_ops[i]);
 
-cleanup_table:
 	arpt_unregister_table(&packet_filter);
-
 	return ret;
 }
 
@@ -178,7 +201,7 @@ static void __exit fini(void)
 {
 	unsigned int i;
 
-	for (i = 0; i < sizeof(arpt_ops)/sizeof(struct nf_hook_ops); i++)
+	for (i = 0; i < ARRAY_SIZE(arpt_ops); i++)
 		nf_unregister_hook(&arpt_ops[i]);
 
 	arpt_unregister_table(&packet_filter);
--- linux-2.5.72/include/linux/netfilter_arp.h.old	2003-06-19 20:41:19.000000000 +0200
+++ linux-2.5.72/include/linux/netfilter_arp.h	2003-06-19 20:41:26.000000000 +0200
@@ -14,6 +14,7 @@
 /* ARP Hooks */
 #define NF_ARP_IN	0
 #define NF_ARP_OUT	1
-#define NF_ARP_NUMHOOKS	2
+#define NF_ARP_FORWARD	2
+#define NF_ARP_NUMHOOKS	3
 
 #endif /* __LINUX_ARP_NETFILTER_H */
