From: Tim Gardner <timg@tpi.com>
Subject: Re: Call for testing: patch-o-matic-ng (condition filter)
Date: Tue, 23 Dec 2003 07:57:23 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200312230757.23207.timg@tpi.com>
References: <20031221122445.GC5058@obroa-skai.de.gnumonks.org> <1072086985.1031.7.camel@nienna.balabit> <20031222120047.GK5058@obroa-skai.de.gnumonks.org>
Reply-To: timg@tpi.com
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="------------Boundary-00=_N7SCM095CLAVI3554D5E"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031222120047.GK5058@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--------------Boundary-00=_N7SCM095CLAVI3554D5E
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Harald,

The condition filter (at least for 2.6) has extra files:

condition/linux/net/ipv6/Makefile.ladd
condition/linux/net/ipv6/Config.in.ladd

The presense of Makefile.ladd will not allow the filter to be applied. I=20
suspect Config.in.ladd will cause a similar problem for 2.4.

Attached is a patch that removes these files as well as patches=20
ipt_condition.c for 2.6.

ipv6/netfilter/ipt_condition.c compiles with warnings. Since I'm not usin=
g it=20
(and I'm basically lazy), I'll leave it up to the authors to make it corr=
ect=20
for 2.6

rtg
--=20
Tim Gardner - timg@tpi.com
www.tpi.com 406-443-5357
--------------Boundary-00=_N7SCM095CLAVI3554D5E
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="condition.diffs"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="condition.diffs"

diff -r -u --new-file netfilter/patch-o-matic-ng/condition/linux/net/ipv4/netfilter/ipt_condition.c netfilter.wrk/patch-o-matic-ng/condition/linux/net/ipv4/netfilter/ipt_condition.c
--- netfilter/patch-o-matic-ng/condition/linux/net/ipv4/netfilter/ipt_condition.c	2003-12-18 11:47:55.000000000 -0700
+++ netfilter.wrk/patch-o-matic-ng/condition/linux/net/ipv4/netfilter/ipt_condition.c	2003-12-23 07:45:30.000000000 -0700
@@ -17,6 +17,7 @@
 \*-------------------------------------------*/
 
 #include<linux/module.h>
+#include <linux/version.h>
 #include<linux/proc_fs.h>
 #include<linux/spinlock.h>
 #include<linux/string.h>
@@ -90,9 +91,17 @@
 
 
 static int
-match(const struct sk_buff *skb, const struct net_device *in,
-      const struct net_device *out, const void *matchinfo, int offset,
-      const void *hdr, u_int16_t datalen, int *hotdrop)
+match(
+	const struct sk_buff *skb,
+	const struct net_device *in,
+	const struct net_device *out,
+	const void *matchinfo,
+	int offset,
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
+	const void *hdr,
+	u_int16_t datalen,
+#endif
+	int *hotdrop)
 {
 	const struct condition_info *info =
 	    (const struct condition_info *) matchinfo;
diff -r -u --new-file netfilter/patch-o-matic-ng/condition/linux/net/ipv6/Config.in.ladd netfilter.wrk/patch-o-matic-ng/condition/linux/net/ipv6/Config.in.ladd
--- netfilter/patch-o-matic-ng/condition/linux/net/ipv6/Config.in.ladd	2003-12-20 09:38:19.000000000 -0700
+++ netfilter.wrk/patch-o-matic-ng/condition/linux/net/ipv6/Config.in.ladd	1969-12-31 17:00:00.000000000 -0700
@@ -1,2 +0,0 @@
-  dep_tristate '  MAC address match support' CONFIG_IP6_NF_MATCH_MAC $CONFIG_IP6_NF_IPTABLES
-  dep_tristate '  Condition variable match support' CONFIG_IP6_NF_MATCH_CONDITION $CONFIG_IP6_NF_IPTABLES
diff -r -u --new-file netfilter/patch-o-matic-ng/condition/linux/net/ipv6/Makefile.ladd netfilter.wrk/patch-o-matic-ng/condition/linux/net/ipv6/Makefile.ladd
--- netfilter/patch-o-matic-ng/condition/linux/net/ipv6/Makefile.ladd	2003-12-20 09:38:19.000000000 -0700
+++ netfilter.wrk/patch-o-matic-ng/condition/linux/net/ipv6/Makefile.ladd	1969-12-31 17:00:00.000000000 -0700
@@ -1,2 +0,0 @@
-obj-$(CONFIG_IP6_NF_MATCH_MARK) += ip6t_mark.o
-obj-$(CONFIG_IP6_NF_MATCH_CONDITION) += ip6t_condition.o

--------------Boundary-00=_N7SCM095CLAVI3554D5E--
