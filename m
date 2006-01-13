From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] [CTNETLINK] load-on-demand support for expectations
Date: Fri, 13 Jan 2006 02:21:04 +0100
Message-ID: <43C70080.6020009@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020306070702000909020609"
Cc: Patrick McHardy <kaber@trash.net>
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

This is a multi-part message in MIME format.
--------------020306070702000909020609
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Add load-on-demand support for expectation request. eg. conntrack -L expect

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------020306070702000909020609
Content-Type: text/plain;
 name="x2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x2"

Add load-on-demand support for expectation request. eg. conntrack -L expect

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: netfilter-2.6.14.git/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- netfilter-2.6.14.git.orig/net/netfilter/nf_conntrack_netlink.c	2006-01-08 21:13:14.000000000 +0100
+++ netfilter-2.6.14.git/net/netfilter/nf_conntrack_netlink.c	2006-01-08 21:39:53.000000000 +0100
@@ -1589,6 +1589,7 @@ static struct nfnetlink_subsystem ctnl_e
 };
 
 MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_CTNETLINK);
+MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_CTNETLINK_EXP);
 
 static int __init ctnetlink_init(void)
 {
Index: netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- netfilter-2.6.14.git.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-12-15 12:46:08.000000000 +0100
+++ netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-01-08 21:40:20.000000000 +0100
@@ -1576,6 +1576,7 @@ static struct nfnetlink_subsystem ctnl_e
 };
 
 MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_CTNETLINK);
+MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_CTNETLINK_EXP);
 
 static int __init ctnetlink_init(void)
 {

--------------020306070702000909020609--
