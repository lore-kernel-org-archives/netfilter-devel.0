From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/69]: bridge netfilter: remove nf_bridge_info read-only netoutdev member
Date: Wed, 30 Jan 2008 21:16:59 +0100 (MET)
Message-ID: <20080130201657.29874.49831.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60646 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765006AbYA3URB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:17:01 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: bridge netfilter: remove nf_bridge_info read-only netoutdev member

Before the removal of the deferred output hooks, netoutdev was used in case
of VLANs on top of a bridge to store the VLAN device, so the deferred hooks
would see the correct output device. This isn't necessary anymore since we're
calling the output hooks for the correct device directly in the IP stack.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 55a3ad929c35527e0ac6ccdb5535779ed1523be5
tree 3db79be7f7c220b1bbfbac83b4040e67ad65c127
parent 4639b794086800b0bef00c06c880a47be1517853
author Patrick McHardy <kaber@trash.net> Tue, 29 Jan 2008 16:21:51 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 15:04:12 +0100

 include/linux/skbuff.h    |    3 ---
 net/bridge/br_netfilter.c |    4 ----
 2 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index c618fbf..dfe975a 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -108,9 +108,6 @@ struct nf_bridge_info {
 	atomic_t use;
 	struct net_device *physindev;
 	struct net_device *physoutdev;
-#if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
-	struct net_device *netoutdev;
-#endif
 	unsigned int mask;
 	unsigned long data[32 / sizeof(unsigned long)];
 };
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 80014ba..1c0efd8 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -828,10 +828,6 @@ static unsigned int br_nf_post_routing(unsigned int hook, struct sk_buff *skb,
 	nf_bridge_pull_encap_header(skb);
 	nf_bridge_save_header(skb);
 
-#if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
-	if (nf_bridge->netoutdev)
-		realoutdev = nf_bridge->netoutdev;
-#endif
 	NF_HOOK(pf, NF_INET_POST_ROUTING, skb, NULL, realoutdev,
 		br_nf_dev_queue_xmit);
 
