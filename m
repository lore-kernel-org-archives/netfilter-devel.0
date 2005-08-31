From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: kernel config for nfnetlink [Was Re: your mail]
Date: Wed, 31 Aug 2005 18:47:19 +0900 (JST)
Message-ID: <200508310947.j7V9lKKQ013216@toshiba.co.jp>
References: <200508301321.j7UDLV9k002943@toshiba.co.jp>
	<20050830140923.GD4221@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Wed_Aug_31_18_47_19_2005_401)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, pablo@netfilter.org,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20050830140923.GD4221@rama.de.gnumonks.org>
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

----Next_Part(Wed_Aug_31_18_47_19_2005_401)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Oh, sorry for missing subject.

From: Harald Welte <laforge@netfilter.org>
Date: Tue, 30 Aug 2005 16:09:23 +0200

> > If CONFIG_NF_IP_CONNTRACK=y, CONFIG_NETFILTER_NETLINK=m, and
> > CONFIG_NF_CONNTRACK_NETLINK=m, it's failed to build kernel
> > of netfilter-2.6.14 git tree. Because __nfa_fill() in nfnetlink
> > called from ip_conntrack isn't built into kernel image in this case.
> > It's necessary to fix Kconfig or change source code to make dependencies
> > more simple.
> 
> Thanks for pointing this out.
> 
> This problem will be fixed by Thomas Graf's generic netlink macros
> (which will be part of the core network stack) which will be merged
> during the net-2.6.14 process, so I think we can ignore
> this for now.

That's good. And I found that kernel configuration for nfnetlink in
David's 2.6.14 tree is in pkgen menu. But its Kconfig doesn't include
'menu'. Should we add 'menu "Core Netfilter Configuration"' to it ?

Of cause, if we can submit nf_conntrack, we don't need fix for this
because it's already fixed in nf_conntrack tree.

I attached the patch for this anyway.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Wed_Aug_31_18_47_19_2005_401)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="nfnetlink_menu.patch"

diff --git a/net/Kconfig b/net/Kconfig
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -140,6 +140,7 @@ config BRIDGE_NETFILTER
 
 	  If unsure, say N.
 
+source "net/netfilter/Kconfig"
 source "net/ipv4/netfilter/Kconfig"
 source "net/ipv6/netfilter/Kconfig"
 source "net/decnet/netfilter/Kconfig"
@@ -206,7 +207,6 @@ config NET_PKTGEN
 	  To compile this code as a module, choose M here: the
 	  module will be called pktgen.
 
-source "net/netfilter/Kconfig"
 
 endmenu
 
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -1,3 +1,6 @@
+menu "Core Netfilter Configuration"
+        depends on NET && NETFILTER
+
 config NETFILTER_NETLINK
        tristate "Netfilter netlink interface"
        help
@@ -22,3 +25,4 @@ config NETFILTER_NETLINK_LOG
 	  and is also scheduled to replace the old syslog-based ipt_LOG
 	  and ip6t_LOG modules.
 
+endmenu

----Next_Part(Wed_Aug_31_18_47_19_2005_401)----
