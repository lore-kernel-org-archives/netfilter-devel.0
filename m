From: Gregor Maier <gregor@net.in.tum.de>
Subject: IPv6 stateful macht support for 2.6.15.2
Date: Mon, 06 Feb 2006 20:45:22 +0100
Message-ID: <43E7A752.3070101@net.in.tum.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigF3180AB257BF65EEF49E20BE"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF3180AB257BF65EEF49E20BE
Content-Type: multipart/mixed; boundary="------------020000020106000005000404"

This is a multi-part message in MIME format.
--------------020000020106000005000404
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

since I haven't found state match support for IPv6 in the kernel
(although it's supported by iptables 1.3.5) if ported the ipt_state.c
code to v6 (ip6t_state.c).

So here's a patch that adds IPv6 state match support to the kernel.

cu
Gregor

-- 
Gregor Maier                                      Lehrstuhl Informatik 8
gregor@net.in.tum.de                              Tel: +49 89  289-18010
http://www.net.in.tum.de                                     TU Muenchen

--------------020000020106000005000404
Content-Type: text/plain; x-mac-type="0"; x-mac-creator="0";
	name="ip6t_state-2.6.15.2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ip6t_state-2.6.15.2.patch"

diff -Naur linux-2.6.15.2.orig/include/linux/netfilter_ipv6/ip6t_state.h linux-2.6.15.2/include/linux/netfilter_ipv6/ip6t_state.h
--- linux-2.6.15.2.orig/include/linux/netfilter_ipv6/ip6t_state.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.15.2/include/linux/netfilter_ipv6/ip6t_state.h	2006-02-06 19:44:43.000000000 +0100
@@ -0,0 +1,13 @@
+#ifndef _IP6T_STATE_H
+#define _IP6T_STATE_H
+
+#define IP6T_STATE_BIT(ctinfo) (1 << ((ctinfo)%IP_CT_IS_REPLY+1))
+#define IP6T_STATE_INVALID (1 << 0)
+
+#define IP6T_STATE_UNTRACKED (1 << (IP_CT_NUMBER + 1))
+
+struct ip6t_state_info
+{
+	unsigned int statemask;
+};
+#endif /*_IP6T_STATE_H*/
diff -Naur linux-2.6.15.2.orig/net/ipv6/netfilter/ip6t_state.c linux-2.6.15.2/net/ipv6/netfilter/ip6t_state.c
--- linux-2.6.15.2.orig/net/ipv6/netfilter/ip6t_state.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.15.2/net/ipv6/netfilter/ip6t_state.c	2006-02-06 19:49:02.000000000 +0100
@@ -0,0 +1,77 @@
+/* Kernel module to match connection tracking information. */
+
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <net/netfilter/nf_conntrack_compat.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_ipv6/ip6t_state.h>
+
+extern void need_ip6_conntrack(void);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Rusty Russell <rusty@rustcorp.com.au>");
+MODULE_DESCRIPTION("ip6tables connection tracking state match module");
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+		unsigned int protoff,
+      int *hotdrop)
+{
+	const struct ip6t_state_info *sinfo = matchinfo;
+	enum ip_conntrack_info ctinfo;
+	unsigned int statebit;
+
+	if (nf_ct_is_untracked(skb))
+		statebit = IP6T_STATE_UNTRACKED;
+	else if (!nf_ct_get_ctinfo(skb, &ctinfo))
+		statebit = IP6T_STATE_INVALID;
+	else
+		statebit = IP6T_STATE_BIT(ctinfo);
+
+	return (sinfo->statemask & statebit);
+}
+
+static int check(const char *tablename,
+		 const struct ip6t_ip6 *ip,
+		 void *matchinfo,
+		 unsigned int matchsize,
+		 unsigned int hook_mask)
+{
+	if (matchsize != IP6T_ALIGN(sizeof(struct ip6t_state_info)))
+		return 0;
+
+	return 1;
+}
+
+static struct ip6t_match state_match = {
+	.name		= "state",
+	.match		= &match,
+	.checkentry	= &check,
+	.me		= THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	need_ip6_conntrack();
+	return ip6t_register_match(&state_match);
+}
+
+static void __exit fini(void)
+{
+	ip6t_unregister_match(&state_match);
+}
+
+module_init(init);
+module_exit(fini);
diff -Naur linux-2.6.15.2.orig/net/ipv6/netfilter/Kconfig linux-2.6.15.2/net/ipv6/netfilter/Kconfig
--- linux-2.6.15.2.orig/net/ipv6/netfilter/Kconfig	2006-01-31 07:25:07.000000000 +0100
+++ linux-2.6.15.2/net/ipv6/netfilter/Kconfig	2006-02-06 19:55:49.000000000 +0100
@@ -115,6 +115,17 @@
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config IP6_NF_MATCH_STATE
+	tristate "Connection state match support"
+	depends on IP6_NF_IPTABLES
+	depends on NF_CONNTRACK_IPV6
+	help
+	  Connection state matching allows you to match packets based on their
+	  relationship to a tracked connection (ie. previous packets).  This
+	  is a powerful tool for packet classification.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config IP6_NF_MATCH_OWNER
 	tristate "Owner match support"
 	depends on IP6_NF_IPTABLES
diff -Naur linux-2.6.15.2.orig/net/ipv6/netfilter/Makefile linux-2.6.15.2/net/ipv6/netfilter/Makefile
--- linux-2.6.15.2.orig/net/ipv6/netfilter/Makefile	2006-01-31 07:25:07.000000000 +0100
+++ linux-2.6.15.2/net/ipv6/netfilter/Makefile	2006-02-06 19:52:12.000000000 +0100
@@ -33,3 +33,6 @@
 
 # l3 independent conntrack
 obj-$(CONFIG_NF_CONNTRACK_IPV6) += nf_conntrack_ipv6.o
+
+obj-$(CONFIG_IP6_NF_MATCH_STATE) += ip6t_state.o
+

--------------020000020106000005000404--

--------------enigF3180AB257BF65EEF49E20BE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (Darwin)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFD56dWdGiwgbikMYMRAox8AKCYOd9GvCS0m3Bpfa8j/57hA5hmPQCeJvor
uDIVQ5a6U0GVaUnpDnRhJuE=
=PvkE
-----END PGP SIGNATURE-----

--------------enigF3180AB257BF65EEF49E20BE--
