From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] net/ipv6/netfilter/Kconfig cleanups
Date: Sun, 13 Nov 2005 17:20:02 +0900 (JST)
Message-ID: <200511130820.jAD8K3o3019750@toshiba.co.jp>
References: <Pine.LNX.4.64.0511120207340.26844@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Sun_Nov_13_17_20_02_2005_234)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: olenf@ans.pl, laforge@netfilter.org
In-Reply-To: <Pine.LNX.4.64.0511120207340.26844@bizon.gios.gov.pl>
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

----Next_Part(Sun_Nov_13_17_20_02_2005_234)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi,

From: Krzysztof Oledzki <olenf@ans.pl>
Date: Sat, 12 Nov 2005 02:13:40 +0100 (CET)

> Hello,
> 
> Attached (and inlined) patch moves NF_CONNTRACK_IPV6 so both "IPv6: 
> Netfilter Configuration" and "IP: Netfilter Configuration" look similar.
> It also removes unneeded CONFIG_IP6_NF_CONNTRACK.

Thanks. But this patch generates Hunks, too. I rewrote it and it also remove
all other linux 2.4 style configurations in comments.

Harald, please apply this.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

Regards,

----Next_Part(Sun_Nov_13_17_20_02_2005_234)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="01-ipv6-kconfig-cleanup.patch"

[NETFILTER] cleanup IPv6 Netfilter Kconfig

This removes linux 2.4 configs in comments as TODO lists.
And this also move the entry of nf_conntrack to top like IPv4 Netfilter
Kconfig.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 3dee1e7deee4fb4fa655d48befe4a8068174aa79
tree 47e1c2e1b5aa628040933df190611a74363d81db
parent 55f077463dbf36962b7773726098b2b45cc89709
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sun, 13 Nov 2005 03:25:18 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sun, 13 Nov 2005 03:25:18 +0900

 net/ipv6/netfilter/Kconfig |   50 ++++++++++++--------------------------------
 1 files changed, 14 insertions(+), 36 deletions(-)

diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 971ba60..060d612 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -5,10 +5,20 @@
 menu "IPv6: Netfilter Configuration (EXPERIMENTAL)"
 	depends on INET && IPV6 && NETFILTER && EXPERIMENTAL
 
-#tristate 'Connection tracking (required for masq/NAT)' CONFIG_IP6_NF_CONNTRACK
-#if [ "$CONFIG_IP6_NF_CONNTRACK" != "n" ]; then
-#  dep_tristate '  FTP protocol support' CONFIG_IP6_NF_FTP $CONFIG_IP6_NF_CONNTRACK
-#fi
+config NF_CONNTRACK_IPV6
+	tristate "IPv6 support for new connection tracking (EXPERIMENTAL)"
+	depends on EXPERIMENTAL && NF_CONNTRACK
+	---help---
+	  Connection tracking keeps a record of what packets have passed
+	  through your machine, in order to figure out how they are related
+	  into connections.
+
+	  This is IPv6 support on Layer 3 independent connection tracking.
+	  Layer 3 independent connection tracking is experimental scheme
+	  which generalize ip_conntrack to support other layer 3 protocols.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config IP6_NF_QUEUE
 	tristate "IP6 Userspace queueing via NETLINK (OBSOLETE)"
 	---help---
@@ -114,7 +124,6 @@ config IP6_NF_MATCH_OWNER
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-#  dep_tristate '  MAC address match support' CONFIG_IP6_NF_MATCH_MAC $CONFIG_IP6_NF_IPTABLES
 config IP6_NF_MATCH_MARK
 	tristate "netfilter MARK match support"
 	depends on IP6_NF_IPTABLES
@@ -170,15 +179,6 @@ config IP6_NF_MATCH_PHYSDEV
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-#  dep_tristate '  Multiple port match support' CONFIG_IP6_NF_MATCH_MULTIPORT $CONFIG_IP6_NF_IPTABLES
-#  dep_tristate '  TOS match support' CONFIG_IP6_NF_MATCH_TOS $CONFIG_IP6_NF_IPTABLES
-#  if [ "$CONFIG_IP6_NF_CONNTRACK" != "n" ]; then
-#    dep_tristate '  Connection state match support' CONFIG_IP6_NF_MATCH_STATE $CONFIG_IP6_NF_CONNTRACK $CONFIG_IP6_NF_IPTABLES 
-#  fi
-#  if [ "$CONFIG_EXPERIMENTAL" = "y" ]; then
-#    dep_tristate '  Unclean match support (EXPERIMENTAL)' CONFIG_IP6_NF_MATCH_UNCLEAN $CONFIG_IP6_NF_IPTABLES
-#    dep_tristate '  Owner match support (EXPERIMENTAL)' CONFIG_IP6_NF_MATCH_OWNER $CONFIG_IP6_NF_IPTABLES
-#  fi
 # The targets
 config IP6_NF_FILTER
 	tristate "Packet filtering"
@@ -220,12 +220,6 @@ config IP6_NF_TARGET_NFQUEUE
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-#  if [ "$CONFIG_IP6_NF_FILTER" != "n" ]; then
-#    dep_tristate '    REJECT target support' CONFIG_IP6_NF_TARGET_REJECT $CONFIG_IP6_NF_FILTER
-#    if [ "$CONFIG_EXPERIMENTAL" = "y" ]; then
-#      dep_tristate '    MIRROR target support (EXPERIMENTAL)' CONFIG_IP6_NF_TARGET_MIRROR $CONFIG_IP6_NF_FILTER
-#    fi
-#  fi
 config IP6_NF_MANGLE
 	tristate "Packet mangling"
 	depends on IP6_NF_IPTABLES
@@ -236,7 +230,6 @@ config IP6_NF_MANGLE
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-#    dep_tristate '    TOS target support' CONFIG_IP6_NF_TARGET_TOS $CONFIG_IP_NF_MANGLE
 config IP6_NF_TARGET_MARK
 	tristate "MARK target support"
 	depends on IP6_NF_MANGLE
@@ -266,7 +259,6 @@ config IP6_NF_TARGET_HL
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-#dep_tristate '  LOG target support' CONFIG_IP6_NF_TARGET_LOG $CONFIG_IP6_NF_IPTABLES
 config IP6_NF_RAW
 	tristate  'raw table support (required for TRACE)'
 	depends on IP6_NF_IPTABLES
@@ -278,19 +270,5 @@ config IP6_NF_RAW
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/modules.txt>.  If unsure, say `N'.
 
-config NF_CONNTRACK_IPV6
-	tristate "IPv6 support for new connection tracking (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && NF_CONNTRACK
-	---help---
-	  Connection tracking keeps a record of what packets have passed
-	  through your machine, in order to figure out how they are related
-	  into connections.
-
-	  This is IPv6 support on Layer 3 independent connection tracking.
-	  Layer 3 independent connection tracking is experimental scheme
-	  which generalize ip_conntrack to support other layer 3 protocols.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 endmenu
 

----Next_Part(Sun_Nov_13_17_20_02_2005_234)----
