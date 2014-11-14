From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [PATCH nf 1/2] bridge: export nft_reject_ip*hdr_validate functions
Date: Fri, 14 Nov 2014 11:29:49 +0100
Message-ID: <1415960990-19489-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:64645 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018AbaKNK32 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Nov 2014 05:29:28 -0500
Received: by mail-wg0-f45.google.com with SMTP id x12so19039925wgg.32
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Nov 2014 02:29:26 -0800 (PST)
Received: from localhost.localdomain (129.166.216.87.static.jazztel.es. [87.216.166.129])
        by mx.google.com with ESMTPSA id 10sm39068009wjs.21.2014.11.14.02.29.25
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Nov 2014 02:29:25 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch exports the functions nft_reject_iphdr_validate and
nft_reject_ip6hdr_validate to use it in follow up patches.
These functions check if the ethernet header is correct.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 include/net/netfilter/nf_tables_bridge.h |    7 ++++
 net/bridge/netfilter/nf_tables_bridge.c  |   48 +++++++++++++++++++++++++++
 net/bridge/netfilter/nft_reject_bridge.c |   52 +++---------------------------
 3 files changed, 60 insertions(+), 47 deletions(-)
 create mode 100644 include/net/netfilter/nf_tables_bridge.h

diff --git a/include/net/netfilter/nf_tables_bridge.h b/include/net/netfilter/nf_tables_bridge.h
new file mode 100644
index 0000000..511fb79
--- /dev/null
+++ b/include/net/netfilter/nf_tables_bridge.h
@@ -0,0 +1,7 @@
+#ifndef _NET_NF_TABLES_BRIDGE_H
+#define _NET_NF_TABLES_BRIDGE_H
+
+int nft_bridge_iphdr_validate(struct sk_buff *skb);
+int nft_bridge_ip6hdr_validate(struct sk_buff *skb);
+
+#endif /* _NET_NF_TABLES_BRIDGE_H */
diff --git a/net/bridge/netfilter/nf_tables_bridge.c b/net/bridge/netfilter/nf_tables_bridge.c
index 074c557..d468c19 100644
--- a/net/bridge/netfilter/nf_tables_bridge.c
+++ b/net/bridge/netfilter/nf_tables_bridge.c
@@ -13,6 +13,54 @@
 #include <linux/module.h>
 #include <linux/netfilter_bridge.h>
 #include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_bridge.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+
+int nft_bridge_iphdr_validate(struct sk_buff *skb)
+{
+	struct iphdr *iph;
+	u32 len;
+
+	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
+		return 0;
+
+	iph = ip_hdr(skb);
+	if (iph->ihl < 5 || iph->version != 4)
+		return 0;
+
+	len = ntohs(iph->tot_len);
+	if (skb->len < len)
+		return 0;
+	else if (len < (iph->ihl*4))
+		return 0;
+
+	if (!pskb_may_pull(skb, iph->ihl*4))
+		return 0;
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(nft_bridge_iphdr_validate);
+
+int nft_bridge_ip6hdr_validate(struct sk_buff *skb)
+{
+	struct ipv6hdr *hdr;
+	u32 pkt_len;
+
+	if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
+		return 0;
+
+	hdr = ipv6_hdr(skb);
+	if (hdr->version != 6)
+		return 0;
+
+	pkt_len = ntohs(hdr->payload_len);
+	if (pkt_len + sizeof(struct ipv6hdr) > skb->len)
+		return 0;
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(nft_bridge_ip6hdr_validate);
 
 static unsigned int
 nft_do_chain_bridge(const struct nf_hook_ops *ops,
diff --git a/net/bridge/netfilter/nft_reject_bridge.c b/net/bridge/netfilter/nft_reject_bridge.c
index 654c901..1285f25 100644
--- a/net/bridge/netfilter/nft_reject_bridge.c
+++ b/net/bridge/netfilter/nft_reject_bridge.c
@@ -14,6 +14,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nft_reject.h>
+#include <net/netfilter/nf_tables_bridge.h>
 #include <net/netfilter/ipv4/nf_reject.h>
 #include <net/netfilter/ipv6/nf_reject.h>
 #include <linux/ip.h>
@@ -34,30 +35,6 @@ static void nft_reject_br_push_etherhdr(struct sk_buff *oldskb,
 	skb_pull(nskb, ETH_HLEN);
 }
 
-static int nft_reject_iphdr_validate(struct sk_buff *oldskb)
-{
-	struct iphdr *iph;
-	u32 len;
-
-	if (!pskb_may_pull(oldskb, sizeof(struct iphdr)))
-		return 0;
-
-	iph = ip_hdr(oldskb);
-	if (iph->ihl < 5 || iph->version != 4)
-		return 0;
-
-	len = ntohs(iph->tot_len);
-	if (oldskb->len < len)
-		return 0;
-	else if (len < (iph->ihl*4))
-		return 0;
-
-	if (!pskb_may_pull(oldskb, iph->ihl*4))
-		return 0;
-
-	return 1;
-}
-
 static void nft_reject_br_send_v4_tcp_reset(struct sk_buff *oldskb, int hook)
 {
 	struct sk_buff *nskb;
@@ -65,7 +42,7 @@ static void nft_reject_br_send_v4_tcp_reset(struct sk_buff *oldskb, int hook)
 	const struct tcphdr *oth;
 	struct tcphdr _oth;
 
-	if (!nft_reject_iphdr_validate(oldskb))
+	if (!nft_bridge_iphdr_validate(oldskb))
 		return;
 
 	oth = nf_reject_ip_tcphdr_get(oldskb, &_oth, hook);
@@ -100,7 +77,7 @@ static void nft_reject_br_send_v4_unreach(struct sk_buff *oldskb, int hook,
 	void *payload;
 	__wsum csum;
 
-	if (!nft_reject_iphdr_validate(oldskb))
+	if (!nft_bridge_iphdr_validate(oldskb))
 		return;
 
 	/* IP header checks: fragment. */
@@ -145,25 +122,6 @@ static void nft_reject_br_send_v4_unreach(struct sk_buff *oldskb, int hook,
 	br_deliver(br_port_get_rcu(oldskb->dev), nskb);
 }
 
-static int nft_reject_ip6hdr_validate(struct sk_buff *oldskb)
-{
-	struct ipv6hdr *hdr;
-	u32 pkt_len;
-
-	if (!pskb_may_pull(oldskb, sizeof(struct ipv6hdr)))
-		return 0;
-
-	hdr = ipv6_hdr(oldskb);
-	if (hdr->version != 6)
-		return 0;
-
-	pkt_len = ntohs(hdr->payload_len);
-	if (pkt_len + sizeof(struct ipv6hdr) > oldskb->len)
-		return 0;
-
-	return 1;
-}
-
 static void nft_reject_br_send_v6_tcp_reset(struct net *net,
 					    struct sk_buff *oldskb, int hook)
 {
@@ -173,7 +131,7 @@ static void nft_reject_br_send_v6_tcp_reset(struct net *net,
 	unsigned int otcplen;
 	struct ipv6hdr *nip6h;
 
-	if (!nft_reject_ip6hdr_validate(oldskb))
+	if (!nft_bridge_ip6hdr_validate(oldskb))
 		return;
 
 	oth = nf_reject_ip6_tcphdr_get(oldskb, &_oth, &otcplen, hook);
@@ -206,7 +164,7 @@ static void nft_reject_br_send_v6_unreach(struct net *net,
 	unsigned int len;
 	void *payload;
 
-	if (!nft_reject_ip6hdr_validate(oldskb))
+	if (!nft_bridge_ip6hdr_validate(oldskb))
 		return;
 
 	/* Include "As much of invoking packet as possible without the ICMPv6
-- 
1.7.10.4

