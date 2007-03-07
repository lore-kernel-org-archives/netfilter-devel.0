From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 07/13]: nfnetlink_log: fix possible NULL pointer
	dereference
Date: Wed,  7 Mar 2007 22:34:36 +0100 (MET)
Message-ID: <20070307213356.22306.90917.sendpatchset@localhost.localdomain>
References: <20070307213347.22306.9248.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	davem@davemloft.net
To: stable@kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070307213347.22306.9248.sendpatchset@localhost.localdomain>
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
commit 5e1bb4837b82a6d474ee123030d90de7d51fb2cc
tree e0f7ec93c1892cf8b1d118aa8128d31a220ef73f
parent 9c6dd76c66b13b49987974d48479e42241ae057a
author Michal Miroslaw <mirq-linux@rere.qmqm.pl> Tue, 06 Mar 2007 08:25:47 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 06 Mar 2007 08:25:47 +0100

 net/netfilter/nfnetlink_log.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index d9f0f0c..2e773c5 100644
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
 
