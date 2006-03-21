From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/09]: Fix Kconfig typos
Date: Tue, 21 Mar 2006 02:55:50 +0100 (MET)
Message-ID: <20060321015550.11977.43553.sendpatchset@localhost.localdomain>
References: <20060321015549.11977.45799.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060321015549.11977.45799.sendpatchset@localhost.localdomain>
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
commit a1cc87e7efc5abc436e3f2a04931dd40ecdba6d1
tree b2dc3a5e231e09e1b91e049d5056595bbaa9e985
parent b3fad09edaeb07049850ac33d2f51c5bc53e76e1
author Thomas Voegtle <tv@lio96.de> Mon, 20 Mar 2006 14:06:14 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 20 Mar 2006 14:06:14 +0100

 net/netfilter/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 1e6e311..a7355c5 100644
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
