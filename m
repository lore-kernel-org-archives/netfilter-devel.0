Return-Path: <SRS0=iy/8=SN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EB2FC282CE
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Apr 2019 14:39:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A00E206BA
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Apr 2019 14:39:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbfDKOjq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Apr 2019 10:39:46 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:36470 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726391AbfDKOjp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Apr 2019 10:39:45 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hEarf-0001tE-Hh; Thu, 11 Apr 2019 16:39:43 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        <netdev@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/4] bridge: reduce size of input cb to 16 bytes
Date:   Thu, 11 Apr 2019 16:36:40 +0200
Message-Id: <20190411143642.1087-3-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190411143642.1087-1-fw@strlen.de>
References: <20190411143642.1087-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

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

Cc: Roopa Prabhu <roopa@cumulusnetworks.com>
Cc: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
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
2.21.0

