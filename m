From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] netfilter: bridge: unshare bridge info before change
 it
Date: Wed, 19 Nov 2014 14:32:04 +0100
Message-ID: <20141119133204.GA12162@salvia>
References: <1416366453-12090-1-git-send-email-gaofeng@cn.fujitsu.com>
 <20141119130751.GA10748@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="tKW2IUtsqtDRztdT"
Cc: netfilter-devel@vger.kernel.org
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44531 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585AbaKSNaH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Nov 2014 08:30:07 -0500
Content-Disposition: inline
In-Reply-To: <20141119130751.GA10748@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 19, 2014 at 02:07:51PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Nov 19, 2014 at 11:07:32AM +0800, Gao feng wrote:
> > diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
> > index c755e49..dca7337 100644
> > --- a/include/linux/netfilter_bridge.h
> > +++ b/include/linux/netfilter_bridge.h
> > @@ -81,14 +81,64 @@ static inline unsigned int nf_bridge_mtu_reduction(const struct sk_buff *skb)
> >  	return 0;
> >  }
> >  
> > +static inline struct nf_bridge_info *nf_bridge_alloc(struct sk_buff *skb)
> > +{
> > +	skb->nf_bridge = kzalloc(sizeof(struct nf_bridge_info), GFP_ATOMIC);
> > +	if (likely(skb->nf_bridge))
> > +		atomic_set(&(skb->nf_bridge->use), 1);
> > +
> > +	return skb->nf_bridge;
> > +}
> > +
> > +static inline struct nf_bridge_info *nf_bridge_unshare(struct sk_buff *skb)
> > +{
> > +	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
> > +
> > +	if (atomic_read(&nf_bridge->use) > 1) {
> > +		struct nf_bridge_info *tmp = nf_bridge_alloc(skb);
> 
> nf_bridge_alloc() overwrites the original skb->nf_bridge when
> unsharing, so this leaks and likely breaks other things.

I took over your patch and gave it another spin.

Specifically, I added some helper functions to handle the skb->pkttype
mangling (see nf_br_mangle_pkttype(), nf_br_restore_pkttype().
Also fixed the problem above, compile tested only.

Not your fault, this br_netfilter code is not in good shape, but I
would like not to get it worse.

Would you take this over and split it in smaller patches? I'd suggest:

1) Cleanup patch to use &=~ instead of ^=. The existing code looks
fine, but I think a bug may invert the bits when use xor to handle
flags.

2) Patch to move nf_bridge_alloc() and so on to the header file, to
prepare the unshare fix.

3) Patch to add the pkttype helper functions.

4) Your unshare fix for br_netfilter.

Would you work on that? Thanks.

--tKW2IUtsqtDRztdT
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-bridge-unshare-bridge-info-before-change-i.patch"

>From 6fd546e3866fe5a60be84aebd5fbc1e93ef14f46 Mon Sep 17 00:00:00 2001
From: Gao feng <gaofeng@cn.fujitsu.com>
Date: Wed, 19 Nov 2014 11:07:32 +0800
Subject: [PATCH] netfilter: bridge: unshare bridge info before change it

Many packets may share the same bridge information, we should unshare
the bridge info before we change it, otherwise other packets will go to
PF_INET(6)/PRE_ROUTING second time or the pkt_type of other packets
will be incorrect.

The problem occurs in below case.

Firstly setup NFQUEUE rule on ipv4 PREROUTING chain.

When gso packet came in from bridge, br_nf_pre_routing will
allocate nf_bridge_info for this gso packet and call setup_pre_routing
to setup nf_bridge_info (such as nf_bridge->mask |= BRNF_NF_BRIDGE_PREROUTING)

Then this packet goes to ipv4 prerouting chain, nfqnl_enqueue_packet
will call skb_segment to segment this gso packet. in skb_segment, the
new packets will copy gso packet's header(__copy_skb_header), so there
will be many packets share the same nf_bridge_info.

When these segmented packets being reinjected into kernel, they will
continue going through bridge netfilter, br_nf_pre_routing_finish will
clean the BRNF_NF_BRIDGE_PREROUTING for the first packet, setup it for
the secondary packet, clean it for the third packet...

If the dest of these packets is local machine, they will come into
br_pass_frame_up. then go to ipv4 prerouting chain again through
netif_receive_skb. so ip_sabotage_in will not stop half of these
packets.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
NOTE: This still needs another review. The patch is rather large and it would
be good to split this in smaller chunks for easier review.

 include/linux/netfilter_bridge.h |   57 +++++++++++++++-
 net/bridge/br_netfilter.c        |  135 +++++++++++++++++---------------------
 2 files changed, 116 insertions(+), 76 deletions(-)

diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
index c755e49..cad76d6 100644
--- a/include/linux/netfilter_bridge.h
+++ b/include/linux/netfilter_bridge.h
@@ -81,14 +81,67 @@ static inline unsigned int nf_bridge_mtu_reduction(const struct sk_buff *skb)
 	return 0;
 }
 
+static inline struct nf_bridge_info *nf_bridge_alloc(struct sk_buff *skb)
+{
+	struct nf_bridge_info *nf_bridge;
+
+	nf_bridge = kzalloc(sizeof(struct nf_bridge_info), GFP_ATOMIC);
+	if (nf_bridge == NULL)
+		return NULL;
+
+	atomic_set(&nf_bridge->use, 1);
+
+	return nf_bridge;
+}
+
+static inline struct nf_bridge_info *nf_bridge_unshare(struct sk_buff *skb)
+{
+	if (atomic_read(&skb->nf_bridge->use) > 1) {
+		struct nf_bridge_info *clone = nf_bridge_alloc(skb);
+
+		if (clone) {
+			memcpy(clone, skb->nf_bridge,
+			       sizeof(struct nf_bridge_info));
+			atomic_set(&clone->use, 1);
+		}
+		nf_bridge_put(skb->nf_bridge);
+		return clone;
+	}
+	return skb->nf_bridge;
+}
+
+static inline struct nf_bridge_info *
+nf_bridge_set_mask(struct sk_buff *skb, unsigned int mask)
+{
+	if (!nf_bridge_unshare(skb))
+		return NULL;
+
+	skb->nf_bridge->mask |= mask;
+	return skb->nf_bridge;
+}
+
+static inline struct nf_bridge_info *
+nf_bridge_unset_mask(struct sk_buff *skb, unsigned int mask)
+{
+	if (!nf_bridge_unshare(skb))
+		return NULL;
+
+	skb->nf_bridge->mask &= ~mask;
+	return skb->nf_bridge;
+}
+
 int br_handle_frame_finish(struct sk_buff *skb);
 /* Only used in br_device.c */
 static inline int br_nf_pre_routing_finish_bridge_slow(struct sk_buff *skb)
 {
-	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
+	struct nf_bridge_info *nf_bridge;
 
 	skb_pull(skb, ETH_HLEN);
-	nf_bridge->mask ^= BRNF_BRIDGED_DNAT;
+	nf_bridge = nf_bridge_unset_mask(skb, BRNF_BRIDGED_DNAT);
+	if (nf_bridge == NULL) {
+		kfree_skb(skb);
+		return 0;
+	}
 	skb_copy_to_linear_data_offset(skb, -(ETH_HLEN-ETH_ALEN),
 				       skb->nf_bridge->data, ETH_HLEN-ETH_ALEN);
 	skb->dev = nf_bridge->physindev;
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index f81dc33..4647cd2 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -128,32 +128,6 @@ static inline struct net_device *bridge_parent(const struct net_device *dev)
 	return port ? port->br->dev : NULL;
 }
 
-static inline struct nf_bridge_info *nf_bridge_alloc(struct sk_buff *skb)
-{
-	skb->nf_bridge = kzalloc(sizeof(struct nf_bridge_info), GFP_ATOMIC);
-	if (likely(skb->nf_bridge))
-		atomic_set(&(skb->nf_bridge->use), 1);
-
-	return skb->nf_bridge;
-}
-
-static inline struct nf_bridge_info *nf_bridge_unshare(struct sk_buff *skb)
-{
-	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
-
-	if (atomic_read(&nf_bridge->use) > 1) {
-		struct nf_bridge_info *tmp = nf_bridge_alloc(skb);
-
-		if (tmp) {
-			memcpy(tmp, nf_bridge, sizeof(struct nf_bridge_info));
-			atomic_set(&tmp->use, 1);
-		}
-		nf_bridge_put(nf_bridge);
-		nf_bridge = tmp;
-	}
-	return nf_bridge;
-}
-
 static inline void nf_bridge_push_encap_header(struct sk_buff *skb)
 {
 	unsigned int len = nf_bridge_encap_header_len(skb);
@@ -253,25 +227,43 @@ drop:
 	return -1;
 }
 
+static inline struct nf_bridge_info *nf_br_mangle_pkttype(struct sk_buff *skb)
+{
+	if (skb->pkt_type != PACKET_OTHERHOST)
+		return skb->nf_bridge;
+
+	skb->pkt_type = PACKET_HOST;
+	return nf_bridge_set_mask(skb, BRNF_PKT_TYPE);
+}
+
+static inline struct nf_bridge_info *nf_br_restore_pkttype(struct sk_buff *skb)
+{
+	if (skb->nf_bridge->mask & BRNF_PKT_TYPE) {
+		skb->pkt_type = PACKET_OTHERHOST;
+		return nf_bridge_unset_mask(skb, BRNF_PKT_TYPE);
+	}
+
+	return skb->nf_bridge;
+}
+
 /* PF_BRIDGE/PRE_ROUTING *********************************************/
 /* Undo the changes made for ip6tables PREROUTING and continue the
  * bridge PRE_ROUTING hook. */
 static int br_nf_pre_routing_finish_ipv6(struct sk_buff *skb)
 {
-	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
+	struct nf_bridge_info *nf_bridge;
 	struct rtable *rt;
 
-	if (nf_bridge->mask & BRNF_PKT_TYPE) {
-		skb->pkt_type = PACKET_OTHERHOST;
-		nf_bridge->mask ^= BRNF_PKT_TYPE;
-	}
-	nf_bridge->mask ^= BRNF_NF_BRIDGE_PREROUTING;
+	nf_bridge = nf_br_restore_pkttype(skb);
+	if (nf_bridge == NULL)
+		goto drop;
+
+	nf_bridge->mask &= ~BRNF_NF_BRIDGE_PREROUTING;
 
 	rt = bridge_parent_rtable(nf_bridge->physindev);
-	if (!rt) {
-		kfree_skb(skb);
-		return 0;
-	}
+	if (!rt)
+		goto drop;
+
 	skb_dst_set_noref(skb, &rt->dst);
 
 	skb->dev = nf_bridge->physindev;
@@ -279,7 +271,9 @@ static int br_nf_pre_routing_finish_ipv6(struct sk_buff *skb)
 	nf_bridge_push_encap_header(skb);
 	NF_HOOK_THRESH(NFPROTO_BRIDGE, NF_BR_PRE_ROUTING, skb, skb->dev, NULL,
 		       br_handle_frame_finish, 1);
-
+	return 0;
+drop:
+	kfree_skb(skb);
 	return 0;
 }
 
@@ -300,7 +294,7 @@ static int br_nf_pre_routing_finish_bridge(struct sk_buff *skb)
 	dst = skb_dst(skb);
 	neigh = dst_neigh_lookup_skb(dst, skb);
 	if (neigh) {
-		int ret;
+		int ret = 0;
 
 		if (neigh->hh.hh_len) {
 			neigh_hh_bridge(&neigh->hh, skb);
@@ -317,8 +311,12 @@ static int br_nf_pre_routing_finish_bridge(struct sk_buff *skb)
 							 ETH_HLEN-ETH_ALEN);
 			/* tell br_dev_xmit to continue with forwarding */
 			nf_bridge->mask |= BRNF_BRIDGED_DNAT;
-			/* FIXME Need to refragment */
-			ret = neigh->output(neigh, skb);
+			if (!nf_bridge_set_mask(skb, BRNF_BRIDGED_DNAT)) {
+				kfree_skb(skb);
+			} else {
+				/* FIXME Need to refragment */
+				ret = neigh->output(neigh, skb);
+			}
 		}
 		neigh_release(neigh);
 		return ret;
@@ -370,7 +368,7 @@ static int br_nf_pre_routing_finish(struct sk_buff *skb)
 {
 	struct net_device *dev = skb->dev;
 	struct iphdr *iph = ip_hdr(skb);
-	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
+	struct nf_bridge_info *nf_bridge;
 	struct rtable *rt;
 	int err;
 	int frag_max_size;
@@ -378,11 +376,12 @@ static int br_nf_pre_routing_finish(struct sk_buff *skb)
 	frag_max_size = IPCB(skb)->frag_max_size;
 	BR_INPUT_SKB_CB(skb)->frag_max_size = frag_max_size;
 
-	if (nf_bridge->mask & BRNF_PKT_TYPE) {
-		skb->pkt_type = PACKET_OTHERHOST;
-		nf_bridge->mask ^= BRNF_PKT_TYPE;
-	}
-	nf_bridge->mask ^= BRNF_NF_BRIDGE_PREROUTING;
+	nf_bridge = nf_br_restore_pkttype(skb);
+	if (nf_bridge == NULL)
+		goto free_skb;
+
+	nf_bridge->mask &= ~BRNF_NF_BRIDGE_PREROUTING;
+
 	if (dnat_took_place(skb)) {
 		if ((err = ip_route_input(skb, iph->daddr, iph->saddr, iph->tos, dev))) {
 			struct in_device *in_dev = __in_dev_get_rcu(dev);
@@ -462,13 +461,9 @@ static struct net_device *brnf_get_logical_dev(struct sk_buff *skb, const struct
 /* Some common code for IPv4/IPv6 */
 static struct net_device *setup_pre_routing(struct sk_buff *skb)
 {
-	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
-
-	if (skb->pkt_type == PACKET_OTHERHOST) {
-		skb->pkt_type = PACKET_HOST;
-		nf_bridge->mask |= BRNF_PKT_TYPE;
-	}
+	struct nf_bridge_info *nf_bridge;
 
+	nf_bridge = nf_br_mangle_pkttype(skb);
 	nf_bridge->mask |= BRNF_NF_BRIDGE_PREROUTING;
 	nf_bridge->physindev = skb->dev;
 	skb->dev = brnf_get_logical_dev(skb, skb->dev);
@@ -571,7 +566,8 @@ static unsigned int br_nf_pre_routing_ipv6(const struct nf_hook_ops *ops,
 		return NF_DROP;
 
 	nf_bridge_put(skb->nf_bridge);
-	if (!nf_bridge_alloc(skb))
+	skb->nf_bridge = nf_bridge_alloc(skb);
+	if (skb->nf_bridge == NULL)
 		return NF_DROP;
 	if (!setup_pre_routing(skb))
 		return NF_DROP;
@@ -627,7 +623,8 @@ static unsigned int br_nf_pre_routing(const struct nf_hook_ops *ops,
 		return NF_DROP;
 
 	nf_bridge_put(skb->nf_bridge);
-	if (!nf_bridge_alloc(skb))
+	skb->nf_bridge = nf_bridge_alloc(skb);
+	if (skb->nf_bridge == NULL)
 		return NF_DROP;
 	if (!setup_pre_routing(skb))
 		return NF_DROP;
@@ -666,10 +663,11 @@ static int br_nf_forward_finish(struct sk_buff *skb)
 
 	if (!IS_ARP(skb) && !IS_VLAN_ARP(skb)) {
 		in = nf_bridge->physindev;
-		if (nf_bridge->mask & BRNF_PKT_TYPE) {
-			skb->pkt_type = PACKET_OTHERHOST;
-			nf_bridge->mask ^= BRNF_PKT_TYPE;
-		}
+
+		nf_bridge = nf_br_restore_pkttype(skb);
+		if (nf_bridge == NULL)
+			return 0;
+
 		nf_bridge_update_protocol(skb);
 	} else {
 		in = *((struct net_device **)(skb->cb));
@@ -700,11 +698,6 @@ static unsigned int br_nf_forward_ip(const struct nf_hook_ops *ops,
 	if (!skb->nf_bridge)
 		return NF_ACCEPT;
 
-	/* Need exclusive nf_bridge_info since we might have multiple
-	 * different physoutdevs. */
-	if (!nf_bridge_unshare(skb))
-		return NF_DROP;
-
 	parent = bridge_parent(out);
 	if (!parent)
 		return NF_DROP;
@@ -718,13 +711,9 @@ static unsigned int br_nf_forward_ip(const struct nf_hook_ops *ops,
 
 	nf_bridge_pull_encap_header(skb);
 
-	nf_bridge = skb->nf_bridge;
-	if (skb->pkt_type == PACKET_OTHERHOST) {
-		skb->pkt_type = PACKET_HOST;
-		nf_bridge->mask |= BRNF_PKT_TYPE;
-	}
-
-	if (pf == NFPROTO_IPV4 && br_parse_ip_options(skb))
+	nf_bridge = nf_br_mangle_pkttype(skb);
+	if (nf_bridge == NULL ||
+	    (pf == NFPROTO_IPV4 && br_parse_ip_options(skb)))
 		return NF_DROP;
 
 	/* The physdev module checks on this */
@@ -833,10 +822,8 @@ static unsigned int br_nf_post_routing(const struct nf_hook_ops *ops,
 
 	/* We assume any code from br_dev_queue_push_xmit onwards doesn't care
 	 * about the value of skb->pkt_type. */
-	if (skb->pkt_type == PACKET_OTHERHOST) {
-		skb->pkt_type = PACKET_HOST;
-		nf_bridge->mask |= BRNF_PKT_TYPE;
-	}
+	if (nf_br_mangle_pkttype(skb) == NULL)
+		return NF_DROP;
 
 	nf_bridge_pull_encap_header(skb);
 	nf_bridge_save_header(skb);
-- 
1.7.10.4


--tKW2IUtsqtDRztdT--
