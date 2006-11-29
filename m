From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 30/33]: ebtables: add --snap-arp option
Date: Wed, 29 Nov 2006 03:09:30 +0100 (MET)
Message-ID: <20061129020930.21082.67864.sendpatchset@localhost.localdomain>
References: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ebtables: add --snap-arp option

The attached patch adds --snat-arp support, which makes it possible to
change the source mac address in both the mac header and the arp header
with one rule.

Signed-off-by: Bart De Schuymer <bdschuym@pandora.be>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 80edc7ee5b534c039c0f1839af3ce5348417fd54
tree 1cac381ed8d3463fa5a9c83ba3460a3b139e7d47
parent a212f14ec0dccdfd5c3f77017dfe3c23fa944d2c
author Bart De Schuymer <bdschuym@pandora.be> Tue, 28 Nov 2006 23:13:16 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 29 Nov 2006 02:32:53 +0100

 include/linux/netfilter_bridge/ebt_nat.h  |    1 +
 include/linux/netfilter_bridge/ebtables.h |    4 ++++
 net/bridge/netfilter/ebt_mark.c           |    6 +++---
 net/bridge/netfilter/ebt_snat.c           |   27 ++++++++++++++++++++++++---
 4 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter_bridge/ebt_nat.h b/include/linux/netfilter_bridge/ebt_nat.h
index 26fd90d..435b886 100644
--- a/include/linux/netfilter_bridge/ebt_nat.h
+++ b/include/linux/netfilter_bridge/ebt_nat.h
@@ -1,6 +1,7 @@
 #ifndef __LINUX_BRIDGE_EBT_NAT_H
 #define __LINUX_BRIDGE_EBT_NAT_H
 
+#define NAT_ARP_BIT  (0x00000010)
 struct ebt_nat_info
 {
 	unsigned char mac[ETH_ALEN];
diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index e6ea70d..8777526 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -26,6 +26,10 @@ #define EBT_DROP     -2
 #define EBT_CONTINUE -3
 #define EBT_RETURN   -4
 #define NUM_STANDARD_TARGETS   4
+/* ebtables target modules store the verdict inside an int. We can
+ * reclaim a part of this int for backwards compatible extensions.
+ * The 4 lsb are more than enough to store the verdict. */
+#define EBT_VERDICT_BITS 0x0000000F
 
 struct ebt_counter
 {
diff --git a/net/bridge/netfilter/ebt_mark.c b/net/bridge/netfilter/ebt_mark.c
index 2458638..62d23c7 100644
--- a/net/bridge/netfilter/ebt_mark.c
+++ b/net/bridge/netfilter/ebt_mark.c
@@ -33,7 +33,7 @@ static int ebt_target_mark(struct sk_buf
 	else
 		(*pskb)->mark ^= info->mark;
 
-	return info->target | -16;
+	return info->target | ~EBT_VERDICT_BITS;
 }
 
 static int ebt_target_mark_check(const char *tablename, unsigned int hookmask,
@@ -44,13 +44,13 @@ static int ebt_target_mark_check(const c
 
 	if (datalen != EBT_ALIGN(sizeof(struct ebt_mark_t_info)))
 		return -EINVAL;
-	tmp = info->target | -16;
+	tmp = info->target | ~EBT_VERDICT_BITS;
 	if (BASE_CHAIN && tmp == EBT_RETURN)
 		return -EINVAL;
 	CLEAR_BASE_CHAIN_BIT;
 	if (tmp < -NUM_STANDARD_TARGETS || tmp >= 0)
 		return -EINVAL;
-	tmp = info->target & -16;
+	tmp = info->target & ~EBT_VERDICT_BITS;
 	if (tmp != MARK_SET_VALUE && tmp != MARK_OR_VALUE &&
 	    tmp != MARK_AND_VALUE && tmp != MARK_XOR_VALUE)
 		return -EINVAL;
diff --git a/net/bridge/netfilter/ebt_snat.c b/net/bridge/netfilter/ebt_snat.c
index cbb33e2..a507221 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -12,6 +12,8 @@ #include <linux/netfilter_bridge/ebtable
 #include <linux/netfilter_bridge/ebt_nat.h>
 #include <linux/module.h>
 #include <net/sock.h>
+#include <linux/if_arp.h>
+#include <net/arp.h>
 
 static int ebt_target_snat(struct sk_buff **pskb, unsigned int hooknr,
    const struct net_device *in, const struct net_device *out,
@@ -31,24 +33,43 @@ static int ebt_target_snat(struct sk_buf
 		*pskb = nskb;
 	}
 	memcpy(eth_hdr(*pskb)->h_source, info->mac, ETH_ALEN);
-	return info->target;
+	if (!(info->target & NAT_ARP_BIT) &&
+	    eth_hdr(*pskb)->h_proto == htons(ETH_P_ARP)) {
+		struct arphdr _ah, *ap;
+
+		ap = skb_header_pointer(*pskb, 0, sizeof(_ah), &_ah);
+		if (ap == NULL)
+			return EBT_DROP;
+		if (ap->ar_hln != ETH_ALEN)
+			goto out;
+		if (skb_store_bits(*pskb, sizeof(_ah), info->mac,ETH_ALEN))
+			return EBT_DROP;
+	}
+out:
+	return info->target | ~EBT_VERDICT_BITS;
 }
 
 static int ebt_target_snat_check(const char *tablename, unsigned int hookmask,
    const struct ebt_entry *e, void *data, unsigned int datalen)
 {
 	struct ebt_nat_info *info = (struct ebt_nat_info *) data;
+	int tmp;
 
 	if (datalen != EBT_ALIGN(sizeof(struct ebt_nat_info)))
 		return -EINVAL;
-	if (BASE_CHAIN && info->target == EBT_RETURN)
+	tmp = info->target | ~EBT_VERDICT_BITS;
+	if (BASE_CHAIN && tmp == EBT_RETURN)
 		return -EINVAL;
 	CLEAR_BASE_CHAIN_BIT;
 	if (strcmp(tablename, "nat"))
 		return -EINVAL;
 	if (hookmask & ~(1 << NF_BR_POST_ROUTING))
 		return -EINVAL;
-	if (INVALID_TARGET)
+
+	if (tmp < -NUM_STANDARD_TARGETS || tmp >= 0)
+		return -EINVAL;
+	tmp = info->target | EBT_VERDICT_BITS;
+	if ((tmp & ~NAT_ARP_BIT) != ~NAT_ARP_BIT)
 		return -EINVAL;
 	return 0;
 }
