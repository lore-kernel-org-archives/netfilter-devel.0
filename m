From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] Unspecified proto should print as "all" in iptables -L
Date: Sat, 28 Apr 2007 15:02:06 -0700
Message-ID: <20070428220206.GA26272@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="envbJBWh7q8WU6mo"
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

In fixing bug #446 [1], the output for unspecified proto was changed
from "all" to "0".  This reverts to the original behaviour, and
closes bugzilla #543.

Phil

[1] http://svn.netfilter.org/cgi-bin/viewcvs.cgi/trunk/iptables/ip6tables.c?r1=6465&r2=6466




--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-ipt-proto-all

diff -ru ipt-orig/iptables.c ipt-new/iptables.c
--- ipt-orig/iptables.c	2007-03-20 08:51:41.000000000 -0700
+++ ipt-new/iptables.c	2007-04-28 14:51:02.000000000 -0700
@@ -232,6 +232,7 @@
 	{ "esp", IPPROTO_ESP },
 	{ "ah", IPPROTO_AH },
 	{ "sctp", IPPROTO_SCTP },
+	{ "all", 0 },
 };
 
 static char *

--envbJBWh7q8WU6mo--
