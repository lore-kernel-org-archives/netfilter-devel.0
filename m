From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/13]: nfnetlink_log: fix use after free
Date: Wed,  7 Mar 2007 22:34:33 +0100 (MET)
Message-ID: <20070307213354.22306.58320.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nfnetlink_log: fix use after free

Paranoia: instance_put() might have freed the inst pointer when we
spin_unlock_bh().

Signed-off-by: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 35acdc83b42fa79c56d7c4367b59115554324d12
tree b32a649446ddc1dac278ccfbc86ae721d330b60b
parent 1a069cf250b123f7e407a0b59ff4803762d02a98
author Michal Miroslaw <mirq-linux@rere.qmqm.pl> Tue, 06 Mar 2007 08:24:20 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 06 Mar 2007 08:24:20 +0100

 net/netfilter/nfnetlink_log.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 8f85dc4..987f37b 100644
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
