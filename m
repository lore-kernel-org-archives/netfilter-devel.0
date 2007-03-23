From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 07/12]: nfnetlink_log: micro-optimization: inst->skb !=
	NULL in __nfulnl_send()
Date: Fri, 23 Mar 2007 15:05:08 +0100 (MET)
Message-ID: <20070323140442.22987.85376.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nfnetlink_log: micro-optimization: inst->skb != NULL in __nfulnl_send()

No other function calls __nfulnl_send() with inst->skb == NULL than
nfulnl_timer().

Signed-off-by: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d5e28a22dfd6b5a6b2d80565cb0347b093a1a85b
tree 2b6d8bddacbbc95a379d3a7b9e9db7e8a7b73166
parent 711273c65e2da4bd148f9c72d30970859d4255ad
author Michal Miroslaw <mirq-linux@rere.qmqm.pl> Thu, 22 Mar 2007 23:02:40 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 23 Mar 2007 11:00:22 +0100

 net/netfilter/nfnetlink_log.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index e934770..34de3d8 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -360,9 +360,6 @@ __nfulnl_send(struct nfulnl_instance *inst)
 {
 	int status;
 
-	if (!inst->skb)
-		return 0;
-
 	if (inst->qlen > 1)
 		inst->lastnlh->nlmsg_type = NLMSG_DONE;
 
@@ -386,7 +383,8 @@ static void nfulnl_timer(unsigned long data)
 	UDEBUG("timer function called, flushing buffer\n");
 
 	spin_lock_bh(&inst->lock);
-	__nfulnl_send(inst);
+	if (inst->skb)
+		__nfulnl_send(inst);
 	spin_unlock_bh(&inst->lock);
 	instance_put(inst);
 }
