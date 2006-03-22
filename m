From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/10]: Fix Kconfig typos
Date: Wed, 22 Mar 2006 19:47:44 +0100 (MET)
Message-ID: <20060322184744.5655.30609.sendpatchset@localhost.localdomain>
References: <20060322184740.5655.7960.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060322184740.5655.7960.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Fix Kconfig typos

Signed-off-by: Thomas Vögtle <tv@lio96.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f50d6f98c2dbfa3472c1650dee11758b60b651ce
tree 0525f86907261389b7f57058dfa92c2209df031b
parent 28b7fea5433d3b5ddcba2948b17e6a0aa9fa0af6
author Thomas Voegtle <tv@lio96.de> Tue, 21 Mar 2006 22:30:18 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 21 Mar 2006 22:30:18 +0100

 net/netfilter/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 1740278..332acb3 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -11,7 +11,7 @@ config NETFILTER_NETLINK_QUEUE
 	tristate "Netfilter NFQUEUE over NFNETLINK interface"
 	depends on NETFILTER_NETLINK
 	help
-	  If this option isenabled, the kernel will include support
+	  If this option is enabled, the kernel will include support
 	  for queueing packets via NFNETLINK.
 	  
 config NETFILTER_NETLINK_LOG
@@ -66,7 +66,7 @@ config NF_CONNTRACK_EVENTS
 	help
 	  If this option is enabled, the connection tracking code will
 	  provide a notifier chain that can be used by other kernel code
-	  to get notified aboutchanges in the connection tracking state.
+	  to get notified about changes in the connection tracking state.
 
 	  If unsure, say `N'.
 
@@ -153,7 +153,7 @@ config NETFILTER_XT_TARGET_NFQUEUE
 	tristate '"NFQUEUE" target Support'
 	depends on NETFILTER_XTABLES
 	help
-	  This Target replaced the old obsolete QUEUE target.
+	  This target replaced the old obsolete QUEUE target.
 
 	  As opposed to QUEUE, it supports 65535 different queues,
 	  not just one.
