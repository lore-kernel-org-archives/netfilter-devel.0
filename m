From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH] use NF_BR_PRI_BRNF in NF_HOOK_THRESH
Date: Wed, 19 Nov 2014 11:07:33 +0800
Message-ID: <1416366453-12090-2-git-send-email-gaofeng@cn.fujitsu.com>
References: <1416366453-12090-1-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <pablo@netfilter.org>, Gao feng <gaofeng@cn.fujitsu.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60692 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753741AbaKSDHj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Nov 2014 22:07:39 -0500
In-Reply-To: <1416366453-12090-1-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

packets jump to ip/ipv6/arp netfilter from bridge
netfilter hooks whose priority are NF_BR_PRI_BRNF,
so when packets return to bridge netfilter, the
thresh is NF_BR_PRI_BRNF + 1.

this patch use marco NF_BR_PRI_BRNF + 1 to replace
the number 1.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 net/bridge/br_netfilter.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index eb00150..6c90696 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -242,7 +242,7 @@ static int br_nf_pre_routing_finish_ipv6(struct sk_buff *skb)
 	nf_bridge_update_protocol(skb);
 	nf_bridge_push_encap_header(skb);
 	NF_HOOK_THRESH(NFPROTO_BRIDGE, NF_BR_PRE_ROUTING, skb, skb->dev, NULL,
-		       br_handle_frame_finish, 1);
+		       br_handle_frame_finish, NF_BR_PRI_BRNF + 1);
 out:
 	return 0;
 drop:
@@ -399,7 +399,7 @@ bridged_dnat:
 					       NF_BR_PRE_ROUTING,
 					       skb, skb->dev, NULL,
 					       br_nf_pre_routing_finish_bridge,
-					       1);
+					       NF_BR_PRI_BRNF + 1);
 				return 0;
 			}
 			ether_addr_copy(eth_hdr(skb)->h_dest, dev->dev_addr);
@@ -418,7 +418,7 @@ bridged_dnat:
 	nf_bridge_update_protocol(skb);
 	nf_bridge_push_encap_header(skb);
 	NF_HOOK_THRESH(NFPROTO_BRIDGE, NF_BR_PRE_ROUTING, skb, skb->dev, NULL,
-		       br_handle_frame_finish, 1);
+		       br_handle_frame_finish, NF_BR_PRI_BRNF + 1);
 
 	return 0;
 }
@@ -659,7 +659,7 @@ static int br_nf_forward_finish(struct sk_buff *skb)
 	nf_bridge_push_encap_header(skb);
 
 	NF_HOOK_THRESH(NFPROTO_BRIDGE, NF_BR_FORWARD, skb, in,
-		       skb->dev, br_forward_finish, 1);
+		       skb->dev, br_forward_finish, NF_BR_PRI_BRNF + 1);
 	return 0;
 }
 
-- 
1.9.3

