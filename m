From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [PATCH nf 2/2 v2] bridge: set the pktinfo for IPv4/IPv6 traffic
Date: Mon, 24 Nov 2014 20:15:50 +0100
Message-ID: <1416856550-15589-2-git-send-email-alvaroneay@gmail.com>
References: <1416856550-15589-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:51804 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333AbaKXTP2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2014 14:15:28 -0500
Received: by mail-wg0-f48.google.com with SMTP id y19so13171417wgg.7
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Nov 2014 11:15:27 -0800 (PST)
Received: from localhost.localdomain (129.166.216.87.static.jazztel.es. [87.216.166.129])
        by mx.google.com with ESMTPSA id hs1sm13292526wib.1.2014.11.24.11.15.26
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Nov 2014 11:15:26 -0800 (PST)
In-Reply-To: <1416856550-15589-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch sets the pktinfo for IPv4/IPv6 traffic. Therefore, we can check the
meta l4proto for IPv4/IPv6 traffic in bridge, before we don't have enough
information to do it. Example:

  nft add rule bridge filter input ether type {ip, ip6} meta l4proto udp counter
and
  nft add rule bridge filter input ether type {ip, ip6} meta l4proto tcp counter

With this patch, we can filter the traffic using the transport context that we
want.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[changes in v2]
 * Refactor the code to make it more clear
 * Make sure that IPv6 is enabled

 net/bridge/netfilter/nf_tables_bridge.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/nf_tables_bridge.c b/net/bridge/netfilter/nf_tables_bridge.c
index d468c19..f4471d7 100644
--- a/net/bridge/netfilter/nf_tables_bridge.c
+++ b/net/bridge/netfilter/nf_tables_bridge.c
@@ -16,6 +16,8 @@
 #include <net/netfilter/nf_tables_bridge.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
+#include <net/netfilter/nf_tables_ipv4.h>
+#include <net/netfilter/nf_tables_ipv6.h>
 
 int nft_bridge_iphdr_validate(struct sk_buff *skb)
 {
@@ -71,7 +73,24 @@ nft_do_chain_bridge(const struct nf_hook_ops *ops,
 {
 	struct nft_pktinfo pkt;
 
-	nft_set_pktinfo(&pkt, ops, skb, in, out);
+	switch (eth_hdr(skb)->h_proto) {
+	case htons(ETH_P_IP):
+		if (!nft_bridge_iphdr_validate(skb))
+			nft_set_pktinfo(&pkt, ops, skb, in, out);
+		else
+			nft_set_pktinfo_ipv4(&pkt, ops, skb, in, out);
+		break;
+	case htons(ETH_P_IPV6):
+		#if IS_ENABLED(CONFIG_IPV6)
+			if (!nft_bridge_ip6hdr_validate(skb) ||
+			    nft_set_pktinfo_ipv6(&pkt, ops, skb, in, out) < 0)
+				nft_set_pktinfo(&pkt, ops, skb, in, out);
+			break;
+		#endif
+	default:
+		nft_set_pktinfo(&pkt, ops, skb, in, out);
+		break;
+	}
 
 	return nft_do_chain(&pkt, ops);
 }
-- 
1.7.10.4

