From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/10]: nfnetlink_log: fix use after free
Date: Sun,  4 Mar 2007 21:20:04 +0100 (MET)
Message-ID: <20070304201912.28582.29134.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nfnetlink_log: fix use after free

Paranoia: instance_put() might have freed the inst pointer when we
spin_unlock_bh().

Signed-off-by: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit aa1cfb5305723e815830307a398c17134a19d4d2
tree 63649ce0eb88954ba6f8a8cb0b06a2a1b265c9d3
parent d8b913269b678945a6af2e5432b6c2aa8a6ff3ef
author Michal Miroslaw <mirq-linux@rere.qmqm.pl> Thu, 01 Mar 2007 16:20:49 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 01 Mar 2007 16:20:49 +0100

 net/netfilter/nfnetlink_log.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 62c3f31..27b844a 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -393,8 +393,8 @@ static void nfulnl_timer(unsigned long d
 
 	spin_lock_bh(&inst->lock);
 	__nfulnl_send(inst);
-	instance_put(inst);
 	spin_unlock_bh(&inst->lock);
+	instance_put(inst);
 }
 
 /* This is an inline function, we don't really care about a long
