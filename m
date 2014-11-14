From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [PATCH nf 2/2] bridge: set the pktinfo for IPv4/IPv6 traffic
Date: Fri, 14 Nov 2014 11:29:50 +0100
Message-ID: <1415960990-19489-2-git-send-email-alvaroneay@gmail.com>
References: <1415960990-19489-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:36058 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019AbaKNK33 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Nov 2014 05:29:29 -0500
Received: by mail-wi0-f174.google.com with SMTP id h11so2241518wiw.1
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Nov 2014 02:29:27 -0800 (PST)
Received: from localhost.localdomain (129.166.216.87.static.jazztel.es. [87.216.166.129])
        by mx.google.com with ESMTPSA id 10sm39068009wjs.21.2014.11.14.02.29.26
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Nov 2014 02:29:27 -0800 (PST)
In-Reply-To: <1415960990-19489-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch sets the pktinfo for IPv4/IPv6 traffic. Therefore, we can check the
meta l4proto for IPv4/IPv6 traffic in bridge, before we don't have enough
information to do it.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 net/bridge/netfilter/nf_tables_bridge.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/nf_tables_bridge.c b/net/bridge/netfilter/nf_tables_bridge.c
index d468c19..0a0f0ca 100644
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
@@ -71,8 +73,21 @@ nft_do_chain_bridge(const struct nf_hook_ops *ops,
 {
 	struct nft_pktinfo pkt;
 
-	nft_set_pktinfo(&pkt, ops, skb, in, out);
+	switch (eth_hdr(skb)->h_proto) {
+	case htons(ETH_P_IP):
+		if (!nft_bridge_iphdr_validate(skb))
+			break;
+		nft_set_pktinfo_ipv4(&pkt, ops, skb, in, out);
+		return nft_do_chain(&pkt, ops);
+	case htons(ETH_P_IPV6):
+		if (!nft_bridge_ip6hdr_validate(skb))
+			break;
+		if (nft_set_pktinfo_ipv6(&pkt, ops, skb, in, out) < 0)
+			break;
+		return nft_do_chain(&pkt, ops);
+	}
 
+	nft_set_pktinfo(&pkt, ops, skb, in, out);
 	return nft_do_chain(&pkt, ops);
 }
 
-- 
1.7.10.4

