From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/12]: nfnetlink_log: kill duplicate code
Date: Fri, 23 Mar 2007 15:05:03 +0100 (MET)
Message-ID: <20070323140437.22987.44821.sendpatchset@localhost.localdomain>
References: <20070323140433.22987.44867.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070323140433.22987.44867.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nfnetlink_log: kill duplicate code

Kill some duplicate code in nfulnl_log_packet().

Signed-off-by: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 797c0ab0be222b58be043f42eee79f2503b4ab08
tree 4877b09381dd4c284fa8d31be665b268be67463d
parent 9bff4aef16228a63f2fd5515dcec087574019a75
author Michal Miroslaw <mirq-linux@rere.qmqm.pl> Thu, 22 Mar 2007 23:01:22 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 23 Mar 2007 11:00:21 +0100

 net/netfilter/nfnetlink_log.c |   22 +++++++---------------
 1 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 3b849a7..d14cf51 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -660,19 +660,11 @@ nfulnl_log_packet(unsigned int pf,
 		break;
 
 	default:
-		spin_unlock_bh(&inst->lock);
-		instance_put(inst);
-		return;
+		goto unlock_and_release;
 	}
 
-	if (!inst->skb) {
-		if (!(inst->skb = nfulnl_alloc_skb(inst->nlbufsiz, size))) {
-			UDEBUG("error in nfulnl_alloc_skb(%u, %u)\n",
-				inst->nlbufsiz, size);
-			goto alloc_failure;
-		}
-	} else if (inst->qlen >= qthreshold ||
-		   size > skb_tailroom(inst->skb)) {
+	if (inst->qlen >= qthreshold ||
+	    (inst->skb && size > skb_tailroom(inst->skb))) {
 		/* either the queue len is too high or we don't have
 		 * enough room in the skb left. flush to userspace. */
 		UDEBUG("flushing old skb\n");
@@ -681,12 +673,12 @@ nfulnl_log_packet(unsigned int pf,
 		if (del_timer(&inst->timer))
 			instance_put(inst);
 		__nfulnl_send(inst);
+	}
 
-		if (!(inst->skb = nfulnl_alloc_skb(inst->nlbufsiz, size))) {
-			UDEBUG("error in nfulnl_alloc_skb(%u, %u)\n",
-				inst->nlbufsiz, size);
+	if (!inst->skb) {
+		inst->skb = nfulnl_alloc_skb(inst->nlbufsiz, size);
+		if (!inst->skb)
 			goto alloc_failure;
-		}
 	}
 
 	UDEBUG("qlen %d, qthreshold %d\n", inst->qlen, qthreshold);
