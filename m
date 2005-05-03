From: Pawel Sikora <pluto@pld-linux.org>
Subject: [PATCH] undefined "csum_ipv6_magic" in
	net/ipv6/netfilter/nf_conntrack_ipv6.ko
Date: Tue, 3 May 2005 09:11:50 +0200
Message-ID: <200505030911.51011.pluto@pld-linux.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_2QydCMmFJeG9vWp"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>
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

--Boundary-00=_2QydCMmFJeG9vWp
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi All,

The asm/arch-ppc/checksum.h doesn't provide an optimizied version
of `csum_ipv6_magic'. You shoud use a generic version.

During build on PPC32 I get:

  CC [M]  net/ipv6/netfilter/nf_conntrack_proto_icmpv6.o
net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c: In function `icmpv6_error':
net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c:239:
  warning: implicit declaration of function csum_ipv6_magic'

And finally get unusable module:
* Warning: "csum_ipv6_magic" [net/ipv6/netfilter/nf_conntrack_ipv6.ko]
  undefined!

Problem was also reported in bug#307.

Regards,
Pawel.

-- 
The only thing necessary for the triumph of evil
  is for good men to do nothing.
                                           - Edmund Burke

--Boundary-00=_2QydCMmFJeG9vWp
Content-Type: text/x-diff; charset="utf-8";
	name="nf_conntrack-undefined_checksum.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="nf_conntrack-undefined_checksum.patch"

Index: nf_conntrack/linux-2.6/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
===================================================================
--- nf_conntrack/linux-2.6/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c	(revision 3889)
+++ nf_conntrack/linux-2.6/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c	(working copy)
@@ -25,6 +25,7 @@
 #include <linux/icmpv6.h>
 #include <linux/ipv6.h>
 #include <net/ipv6.h>
+#include <net/ip6_checksum.h>
 #include <linux/seq_file.h>
 #include <linux/netfilter_ipv6.h>
 #include <linux/netfilter/nf_conntrack_tuple.h>

--Boundary-00=_2QydCMmFJeG9vWp--
