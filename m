From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 6/9]: Mark ctnetlink as EXPERIMENTAL
Date: Sun, 04 Dec 2005 22:01:23 +0100
Message-ID: <20051204210123.24032.2569.sendpatchset@localhost.localdomain>
References: <20051204210116.24032.9802.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David S. Miller <davem@davemloft.net>
In-Reply-To: <20051204210116.24032.9802.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Mark ctnetlink as EXPERIMENTAL

Should have been marked EXPERIMENTAL from the beginning, as the current
bunch of fixes show.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit aea6c7fa24378c7f38026177c0b524719789b4be
tree e656f511d3fbfaf666828a8fc6803d7579db6dc9
parent 0fa82f8caa129bb2377e1b593bf2986fc13c5391
author Patrick McHardy <kaber@trash.net> Sun, 04 Dec 2005 17:11:34 +0100
committer Patrick McHardy <kaber@trash.net> Sun, 04 Dec 2005 17:11:34 +0100

 net/ipv4/netfilter/Kconfig |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 0bc0052..88a6065 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -56,8 +56,8 @@ config IP_NF_CONNTRACK_MARK
 	  instead of the individual packets.
 	
 config IP_NF_CONNTRACK_EVENTS
-	bool "Connection tracking events"
-	depends on IP_NF_CONNTRACK
+	bool "Connection tracking events (EXPERIMENTAL)"
+	depends on EXPERIMENTAL && IP_NF_CONNTRACK
 	help
 	  If this option is enabled, the connection tracking code will
 	  provide a notifier chain that can be used by other kernel code
@@ -66,8 +66,8 @@ config IP_NF_CONNTRACK_EVENTS
 	  IF unsure, say `N'.
 
 config IP_NF_CONNTRACK_NETLINK
-	tristate 'Connection tracking netlink interface'
-	depends on IP_NF_CONNTRACK && NETFILTER_NETLINK
+	tristate 'Connection tracking netlink interface (EXPERIMENTAL)'
+	depends on EXPERIMENTAL && IP_NF_CONNTRACK && NETFILTER_NETLINK
 	depends on IP_NF_CONNTRACK!=y || NETFILTER_NETLINK!=m
 	help
 	  This option enables support for a netlink-based userspace interface
