From: Glen Turner <glen.turner@aarnet.edu.au>
Subject: [PATCH] Add TCPCONG target to patch-o-matic
Date: Thu, 05 Oct 2006 17:30:50 +0930
Message-ID: <4524BBB2.2000109@aarnet.edu.au>
References: <45235EDC.4080709@aarnet.edu.au> <4524118B.4020903@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <4524118B.4020903@netfilter.org>
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


Hi folks,

I have created a kernel module and iptables shared library
to allow netfilter to set the TCP congestion control
algorithm.

This has three major uses: selecting differing algorithms
for wired and non-wired interfaces; selecting differing
algorithms for close and far hosts; and selecting differing
algorithms for comparison testing.

Thanks to the hint from Pablo Neira Ayuso I have put this
into the patch-o-matic format.  This has been tested against
iptables-1.3.6 and linux-2.6.18.

A SVN diff against patch-o-matic follows, which I'm hoping
Thunderbird doesn't mangle. Since I'm not familiar with SVN
please let me know if this isn't the desired patch format.

I would hope that this facility can become a standard part of
the kernel and iptables.  Please let me know what I need to
do to follow that path.

Thanks,
Glen

Index: patchlets/TCPCONG/linux-2.6.patch
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- patchlets/TCPCONG/linux-2.6.patch	(revision 0)
+++ patchlets/TCPCONG/linux-2.6.patch	(revision 0)
@@ -0,0 +1,10 @@
+--- linux-2.6.18/net/ipv4/tcp_cong.c	2006-09-20 13:12:06.000000000 +0930
++++ linux-2.6.18-new/net/ipv4/tcp_cong.c	2006-10-04 15:10:59.000000000 +=
0930
+@@ -172,6 +172,7 @@
+ 	rcu_read_unlock();
+ 	return err;
+ }
++EXPORT_SYMBOL_GPL(tcp_set_congestion_control);
+
+
+ /*
Index: patchlets/TCPCONG/linux-2.6/include/linux/netfilter_ipv4/ipt_TCPCO=
NG.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- patchlets/TCPCONG/linux-2.6/include/linux/netfilter_ipv4/ipt_TCPCONG.=
h	(revision 0)
+++ patchlets/TCPCONG/linux-2.6/include/linux/netfilter_ipv4/ipt_TCPCONG.=
h	(revision 0)
@@ -0,0 +1,25 @@
+/* iptables module for setting the TCP congestion control algorithm.
+ *
+ * For information see net/ipv4/netfilter/ipt_TCPCONG.c.
+ *
+ * Copyright =C2=A9 Glen David Turner of Semaphore, South Australia, 200=
6.
+ * <http://www.aarnet.edu.au/~gdt/>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version.
+ */
+
+#ifndef _IPT_TCPCONG_TARGET_H
+#define _IPT_TCPCONG_TARGET_H
+
+/* Value from tcp.h, but this header needs to work for both kernel and u=
ser compile. */
+#define TCP_CA_NAME_MAX 16
+
+/* Target attributes */
+struct ipt_TCPCONG {
+	char algorithm_name[TCP_CA_NAME_MAX];
+};
+
+#endif /* _IPT_TCPCONG_TARGET_H */

Property changes on: patchlets/TCPCONG/linux-2.6/include/linux/netfilter_=
ipv4/ipt_TCPCONG.h
___________________________________________________________________
Name: svn:keywords
    + Id
Name: svn:eol-style
    + native

Index: patchlets/TCPCONG/linux-2.6/net/ipv4/netfilter/Makefile.ladd
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- patchlets/TCPCONG/linux-2.6/net/ipv4/netfilter/Makefile.ladd	(revisio=
n 0)
+++ patchlets/TCPCONG/linux-2.6/net/ipv4/netfilter/Makefile.ladd	(revisio=
n 0)
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP_NF_TARGET_LOG) +=3D ipt_LOG.o
+obj-$(CONFIG_IP_NF_TARGET_TCPCONG) +=3D ipt_TCPCONG.o
Index: patchlets/TCPCONG/linux-2.6/net/ipv4/netfilter/Kconfig.ladd
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- patchlets/TCPCONG/linux-2.6/net/ipv4/netfilter/Kconfig.ladd	(revision=
 0)
+++ patchlets/TCPCONG/linux-2.6/net/ipv4/netfilter/Kconfig.ladd	(revision=
 0)
@@ -0,0 +1,13 @@
+config IP_NF_TARGET_TCPCONG
+	tristate "TCP congeston control algorithm target support"
+	depends on TCP_CONG_ADVANCED
+	---help---
+	  This option adds a TCPCONG target. This allows the TCP
+	  congestion control algorithm to be selected from Netfilter.
+
+	  The TCPCONG target requires the kernel compilation option
+	  TCP_CONG_ADVANCED, which can be found at Networking |
+	  Networking support | Networking options | TCP/IP networking |
+	  TCP: advanced congestion control.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
Index: patchlets/TCPCONG/linux-2.6/net/ipv4/netfilter/ipt_TCPCONG.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- patchlets/TCPCONG/linux-2.6/net/ipv4/netfilter/ipt_TCPCONG.c	(revisio=
n 0)
+++ patchlets/TCPCONG/linux-2.6/net/ipv4/netfilter/ipt_TCPCONG.c	(revisio=
n 0)
@@ -0,0 +1,125 @@
+/* iptables module for setting the TCP congestion control algorithm.
+ *
+ * Copyright =C2=A9 Glen David Turner of Semaphore, South Australia, 200=
6.
+ * <http://www.aarnet.edu.au/~gdt/>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <net/tcp.h>        /* For TCP_*, tcp_setsockopt(). */
+#include <linux/socket.h>   /* For SOL_TCP */
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_TCPCONG.h>
+
+MODULE_DESCRIPTION("iptables TCPCONG target sets TCP congestion control =
algorithm");
+MODULE_AUTHOR("Glen Turner, http://www.aarnet.edu.au/~gdt/");
+MODULE_LICENSE("GPL");
+
+static unsigned int
+target(struct sk_buff **pskb,
+       const struct net_device *in,
+       const struct net_device *out,
+       unsigned int hooknum,
+       const struct xt_target *target,
+       const void *targinfo,
+       void *userinfo)
+{
+        int error;
+	const struct ipt_TCPCONG *tcpcong =3D targinfo;
+	struct sock *sk =3D (*pskb)->sk;
+
+        if (sk) {
+                /* Netfilter has already locked sk. */
+                error =3D tcp_set_congestion_control(sk,
+                                                   tcpcong->algorithm_na=
me);
+                if (error) {
+                        if (error =3D=3D -2) {
+                                printk(KERN_INFO
+                                       "TCPCONG: Cannot find TCP congest=
ion "
+                                       "control algorithm \'%s\". (Perha=
ps "
+                                       "\"modprobe tcp_%s\" was forgotte=
n.) "
+                                       "Continuing with previous algorit=
hm."
+                                       "\n",
+                                       tcpcong->algorithm_name,
+                                       tcpcong->algorithm_name);
+                        } else {
+                                printk(KERN_INFO
+                                       "TCPCONG: Failed with error %d "
+                                       "setting TCP congestion control "
+                                       "algorithm \"%s\"; continuing wit=
h "
+                                       "previous algorithm.\n",
+                                       error,
+                                       tcpcong->algorithm_name);
+                        }
+                }
+        } else {
+                printk(KERN_INFO
+                       "TCPCONG: No socket yet for this packet; continui=
ng "
+                       "with previous TCP congestion control algorithm\n=
");
+        }
+
+	return IPT_CONTINUE;
+}
+
+static int
+checkentry(const char *tablename,
+           const void *entry_void,
+           const struct xt_target *target,
+           void *targinfo,
+           unsigned int targinfosize,
+           unsigned int hook_mask)
+{
+        const struct ipt_entry *entry =3D entry_void;
+
+        if (entry->ip.proto !=3D IPPROTO_TCP) {
+                printk(KERN_INFO
+                       "TCPCONG: Need a match of \"--protocol tcp\" befo=
re "
+                       "the target \"--tcpcong-algorithm\" can be used t=
o set "
+                       "a TCP congestion control algorithm.\n");
+                return 0;
+        }
+        return 1;
+}
+
+/* Module registration. */
+static struct ipt_target target_registration =3D {
+	.name =3D "TCPCONG",
+	.target =3D target,
+	.targetsize =3D sizeof(struct ipt_TCPCONG),
+	.table =3D "filter",
+	.checkentry =3D checkentry,
+	.me =3D THIS_MODULE,
+};
+
+static int __init ipt_tcpcong_init(void)
+{
+	return ipt_register_target(&target_registration);
+}
+
+/* Unregistering a target leaves the TCP congestion control algorithm in=
 place
+ * for opened connections. Not sure if this is a bug, since it might act=
ually
+ * be desirable.
+ */
+static void __exit ipt_tcpcong_fini(void)
+{
+	ipt_unregister_target(&target_registration);
+}
+
+module_init(ipt_tcpcong_init);
+module_exit(ipt_tcpcong_fini);

Property changes on: patchlets/TCPCONG/linux-2.6/net/ipv4/netfilter/ipt_T=
CPCONG.c
___________________________________________________________________
Name: svn:keywords
    + Id
Name: svn:eol-style
    + native

Index: patchlets/TCPCONG/iptables/extensions/libipt_TCPCONG.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- patchlets/TCPCONG/iptables/extensions/libipt_TCPCONG.c	(revision 0)
+++ patchlets/TCPCONG/iptables/extensions/libipt_TCPCONG.c	(revision 0)
@@ -0,0 +1,279 @@
+/* libipt_TCPCONG.c -- set the TCP congestion control algorithm.
+ *
+ * $Id$
+ *
+ * Differing TCP congestion control algorithms are better than others
+ * in particular circumstances. Westwood TCP is designed for 802.11
+ * wireless LANs with their lossy transmission links; Hamilton TCP,
+ * BIC and CUBIC are designed for fat long pipes; Vegas uses router
+ * queueing delay rather than packet loss as a measure of available
+ * bandwidth. This target lets you choose the TCP congestion control
+ * algorithm that best suits the task at hand without needing to
+ * recompile the application to call setsockopt().
+ *
+ * Copyright =C2=A9 Glen David Turner of Semaphore, South Australia, 200=
6.
+ * <http://www.aarnet.edu.au/~gdt/>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <syslog.h>
+#include <getopt.h>
+#include <iptables.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_TCPCONG.h>
+
+
+/*
+ * Help for user.
+ */
+static char *help_text[] =3D {
+"TCPCONG options:",
+"    --tcpcong-algorithm s",
+"        Set the TCP congestion control algorithm for this connection to=
 the",
+"        algorithm named \"s\". The effect is the same as",
+"            setsockopt(connection, getprotobyname(\"tcp\")->p_proto,",
+"                       TCP_CONGESTION, \"s\");",
+"        The available algorithms depend upon your kernel version and it=
s",
+"        configuration. Example algorithm names are: bic, reno, cubic,",
+"        highspeed, htcp, hybla, scalable, vegas, westwood.",
+"    --tcpcong-algorithm-default",
+"        Set the  TCP congestion control algorithm to the default algori=
thm.",
+"        The default TCP congestion control algorithm is the value of th=
e",
+"        kernel sysctl parameter",
+"            net.ipv4.tcp_congestion_control",
+"        If that sysctl parameter is missing then the default algorithm"=
,
+"        is established by the kernel's build configuration. This option=
",
+"        is identical to --tcpcong-algorithm \"\" but a distinct option =
is",
+"        provided to avoid the complexities of shell quoting.",
+
+	NULL /* End of list sentinel. */
+};
+
+static void
+help(void)
+{
+	char **p;
+	for (p =3D help_text; *p !=3D NULL; p++) {
+		puts(*p);
+	}
+}
+
+
+/*
+ * Options for this target.
+ *
+ * See "man getopt_long" for an explanation of this structure.
+ */
+static struct option extra_opts[] =3D
+{
+	{ "tcpcong-algorithm", 1, 0, '1' },
+	{ "tcpcong-algorithm-default", 0, 0, '2' },
+	{ 0 }
+};
+
+
+/*
+ * Initialise data for target.
+ *
+ * Inputs:
+ *  target -- information for this target instance.
+ *  nfcache -- ??
+ */
+static void
+init(struct ipt_entry_target *target,
+     unsigned int *nfcache)
+{
+}
+
+
+/*
+ * Parse a command.
+ *
+ * Inputs:
+ *  option -- the 'val' from opts[] above, could possibly be something w=
e
+ *   cannot recognise in which case return(0).  If we do recognise it
+ *   then return(1).
+ *  argv -- in case we want to take parameters from the command line,
+ *  invert -- set if the option parameter had '!' in front of it.
+ *  flags -- Starts of zero for a fresh target, gets fed into
+ *   final_check(). Same as (*target)->tflags.
+ *  entry  --  ??
+ *  target -- the record that holds data about this target, most
+ *   importantly, our private data is (*target)->data (this has already
+ *   been malloced).
+ * Returns:
+ *  1 if option matches, 0 otherwise.
+ * Side effects:
+ *  Fill in target->data with parsed options.
+ */
+
+/* Treat 'flags' as a bit vector which indicates which options have been
+ * parsed. This macro assigns option numbers to bit locations.
+ */
+#define OPTION_PARSED(OPTION) (1 << ((OPTION)-'1'))
+
+static int
+parse(int option,
+      char **argv,
+      int invert,
+      unsigned int *flags,
+      const struct ipt_entry *entry,
+      struct ipt_entry_target **target)
+{
+	struct ipt_TCPCONG *tcpcong =3D (struct ipt_TCPCONG *)(*target)->data;
+
+        switch (option) {
+        case '1':
+                if (invert) {
+                        exit_error(PARAMETER_PROBLEM,
+                                   "TCPCONG: \"! --tcpcong-algorithm\" n=
ot "
+                                   "supported");
+                }
+                if (*flags & OPTION_PARSED('1')) {
+                        exit_error(PARAMETER_PROBLEM,
+                                   "TCPCONG: Cannot have more than one "
+                                   "\"--tcpcong-algorithm\"");
+                }
+                *flags |=3D OPTION_PARSED('1');
+                strncpy(tcpcong->algorithm_name,
+                        optarg,
+                        TCP_CA_NAME_MAX);
+                tcpcong->algorithm_name[TCP_CA_NAME_MAX-1] =3D '\0';
+                break;
+        case '2':
+                if (invert) {
+                        exit_error(PARAMETER_PROBLEM,
+                                   "TCPCONG: \"! "
+                                   "--tcpconf-algorithm-default\" not "
+                                   "supported");
+                }
+                *flags |=3D OPTION_PARSED('2');
+                tcpcong->algorithm_name[0] =3D '\0';
+                break;
+        default:
+                return 0;
+        }
+	return 1;
+}
+
+
+/*
+ * Check for incompatible combinations of options.
+ *
+ * Inputs:
+ *  flags -- (*target)->tflags from parse().
+ * Side effects:
+ *  exit_error(PARAMETER_PROBLEM, ...) called if incompatible combinatio=
ns
+ *   exist.
+ */
+static void
+final_check(unsigned int flags)
+{
+        if (!flags) {
+                exit_error(PARAMETER_PROBLEM,
+                           "TCPCONG: At least one parameter is required"=
);
+        }
+        if ((flags & OPTION_PARSED('1')) && (flags & OPTION_PARSED('2'))=
) {
+                exit_error(PARAMETER_PROBLEM,
+                           "TCPCONG: Both --tcpcong-algorithm and "
+                           "--tcpcong-algorithm-default cannot be reques=
ted.");
+        }
+}
+
+
+/*
+ * Describe the target for "iptables --list", a human-readable listing o=
f
+ * rules.
+ *
+ * Inputs:
+ *  ip -- general IP Tables information,
+ *  target -- information for this instance of the target.
+ *  numeric -- ??
+ * Side effects:
+ *  print target to stdout
+ */
+static void
+print(const struct ipt_ip *ip,
+      const struct ipt_entry_target *target,
+      int numeric)
+{
+	const struct ipt_TCPCONG *tcpcong =3D
+                (const struct ipt_TCPCONG *)target->data;
+
+	printf("algorithm:%s",
+               tcpcong->algorithm_name[0]
+                ? tcpcong->algorithm_name
+                : "default");
+}
+
+
+/*
+ * Describe target for "iptables-save", a machine-readable listing of ru=
les.
+ *
+ * Inputs:
+ *  ip -- general IP Tables information,
+ *  target -- information for this instance of the target.
+ * Side effects:
+ *  print target to stdout
+ */
+static void
+save(const struct ipt_ip *ip,
+     const struct ipt_entry_target *target )
+{
+	const struct ipt_TCPCONG *tcpcong =3D
+                (const struct ipt_TCPCONG *)target->data;
+
+        if (tcpcong->algorithm_name[0]) {
+                printf("TCPCONG --tcpcong-algorithm %s",
+                       tcpcong->algorithm_name);
+        } else {
+                printf("TCPCONG --tcpcong-algorithm-default");
+        }
+}
+
+
+/*
+ * The registration record for this target.
+ */
+static struct iptables_target tcpcong_target =3D {
+        .next =3D NULL,
+        .name =3D "TCPCONG",
+        .version =3D IPTABLES_VERSION,
+        .size =3D IPT_ALIGN(sizeof(struct ipt_TCPCONG)),
+        .userspacesize =3D IPT_ALIGN(sizeof(struct ipt_TCPCONG)),
+        .help =3D &help,
+        .init =3D &init,
+        .parse =3D &parse,
+        .final_check =3D &final_check,
+        .print =3D &print,
+        .save =3D &save,
+        .extra_opts =3D extra_opts
+};
+
+
+/*
+ * This registers the target into the list of available targets so
+ * that the options become available.
+ */
+void
+_init(void)
+{
+        register_target(&tcpcong_target);
+}

Property changes on: patchlets/TCPCONG/iptables/extensions/libipt_TCPCONG=
.c
___________________________________________________________________
Name: svn:keywords
    + Id
Name: svn:eol-style
    + native

Index: patchlets/TCPCONG/iptables/extensions/.TCPCONG-test
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- patchlets/TCPCONG/iptables/extensions/.TCPCONG-test	(revision 0)
+++ patchlets/TCPCONG/iptables/extensions/.TCPCONG-test	(revision 0)
@@ -0,0 +1,2 @@
+#!/bin/sh
+[ -f $KERNEL_DIR/net/ipv4/netfilter/ipt_TCPCONG.c ] && echo TCPCONG

Property changes on: patchlets/TCPCONG/iptables/extensions/.TCPCONG-test
___________________________________________________________________
Name: svn:executable
    + *

Index: patchlets/TCPCONG/iptables/extensions/libipt_TCPCONG.man
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- patchlets/TCPCONG/iptables/extensions/libipt_TCPCONG.man	(revision 0)
+++ patchlets/TCPCONG/iptables/extensions/libipt_TCPCONG.man	(revision 0)
@@ -0,0 +1,123 @@
+.\" Manual page component for Netfilter TCPCONG target.
+.\"
+.\" @(#) $Id$
+.\"
+.\" Copyright =C2=A9 Glen David Turner of Semaphore, South Australia, 20=
06.
+.\" <http://www.aarnet.edu.au/~gdt/>
+.\"
+.\" This program is free software; you can redistribute it and/or
+.\" modify it under the terms of the GNU General Public License as
+.\" published by the Free Software Foundation; either version 2 of the
+.\" License, or (at your option) any later version.
+
+This module sets the TCP congestion control algorithm.
+.TP
+.BI "--tcpcong-algorithm " "algorithm"
+Set the TCP congestion control algorithm to the algorithm named
+.I algorithm
+.TP
+.BI "--tcpcong-algorithm-default"
+Set the TCP congestion control algorithm to the default algorithm. The
+default algorithm is determined by the value of the sysctl variable
+\fInet.ipv4.tcp_congestion_control\fP.  If that variable is not set
+then the default value is determined by the kernel build
+options. There is no means of getting this algorithm name from a
+running kernel. This option is the same as --tcpcong-algorithm "" but
+is provided to avoid the nightmare of quoting an empty string from the
+shell.
+.P
+This target requires a Linux kernel 2.6.13 or later built with the
+option CONFIG_TCP_CONG_ADVANCED enabled. The available algorithms
+depend upon the algorithms selected when the kernel was built. There
+is no way to get a list of available algorithms from a running
+kernel. Algorithms available in Linux kernel 2.6.17 are: bic, reno,
+cubic, highspeed, htcp, hybla, scalable, vegas, westwood.
+.P
+Some TCP congestion control algorithms are:
+.TP
+.I bic
+BIC-TCP (Rhee, NCSU). Designed for long fat pipes. The default in
+recent Linux kernels.
+.TP
+.I cubic
+CUBIC-TCP (Rhee, NCSU). Designed for long fat pipes, designed to
+overcome issues with BIC-TCP.
+.TP
+.I highspeed
+HighSpeed TCP (Floyd, ICIR). The original modification for long fat
+pipes.
+.TP
+.I htcp
+Hamilton TCP (Leith, Hamilton Institute). Designed for long fat
+pipes. Shares capacity with other connections well.
+.TP
+.I hybla
+Hybla TCP. Designed for satellite links. These have bandwith under
+100Mbps, round-trip times of 500ms or more, and high error rates.
+.TP
+.I reno
+Reno BSD (Jacobson, Packet Design). The traditional TCP congestion
+avoidance algorithm. Used by older TCP/IP implementations based on
+BSD4.3.
+.TP
+.I scalable
+Scalable TCP. (Kelly, Cambridge). A variant of Highspeed TCP which
+works well on all bandwidths.
+.TP
+.I vegas
+Vegas BSD (Brakmo & Peterson, Arizona). Uses queuing delay rather than
+packet loss as the measure of network congestion. Used by BSD4.4.
+.TP
+.I westwood
+Westwood TCP (Mascolo, Politecnico di Bari). Designed for wireless
+networks. These have high error rates.
+.TP
+EXAMPLE
+Select the Westwood+ TCP congestion control algorithm for
+traffic using the wireless interface eth1.
+.P
+iptables --table filter --append OUTPUT --out-interface eth1 --protocol =
tcp --tcp-flags SYN,FIN,RST SYN --jump TCPCONG --tcpcong-algoriithm westw=
ood
+.P
+Note that a match of "--protocol tcp" is required when
+--tcpcong-algorithm is used as setting the TCP congestion control
+algorithm for a non-TCP connections makes little sense.
+.P
+Using the OUTPUT chain is more reliable than using the INPUT chain.  A
+SYN flows both ways during a TCP connection establishment so either
+chain can be used in theory, but in practice not all incoming packets
+will have a socket assigned to them at the time when Netfilter
+examines an INPUT packet. A socket records the details of the
+connection, so a socket must have been allocated to the packet to
+alter a detail like the TCP congestion control algorithm. Using the
+FORWARD chain makes no sense at all.
+.P
+The TCP congestion control algorithm of the transmitter of the data
+controls most of the aspects of congestion control. In the above
+example the wireless LAN device would usually only notice an
+improvement when uploading data.
+.TP EXAMPLE
+Select the Hamilton TCP congestion control algorithm for connections
+to the service on port 80 on the machine at 10.1.1.1.
+.P
+iptables --table filter --append OUTPUT --destination 10.1.1.1
+--protocol tcp --destination-port 80 --jump TCPCONG
+--tcpcong-algorithm htcp
+.P
+If the TCP buffer size is inadequate then altering the TCP congestion
+control algorithm will generally not improve performance. For maximum
+performance with long-lived connections across low loss media the TCP
+buffer size must meet or exceed the bandwidth-delay product of the
+connection's path through the network. Often the operating system's
+default TCP buffer size is far too small.
+.P
+An application can use setsockopt(..., SOL_TCP, TCP_CONGESTION,
+"alogorithm", strlen("algorithm")) to achieve a result identical to
+this target. This target is useful when modifying the application is
+not justified.
+.P
+To alter the congestion control algorithm for all connections modify
+the sysctl variable \fInet.ipv4.tcp_congestion_control\fP rather than
+use this module.
+.TP
+SEE ALSO
+http://www.aarnet.edu.au/~gdt/patch/tcpcong/
Index: patchlets/TCPCONG/help
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- patchlets/TCPCONG/help	(revision 0)
+++ patchlets/TCPCONG/help	(revision 0)
@@ -0,0 +1,3 @@
+
+This target sets the TCP congestion control algorithm.
+
Index: patchlets/TCPCONG/info
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- patchlets/TCPCONG/info	(revision 0)
+++ patchlets/TCPCONG/info	(revision 0)
@@ -0,0 +1,10 @@
+Title:		Sets TCP congestion control algorithm
+Author:		Glen Turner, <glen.turner@aarnet.edu.au>
+Status:		Beta
+Repository:	base
+Requires:	linux-2.6 >=3D 2.6.13
+Requires:	linux-2.6.patch >=3D 2.6.13
+Recompile:	kernel
+Recompile:	iptables
+
+Target to set TCP congestion control algorithm.
Index: sources.list
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- sources.list	(revision 6678)
+++ sources.list	(working copy)
@@ -9,3 +9,6 @@

  # ipp2p, time, IPMARK and connlimit maintained by Krzysztof Oledzki <ol=
e@ans.pl>
  http://people.netfilter.org/ole/pom/
+
+# TCPCONG maintained by Glen Turner <glen.turner@aarnet.edu.au>
+http://www.aarnet.edu.au/~gdt/patch/tcpcong/
