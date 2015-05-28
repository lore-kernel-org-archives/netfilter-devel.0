From: Bernhard Thaler <bernhard.thaler@wvnet.at>
Subject: [PATCHv6 2/4] netfilter: bridge: forward IPv6 fragmented packets
Date: Thu, 28 May 2015 10:24:33 +0200
Message-ID: <1432801473-11867-1-git-send-email-bernhard.thaler@wvnet.at>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
	Bernhard Thaler <bernhard.thaler@wvnet.at>
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx-out.wvnet.at ([62.212.170.133]:53906 "EHLO mx-out.wvnet.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518AbbE1IZC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 May 2015 04:25:02 -0400
Received: from smtp.wvnet.at (localhost [127.0.0.1])
	by mx-out.wvnet.at (Postfix) with ESMTP id 0EF931073420
	for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2015 10:25:01 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

IPv6 fragmented packets are not forwarded on an ethernet bridge
with netfilter ip6_tables loaded. e.g. steps to reproduce

1) create a simple bridge like this

        modprobe br_netfilter
        brctl addbr br0
        brctl addif br0 eth0
        brctl addif br0 eth2
        ifconfig eth0 up
        ifconfig eth2 up
        ifconfig br0 up

2) place a host with an IPv6 address on each side of the bridge

        set IPv6 address on host A:
        ip -6 addr add fd01:2345:6789:1::1/64 dev eth0

        set IPv6 address on host B:
        ip -6 addr add fd01:2345:6789:1::2/64 dev eth0

3) run a simple ping command on host A with packets > MTU

        ping6 -s 4000 fd01:2345:6789:1::2

4) wait some time and run e.g. "ip6tables -t nat -nvL" on the bridge

IPv6 fragmented packets traverse the bridge cleanly until somebody runs.
"ip6tables -t nat -nvL". As soon as it is run (and netfilter modules are
loaded) IPv6 fragmented packets do not traverse the bridge any more (you
see no more responses in ping's output).

After applying this patch IPv6 fragmented packets traverse the bridge
cleanly in above scenario.

Signed-off-by: Bernhard Thaler <bernhard.thaler@wvnet.at>
[pablo@netfilter.org: small changes to br_nf_dev_queue_xmit]
---
Changes since v5:
* rebase to current davem/net-next
* include netfilter in subject line

 include/linux/netfilter_ipv6.h |    2 +
 net/bridge/br_netfilter.c      |  259 ++++++++++++++++++++++++----------------
 net/bridge/br_private.h        |    6 +-
 net/ipv6/netfilter.c           |    3 +-
 4 files changed, 168 insertions(+), 102 deletions(-)

diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index e2d1969..8b7d28f 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -26,6 +26,8 @@ struct nf_ipv6_ops {
 	int (*chk_addr)(struct net *net, const struct in6_addr *addr,
 			const struct net_device *dev, int strict);
 	void (*route_input)(struct sk_buff *skb);
+	int (*fragment)(struct sock *sk, struct sk_buff *skb,
+			int (*output)(struct sock *, struct sk_buff *));
 };
 
 extern const struct nf_ipv6_ops __rcu *nf_ipv6_ops;
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index ea8e063..a43e216 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -34,6 +34,7 @@
 
 #include <net/ip.h>
 #include <net/ipv6.h>
+#include <net/addrconf.h>
 #include <net/route.h>
 #include <net/netfilter/br_netfilter.h>
 
@@ -264,6 +265,109 @@ drop:
 	return -1;
 }
 
+/* We only check the length. A bridge shouldn't do hop-by-hop stuff anyway */
+static int check_hbh_len(struct sk_buff *skb)
+{
+	unsigned char *raw = (u8 *)(ipv6_hdr(skb) + 1);
+	u32 pkt_len;
+	const unsigned char *nh = skb_network_header(skb);
+	int off = raw - nh;
+	int len = (raw[1] + 1) << 3;
+
+	if ((raw + len) - skb->data > skb_headlen(skb))
+		goto bad;
+
+	off += 2;
+	len -= 2;
+
+	while (len > 0) {
+		int optlen = nh[off + 1] + 2;
+
+		switch (nh[off]) {
+		case IPV6_TLV_PAD1:
+			optlen = 1;
+			break;
+
+		case IPV6_TLV_PADN:
+			break;
+
+		case IPV6_TLV_JUMBO:
+			if (nh[off + 1] != 4 || (off & 3) != 2)
+				goto bad;
+			pkt_len = ntohl(*(__be32 *)(nh + off + 2));
+			if (pkt_len <= IPV6_MAXPLEN ||
+			    ipv6_hdr(skb)->payload_len)
+				goto bad;
+			if (pkt_len > skb->len - sizeof(struct ipv6hdr))
+				goto bad;
+			if (pskb_trim_rcsum(skb,
+					    pkt_len + sizeof(struct ipv6hdr)))
+				goto bad;
+			nh = skb_network_header(skb);
+			break;
+		default:
+			if (optlen > len)
+				goto bad;
+			break;
+		}
+		off += optlen;
+		len -= optlen;
+	}
+	if (len == 0)
+		return 0;
+bad:
+	return -1;
+}
+
+/* Equivalent to br_parse_ip_options for IPv6 */
+static int br_validate_ipv6(struct sk_buff *skb)
+{
+	const struct ipv6hdr *hdr;
+	struct net_device *dev = skb->dev;
+	struct inet6_dev *idev = in6_dev_get(skb->dev);
+	u32 pkt_len;
+	u8 ip6h_len = sizeof(struct ipv6hdr);
+
+	if (!pskb_may_pull(skb, ip6h_len))
+		goto inhdr_error;
+
+	if (skb->len < ip6h_len)
+		goto drop;
+
+	hdr = ipv6_hdr(skb);
+
+	if (hdr->version != 6)
+		goto inhdr_error;
+
+	pkt_len = ntohs(hdr->payload_len);
+
+	if (pkt_len || hdr->nexthdr != NEXTHDR_HOP) {
+		if (pkt_len + ip6h_len > skb->len) {
+			IP6_INC_STATS_BH(dev_net(dev), idev,
+					 IPSTATS_MIB_INTRUNCATEDPKTS);
+			goto drop;
+		}
+		if (pskb_trim_rcsum(skb, pkt_len + ip6h_len)) {
+			IP6_INC_STATS_BH(dev_net(dev), idev,
+					 IPSTATS_MIB_INDISCARDS);
+			goto drop;
+		}
+	}
+	if (hdr->nexthdr == NEXTHDR_HOP && check_hbh_len(skb))
+		goto drop;
+
+	memset(IP6CB(skb), 0, sizeof(struct inet6_skb_parm));
+	/* No IP options in IPv6 header; however it should be
+	 * checked if some next headers need special treatment
+	 */
+	return 0;
+
+inhdr_error:
+	IP6_INC_STATS_BH(dev_net(dev), idev, IPSTATS_MIB_INHDRERRORS);
+drop:
+	return -1;
+}
+
 static void nf_bridge_update_protocol(struct sk_buff *skb)
 {
 	switch (skb->nf_bridge->orig_proto) {
@@ -351,6 +455,10 @@ static int br_nf_pre_routing_finish_ipv6(struct sock *sk, struct sk_buff *skb)
 	struct rtable *rt;
 	struct net_device *dev = skb->dev;
 	const struct nf_ipv6_ops *v6ops = nf_get_ipv6_ops();
+	int frag_max_size;
+
+	frag_max_size = IP6CB(skb)->frag_max_size;
+	BR_INPUT_SKB_CB(skb)->frag_max_size = frag_max_size;
 
 	if (nf_bridge->pkt_otherhost) {
 		skb->pkt_type = PACKET_OTHERHOST;
@@ -554,91 +662,17 @@ static struct net_device *setup_pre_routing(struct sk_buff *skb)
 	return skb->dev;
 }
 
-/* We only check the length. A bridge shouldn't do any hop-by-hop stuff anyway */
-static int check_hbh_len(struct sk_buff *skb)
-{
-	unsigned char *raw = (u8 *)(ipv6_hdr(skb) + 1);
-	u32 pkt_len;
-	const unsigned char *nh = skb_network_header(skb);
-	int off = raw - nh;
-	int len = (raw[1] + 1) << 3;
-
-	if ((raw + len) - skb->data > skb_headlen(skb))
-		goto bad;
-
-	off += 2;
-	len -= 2;
-
-	while (len > 0) {
-		int optlen = nh[off + 1] + 2;
-
-		switch (nh[off]) {
-		case IPV6_TLV_PAD1:
-			optlen = 1;
-			break;
-
-		case IPV6_TLV_PADN:
-			break;
-
-		case IPV6_TLV_JUMBO:
-			if (nh[off + 1] != 4 || (off & 3) != 2)
-				goto bad;
-			pkt_len = ntohl(*(__be32 *) (nh + off + 2));
-			if (pkt_len <= IPV6_MAXPLEN ||
-			    ipv6_hdr(skb)->payload_len)
-				goto bad;
-			if (pkt_len > skb->len - sizeof(struct ipv6hdr))
-				goto bad;
-			if (pskb_trim_rcsum(skb,
-					    pkt_len + sizeof(struct ipv6hdr)))
-				goto bad;
-			nh = skb_network_header(skb);
-			break;
-		default:
-			if (optlen > len)
-				goto bad;
-			break;
-		}
-		off += optlen;
-		len -= optlen;
-	}
-	if (len == 0)
-		return 0;
-bad:
-	return -1;
-
-}
-
 /* Replicate the checks that IPv6 does on packet reception and pass the packet
- * to ip6tables, which doesn't support NAT, so things are fairly simple. */
+ * to ip6tables.
+ */
 static unsigned int br_nf_pre_routing_ipv6(const struct nf_hook_ops *ops,
 					   struct sk_buff *skb,
 					   const struct nf_hook_state *state)
 {
 	struct nf_bridge_info *nf_bridge;
-	const struct ipv6hdr *hdr;
-	u32 pkt_len;
-
-	if (skb->len < sizeof(struct ipv6hdr))
-		return NF_DROP;
-
-	if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
-		return NF_DROP;
-
-	hdr = ipv6_hdr(skb);
-
-	if (hdr->version != 6)
-		return NF_DROP;
-
-	pkt_len = ntohs(hdr->payload_len);
 
-	if (pkt_len || hdr->nexthdr != NEXTHDR_HOP) {
-		if (pkt_len + sizeof(struct ipv6hdr) > skb->len)
-			return NF_DROP;
-		if (pskb_trim_rcsum(skb, pkt_len + sizeof(struct ipv6hdr)))
-			return NF_DROP;
-	}
-	if (hdr->nexthdr == NEXTHDR_HOP && check_hbh_len(skb))
+	if (br_validate_ipv6(skb))
+		/* Drop invalid packet */
 		return NF_DROP;
 
 	nf_bridge_put(skb->nf_bridge);
@@ -747,6 +781,10 @@ static int br_nf_forward_finish(struct sock *sk, struct sk_buff *skb)
 			frag_max_size = IPCB(skb)->frag_max_size;
 			BR_INPUT_SKB_CB(skb)->frag_max_size = frag_max_size;
 		}
+		if (skb->protocol == htons(ETH_P_IPV6)) {
+			frag_max_size = IP6CB(skb)->frag_max_size;
+			BR_INPUT_SKB_CB(skb)->frag_max_size = frag_max_size;
+		}
 
 		in = nf_bridge->physindev;
 		if (nf_bridge->pkt_otherhost) {
@@ -808,15 +846,20 @@ static unsigned int br_nf_forward_ip(const struct nf_hook_ops *ops,
 		nf_bridge->pkt_otherhost = true;
 	}
 
-	if (pf == NFPROTO_IPV4) {
-		int frag_max = BR_INPUT_SKB_CB(skb)->frag_max_size;
+	int frag_max = BR_INPUT_SKB_CB(skb)->frag_max_size;
 
+	if (pf == NFPROTO_IPV4) {
 		if (br_parse_ip_options(skb))
 			return NF_DROP;
-
 		IPCB(skb)->frag_max_size = frag_max;
 	}
 
+	if (pf == NFPROTO_IPV6) {
+		if (br_validate_ipv6(skb))
+			return NF_DROP;
+		IP6CB(skb)->frag_max_size = frag_max;
+	}
+
 	nf_bridge->physoutdev = skb->dev;
 	if (pf == NFPROTO_IPV4)
 		skb->protocol = htons(ETH_P_IP);
@@ -864,7 +907,7 @@ static unsigned int br_nf_forward_arp(const struct nf_hook_ops *ops,
 	return NF_STOLEN;
 }
 
-#if IS_ENABLED(CONFIG_NF_DEFRAG_IPV4)
+#if IS_ENABLED(CONFIG_NF_DEFRAG_IPV4) || IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
 static int br_nf_push_frag_xmit(struct sock *sk, struct sk_buff *skb)
 {
 	struct brnf_frag_data *data;
@@ -884,6 +927,7 @@ static int br_nf_push_frag_xmit(struct sock *sk, struct sk_buff *skb)
 	nf_bridge_info_free(skb);
 	return br_dev_queue_push_xmit(sk, skb);
 }
+#endif
 
 static int br_nf_ip_fragment(struct sock *sk, struct sk_buff *skb,
 			     int (*output)(struct sock *, struct sk_buff *))
@@ -906,27 +950,25 @@ static int br_nf_ip_fragment(struct sock *sk, struct sk_buff *skb,
 
 static int br_nf_dev_queue_xmit(struct sock *sk, struct sk_buff *skb)
 {
-	int ret;
-	int frag_max_size;
 	unsigned int mtu_reserved;
 
-	if (skb_is_gso(skb) || skb->protocol != htons(ETH_P_IP)) {
+	mtu_reserved = nf_bridge_mtu_reduction(skb);
+	if (skb_is_gso(skb) || skb->len + mtu_reserved <= skb->dev->mtu) {
 		nf_bridge_info_free(skb);
 		return br_dev_queue_push_xmit(sk, skb);
 	}
 
-	mtu_reserved = nf_bridge_mtu_reduction(skb);
+#if IS_ENABLED(CONFIG_NF_DEFRAG_IPV4)
 	/* This is wrong! We should preserve the original fragment
 	 * boundaries by preserving frag_list rather than refragmenting.
 	 */
-	if (skb->len + mtu_reserved > skb->dev->mtu) {
+	if (skb->protocol == htons(ETH_P_IP)) {
 		struct brnf_frag_data *data;
-
-		frag_max_size = BR_INPUT_SKB_CB(skb)->frag_max_size;
 		if (br_parse_ip_options(skb))
 			/* Drop invalid packet */
 			return NF_DROP;
-		IPCB(skb)->frag_max_size = frag_max_size;
+
+		IPCB(skb)->frag_max_size = BR_INPUT_SKB_CB(skb)->frag_max_size;
 
 		nf_bridge_update_protocol(skb);
 
@@ -937,21 +979,38 @@ static int br_nf_dev_queue_xmit(struct sock *sk, struct sk_buff *skb)
 		skb_copy_from_linear_data_offset(skb, -data->size, data->mac,
 						 data->size);
 
-		ret = br_nf_ip_fragment(sk, skb, br_nf_push_frag_xmit);
-	} else {
-		nf_bridge_info_free(skb);
-		ret = br_dev_queue_push_xmit(sk, skb);
+		return br_nf_ip_fragment(sk, skb, br_nf_push_frag_xmit);
 	}
+#endif
+#if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
+	if (skb->protocol == htons(ETH_P_IPV6)) {
+		const struct nf_ipv6_ops *v6ops = nf_get_ipv6_ops();
+		struct brnf_frag_data *data;
 
-	return ret;
-}
-#else
-static int br_nf_dev_queue_xmit(struct sock *sk, struct sk_buff *skb)
-{
+		if (br_validate_ipv6(skb))
+			/* Drop invalid packet */
+			return NF_DROP;
+
+		IP6CB(skb)->frag_max_size = BR_INPUT_SKB_CB(skb)->frag_max_size;
+
+		nf_bridge_update_protocol(skb);
+
+		data = this_cpu_ptr(&brnf_frag_data_storage);
+		data->encap_size = nf_bridge_encap_header_len(skb);
+		data->size = ETH_HLEN + data->encap_size;
+
+		skb_copy_from_linear_data_offset(skb, -data->size, data->mac,
+						 data->size);
+
+		if (v6ops)
+			return v6ops->fragment(sk, skb, br_nf_push_frag_xmit);
+		else
+			return -EMSGSIZE;
+	}
+#endif
 	nf_bridge_info_free(skb);
 	return br_dev_queue_push_xmit(sk, skb);
 }
-#endif
 
 /* PF_BRIDGE/POST_ROUTING ********************************************/
 static unsigned int br_nf_post_routing(const struct nf_hook_ops *ops,
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 1f36fa7..fc71894 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -18,6 +18,7 @@
 #include <linux/netpoll.h>
 #include <linux/u64_stats_sync.h>
 #include <net/route.h>
+#include <net/ip6_fib.h>
 #include <linux/if_vlan.h>
 
 #define BR_HASH_BITS 8
@@ -214,7 +215,10 @@ struct net_bridge
 	spinlock_t			hash_lock;
 	struct hlist_head		hash[BR_HASH_SIZE];
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
-	struct rtable 			fake_rtable;
+	union {
+		struct rtable		fake_rtable;
+		struct rt6_info		fake_rt6_info;
+	};
 	bool				nf_call_iptables;
 	bool				nf_call_ip6tables;
 	bool				nf_call_arptables;
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index bbca09f..b4de08a 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -191,7 +191,8 @@ static __sum16 nf_ip6_checksum_partial(struct sk_buff *skb, unsigned int hook,
 
 static const struct nf_ipv6_ops ipv6ops = {
 	.chk_addr	= ipv6_chk_addr,
-	.route_input    = ip6_route_input
+	.route_input    = ip6_route_input,
+	.fragment	= ip6_fragment
 };
 
 static const struct nf_afinfo nf_ip6_afinfo = {
-- 
1.7.10.4

