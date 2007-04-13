From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/06]: ebt_arp: add gratuitous arp filtering
Date: Fri, 13 Apr 2007 05:00:10 +0200 (MEST)
Message-ID: <20070413025926.29875.28406.sendpatchset@localhost.localdomain>
References: <20070413025923.29875.68909.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070413025923.29875.68909.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ebt_arp: add gratuitous arp filtering

The attached patch adds gratuitous arp filtering, more precisely: it
allows checking that the IPv4 source address matches the IPv4
destination address inside the ARP header. It also adds a check for the
hardware address type when matching MAC addresses (nothing critical,
just for better consistency).

Signed-off-by: Bart De Schuymer <bdschuym@pandora.be>
Acked-by: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 801b6d278e6e78a2a58b6729eb8f799de6ed74d0
tree 2f68cb4c51af86782ba9b1ddff5735e4ccae9df5
parent 2b4788ea9b3c4e532f7cde3f05800c33977f32ee
author Bart De Schuymer <bdschuym@pandora.be> Fri, 13 Apr 2007 04:43:04 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 13 Apr 2007 04:43:04 +0200

 include/linux/netfilter_bridge/ebt_arp.h |    4 ++-
 net/bridge/netfilter/ebt_arp.c           |   48 ++++++++++++++----------------
 2 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/include/linux/netfilter_bridge/ebt_arp.h b/include/linux/netfilter_bridge/ebt_arp.h
index 97e4dbd..cbf4843 100644
--- a/include/linux/netfilter_bridge/ebt_arp.h
+++ b/include/linux/netfilter_bridge/ebt_arp.h
@@ -8,8 +8,10 @@
 #define EBT_ARP_DST_IP 0x10
 #define EBT_ARP_SRC_MAC 0x20
 #define EBT_ARP_DST_MAC 0x40
+#define EBT_ARP_GRAT 0x80
 #define EBT_ARP_MASK (EBT_ARP_OPCODE | EBT_ARP_HTYPE | EBT_ARP_PTYPE | \
-   EBT_ARP_SRC_IP | EBT_ARP_DST_IP | EBT_ARP_SRC_MAC | EBT_ARP_DST_MAC)
+   EBT_ARP_SRC_IP | EBT_ARP_DST_IP | EBT_ARP_SRC_MAC | EBT_ARP_DST_MAC | \
+   EBT_ARP_GRAT)
 #define EBT_ARP_MATCH "arp"
 
 struct ebt_arp_info
diff --git a/net/bridge/netfilter/ebt_arp.c b/net/bridge/netfilter/ebt_arp.c
index 9c59980..1a46952 100644
--- a/net/bridge/netfilter/ebt_arp.c
+++ b/net/bridge/netfilter/ebt_arp.c
@@ -35,40 +35,36 @@ static int ebt_filter_arp(const struct sk_buff *skb, const struct net_device *in
 		return EBT_NOMATCH;
 
 	if (info->bitmask & (EBT_ARP_SRC_IP | EBT_ARP_DST_IP)) {
-		__be32 _addr, *ap;
+		__be32 saddr, daddr, *sap, *dap;
 
-		/* IPv4 addresses are always 4 bytes */
-		if (ah->ar_pln != sizeof(__be32))
+		if (ah->ar_pln != sizeof(__be32) || ah->ar_pro != htons(ETH_P_IP))
+			return EBT_NOMATCH;
+		sap = skb_header_pointer(skb, sizeof(struct arphdr) +
+					ah->ar_hln, sizeof(saddr),
+					&saddr);
+		if (sap == NULL)
+			return EBT_NOMATCH;
+		dap = skb_header_pointer(skb, sizeof(struct arphdr) +
+					2*ah->ar_hln+sizeof(saddr),
+					sizeof(daddr), &daddr);
+		if (dap == NULL)
+			return EBT_NOMATCH;
+		if (info->bitmask & EBT_ARP_SRC_IP &&
+		    FWINV(info->saddr != (*sap & info->smsk), EBT_ARP_SRC_IP))
+			return EBT_NOMATCH;
+		if (info->bitmask & EBT_ARP_DST_IP &&
+		    FWINV(info->daddr != (*dap & info->dmsk), EBT_ARP_DST_IP))
+			return EBT_NOMATCH;
+		if (info->bitmask & EBT_ARP_GRAT &&
+		    FWINV(*dap != *sap, EBT_ARP_GRAT))
 			return EBT_NOMATCH;
-		if (info->bitmask & EBT_ARP_SRC_IP) {
-			ap = skb_header_pointer(skb, sizeof(struct arphdr) +
-						ah->ar_hln, sizeof(_addr),
-						&_addr);
-			if (ap == NULL)
-				return EBT_NOMATCH;
-			if (FWINV(info->saddr != (*ap & info->smsk),
-			   EBT_ARP_SRC_IP))
-				return EBT_NOMATCH;
-		}
-
-		if (info->bitmask & EBT_ARP_DST_IP) {
-			ap = skb_header_pointer(skb, sizeof(struct arphdr) +
-						2*ah->ar_hln+sizeof(__be32),
-						sizeof(_addr), &_addr);
-			if (ap == NULL)
-				return EBT_NOMATCH;
-			if (FWINV(info->daddr != (*ap & info->dmsk),
-			   EBT_ARP_DST_IP))
-				return EBT_NOMATCH;
-		}
 	}
 
 	if (info->bitmask & (EBT_ARP_SRC_MAC | EBT_ARP_DST_MAC)) {
 		unsigned char _mac[ETH_ALEN], *mp;
 		uint8_t verdict, i;
 
-		/* MAC addresses are 6 bytes */
-		if (ah->ar_hln != ETH_ALEN)
+		if (ah->ar_hln != ETH_ALEN || ah->ar_hrd != htons(ARPHRD_ETHER))
 			return EBT_NOMATCH;
 		if (info->bitmask & EBT_ARP_SRC_MAC) {
 			mp = skb_header_pointer(skb, sizeof(struct arphdr),
