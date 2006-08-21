From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 08/18]: nfnetlink_queue: fix typo in error message
Date: Tue, 22 Aug 2006 00:52:28 +0200 (MEST)
Message-ID: <20060821225228.10288.68921.sendpatchset@localhost.localdomain>
References: <20060821225217.10288.69738.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060821225217.10288.69738.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nfnetlink_queue: fix typo in error message

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 94964e26cff67825112477f3c8bae88539245d72
tree f011d732bad268a2060caa362348665f690f5e66
parent b27f40cbcae710e0b68589c9943499d8487a1590
author Patrick McHardy <kaber@trash.net> Fri, 11 Aug 2006 21:01:34 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 11 Aug 2006 21:01:34 +0200

 net/netfilter/nfnetlink_queue.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index eddfbe4..8eb2473 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -584,7 +584,7 @@ nfqnl_enqueue_packet(struct sk_buff *skb
                 queue->queue_dropped++;
 		status = -ENOSPC;
 		if (net_ratelimit())
-		          printk(KERN_WARNING "ip_queue: full at %d entries, "
+		          printk(KERN_WARNING "nf_queue: full at %d entries, "
 				 "dropping packets(s). Dropped: %d\n", 
 				 queue->queue_total, queue->queue_dropped);
 		goto err_out_free_nskb;
@@ -635,7 +635,7 @@ nfqnl_mangle(void *data, int data_len, s
 			                         diff,
 			                         GFP_ATOMIC);
 			if (newskb == NULL) {
-				printk(KERN_WARNING "ip_queue: OOM "
+				printk(KERN_WARNING "nf_queue: OOM "
 				      "in mangle, dropping packet\n");
 				return -ENOMEM;
 			}
