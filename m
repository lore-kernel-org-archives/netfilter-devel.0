From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 09/10]: nfnetlink_log: fix reference counting
Date: Sun,  4 Mar 2007 21:20:10 +0100 (MET)
Message-ID: <20070304201918.28582.61146.sendpatchset@localhost.localdomain>
References: <20070304201906.28582.51903.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070304201906.28582.51903.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nfnetlink_log: fix reference counting

Fix reference counting (memory leak) problem in __nfulnl_send() and callers
related to packet queueing.

Signed-off-by: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 346efa9c7dd81bff762a436d0259424e7c74fa69
tree 70f56ee7946691f7326b9e8bb2d8bbb502c757e2
parent 3aed666579e96dfe23eb1988faf4af09c33358bc
author Michal Miroslaw <mirq-linux@rere.qmqm.pl> Fri, 02 Mar 2007 13:24:08 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 02 Mar 2007 13:24:08 +0100

 net/netfilter/nfnetlink_log.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index d0af8bc..91a0972 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -218,6 +218,9 @@ _instance_destroy2(struct nfulnl_instanc
 
 	spin_lock_bh(&inst->lock);
 	if (inst->skb) {
+		/* timer "holds" one reference (we have one more) */
+		if (del_timer(&inst->timer))
+			instance_put(inst);
 		if (inst->qlen)
 			__nfulnl_send(inst);
 		if (inst->skb) {
@@ -362,9 +365,6 @@ __nfulnl_send(struct nfulnl_instance *in
 {
 	int status;
 
-	if (timer_pending(&inst->timer))
-		del_timer(&inst->timer);
-
 	if (!inst->skb)
 		return 0;
 
@@ -689,6 +689,9 @@ #endif
 		 * enough room in the skb left. flush to userspace. */
 		UDEBUG("flushing old skb\n");
 
+		/* timer "holds" one reference (we have another one) */
+		if (del_timer(&inst->timer))
+			instance_put(inst);
 		__nfulnl_send(inst);
 
 		if (!(inst->skb = nfulnl_alloc_skb(nlbufsiz, size))) {
