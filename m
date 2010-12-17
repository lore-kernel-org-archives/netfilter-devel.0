From: Florian Westphal <fw@strlen.de>
Subject: [PATCH] netfilter: ebt_ip6: allow matching on ipv6-icmp types/codes
Date: Fri, 17 Dec 2010 16:27:02 +0100
Message-ID: <20101217152702.GB15737@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:44678 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753006Ab0LQP1E (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Dec 2010 10:27:04 -0500
Received: id: fw by Chamillionaire.breakpoint.cc with local
	(easymta 1.00 BETA 1)
	id 1PTcD0-00046s-Qh
	for netfilter-devel@vger.kernel.org; Fri, 17 Dec 2010 16:27:02 +0100
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

To avoid adding a new match revision icmp type/code are stored
in the sport/dport area.

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Holger Eitzenberger <holger@eitzenberger.org>
---
 patch for ebtables userspace will follow soon.

 include/linux/netfilter_bridge/ebt_ip6.h |   15 +++++++++--
 net/bridge/netfilter/ebt_ip6.c           |   40 ++++++++++++++++++++++-------
 2 files changed, 42 insertions(+), 13 deletions(-)

diff --git a/include/linux/netfilter_bridge/ebt_ip6.h b/include/linux/netfilter_bridge/ebt_ip6.h
index e5de987..22af18a 100644
--- a/include/linux/netfilter_bridge/ebt_ip6.h
+++ b/include/linux/netfilter_bridge/ebt_ip6.h
@@ -18,8 +18,11 @@
 #define EBT_IP6_PROTO 0x08
 #define EBT_IP6_SPORT 0x10
 #define EBT_IP6_DPORT 0x20
+#define EBT_IP6_ICMP6 0x40
+
 #define EBT_IP6_MASK (EBT_IP6_SOURCE | EBT_IP6_DEST | EBT_IP6_TCLASS |\
-		      EBT_IP6_PROTO | EBT_IP6_SPORT | EBT_IP6_DPORT)
+		      EBT_IP6_PROTO | EBT_IP6_SPORT | EBT_IP6_DPORT | \
+		      EBT_IP6_ICMP6)
 #define EBT_IP6_MATCH "ip6"
 
 /* the same values are used for the invflags */
@@ -32,8 +35,14 @@ struct ebt_ip6_info {
 	uint8_t  protocol;
 	uint8_t  bitmask;
 	uint8_t  invflags;
-	uint16_t sport[2];
-	uint16_t dport[2];
+	union {
+		uint16_t sport[2];
+		uint8_t icmpv6_type[2];
+	};
+	union {
+		uint16_t dport[2];
+		uint8_t icmpv6_code[2];
+	};
 };
 
 #endif
diff --git a/net/bridge/netfilter/ebt_ip6.c b/net/bridge/netfilter/ebt_ip6.c
index 50a46af..e6e5bbe 100644
--- a/net/bridge/netfilter/ebt_ip6.c
+++ b/net/bridge/netfilter/ebt_ip6.c
@@ -22,9 +22,15 @@
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_ip6.h>
 
-struct tcpudphdr {
-	__be16 src;
-	__be16 dst;
+union pkthdr {
+	struct {
+		__be16 src;
+		__be16 dst;
+	} tcpudphdr;
+	struct {
+		u8 type;
+		u8 code;
+	} icmphdr;
 };
 
 static bool
@@ -33,8 +39,8 @@ ebt_ip6_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	const struct ebt_ip6_info *info = par->matchinfo;
 	const struct ipv6hdr *ih6;
 	struct ipv6hdr _ip6h;
-	const struct tcpudphdr *pptr;
-	struct tcpudphdr _ports;
+	const union pkthdr *pptr;
+	union pkthdr _ports;
 
 	ih6 = skb_header_pointer(skb, 0, sizeof(_ip6h), &_ip6h);
 	if (ih6 == NULL)
@@ -56,26 +62,32 @@ ebt_ip6_mt(const struct sk_buff *skb, struct xt_action_param *par)
 			return false;
 		if (FWINV(info->protocol != nexthdr, EBT_IP6_PROTO))
 			return false;
-		if (!(info->bitmask & EBT_IP6_DPORT) &&
-		    !(info->bitmask & EBT_IP6_SPORT))
+		if (!(info->bitmask & ( EBT_IP6_DPORT |
+					EBT_IP6_SPORT | EBT_IP6_ICMP6)))
 			return true;
 		pptr = skb_header_pointer(skb, offset_ph, sizeof(_ports),
 					  &_ports);
 		if (pptr == NULL)
 			return false;
 		if (info->bitmask & EBT_IP6_DPORT) {
-			u32 dst = ntohs(pptr->dst);
+			u32 dst = ntohs(pptr->tcpudphdr.dst);
 			if (FWINV(dst < info->dport[0] ||
 				  dst > info->dport[1], EBT_IP6_DPORT))
 				return false;
 		}
 		if (info->bitmask & EBT_IP6_SPORT) {
-			u32 src = ntohs(pptr->src);
+			u32 src = ntohs(pptr->tcpudphdr.src);
 			if (FWINV(src < info->sport[0] ||
 				  src > info->sport[1], EBT_IP6_SPORT))
 			return false;
 		}
-		return true;
+		if ((info->bitmask & EBT_IP6_ICMP6) &&
+		     FWINV(pptr->icmphdr.type < info->icmpv6_type[0] ||
+			   pptr->icmphdr.type > info->icmpv6_type[1] ||
+			   pptr->icmphdr.code < info->icmpv6_code[0] ||
+			   pptr->icmphdr.code > info->icmpv6_code[1],
+							EBT_IP6_ICMP6))
+			return false;
 	}
 	return true;
 }
@@ -103,6 +115,14 @@ static int ebt_ip6_mt_check(const struct xt_mtchk_param *par)
 		return -EINVAL;
 	if (info->bitmask & EBT_IP6_SPORT && info->sport[0] > info->sport[1])
 		return -EINVAL;
+	if (info->bitmask & EBT_IP6_ICMP6) {
+		if ((info->invflags & EBT_IP6_PROTO ||
+		     info->protocol != IPPROTO_ICMPV6))
+			return -EINVAL;
+		if (info->icmpv6_type[0] > info->icmpv6_type[1] ||
+		    info->icmpv6_code[0] > info->icmpv6_code[1])
+			return -EINVAL;
+	}
 	return 0;
 }
 
-- 
1.7.2.2

