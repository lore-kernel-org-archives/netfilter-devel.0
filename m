From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCH] remove old cruft from ipv6 Kconfig
Date: 26 May 2003 16:56:28 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1053960987.749.2.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Harald,

Can you please forward this patch to davem?

--- linux-2.5.69-mm9/net/ipv6/netfilter/Kconfig.orig	2003-05-26 16:48:52.000000000 +0200
+++ linux-2.5.69-mm9/net/ipv6/netfilter/Kconfig	2003-05-26 16:52:28.000000000 +0200
@@ -5,10 +5,6 @@
 menu "IPv6: Netfilter Configuration"
 	depends on INET && EXPERIMENTAL && IPV6!=n && NETFILTER
 
-#tristate 'Connection tracking (required for masq/NAT)' CONFIG_IP6_NF_CONNTRACK
-#if [ "$CONFIG_IP6_NF_CONNTRACK" != "n" ]; then
-#  dep_tristate '  FTP protocol support' CONFIG_IP6_NF_FTP $CONFIG_IP6_NF_CONNTRACK
-#fi
 config IP6_NF_QUEUE
 	tristate "Userspace queueing via NETLINK (EXPERIMENTAL)"
 	---help---
@@ -121,7 +117,6 @@
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/modules.txt>.  If unsure, say `N'.
 
-#  dep_tristate '  MAC address match support' CONFIG_IP6_NF_MATCH_MAC $CONFIG_IP6_NF_IPTABLES
 config IP6_NF_MATCH_MARK
 	tristate "netfilter MARK match support"
 	depends on IP6_NF_IPTABLES
@@ -173,15 +168,6 @@
 	  If you want to compile it as a module, say M here and read
 	  Documentation/modules.txt.  If unsure, say `N'.
 
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
@@ -204,12 +190,6 @@
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/modules.txt>.  If unsure, say `N'.
 
-#  if [ "$CONFIG_IP6_NF_FILTER" != "n" ]; then
-#    dep_tristate '    REJECT target support' CONFIG_IP6_NF_TARGET_REJECT $CONFIG_IP6_NF_FILTER
-#    if [ "$CONFIG_EXPERIMENTAL" = "y" ]; then
-#      dep_tristate '    MIRROR target support (EXPERIMENTAL)' CONFIG_IP6_NF_TARGET_MIRROR $CONFIG_IP6_NF_FILTER
-#    fi
-#  fi
 config IP6_NF_MANGLE
 	tristate "Packet mangling"
 	depends on IP6_NF_IPTABLES
@@ -221,7 +201,6 @@
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/modules.txt>.  If unsure, say `N'.
 
-#    dep_tristate '    TOS target support' CONFIG_IP6_NF_TARGET_TOS $CONFIG_IP_NF_MANGLE
 config IP6_NF_TARGET_MARK
 	tristate "MARK target support"
 	depends on IP6_NF_MANGLE
@@ -236,6 +215,5 @@
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/modules.txt>.  If unsure, say `N'.
 
-#dep_tristate '  LOG target support' CONFIG_IP6_NF_TARGET_LOG $CONFIG_IP6_NF_IPTABLES
 endmenu
 


-- 
/Martin
