From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: latest nf_conntrack version
Date: Thu, 04 Aug 2005 06:14:45 +0900 (JST)
Message-ID: <200508032114.j73LEkHv028997@toshiba.co.jp>
References: <200508021633.j72GX9Ea016932@toshiba.co.jp>
	<42EFEA57.5010406@trash.net>
	<20050803142708.GA9456@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Thu_Aug__4_06_14_45_2005_682)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20050803142708.GA9456@rama.de.gnumonks.org>
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

----Next_Part(Thu_Aug__4_06_14_45_2005_682)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi, Harald,

From: Harald Welte <laforge@netfilter.org>
Date: Wed, 3 Aug 2005 16:27:08 +0200

> I've now also merged your nf_conntrack tree into my netfilter-2.6 tree
> as local "nf_conntrack" branch.
> 
> rsync://people.netfilter.org/users/laforge/scm/netfilter-2.6.14.git#nf_conntrack
> 
> should therefore be the full url to that branch.  I've done the nfcache
> removal and the nf_log_packet() api changes. it compiles and builds fine
> (no unresolved symbols), but I didn't have time to test it further.

The configuration menu for netlink and nf_conntrack in your branch are in
"Packet Generator" menu. And currently masq/NAT sentences should be removed,
I think.

I attached the patch for this. But if you have the better idea of
title/explanations, feel free to change them.

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Thu_Aug__4_06_14_45_2005_682)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="kconfig.patch"

diff --git a/net/Kconfig b/net/Kconfig
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -140,6 +140,7 @@ config BRIDGE_NETFILTER
 
 	  If unsure, say N.
 
+source "net/netfilter/Kconfig"
 source "net/ipv4/netfilter/Kconfig"
 source "net/ipv6/netfilter/Kconfig"
 source "net/decnet/netfilter/Kconfig"
@@ -205,8 +206,6 @@ config NET_PKTGEN
 	  To compile this code as a module, choose M here: the
 	  module will be called pktgen.
 
-source "net/netfilter/Kconfig"
-
 endmenu
 
 endmenu
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -7,16 +7,15 @@ menu "IP: Netfilter Configuration"
 
 # connection tracking, helpers and protocols
 config IP_NF_CONNTRACK
-	tristate "Connection tracking (required for masq/NAT)"
+	depends on EXPERIMENTAL
+	tristate "Layer 3 Independent Connection tracking (EXPERIMENTAL)"
 	---help---
 	  Connection tracking keeps a record of what packets have passed
 	  through your machine, in order to figure out how they are related
 	  into connections.
 
-	  This is required to do Masquerading or other kinds of Network
-	  Address Translation (except for Fast NAT).  It can also be used to
-	  enhance packet filtering (see `Connection state match support'
-	  below).
+	  Layer 3 independent connection tracking is experimental scheme
+	  which generalize ip_conntrack to support other layer 3 protocols.
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -1,3 +1,6 @@
+menu "Generic Netfilter Configuration"
+	depends on NET && NETFILTER
+
 config NETFILTER_NETLINK
        tristate "Netfilter netlink interface"
        help
@@ -82,3 +85,4 @@ config NF_CONNTRACK_FTP
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+endmenu

----Next_Part(Thu_Aug__4_06_14_45_2005_682)----
