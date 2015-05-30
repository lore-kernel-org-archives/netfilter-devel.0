From: Bernhard Thaler <bernhard.thaler@wvnet.at>
Subject: [PATCH 1/3] netfilter: bridge: refactor clearing BRNF_NF_BRIDGE_PREROUTING
Date: Sat, 30 May 2015 15:26:13 +0200
Message-ID: <1432992373-3954-1-git-send-email-bernhard.thaler@wvnet.at>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
	Bernhard Thaler <bernhard.thaler@wvnet.at>
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx-out.wvnet.at ([62.212.170.132]:22283 "EHLO mx-out.wvnet.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932316AbbE3N0x (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 May 2015 09:26:53 -0400
Received: from smtp.wvnet.at (localhost [127.0.0.1])
	by mx-out.wvnet.at (Postfix) with ESMTP id C98B81107D89
	for <netfilter-devel@vger.kernel.org>; Sat, 30 May 2015 15:26:50 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

use binary AND on complement of BRNF_NF_BRIDGE_PREROUTING to unset
bit in nf_bridge->mask.

Signed-off-by: Bernhard Thaler <bernhard.thaler@wvnet.at>
---
 net/bridge/br_netfilter.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 46660a2..2651876 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -290,7 +290,7 @@ static int br_nf_pre_routing_finish_ipv6(struct sock *sk, struct sk_buff *skb)
 		skb->pkt_type = PACKET_OTHERHOST;
 		nf_bridge->pkt_otherhost = false;
 	}
-	nf_bridge->mask ^= BRNF_NF_BRIDGE_PREROUTING;
+	nf_bridge->mask &= ~BRNF_NF_BRIDGE_PREROUTING;
 
 	rt = bridge_parent_rtable(nf_bridge->physindev);
 	if (!rt) {
@@ -415,7 +415,7 @@ static int br_nf_pre_routing_finish(struct sock *sk, struct sk_buff *skb)
 		skb->pkt_type = PACKET_OTHERHOST;
 		nf_bridge->pkt_otherhost = false;
 	}
-	nf_bridge->mask ^= BRNF_NF_BRIDGE_PREROUTING;
+	nf_bridge->mask &= ~BRNF_NF_BRIDGE_PREROUTING;
 	if (daddr_was_changed(skb, nf_bridge)) {
 		if ((err = ip_route_input(skb, iph->daddr, iph->saddr, iph->tos, dev))) {
 			struct in_device *in_dev = __in_dev_get_rcu(dev);
-- 
1.7.10.4

