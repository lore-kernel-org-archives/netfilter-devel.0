From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next,RFC 05/13] netfilter: add early ingress hook for IPv4
Date: Thu, 14 Jun 2018 16:19:39 +0200
Message-ID: <20180614141947.3580-6-pablo@netfilter.org>
References: <20180614141947.3580-1-pablo@netfilter.org>
Cc: netdev@vger.kernel.org, steffen.klassert@secunet.com
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180614141947.3580-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>

Add the new early ingress hook for the netdev family, this new hook is
called from the GRO layer before the standard ipv4 GRO layers.

This hook allows us to perform early packet filtering and to define fast
forwarding path through packet chaining and flowtables using the new GSO
netfilter type. Packet that don't follow the fast path are passed up to
the standard GRO path for aggregation as usual.

This patch adds the GRO and GSO logic for this custom packet chaining.
The chaining uses the frag_list pointer so this means we do not need to
mangle the packets, therefore the aggregation strategy we follow does
not modify the packet as in the standard GRO path - we have no need to
recalculate checksum. This chain of packets is sent from the
.gro_complete callback directly to the neighbour layer. The first packet
in the chain holds a reference to the destination route.

Supported layer 4 protocols for this custom GRO packet chaining include
TCP and UDP.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netdevice.h             |   2 +
 include/linux/netfilter.h             |   6 +
 include/linux/netfilter_ingress.h     |   1 +
 include/net/netfilter/early_ingress.h |  20 +++
 include/uapi/linux/netfilter.h        |   1 +
 net/ipv4/netfilter/Makefile           |   1 +
 net/ipv4/netfilter/early_ingress.c    | 319 +++++++++++++++++++++++++++++++++
 net/netfilter/Kconfig                 |   8 +
 net/netfilter/Makefile                |   1 +
 net/netfilter/core.c                  |  35 +++-
 net/netfilter/early_ingress.c         | 323 ++++++++++++++++++++++++++++++++++
 11 files changed, 716 insertions(+), 1 deletion(-)
 create mode 100644 include/net/netfilter/early_ingress.h
 create mode 100644 net/ipv4/netfilter/early_ingress.c
 create mode 100644 net/netfilter/early_ingress.c

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 62734cf0c43a..c79922665be5 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1880,6 +1880,8 @@ struct net_device {
 	rx_handler_func_t __rcu	*rx_handler;
 	void __rcu		*rx_handler_data;
 
+	struct nf_hook_entries __rcu *nf_hooks_early_ingress;
+
 #ifdef CONFIG_NET_CLS_ACT
 	struct mini_Qdisc __rcu	*miniq_ingress;
 #endif
diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 04551af2ff23..ad3f0b9ae4f1 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -429,4 +429,10 @@ extern struct nfnl_ct_hook __rcu *nfnl_ct_hook;
  */
 DECLARE_PER_CPU(bool, nf_skb_duplicated);
 
+int nf_hook_netdev(struct sk_buff *skb, struct nf_hook_state *state,
+		   const struct nf_hook_entries *e);
+
+void nf_early_ingress_enable(void);
+void nf_early_ingress_disable(void);
+
 #endif /*__LINUX_NETFILTER_H*/
diff --git a/include/linux/netfilter_ingress.h b/include/linux/netfilter_ingress.h
index 554c920691dd..7b70c9d4c435 100644
--- a/include/linux/netfilter_ingress.h
+++ b/include/linux/netfilter_ingress.h
@@ -40,6 +40,7 @@ static inline int nf_hook_ingress(struct sk_buff *skb)
 
 static inline void nf_hook_ingress_init(struct net_device *dev)
 {
+	RCU_INIT_POINTER(dev->nf_hooks_early_ingress, NULL);
 	RCU_INIT_POINTER(dev->nf_hooks_ingress, NULL);
 }
 #else /* CONFIG_NETFILTER_INGRESS */
diff --git a/include/net/netfilter/early_ingress.h b/include/net/netfilter/early_ingress.h
new file mode 100644
index 000000000000..caaef9fe619f
--- /dev/null
+++ b/include/net/netfilter/early_ingress.h
@@ -0,0 +1,20 @@
+#ifndef _NF_EARLY_INGRESS_H_
+#define _NF_EARLY_INGRESS_H_
+
+#include <net/protocol.h>
+
+struct sk_buff *nft_skb_segment(struct sk_buff *head_skb);
+struct sk_buff **nft_udp_gro_receive(struct sk_buff **head,
+				     struct sk_buff *skb);
+struct sk_buff **nft_tcp_gro_receive(struct sk_buff **head,
+				     struct sk_buff *skb);
+
+int nf_hook_early_ingress(struct sk_buff *skb);
+
+void nf_early_ingress_ip_enable(void);
+void nf_early_ingress_ip_disable(void);
+
+void nf_early_ingress_enable(void);
+void nf_early_ingress_disable(void);
+
+#endif
diff --git a/include/uapi/linux/netfilter.h b/include/uapi/linux/netfilter.h
index cca10e767cd8..55d26b20e09f 100644
--- a/include/uapi/linux/netfilter.h
+++ b/include/uapi/linux/netfilter.h
@@ -54,6 +54,7 @@ enum nf_inet_hooks {
 
 enum nf_dev_hooks {
 	NF_NETDEV_INGRESS,
+	NF_NETDEV_EARLY_INGRESS,
 	NF_NETDEV_NUMHOOKS
 };
 
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 8394c17c269f..faf5fab59f0f 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -2,6 +2,7 @@
 #
 # Makefile for the netfilter modules on top of IPv4.
 #
+obj-$(CONFIG_NETFILTER_EARLY_INGRESS) += early_ingress.o
 
 # objects for l3 independent conntrack
 nf_conntrack_ipv4-y	:=  nf_conntrack_l3proto_ipv4.o nf_conntrack_proto_icmp.o
diff --git a/net/ipv4/netfilter/early_ingress.c b/net/ipv4/netfilter/early_ingress.c
new file mode 100644
index 000000000000..6ff6e34e5eff
--- /dev/null
+++ b/net/ipv4/netfilter/early_ingress.c
@@ -0,0 +1,319 @@
+#include <linux/kernel.h>
+#include <linux/netfilter.h>
+#include <linux/types.h>
+#include <net/xfrm.h>
+#include <net/arp.h>
+#include <net/udp.h>
+#include <net/tcp.h>
+#include <net/protocol.h>
+#include <net/netfilter/early_ingress.h>
+
+static const struct net_offload __rcu *nft_ip_offloads[MAX_INET_PROTOS] __read_mostly;
+
+static struct sk_buff *nft_udp4_gso_segment(struct sk_buff *skb,
+					    netdev_features_t features)
+{
+	skb_push(skb, sizeof(struct iphdr));
+	return nft_skb_segment(skb);
+}
+
+static struct sk_buff *nft_tcp4_gso_segment(struct sk_buff *skb,
+					    netdev_features_t features)
+{
+	skb_push(skb, sizeof(struct iphdr));
+	return nft_skb_segment(skb);
+}
+
+static struct sk_buff *nft_ipv4_gso_segment(struct sk_buff *skb,
+					    netdev_features_t features)
+{
+	struct sk_buff *segs = ERR_PTR(-EINVAL);
+	const struct net_offload *ops;
+	struct packet_offload *ptype;
+	struct iphdr *iph;
+	int proto;
+	int ihl;
+
+	if (!(skb_shinfo(skb)->gso_type & SKB_GSO_NFT)) {
+		ptype = dev_get_packet_offload(skb->protocol, 1);
+		if (ptype)
+			return ptype->callbacks.gso_segment(skb, features);
+
+		return ERR_PTR(-EPROTONOSUPPORT);
+	}
+
+	if (SKB_GSO_CB(skb)->encap_level == 0) {
+		iph = ip_hdr(skb);
+		skb_reset_network_header(skb);
+	} else {
+		iph = (struct iphdr *)skb->data;
+	}
+
+	if (unlikely(!pskb_may_pull(skb, sizeof(*iph))))
+		goto out;
+
+	ihl = iph->ihl * 4;
+	if (ihl < sizeof(*iph))
+		goto out;
+
+	SKB_GSO_CB(skb)->encap_level += ihl;
+
+	if (unlikely(!pskb_may_pull(skb, ihl)))
+		goto out;
+
+	__skb_pull(skb, ihl);
+
+	proto = iph->protocol;
+
+	segs = ERR_PTR(-EPROTONOSUPPORT);
+
+	ops = rcu_dereference(nft_ip_offloads[proto]);
+	if (likely(ops && ops->callbacks.gso_segment))
+		segs = ops->callbacks.gso_segment(skb, features);
+
+out:
+	return segs;
+}
+
+static int nft_ipv4_gro_complete(struct sk_buff *skb, int nhoff)
+{
+	struct iphdr *iph = (struct iphdr *)(skb->data + nhoff);
+	struct dst_entry *dst = skb_dst(skb);
+	struct rtable *rt = (struct rtable *)dst;
+	const struct net_offload *ops;
+	struct packet_offload *ptype;
+	struct net_device *dev;
+	struct neighbour *neigh;
+	unsigned int hh_len;
+	int err = 0;
+	u32 nexthop;
+	u16 count;
+
+	count = NAPI_GRO_CB(skb)->count;
+
+	if (!NAPI_GRO_CB(skb)->is_ffwd) {
+		ptype = dev_get_packet_offload(skb->protocol, 1);
+		if (ptype)
+			return ptype->callbacks.gro_complete(skb, nhoff);
+
+		return 0;
+	}
+
+	rcu_read_lock();
+	ops = rcu_dereference(nft_ip_offloads[iph->protocol]);
+	if (!ops || !ops->callbacks.gro_complete)
+		goto out_unlock;
+
+	/* Only need to add sizeof(*iph) to get to the next hdr below
+	 * because any hdr with option will have been flushed in
+	 * inet_gro_receive().
+	 */
+	err = ops->callbacks.gro_complete(skb, nhoff + sizeof(*iph));
+
+out_unlock:
+	rcu_read_unlock();
+
+	if (err)
+		return err;
+
+	skb_shinfo(skb)->gso_type |= SKB_GSO_NFT;
+	skb_shinfo(skb)->gso_segs = count;
+
+	dev = dst->dev;
+	dev_hold(dev);
+	skb->dev = dev;
+
+	if (skb_dst(skb)->xfrm) {
+		err = dst_output(dev_net(dev), NULL, skb);
+		if (err != -EREMOTE)
+			return -EINPROGRESS;
+	}
+
+	if (count <= 1)
+		skb_gso_reset(skb);
+
+	hh_len = LL_RESERVED_SPACE(dev);
+
+	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
+		struct sk_buff *skb2;
+
+		skb2 = skb_realloc_headroom(skb, LL_RESERVED_SPACE(dev));
+		if (!skb2) {
+			kfree_skb(skb);
+			return -ENOMEM;
+		}
+		consume_skb(skb);
+		skb = skb2;
+	}
+	rcu_read_lock();
+	nexthop = (__force u32) rt_nexthop(rt, iph->daddr);
+	neigh = __ipv4_neigh_lookup_noref(dev, nexthop);
+	if (unlikely(!neigh))
+		neigh = __neigh_create(&arp_tbl, &nexthop, dev, false);
+	if (!IS_ERR(neigh))
+		neigh_output(neigh, skb);
+	rcu_read_unlock();
+
+	return -EINPROGRESS;
+}
+
+static struct sk_buff **nft_ipv4_gro_receive(struct sk_buff **head,
+					     struct sk_buff *skb)
+{
+	const struct net_offload *ops;
+	struct packet_offload *ptype;
+	struct sk_buff **pp = NULL;
+	struct sk_buff *p;
+	struct iphdr *iph;
+	unsigned int hlen;
+	unsigned int off;
+	int proto, ret;
+
+	off = skb_gro_offset(skb);
+	hlen = off + sizeof(*iph);
+
+	iph = skb_gro_header_slow(skb, hlen, off);
+	if (unlikely(!iph)) {
+		pp = ERR_PTR(-EPERM);
+		goto out;
+	}
+
+	proto = iph->protocol;
+
+	rcu_read_lock();
+
+	if (*(u8 *)iph != 0x45) {
+		kfree_skb(skb);
+		pp = ERR_PTR(-EPERM);
+		goto out_unlock;
+	}
+
+	if (unlikely(ip_fast_csum((u8 *)iph, 5))) {
+		kfree_skb(skb);
+		pp = ERR_PTR(-EPERM);
+		goto out_unlock;
+	}
+
+	if (ip_is_fragment(iph))
+		goto out_unlock;
+
+	ret = nf_hook_early_ingress(skb);
+	switch (ret) {
+	case NF_STOLEN:
+		break;
+	case NF_ACCEPT:
+		ptype = dev_get_packet_offload(skb->protocol, 1);
+		if (ptype)
+			pp = ptype->callbacks.gro_receive(head, skb);
+
+		goto out_unlock;
+	case NF_DROP:
+		pp = ERR_PTR(-EPERM);
+		goto out_unlock;
+	}
+
+	ops = rcu_dereference(nft_ip_offloads[proto]);
+	if (!ops || !ops->callbacks.gro_receive)
+		goto out_unlock;
+
+	if (iph->ttl <= 1) {
+		kfree_skb(skb);
+		pp = ERR_PTR(-EPERM);
+		goto out_unlock;
+	}
+
+	skb->ip_summed = CHECKSUM_UNNECESSARY;
+
+	for (p = *head; p; p = p->next) {
+		struct iphdr *iph2;
+
+		if (!NAPI_GRO_CB(p)->same_flow)
+			continue;
+
+		iph2 = ip_hdr(p);
+		/* The above works because, with the exception of the top
+		 * (inner most) layer, we only aggregate pkts with the same
+		 * hdr length so all the hdrs we'll need to verify will start
+		 * at the same offset.
+		 */
+		if ((iph->protocol ^ iph2->protocol) |
+		    ((__force u32)iph->saddr ^ (__force u32)iph2->saddr) |
+		    ((__force u32)iph->daddr ^ (__force u32)iph2->daddr)) {
+			NAPI_GRO_CB(p)->same_flow = 0;
+			continue;
+		}
+
+		if (!NAPI_GRO_CB(p)->is_ffwd)
+			continue;
+
+		if (!skb_dst(p))
+			continue;
+
+		/* All fields must match except length and checksum. */
+		NAPI_GRO_CB(p)->flush |=
+			((iph->ttl - 1) ^ iph2->ttl) |
+			(iph->tos ^ iph2->tos) |
+			((iph->frag_off ^ iph2->frag_off) & htons(IP_DF));
+
+		pp = &p;
+
+		break;
+	}
+
+	NAPI_GRO_CB(skb)->is_atomic = !!(iph->frag_off & htons(IP_DF));
+
+	ip_decrease_ttl(iph);
+	skb->priority = rt_tos2priority(iph->tos);
+
+	skb_pull(skb, off);
+	NAPI_GRO_CB(skb)->data_offset = sizeof(*iph);
+	skb_reset_network_header(skb);
+	skb_set_transport_header(skb, sizeof(*iph));
+
+	pp = call_gro_receive(ops->callbacks.gro_receive, head, skb);
+out_unlock:
+	rcu_read_unlock();
+
+out:
+	NAPI_GRO_CB(skb)->data_offset = 0;
+	return pp;
+}
+
+static struct packet_offload nft_ipv4_packet_offload __read_mostly = {
+	.type = cpu_to_be16(ETH_P_IP),
+	.priority = 0,
+	.callbacks = {
+		.gro_receive = nft_ipv4_gro_receive,
+		.gro_complete = nft_ipv4_gro_complete,
+		.gso_segment = nft_ipv4_gso_segment,
+	},
+};
+
+static const struct net_offload nft_udp4_offload = {
+	.callbacks = {
+		.gso_segment = nft_udp4_gso_segment,
+		.gro_receive  =	nft_udp_gro_receive,
+	},
+};
+
+static const struct net_offload nft_tcp4_offload = {
+	.callbacks = {
+		.gso_segment = nft_tcp4_gso_segment,
+		.gro_receive  =	nft_tcp_gro_receive,
+	},
+};
+
+static const struct net_offload __rcu *nft_ip_offloads[MAX_INET_PROTOS] __read_mostly = {
+	[IPPROTO_UDP]	= &nft_udp4_offload,
+	[IPPROTO_TCP]	= &nft_tcp4_offload,
+};
+
+void nf_early_ingress_ip_enable(void)
+{
+	dev_add_offload(&nft_ipv4_packet_offload);
+}
+
+void nf_early_ingress_ip_disable(void)
+{
+	dev_remove_offload(&nft_ipv4_packet_offload);
+}
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index dbd7d1fad277..8f803a1fd76e 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -9,6 +9,14 @@ config NETFILTER_INGRESS
 	  This allows you to classify packets from ingress using the Netfilter
 	  infrastructure.
 
+config NETFILTER_EARLY_INGRESS
+	bool "Netfilter early ingress support"
+	default y
+	help
+	  This allows you to perform very early filtering and packet aggregation
+	  for fast forwarding bypass by exercising the GRO engine from the
+	  Netfilter infrastructure.
+
 config NETFILTER_NETLINK
 	tristate
 
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 44449389e527..eebc0e35f9e5 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 netfilter-objs := core.o nf_log.o nf_queue.o nf_sockopt.o utils.o
+netfilter-$(CONFIG_NETFILTER_EARLY_INGRESS) += early_ingress.o
 
 nf_conntrack-y	:= nf_conntrack_core.o nf_conntrack_standalone.o nf_conntrack_expect.o nf_conntrack_helper.o nf_conntrack_proto.o nf_conntrack_l3proto_generic.o nf_conntrack_proto_generic.o nf_conntrack_proto_tcp.o nf_conntrack_proto_udp.o nf_conntrack_extend.o nf_conntrack_acct.o nf_conntrack_seqadj.o
 nf_conntrack-$(CONFIG_NF_CONNTRACK_TIMEOUT) += nf_conntrack_timeout.o
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 168af54db975..4885365380d3 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -306,6 +306,11 @@ nf_hook_entry_head(struct net *net, int pf, unsigned int hooknum,
 			return &dev->nf_hooks_ingress;
 	}
 #endif
+	if (hooknum == NF_NETDEV_EARLY_INGRESS) {
+		if (dev && dev_net(dev) == net)
+			return &dev->nf_hooks_early_ingress;
+	}
+
 	WARN_ON_ONCE(1);
 	return NULL;
 }
@@ -321,7 +326,8 @@ static int __nf_register_net_hook(struct net *net, int pf,
 		if (reg->hooknum == NF_NETDEV_INGRESS)
 			return -EOPNOTSUPP;
 #endif
-		if (reg->hooknum != NF_NETDEV_INGRESS ||
+		if ((reg->hooknum != NF_NETDEV_INGRESS &&
+		     reg->hooknum != NF_NETDEV_EARLY_INGRESS) ||
 		    !reg->dev || dev_net(reg->dev) != net)
 			return -EINVAL;
 	}
@@ -347,6 +353,9 @@ static int __nf_register_net_hook(struct net *net, int pf,
 	if (pf == NFPROTO_NETDEV && reg->hooknum == NF_NETDEV_INGRESS)
 		net_inc_ingress_queue();
 #endif
+	if (pf == NFPROTO_NETDEV && reg->hooknum == NF_NETDEV_EARLY_INGRESS)
+		nf_early_ingress_enable();
+
 #ifdef HAVE_JUMP_LABEL
 	static_key_slow_inc(&nf_hooks_needed[pf][reg->hooknum]);
 #endif
@@ -404,6 +413,9 @@ static void __nf_unregister_net_hook(struct net *net, int pf,
 #ifdef CONFIG_NETFILTER_INGRESS
 		if (pf == NFPROTO_NETDEV && reg->hooknum == NF_NETDEV_INGRESS)
 			net_dec_ingress_queue();
+
+		if (pf == NFPROTO_NETDEV && reg->hooknum == NF_NETDEV_EARLY_INGRESS)
+			nf_early_ingress_disable();
 #endif
 #ifdef HAVE_JUMP_LABEL
 		static_key_slow_dec(&nf_hooks_needed[pf][reg->hooknum]);
@@ -535,6 +547,27 @@ int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state,
 }
 EXPORT_SYMBOL(nf_hook_slow);
 
+int nf_hook_netdev(struct sk_buff *skb, struct nf_hook_state *state,
+		   const struct nf_hook_entries *e)
+{
+	unsigned int verdict, s, v = NF_ACCEPT;
+
+	for (s = 0; s < e->num_hook_entries; s++) {
+		verdict = nf_hook_entry_hookfn(&e->hooks[s], skb, state);
+		v = verdict & NF_VERDICT_MASK;
+		switch (v) {
+		case NF_ACCEPT:
+			break;
+		case NF_DROP:
+			kfree_skb(skb);
+			/* Fall through */
+		default:
+			return v;
+		}
+	}
+
+	return v;
+}
 
 int skb_make_writable(struct sk_buff *skb, unsigned int writable_len)
 {
diff --git a/net/netfilter/early_ingress.c b/net/netfilter/early_ingress.c
new file mode 100644
index 000000000000..bf31aa8b3721
--- /dev/null
+++ b/net/netfilter/early_ingress.c
@@ -0,0 +1,323 @@
+#include <linux/kernel.h>
+#include <linux/netfilter.h>
+#include <linux/types.h>
+#include <net/xfrm.h>
+#include <net/arp.h>
+#include <net/udp.h>
+#include <net/tcp.h>
+#include <net/protocol.h>
+#include <crypto/aead.h>
+#include <net/netfilter/early_ingress.h>
+
+/* XXX: Maybe export this from net/core/skbuff.c
+ * instead of holding a local copy */
+static void skb_headers_offset_update(struct sk_buff *skb, int off)
+{
+	/* Only adjust this if it actually is csum_start rather than csum */
+	if (skb->ip_summed == CHECKSUM_PARTIAL)
+		skb->csum_start += off;
+	/* {transport,network,mac}_header and tail are relative to skb->head */
+	skb->transport_header += off;
+	skb->network_header   += off;
+	if (skb_mac_header_was_set(skb))
+		skb->mac_header += off;
+	skb->inner_transport_header += off;
+	skb->inner_network_header += off;
+	skb->inner_mac_header += off;
+}
+
+struct sk_buff *nft_skb_segment(struct sk_buff *head_skb)
+{
+	unsigned int headroom;
+	struct sk_buff *nskb;
+	struct sk_buff *segs = NULL;
+	struct sk_buff *tail = NULL;
+	unsigned int doffset = head_skb->data - skb_mac_header(head_skb);
+	struct sk_buff *list_skb = skb_shinfo(head_skb)->frag_list;
+	unsigned int tnl_hlen = skb_tnl_header_len(head_skb);
+	unsigned int delta_segs, delta_len, delta_truesize;
+
+	__skb_push(head_skb, doffset);
+
+	headroom = skb_headroom(head_skb);
+
+	delta_segs = delta_len = delta_truesize = 0;
+
+	skb_shinfo(head_skb)->frag_list = NULL;
+
+	segs = skb_clone(head_skb, GFP_ATOMIC);
+	if (unlikely(!segs))
+		return ERR_PTR(-ENOMEM);
+
+	do {
+		nskb = list_skb;
+
+		list_skb = list_skb->next;
+
+		if (!tail)
+			segs->next = nskb;
+		else
+			tail->next = nskb;
+
+		tail = nskb;
+
+		delta_len += nskb->len;
+		delta_truesize += nskb->truesize;
+
+		skb_push(nskb, doffset);
+
+		nskb->dev = head_skb->dev;
+		nskb->queue_mapping = head_skb->queue_mapping;
+		nskb->network_header = head_skb->network_header;
+		nskb->mac_len = head_skb->mac_len;
+		nskb->mac_header = head_skb->mac_header;
+		nskb->transport_header = head_skb->transport_header;
+
+		if (!secpath_exists(nskb))
+			nskb->sp = secpath_get(head_skb->sp);
+
+		skb_headers_offset_update(nskb, skb_headroom(nskb) - headroom);
+
+		skb_copy_from_linear_data_offset(head_skb, -tnl_hlen,
+						 nskb->data - tnl_hlen,
+						 doffset + tnl_hlen);
+
+	} while (list_skb);
+
+	segs->len = head_skb->len - delta_len;
+	segs->data_len = head_skb->data_len - delta_len;
+	segs->truesize += head_skb->data_len - delta_truesize;
+
+	head_skb->len = segs->len;
+	head_skb->data_len = segs->data_len;
+	head_skb->truesize += segs->truesize;
+
+	skb_shinfo(segs)->gso_size = 0;
+	skb_shinfo(segs)->gso_segs = 0;
+	skb_shinfo(segs)->gso_type = 0;
+
+	segs->prev = tail;
+
+	return segs;
+}
+
+static int nft_skb_gro_receive(struct sk_buff **head, struct sk_buff *skb)
+{
+	struct sk_buff *p = *head;
+
+	if (unlikely((!NAPI_GRO_CB(p)->is_ffwd) || !skb_dst(p)))
+		return -EINVAL;
+
+	if (NAPI_GRO_CB(p)->last == p)
+		skb_shinfo(p)->frag_list = skb;
+	else
+		NAPI_GRO_CB(p)->last->next = skb;
+	NAPI_GRO_CB(p)->last = skb;
+
+	NAPI_GRO_CB(p)->count++;
+	p->data_len += skb->len;
+	p->truesize += skb->truesize;
+	p->len += skb->len;
+
+	NAPI_GRO_CB(skb)->same_flow = 1;
+	return 0;
+}
+
+static struct sk_buff **udp_gro_ffwd_receive(struct sk_buff **head,
+					     struct sk_buff *skb,
+					     struct udphdr *uh)
+{
+	struct sk_buff *p = NULL;
+	struct sk_buff **pp = NULL;
+	struct udphdr *uh2;
+	int flush = 0;
+
+	for (; (p = *head); head = &p->next) {
+
+		if (!NAPI_GRO_CB(p)->same_flow)
+			continue;
+
+		uh2 = udp_hdr(p);
+
+		/* Match ports and either checksums are either both zero
+		 * or nonzero.
+		 */
+		if ((*(u32 *)&uh->source != *(u32 *)&uh2->source) ||
+		    (!uh->check ^ !uh2->check)) {
+			NAPI_GRO_CB(p)->same_flow = 0;
+			continue;
+		}
+
+		goto found;
+	}
+
+	goto out;
+
+found:
+	p = *head;
+
+	if (nft_skb_gro_receive(head, skb))
+		flush = 1;
+
+out:
+	if (p && (!NAPI_GRO_CB(skb)->same_flow || flush))
+		pp = head;
+
+	NAPI_GRO_CB(skb)->flush |= flush;
+	return pp;
+}
+
+struct sk_buff **nft_udp_gro_receive(struct sk_buff **head, struct sk_buff *skb)
+{
+	struct udphdr *uh;
+
+	uh = skb_gro_header_slow(skb, skb_transport_offset(skb) + sizeof(struct udphdr),
+				 skb_transport_offset(skb));
+
+	if (unlikely(!uh))
+		goto flush;
+
+	if (NAPI_GRO_CB(skb)->flush)
+		goto flush;
+
+	if (NAPI_GRO_CB(skb)->is_ffwd)
+		return udp_gro_ffwd_receive(head, skb, uh);
+
+flush:
+	NAPI_GRO_CB(skb)->flush = 1;
+	return NULL;
+}
+
+struct sk_buff **nft_tcp_gro_receive(struct sk_buff **head, struct sk_buff *skb)
+{
+	struct sk_buff **pp = NULL;
+	struct sk_buff *p;
+	struct tcphdr *th;
+	struct tcphdr *th2;
+	unsigned int len;
+	unsigned int thlen;
+	__be32 flags;
+	unsigned int mss = 1;
+	unsigned int hlen;
+	int flush = 1;
+	int i;
+
+	th = skb_gro_header_slow(skb, skb_transport_offset(skb) + sizeof(struct tcphdr),
+				 skb_transport_offset(skb));
+	if (unlikely(!th))
+		goto out;
+
+	thlen = th->doff * 4;
+	if (thlen < sizeof(*th))
+		goto out;
+
+	hlen = skb_transport_offset(skb) + thlen;
+
+	th = skb_gro_header_slow(skb, hlen, skb_transport_offset(skb));
+	if (unlikely(!th))
+		goto out;
+
+	skb_gro_pull(skb, thlen);
+	len = skb_gro_len(skb);
+	flags = tcp_flag_word(th);
+
+	for (; (p = *head); head = &p->next) {
+		if (!NAPI_GRO_CB(p)->same_flow)
+			continue;
+
+		th2 = tcp_hdr(p);
+
+		if (*(u32 *)&th->source ^ *(u32 *)&th2->source) {
+			NAPI_GRO_CB(p)->same_flow = 0;
+			continue;
+		}
+
+		goto found;
+	}
+
+	goto out_check_final;
+
+found:
+	flush = NAPI_GRO_CB(p)->flush;
+	flush |= (__force int)(flags & TCP_FLAG_CWR);
+	flush |= (__force int)((flags ^ tcp_flag_word(th2)) &
+		  ~(TCP_FLAG_CWR | TCP_FLAG_FIN | TCP_FLAG_PSH));
+	flush |= (__force int)(th->ack_seq ^ th2->ack_seq);
+	for (i = sizeof(*th); i < thlen; i += 4)
+		flush |= *(u32 *)((u8 *)th + i) ^
+			 *(u32 *)((u8 *)th2 + i);
+
+	mss = skb_shinfo(p)->gso_size;
+
+	flush |= (len - 1) >= mss;
+	flush |= (ntohl(th2->seq) + (skb_gro_len(p) - (hlen * (NAPI_GRO_CB(p)->count - 1)))) ^ ntohl(th->seq);
+
+	if (flush || nft_skb_gro_receive(head, skb)) {
+		mss = 1;
+		goto out_check_final;
+	}
+
+	p = *head;
+
+out_check_final:
+	flush = len < mss;
+	flush |= (__force int)(flags & (TCP_FLAG_URG | TCP_FLAG_PSH |
+					TCP_FLAG_RST | TCP_FLAG_SYN |
+					TCP_FLAG_FIN));
+
+	if (p && (!NAPI_GRO_CB(skb)->same_flow || flush))
+		pp = head;
+
+out:
+	NAPI_GRO_CB(skb)->flush |= (flush != 0);
+
+	return pp;
+}
+
+static inline bool nf_hook_early_ingress_active(const struct sk_buff *skb)
+{
+#ifdef HAVE_JUMP_LABEL
+	if (!static_key_false(&nf_hooks_needed[NFPROTO_NETDEV][NF_NETDEV_EARLY_INGRESS]))
+		return false;
+#endif
+	return rcu_access_pointer(skb->dev->nf_hooks_early_ingress);
+}
+
+int nf_hook_early_ingress(struct sk_buff *skb)
+{
+	struct nf_hook_entries *e =
+		rcu_dereference(skb->dev->nf_hooks_early_ingress);
+	struct nf_hook_state state;
+	int ret = NF_ACCEPT;
+
+	if (nf_hook_early_ingress_active(skb)) {
+		if (unlikely(!e))
+			return 0;
+
+		nf_hook_state_init(&state, NF_NETDEV_EARLY_INGRESS,
+				   NFPROTO_NETDEV, skb->dev, NULL, NULL,
+				   dev_net(skb->dev), NULL);
+
+		ret = nf_hook_netdev(skb, &state, e);
+	}
+
+	return ret;
+}
+
+/* protected by nf_hook_mutex. */
+static int nf_early_ingress_use;
+
+void nf_early_ingress_enable(void)
+{
+	if (nf_early_ingress_use++ == 0) {
+		nf_early_ingress_use++;
+		nf_early_ingress_ip_enable();
+	}
+}
+
+void nf_early_ingress_disable(void)
+{
+	if (--nf_early_ingress_use == 0) {
+		nf_early_ingress_ip_disable();
+	}
+}
-- 
2.11.0
