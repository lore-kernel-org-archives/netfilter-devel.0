From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 32/47] netfilter: ebtables: add support for matching ICMP type and code
Date: Fri, 30 Mar 2018 13:44:54 +0200
Message-ID: <20180330114509.18738-3-pablo@netfilter.org>
References: <20180330114509.18738-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330114509.18738-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Matthias Schiffer <mschiffer@universe-factory.net>

We already have ICMPv6 type/code matches. This adds support for IPv4 ICMP
matches in the same way.

Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter_bridge/ebt_ip.h | 13 +++++++--
 net/bridge/netfilter/ebt_ip.c                | 43 +++++++++++++++++++++-------
 2 files changed, 43 insertions(+), 13 deletions(-)

diff --git a/include/uapi/linux/netfilter_bridge/ebt_ip.h b/include/uapi/linux/netfilter_bridge/ebt_ip.h
index 8e462fb1983f..4ed7fbb0a482 100644
--- a/include/uapi/linux/netfilter_bridge/ebt_ip.h
+++ b/include/uapi/linux/netfilter_bridge/ebt_ip.h
@@ -24,8 +24,9 @@
 #define EBT_IP_PROTO 0x08
 #define EBT_IP_SPORT 0x10
 #define EBT_IP_DPORT 0x20
+#define EBT_IP_ICMP 0x40
 #define EBT_IP_MASK (EBT_IP_SOURCE | EBT_IP_DEST | EBT_IP_TOS | EBT_IP_PROTO |\
- EBT_IP_SPORT | EBT_IP_DPORT )
+		     EBT_IP_SPORT | EBT_IP_DPORT | EBT_IP_ICMP)
 #define EBT_IP_MATCH "ip"
 
 /* the same values are used for the invflags */
@@ -38,8 +39,14 @@ struct ebt_ip_info {
 	__u8  protocol;
 	__u8  bitmask;
 	__u8  invflags;
-	__u16 sport[2];
-	__u16 dport[2];
+	union {
+		__u16 sport[2];
+		__u8 icmp_type[2];
+	};
+	union {
+		__u16 dport[2];
+		__u8 icmp_code[2];
+	};
 };
 
 #endif
diff --git a/net/bridge/netfilter/ebt_ip.c b/net/bridge/netfilter/ebt_ip.c
index 2b46c50abce0..8cb8f8395768 100644
--- a/net/bridge/netfilter/ebt_ip.c
+++ b/net/bridge/netfilter/ebt_ip.c
@@ -19,9 +19,15 @@
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_ip.h>
 
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
@@ -30,8 +36,8 @@ ebt_ip_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	const struct ebt_ip_info *info = par->matchinfo;
 	const struct iphdr *ih;
 	struct iphdr _iph;
-	const struct tcpudphdr *pptr;
-	struct tcpudphdr _ports;
+	const union pkthdr *pptr;
+	union pkthdr _pkthdr;
 
 	ih = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
 	if (ih == NULL)
@@ -50,29 +56,38 @@ ebt_ip_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	if (info->bitmask & EBT_IP_PROTO) {
 		if (NF_INVF(info, EBT_IP_PROTO, info->protocol != ih->protocol))
 			return false;
-		if (!(info->bitmask & EBT_IP_DPORT) &&
-		    !(info->bitmask & EBT_IP_SPORT))
+		if (!(info->bitmask & (EBT_IP_DPORT | EBT_IP_SPORT |
+				       EBT_IP_ICMP)))
 			return true;
 		if (ntohs(ih->frag_off) & IP_OFFSET)
 			return false;
+
+		/* min icmp headersize is 4, so sizeof(_pkthdr) is ok. */
 		pptr = skb_header_pointer(skb, ih->ihl*4,
-					  sizeof(_ports), &_ports);
+					  sizeof(_pkthdr), &_pkthdr);
 		if (pptr == NULL)
 			return false;
 		if (info->bitmask & EBT_IP_DPORT) {
-			u32 dst = ntohs(pptr->dst);
+			u32 dst = ntohs(pptr->tcpudphdr.dst);
 			if (NF_INVF(info, EBT_IP_DPORT,
 				    dst < info->dport[0] ||
 				    dst > info->dport[1]))
 				return false;
 		}
 		if (info->bitmask & EBT_IP_SPORT) {
-			u32 src = ntohs(pptr->src);
+			u32 src = ntohs(pptr->tcpudphdr.src);
 			if (NF_INVF(info, EBT_IP_SPORT,
 				    src < info->sport[0] ||
 				    src > info->sport[1]))
 				return false;
 		}
+		if ((info->bitmask & EBT_IP_ICMP) &&
+		    NF_INVF(info, EBT_IP_ICMP,
+			    pptr->icmphdr.type < info->icmp_type[0] ||
+			    pptr->icmphdr.type > info->icmp_type[1] ||
+			    pptr->icmphdr.code < info->icmp_code[0] ||
+			    pptr->icmphdr.code > info->icmp_code[1]))
+			return false;
 	}
 	return true;
 }
@@ -101,6 +116,14 @@ static int ebt_ip_mt_check(const struct xt_mtchk_param *par)
 		return -EINVAL;
 	if (info->bitmask & EBT_IP_SPORT && info->sport[0] > info->sport[1])
 		return -EINVAL;
+	if (info->bitmask & EBT_IP_ICMP) {
+		if ((info->invflags & EBT_IP_PROTO) ||
+		    info->protocol != IPPROTO_ICMP)
+			return -EINVAL;
+		if (info->icmp_type[0] > info->icmp_type[1] ||
+		    info->icmp_code[0] > info->icmp_code[1])
+			return -EINVAL;
+	}
 	return 0;
 }
 
-- 
2.11.0
