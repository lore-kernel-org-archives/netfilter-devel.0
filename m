From: Willy Tarreau <willy@w.ods.org>
Subject: [PATCH] ipt_ROUTE build fix
Date: Sun, 30 May 2004 02:04:59 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040530000459.GA2389@alpha.home.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi all,

I had to include the following patch to build ipt_ROUTE as a module
under 2.4.27-pre3 (ip_fast_csum not found). I believe it broke not too
long ago but was lazy enough to check when since the patch is 1-line.
Patch against pom-ng-040528. 

Please apply,
Willy

diff -ur linux-2.4-bk-pomng/net/ipv4/netfilter/ipt_ROUTE.c linux-2.4-bk-pomng-ipt_route/net/ipv4/netfilter/ipt_ROUTE.c
--- linux-2.4-bk-pomng/net/ipv4/netfilter/ipt_ROUTE.c	Sat May 29 21:30:52 2004
+++ linux-2.4-bk-pomng-ipt_route/net/ipv4/netfilter/ipt_ROUTE.c	Sat May 29 21:33:58 2004
@@ -19,6 +19,7 @@
 #include <net/ip.h>
 #include <net/route.h>
 #include <net/icmp.h>
+#include <net/checksum.h>
 
 #if 0
 #define DEBUGP printk
