Return-Path: <SRS0=iy/8=SN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1E22C10F14
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Apr 2019 14:39:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABFCC206BA
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Apr 2019 14:39:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfDKOjx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Apr 2019 10:39:53 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:36476 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726391AbfDKOjw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Apr 2019 10:39:52 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hEarl-0001te-1X; Thu, 11 Apr 2019 16:39:49 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        <netdev@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 4/4] bridge: broute: make broute a real ebtables table
Date:   Thu, 11 Apr 2019 16:36:42 +0200
Message-Id: <20190411143642.1087-5-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190411143642.1087-1-fw@strlen.de>
References: <20190411143642.1087-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This makes broute a normal ebtables table, hooking at PREROUTING.
The broute hook is removed.

It uses skb->cb to signal to bridge rx handler that the skb should be
routed instead of being bridged.

This change is backwards compatible with ebtables as no userspace visible
parts are changed.

This means we can also remove the !ops test in ebt_register_table,
it was only there for broute table sake.

Cc: Roopa Prabhu <roopa@cumulusnetworks.com>
Cc: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/if_bridge.h             |  3 --
 net/bridge/br_input.c                 | 18 ++------
 net/bridge/br_private.h               |  3 ++
 net/bridge/netfilter/ebtable_broute.c | 63 +++++++++++++++++++--------
 net/bridge/netfilter/ebtables.c       |  7 +--
 5 files changed, 52 insertions(+), 42 deletions(-)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 627b788ba0ff..ef0819ced0fc 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -56,9 +56,6 @@ struct br_ip_list {
 
 extern void brioctl_set(int (*ioctl_hook)(struct net *, unsigned int, void __user *));
 
-typedef int br_should_route_hook_t(struct sk_buff *skb);
-extern br_should_route_hook_t __rcu *br_should_route_hook;
-
 #if IS_ENABLED(CONFIG_BRIDGE) && IS_ENABLED(CONFIG_BRIDGE_IGMP_SNOOPING)
 int br_multicast_list_adjacent(struct net_device *dev,
 			       struct list_head *br_ip_list);
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 4ac34fb5f943..e0aacfedcfe1 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -24,10 +24,6 @@
 #include "br_private.h"
 #include "br_private_tunnel.h"
 
-/* Hook for brouter */
-br_should_route_hook_t __rcu *br_should_route_hook __read_mostly;
-EXPORT_SYMBOL(br_should_route_hook);
-
 static int
 br_netif_receive_skb(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
@@ -234,6 +230,10 @@ static int nf_hook_bridge_pre(struct sk_buff *skb, struct sk_buff **pskb)
 		verdict = nf_hook_entry_hookfn(&e->hooks[i], skb, &state);
 		switch (verdict & NF_VERDICT_MASK) {
 		case NF_ACCEPT:
+			if (BR_INPUT_SKB_CB(skb)->br_netfilter_broute) {
+				*pskb = skb;
+				return RX_HANDLER_PASS;
+			}
 			break;
 		case NF_DROP:
 			kfree_skb(skb);
@@ -265,7 +265,6 @@ rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
 	struct net_bridge_port *p;
 	struct sk_buff *skb = *pskb;
 	const unsigned char *dest = eth_hdr(skb)->h_dest;
-	br_should_route_hook_t *rhook;
 
 	if (unlikely(skb->pkt_type == PACKET_LOOPBACK))
 		return RX_HANDLER_PASS;
@@ -341,15 +340,6 @@ rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
 forward:
 	switch (p->state) {
 	case BR_STATE_FORWARDING:
-		rhook = rcu_dereference(br_should_route_hook);
-		if (rhook) {
-			if ((*rhook)(skb)) {
-				*pskb = skb;
-				return RX_HANDLER_PASS;
-			}
-			dest = eth_hdr(skb)->h_dest;
-		}
-		/* fall through */
 	case BR_STATE_LEARNING:
 		if (ether_addr_equal(p->br->dev->dev_addr, dest))
 			skb->pkt_type = PACKET_HOST;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index e7110a6e2b7e..4bea2f11da9b 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -433,6 +433,9 @@ struct br_input_skb_cb {
 #ifdef CONFIG_BRIDGE_VLAN_FILTERING
 	u8 vlan_filtered:1;
 #endif
+#ifdef CONFIG_NETFILTER_FAMILY_BRIDGE
+	u8 br_netfilter_broute:1;
+#endif
 
 #ifdef CONFIG_NET_SWITCHDEV
 	int offload_fwd_mark;
diff --git a/net/bridge/netfilter/ebtable_broute.c b/net/bridge/netfilter/ebtable_broute.c
index 276b60262981..ec2652a459da 100644
--- a/net/bridge/netfilter/ebtable_broute.c
+++ b/net/bridge/netfilter/ebtable_broute.c
@@ -15,6 +15,8 @@
 #include <linux/module.h>
 #include <linux/if_bridge.h>
 
+#include "../br_private.h"
+
 /* EBT_ACCEPT means the frame will be bridged
  * EBT_DROP means the frame will be routed
  */
@@ -48,30 +50,63 @@ static const struct ebt_table broute_table = {
 	.me		= THIS_MODULE,
 };
 
-static int ebt_broute(struct sk_buff *skb)
+static unsigned int ebt_broute(void *priv, struct sk_buff *skb,
+			       const struct nf_hook_state *s)
 {
+	struct net_bridge_port *p = br_port_get_rcu(skb->dev);
 	struct nf_hook_state state;
+	unsigned char *dest;
 	int ret;
 
+	if (!p || p->state != BR_STATE_FORWARDING)
+		return NF_ACCEPT;
+
 	nf_hook_state_init(&state, NF_BR_BROUTING,
-			   NFPROTO_BRIDGE, skb->dev, NULL, NULL,
-			   dev_net(skb->dev), NULL);
+			   NFPROTO_BRIDGE, s->in, NULL, NULL,
+			   s->net, NULL);
 
 	ret = ebt_do_table(skb, &state, state.net->xt.broute_table);
-	if (ret == NF_DROP)
-		return 1; /* route it */
-	return 0; /* bridge it */
+
+	if (ret != NF_DROP)
+		return ret;
+
+	/* DROP in ebtables -t broute means that the
+	 * skb should be routed, not bridged.
+	 * This is awkward, but can't be changed for compatibility
+	 * reasons.
+	 *
+	 * We map DROP to ACCEPT and set the ->br_netfilter_broute flag.
+	 */
+	BR_INPUT_SKB_CB(skb)->br_netfilter_broute = 1;
+
+	/* undo PACKET_HOST mangling done in br_input in case the dst
+	 * address matches the logical bridge but not the port.
+	 */
+	dest = eth_hdr(skb)->h_dest;
+	if (skb->pkt_type == PACKET_HOST &&
+	    !ether_addr_equal(skb->dev->dev_addr, dest) &&
+	     ether_addr_equal(p->br->dev->dev_addr, dest))
+		skb->pkt_type = PACKET_OTHERHOST;
+
+	return NF_ACCEPT;
 }
 
+static const struct nf_hook_ops ebt_ops_broute = {
+	.hook		= ebt_broute,
+	.pf		= NFPROTO_BRIDGE,
+	.hooknum	= NF_BR_PRE_ROUTING,
+	.priority	= NF_BR_PRI_FIRST,
+};
+
 static int __net_init broute_net_init(struct net *net)
 {
-	return ebt_register_table(net, &broute_table, NULL,
+	return ebt_register_table(net, &broute_table, &ebt_ops_broute,
 				  &net->xt.broute_table);
 }
 
 static void __net_exit broute_net_exit(struct net *net)
 {
-	ebt_unregister_table(net, net->xt.broute_table, NULL);
+	ebt_unregister_table(net, net->xt.broute_table, &ebt_ops_broute);
 }
 
 static struct pernet_operations broute_net_ops = {
@@ -81,21 +116,11 @@ static struct pernet_operations broute_net_ops = {
 
 static int __init ebtable_broute_init(void)
 {
-	int ret;
-
-	ret = register_pernet_subsys(&broute_net_ops);
-	if (ret < 0)
-		return ret;
-	/* see br_input.c */
-	RCU_INIT_POINTER(br_should_route_hook,
-			   (br_should_route_hook_t *)ebt_broute);
-	return 0;
+	return register_pernet_subsys(&broute_net_ops);
 }
 
 static void __exit ebtable_broute_fini(void)
 {
-	RCU_INIT_POINTER(br_should_route_hook, NULL);
-	synchronize_net();
 	unregister_pernet_subsys(&broute_net_ops);
 }
 
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index eb15891f8b9f..383f0328ff68 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1221,10 +1221,6 @@ int ebt_register_table(struct net *net, const struct ebt_table *input_table,
 	mutex_unlock(&ebt_mutex);
 
 	WRITE_ONCE(*res, table);
-
-	if (!ops)
-		return 0;
-
 	ret = nf_register_net_hooks(net, ops, hweight32(table->valid_hooks));
 	if (ret) {
 		__ebt_unregister_table(net, table);
@@ -1248,8 +1244,7 @@ int ebt_register_table(struct net *net, const struct ebt_table *input_table,
 void ebt_unregister_table(struct net *net, struct ebt_table *table,
 			  const struct nf_hook_ops *ops)
 {
-	if (ops)
-		nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
+	nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
 	__ebt_unregister_table(net, table);
 }
 
-- 
2.21.0

