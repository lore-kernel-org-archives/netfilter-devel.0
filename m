From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 33/47] netfilter: ebtables: add support for matching IGMP type
Date: Fri, 30 Mar 2018 13:44:55 +0200
Message-ID: <20180330114509.18738-4-pablo@netfilter.org>
References: <20180330114509.18738-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330114509.18738-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Matthias Schiffer <mschiffer@universe-factory.net>

We already have ICMPv6 type/code matches (which can be used to distinguish
different types of MLD packets). Add support for IPv4 IGMP matches in the
same way.

Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter_bridge/ebt_ip.h |  4 +++-
 net/bridge/netfilter/ebt_ip.c                | 19 +++++++++++++++++--
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/netfilter_bridge/ebt_ip.h b/include/uapi/linux/netfilter_bridge/ebt_ip.h
index 4ed7fbb0a482..46d6261370b0 100644
--- a/include/uapi/linux/netfilter_bridge/ebt_ip.h
+++ b/include/uapi/linux/netfilter_bridge/ebt_ip.h
@@ -25,8 +25,9 @@
 #define EBT_IP_SPORT 0x10
 #define EBT_IP_DPORT 0x20
 #define EBT_IP_ICMP 0x40
+#define EBT_IP_IGMP 0x80
 #define EBT_IP_MASK (EBT_IP_SOURCE | EBT_IP_DEST | EBT_IP_TOS | EBT_IP_PROTO |\
-		     EBT_IP_SPORT | EBT_IP_DPORT | EBT_IP_ICMP)
+		     EBT_IP_SPORT | EBT_IP_DPORT | EBT_IP_ICMP | EBT_IP_IGMP)
 #define EBT_IP_MATCH "ip"
 
 /* the same values are used for the invflags */
@@ -42,6 +43,7 @@ struct ebt_ip_info {
 	union {
 		__u16 sport[2];
 		__u8 icmp_type[2];
+		__u8 igmp_type[2];
 	};
 	union {
 		__u16 dport[2];
diff --git a/net/bridge/netfilter/ebt_ip.c b/net/bridge/netfilter/ebt_ip.c
index 8cb8f8395768..ffaa8ce2e724 100644
--- a/net/bridge/netfilter/ebt_ip.c
+++ b/net/bridge/netfilter/ebt_ip.c
@@ -28,6 +28,9 @@ union pkthdr {
 		u8 type;
 		u8 code;
 	} icmphdr;
+	struct {
+		u8 type;
+	} igmphdr;
 };
 
 static bool
@@ -57,12 +60,12 @@ ebt_ip_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		if (NF_INVF(info, EBT_IP_PROTO, info->protocol != ih->protocol))
 			return false;
 		if (!(info->bitmask & (EBT_IP_DPORT | EBT_IP_SPORT |
-				       EBT_IP_ICMP)))
+				       EBT_IP_ICMP | EBT_IP_IGMP)))
 			return true;
 		if (ntohs(ih->frag_off) & IP_OFFSET)
 			return false;
 
-		/* min icmp headersize is 4, so sizeof(_pkthdr) is ok. */
+		/* min icmp/igmp headersize is 4, so sizeof(_pkthdr) is ok. */
 		pptr = skb_header_pointer(skb, ih->ihl*4,
 					  sizeof(_pkthdr), &_pkthdr);
 		if (pptr == NULL)
@@ -88,6 +91,11 @@ ebt_ip_mt(const struct sk_buff *skb, struct xt_action_param *par)
 			    pptr->icmphdr.code < info->icmp_code[0] ||
 			    pptr->icmphdr.code > info->icmp_code[1]))
 			return false;
+		if ((info->bitmask & EBT_IP_IGMP) &&
+		    NF_INVF(info, EBT_IP_IGMP,
+			    pptr->igmphdr.type < info->igmp_type[0] ||
+			    pptr->igmphdr.type > info->igmp_type[1]))
+			return false;
 	}
 	return true;
 }
@@ -124,6 +132,13 @@ static int ebt_ip_mt_check(const struct xt_mtchk_param *par)
 		    info->icmp_code[0] > info->icmp_code[1])
 			return -EINVAL;
 	}
+	if (info->bitmask & EBT_IP_IGMP) {
+		if ((info->invflags & EBT_IP_PROTO) ||
+		    info->protocol != IPPROTO_IGMP)
+			return -EINVAL;
+		if (info->igmp_type[0] > info->igmp_type[1])
+			return -EINVAL;
+	}
 	return 0;
 }
 
-- 
2.11.0
