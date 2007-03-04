From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 07/10]: nfnetlink_log: fix possible NULL pointer
	dereference
Date: Sun,  4 Mar 2007 21:20:07 +0100 (MET)
Message-ID: <20070304201915.28582.66793.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nfnetlink_log: fix possible NULL pointer dereference

Eliminate possible NULL pointer dereference in nfulnl_recv_config().

Signed-off-by: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 79fb63ea8565212c9e8fde1e18a5598b438ced08
tree 5e0e1dd8d4b2bc6af902fbd508c05bde37df98a4
parent eff0bb8715bfc8b8c2cbd58504433d3fd48b36c8
author Michal Miroslaw <mirq-linux@rere.qmqm.pl> Fri, 02 Mar 2007 13:11:38 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 02 Mar 2007 13:11:38 +0100

 net/netfilter/nfnetlink_log.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 1b94051..b669db5 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -858,6 +858,9 @@ nfulnl_recv_config(struct sock *ctnl, st
 			ret = -EINVAL;
 			break;
 		}
+
+		if (!inst)
+			goto out;
 	} else {
 		if (!inst) {
 			UDEBUG("no config command, and no instance for "
@@ -911,6 +914,7 @@ nfulnl_recv_config(struct sock *ctnl, st
 
 out_put:
 	instance_put(inst);
+out:
 	return ret;
 }
 
