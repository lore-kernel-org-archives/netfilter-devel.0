From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/03]: nfnetlink_log: zero-terminate prefix
Date: Tue,  6 Mar 2007 08:44:04 +0100 (MET)
Message-ID: <20070306074403.24479.10486.sendpatchset@localhost.localdomain>
References: <20070306074400.24479.43171.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070306074400.24479.43171.sendpatchset@localhost.localdomain>
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
commit fdc819454fe27437cdaac5674a18373657650068
tree 577adbfcbd3741e1538d5f943a7c7ca23172cd01
parent 5bd8638bfa97ebf5ff7765ed06fccd594108e92f
author Patrick McHardy <kaber@trash.net> Tue, 06 Mar 2007 07:17:00 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 06 Mar 2007 07:17:00 +0100

 net/netfilter/nfnetlink_log.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 91a0972..12f92e2 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -615,7 +615,7 @@ nfulnl_log_packet(unsigned int pf,
 
 	plen = 0;
 	if (prefix)
-		plen = strlen(prefix);
+		plen = strlen(prefix) + 1;
 
 	/* all macros expand to constant values at compile time */
 	/* FIXME: do we want to make the size calculation conditional based on
