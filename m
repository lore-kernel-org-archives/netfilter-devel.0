From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] ip6t_REJECT on ppc
Date: Mon, 20 Sep 2004 15:32:47 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040920223247.GA373@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="6c2NcOVqGQ03X4Wi"
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
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

As noted by Pavel Sikora, PPC platform has no optimized version of
csum_ipv6_magic.  As such, ip6t_REJECT does not build on that
platform without including the generic version.  The patch below
does this.

Compile tested on i386 - Pavel tested the patch below on PPC.

This fixes bugzilla #226.

Phil



--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-ip6treject

diff -ru pom-orig/REJECT/linux-2.6/net/ipv6/netfilter/ip6t_REJECT.c pom-new/REJECT/linux-2.6/net/ipv6/netfilter/ip6t_REJECT.c
--- pom-orig/REJECT/linux-2.6/net/ipv6/netfilter/ip6t_REJECT.c	2004-03-26 00:39:33.000000000 -0800
+++ pom-new/REJECT/linux-2.6/net/ipv6/netfilter/ip6t_REJECT.c	2004-09-20 15:27:22.070527392 -0700
@@ -22,6 +22,7 @@
 #include <net/ipv6.h>
 #include <net/tcp.h>
 #include <net/icmp.h>
+#include <net/ip6_checksum.h>
 #include <net/ip6_fib.h>
 #include <net/ip6_route.h>
 #include <net/flow.h>

--6c2NcOVqGQ03X4Wi--
