From: Tim Gardner <timg@tpi.com>
Subject: Re: Call for testing: patch-o-matic-ng (fuzzy filter)
Date: Tue, 23 Dec 2003 08:13:09 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200312230813.09796.timg@tpi.com>
References: <20031221122445.GC5058@obroa-skai.de.gnumonks.org> <20031222120047.GK5058@obroa-skai.de.gnumonks.org> <200312230757.23207.timg@tpi.com>
Reply-To: timg@tpi.com
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="------------Boundary-00=_XXSC4VAEMSLS4YQX1GD5"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <200312230757.23207.timg@tpi.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--------------Boundary-00=_XXSC4VAEMSLS4YQX1GD5
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Harald,

Attached is a patch file that corrects ipt_fuzzy.c for 2.6.

rtg
--=20
Tim Gardner - timg@tpi.com
www.tpi.com 406-443-5357
--------------Boundary-00=_XXSC4VAEMSLS4YQX1GD5
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="fuzzy.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="fuzzy.diff"

diff -r -u --new-file netfilter/patch-o-matic-ng/fuzzy/linux/net/ipv4/netfilter/ipt_fuzzy.c netfilter.wrk/patch-o-matic-ng/fuzzy/linux/net/ipv4/netfilter/ipt_fuzzy.c
--- netfilter/patch-o-matic-ng/fuzzy/linux/net/ipv4/netfilter/ipt_fuzzy.c	2003-12-18 11:15:29.000000000 -0700
+++ netfilter.wrk/patch-o-matic-ng/fuzzy/linux/net/ipv4/netfilter/ipt_fuzzy.c	2003-12-23 08:07:52.000000000 -0700
@@ -17,6 +17,7 @@
 */
 
 #include <linux/module.h>
+#include <linux/version.h>
 #include <linux/skbuff.h>
 #include <linux/ip.h>
 #include <linux/random.h>
@@ -64,8 +65,10 @@
 	       const struct net_device *out,
 	       const void *matchinfo,
 	       int offset,
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
 	       const void *hdr,
 	       u_int16_t datalen,
+#endif
 	       int *hotdrop)
 {
 	/* From userspace */

--------------Boundary-00=_XXSC4VAEMSLS4YQX1GD5--
