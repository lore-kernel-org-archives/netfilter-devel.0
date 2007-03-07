From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/13]: nfnetlink_log: fix reference leak
Date: Wed,  7 Mar 2007 22:34:32 +0100 (MET)
Message-ID: <20070307213352.22306.5081.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nfnetlink_log: fix reference leak

Stop reference leaking in nfulnl_log_packet(). If we start a timer we
are already taking another reference.

Signed-off-by: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 1a069cf250b123f7e407a0b59ff4803762d02a98
tree f9f71c51b1b9277c2d522f22ea14c6dbc2907d2b
parent 026cf98c00d9fd7a1cf241a29d466f04c84c4df1
author Michal Miroslaw <mirq-linux@rere.qmqm.pl> Tue, 06 Mar 2007 08:23:47 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 06 Mar 2007 08:23:47 +0100

 net/netfilter/nfnetlink_log.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index d1505dd..8f85dc4 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -711,15 +711,16 @@ #endif
 		inst->timer.expires = jiffies + (inst->flushtimeout*HZ/100);
 		add_timer(&inst->timer);
 	}
-	spin_unlock_bh(&inst->lock);
 
+unlock_and_release:
+	spin_unlock_bh(&inst->lock);
+	instance_put(inst);
 	return;
 
 alloc_failure:
-	spin_unlock_bh(&inst->lock);
-	instance_put(inst);
 	UDEBUG("error allocating skb\n");
 	/* FIXME: statistics */
+	goto unlock_and_release;
 }
 
 static int
