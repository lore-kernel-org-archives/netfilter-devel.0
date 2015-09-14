From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: bridge: fix routing of bridge frames with call-iptables=1
Date: Mon, 14 Sep 2015 10:40:35 +0200
Message-ID: <1442220035-2225-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:60217 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751330AbbINIkq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Sep 2015 04:40:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We need to (re-)init physoutdev to NULL, as its storage area is used
to stash the ip destination to detect L3 nat.

For frames that are bridged this is no problem because the bridge
forward hook initializes physoutdev to the real bridge port.

But in case the skb is delivered locally and then routed we can crash
in the physdev match since nf_bridge->physoutdev is garbage
(ipv4/ipv6 address)

Fixes: 72b1e5e4cac7 ("netfilter: bridge: reduce nf_bridge_info to 32 bytes again")
Reported-and-tested-by: Sander Eikelenboom <linux@eikelenboom.it>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/bridge/br_netfilter_hooks.c | 10 +++++++++-
 net/bridge/br_netfilter_ipv6.c  |  7 ++++++-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 33a82ff..824fbc8 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -355,6 +355,7 @@ static int br_nf_pre_routing_finish(struct sock *sk, struct sk_buff *skb)
 	struct iphdr *iph = ip_hdr(skb);
 	struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
 	struct rtable *rt;
+	bool daddr_changed;
 	int err;
 
 	nf_bridge->frag_max_size = IPCB(skb)->frag_max_size;
@@ -363,8 +364,15 @@ static int br_nf_pre_routing_finish(struct sock *sk, struct sk_buff *skb)
 		skb->pkt_type = PACKET_OTHERHOST;
 		nf_bridge->pkt_otherhost = false;
 	}
+
+	daddr_changed = br_nf_ipv4_daddr_was_changed(skb, nf_bridge);
+	/* init physoutdev to NULL. Its set by the bridge forward hook, but
+	 * frame might be routed instead of bridged.
+	 */
+	nf_bridge->physoutdev = NULL;
 	nf_bridge->in_prerouting = 0;
-	if (br_nf_ipv4_daddr_was_changed(skb, nf_bridge)) {
+
+	if (daddr_changed) {
 		if ((err = ip_route_input(skb, iph->daddr, iph->saddr, iph->tos, dev))) {
 			struct in_device *in_dev = __in_dev_get_rcu(dev);
 
diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
index 77383bf..772222b 100644
--- a/net/bridge/br_netfilter_ipv6.c
+++ b/net/bridge/br_netfilter_ipv6.c
@@ -167,6 +167,7 @@ static int br_nf_pre_routing_finish_ipv6(struct sock *sk, struct sk_buff *skb)
 	struct rtable *rt;
 	struct net_device *dev = skb->dev;
 	const struct nf_ipv6_ops *v6ops = nf_get_ipv6_ops();
+	bool daddr_changed;
 
 	nf_bridge->frag_max_size = IP6CB(skb)->frag_max_size;
 
@@ -174,8 +175,12 @@ static int br_nf_pre_routing_finish_ipv6(struct sock *sk, struct sk_buff *skb)
 		skb->pkt_type = PACKET_OTHERHOST;
 		nf_bridge->pkt_otherhost = false;
 	}
+
+	daddr_changed = br_nf_ipv6_daddr_was_changed(skb, nf_bridge);
+	nf_bridge->physoutdev = NULL;
 	nf_bridge->in_prerouting = 0;
-	if (br_nf_ipv6_daddr_was_changed(skb, nf_bridge)) {
+
+	if (daddr_changed) {
 		skb_dst_drop(skb);
 		v6ops->route_input(skb);
 
-- 
2.0.5

