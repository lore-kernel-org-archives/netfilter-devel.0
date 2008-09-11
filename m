From: Jan Engelhardt <jengelh@medozas.de>
Subject: 03/11 [NETFILTER]: Change return types of match functions for Ebtables
 extensions
Date: Wed, 10 Sep 2008 22:45:05 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0809102244570.8838@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0809102242180.8838@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41551 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031AbYIKCpH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Sep 2008 22:45:07 -0400
In-Reply-To: <alpine.LNX.1.10.0809102242180.8838@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 85406f396edadf87efdc4485b3afa65d6482bdd9
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Sep 10 02:27:36 2008 -0400

[NETFILTER]: Change return types of match functions for Ebtables extensions

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter_bridge/ebtables.h |    3 +-
 net/bridge/netfilter/ebt_802_3.c          |   13 +++---
 net/bridge/netfilter/ebt_among.c          |   44 +++++++++-----------
 net/bridge/netfilter/ebt_arp.c            |   35 ++++++++--------
 net/bridge/netfilter/ebt_ip.c             |   25 ++++++------
 net/bridge/netfilter/ebt_ip6.c            |   26 ++++++------
 net/bridge/netfilter/ebt_limit.c          |    6 +-
 net/bridge/netfilter/ebt_mark_m.c         |    6 +-
 net/bridge/netfilter/ebt_pkttype.c        |    4 +-
 net/bridge/netfilter/ebt_stp.c            |   39 +++++++++---------
 net/bridge/netfilter/ebt_vlan.c           |    8 ++--
 11 files changed, 104 insertions(+), 105 deletions(-)

diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index 5f71719..f9fda2c 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -207,8 +207,7 @@ struct ebt_match
 {
 	struct list_head list;
 	const char name[EBT_FUNCTION_MAXNAMELEN];
-	/* 0 == it matches */
-	int (*match)(const struct sk_buff *skb, const struct net_device *in,
+	bool (*match)(const struct sk_buff *skb, const struct net_device *in,
 	   const struct net_device *out, const void *matchdata,
 	   unsigned int datalen);
 	bool (*check)(const char *tablename, unsigned int hookmask,
diff --git a/net/bridge/netfilter/ebt_802_3.c b/net/bridge/netfilter/ebt_802_3.c
index 868df9c..8ebe62b 100644
--- a/net/bridge/netfilter/ebt_802_3.c
+++ b/net/bridge/netfilter/ebt_802_3.c
@@ -12,7 +12,8 @@
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_802_3.h>
 
-static int ebt_filter_802_3(const struct sk_buff *skb, const struct net_device *in,
+static bool ebt_filter_802_3(const struct sk_buff *skb,
+   const struct net_device *in,
    const struct net_device *out, const void *data, unsigned int datalen)
 {
 	const struct ebt_802_3_info *info = data;
@@ -21,19 +22,19 @@ static int ebt_filter_802_3(const struct sk_buff *skb, const struct net_device *
 
 	if (info->bitmask & EBT_802_3_SAP) {
 		if (FWINV(info->sap != hdr->llc.ui.ssap, EBT_802_3_SAP))
-				return EBT_NOMATCH;
+			return false;
 		if (FWINV(info->sap != hdr->llc.ui.dsap, EBT_802_3_SAP))
-				return EBT_NOMATCH;
+			return false;
 	}
 
 	if (info->bitmask & EBT_802_3_TYPE) {
 		if (!(hdr->llc.ui.dsap == CHECK_TYPE && hdr->llc.ui.ssap == CHECK_TYPE))
-			return EBT_NOMATCH;
+			return false;
 		if (FWINV(info->type != type, EBT_802_3_TYPE))
-			return EBT_NOMATCH;
+			return false;
 	}
 
-	return EBT_MATCH;
+	return true;
 }
 
 static struct ebt_match filter_802_3;
diff --git a/net/bridge/netfilter/ebt_among.c b/net/bridge/netfilter/ebt_among.c
index 95e2e70..bfdc67b 100644
--- a/net/bridge/netfilter/ebt_among.c
+++ b/net/bridge/netfilter/ebt_among.c
@@ -14,8 +14,8 @@
 #include <linux/if_arp.h>
 #include <linux/module.h>
 
-static int ebt_mac_wormhash_contains(const struct ebt_mac_wormhash *wh,
-				     const char *mac, __be32 ip)
+static bool ebt_mac_wormhash_contains(const struct ebt_mac_wormhash *wh,
+				      const char *mac, __be32 ip)
 {
 	/* You may be puzzled as to how this code works.
 	 * Some tricks were used, refer to
@@ -33,23 +33,19 @@ static int ebt_mac_wormhash_contains(const struct ebt_mac_wormhash *wh,
 	if (ip) {
 		for (i = start; i < limit; i++) {
 			p = &wh->pool[i];
-			if (cmp[1] == p->cmp[1] && cmp[0] == p->cmp[0]) {
-				if (p->ip == 0 || p->ip == ip) {
-					return 1;
-				}
-			}
+			if (cmp[1] == p->cmp[1] && cmp[0] == p->cmp[0])
+				if (p->ip == 0 || p->ip == ip)
+					return true;
 		}
 	} else {
 		for (i = start; i < limit; i++) {
 			p = &wh->pool[i];
-			if (cmp[1] == p->cmp[1] && cmp[0] == p->cmp[0]) {
-				if (p->ip == 0) {
-					return 1;
-				}
-			}
+			if (cmp[1] == p->cmp[1] && cmp[0] == p->cmp[0])
+				if (p->ip == 0)
+					return true;
 		}
 	}
-	return 0;
+	return false;
 }
 
 static int ebt_mac_wormhash_check_integrity(const struct ebt_mac_wormhash
@@ -131,10 +127,10 @@ static int get_ip_src(const struct sk_buff *skb, __be32 *addr)
 	return 0;
 }
 
-static int ebt_filter_among(const struct sk_buff *skb,
-			    const struct net_device *in,
-			    const struct net_device *out, const void *data,
-			    unsigned int datalen)
+static bool ebt_filter_among(const struct sk_buff *skb,
+			     const struct net_device *in,
+			     const struct net_device *out, const void *data,
+			     unsigned int datalen)
 {
 	const struct ebt_among_info *info = data;
 	const char *dmac, *smac;
@@ -147,34 +143,34 @@ static int ebt_filter_among(const struct sk_buff *skb,
 	if (wh_src) {
 		smac = eth_hdr(skb)->h_source;
 		if (get_ip_src(skb, &sip))
-			return EBT_NOMATCH;
+			return false;
 		if (!(info->bitmask & EBT_AMONG_SRC_NEG)) {
 			/* we match only if it contains */
 			if (!ebt_mac_wormhash_contains(wh_src, smac, sip))
-				return EBT_NOMATCH;
+				return false;
 		} else {
 			/* we match only if it DOES NOT contain */
 			if (ebt_mac_wormhash_contains(wh_src, smac, sip))
-				return EBT_NOMATCH;
+				return false;
 		}
 	}
 
 	if (wh_dst) {
 		dmac = eth_hdr(skb)->h_dest;
 		if (get_ip_dst(skb, &dip))
-			return EBT_NOMATCH;
+			return false;
 		if (!(info->bitmask & EBT_AMONG_DST_NEG)) {
 			/* we match only if it contains */
 			if (!ebt_mac_wormhash_contains(wh_dst, dmac, dip))
-				return EBT_NOMATCH;
+				return false;
 		} else {
 			/* we match only if it DOES NOT contain */
 			if (ebt_mac_wormhash_contains(wh_dst, dmac, dip))
-				return EBT_NOMATCH;
+				return false;
 		}
 	}
 
-	return EBT_MATCH;
+	return true;
 }
 
 static bool
diff --git a/net/bridge/netfilter/ebt_arp.c b/net/bridge/netfilter/ebt_arp.c
index cb33672..f1f0bcf 100644
--- a/net/bridge/netfilter/ebt_arp.c
+++ b/net/bridge/netfilter/ebt_arp.c
@@ -15,7 +15,8 @@
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_arp.h>
 
-static int ebt_filter_arp(const struct sk_buff *skb, const struct net_device *in,
+static bool ebt_filter_arp(const struct sk_buff *skb,
+   const struct net_device *in,
    const struct net_device *out, const void *data, unsigned int datalen)
 {
 	const struct ebt_arp_info *info = data;
@@ -24,42 +25,42 @@ static int ebt_filter_arp(const struct sk_buff *skb, const struct net_device *in
 
 	ah = skb_header_pointer(skb, 0, sizeof(_arph), &_arph);
 	if (ah == NULL)
-		return EBT_NOMATCH;
+		return false;
 	if (info->bitmask & EBT_ARP_OPCODE && FWINV(info->opcode !=
 	   ah->ar_op, EBT_ARP_OPCODE))
-		return EBT_NOMATCH;
+		return false;
 	if (info->bitmask & EBT_ARP_HTYPE && FWINV(info->htype !=
 	   ah->ar_hrd, EBT_ARP_HTYPE))
-		return EBT_NOMATCH;
+		return false;
 	if (info->bitmask & EBT_ARP_PTYPE && FWINV(info->ptype !=
 	   ah->ar_pro, EBT_ARP_PTYPE))
-		return EBT_NOMATCH;
+		return false;
 
 	if (info->bitmask & (EBT_ARP_SRC_IP | EBT_ARP_DST_IP | EBT_ARP_GRAT)) {
 		const __be32 *sap, *dap;
 		__be32 saddr, daddr;
 
 		if (ah->ar_pln != sizeof(__be32) || ah->ar_pro != htons(ETH_P_IP))
-			return EBT_NOMATCH;
+			return false;
 		sap = skb_header_pointer(skb, sizeof(struct arphdr) +
 					ah->ar_hln, sizeof(saddr),
 					&saddr);
 		if (sap == NULL)
-			return EBT_NOMATCH;
+			return false;
 		dap = skb_header_pointer(skb, sizeof(struct arphdr) +
 					2*ah->ar_hln+sizeof(saddr),
 					sizeof(daddr), &daddr);
 		if (dap == NULL)
-			return EBT_NOMATCH;
+			return false;
 		if (info->bitmask & EBT_ARP_SRC_IP &&
 		    FWINV(info->saddr != (*sap & info->smsk), EBT_ARP_SRC_IP))
-			return EBT_NOMATCH;
+			return false;
 		if (info->bitmask & EBT_ARP_DST_IP &&
 		    FWINV(info->daddr != (*dap & info->dmsk), EBT_ARP_DST_IP))
-			return EBT_NOMATCH;
+			return false;
 		if (info->bitmask & EBT_ARP_GRAT &&
 		    FWINV(*dap != *sap, EBT_ARP_GRAT))
-			return EBT_NOMATCH;
+			return false;
 	}
 
 	if (info->bitmask & (EBT_ARP_SRC_MAC | EBT_ARP_DST_MAC)) {
@@ -68,18 +69,18 @@ static int ebt_filter_arp(const struct sk_buff *skb, const struct net_device *in
 		uint8_t verdict, i;
 
 		if (ah->ar_hln != ETH_ALEN || ah->ar_hrd != htons(ARPHRD_ETHER))
-			return EBT_NOMATCH;
+			return false;
 		if (info->bitmask & EBT_ARP_SRC_MAC) {
 			mp = skb_header_pointer(skb, sizeof(struct arphdr),
 						sizeof(_mac), &_mac);
 			if (mp == NULL)
-				return EBT_NOMATCH;
+				return false;
 			verdict = 0;
 			for (i = 0; i < 6; i++)
 				verdict |= (mp[i] ^ info->smaddr[i]) &
 				       info->smmsk[i];
 			if (FWINV(verdict != 0, EBT_ARP_SRC_MAC))
-				return EBT_NOMATCH;
+				return false;
 		}
 
 		if (info->bitmask & EBT_ARP_DST_MAC) {
@@ -87,17 +88,17 @@ static int ebt_filter_arp(const struct sk_buff *skb, const struct net_device *in
 						ah->ar_hln + ah->ar_pln,
 						sizeof(_mac), &_mac);
 			if (mp == NULL)
-				return EBT_NOMATCH;
+				return false;
 			verdict = 0;
 			for (i = 0; i < 6; i++)
 				verdict |= (mp[i] ^ info->dmaddr[i]) &
 					info->dmmsk[i];
 			if (FWINV(verdict != 0, EBT_ARP_DST_MAC))
-				return EBT_NOMATCH;
+				return false;
 		}
 	}
 
-	return EBT_MATCH;
+	return true;
 }
 
 static bool ebt_arp_check(const char *tablename, unsigned int hookmask,
diff --git a/net/bridge/netfilter/ebt_ip.c b/net/bridge/netfilter/ebt_ip.c
index cbf0918..018782f 100644
--- a/net/bridge/netfilter/ebt_ip.c
+++ b/net/bridge/netfilter/ebt_ip.c
@@ -24,7 +24,8 @@ struct tcpudphdr {
 	__be16 dst;
 };
 
-static int ebt_filter_ip(const struct sk_buff *skb, const struct net_device *in,
+static bool ebt_filter_ip(const struct sk_buff *skb,
+   const struct net_device *in,
    const struct net_device *out, const void *data,
    unsigned int datalen)
 {
@@ -36,46 +37,46 @@ static int ebt_filter_ip(const struct sk_buff *skb, const struct net_device *in,
 
 	ih = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
 	if (ih == NULL)
-		return EBT_NOMATCH;
+		return false;
 	if (info->bitmask & EBT_IP_TOS &&
 	   FWINV(info->tos != ih->tos, EBT_IP_TOS))
-		return EBT_NOMATCH;
+		return false;
 	if (info->bitmask & EBT_IP_SOURCE &&
 	   FWINV((ih->saddr & info->smsk) !=
 	   info->saddr, EBT_IP_SOURCE))
-		return EBT_NOMATCH;
+		return false;
 	if ((info->bitmask & EBT_IP_DEST) &&
 	   FWINV((ih->daddr & info->dmsk) !=
 	   info->daddr, EBT_IP_DEST))
-		return EBT_NOMATCH;
+		return false;
 	if (info->bitmask & EBT_IP_PROTO) {
 		if (FWINV(info->protocol != ih->protocol, EBT_IP_PROTO))
-			return EBT_NOMATCH;
+			return false;
 		if (!(info->bitmask & EBT_IP_DPORT) &&
 		    !(info->bitmask & EBT_IP_SPORT))
-			return EBT_MATCH;
+			return true;
 		if (ntohs(ih->frag_off) & IP_OFFSET)
-			return EBT_NOMATCH;
+			return false;
 		pptr = skb_header_pointer(skb, ih->ihl*4,
 					  sizeof(_ports), &_ports);
 		if (pptr == NULL)
-			return EBT_NOMATCH;
+			return false;
 		if (info->bitmask & EBT_IP_DPORT) {
 			u32 dst = ntohs(pptr->dst);
 			if (FWINV(dst < info->dport[0] ||
 				  dst > info->dport[1],
 				  EBT_IP_DPORT))
-			return EBT_NOMATCH;
+			return false;
 		}
 		if (info->bitmask & EBT_IP_SPORT) {
 			u32 src = ntohs(pptr->src);
 			if (FWINV(src < info->sport[0] ||
 				  src > info->sport[1],
 				  EBT_IP_SPORT))
-			return EBT_NOMATCH;
+			return false;
 		}
 	}
-	return EBT_MATCH;
+	return true;
 }
 
 static bool ebt_ip_check(const char *tablename, unsigned int hookmask,
diff --git a/net/bridge/netfilter/ebt_ip6.c b/net/bridge/netfilter/ebt_ip6.c
index 1230c9e..7fc3928 100644
--- a/net/bridge/netfilter/ebt_ip6.c
+++ b/net/bridge/netfilter/ebt_ip6.c
@@ -27,7 +27,7 @@ struct tcpudphdr {
 	__be16 dst;
 };
 
-static int ebt_filter_ip6(const struct sk_buff *skb,
+static bool ebt_filter_ip6(const struct sk_buff *skb,
    const struct net_device *in,
    const struct net_device *out, const void *data,
    unsigned int datalen)
@@ -42,54 +42,54 @@ static int ebt_filter_ip6(const struct sk_buff *skb,
 
 	ih6 = skb_header_pointer(skb, 0, sizeof(_ip6h), &_ip6h);
 	if (ih6 == NULL)
-		return EBT_NOMATCH;
+		return false;
 	if (info->bitmask & EBT_IP6_TCLASS &&
 	   FWINV(info->tclass != ipv6_get_dsfield(ih6), EBT_IP6_TCLASS))
-		return EBT_NOMATCH;
+		return false;
 	for (i = 0; i < 4; i++)
 		tmp_addr.in6_u.u6_addr32[i] = ih6->saddr.in6_u.u6_addr32[i] &
 			info->smsk.in6_u.u6_addr32[i];
 	if (info->bitmask & EBT_IP6_SOURCE &&
 		FWINV((ipv6_addr_cmp(&tmp_addr, &info->saddr) != 0),
 			EBT_IP6_SOURCE))
-		return EBT_NOMATCH;
+		return false;
 	for (i = 0; i < 4; i++)
 		tmp_addr.in6_u.u6_addr32[i] = ih6->daddr.in6_u.u6_addr32[i] &
 			info->dmsk.in6_u.u6_addr32[i];
 	if (info->bitmask & EBT_IP6_DEST &&
 	   FWINV((ipv6_addr_cmp(&tmp_addr, &info->daddr) != 0), EBT_IP6_DEST))
-		return EBT_NOMATCH;
+		return false;
 	if (info->bitmask & EBT_IP6_PROTO) {
 		uint8_t nexthdr = ih6->nexthdr;
 		int offset_ph;
 
 		offset_ph = ipv6_skip_exthdr(skb, sizeof(_ip6h), &nexthdr);
 		if (offset_ph == -1)
-			return EBT_NOMATCH;
+			return false;
 		if (FWINV(info->protocol != nexthdr, EBT_IP6_PROTO))
-			return EBT_NOMATCH;
+			return false;
 		if (!(info->bitmask & EBT_IP6_DPORT) &&
 		    !(info->bitmask & EBT_IP6_SPORT))
-			return EBT_MATCH;
+			return true;
 		pptr = skb_header_pointer(skb, offset_ph, sizeof(_ports),
 					  &_ports);
 		if (pptr == NULL)
-			return EBT_NOMATCH;
+			return false;
 		if (info->bitmask & EBT_IP6_DPORT) {
 			u32 dst = ntohs(pptr->dst);
 			if (FWINV(dst < info->dport[0] ||
 				  dst > info->dport[1], EBT_IP6_DPORT))
-				return EBT_NOMATCH;
+				return false;
 		}
 		if (info->bitmask & EBT_IP6_SPORT) {
 			u32 src = ntohs(pptr->src);
 			if (FWINV(src < info->sport[0] ||
 				  src > info->sport[1], EBT_IP6_SPORT))
-			return EBT_NOMATCH;
+			return false;
 		}
-		return EBT_MATCH;
+		return true;
 	}
-	return EBT_MATCH;
+	return true;
 }
 
 static bool ebt_ip6_check(const char *tablename, unsigned int hookmask,
diff --git a/net/bridge/netfilter/ebt_limit.c b/net/bridge/netfilter/ebt_limit.c
index 9b04f2b..925065a 100644
--- a/net/bridge/netfilter/ebt_limit.c
+++ b/net/bridge/netfilter/ebt_limit.c
@@ -30,7 +30,7 @@ static DEFINE_SPINLOCK(limit_lock);
 
 #define CREDITS_PER_JIFFY POW2_BELOW32(MAX_CPJ)
 
-static int ebt_limit_match(const struct sk_buff *skb,
+static bool ebt_limit_match(const struct sk_buff *skb,
    const struct net_device *in, const struct net_device *out,
    const void *data, unsigned int datalen)
 {
@@ -46,11 +46,11 @@ static int ebt_limit_match(const struct sk_buff *skb,
 		/* We're not limited. */
 		info->credit -= info->cost;
 		spin_unlock_bh(&limit_lock);
-		return EBT_MATCH;
+		return true;
 	}
 
 	spin_unlock_bh(&limit_lock);
-	return EBT_NOMATCH;
+	return false;
 }
 
 /* Precision saver. */
diff --git a/net/bridge/netfilter/ebt_mark_m.c b/net/bridge/netfilter/ebt_mark_m.c
index b2707d7..ec16c0e 100644
--- a/net/bridge/netfilter/ebt_mark_m.c
+++ b/net/bridge/netfilter/ebt_mark_m.c
@@ -12,15 +12,15 @@
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_mark_m.h>
 
-static int ebt_filter_mark(const struct sk_buff *skb,
+static bool ebt_filter_mark(const struct sk_buff *skb,
    const struct net_device *in, const struct net_device *out, const void *data,
    unsigned int datalen)
 {
 	const struct ebt_mark_m_info *info = data;
 
 	if (info->bitmask & EBT_MARK_OR)
-		return !(!!(skb->mark & info->mask) ^ info->invert);
-	return !(((skb->mark & info->mask) == info->mark) ^ info->invert);
+		return !!(skb->mark & info->mask) ^ info->invert;
+	return ((skb->mark & info->mask) == info->mark) ^ info->invert;
 }
 
 static bool ebt_mark_check(const char *tablename, unsigned int hookmask,
diff --git a/net/bridge/netfilter/ebt_pkttype.c b/net/bridge/netfilter/ebt_pkttype.c
index 4dcd3b8..74b4432 100644
--- a/net/bridge/netfilter/ebt_pkttype.c
+++ b/net/bridge/netfilter/ebt_pkttype.c
@@ -12,7 +12,7 @@
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_pkttype.h>
 
-static int ebt_filter_pkttype(const struct sk_buff *skb,
+static bool ebt_filter_pkttype(const struct sk_buff *skb,
    const struct net_device *in,
    const struct net_device *out,
    const void *data,
@@ -20,7 +20,7 @@ static int ebt_filter_pkttype(const struct sk_buff *skb,
 {
 	const struct ebt_pkttype_info *info = data;
 
-	return (skb->pkt_type != info->pkt_type) ^ info->invert;
+	return (skb->pkt_type == info->pkt_type) ^ info->invert;
 }
 
 static bool ebt_pkttype_check(const char *tablename, unsigned int hookmask,
diff --git a/net/bridge/netfilter/ebt_stp.c b/net/bridge/netfilter/ebt_stp.c
index 37d9480..7618206 100644
--- a/net/bridge/netfilter/ebt_stp.c
+++ b/net/bridge/netfilter/ebt_stp.c
@@ -40,7 +40,7 @@ struct stp_config_pdu {
 #define NR16(p) (p[0] << 8 | p[1])
 #define NR32(p) ((p[0] << 24) | (p[1] << 16) | (p[2] << 8) | p[3])
 
-static int ebt_filter_config(const struct ebt_stp_info *info,
+static bool ebt_filter_config(const struct ebt_stp_info *info,
    const struct stp_config_pdu *stpc)
 {
 	const struct ebt_stp_config_info *c;
@@ -51,12 +51,12 @@ static int ebt_filter_config(const struct ebt_stp_info *info,
 	c = &info->config;
 	if ((info->bitmask & EBT_STP_FLAGS) &&
 	    FWINV(c->flags != stpc->flags, EBT_STP_FLAGS))
-		return EBT_NOMATCH;
+		return false;
 	if (info->bitmask & EBT_STP_ROOTPRIO) {
 		v16 = NR16(stpc->root);
 		if (FWINV(v16 < c->root_priol ||
 		    v16 > c->root_priou, EBT_STP_ROOTPRIO))
-			return EBT_NOMATCH;
+			return false;
 	}
 	if (info->bitmask & EBT_STP_ROOTADDR) {
 		verdict = 0;
@@ -64,19 +64,19 @@ static int ebt_filter_config(const struct ebt_stp_info *info,
 			verdict |= (stpc->root[2+i] ^ c->root_addr[i]) &
 				   c->root_addrmsk[i];
 		if (FWINV(verdict != 0, EBT_STP_ROOTADDR))
-			return EBT_NOMATCH;
+			return false;
 	}
 	if (info->bitmask & EBT_STP_ROOTCOST) {
 		v32 = NR32(stpc->root_cost);
 		if (FWINV(v32 < c->root_costl ||
 		    v32 > c->root_costu, EBT_STP_ROOTCOST))
-			return EBT_NOMATCH;
+			return false;
 	}
 	if (info->bitmask & EBT_STP_SENDERPRIO) {
 		v16 = NR16(stpc->sender);
 		if (FWINV(v16 < c->sender_priol ||
 		    v16 > c->sender_priou, EBT_STP_SENDERPRIO))
-			return EBT_NOMATCH;
+			return false;
 	}
 	if (info->bitmask & EBT_STP_SENDERADDR) {
 		verdict = 0;
@@ -84,42 +84,43 @@ static int ebt_filter_config(const struct ebt_stp_info *info,
 			verdict |= (stpc->sender[2+i] ^ c->sender_addr[i]) &
 				   c->sender_addrmsk[i];
 		if (FWINV(verdict != 0, EBT_STP_SENDERADDR))
-			return EBT_NOMATCH;
+			return false;
 	}
 	if (info->bitmask & EBT_STP_PORT) {
 		v16 = NR16(stpc->port);
 		if (FWINV(v16 < c->portl ||
 		    v16 > c->portu, EBT_STP_PORT))
-			return EBT_NOMATCH;
+			return false;
 	}
 	if (info->bitmask & EBT_STP_MSGAGE) {
 		v16 = NR16(stpc->msg_age);
 		if (FWINV(v16 < c->msg_agel ||
 		    v16 > c->msg_ageu, EBT_STP_MSGAGE))
-			return EBT_NOMATCH;
+			return false;
 	}
 	if (info->bitmask & EBT_STP_MAXAGE) {
 		v16 = NR16(stpc->max_age);
 		if (FWINV(v16 < c->max_agel ||
 		    v16 > c->max_ageu, EBT_STP_MAXAGE))
-			return EBT_NOMATCH;
+			return false;
 	}
 	if (info->bitmask & EBT_STP_HELLOTIME) {
 		v16 = NR16(stpc->hello_time);
 		if (FWINV(v16 < c->hello_timel ||
 		    v16 > c->hello_timeu, EBT_STP_HELLOTIME))
-			return EBT_NOMATCH;
+			return false;
 	}
 	if (info->bitmask & EBT_STP_FWDD) {
 		v16 = NR16(stpc->forward_delay);
 		if (FWINV(v16 < c->forward_delayl ||
 		    v16 > c->forward_delayu, EBT_STP_FWDD))
-			return EBT_NOMATCH;
+			return false;
 	}
-	return EBT_MATCH;
+	return true;
 }
 
-static int ebt_filter_stp(const struct sk_buff *skb, const struct net_device *in,
+static bool ebt_filter_stp(const struct sk_buff *skb,
+   const struct net_device *in,
    const struct net_device *out, const void *data, unsigned int datalen)
 {
 	const struct ebt_stp_info *info = data;
@@ -129,15 +130,15 @@ static int ebt_filter_stp(const struct sk_buff *skb, const struct net_device *in
 
 	sp = skb_header_pointer(skb, 0, sizeof(_stph), &_stph);
 	if (sp == NULL)
-		return EBT_NOMATCH;
+		return false;
 
 	/* The stp code only considers these */
 	if (memcmp(sp, header, sizeof(header)))
-		return EBT_NOMATCH;
+		return false;
 
 	if (info->bitmask & EBT_STP_TYPE
 	    && FWINV(info->type != sp->type, EBT_STP_TYPE))
-		return EBT_NOMATCH;
+		return false;
 
 	if (sp->type == BPDU_TYPE_CONFIG &&
 	    info->bitmask & EBT_STP_CONFIG_MASK) {
@@ -147,10 +148,10 @@ static int ebt_filter_stp(const struct sk_buff *skb, const struct net_device *in
 		st = skb_header_pointer(skb, sizeof(_stph),
 					sizeof(_stpc), &_stpc);
 		if (st == NULL)
-			return EBT_NOMATCH;
+			return false;
 		return ebt_filter_config(info, st);
 	}
-	return EBT_MATCH;
+	return true;
 }
 
 static bool ebt_stp_check(const char *tablename, unsigned int hookmask,
diff --git a/net/bridge/netfilter/ebt_vlan.c b/net/bridge/netfilter/ebt_vlan.c
index fc88d5d..8cc4257 100644
--- a/net/bridge/netfilter/ebt_vlan.c
+++ b/net/bridge/netfilter/ebt_vlan.c
@@ -38,9 +38,9 @@ MODULE_LICENSE("GPL");
 
 #define DEBUG_MSG(args...) if (debug) printk (KERN_DEBUG "ebt_vlan: " args)
 #define GET_BITMASK(_BIT_MASK_) info->bitmask & _BIT_MASK_
-#define EXIT_ON_MISMATCH(_MATCH_,_MASK_) {if (!((info->_MATCH_ == _MATCH_)^!!(info->invflags & _MASK_))) return EBT_NOMATCH;}
+#define EXIT_ON_MISMATCH(_MATCH_,_MASK_) {if (!((info->_MATCH_ == _MATCH_)^!!(info->invflags & _MASK_))) return false; }
 
-static int
+static bool
 ebt_filter_vlan(const struct sk_buff *skb,
 		const struct net_device *in,
 		const struct net_device *out,
@@ -58,7 +58,7 @@ ebt_filter_vlan(const struct sk_buff *skb,
 
 	fp = skb_header_pointer(skb, 0, sizeof(_frame), &_frame);
 	if (fp == NULL)
-		return EBT_NOMATCH;
+		return false;
 
 	/* Tag Control Information (TCI) consists of the following elements:
 	 * - User_priority. The user_priority field is three bits in length,
@@ -84,7 +84,7 @@ ebt_filter_vlan(const struct sk_buff *skb,
 	if (GET_BITMASK(EBT_VLAN_ENCAP))
 		EXIT_ON_MISMATCH(encap, EBT_VLAN_ENCAP);
 
-	return EBT_MATCH;
+	return true;
 }
 
 static bool
