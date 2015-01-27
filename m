From: Bernhard Thaler <bernhard.thaler@wvnet.at>
Subject: [PATCHv3 1/1] bridge: forward IPv6 fragmented packets when passing netfilter
Date: Tue, 27 Jan 2015 02:22:04 +0100
Message-ID: <1422321724-325-1-git-send-email-bernhard.thaler@wvnet.at>
References: <20150122234940.GD16045@breakpoint.cc>
Cc: netfilter-devel@vger.kernel.org,
	Bernhard Thaler <bernhard.thaler@wvnet.at>
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smarthost2.wvnet.at ([62.212.174.131]:29846 "EHLO
	smarthost2.wvnet.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbbA0BXE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Jan 2015 20:23:04 -0500
Received: from smtp.wvnet.at (localhost [127.0.0.1])
	by smarthost1.wvnet.at (Postfix) with ESMTP id 66272FD0453
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Jan 2015 02:23:00 +0100 (CET)
In-Reply-To: <20150122234940.GD16045@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently IPv6 fragmented packets are not forwarded on an ethernet bridge
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

IPv6 fragmented packets traverse the bridge cleanly until "ip6tables -t nat -nvL"
is run. As soon as it is run (and netfilter modules are loaded) IPv6 fragmented
packets do not traverse the bridge any more (you see no more responses in ping's
output).

Patch exports ip6_fragment() in include/net/ipv6.h and net/ipv6/ip6_output.c
to use it in net/bridge/br_netfilter.c's br_nf_dev_queue_xmit() for IPv6 packets
that need to be fragmented.

In net/bridge/br_netfilter.c br_nf_pre_routing_finish_ipv6() is changed to keep
track of fragment size and br_nf_dev_queue_xmit() checks for IPv6 packets that
need to be fragmented.
br_validate_ipv6() is introduced to do some validity checks on the IPv6 packet
before calling ip6_fragment() in br_nf_dev_queue_xmit() and is closely aligned
to br_parse_ip_options() and existing checks in br_nf_pre_routing_finish_ipv6().
Existing checks in br_nf_pre_routing_finish_ipv6() are factored into
br_validate_ipv6() as suggested by Florian Westphal and br_parse_validate_ipv6()
called from there.
br_nf_dev_queue_xmit() is changed to contain the relevant code depending on
CONFIG_NF_DEFRAG_IPV4 or CONFIG_NF_DEFRAG_IPV6 being used both or each for
their own.

Function order is changed to have check_hbh_len() before br_validate_ipv6() to
be able to call it from there.

ip6_fragment() in net/ipv6/ip6_output.c yields a NULL pointer dereference
happening when handling packets coming from br_nf_dev_queue_xmit().  When
calling IP6_INC_STATS(), ip6_dst_idev(skb_dst(skb)) did crash the kernel
like this:

BUG: unable to handle kernel NULL pointer dereference at 000000000000037a
IP: [<ffffffff814cba2a>] ip6_fragment+0x99a/0x1290
PGD 3bc3f067 PUD 3bc12067 PMD 0
Oops: 0000 [#1] SMP
...

As suggested by Pablo Neira Ayuso net/bridge/br_private.h was changed to
prevent this issue by using a union to hold either fake_rtable or fake_rt6_info.

ip6_fragment() is further changed to use nf_bridge_mtu_reduction(skb) as it is
done in the IPv4 code.

After applying this patch, in the same setup as stated above fragmented IPv6
packets traverse the bridge even after running "ip6tables -t nat -nvL" / net-
filter modules loaded. This was tested using overlong IPv6 ICMP ping packets
as described above.
Some tests were performed crafting invalid headers (e.g. ipv6 version field
set to 5) to test checks in br_parse_ip6_options(), however these packets do
not seem to reach changed code parts and seem to be dropped at an earlier
stage (more testing needed with invalid / fuzzed packets).

Signed-off-by: Bernhard Thaler <bernhard.thaler@wvnet.at>
---

Changes since v2:
* changes in net/bridge/br_netfilter.c to combine checks on IPv6 header
  already performed in br_nf_pre_routing_finish_ipv6() with newly created
  br_parse_ip6_options()
* rename br_parse_ip6_options() to br_validate_ipv6()
* br_validate_ipv6() still performed in br_nf_pre_routing_finish_ipv6()
  and br_nf_dev_queue_xmit() to make sure even locally generated packets
  with SOCK_RAW are checked
* all changes based on suggestions by Florian Westphal on PATCHv2

 include/net/ipv6.h        |    1 +
 net/bridge/br_netfilter.c |  220 +++++++++++++++++++++++++++------------------
 net/bridge/br_private.h   |    6 +-
 net/ipv6/ip6_output.c     |    1 +
 4 files changed, 139 insertions(+), 89 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 4292929..aecbead 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -495,6 +495,7 @@ struct ip6_create_arg {
 
 void ip6_frag_init(struct inet_frag_queue *q, const void *a);
 bool ip6_frag_match(const struct inet_frag_queue *q, const void *a);
+int ip6_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *));
 
 /*
  *	Equivalent of ipv4 struct ip
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index c190d22..17e6a85 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -18,6 +18,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/ip.h>
+#include <linux/ipv6.h>
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <linux/if_arp.h>
@@ -34,6 +35,7 @@
 
 #include <net/ip.h>
 #include <net/ipv6.h>
+#include <net/addrconf.h>
 #include <net/route.h>
 #include <net/netfilter/br_netfilter.h>
 
@@ -239,6 +241,109 @@ drop:
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
+			pkt_len = ntohl(*(__be32 *) (nh + off + 2));
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
 /* PF_BRIDGE/PRE_ROUTING *********************************************/
 /* Undo the changes made for ip6tables PREROUTING and continue the
  * bridge PRE_ROUTING hook. */
@@ -246,6 +351,10 @@ static int br_nf_pre_routing_finish_ipv6(struct sk_buff *skb)
 {
 	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
 	struct rtable *rt;
+	int frag_max_size;
+
+	frag_max_size = IP6CB(skb)->frag_max_size;
+	BR_INPUT_SKB_CB(skb)->frag_max_size = frag_max_size;
 
 	if (nf_bridge->mask & BRNF_PKT_TYPE) {
 		skb->pkt_type = PACKET_OTHERHOST;
@@ -468,92 +577,17 @@ static struct net_device *setup_pre_routing(struct sk_buff *skb)
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
+ * to ip6tables
+ */
 static unsigned int br_nf_pre_routing_ipv6(const struct nf_hook_ops *ops,
 					   struct sk_buff *skb,
 					   const struct net_device *in,
 					   const struct net_device *out,
 					   int (*okfn)(struct sk_buff *))
 {
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
-
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
@@ -763,7 +797,6 @@ static unsigned int br_nf_forward_arp(const struct nf_hook_ops *ops,
 	return NF_STOLEN;
 }
 
-#if IS_ENABLED(CONFIG_NF_DEFRAG_IPV4)
 static int br_nf_dev_queue_xmit(struct sk_buff *skb)
 {
 	int ret;
@@ -772,6 +805,7 @@ static int br_nf_dev_queue_xmit(struct sk_buff *skb)
 	/* This is wrong! We should preserve the original fragment
 	 * boundaries by preserving frag_list rather than refragmenting.
 	 */
+#if IS_ENABLED(CONFIG_NF_DEFRAG_IPV4)
 	if (skb->protocol == htons(ETH_P_IP) &&
 	    skb->len + nf_bridge_mtu_reduction(skb) > skb->dev->mtu &&
 	    !skb_is_gso(skb)) {
@@ -781,17 +815,27 @@ static int br_nf_dev_queue_xmit(struct sk_buff *skb)
 			return NF_DROP;
 		IPCB(skb)->frag_max_size = frag_max_size;
 		ret = ip_fragment(skb, br_dev_queue_push_xmit);
-	} else
-		ret = br_dev_queue_push_xmit(skb);
+		return ret;
+	}
+#endif
+#if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
+	if (skb->protocol == htons(ETH_P_IPV6) &&
+	    skb->len + nf_bridge_mtu_reduction(skb) > skb->dev->mtu &&
+	    !skb_is_gso(skb)) {
+		frag_max_size = BR_INPUT_SKB_CB(skb)->frag_max_size;
+		if (br_validate_ipv6(skb))
+			/* Drop invalid packet */
+			return NF_DROP;
+		IP6CB(skb)->frag_max_size = frag_max_size;
+		ret = ip6_fragment(skb, br_dev_queue_push_xmit);
+		return ret;
+	}
+#endif
+
+	ret = br_dev_queue_push_xmit(skb);
 
 	return ret;
 }
-#else
-static int br_nf_dev_queue_xmit(struct sk_buff *skb)
-{
-        return br_dev_queue_push_xmit(skb);
-}
-#endif
 
 /* PF_BRIDGE/POST_ROUTING ********************************************/
 static unsigned int br_nf_post_routing(const struct nf_hook_ops *ops,
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index aea3d13..d9c880d 100644
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
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index ce69a12..30ff0dc 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -830,6 +830,7 @@ fail:
 	kfree_skb(skb);
 	return err;
 }
+EXPORT_SYMBOL(ip6_fragment);
 
 static inline int ip6_rt_check(const struct rt6key *rt_key,
 			       const struct in6_addr *fl_addr,
-- 
1.7.10.4

