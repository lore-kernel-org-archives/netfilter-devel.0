From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 3/7]: Restore netfilter assumptions in IPv6 multicast
Date: Tue, 21 Jun 2005 01:04:16 +0200
Message-ID: <42B74B70.60500@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="03.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="03.diff"
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

[NETFILTER]: Restore netfilter assumptions in IPv6 multicast

Netfilter assumes that skb->data == skb->nh.ipv6h

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 6f3e8460b395913e1f156c6e66e818c83afc4d25
tree 4ed80e10056c649442d0cab25f7a9421517dcee5
parent d83d34acca8d7e31aeb226928ba723b4213f7e70
author Patrick McHardy <kaber@trash.net> Mon, 20 Jun 2005 18:46:39
committer Patrick McHardy <kaber@trash.net> Mon, 20 Jun 2005 18:46:39

 net/ipv6/mcast.c |   47 ++++++++++++++++++++++++++---------------------
 1 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -1280,15 +1280,6 @@ static struct sk_buff *mld_newpack(struc
 		return NULL;
 
 	skb_reserve(skb, LL_RESERVED_SPACE(dev));
-	if (dev->hard_header) {
-		unsigned char ha[MAX_ADDR_LEN];
-
-		ndisc_mc_map(&mld2_all_mcr, ha, dev, 1);
-		if (dev->hard_header(skb, dev, ETH_P_IPV6,ha,NULL,size) < 0) {
-			kfree_skb(skb);
-			return NULL;
-		}
-	}
 
 	if (ipv6_get_lladdr(dev, &addr_buf)) {
 		/* <draft-ietf-magma-mld-source-05.txt>:
@@ -1312,6 +1303,30 @@ static struct sk_buff *mld_newpack(struc
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
@@ -1329,7 +1344,7 @@ static void mld_sendpack(struct sk_buff 
 	pmr->csum = csum_ipv6_magic(&pip6->saddr, &pip6->daddr, mldlen,
 		IPPROTO_ICMPV6, csum_partial(skb->h.raw, mldlen, 0));
 	err = NF_HOOK(PF_INET6, NF_IP6_LOCAL_OUT, skb, NULL, skb->dev,
-		dev_queue_xmit);
+		mld_dev_queue_xmit);
 	if (!err) {
 		ICMP6_INC_STATS(idev,ICMP6_MIB_OUTMSGS);
 		IP6_INC_STATS(IPSTATS_MIB_OUTMCASTPKTS);
@@ -1635,12 +1650,6 @@ static void igmp6_send(struct in6_addr *
 	}
 
 	skb_reserve(skb, LL_RESERVED_SPACE(dev));
-	if (dev->hard_header) {
-		unsigned char ha[MAX_ADDR_LEN];
-		ndisc_mc_map(snd_addr, ha, dev, 1);
-		if (dev->hard_header(skb, dev, ETH_P_IPV6, ha, NULL, full_len) < 0)
-			goto out;
-	}
 
 	if (ipv6_get_lladdr(dev, &addr_buf)) {
 		/* <draft-ietf-magma-mld-source-05.txt>:
@@ -1668,7 +1677,7 @@ static void igmp6_send(struct in6_addr *
 	idev = in6_dev_get(skb->dev);
 
 	err = NF_HOOK(PF_INET6, NF_IP6_LOCAL_OUT, skb, NULL, skb->dev,
-		dev_queue_xmit);
+		mld_dev_queue_xmit);
 	if (!err) {
 		if (type == ICMPV6_MGM_REDUCTION)
 			ICMP6_INC_STATS(idev, ICMP6_MIB_OUTGROUPMEMBREDUCTIONS);
@@ -1682,10 +1691,6 @@ static void igmp6_send(struct in6_addr *
 	if (likely(idev != NULL))
 		in6_dev_put(idev);
 	return;
-
-out:
-	IP6_INC_STATS(IPSTATS_MIB_OUTDISCARDS);
-	kfree_skb(skb);
 }
 
 static int ip6_mc_del1_src(struct ifmcaddr6 *pmc, int sfmode,
