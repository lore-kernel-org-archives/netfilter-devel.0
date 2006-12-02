From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 06/20]: Kconfig: improve conntrack selection
Date: Sat,  2 Dec 2006 15:49:45 +0100 (MET)
Message-ID: <20061202145250.1381.45252.sendpatchset@localhost.localdomain>
References: <20061202145241.1381.88698.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061202145241.1381.88698.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Kconfig: improve conntrack selection

Improve the connection tracking selection (well, the user experience,
not really the aesthetics) by offering one option to enable connection
tracking and a choice between the implementations.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 03143a9731c29b2c5bd72881d76471d9d68922d0
tree e21b3fa96fd59e2688c323bc42861a1883ec40d5
parent fff1e474556ff5fcae813c7b73a0a95c2b7143fc
author Patrick McHardy <kaber@trash.net> Sat, 02 Dec 2006 15:33:58 +0100
committer Patrick McHardy <kaber@trash.net> Sat, 02 Dec 2006 15:33:58 +0100

 net/ipv4/netfilter/Kconfig |   14 ------------
 net/netfilter/Kconfig      |   50 +++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 44 insertions(+), 20 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 06fec80..7148527 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -31,20 +31,6 @@ config NF_CONNTRACK_PROC_COMPAT
 	  If unsure, say Y.
 
 # connection tracking, helpers and protocols
-config IP_NF_CONNTRACK
-	tristate "Connection tracking (required for masq/NAT)"
-	---help---
-	  Connection tracking keeps a record of what packets have passed
-	  through your machine, in order to figure out how they are related
-	  into connections.
-
-	  This is required to do Masquerading or other kinds of Network
-	  Address Translation (except for Fast NAT).  It can also be used to
-	  enhance packet filtering (see `Connection state match support'
-	  below).
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 config IP_NF_CT_ACCT
 	bool "Connection tracking flow accounting"
 	depends on IP_NF_CONNTRACK
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index d191dac..efe56f7 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -25,19 +25,57 @@ config NETFILTER_NETLINK_LOG
 	  and is also scheduled to replace the old syslog-based ipt_LOG
 	  and ip6t_LOG modules.
 
-config NF_CONNTRACK
-	tristate "Layer 3 Independent Connection tracking (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && IP_NF_CONNTRACK=n
-	default n
-	---help---
+config NF_CONNTRACK_ENABLED
+	tristate "Netfilter connection tracking support"
+	help
 	  Connection tracking keeps a record of what packets have passed
 	  through your machine, in order to figure out how they are related
 	  into connections.
 
+	  This is required to do Masquerading or other kinds of Network
+	  Address Translation (except for Fast NAT).  It can also be used to
+	  enhance packet filtering (see `Connection state match support'
+	  below).
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
+choice
+	prompt "Netfilter connection tracking support"
+	depends on NF_CONNTRACK_ENABLED
+
+config NF_CONNTRACK_SUPPORT
+	bool "Layer 3 Independent Connection tracking (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	help
 	  Layer 3 independent connection tracking is experimental scheme
 	  which generalize ip_conntrack to support other layer 3 protocols.
 
-	  To compile it as a module, choose M here.  If unsure, say N.
+	  This is required to do Masquerading or other kinds of Network
+	  Address Translation (except for Fast NAT).  It can also be used to
+	  enhance packet filtering (see `Connection state match support'
+	  below).
+
+config IP_NF_CONNTRACK_SUPPORT
+	bool "Layer 3 Dependent Connection tracking"
+	help
+	  The old, Layer 3 dependent ip_conntrack subsystem of netfilter.
+
+	  This is required to do Masquerading or other kinds of Network
+	  Address Translation (except for Fast NAT).  It can also be used to
+	  enhance packet filtering (see `Connection state match support'
+	  below).
+
+endchoice
+
+config NF_CONNTRACK
+	tristate
+	default m if NF_CONNTRACK_SUPPORT && NF_CONNTRACK_ENABLED=m
+	default y if NF_CONNTRACK_SUPPORT && NF_CONNTRACK_ENABLED=y
+
+config IP_NF_CONNTRACK
+	tristate
+	default m if IP_NF_CONNTRACK_SUPPORT && NF_CONNTRACK_ENABLED=m
+	default y if IP_NF_CONNTRACK_SUPPORT && NF_CONNTRACK_ENABLED=y
 
 config NF_CT_ACCT
 	bool "Connection tracking flow accounting"
