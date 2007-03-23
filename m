From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/12]: nfnetlink_log: don't count max(a,b) twice
Date: Fri, 23 Mar 2007 15:05:01 +0100 (MET)
Message-ID: <20070323140436.22987.20165.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nfnetlink_log: don't count max(a,b) twice

We don't need local nlbufsiz (skb size) as nfulnl_alloc_skb() takes
the maximum anyway.

Signed-off-by: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9bff4aef16228a63f2fd5515dcec087574019a75
tree 9c9b3d253ee3a49a401d24b3befe69ce941ab43c
parent 7d6eb2567f5694088bda13109f45b6b16ef1e21d
author Michal Miroslaw <mirq-linux@rere.qmqm.pl> Thu, 22 Mar 2007 23:01:00 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 23 Mar 2007 11:00:20 +0100

 net/netfilter/nfnetlink_log.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 8ae83cb..3b849a7 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -590,7 +590,6 @@ nfulnl_log_packet(unsigned int pf,
 	struct nfulnl_instance *inst;
 	const struct nf_loginfo *li;
 	unsigned int qthreshold;
-	unsigned int nlbufsiz;
 	unsigned int plen;
 
 	if (li_user && li_user->type == NF_LOG_TYPE_ULOG)
@@ -666,13 +665,8 @@ nfulnl_log_packet(unsigned int pf,
 		return;
 	}
 
-	if (size > inst->nlbufsiz)
-		nlbufsiz = size;
-	else
-		nlbufsiz = inst->nlbufsiz;
-
 	if (!inst->skb) {
-		if (!(inst->skb = nfulnl_alloc_skb(nlbufsiz, size))) {
+		if (!(inst->skb = nfulnl_alloc_skb(inst->nlbufsiz, size))) {
 			UDEBUG("error in nfulnl_alloc_skb(%u, %u)\n",
 				inst->nlbufsiz, size);
 			goto alloc_failure;
@@ -688,7 +682,7 @@ nfulnl_log_packet(unsigned int pf,
 			instance_put(inst);
 		__nfulnl_send(inst);
 
-		if (!(inst->skb = nfulnl_alloc_skb(nlbufsiz, size))) {
+		if (!(inst->skb = nfulnl_alloc_skb(inst->nlbufsiz, size))) {
 			UDEBUG("error in nfulnl_alloc_skb(%u, %u)\n",
 				inst->nlbufsiz, size);
 			goto alloc_failure;
