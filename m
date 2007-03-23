From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/12]: nfnetlink_log: micro-optimization: don't modify
	destroyed instance
Date: Fri, 23 Mar 2007 15:05:05 +0100 (MET)
Message-ID: <20070323140440.22987.16363.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nfnetlink_log: micro-optimization: don't modify destroyed instance

Simple micro-optimization: Don't change any options if the instance is
being destroyed.

Signed-off-by: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 76fd1fbb4efe0c85596590b0a56ffaf4fc467c61
tree c09b5c3dc82ea09e5960cfc95d562722b7d6ddce
parent 7e6bd92e1cdbb5bd83285d2a2f7dc151c853511d
author Michal Miroslaw <mirq-linux@rere.qmqm.pl> Thu, 22 Mar 2007 23:01:59 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 23 Mar 2007 11:00:21 +0100

 net/netfilter/nfnetlink_log.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index d4b45e2..441f0fb 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -825,7 +825,7 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 			}
 
 			instance_destroy(inst);
-			break;
+			goto out;
 		case NFULNL_CFG_CMD_PF_BIND:
 			UDEBUG("registering log handler for pf=%u\n", pf);
 			ret = nf_log_register(pf, &nfulnl_logger);
