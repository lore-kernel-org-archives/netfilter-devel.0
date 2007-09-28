From: Sven Schnelle <svens@bitebene.org>
Subject: [RFC] TCPOPTSTRIP target
Date: Fri, 28 Sep 2007 08:56:37 +0200
Message-ID: <873awz2s7u.fsf@begreifnix.intranet.astaro.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from woomax.duncanthrax.net ([195.2.162.46]:34181 "EHLO
	woomax.duncanthrax.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757472AbXI1HSd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 03:18:33 -0400
Received: from vpn.astaro.de ([213.144.15.3] helo=begreifnix.intranet.astaro.de)
	by smtp.duncanthrax.net with esmtpa (Exim 4.68)
	(envelope-from <svens@bitebene.org>)
	id 1Ib9mD-0003AB-V7
	for netfilter-devel@vger.kernel.org; Fri, 28 Sep 2007 08:56:42 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

--==-=-=
Content-Type: multipart/mixed; boundary="=-=-="

--=-=-=
Content-Transfer-Encoding: quoted-printable

Hi,

i stumbled across a sitiuation where i had to strip of a specific TCP
option from the TCP Header. As i've found no target in current xtables,
i wrote an TCPOPTSTRIP target, that does this.

Maybe this is useful for others (or for integration in the current
xtables) i'm attaching it to this mail. Comments?

Cheers,

Sven.

=2D-=20
Signed-Of-By: Sven Schnelle <svens@bitebene.org>


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline; filename=iptables-tcpoptstrip.diff
Content-Transfer-Encoding: quoted-printable

Index: extensions/libxt_TCPOPTSTRIP.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- extensions/libxt_TCPOPTSTRIP.c	(revision 0)
+++ extensions/libxt_TCPOPTSTRIP.c	(revision 0)
@@ -0,0 +1,120 @@
+/* Shared library add-on to iptables to add TCPOPTSTRIP target support.
+ *
+ * Copyright (c) 2007 Sven Schnelle <svens@bitebene.org>
+*/
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+
+#include <xtables.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_TCPOPTSTRIP.h>
+
+struct optinfo {
+	struct xt_entry_target t;
+	struct xt_tcpoptstrip_info option;
+};
+
+/* Function which prints out usage message. */
+static void help(void)
+{
+    printf("TCPOPTSTRIP target options:\n"
+	   "  --strip-tcp-option value      strip tcp option 'value' from TCP Hea=
der\n");
+}
+
+static const struct option opts[] =3D {
+	{ "strip-tcp-option", 1, NULL, '1' },
+	{ }
+};
+
+/* Initialize the target. */
+static void init(struct xt_entry_target *t)
+{
+}
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int parse(int c, char **argv, int invert, unsigned int *flags,
+      const void *entry, struct xt_entry_target **target)
+{
+    struct xt_tcpoptstrip_info *optinfo
+	=3D (struct xt_tcpoptstrip_info *)(*target)->data;
+
+	switch (c) {
+		unsigned int option;
+
+	case '1':
+	    if (string_to_number(optarg, 0, 255, &option) =3D=3D -1)
+		exit_error(PARAMETER_PROBLEM, "Bad TCPOPTSTRIP value `%s'", optarg);
+	    optinfo->tcpoption =3D option;
+	    *flags =3D 1;
+	    break;
+
+	default:
+	    return 0;
+	}
+
+	return 1;
+}
+
+static void final_check(unsigned int flags)
+{
+    if (!flags)
+	exit_error(PARAMETER_PROBLEM,
+		   "TCPOPTSTRIP target: At least one parameter is required");
+}
+
+/* Prints out the targinfo. */
+static void print(const void *ip,const struct xt_entry_target *target,
+      int numeric)
+{
+	const struct xt_tcpoptstrip_info *optinfo =3D
+		(const struct xt_tcpoptstrip_info *)target->data;
+	printf("TCPOPTSTRIP option %u ", optinfo->tcpoption);
+}
+
+/* Saves the union ipt_targinfo in parsable form to stdout. */
+static void save(const void *ip, const struct xt_entry_target *target)
+{
+    const struct xt_tcpoptstrip_info *optinfo =3D
+	(const struct xt_tcpoptstrip_info *)target->data;
+
+    printf("--strip-tcp-option %u ", optinfo->tcpoption);
+}
+
+static struct xtables_target tcpopt =3D {
+	.family		=3D AF_INET,
+	.name		=3D "TCPOPTSTRIP",
+	.version	=3D IPTABLES_VERSION,
+	.size		=3D XT_ALIGN(sizeof(struct xt_tcpoptstrip_info)),
+	.userspacesize	=3D XT_ALIGN(sizeof(struct xt_tcpoptstrip_info)),
+	.help		=3D &help,
+	.init		=3D &init,
+	.parse		=3D &parse,
+	.final_check	=3D &final_check,
+	.print		=3D &print,
+	.save		=3D &save,
+	.extra_opts	=3D opts
+};
+
+static struct xtables_target tcpopt6 =3D {
+	.family		=3D AF_INET6,
+	.name		=3D "TCPOPTSTRIP",
+	.version	=3D IPTABLES_VERSION,
+	.size		=3D XT_ALIGN(sizeof(struct xt_tcpoptstrip_info)),
+	.userspacesize	=3D XT_ALIGN(sizeof(struct xt_tcpoptstrip_info)),
+	.help		=3D &help,
+	.init		=3D &init,
+	.parse		=3D &parse,
+	.final_check	=3D &final_check,
+	.print		=3D &print,
+	.save		=3D &save,
+	.extra_opts	=3D opts
+};
+
+void _init(void)
+{
+    xtables_register_target(&tcpopt);
+    xtables_register_target(&tcpopt6);
+}
Index: extensions/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- extensions/Makefile	(revision 7050)
+++ extensions/Makefile	(working copy)
@@ -7,7 +7,7 @@
 #
 PF_EXT_SLIB:=3Dah addrtype conntrack ecn icmp iprange owner policy realm r=
ecent tos ttl unclean CLUSTERIP DNAT ECN LOG MASQUERADE MIRROR NETMAP REDIR=
ECT REJECT SAME SNAT TOS TTL ULOG
 PF6_EXT_SLIB:=3Dah dst eui64 frag hbh hl icmp6 ipv6header mh owner policy =
rt HL LOG REJECT
=2DPFX_EXT_SLIB:=3Dconnbytes connmark connlimit comment dccp dscp esp hashl=
imit helper length limit mac mark multiport physdev pkttype quota sctp stat=
e statistic standard string tcp tcpmss time u32 udp CLASSIFY CONNMARK DSCP =
MARK NFLOG NFQUEUE NOTRACK TCPMSS TRACE
+PFX_EXT_SLIB:=3Dconnbytes connmark connlimit comment dccp dscp esp hashlim=
it helper length limit mac mark multiport physdev pkttype quota sctp state =
statistic standard string tcp tcpmss time u32 udp CLASSIFY CONNMARK DSCP MA=
RK NFLOG NFQUEUE NOTRACK TCPMSS TRACE TCPOPTSTRIP
=20
 PF_EXT_SELINUX_SLIB:=3D
 PF6_EXT_SELINUX_SLIB:=3D

--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline; filename=xtables-tcpoptstrip.diff
Content-Transfer-Encoding: quoted-printable

diff --git a/include/linux/netfilter/xt_TCPOPTSTRIP.h b/include/linux/netfi=
lter/xt_TCPOPTSTRIP.h
new file mode 100644
index 0000000..97678e8
=2D-- /dev/null
+++ b/include/linux/netfilter/xt_TCPOPTSTRIP.h
@@ -0,0 +1,9 @@
+#ifndef _XT_TCPOPTSTRIP_H
+#define _XT_TCPOPTSTRIP_H
+
+struct xt_tcpoptstrip_info {
+	int tcpoption;
+};
+
+
+#endif /* _XT_TCPOPTSTRIP_H */
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 3599770..44c6e17 100644
=2D-- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -411,6 +411,13 @@ config NETFILTER_XT_TARGET_TCPMSS
=20
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
+config NETFILTER_XT_TARGET_TCPOPTSTRIP
+	tristate '"TCPOPTSTRIP" target support'
+	depends on NETFILTER_XTABLES && (IPV6 || IPV6=3Dn)
+	---help---
+	  This option adds a `TCPOPTSTRIP' target, which allows you to strip
+	  a specific tcp option from TCP packets.
+
 config NETFILTER_XT_MATCH_COMMENT
 	tristate  '"comment" match support'
 	depends on NETFILTER_XTABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 0c054bf..fe5ac6e 100644
=2D-- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -49,6 +49,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) +=3D xt_TRACE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) +=3D xt_SECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) +=3D xt_TCPMSS.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CONNSECMARK) +=3D xt_CONNSECMARK.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP) +=3D xt_TCPOPTSTRIP.o
=20
 # matches
 obj-$(CONFIG_NETFILTER_XT_MATCH_COMMENT) +=3D xt_comment.o
diff --git a/net/netfilter/xt_TCPOPTSTRIP.c b/net/netfilter/xt_TCPOPTSTRIP.c
new file mode 100644
index 0000000..c3c1420
=2D-- /dev/null
+++ b/net/netfilter/xt_TCPOPTSTRIP.c
@@ -0,0 +1,170 @@
+/*
+ * This is a module which is used for stripping a specific tcp option=20
+ * from TCP packets.
+ *
+ * Copyright (C) 2007 Sven Schnelle <svens@bitebene.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/tcp.h>
+#include <net/ipv6.h>
+#include <net/tcp.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_tcpudp.h>
+#include <linux/netfilter/xt_TCPOPTSTRIP.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Sven Schnelle <svens@bitebene.org>");
+MODULE_DESCRIPTION("x_tables TCPOPTSTRIP module");
+MODULE_ALIAS("ipt_TCPOPTSTRIP");
+MODULE_ALIAS("ip6t_TCPOPTSRIP");
+
+static inline unsigned int optlen(const u_int8_t *opt, unsigned int offset)
+{
+	/* Beware zero-length options: make finite progress */
+	if (opt[offset] <=3D TCPOPT_NOP || opt[offset+1] =3D=3D 0)
+		return 1;
+	else
+		return opt[offset+1];
+}
+
+static void fast_csum(__sum16 *csum,
+		      const u8 *optr,
+		      const u8 *nptr,
+		      const int offset)
+{
+	u8 s[4];
+
+	if (offset & 1) {
+		s[0] =3D s[2] =3D 0;
+		s[1] =3D ~*optr;
+		s[3] =3D *nptr;
+	} else {
+		s[1] =3D s[3] =3D 0;
+		s[0] =3D ~*optr;
+		s[2] =3D *nptr;
+	}
+
+	*csum =3D csum_fold(csum_partial(s, 4, ~csum_unfold(*csum)));
+}
+
+
+static int tcpoptstrip_mangle_packet(struct sk_buff **pskb, const void *in=
fo,
+				    unsigned int tcphoff, unsigned int minlen)
+{
+    struct xt_tcpoptstrip_info *tinfo =3D (struct xt_tcpoptstrip_info *)in=
fo;
+    struct tcphdr *tcph;
+    const u8 newopt =3D TCPOPT_NOP;
+    unsigned int optl, tcplen, i,j;
+    u8 *opt;
+
+    if (!skb_make_writable(pskb, (*pskb)->len))
+	return -1;
+
+    tcplen =3D (*pskb)->len - tcphoff;
+    tcph =3D (struct tcphdr *)(skb_network_header(*pskb) + tcphoff);
+
+    if (tcplen !=3D tcph->doff*4 && net_ratelimit()) {
+	printk(KERN_ERR "xt_TCPOPTSTRIP: bad length (%u bytes)\n", (*pskb)->len);
+	return -1;
+    }
+
+    opt =3D (u_int8_t *)tcph;
+
+    for(i =3D sizeof(struct tcphdr); i < tcph->doff*4; i +=3D optl) {
+	optl =3D optlen(opt, i);
+
+	if(optl + i > tcph->doff*4)
+	    break;
+
+	if (opt[i] =3D=3D tinfo->tcpoption) {
+	    for(j =3D 0; j < optl; j++)
+		fast_csum(&tcph->check, opt+i+j, &newopt, i+j);
+	    if(optl & 1)
+		fast_csum(&tcph->check, &newopt, &newopt, i+j);
+	    memset(opt+i, newopt, optl);
+	    break;
+	}
+    }
+    return 0;
+}
+
+static unsigned int xt_tcpoptstrip_target4(struct sk_buff **pskb,
+		  const struct net_device *in, const struct net_device *out,
+		  unsigned int hooknum, const struct xt_target *target, const void *targ=
info)
+{
+    struct iphdr *iph =3D ip_hdr(*pskb);
+
+
+    tcpoptstrip_mangle_packet(pskb, targinfo, iph->ihl * 4,
+			     sizeof(*iph) + sizeof(struct tcphdr));
+    return XT_CONTINUE;
+}
+
+#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODU=
LE)
+static unsigned int
+xt_tcpoptstrip_target6(struct sk_buff **pskb, const struct net_device *in,=
 const struct net_device *out,
+		  unsigned int hooknum, const struct xt_target *target, const void *targ=
info)
+{
+    struct ipv6hdr *ipv6h =3D ipv6_hdr(*pskb);
+    u8 nexthdr;
+    int tcphoff;
+
+    nexthdr =3D ipv6h->nexthdr;
+    tcphoff =3D ipv6_skip_exthdr(*pskb, sizeof(*ipv6h), &nexthdr);
+    if (tcphoff < 0) {
+	WARN_ON(1);
+	return NF_DROP;
+    }
+
+    tcpoptstrip_mangle_packet(pskb, targinfo, tcphoff,
+			     sizeof(*ipv6h) + sizeof(struct tcphdr));
+    return XT_CONTINUE;
+}
+#endif
+
+static struct xt_target xt_tcpoptstrip_reg[] __read_mostly =3D {
+    {
+	.family		=3D AF_INET,
+	.name		=3D "TCPOPTSTRIP",
+	.target		=3D xt_tcpoptstrip_target4,
+	.targetsize	=3D sizeof(struct xt_tcpoptstrip_info),
+	.proto		=3D IPPROTO_TCP,
+	.table          =3D "mangle",
+	.me		=3D THIS_MODULE,
+    },
+#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODU=
LE)
+    {
+	.family		=3D AF_INET6,
+	.name		=3D "TCPOPTSTRIP",
+	.target		=3D xt_tcpoptstrip_target6,
+	.targetsize	=3D sizeof(struct xt_tcpoptstrip_info),
+	.proto		=3D IPPROTO_TCP,
+	.table          =3D "mangle",
+	.me		=3D THIS_MODULE,
+    },
+#endif
+};
+
+static int __init xt_tcpoptstrip_init(void)
+{
+    return xt_register_targets(xt_tcpoptstrip_reg, ARRAY_SIZE(xt_tcpoptstr=
ip_reg));
+}
+
+static void __exit xt_tcpoptstrip_fini(void)
+{
+    xt_unregister_targets(xt_tcpoptstrip_reg, ARRAY_SIZE(xt_tcpoptstrip_re=
g));
+}
+
+module_init(xt_tcpoptstrip_init);
+module_exit(xt_tcpoptstrip_fini);

--=-=-=--

--==-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG/KWn86MdxiXaIbERAkJcAKCgOCCo7T2mnkx5bhOpyerAkGac7wCeISkP
AjMpoJO3O4qVrICkFZMWIDQ=
=s1BH
-----END PGP SIGNATURE-----
--==-=-=--
