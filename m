From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 12/13]: nfnetlink_log: zero-terminate prefix
Date: Wed,  7 Mar 2007 22:34:43 +0100 (MET)
Message-ID: <20070307213404.22306.77575.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nfnetlink_log: zero-terminate prefix

Userspace expects a zero-terminated string, so include the trailing
zero in the netlink message.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 80124a592479a1730fde6fb370c80d705d889ce3
tree 9c4009aeedad6d290530ea544dd162848fce36e9
parent dde28ec33796ecfc28f2d49b870dffac050834a9
author Patrick McHardy <kaber@trash.net> Tue, 06 Mar 2007 08:31:57 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 06 Mar 2007 08:31:57 +0100

 net/netfilter/nfnetlink_log.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 5a522d9..5675d2d 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -615,7 +615,7 @@ nfulnl_log_packet(unsigned int pf,
 
 	plen = 0;
 	if (prefix)
-		plen = strlen(prefix);
+		plen = strlen(prefix) + 1;
 
 	/* all macros expand to constant values at compile time */
 	/* FIXME: do we want to make the size calculation conditional based on
