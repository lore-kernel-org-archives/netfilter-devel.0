From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/12]: nfnetlink_log: micro-optimization for inst==NULL
	in nfulnl_recv_config()
Date: Fri, 23 Mar 2007 15:05:04 +0100 (MET)
Message-ID: <20070323140438.22987.68301.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nfnetlink_log: micro-optimization for inst==NULL in nfulnl_recv_config()

Simple micro-optimization: don't call instance_put() on known NULL pointers.

Signed-off-by: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7e6bd92e1cdbb5bd83285d2a2f7dc151c853511d
tree 829f4920a6df42202656aeaa7d9871fbf0ce8a48
parent 797c0ab0be222b58be043f42eee79f2503b4ab08
author Michal Miroslaw <mirq-linux@rere.qmqm.pl> Thu, 22 Mar 2007 23:01:33 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 23 Mar 2007 11:00:21 +0100

 net/netfilter/nfnetlink_log.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index d14cf51..d4b45e2 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -810,13 +810,13 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 					       NETLINK_CB(skb).pid);
 			if (!inst) {
 				ret = -EINVAL;
-				goto out_put;
+				goto out;
 			}
 			break;
 		case NFULNL_CFG_CMD_UNBIND:
 			if (!inst) {
 				ret = -ENODEV;
-				goto out_put;
+				goto out;
 			}
 
 			if (inst->peer_pid != NETLINK_CB(skb).pid) {
@@ -849,7 +849,7 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 				"group=%u pid=%u =>ENOENT\n",
 				group_num, NETLINK_CB(skb).pid);
 			ret = -ENOENT;
-			goto out_put;
+			goto out;
 		}
 
 		if (inst->peer_pid != NETLINK_CB(skb).pid) {
