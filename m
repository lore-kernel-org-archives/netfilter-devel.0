From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2.4 3/6]: Restore netfilter assumption in IPv6 multicast
Date: Mon, 01 Aug 2005 02:42:29 +0200
Message-ID: <42ED6FF5.5010609@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="3.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="3.diff"
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

[NETFILTER]: Restore netfilter assumption in IPv6 multicast

Netfilter assumes that skb->data == skb->nh.ipv6h

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 387a85697670fa620cf91969bd97f01687e83b20
tree bd1d42683a16f159e42b41cfe580a062f571a803
parent 36d73751283413992a12837f7a6e4116b9e70d3f
author Patrick McHardy <kaber@trash.net> Sun, 31 Jul 2005 20:11:06 +0200
committer Patrick McHardy <kaber@trash.net> Sun, 31 Jul 2005 20:11:06 +0200

 net/ipv6/mcast.c |   46 ++++++++++++++++++++++++++--------------------
 1 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -1243,15 +1243,6 @@ static struct sk_buff *mld_newpack(struc
 		return 0;
 
 	skb_reserve(skb, (dev->hard_header_len + 15) & ~15);
-	if (dev->hard_header) {
-		unsigned char ha[MAX_ADDR_LEN];
-
-		ndisc_mc_map(&mld2_all_mcr, ha, dev, 1);
-		if (dev->hard_header(skb, dev, ETH_P_IPV6,ha,NULL,size) < 0) {
-			kfree_skb(skb);
-			return 0;
-		}
-	}
 
 	if (ipv6_get_lladdr(dev, &addr_buf)) {
 		/* <draft-ietf-magma-mld-source-02.txt>:
@@ -1275,6 +1266,30 @@ static struct sk_buff *mld_newpack(struc
 	return skb;
 }
 
+static inline int mld_dev_queue_xmit2(struct sk_buff *skb)
+{
+	struct net_device *dev = skb->dev;
+
+	if (dev->hard_header) {
+		unsigned char ha[MAX_ADDR_LEN];
+		int err;
+
+		ndisc_mc_map(&skb->nh.ipv6h->daddr, ha, dev, 1);
+		err = dev->hard_header(skb, dev, ETH_P_IPV6, ha, NULL, skb->len);
+		if (err < 0) {
+			kfree_skb(skb);
+			return err;
+		}
+	}
+	return dev_queue_xmit(skb);
+}
+
+static inline int mld_dev_queue_xmit(struct sk_buff *skb)
+{
+	return NF_HOOK(PF_INET6, NF_IP6_POST_ROUTING, skb, NULL, skb->dev,
+	               mld_dev_queue_xmit2);
+}
+
 static void mld_sendpack(struct sk_buff *skb)
 {
 	struct ipv6hdr *pip6 = skb->nh.ipv6h;
@@ -1289,7 +1304,7 @@ static void mld_sendpack(struct sk_buff 
 	pmr->csum = csum_ipv6_magic(&pip6->saddr, &pip6->daddr, mldlen,
 		IPPROTO_ICMPV6, csum_partial(skb->h.raw, mldlen, 0));
 	err = NF_HOOK(PF_INET6, NF_IP6_LOCAL_OUT, skb, NULL, skb->dev,
-		      dev_queue_xmit);
+		      mld_dev_queue_xmit);
 	if (!err)
 		ICMP6_INC_STATS(Icmp6OutMsgs);
 }
@@ -1585,12 +1600,6 @@ void igmp6_send(struct in6_addr *addr, s
 		return;
 
 	skb_reserve(skb, (dev->hard_header_len + 15) & ~15);
-	if (dev->hard_header) {
-		unsigned char ha[MAX_ADDR_LEN];
-		ndisc_mc_map(snd_addr, ha, dev, 1);
-		if (dev->hard_header(skb, dev, ETH_P_IPV6, ha, NULL, full_len) < 0)
-			goto out;
-	}
 
 	if (ipv6_get_lladdr(dev, &addr_buf)) {
 		/* <draft-ietf-magma-mld-source-02.txt>:
@@ -1616,7 +1625,7 @@ void igmp6_send(struct in6_addr *addr, s
 					   csum_partial((__u8 *) hdr, len, 0));
 
 	err = NF_HOOK(PF_INET6, NF_IP6_LOCAL_OUT, skb, NULL, skb->dev,
-		      dev_queue_xmit);
+		      mld_dev_queue_xmit);
 	if (!err) {
 		if (type == ICMPV6_MGM_REDUCTION)
 			ICMP6_INC_STATS(Icmp6OutGroupMembReductions);
@@ -1626,9 +1635,6 @@ void igmp6_send(struct in6_addr *addr, s
 	}
 
 	return;
-
-out:
-	kfree_skb(skb);
 }
 
 static int ip6_mc_del1_src(struct ifmcaddr6 *pmc, int sfmode,
