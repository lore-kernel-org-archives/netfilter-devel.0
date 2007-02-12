From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 19/22]: Kconfig: improve dependency handling
Date: Mon, 12 Feb 2007 11:36:47 +0100 (MET)
Message-ID: <20070212103647.661.73276.sendpatchset@localhost.localdomain>
References: <20070212103621.661.65165.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070212103621.661.65165.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Kconfig: improve dependency handling

Instead of depending on internally needed options and letting users
figure out what is needed, select them when needed:

- IP_NF_IPTABLES, IP_NF_ARPTABLES and IP6_NF_IPTABLES select
  NETFILTER_XTABLES

- NETFILTER_XT_TARGET_CONNMARK, NETFILTER_XT_MATCH_CONNMARK and
  IP_NF_TARGET_CLUSTERIP select NF_CONNTRACK_MARK

- NETFILTER_XT_MATCH_CONNBYTES selects NF_CT_ACCT

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a3987b41ed8c0275393942316c502e4cffbc0126
tree e5f23f16e4bdd9b454356a75269f8a3fb161082a
parent 0a03715d7befc80612212ee80723dcce8b75f3c1
author Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 11:08:00 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 11:08:00 +0100

 net/ipv4/netfilter/Kconfig |    8 +++++---
 net/ipv6/netfilter/Kconfig |    3 ++-
 net/netfilter/Kconfig      |   12 +++++++++---
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 9b08e7a..601808c 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -226,7 +226,7 @@ config IP_NF_QUEUE
 
 config IP_NF_IPTABLES
 	tristate "IP tables support (required for filtering/masq/NAT)"
-	depends on NETFILTER_XTABLES
+	select NETFILTER_XTABLES
 	help
 	  iptables is a general, extensible packet identification framework.
 	  The packet filtering and full NAT (masquerading, port forwarding,
@@ -606,7 +606,9 @@ config IP_NF_TARGET_TTL
 config IP_NF_TARGET_CLUSTERIP
 	tristate "CLUSTERIP target support (EXPERIMENTAL)"
 	depends on IP_NF_MANGLE && EXPERIMENTAL
-	depends on (IP_NF_CONNTRACK && IP_NF_CONNTRACK_MARK) || (NF_CONNTRACK_MARK && NF_CONNTRACK_IPV4)
+	depends on IP_NF_CONNTRACK || NF_CONNTRACK_IPV4
+	select IP_NF_CONNTRACK_MARK if IP_NF_CONNTRACK
+	select NF_CONNTRACK_MARK if NF_CONNTRACK_IPV4
 	help
 	  The CLUSTERIP target allows you to build load-balancing clusters of
 	  network servers without having a dedicated load-balancing
@@ -629,7 +631,7 @@ config IP_NF_RAW
 # ARP tables
 config IP_NF_ARPTABLES
 	tristate "ARP tables support"
-	depends on NETFILTER_XTABLES
+	select NETFILTER_XTABLES
 	help
 	  arptables is a general, extensible packet identification framework.
 	  The ARP packet filtering and mangling (manipulation)subsystems
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index cd549ae..da07e9a 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -42,7 +42,8 @@ config IP6_NF_QUEUE
 
 config IP6_NF_IPTABLES
 	tristate "IP6 tables support (required for filtering)"
-	depends on INET && IPV6 && EXPERIMENTAL && NETFILTER_XTABLES
+	depends on INET && IPV6 && EXPERIMENTAL
+	select NETFILTER_XTABLES
 	help
 	  ip6tables is a general, extensible packet identification framework.
 	  Currently only the packet filtering and packet mangling subsystem
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 748f7f0..253fce3 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -302,7 +302,9 @@ config NETFILTER_XT_TARGET_CONNMARK
 	tristate  '"CONNMARK" target support'
 	depends on NETFILTER_XTABLES
 	depends on IP_NF_MANGLE || IP6_NF_MANGLE
-	depends on (IP_NF_CONNTRACK && IP_NF_CONNTRACK_MARK) || (NF_CONNTRACK_MARK && NF_CONNTRACK)
+	depends on IP_NF_CONNTRACK || NF_CONNTRACK
+	select IP_NF_CONNTRACK_MARK if IP_NF_CONNTRACK
+	select NF_CONNTRACK_MARK if NF_CONNTRACK
 	help
 	  This option adds a `CONNMARK' target, which allows one to manipulate
 	  the connection mark value.  Similar to the MARK target, but
@@ -434,7 +436,9 @@ config NETFILTER_XT_MATCH_COMMENT
 config NETFILTER_XT_MATCH_CONNBYTES
 	tristate  '"connbytes" per-connection counter match support'
 	depends on NETFILTER_XTABLES
-	depends on (IP_NF_CONNTRACK && IP_NF_CT_ACCT) || (NF_CT_ACCT && NF_CONNTRACK)
+	depends on IP_NF_CONNTRACK || NF_CONNTRACK
+	select IP_NF_CT_ACCT if IP_NF_CONNTRACK
+	select NF_CT_ACCT if NF_CONNTRACK
 	help
 	  This option adds a `connbytes' match, which allows you to match the
 	  number of bytes and/or packets for each direction within a connection.
@@ -445,7 +449,9 @@ config NETFILTER_XT_MATCH_CONNBYTES
 config NETFILTER_XT_MATCH_CONNMARK
 	tristate  '"connmark" connection mark match support'
 	depends on NETFILTER_XTABLES
-	depends on (IP_NF_CONNTRACK && IP_NF_CONNTRACK_MARK) || (NF_CONNTRACK_MARK && NF_CONNTRACK)
+	depends on IP_NF_CONNTRACK || NF_CONNTRACK
+	select IP_NF_CONNTRACK_MARK if IP_NF_CONNTRACK
+	select NF_CONNTRACK_MARK if NF_CONNTRACK
 	help
 	  This option adds a `connmark' match, which allows you to match the
 	  connection mark value previously set for the session by `CONNMARK'. 
