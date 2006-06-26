From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/06]: ip_queue/nfnetlink_queue: drop bridge port
	references when dev disappears
Date: Mon, 26 Jun 2006 17:43:13 +0200 (MEST)
Message-ID: <20060626154313.11682.382.sendpatchset@localhost.localdomain>
References: <20060626154307.11682.28562.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060626154307.11682.28562.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: ip_queue/nfnetlink_queue: drop bridge port references when dev disappears

When a device that is acting as a bridge port is unregistered, the
ip_queue/nfnetlink_queue notifier doesn't check if its one of
physindev/physoutdev and doesn't release the references if it is.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5e9d63f46ae2805245fcc9ec58f844d1347bd469
tree 96f0d37e0f70100ba2b31b7eaa5453125a4d6ac4
parent 9565b859bc682e4c208f73e83adb21a7f86d0143
author Patrick McHardy <kaber@trash.net> Mon, 26 Jun 2006 17:15:02 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 26 Jun 2006 17:15:02 +0200

 net/ipv4/netfilter/ip_queue.c   |   12 ++++++++++--
 net/netfilter/nfnetlink_queue.c |   12 ++++++++++--
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/ip_queue.c b/net/ipv4/netfilter/ip_queue.c
index b93f049..213d116 100644
--- a/net/ipv4/netfilter/ip_queue.c
+++ b/net/ipv4/netfilter/ip_queue.c
@@ -457,11 +457,19 @@ dev_cmp(struct ipq_queue_entry *entry, u
 	if (entry->info->indev)
 		if (entry->info->indev->ifindex == ifindex)
 			return 1;
-			
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
+		    	return 1;
+	}
+#endif
 	return 0;
 }
 
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 86a4ac3..49ef41e 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -680,11 +680,19 @@ dev_cmp(struct nfqnl_queue_entry *entry,
 	if (entinf->indev)
 		if (entinf->indev->ifindex == ifindex)
 			return 1;
-			
 	if (entinf->outdev)
 		if (entinf->outdev->ifindex == ifindex)
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
 
