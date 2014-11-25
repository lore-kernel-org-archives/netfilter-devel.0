From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [PATCH nf 2/2 v3] bridge: set the pktinfo for IPv4/IPv6 traffic
Date: Tue, 25 Nov 2014 14:15:32 +0100
Message-ID: <1416921332-23658-2-git-send-email-alvaroneay@gmail.com>
References: <1416921332-23658-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:63727 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaKYNPg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:15:36 -0500
Received: by mail-wi0-f182.google.com with SMTP id h11so1388103wiw.9
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Nov 2014 05:15:35 -0800 (PST)
Received: from localhost.localdomain (129.166.216.87.static.jazztel.es. [87.216.166.129])
        by mx.google.com with ESMTPSA id jp3sm16454224wid.9.2014.11.25.05.15.34
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Nov 2014 05:15:34 -0800 (PST)
In-Reply-To: <1416921332-23658-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the missing bits to allow to match per meta l4proto from
the bridge. Example:

  nft add rule bridge filter input ether type {ip, ip6} meta l4proto udp counter

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[changes in v3]
* Wrong identation using #if and #ifdef
* Enhanced the description of this patch

 net/bridge/netfilter/nf_tables_bridge.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/nf_tables_bridge.c b/net/bridge/netfilter/nf_tables_bridge.c
index d468c19..3887fe5 100644
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
+#if IS_ENABLED(CONFIG_IPV6)
+			if (!nft_bridge_ip6hdr_validate(skb) ||
+			    nft_set_pktinfo_ipv6(&pkt, ops, skb, in, out) < 0)
+				nft_set_pktinfo(&pkt, ops, skb, in, out);
+			break;
+#endif
+	default:
+		nft_set_pktinfo(&pkt, ops, skb, in, out);
+		break;
+	}
 
 	return nft_do_chain(&pkt, ops);
 }
-- 
1.7.10.4

