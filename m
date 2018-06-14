From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next,RFC 06/13] netfilter: add early ingress support for IPv6
Date: Thu, 14 Jun 2018 16:19:40 +0200
Message-ID: <20180614141947.3580-7-pablo@netfilter.org>
References: <20180614141947.3580-1-pablo@netfilter.org>
Cc: netdev@vger.kernel.org, steffen.klassert@secunet.com
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180614141947.3580-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>

This patch adds the custom GSO and GRO logic for the IPv6 early ingress
hook. Layer 4 supports UDP and TCP at this stage.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/early_ingress.h |   2 +
 net/ipv6/netfilter/Makefile           |   1 +
 net/ipv6/netfilter/early_ingress.c    | 307 ++++++++++++++++++++++++++++++++++
 net/netfilter/early_ingress.c         |   2 +
 4 files changed, 312 insertions(+)
 create mode 100644 net/ipv6/netfilter/early_ingress.c

diff --git a/include/net/netfilter/early_ingress.h b/include/net/netfilter/early_ingress.h
index caaef9fe619f..9ba8e2875345 100644
--- a/include/net/netfilter/early_ingress.h
+++ b/include/net/netfilter/early_ingress.h
@@ -13,6 +13,8 @@ int nf_hook_early_ingress(struct sk_buff *skb);
 
 void nf_early_ingress_ip_enable(void);
 void nf_early_ingress_ip_disable(void);
+void nf_early_ingress_ip6_enable(void);
+void nf_early_ingress_ip6_disable(void);
 
 void nf_early_ingress_enable(void);
 void nf_early_ingress_disable(void);
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index 10a5a1c87320..445dfcf51ca8 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -2,6 +2,7 @@
 #
 # Makefile for the netfilter modules on top of IPv6.
 #
+obj-$(CONFIG_NETFILTER_EARLY_INGRESS) += early_ingress.o
 
 # Link order matters here.
 obj-$(CONFIG_IP6_NF_IPTABLES) += ip6_tables.o
diff --git a/net/ipv6/netfilter/early_ingress.c b/net/ipv6/netfilter/early_ingress.c
new file mode 100644
index 000000000000..026d2814530a
--- /dev/null
+++ b/net/ipv6/netfilter/early_ingress.c
@@ -0,0 +1,307 @@
+#include <linux/kernel.h>
+#include <linux/netfilter.h>
+#include <linux/types.h>
+#include <net/xfrm.h>
+#include <net/arp.h>
+#include <net/udp.h>
+#include <net/tcp.h>
+#include <net/protocol.h>
+#include <net/netfilter/early_ingress.h>
+#include <net/ip6_route.h>
+
+static const struct net_offload __rcu *nft_ip6_offloads[MAX_INET_PROTOS] __read_mostly;
+
+static struct sk_buff *nft_udp6_gso_segment(struct sk_buff *skb,
+					    netdev_features_t features)
+{
+	skb_push(skb, sizeof(struct ipv6hdr));
+	return nft_skb_segment(skb);
+}
+
+static struct sk_buff *nft_tcp6_gso_segment(struct sk_buff *skb,
+					    netdev_features_t features)
+{
+	skb_push(skb, sizeof(struct ipv6hdr));
+	return nft_skb_segment(skb);
+}
+
+static struct sk_buff *nft_ipv6_gso_segment(struct sk_buff *skb,
+					    netdev_features_t features)
+{
+	struct sk_buff *segs = ERR_PTR(-EINVAL);
+	const struct net_offload *ops;
+	struct packet_offload *ptype;
+	struct ipv6hdr *iph;
+	int proto;
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
+		iph = ipv6_hdr(skb);
+		skb_reset_network_header(skb);
+	} else {
+		iph = (struct ipv6hdr *)skb->data;
+	}
+
+	if (unlikely(!pskb_may_pull(skb, sizeof(*iph))))
+		goto out;
+
+	SKB_GSO_CB(skb)->encap_level += sizeof(*iph);
+
+	if (unlikely(!pskb_may_pull(skb, sizeof(*iph))))
+		goto out;
+
+	__skb_pull(skb, sizeof(*iph));
+
+	proto = iph->nexthdr;
+
+	segs = ERR_PTR(-EPROTONOSUPPORT);
+
+	ops = rcu_dereference(nft_ip6_offloads[proto]);
+	if (likely(ops && ops->callbacks.gso_segment))
+		segs = ops->callbacks.gso_segment(skb, features);
+
+out:
+	return segs;
+}
+
+static int nft_ipv6_gro_complete(struct sk_buff *skb, int nhoff)
+{
+	struct ipv6hdr *iph = (struct ipv6hdr *)(skb->data + nhoff);
+	struct dst_entry *dst = skb_dst(skb);
+	struct rt6_info *rt = (struct rt6_info *)dst;
+	const struct net_offload *ops;
+	struct packet_offload *ptype;
+	int proto = iph->nexthdr;
+	struct in6_addr *nexthop;
+	struct neighbour *neigh;
+	struct net_device *dev;
+	unsigned int hh_len;
+	int err = 0;
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
+	ops = rcu_dereference(nft_ip6_offloads[proto]);
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
+	nexthop = rt6_nexthop(rt, &iph->daddr);
+	neigh = __ipv6_neigh_lookup_noref(dev, nexthop);
+	if (unlikely(!neigh))
+		neigh = __neigh_create(&arp_tbl, &nexthop, dev, false);
+	if (!IS_ERR(neigh))
+		neigh_output(neigh, skb);
+	rcu_read_unlock();
+
+	return -EINPROGRESS;
+}
+
+static struct sk_buff **nft_ipv6_gro_receive(struct sk_buff **head,
+					     struct sk_buff *skb)
+{
+	const struct net_offload *ops;
+	struct packet_offload *ptype;
+	struct sk_buff **pp = NULL;
+	struct sk_buff *p;
+	struct ipv6hdr *iph;
+	unsigned int nlen;
+	unsigned int hlen;
+	unsigned int off;
+	int proto, ret;
+
+	off = skb_gro_offset(skb);
+	hlen = off + sizeof(*iph);
+
+	iph = skb_gro_header_slow(skb, hlen, off);
+	if (unlikely(!iph))
+		goto out;
+
+	proto = iph->nexthdr;
+
+	rcu_read_lock();
+
+	if (iph->version != 6)
+		goto out_unlock;
+
+	nlen = skb_network_header_len(skb);
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
+	ops = rcu_dereference(nft_ip6_offloads[proto]);
+	if (!ops || !ops->callbacks.gro_receive)
+		goto out_unlock;
+
+	if (iph->hop_limit <= 1)
+		goto out_unlock;
+
+	skb->ip_summed = CHECKSUM_UNNECESSARY;
+
+	for (p = *head; p; p = p->next) {
+		struct ipv6hdr *iph2;
+		__be32 first_word; /* <Version:4><Traffic_Class:8><Flow_Label:20> */
+
+		if (!NAPI_GRO_CB(p)->same_flow)
+			continue;
+
+		if (!NAPI_GRO_CB(p)->is_ffwd) {
+			NAPI_GRO_CB(p)->same_flow = 0;
+			continue;
+		}
+
+		if (!skb_dst(p)) {
+			NAPI_GRO_CB(p)->same_flow = 0;
+			continue;
+		}
+
+		iph2 = ipv6_hdr(p);
+		first_word = *(__be32 *)iph ^ *(__be32 *)iph2;
+
+		/* All fields must match except length and Traffic Class.
+		 * XXX skbs on the gro_list have all been parsed and pulled
+		 * already so we don't need to compare nlen
+		 * (nlen != (sizeof(*iph2) + ipv6_exthdrs_len(iph2, &ops)))
+		 * memcmp() alone below is suffcient, right?
+		 */
+		if ((first_word & htonl(0xF00FFFFF)) ||
+		   memcmp(&iph->nexthdr, &iph2->nexthdr,
+			  nlen - offsetof(struct ipv6hdr, nexthdr))) {
+			NAPI_GRO_CB(p)->same_flow = 0;
+			continue;
+		}
+		/* flush if Traffic Class fields are different */
+		NAPI_GRO_CB(p)->flush |= !!(first_word & htonl(0x0FF00000));
+
+		NAPI_GRO_CB(skb)->is_ffwd = 1;
+		skb_dst_set_noref(skb, skb_dst(p));
+		pp = &p;
+
+		break;
+	}
+
+	NAPI_GRO_CB(skb)->is_atomic = true;
+
+	iph->hop_limit--;
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
+static struct packet_offload nft_ip6_packet_offload __read_mostly = {
+	.type = cpu_to_be16(ETH_P_IPV6),
+	.priority = 0,
+	.callbacks = {
+		.gro_receive = nft_ipv6_gro_receive,
+		.gro_complete = nft_ipv6_gro_complete,
+		.gso_segment = nft_ipv6_gso_segment,
+	},
+};
+
+static const struct net_offload nft_udp6_offload = {
+	.callbacks = {
+		.gso_segment = nft_udp6_gso_segment,
+		.gro_receive  =	nft_udp_gro_receive,
+	},
+};
+
+static const struct net_offload nft_tcp6_offload = {
+	.callbacks = {
+		.gso_segment = nft_tcp6_gso_segment,
+		.gro_receive  =	nft_tcp_gro_receive,
+	},
+};
+
+static const struct net_offload __rcu *nft_ip6_offloads[MAX_INET_PROTOS] __read_mostly = {
+	[IPPROTO_UDP]	= &nft_udp6_offload,
+	[IPPROTO_TCP]	= &nft_tcp6_offload,
+};
+
+void nf_early_ingress_ip6_enable(void)
+{
+	dev_add_offload(&nft_ip6_packet_offload);
+}
+
+void nf_early_ingress_ip6_disable(void)
+{
+	dev_remove_offload(&nft_ip6_packet_offload);
+}
diff --git a/net/netfilter/early_ingress.c b/net/netfilter/early_ingress.c
index bf31aa8b3721..4daf6cfea304 100644
--- a/net/netfilter/early_ingress.c
+++ b/net/netfilter/early_ingress.c
@@ -312,6 +312,7 @@ void nf_early_ingress_enable(void)
 	if (nf_early_ingress_use++ == 0) {
 		nf_early_ingress_use++;
 		nf_early_ingress_ip_enable();
+		nf_early_ingress_ip6_enable();
 	}
 }
 
@@ -319,5 +320,6 @@ void nf_early_ingress_disable(void)
 {
 	if (--nf_early_ingress_use == 0) {
 		nf_early_ingress_ip_disable();
+		nf_early_ingress_ip6_disable();
 	}
 }
-- 
2.11.0
