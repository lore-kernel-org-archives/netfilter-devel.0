From: Bernhard Thaler <bernhard.thaler@wvnet.at>
Subject: [PATCHv2 1/1] bridge: forward IPv6 fragmented packets when passing netfilter
Date: Fri, 23 Jan 2015 00:27:12 +0100
Message-ID: <1421969232-19103-1-git-send-email-bernhard.thaler@wvnet.at>
References: <20150120172805.GA11456@salvia>
Cc: netfilter-devel@vger.kernel.org,
	Bernhard Thaler <bernhard.thaler@wvnet.at>
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smarthost2.wvnet.at ([62.212.174.131]:38974 "EHLO
	smarthost2.wvnet.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbbAVX2l (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Jan 2015 18:28:41 -0500
Received: from smtp.wvnet.at (localhost [127.0.0.1])
	by smarthost1.wvnet.at (Postfix) with ESMTP id 587E1FCF7BF
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Jan 2015 00:28:38 +0100 (CET)
In-Reply-To: <20150120172805.GA11456@salvia>
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
need to be fragmented. br_parse_ip6_options() is introduced to do some validity
checks on the IPv6 packet before calling ip6_fragment() and is closely aligned
to IPv4 code as an example.
br_nf_dev_queue_xmit() is changed to contain the relevant code depending on
CONFIG_NF_DEFRAG_IPV4 or CONFIG_NF_DEFRAG_IPV6 being used both or each for
their own.

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

Changes since v1:
* removed changes to IP6_INC_STATS() calls in net/ipv6/ip6_output.c 
* changed net/bridge/br_private.h to use union for fake_rtable and fake_rt6_info
  as suggested by Pablo Neira Ayuso

 include/net/ipv6.h        |    1 +
 net/bridge/br_netfilter.c |   87 ++++++++++++++++++++++++++++++++++++++++-----
 net/bridge/br_private.h   |    6 +++-
 net/ipv6/ip6_output.c     |    1 +
 4 files changed, 85 insertions(+), 10 deletions(-)

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
index c190d22..fac485e 100644
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
 
@@ -239,6 +241,59 @@ drop:
 	return -1;
 }
 
+/* Equivalent to br_parse_ip_options for IPv6 */
+
+static int br_parse_ip6_options(struct sk_buff *skb)
+{
+	const struct ipv6hdr *ip6h;
+	struct net_device *dev = skb->dev;
+	struct inet6_dev *idev = in6_dev_get(skb->dev);
+	u32 len;
+	u8 ip6h_len = sizeof(struct ipv6hdr);
+
+	if (!pskb_may_pull(skb, ip6h_len))
+		goto inhdr_error;
+
+	ip6h = ipv6_hdr(skb);
+
+	/* Basic sanity checks
+	 * check version
+	 * check minimum header length (40 bytes)
+	 * check total length
+	 */
+	if (ip6h->version != 6)
+		goto inhdr_error;
+
+	if (!pskb_may_pull(skb, ip6h_len))
+		goto inhdr_error;
+
+	len = ntohs(ip6h->payload_len) + ip6h_len;
+
+	if (skb->len < len) {
+		IP6_INC_STATS_BH(dev_net(dev), idev,
+				 IPSTATS_MIB_INTRUNCATEDPKTS);
+		goto drop;
+	} else if (len < ip6h_len) {
+		goto inhdr_error;
+	}
+
+	if (pskb_trim_rcsum(skb, len)) {
+		IP6_INC_STATS_BH(dev_net(dev), idev, IPSTATS_MIB_INDISCARDS);
+		goto drop;
+	}
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
@@ -246,6 +301,10 @@ static int br_nf_pre_routing_finish_ipv6(struct sk_buff *skb)
 {
 	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
 	struct rtable *rt;
+	int frag_max_size;
+
+	frag_max_size = IP6CB(skb)->frag_max_size;
+	BR_INPUT_SKB_CB(skb)->frag_max_size = frag_max_size;
 
 	if (nf_bridge->mask & BRNF_PKT_TYPE) {
 		skb->pkt_type = PACKET_OTHERHOST;
@@ -763,7 +822,6 @@ static unsigned int br_nf_forward_arp(const struct nf_hook_ops *ops,
 	return NF_STOLEN;
 }
 
-#if IS_ENABLED(CONFIG_NF_DEFRAG_IPV4)
 static int br_nf_dev_queue_xmit(struct sk_buff *skb)
 {
 	int ret;
@@ -772,6 +830,7 @@ static int br_nf_dev_queue_xmit(struct sk_buff *skb)
 	/* This is wrong! We should preserve the original fragment
 	 * boundaries by preserving frag_list rather than refragmenting.
 	 */
+#if IS_ENABLED(CONFIG_NF_DEFRAG_IPV4)
 	if (skb->protocol == htons(ETH_P_IP) &&
 	    skb->len + nf_bridge_mtu_reduction(skb) > skb->dev->mtu &&
 	    !skb_is_gso(skb)) {
@@ -781,17 +840,27 @@ static int br_nf_dev_queue_xmit(struct sk_buff *skb)
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
+		if (br_parse_ip6_options(skb))
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

