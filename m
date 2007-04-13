From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/06]: bridge-nf: filter bridged IPv4/IPv6 encapsulated
	in pppoe traffic
Date: Fri, 13 Apr 2007 05:00:09 +0200 (MEST)
Message-ID: <20070413025924.29875.2796.sendpatchset@localhost.localdomain>
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

[NETFILTER]: bridge-nf: filter bridged IPv4/IPv6 encapsulated in pppoe traffic

The attached patch by Michael Milner adds support for using iptables and
ip6tables on bridged traffic encapsulated in ppoe frames, similar to
what's already supported for vlan.

Signed-off-by: Michael Milner <milner@blissisland.ca>
Signed-off-by: Bart De Schuymer <bdschuym@pandora.be>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 2b4788ea9b3c4e532f7cde3f05800c33977f32ee
tree 89fa3b01937da7bff0a6badca6e4fbe3c468d823
parent e5bc163d0150bf7d7deb49a3902d6c0a8a458ef7
author Michael Milner <milner@blissisland.ca> Fri, 13 Apr 2007 04:42:56 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 13 Apr 2007 04:42:56 +0200

 Documentation/networking/ip-sysctl.txt |    7 ++-
 include/linux/if_pppox.h               |    3 +
 include/linux/netfilter_bridge.h       |   11 ++++-
 include/linux/sysctl.h                 |    1 
 net/bridge/br_netfilter.c              |   77 ++++++++++++++++++++++++++++++--
 5 files changed, 92 insertions(+), 7 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index db8b4b7..ce16e6a 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -1006,7 +1006,12 @@ bridge-nf-call-ip6tables - BOOLEAN
 	Default: 1
 
 bridge-nf-filter-vlan-tagged - BOOLEAN
-	1 : pass bridged vlan-tagged ARP/IP traffic to arptables/iptables.
+	1 : pass bridged vlan-tagged ARP/IP/IPv6 traffic to {arp,ip,ip6}tables.
+	0 : disable this.
+	Default: 1
+
+bridge-nf-filter-pppoe-tagged - BOOLEAN
+	1 : pass bridged pppoe-tagged IP/IPv6 traffic to {ip,ip6}tables.
 	0 : disable this.
 	Default: 1
 
diff --git a/include/linux/if_pppox.h b/include/linux/if_pppox.h
index 29d6579..6f987be 100644
--- a/include/linux/if_pppox.h
+++ b/include/linux/if_pppox.h
@@ -111,6 +111,9 @@ struct pppoe_hdr {
 	struct pppoe_tag tag[0];
 } __attribute__ ((packed));
 
+/* Length of entire PPPoE + PPP header */
+#define PPPOE_SES_HLEN	8
+
 #ifdef __KERNEL__
 #include <linux/skbuff.h>
 
diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
index 55689f3..1906003 100644
--- a/include/linux/netfilter_bridge.h
+++ b/include/linux/netfilter_bridge.h
@@ -7,6 +7,7 @@
 #include <linux/netfilter.h>
 #include <linux/if_ether.h>
 #include <linux/if_vlan.h>
+#include <linux/if_pppox.h>
 
 /* Bridge Hooks */
 /* After promisc drops, checksum checks. */
@@ -58,8 +59,14 @@ static inline int nf_bridge_maybe_copy_header(struct sk_buff *skb)
  * enough room for the encapsulating header (if there is one). */
 static inline int nf_bridge_pad(const struct sk_buff *skb)
 {
- 	return (skb->nf_bridge && skb->protocol == htons(ETH_P_8021Q))
-		? VLAN_HLEN : 0;
+	int padding = 0;
+
+	if (skb->nf_bridge && skb->protocol == htons(ETH_P_8021Q))
+		padding = VLAN_HLEN;
+	else if (skb->nf_bridge && skb->protocol == htons(ETH_P_PPP_SES))
+		padding = PPPOE_SES_HLEN;
+
+	return padding;
 }
 
 struct bridge_skb_cb {
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 1e8993b..867db58 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -792,6 +792,7 @@ enum {
 	NET_BRIDGE_NF_CALL_IPTABLES = 2,
 	NET_BRIDGE_NF_CALL_IP6TABLES = 3,
 	NET_BRIDGE_NF_FILTER_VLAN_TAGGED = 4,
+	NET_BRIDGE_NF_FILTER_PPPOE_TAGGED = 5,
 };
 
 /* CTL_FS names: */
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index fd70d04..9b2986b 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -29,6 +29,8 @@
 #include <linux/if_arp.h>
 #include <linux/if_ether.h>
 #include <linux/if_vlan.h>
+#include <linux/if_pppox.h>
+#include <linux/ppp_defs.h>
 #include <linux/netfilter_bridge.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv6.h>
@@ -57,8 +59,10 @@ static int brnf_call_iptables __read_mostly = 1;
 static int brnf_call_ip6tables __read_mostly = 1;
 static int brnf_call_arptables __read_mostly = 1;
 static int brnf_filter_vlan_tagged __read_mostly = 1;
+static int brnf_filter_pppoe_tagged __read_mostly = 1;
 #else
 #define brnf_filter_vlan_tagged 1
+#define brnf_filter_pppoe_tagged 1
 #endif
 
 static inline __be16 vlan_proto(const struct sk_buff *skb)
@@ -81,6 +85,22 @@ static inline __be16 vlan_proto(const struct sk_buff *skb)
 	 vlan_proto(skb) == htons(ETH_P_ARP) &&	\
 	 brnf_filter_vlan_tagged)
 
+static inline __be16 pppoe_proto(const struct sk_buff *skb)
+{
+	return *((__be16 *)(skb_mac_header(skb) + ETH_HLEN +
+			    sizeof(struct pppoe_hdr)));
+}
+
+#define IS_PPPOE_IP(skb) \
+	(skb->protocol == htons(ETH_P_PPP_SES) && \
+	 pppoe_proto(skb) == htons(PPP_IP) && \
+	 brnf_filter_pppoe_tagged)
+
+#define IS_PPPOE_IPV6(skb) \
+	(skb->protocol == htons(ETH_P_PPP_SES) && \
+	 pppoe_proto(skb) == htons(PPP_IPV6) && \
+	 brnf_filter_pppoe_tagged)
+
 /* We need these fake structures to make netfilter happy --
  * lots of places assume that skb->dst != NULL, which isn't
  * all that unreasonable.
@@ -128,6 +148,8 @@ static inline void nf_bridge_save_header(struct sk_buff *skb)
 
 	if (skb->protocol == htons(ETH_P_8021Q))
 		header_size += VLAN_HLEN;
+	else if (skb->protocol == htons(ETH_P_PPP_SES))
+		header_size += PPPOE_SES_HLEN;
 
 	skb_copy_from_linear_data_offset(skb, -header_size,
 					 skb->nf_bridge->data, header_size);
@@ -144,6 +166,8 @@ int nf_bridge_copy_header(struct sk_buff *skb)
 
 	if (skb->protocol == htons(ETH_P_8021Q))
 		header_size += VLAN_HLEN;
+	else if (skb->protocol == htons(ETH_P_PPP_SES))
+		header_size += PPPOE_SES_HLEN;
 
 	err = skb_cow(skb, header_size);
 	if (err)
@@ -154,6 +178,8 @@ int nf_bridge_copy_header(struct sk_buff *skb)
 
 	if (skb->protocol == htons(ETH_P_8021Q))
 		__skb_push(skb, VLAN_HLEN);
+	else if (skb->protocol == htons(ETH_P_PPP_SES))
+		__skb_push(skb, PPPOE_SES_HLEN);
 	return 0;
 }
 
@@ -177,6 +203,9 @@ static int br_nf_pre_routing_finish_ipv6(struct sk_buff *skb)
 	if (skb->protocol == htons(ETH_P_8021Q)) {
 		skb_push(skb, VLAN_HLEN);
 		skb->network_header -= VLAN_HLEN;
+	} else if (skb->protocol == htons(ETH_P_PPP_SES)) {
+		skb_push(skb, PPPOE_SES_HLEN);
+		skb->network_header -= PPPOE_SES_HLEN;
 	}
 	NF_HOOK_THRESH(PF_BRIDGE, NF_BR_PRE_ROUTING, skb, skb->dev, NULL,
 		       br_handle_frame_finish, 1);
@@ -258,6 +287,9 @@ static int br_nf_pre_routing_finish_bridge(struct sk_buff *skb)
 		if (skb->protocol == htons(ETH_P_8021Q)) {
 			skb_pull(skb, VLAN_HLEN);
 			skb->network_header += VLAN_HLEN;
+		} else if (skb->protocol == htons(ETH_P_PPP_SES)) {
+			skb_pull(skb, PPPOE_SES_HLEN);
+			skb->network_header += PPPOE_SES_HLEN;
 		}
 		skb->dst->output(skb);
 	}
@@ -328,6 +360,10 @@ bridged_dnat:
 				    htons(ETH_P_8021Q)) {
 					skb_push(skb, VLAN_HLEN);
 					skb->network_header -= VLAN_HLEN;
+				} else if(skb->protocol ==
+				    htons(ETH_P_PPP_SES)) {
+					skb_push(skb, PPPOE_SES_HLEN);
+					skb->network_header -= PPPOE_SES_HLEN;
 				}
 				NF_HOOK_THRESH(PF_BRIDGE, NF_BR_PRE_ROUTING,
 					       skb, skb->dev, NULL,
@@ -347,6 +383,9 @@ bridged_dnat:
 	if (skb->protocol == htons(ETH_P_8021Q)) {
 		skb_push(skb, VLAN_HLEN);
 		skb->network_header -= VLAN_HLEN;
+	} else if (skb->protocol == htons(ETH_P_PPP_SES)) {
+		skb_push(skb, PPPOE_SES_HLEN);
+		skb->network_header -= PPPOE_SES_HLEN;
 	}
 	NF_HOOK_THRESH(PF_BRIDGE, NF_BR_PRE_ROUTING, skb, skb->dev, NULL,
 		       br_handle_frame_finish, 1);
@@ -489,7 +528,8 @@ static unsigned int br_nf_pre_routing(unsigned int hook, struct sk_buff **pskb,
 	__u32 len;
 	struct sk_buff *skb = *pskb;
 
-	if (skb->protocol == htons(ETH_P_IPV6) || IS_VLAN_IPV6(skb)) {
+	if (skb->protocol == htons(ETH_P_IPV6) || IS_VLAN_IPV6(skb) ||
+	    IS_PPPOE_IPV6(skb)) {
 #ifdef CONFIG_SYSCTL
 		if (!brnf_call_ip6tables)
 			return NF_ACCEPT;
@@ -500,6 +540,9 @@ static unsigned int br_nf_pre_routing(unsigned int hook, struct sk_buff **pskb,
 		if (skb->protocol == htons(ETH_P_8021Q)) {
 			skb_pull_rcsum(skb, VLAN_HLEN);
 			skb->network_header += VLAN_HLEN;
+		} else if (skb->protocol == htons(ETH_P_PPP_SES)) {
+			skb_pull_rcsum(skb, PPPOE_SES_HLEN);
+			skb->network_header += PPPOE_SES_HLEN;
 		}
 		return br_nf_pre_routing_ipv6(hook, skb, in, out, okfn);
 	}
@@ -508,7 +551,8 @@ static unsigned int br_nf_pre_routing(unsigned int hook, struct sk_buff **pskb,
 		return NF_ACCEPT;
 #endif
 
-	if (skb->protocol != htons(ETH_P_IP) && !IS_VLAN_IP(skb))
+	if (skb->protocol != htons(ETH_P_IP) && !IS_VLAN_IP(skb) &&
+	    !IS_PPPOE_IP(skb))
 		return NF_ACCEPT;
 
 	if ((skb = skb_share_check(*pskb, GFP_ATOMIC)) == NULL)
@@ -517,6 +561,9 @@ static unsigned int br_nf_pre_routing(unsigned int hook, struct sk_buff **pskb,
 	if (skb->protocol == htons(ETH_P_8021Q)) {
 		skb_pull_rcsum(skb, VLAN_HLEN);
 		skb->network_header += VLAN_HLEN;
+	} else if (skb->protocol == htons(ETH_P_PPP_SES)) {
+		skb_pull_rcsum(skb, PPPOE_SES_HLEN);
+		skb->network_header += PPPOE_SES_HLEN;
 	}
 
 	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
@@ -598,6 +645,9 @@ static int br_nf_forward_finish(struct sk_buff *skb)
 	if (skb->protocol == htons(ETH_P_8021Q)) {
 		skb_push(skb, VLAN_HLEN);
 		skb->network_header -= VLAN_HLEN;
+	} else if (skb->protocol == htons(ETH_P_PPP_SES)) {
+		skb_push(skb, PPPOE_SES_HLEN);
+		skb->network_header -= PPPOE_SES_HLEN;
 	}
 	NF_HOOK_THRESH(PF_BRIDGE, NF_BR_FORWARD, skb, in,
 		       skb->dev, br_forward_finish, 1);
@@ -626,7 +676,8 @@ static unsigned int br_nf_forward_ip(unsigned int hook, struct sk_buff **pskb,
 	if (!parent)
 		return NF_DROP;
 
-	if (skb->protocol == htons(ETH_P_IP) || IS_VLAN_IP(skb))
+	if (skb->protocol == htons(ETH_P_IP) || IS_VLAN_IP(skb) ||
+	    IS_PPPOE_IP(skb))
 		pf = PF_INET;
 	else
 		pf = PF_INET6;
@@ -634,6 +685,9 @@ static unsigned int br_nf_forward_ip(unsigned int hook, struct sk_buff **pskb,
 	if (skb->protocol == htons(ETH_P_8021Q)) {
 		skb_pull(*pskb, VLAN_HLEN);
 		(*pskb)->network_header += VLAN_HLEN;
+	} else if (skb->protocol == htons(ETH_P_PPP_SES)) {
+		skb_pull(*pskb, PPPOE_SES_HLEN);
+		(*pskb)->network_header += PPPOE_SES_HLEN;
 	}
 
 	nf_bridge = skb->nf_bridge;
@@ -726,6 +780,9 @@ static unsigned int br_nf_local_out(unsigned int hook, struct sk_buff **pskb,
 	if (skb->protocol == htons(ETH_P_8021Q)) {
 		skb_push(skb, VLAN_HLEN);
 		skb->network_header -= VLAN_HLEN;
+	} else if (skb->protocol == htons(ETH_P_PPP_SES)) {
+		skb_push(skb, PPPOE_SES_HLEN);
+		skb->network_header -= PPPOE_SES_HLEN;
 	}
 
 	NF_HOOK(PF_BRIDGE, NF_BR_FORWARD, skb, realindev, skb->dev,
@@ -771,7 +828,8 @@ static unsigned int br_nf_post_routing(unsigned int hook, struct sk_buff **pskb,
 	if (!realoutdev)
 		return NF_DROP;
 
-	if (skb->protocol == htons(ETH_P_IP) || IS_VLAN_IP(skb))
+	if (skb->protocol == htons(ETH_P_IP) || IS_VLAN_IP(skb) ||
+	    IS_PPPOE_IP(skb))
 		pf = PF_INET;
 	else
 		pf = PF_INET6;
@@ -793,6 +851,9 @@ static unsigned int br_nf_post_routing(unsigned int hook, struct sk_buff **pskb,
 	if (skb->protocol == htons(ETH_P_8021Q)) {
 		skb_pull(skb, VLAN_HLEN);
 		skb->network_header += VLAN_HLEN;
+	} else if (skb->protocol == htons(ETH_P_PPP_SES)) {
+		skb_pull(skb, PPPOE_SES_HLEN);
+		skb->network_header += PPPOE_SES_HLEN;
 	}
 
 	nf_bridge_save_header(skb);
@@ -930,6 +991,14 @@ static ctl_table brnf_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &brnf_sysctl_call_tables,
 	},
+	{
+		.ctl_name	= NET_BRIDGE_NF_FILTER_PPPOE_TAGGED,
+		.procname	= "bridge-nf-filter-pppoe-tagged",
+		.data		= &brnf_filter_pppoe_tagged,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &brnf_sysctl_call_tables,
+	},
 	{ .ctl_name = 0 }
 };
 
