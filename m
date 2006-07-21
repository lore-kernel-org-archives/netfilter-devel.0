From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] ROUTE target missing targetsize initialization
Date: Fri, 21 Jul 2006 13:19:50 -0700
Message-ID: <20060721201950.GA1130@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="NzB8fVQJ5HfG6fxh"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Targetsize field needs to be initialized.  

Closes bug #490.

Phil

--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-ROUTE

--- linux-diags/net/ipv4/netfilter/ipt_ROUTE.c	2006-07-21 16:12:59.000000000 -0400
+++ linux-po/net/ipv4/netfilter/ipt_ROUTE.c	2006-07-21 16:04:51.000000000 -0400
@@ -436,6 +436,7 @@
 static struct ipt_target ipt_route_reg = { 
 	.name = "ROUTE",
 	.target = ipt_route_target,
+	.targetsize = sizeof(struct ipt_route_target_info),
 	.checkentry = ipt_route_checkentry,
 	.me = THIS_MODULE,
 };
--- linux-diags/net/ipv6/netfilter/ip6t_ROUTE.c	2006-07-21 16:12:59.000000000 -0400
+++ linux-po/net/ipv6/netfilter/ip6t_ROUTE.c	2006-07-21 16:05:45.000000000 -0400
@@ -283,6 +283,7 @@
 static struct ip6t_target ip6t_route_reg = {
 	.name       = "ROUTE",
 	.target     = ip6t_route_target,
+	.targetsize = sizeof(struct ip6t_route_target_info),
 	.checkentry = ip6t_route_checkentry,
 	.me         = THIS_MODULE
 };

--NzB8fVQJ5HfG6fxh--
