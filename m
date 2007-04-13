From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/06]: nfnetlink_log: remove fallback to group 0
Date: Fri, 13 Apr 2007 05:00:14 +0200 (MEST)
Message-ID: <20070413025930.29875.34422.sendpatchset@localhost.localdomain>
References: <20070413025923.29875.68909.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070413025923.29875.68909.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nfnetlink_log: remove fallback to group 0

Don't fallback to group 0 if no instance can be found for the given group.
This potentially confuses the listener and is not what the user configured.
Also remove the ring buffer spamming that happens when rules are set up
before the logging daemon is started.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 3f1fbdbe77db881eb7bbcf30d806fae6109cda52
tree 2aa2f32e0dc7cf256f7d17b2a81e798ede5b8bc8
parent 474508878b875d838ec122f84193e48ea492f560
author Patrick McHardy <kaber@trash.net> Fri, 13 Apr 2007 04:43:31 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 13 Apr 2007 04:43:31 +0200

 net/netfilter/nfnetlink_log.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index d2c6aab..e32e30e 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -584,12 +584,7 @@ nfulnl_log_packet(unsigned int pf,
 
 	inst = instance_lookup_get(li->u.ulog.group);
 	if (!inst)
-		inst = instance_lookup_get(0);
-	if (!inst) {
-		PRINTR("nfnetlink_log: trying to log packet, "
-			"but no instance for group %u\n", li->u.ulog.group);
 		return;
-	}
 
 	plen = 0;
 	if (prefix)
