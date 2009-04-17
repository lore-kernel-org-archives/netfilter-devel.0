From: Saikiran Madugula <hummerbliss@gmail.com>
Subject: [PATCH] Allow fragmentation of VLAN packets traversing a bridge.
Date: Fri, 17 Apr 2009 16:19:41 +0100
Message-ID: <49E89E0D.5080000@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Saikiran Madugula <hummerbliss@gmail.com>,
	netfilter-devel@vger.kernel.org
To: netdev <netdev@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:48508 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758630AbZDQPTp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Apr 2009 11:19:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

br_nf_dev_queue_xmit only checks for ETH_P_IP packets for fragmenting but not
VLAN packets. This results in dropping of large VLAN packets. This can be
observed when connection tracking is enabled. Connection tracking re-assembles
fragmented packets, and these have to be re-fragmented when transmitting out.

Signed-off-by: Saikiran Madugula <hummerbliss@gmail.com>
---
 net/bridge/br_netfilter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 3953ac4..941f702 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -790,7 +790,7 @@ static unsigned int br_nf_local_out(unsigned int hook, struct sk_buff *skb,
 
 static int br_nf_dev_queue_xmit(struct sk_buff *skb)
 {
-	if (skb->protocol == htons(ETH_P_IP) &&
+	if ((skb->protocol == htons(ETH_P_IP) || IS_VLAN_IP(skb)) &&
 	    skb->len > skb->dev->mtu &&
 	    !skb_is_gso(skb))
 		return ip_fragment(skb, br_dev_queue_push_xmit);
-- 
1.5.6.3
