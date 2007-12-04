From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 33/49]: ip6_queue: resync dev-index based flushing
Date: Tue,  4 Dec 2007 13:02:42 +0100 (MET)
Message-ID: <20071204120242.2442.11572.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62203 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbXLDMCn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:43 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: ip6_queue: resync dev-index based flushing

Resync dev_cmp to take bridge devices into account.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit e7a1b1cd873707620365c477874645736b9388a6
tree 96864ae1684322b3ca8fd762562695ec593dc852
parent 326b67e50d8f9f6a0adc52a0999e5e307724a855
author Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:47:48 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 11:32:55 +0100

 net/ipv6/netfilter/ip6_queue.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/net/ipv6/netfilter/ip6_queue.c b/net/ipv6/netfilter/ip6_queue.c
index 7d0780d..9c50cb1 100644
--- a/net/ipv6/netfilter/ip6_queue.c
+++ b/net/ipv6/netfilter/ip6_queue.c
@@ -418,7 +418,16 @@ dev_cmp(struct ipq_queue_entry *entry, unsigned long ifindex)
 	if (entry->info->outdev)
 		if (entry->info->outdev->ifindex == ifindex)
 			return 1;
-
+#ifdef CONFIG_BRIDGE_NETFILTER
+	if (entry->skb->nf_bridge) {
+		if (entry->skb->nf_bridge->physindev &&
+		    entry->skb->nf_bridge->physindev->ifindex == ifindex)
+			return 1;
+		if (entry->skb->nf_bridge->physoutdev &&
+		    entry->skb->nf_bridge->physoutdev->ifindex == ifindex)
+			return 1;
+	}
+#endif
 	return 0;
 }
 
