From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Subject: [PATCH] fix undefined symbols
Date: Wed, 11 Jan 2006 16:36:30 +0100
Message-ID: <43C525FE.8080607@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

Hi,

with 2.5.15-git7 I get the following warning:

*** Warning: "compare_ether_addr" [net/ipv6/netfilter/ip6t_mac.ko] undefined!
*** Warning: "compare_ether_addr" [net/bridge/netfilter/ebt_stp.ko] undefined!

The following patch fixes it.

Regards,
Carl-Daniel


Signed-off-by: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>

--- linux-2.6.15/net/ipv6/netfilter/ip6t_mac.c~	2006-01-11 13:12:16.000000000 +0100
+++ linux-2.6.15/net/ipv6/netfilter/ip6t_mac.c	2006-01-11 14:54:01.000000000 +0100
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/if_ether.h>
+#include <linux/etherdevice.h>
 
 #include <linux/netfilter_ipv6/ip6t_mac.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
--- linux-2.6.15/net/bridge/netfilter/ebt_stp.c~	2006-01-11 13:12:14.000000000 +0100
+++ linux-2.6.15/net/bridge/netfilter/ebt_stp.c	2006-01-11 14:53:33.000000000 +0100
@@ -11,6 +11,7 @@
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_stp.h>
 #include <linux/module.h>
+#include <linux/etherdevice.h>
 
 #define BPDU_TYPE_CONFIG 0
 #define BPDU_TYPE_TCN 0x80
