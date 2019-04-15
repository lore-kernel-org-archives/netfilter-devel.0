Return-Path: <SRS0=sICu=SR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31D23C10F0E
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:00:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CA242075B
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:00:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbfDORAs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 13:00:48 -0400
Received: from mail.us.es ([193.147.175.20]:50474 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727901AbfDORAr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 13:00:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A27121C4441
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 89726DA711
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:46 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 88700DA710; Mon, 15 Apr 2019 19:00:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 650DEDA706;
        Mon, 15 Apr 2019 19:00:44 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 15 Apr 2019 19:00:44 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 388BF4265A31;
        Mon, 15 Apr 2019 19:00:44 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 19/22] bridge: reduce size of input cb to 16 bytes
Date:   Mon, 15 Apr 2019 19:00:25 +0200
Message-Id: <20190415170028.3470-20-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190415170028.3470-1-pablo@netfilter.org>
References: <20190415170028.3470-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Reduce size of br_input_skb_cb from 24 to 16 bytes by
using bitfield for those values that can only be 0 or 1.

igmp is the igmp type value, so it needs to be at least u8.

Furthermore, the bridge currently relies on step-by-step initialization
of br_input_skb_cb fields as the skb passes through the stack.

Explicitly zero out the bridge input cb instead, this avoids having to
review/validate that no BR_INPUT_SKB_CB(skb)->foo test can see a
'random' value from previous protocol cb.

AFAICS all current fields are always set up before they are read again,
so this is not a bug fix.

Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/br_arp_nd_proxy.c | 18 +++++++++---------
 net/bridge/br_input.c        |  2 ++
 net/bridge/br_private.h      | 12 +++++-------
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/net/bridge/br_arp_nd_proxy.c b/net/bridge/br_arp_nd_proxy.c
index 724b474ade54..15116752365a 100644
--- a/net/bridge/br_arp_nd_proxy.c
+++ b/net/bridge/br_arp_nd_proxy.c
@@ -131,7 +131,7 @@ void br_do_proxy_suppress_arp(struct sk_buff *skb, struct net_bridge *br,
 	u8 *arpptr, *sha;
 	__be32 sip, tip;
 
-	BR_INPUT_SKB_CB(skb)->proxyarp_replied = false;
+	BR_INPUT_SKB_CB(skb)->proxyarp_replied = 0;
 
 	if ((dev->flags & IFF_NOARP) ||
 	    !pskb_may_pull(skb, arp_hdr_len(dev)))
@@ -161,7 +161,7 @@ void br_do_proxy_suppress_arp(struct sk_buff *skb, struct net_bridge *br,
 			return;
 		if (ipv4_is_zeronet(sip) || sip == tip) {
 			/* prevent flooding to neigh suppress ports */
-			BR_INPUT_SKB_CB(skb)->proxyarp_replied = true;
+			BR_INPUT_SKB_CB(skb)->proxyarp_replied = 1;
 			return;
 		}
 	}
@@ -181,7 +181,7 @@ void br_do_proxy_suppress_arp(struct sk_buff *skb, struct net_bridge *br,
 		/* its our local ip, so don't proxy reply
 		 * and don't forward to neigh suppress ports
 		 */
-		BR_INPUT_SKB_CB(skb)->proxyarp_replied = true;
+		BR_INPUT_SKB_CB(skb)->proxyarp_replied = 1;
 		return;
 	}
 
@@ -217,7 +217,7 @@ void br_do_proxy_suppress_arp(struct sk_buff *skb, struct net_bridge *br,
 			 */
 			if (replied ||
 			    br_opt_get(br, BROPT_NEIGH_SUPPRESS_ENABLED))
-				BR_INPUT_SKB_CB(skb)->proxyarp_replied = true;
+				BR_INPUT_SKB_CB(skb)->proxyarp_replied = 1;
 		}
 
 		neigh_release(n);
@@ -393,7 +393,7 @@ void br_do_suppress_nd(struct sk_buff *skb, struct net_bridge *br,
 	struct ipv6hdr *iphdr;
 	struct neighbour *n;
 
-	BR_INPUT_SKB_CB(skb)->proxyarp_replied = false;
+	BR_INPUT_SKB_CB(skb)->proxyarp_replied = 0;
 
 	if (p && (p->flags & BR_NEIGH_SUPPRESS))
 		return;
@@ -401,7 +401,7 @@ void br_do_suppress_nd(struct sk_buff *skb, struct net_bridge *br,
 	if (msg->icmph.icmp6_type == NDISC_NEIGHBOUR_ADVERTISEMENT &&
 	    !msg->icmph.icmp6_solicited) {
 		/* prevent flooding to neigh suppress ports */
-		BR_INPUT_SKB_CB(skb)->proxyarp_replied = true;
+		BR_INPUT_SKB_CB(skb)->proxyarp_replied = 1;
 		return;
 	}
 
@@ -414,7 +414,7 @@ void br_do_suppress_nd(struct sk_buff *skb, struct net_bridge *br,
 
 	if (ipv6_addr_any(saddr) || !ipv6_addr_cmp(saddr, daddr)) {
 		/* prevent flooding to neigh suppress ports */
-		BR_INPUT_SKB_CB(skb)->proxyarp_replied = true;
+		BR_INPUT_SKB_CB(skb)->proxyarp_replied = 1;
 		return;
 	}
 
@@ -432,7 +432,7 @@ void br_do_suppress_nd(struct sk_buff *skb, struct net_bridge *br,
 		/* its our own ip, so don't proxy reply
 		 * and don't forward to arp suppress ports
 		 */
-		BR_INPUT_SKB_CB(skb)->proxyarp_replied = true;
+		BR_INPUT_SKB_CB(skb)->proxyarp_replied = 1;
 		return;
 	}
 
@@ -465,7 +465,7 @@ void br_do_suppress_nd(struct sk_buff *skb, struct net_bridge *br,
 			 */
 			if (replied ||
 			    br_opt_get(br, BROPT_NEIGH_SUPPRESS_ENABLED))
-				BR_INPUT_SKB_CB(skb)->proxyarp_replied = true;
+				BR_INPUT_SKB_CB(skb)->proxyarp_replied = 1;
 		}
 		neigh_release(n);
 	}
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 5ea7e56119c1..e2f93e5c72da 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -227,6 +227,8 @@ rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
 	if (!skb)
 		return RX_HANDLER_CONSUMED;
 
+	memset(skb->cb, 0, sizeof(struct br_input_skb_cb));
+
 	p = br_port_get_rcu(skb->dev);
 	if (p->flags & BR_VLAN_TUNNEL) {
 		if (br_handle_ingress_vlan_tunnel(skb, p,
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 7946aa3b6e09..e7110a6e2b7e 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -425,15 +425,13 @@ struct br_input_skb_cb {
 	struct net_device *brdev;
 
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
-	int igmp;
-	int mrouters_only;
+	u8 igmp;
+	u8 mrouters_only:1;
 #endif
-
-	bool proxyarp_replied;
-	bool src_port_isolated;
-
+	u8 proxyarp_replied:1;
+	u8 src_port_isolated:1;
 #ifdef CONFIG_BRIDGE_VLAN_FILTERING
-	bool vlan_filtered;
+	u8 vlan_filtered:1;
 #endif
 
 #ifdef CONFIG_NET_SWITCHDEV
-- 
2.11.0

