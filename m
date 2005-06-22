From: Bryan Cardillo <dillo@seas.upenn.edu>
Subject: [PATCH] add expire to patch-o-matic
Date: Wed, 22 Jun 2005 13:09:18 -0400
Message-ID: <20050622170918.GB3196@rover.pcbi.upenn.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="3V7upXqbjpZ4EhLz"
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


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

        Attached is a patch to add automatically expiring rules
        to patch-o-matic.  I've fixed a few things from the previous
        version, including restoring the counters once a rule is
        deleted.  Thoughts, comments?

 help                                                 |    8 
 info                                                 |    6 
 iptables/extensions/.expire-test                     |    3 
 iptables/extensions/.expire-test6                    |    3 
 iptables/extensions/libip6t_expire.c                 |  170 +++++
 iptables/extensions/libip6t_expire.man               |    5 
 iptables/extensions/libipt_expire.c                  |  170 +++++
 iptables/extensions/libipt_expire.man                |    5 
 linux-2.6/include/linux/netfilter_ipv4/ipt_expire.h  |   32 +
 linux-2.6/include/linux/netfilter_ipv6/ip6t_expire.h |   32 +
 linux-2.6/net/ipv4/netfilter/Kconfig.ladd            |   10 
 linux-2.6/net/ipv4/netfilter/Makefile.ladd           |    2 
 linux-2.6/net/ipv4/netfilter/ipt_expire.c            |  563 ++++++++++++++++++
 linux-2.6/net/ipv6/netfilter/Kconfig.ladd            |   10 
 linux-2.6/net/ipv6/netfilter/Makefile.ladd           |    2 
 linux-2.6/net/ipv6/netfilter/ip6t_expire.c           |  566 +++++++++++++++++++
 16 files changed, 1587 insertions(+)

        Cheers,
        Bryan Cardillo
        Penn Bioinformatics Core
        University of Pennsylvania
        dillo@seas.upenn.edu


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=iso-8859-1
Content-Description: expire.patch
Content-Disposition: attachment; filename="expire.patch"
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by rover.pcbi.upenn.edu id
	j5MH9IS2018086

Index: ./expire/info
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
RCS file: ./expire/info
diff -N ./expire/info
--- /dev/null	1 Jan 1970 00:00:00 -0000
+++ ./expire/info	22 Jun 2005 13:17:50 -0000	1.1
@@ -0,0 +1,6 @@
+Title: automatically expiring iptables rules
+Author: Bryan Cardillo <dillo@seas.upenn.edu>
+Status: testing
+Repository: base
+Recompile: kernel
+Recompile: iptables
Index: ./expire/help
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
RCS file: ./expire/help
diff -N ./expire/help
--- /dev/null	1 Jan 1970 00:00:00 -0000
+++ ./expire/help	22 Jun 2005 13:17:50 -0000	1.1
@@ -0,0 +1,8 @@
+This option adds an expiring match, which allows you to add rules to
+your iptables ruleset which will later be removed automatically.
+
+Usage:
+	-m expire --expiration [time]
+
+Example:
+	iptables ... -m expire --expiration +30 ...
Index: ./expire/iptables/extensions/.expire-test
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
RCS file: ./expire/iptables/extensions/.expire-test
diff -N ./expire/iptables/extensions/.expire-test
--- /dev/null	1 Jan 1970 00:00:00 -0000
+++ ./expire/iptables/extensions/.expire-test	22 Jun 2005 13:17:53 -0000	=
1.1
@@ -0,0 +1,3 @@
+#!/bin/sh
+
+[ -f $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_expire.h ] && echo exp=
ire
Index: ./expire/iptables/extensions/.expire-test6
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
RCS file: ./expire/iptables/extensions/.expire-test6
diff -N ./expire/iptables/extensions/.expire-test6
--- /dev/null	1 Jan 1970 00:00:00 -0000
+++ ./expire/iptables/extensions/.expire-test6	22 Jun 2005 13:17:53 -0000=
	1.1
@@ -0,0 +1,3 @@
+#!/bin/sh
+
+[ -f $KERNEL_DIR/include/linux/netfilter_ipv6/ip6t_expire.h ] && echo ex=
pire
Index: ./expire/iptables/extensions/libip6t_expire.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
RCS file: ./expire/iptables/extensions/libip6t_expire.c
diff -N ./expire/iptables/extensions/libip6t_expire.c
--- /dev/null	1 Jan 1970 00:00:00 -0000
+++ ./expire/iptables/extensions/libip6t_expire.c	22 Jun 2005 13:17:53 -0=
000	1.1
@@ -0,0 +1,170 @@
+/* This library manipulates expiring firewall rules
+ *
+ * This library is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this library; if not, write to:
+ *      The Free Software Foundation, Inc.
+ *      59 Temple Place, Suite 330
+ *      Boston, MA  02111-1307  USA
+ *
+ * Copyright =A9 2005 Bryan Cardillo <dillo@seas.upenn.edu>
+ */
+
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <time.h>
+
+#include <ip6tables.h>
+#include <linux/netfilter_ipv6/ip6t_expire.h>
+
+static void ip6t_exp_help(void);
+static int ip6t_exp_parse(int, char **, int, unsigned int *,
+		const struct ip6t_entry *, unsigned int *,
+		struct ip6t_entry_match **);
+static void ip6t_exp_final_check(unsigned int);
+static void ip6t_exp_print(const struct ip6t_ip *,
+		const struct ip6t_entry_match *, int);
+static void ip6t_exp_save(const struct ip6t_ip *, const struct ip6t_entr=
y_match *);
+
+/**
+ * options
+ */
+static struct option ip6t_exp_opts[] =3D {
+	{ "expiration", 1, 0, 'e' },
+	{ 0 }
+};
+
+/**
+ * match
+ */
+static struct iptables_match ip6t_expire_match =3D {
+	.next =3D NULL,
+	.name =3D "expire",
+	.version =3D IPTABLES_VERSION,
+	.size =3D IP6T_ALIGN(sizeof(struct ip6t_exp_info)),
+	.userspacesize =3D IP6T_ALIGN(sizeof(struct ip6t_exp_info)),
+	.help =3D &ip6t_exp_help,
+	.parse =3D &ip6t_exp_parse,
+	.final_check =3D &ip6t_exp_final_check,
+	.print =3D &ip6t_exp_print,
+	.save =3D &ip6t_exp_save,
+	.extra_opts =3D ip6t_exp_opts
+};
+
+/**
+ * shared library initialization
+ * @see register_match()
+ */
+void
+_init(void)
+{
+	register_match(&ip6t_expire_match);
+}
+
+/**
+ * print usage information
+ */
+static void
+ip6t_exp_help(void)
+{
+    printf("EXPIRE match options\n"
+           "  --expiration [+]TIME\t\t"
+	   "rule expires at [in] TIME\n\n");
+}
+
+/**
+ * parse module specific options
+ * @param c the short option character
+ * @param argv the arguments array
+ * @param invert is this an inverted argument
+ * @param flags module specific flags
+ * @param entry the entry
+ * @param nfcache netfilter cache flags
+ * @param match the match
+ * @return zero if an option was found, non-zero otherwise
+ */
+static int
+ip6t_exp_parse(int c, char **argv, int invert, unsigned int *flags,
+	const struct ip6t_entry *entry, unsigned int *nfcache,
+	struct ip6t_entry_match **match)
+{
+	char *arg;
+	struct ip6t_exp_info *info;
+=09
+	info =3D (struct ip6t_exp_info *)(*match)->data;
+	info->expiration =3D 0;
+	switch (c) {
+		case 'e':
+			arg =3D argv[optind-1];
+			check_inverse(arg, &invert, &optind, 0);
+			if (invert)
+				exit_error(PARAMETER_PROBLEM,
+					"--expiration cannot be inverted");
+                        if (*arg =3D=3D '+')
+				arg++;
+			if (string_to_number_l(
+					arg, 1, 0, &info->expiration) < 0)
+				exit_error(PARAMETER_PROBLEM,
+					"invalid expiration time");
+			*flags =3D 1;
+			if (*argv[optind-1] =3D=3D '+')
+				info->expiration +=3D time(NULL);
+			break;
+		default:
+			return 0;
+	}
+	return 1;
+}
+
+/**
+ * ensures an expiration was specified
+ * @param flags module specific flags from options parsing
+ */
+static void
+ip6t_exp_final_check(unsigned int flags)
+{
+	if (flags !=3D 1)
+		exit_error(PARAMETER_PROBLEM,
+			"you must specify an expiration time (--expiration)");
+}
+
+/**
+ * print information about an expiring match
+ * in a format suitable for viewing
+ * @param ip the address information
+ * @param match the match
+ * @param numeric the verbose level (?)
+ */
+static void
+ip6t_exp_print(const struct ip6t_ip *ip,
+	const struct ip6t_entry_match *match, int numeric)
+{
+	struct ip6t_exp_info *info;
+	info =3D (struct ip6t_exp_info *)match->data;
+	printf("expires in %lds ", info->expiration - time(NULL));
+}
+
+/**
+ * print information about an expiring match
+ * in a format suitable for reconstructing the match
+ * @param ip the address information
+ * @param match the match
+ */
+static void
+ip6t_exp_save(const struct ip6t_ip *ip, const struct ip6t_entry_match *m=
atch)
+{
+	struct ip6t_exp_info *info;
+	info =3D (struct ip6t_exp_info *)match->data;
+	printf("-m expire --expiration %ld ", info->expiration);
+}
Index: ./expire/iptables/extensions/libip6t_expire.man
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
RCS file: ./expire/iptables/extensions/libip6t_expire.man
diff -N ./expire/iptables/extensions/libip6t_expire.man
--- /dev/null	1 Jan 1970 00:00:00 -0000
+++ ./expire/iptables/extensions/libip6t_expire.man	22 Jun 2005 13:17:53 =
-0000	1.1
@@ -0,0 +1,5 @@
+This module matches until its expiration time.
+.TP
+.BI "--expiration " "[\fItime\fP]"
+Match against the other rule criteria until the expiration time.  After
+the expiration time, the entire rule will be removed from the table.
Index: ./expire/iptables/extensions/libipt_expire.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
RCS file: ./expire/iptables/extensions/libipt_expire.c
diff -N ./expire/iptables/extensions/libipt_expire.c
--- /dev/null	1 Jan 1970 00:00:00 -0000
+++ ./expire/iptables/extensions/libipt_expire.c	22 Jun 2005 13:17:53 -00=
00	1.1
@@ -0,0 +1,170 @@
+/* This library manipulates expiring firewall rules
+ *
+ * This library is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this library; if not, write to:
+ *      The Free Software Foundation, Inc.
+ *      59 Temple Place, Suite 330
+ *      Boston, MA  02111-1307  USA
+ *
+ * Copyright =A9 2005 Bryan Cardillo <dillo@seas.upenn.edu>
+ */
+
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <time.h>
+
+#include <iptables.h>
+#include <linux/netfilter_ipv4/ipt_expire.h>
+
+static void ipt_exp_help(void);
+static int ipt_exp_parse(int, char **, int, unsigned int *,
+		const struct ipt_entry *, unsigned int *,
+		struct ipt_entry_match **);
+static void ipt_exp_final_check(unsigned int);
+static void ipt_exp_print(const struct ipt_ip *,
+		const struct ipt_entry_match *, int);
+static void ipt_exp_save(const struct ipt_ip *, const struct ipt_entry_m=
atch *);
+
+/**
+ * options
+ */
+static struct option ipt_exp_opts[] =3D {
+	{ "expiration", 1, 0, 'e' },
+	{ 0 }
+};
+
+/**
+ * match
+ */
+static struct iptables_match ipt_expire_match =3D {
+	.next =3D NULL,
+	.name =3D "expire",
+	.version =3D IPTABLES_VERSION,
+	.size =3D IPT_ALIGN(sizeof(struct ipt_exp_info)),
+	.userspacesize =3D IPT_ALIGN(sizeof(struct ipt_exp_info)),
+	.help =3D &ipt_exp_help,
+	.parse =3D &ipt_exp_parse,
+	.final_check =3D &ipt_exp_final_check,
+	.print =3D &ipt_exp_print,
+	.save =3D &ipt_exp_save,
+	.extra_opts =3D ipt_exp_opts
+};
+
+/**
+ * shared library initialization
+ * @see register_match()
+ */
+void
+_init(void)
+{
+	register_match(&ipt_expire_match);
+}
+
+/**
+ * print usage information
+ */
+static void
+ipt_exp_help(void)
+{
+    printf("EXPIRE match options\n"
+           "  --expiration [+]TIME\t\t"
+	   "rule expires at [in] TIME\n\n");
+}
+
+/**
+ * parse module specific options
+ * @param c the short option character
+ * @param argv the arguments array
+ * @param invert is this an inverted argument
+ * @param flags module specific flags
+ * @param entry the entry
+ * @param nfcache netfilter cache flags
+ * @param match the match
+ * @return zero if an option was found, non-zero otherwise
+ */
+static int
+ipt_exp_parse(int c, char **argv, int invert, unsigned int *flags,
+	const struct ipt_entry *entry, unsigned int *nfcache,
+	struct ipt_entry_match **match)
+{
+	char *arg;
+	struct ipt_exp_info *info;
+=09
+	info =3D (struct ipt_exp_info *)(*match)->data;
+	info->expiration =3D 0;
+	switch (c) {
+		case 'e':
+			arg =3D argv[optind-1];
+			check_inverse(arg, &invert, &optind, 0);
+			if (invert)
+				exit_error(PARAMETER_PROBLEM,
+					"--expiration cannot be inverted");
+                        if (*arg =3D=3D '+')
+				arg++;
+			if (string_to_number_l(
+					arg, 1, 0, &info->expiration) < 0)
+				exit_error(PARAMETER_PROBLEM,
+					"invalid expiration time");
+			*flags =3D 1;
+			if (*argv[optind-1] =3D=3D '+')
+				info->expiration +=3D time(NULL);
+			break;
+		default:
+			return 0;
+	}
+	return 1;
+}
+
+/**
+ * ensures an expiration was specified
+ * @param flags module specific flags from options parsing
+ */
+static void
+ipt_exp_final_check(unsigned int flags)
+{
+	if (flags !=3D 1)
+		exit_error(PARAMETER_PROBLEM,
+			"you must specify an expiration time (--expiration)");
+}
+
+/**
+ * print information about an expiring match
+ * in a format suitable for viewing
+ * @param ip the address information
+ * @param match the match
+ * @param numeric the verbose level (?)
+ */
+static void
+ipt_exp_print(const struct ipt_ip *ip,
+	const struct ipt_entry_match *match, int numeric)
+{
+	struct ipt_exp_info *info;
+	info =3D (struct ipt_exp_info *)match->data;
+	printf("expires in %lds ", info->expiration - time(NULL));
+}
+
+/**
+ * print information about an expiring match
+ * in a format suitable for reconstructing the match
+ * @param ip the address information
+ * @param match the match
+ */
+static void
+ipt_exp_save(const struct ipt_ip *ip, const struct ipt_entry_match *matc=
h)
+{
+	struct ipt_exp_info *info;
+	info =3D (struct ipt_exp_info *)match->data;
+	printf("-m expire --expiration %ld ", info->expiration);
+}
Index: ./expire/iptables/extensions/libipt_expire.man
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
RCS file: ./expire/iptables/extensions/libipt_expire.man
diff -N ./expire/iptables/extensions/libipt_expire.man
--- /dev/null	1 Jan 1970 00:00:00 -0000
+++ ./expire/iptables/extensions/libipt_expire.man	22 Jun 2005 13:17:53 -=
0000	1.1
@@ -0,0 +1,5 @@
+This module matches until its expiration time.
+.TP
+.BI "--expiration " "[\fItime\fP]"
+Match against the other rule criteria until the expiration time.  After
+the expiration time, the entire rule will be removed from the table.
Index: ./expire/linux-2.6/include/linux/netfilter_ipv4/ipt_expire.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
RCS file: ./expire/linux-2.6/include/linux/netfilter_ipv4/ipt_expire.h
diff -N ./expire/linux-2.6/include/linux/netfilter_ipv4/ipt_expire.h
--- /dev/null	1 Jan 1970 00:00:00 -0000
+++ ./expire/linux-2.6/include/linux/netfilter_ipv4/ipt_expire.h	22 Jun 2=
005 13:17:55 -0000	1.1
@@ -0,0 +1,32 @@
+/* This module matches until it expires, at which point the entire
+ * rule is deleted
+ *
+ * This module is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This module is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this module; if not, write to:
+ *      The Free Software Foundation, Inc.
+ *      59 Temple Place, Suite 330
+ *      Boston, MA  02111-1307  USA
+ *
+ * Copyright =A9 2005 Bryan Cardillo <dillo@seas.upenn.edu>
+ */
+
+#ifndef __IPT_EXPIRE_H
+#define __IPT_EXPIRE_H
+
+#include <linux/types.h>
+
+struct ipt_exp_info {
+	time_t expiration;
+};
+
+#endif
Index: ./expire/linux-2.6/include/linux/netfilter_ipv6/ip6t_expire.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
RCS file: ./expire/linux-2.6/include/linux/netfilter_ipv6/ip6t_expire.h
diff -N ./expire/linux-2.6/include/linux/netfilter_ipv6/ip6t_expire.h
--- /dev/null	1 Jan 1970 00:00:00 -0000
+++ ./expire/linux-2.6/include/linux/netfilter_ipv6/ip6t_expire.h	22 Jun =
2005 13:17:56 -0000	1.1
@@ -0,0 +1,32 @@
+/* This module matches until it expires, at which point the entire
+ * rule is deleted
+ *
+ * This module is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This module is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this module; if not, write to:
+ *      The Free Software Foundation, Inc.
+ *      59 Temple Place, Suite 330
+ *      Boston, MA  02111-1307  USA
+ *
+ * Copyright =A9 2005 Bryan Cardillo <dillo@seas.upenn.edu>
+ */
+
+#ifndef __IP6T_EXPIRE_H
+#define __IP6T_EXPIRE_H
+
+#include <linux/types.h>
+
+struct ip6t_exp_info {
+	time_t expiration;
+};
+
+#endif
Index: ./expire/linux-2.6/net/ipv4/netfilter/Kconfig.ladd
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
RCS file: ./expire/linux-2.6/net/ipv4/netfilter/Kconfig.ladd
diff -N ./expire/linux-2.6/net/ipv4/netfilter/Kconfig.ladd
--- /dev/null	1 Jan 1970 00:00:00 -0000
+++ ./expire/linux-2.6/net/ipv4/netfilter/Kconfig.ladd	22 Jun 2005 13:18:=
00 -0000	1.1
@@ -0,0 +1,10 @@
+config IP_NF_MATCH_EXPIRE
+	tristate  'expiring match support'
+	depends on IP_NF_IPTABLES
+	help
+	  This option adds an expiring match, which allows you to add
+	  rules to your iptables ruleset which will later be removed
+	  automatically.
+
+	  If you want to compile it as a module, say M here and read
+	  Documentation/modules.txt.  If unsure, say `N'.
Index: ./expire/linux-2.6/net/ipv4/netfilter/Makefile.ladd
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
RCS file: ./expire/linux-2.6/net/ipv4/netfilter/Makefile.ladd
diff -N ./expire/linux-2.6/net/ipv4/netfilter/Makefile.ladd
--- /dev/null	1 Jan 1970 00:00:00 -0000
+++ ./expire/linux-2.6/net/ipv4/netfilter/Makefile.ladd	22 Jun 2005 13:18=
:00 -0000	1.1
@@ -0,0 +1,2 @@
+# matches
+obj-$(CONFIG_IP_NF_MATCH_EXPIRE) +=3D ipt_expire.o
Index: ./expire/linux-2.6/net/ipv4/netfilter/ipt_expire.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
RCS file: ./expire/linux-2.6/net/ipv4/netfilter/ipt_expire.c
diff -N ./expire/linux-2.6/net/ipv4/netfilter/ipt_expire.c
--- /dev/null	1 Jan 1970 00:00:00 -0000
+++ ./expire/linux-2.6/net/ipv4/netfilter/ipt_expire.c	22 Jun 2005 13:18:=
00 -0000	1.1
@@ -0,0 +1,563 @@
+/* This module matches until it expires, at which point the entire
+ * rule is deleted
+ *
+ * This module is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This module is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this module; if not, write to:
+ *      The Free Software Foundation, Inc.
+ *      59 Temple Place, Suite 330
+ *      Boston, MA  02111-1307  USA
+ *
+ * Copyright =A9 2005 Bryan Cardillo <dillo@seas.upenn.edu>
+ */
+
+#include <linux/config.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/workqueue.h>
+#include <linux/vmalloc.h>
+#include <linux/time.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_expire.h>
+
+#if CONFIG_NETFILTER_DEBUG
+#define dprintk(format, args...) \
+	printk("ipt_expire[%s]: " format "\n", __FUNCTION__, ## args)
+#else
+#define dprintk(format, args...)
+#endif
+
+MODULE_AUTHOR("Bryan Cardillo <dillo@seas.upenn.edu>");
+MODULE_DESCRIPTION("an iptables expiring match module");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("1.1");
+static int __init ipt_exp_init(void);
+static void __exit ipt_exp_exit(void);
+module_init(ipt_exp_init);
+module_exit(ipt_exp_exit);
+
+static int ipt_exp_match(const struct sk_buff *,
+		const struct net_device *, const struct net_device *,
+		const void *, int, int *);
+static int ipt_exp_checkentry(const char *, const struct ipt_ip *,
+		void *, unsigned int, unsigned int);
+static int ipt_exp_add_table(const char *);
+static void ipt_exp_remove_table(const char *);
+static void ipt_exp_schedule_expiration(time_t);
+static void ipt_exp_work_fn(void *);
+static int ipt_exp_get_info(const char *, struct ipt_getinfo *);
+static int ipt_exp_get_entries(struct ipt_getinfo *, struct ipt_get_entr=
ies *);
+static int ipt_exp_get_active(struct ipt_getinfo *,
+		struct ipt_get_entries *, struct ipt_replace *);
+static int ipt_exp_copy_active(struct ipt_entry *, struct ipt_replace *)=
;
+static int ipt_exp_is_expired(struct ipt_entry_match *);
+static int ipt_exp_replace_expired(struct ipt_replace *);
+static int ipt_exp_get_counters(struct ipt_get_entries *,
+		struct ipt_replace *, struct ipt_counters_info *);
+static int ipt_exp_copy_counter(struct ipt_entry *, struct ipt_replace *=
,
+		struct ipt_counters_info *, int *);
+static int ipt_exp_restore_counters(struct ipt_counters_info *);
+
+/**
+ * struct for list of tables
+ */
+struct ipt_exp_table {
+	/**
+	 * the table name
+	 */
+	char name[IPT_TABLE_MAXNAMELEN];
+	/**
+	 * a list_head structure enabling list inclusion
+	 */
+	struct list_head list;
+};
+
+/**
+ * work_struct for scheduling the deletion of expired rules
+ */
+static DECLARE_WORK(ipt_exp_work, &ipt_exp_work_fn, NULL);
+
+/**
+ * iptables match
+ */
+static struct ipt_match ipt_expire_match =3D {
+	.name		=3D "expire",
+	.match		=3D &ipt_exp_match,
+	.checkentry	=3D &ipt_exp_checkentry,
+	.me		=3D THIS_MODULE
+};
+
+/**
+ * the list of tables contained expiring entries
+ */
+static spinlock_t ipt_exp_tables_lock =3D SPIN_LOCK_UNLOCKED;
+static LIST_HEAD(ipt_exp_tables);
+
+/**
+ * initialize module and register iptables match
+ * @see module_init()
+ * @see ipt_register_match()
+ */
+static int __init
+ipt_exp_init(void)
+{
+	dprintk("initializing");
+	ipt_register_match(&ipt_expire_match);
+	return 0;
+}
+
+/**
+ * cleanup module and unregister iptables match
+ * @see module_exit()
+ * @see ipt_unregister_match()
+ */
+static void __exit
+ipt_exp_exit(void)
+{
+	unsigned long flags;
+	struct ipt_exp_table *t, *tmp;
+
+	dprintk("exiting");
+
+	ipt_unregister_match(&ipt_expire_match);
+	cancel_delayed_work(&ipt_exp_work);
+=09
+	spin_lock_irqsave(&ipt_exp_tables_lock, flags);
+	list_for_each_entry_safe(t, tmp, &ipt_exp_tables, list)
+		kfree(t);
+	spin_unlock_irqrestore(&ipt_exp_tables_lock, flags);
+}
+
+/**
+ * match if the expiration time has't passed
+ * @param skb socket buffer
+ * @param in inbound network device
+ * @param out outbound network device
+ * @param matchinfo match specific data
+ * @param offset match offset (?)
+ * @param hotdrop set to 1 to drop packet immediately when returning fal=
se
+ * @return non-zero for active rules, zero otherwise
+ * @see struct ipt_match
+ */
+static int
+ipt_exp_match(const struct sk_buff *skb,
+		const struct net_device *in, const struct net_device *out,
+		const void *matchinfo, int offset, int *hotdrop)
+{
+	const struct ipt_exp_info *info =3D matchinfo;
+
+	if (get_seconds() < info->expiration)
+		return 1;
+
+	return 0;
+}
+
+/**
+ * check a new iptables entry
+ * @param tablename table name for new entry
+ * @param ip ip info for new entry
+ * @param matchinfo match specific data
+ * @param matchsize size of matchinfo data
+ * @param hookmask valid netfilter hooks (?)
+ * @return non-zero for valid entries, zero otherwise
+ */
+static int
+ipt_exp_checkentry(const char *tablename, const struct ipt_ip *ip,
+		void *matchinfo, unsigned int matchsize, unsigned int hookmask)
+{
+	struct ipt_exp_info *info =3D matchinfo;
+
+	if (matchsize !=3D IPT_ALIGN(sizeof(struct ipt_exp_info)))
+		return 0;
+
+	if (info->expiration <=3D get_seconds())
+		return 0;
+
+	if (ipt_exp_add_table(tablename))
+		return 0;
+
+	ipt_exp_schedule_expiration(info->expiration);
+
+	return 1;
+}
+
+/**
+ * add a table to the set of tables to be searched for expired rules
+ * @param tablename the name of the table
+ * @return zero on success, non-zero on failure
+ */
+static int
+ipt_exp_add_table(const char *tablename)
+{
+	unsigned long flags;
+	struct ipt_exp_table *t;
+
+	spin_lock_irqsave(&ipt_exp_tables_lock, flags);
+	list_for_each_entry(t, &ipt_exp_tables, list)
+		if (strncmp(t->name, tablename, IPT_TABLE_MAXNAMELEN) =3D=3D 0)
+			break;
+	spin_unlock_irqrestore(&ipt_exp_tables_lock, flags);
+
+	if (&t->list =3D=3D &ipt_exp_tables) {
+		if (!(t =3D kmalloc(sizeof(struct ipt_exp_table), GFP_KERNEL))) {
+			dprintk("error allocating memory");
+			return -ENOMEM;
+		}
+		strlcpy(t->name, tablename, IPT_TABLE_MAXNAMELEN);
+		spin_lock_irqsave(&ipt_exp_tables_lock, flags);
+		list_add_tail(&t->list, &ipt_exp_tables);
+		spin_unlock_irqrestore(&ipt_exp_tables_lock, flags);
+	}
+	return 0;
+}
+
+/**
+ * remove a table from the set of tables to be searched for expired rule=
s
+ * @param tablename the name of the table to be removed
+ */
+static void
+ipt_exp_remove_table(const char *tablename)
+{
+	unsigned long flags;
+	struct ipt_exp_table *t, *tmp;
+
+	spin_lock_irqsave(&ipt_exp_tables_lock, flags);
+	list_for_each_entry_safe(t, tmp, &ipt_exp_tables, list) {
+		if (strncmp(t->name, tablename, IPT_TABLE_MAXNAMELEN) =3D=3D 0) {
+			list_del(&t->list);
+			kfree(t);
+		}
+	}
+	spin_unlock_irqrestore(&ipt_exp_tables_lock, flags);
+}
+
+/**
+ * schedule the next removal of expired rules
+ * @param expiration the time to be scheduled
+ */
+static void
+ipt_exp_schedule_expiration(time_t expiration)
+{
+	unsigned long delay =3D (expiration - get_seconds() < 1) ? HZ :
+					(expiration - get_seconds()) * HZ;
+
+	schedule_delayed_work(&ipt_exp_work, delay);
+}
+
+/**
+ * delete expired iptables rules
+ * @param __notused
+ * @see schedule_delayed_work()
+ */
+static void
+ipt_exp_work_fn(void *__notused)
+{
+	struct ipt_exp_table *t;
+
+	/*
+	 * FIXME what about locking here?
+	 */
+	list_for_each_entry(t, &ipt_exp_tables, list) {
+		size_t sz;
+		struct ipt_getinfo info;
+		struct ipt_get_entries *entries =3D NULL;
+		struct ipt_replace *replace =3D NULL;
+		struct ipt_counters_info *counters =3D NULL;
+
+		dprintk("expiring %s entries", t->name);
+
+		/* get table info */
+		if (ipt_exp_get_info(t->name, &info))
+			continue;
+
+		/* allocate memory */
+		sz =3D sizeof(struct ipt_get_entries) + info.size;
+		if (!(entries =3D vmalloc(sz))) {
+			dprintk("error allocating entry table");
+			break;
+		}
+		sz =3D sizeof(struct ipt_replace) + info.size;
+		if (!(replace =3D vmalloc(sz))) {
+			dprintk("error allocating replacement table");
+			goto out_free_entries;
+		}
+		memset(replace, 0, sz);
+		sz =3D sizeof(struct ipt_counters) * info.num_entries;
+		if (!(replace->counters =3D vmalloc(sz))) {
+			dprintk("error allocating counters");
+			goto out_free_entries_replace;
+		}
+		memset(replace->counters, 0, sz);
+		sz +=3D sizeof(struct ipt_counters_info);
+		if (!(counters =3D vmalloc(sz))) {
+			dprintk("error allocating new counters");
+			goto out_free_entries_replace_counters;
+		}
+		memset(counters, 0, sz);
+
+		/* get all entries, then copy active ones */
+		if (ipt_exp_get_entries(&info, entries))
+			goto out_free_entries_replace_counters_info;
+		if (ipt_exp_get_active(&info, entries, replace))
+			goto out_free_entries_replace_counters_info;
+
+		/* replace table */
+		if (replace->size < info.size) {
+			if (ipt_exp_get_counters(entries, replace, counters))
+				goto out_free_entries_replace_counters_info;
+			if (ipt_exp_replace_expired(replace))
+				goto out_free_entries_replace_counters_info;
+			if (ipt_exp_restore_counters(counters))
+				goto out_free_entries_replace_counters_info;
+		}
+
+		dprintk("expired %s entries", t->name);
+
+out_free_entries_replace_counters_info:
+		vfree(counters);
+out_free_entries_replace_counters:
+		vfree(replace->counters);
+out_free_entries_replace:
+		vfree(replace);
+out_free_entries:
+		vfree(entries);
+	}
+}
+
+/**
+ * get info on an a table
+ * @param name the name of the table
+ * @param info the location to store the retrieved info
+ * @return zero on success, non-zero otherwise
+ */
+static int
+ipt_exp_get_info(const char *name, struct ipt_getinfo *info)
+{
+	int ret =3D 0;
+	int sz =3D sizeof(struct ipt_getinfo);
+
+	dprintk("getting entry info");
+
+	strlcpy(info->name, name, IPT_TABLE_MAXNAMELEN);
+	ret =3D nf_getsockopt(NULL, PF_INET, IPT_SO_GET_INFO, (char *)info, &sz=
);
+	switch (ret) {
+		case 0:
+			break;
+		case -ENOENT:
+			/* table is gone */
+			ipt_exp_remove_table(name);
+			break;
+		default:
+			dprintk("error getting iptables info");
+			break;
+	}
+
+	return ret;
+}
+
+/**
+ * get the entries for a table
+ * @param info the location of info about the table
+ * @param entries the location to allocate and store the retrieved entri=
es
+ * @return zero on success, non-zero otherwise
+ */
+static int
+ipt_exp_get_entries(struct ipt_getinfo *info, struct ipt_get_entries *en=
tries)
+{
+	int ret =3D 0;
+	int sz =3D sizeof(struct ipt_get_entries) + info->size;
+
+	dprintk("getting existing entries");
+
+	strlcpy(entries->name, info->name, IPT_TABLE_MAXNAMELEN);
+	entries->size =3D info->size;
+	ret =3D nf_getsockopt(NULL, PF_INET,
+			IPT_SO_GET_ENTRIES, (char *)entries, &sz);
+	if (ret)
+		dprintk("error getting iptables entries");
+
+	return ret;
+}
+
+/**
+ * iterate over a tables entries, copying entries which
+ * are not expired to the replacement table
+ * @param info the location of info about the table
+ * @param entries the location of the table entries
+ * @param replace the location to allocate and store the replacement ent=
ries
+ * @return zero on success, non-zero otherwise
+ */
+static int
+ipt_exp_get_active(struct ipt_getinfo *info,
+		struct ipt_get_entries *entries, struct ipt_replace *replace)
+{
+	dprintk("copying active entries");
+
+	/* copy stuff */
+	strlcpy(replace->name, info->name, IPT_TABLE_MAXNAMELEN);
+	memcpy(replace->hook_entry, info->hook_entry, sizeof(info->hook_entry))=
;
+	memcpy(replace->underflow, info->underflow, sizeof(info->underflow));
+	replace->valid_hooks =3D info->valid_hooks;
+	replace->num_counters =3D info->num_entries;
+
+	/* set size and entry count */
+	replace->size =3D 0;
+	replace->num_entries =3D 0;
+
+	return IPT_ENTRY_ITERATE(entries->entrytable, entries->size,=20
+					ipt_exp_copy_active, replace);
+}
+
+/**
+ * copy a table entry if it is not expired
+ * @param entry the source entry
+ * @param replace the replacement table
+ * @return zero;
+ */
+static int
+ipt_exp_copy_active(struct ipt_entry *entry, struct ipt_replace *replace=
)
+{
+	if (!(IPT_MATCH_ITERATE(entry, ipt_exp_is_expired))) {
+		struct ipt_entry *dest =3D
+				(void *)replace->entries + replace->size;
+		memcpy(dest, entry, entry->next_offset);
+		replace->size +=3D entry->next_offset;
+		replace->num_entries++;
+	}
+
+	return 0;
+}
+
+/**
+ * determine if an entry is expired
+ * @param match the entry match to check for expiration
+ * @return non-zero for expired entries, zero otherwise
+ */
+static int
+ipt_exp_is_expired(struct ipt_entry_match *match)
+{
+	if (strcmp(match->u.user.name, "expire") =3D=3D 0) {
+		struct ipt_exp_info *info =3D (struct ipt_exp_info *)match->data;
+		if (info->expiration <=3D get_seconds())
+			return 1;
+	}
+	return 0;
+}
+
+/**
+ * update a table
+ * @param replace the replacement table
+ * @return zero on success, non-zero otherwise
+ */
+static int
+ipt_exp_replace_expired(struct ipt_replace *replace)
+{
+	int ret =3D 0;
+	int sz =3D sizeof(struct ipt_replace) + replace->size;
+
+	dprintk("replacing table %s", replace->name);
+
+	ret =3D nf_setsockopt(NULL, PF_INET,
+			IPT_SO_SET_REPLACE, (char *)replace, sz);
+	/*
+	 * FIXME remove this verbosity once tested?
+	 */
+	switch (ret) {
+		case 0:
+			break;
+		case -EFAULT:
+			dprintk("EFAULT replacing iptables");
+			break;
+		case -ENOPROTOOPT:
+			dprintk("ENOPROTOOPT replacing iptables");
+			break;
+		case -ENOMEM:
+			dprintk("ENOMEM replacing iptables");
+			break;
+		case -ENOENT:
+			dprintk("ENOENT replacing iptables");
+			break;
+		case -ELOOP:
+			dprintk("ELOOP replacing iptables");
+			break;
+		case -EINVAL:
+			dprintk("EINVAL replacing iptables");
+			break;
+		default:
+			dprintk("unknown error (%d) replacing iptables", ret);
+			break;
+	}
+	return ret;
+}
+
+/**
+ * get counters for unexpired entries
+ * @param entries the entries info
+ * @param replace the replacement structure, containing the old counters
+ * @param counters the new counter info
+ * @return zero on success, non-zero on failure
+ */
+static int
+ipt_exp_get_counters(struct ipt_get_entries *entries,
+		struct ipt_replace *replace,
+		struct ipt_counters_info *counters)
+{
+	int index =3D 0;
+	dprintk("copying active counters");
+
+	/* init stuff */
+	strlcpy(counters->name, replace->name, IPT_TABLE_MAXNAMELEN);
+	counters->num_counters =3D 0;
+
+	return IPT_ENTRY_ITERATE(entries->entrytable, entries->size,=20
+			ipt_exp_copy_counter, replace, counters, &index);
+}
+
+/**
+ * copy a rule counter if the rule is still active
+ * @param entry the entry
+ * @param replace the replacement structure containing the old counters
+ * @param counter the new counter info
+ * @param index the current entry index
+ * @return zero
+ */
+static int
+ipt_exp_copy_counter(struct ipt_entry *entry, struct ipt_replace *replac=
e,
+		struct ipt_counters_info *counters, int *index)
+{
+	if (!(IPT_MATCH_ITERATE(entry, ipt_exp_is_expired)))
+		counters->counters[counters->num_counters++] =3D
+				replace->counters[*index];
+	(*index)++;
+	return 0;
+}
+
+/**
+ * restore the counters for a table
+ * @param counter the counters
+ * @return zero on success, non-zero otherwise
+ */
+static int
+ipt_exp_restore_counters(struct ipt_counters_info *counters)
+{
+	int ret =3D 0;
+	int sz =3D sizeof(struct ipt_counters_info) +
+			sizeof(struct ipt_counters) * counters->num_counters;
+
+	dprintk("restoring counters for %s", counters->name);
+
+	ret =3D nf_setsockopt(NULL, PF_INET,
+			IPT_SO_SET_ADD_COUNTERS, (char *)counters, sz);
+	if (ret)
+		dprintk("error restoring counters (%d)", ret);
+	return ret;
+}
Index: ./expire/linux-2.6/net/ipv6/netfilter/Kconfig.ladd
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
RCS file: ./expire/linux-2.6/net/ipv6/netfilter/Kconfig.ladd
diff -N ./expire/linux-2.6/net/ipv6/netfilter/Kconfig.ladd
--- /dev/null	1 Jan 1970 00:00:00 -0000
+++ ./expire/linux-2.6/net/ipv6/netfilter/Kconfig.ladd	22 Jun 2005 13:18:=
03 -0000	1.1
@@ -0,0 +1,10 @@
+config IP6_NF_MATCH_EXPIRE
+	tristate  'expiring match support'
+	depends on IP6_NF_IPTABLES
+	help
+	  This option adds an expiring match, which allows you to add
+	  rules to your iptables ruleset which will later be removed
+	  automatically.
+
+	  If you want to compile it as a module, say M here and read
+	  Documentation/modules.txt.  If unsure, say `N'.
Index: ./expire/linux-2.6/net/ipv6/netfilter/Makefile.ladd
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
RCS file: ./expire/linux-2.6/net/ipv6/netfilter/Makefile.ladd
diff -N ./expire/linux-2.6/net/ipv6/netfilter/Makefile.ladd
--- /dev/null	1 Jan 1970 00:00:00 -0000
+++ ./expire/linux-2.6/net/ipv6/netfilter/Makefile.ladd	22 Jun 2005 13:18=
:03 -0000	1.1
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP6_NF_IPTABLES) +=3D ip6_tables.o
+obj-$(CONFIG_IP6_NF_MATCH_EXPIRE) +=3D ip6t_expire.o
Index: ./expire/linux-2.6/net/ipv6/netfilter/ip6t_expire.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
RCS file: ./expire/linux-2.6/net/ipv6/netfilter/ip6t_expire.c
diff -N ./expire/linux-2.6/net/ipv6/netfilter/ip6t_expire.c
--- /dev/null	1 Jan 1970 00:00:00 -0000
+++ ./expire/linux-2.6/net/ipv6/netfilter/ip6t_expire.c	22 Jun 2005 13:18=
:03 -0000	1.1
@@ -0,0 +1,566 @@
+/* This module matches until it expires, at which point the entire
+ * rule is deleted
+ *
+ * This module is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This module is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this module; if not, write to:
+ *      The Free Software Foundation, Inc.
+ *      59 Temple Place, Suite 330
+ *      Boston, MA  02111-1307  USA
+ *
+ * Copyright =A9 2005 Bryan Cardillo <dillo@seas.upenn.edu>
+ */
+
+#include <linux/config.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/workqueue.h>
+#include <linux/vmalloc.h>
+#include <linux/time.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_ipv6/ip6t_expire.h>
+
+#if CONFIG_NETFILTER_DEBUG
+#define dprintk(format, args...) \
+	printk("ip6t_expire[%s]: " format "\n", __FUNCTION__, ## args)
+#else
+#define dprintk(format, args...)
+#endif
+
+MODULE_AUTHOR("Bryan Cardillo <dillo@seas.upenn.edu>");
+MODULE_DESCRIPTION("an ip6tables expiring match module");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("1.1");
+static int __init ip6t_exp_init(void);
+static void __exit ip6t_exp_exit(void);
+module_init(ip6t_exp_init);
+module_exit(ip6t_exp_exit);
+
+static int ip6t_exp_match(const struct sk_buff *,
+		const struct net_device *, const struct net_device *,
+		const void *, int, const void *, u_int16_t, int *);
+static int ip6t_exp_checkentry(const char *, const struct ip6t_ip6 *,
+		void *, unsigned int, unsigned int);
+static int ip6t_exp_add_table(const char *);
+static void ip6t_exp_remove_table(const char *);
+static void ip6t_exp_schedule_expiration(time_t);
+static void ip6t_exp_work_fn(void *);
+static int ip6t_exp_get_info(const char *, struct ip6t_getinfo *);
+static int ip6t_exp_get_entries(struct ip6t_getinfo *, struct ip6t_get_e=
ntries *);
+static int ip6t_exp_get_active(struct ip6t_getinfo *,
+		struct ip6t_get_entries *, struct ip6t_replace *);
+static int ip6t_exp_copy_active(struct ip6t_entry *, struct ip6t_replace=
 *);
+static int ip6t_exp_is_expired(struct ip6t_entry_match *);
+static int ip6t_exp_replace_expired(struct ip6t_replace *);
+static int ip6t_exp_get_counters(struct ip6t_get_entries *,
+		struct ip6t_replace *, struct ip6t_counters_info *);
+static int ip6t_exp_copy_counter(struct ip6t_entry *, struct ip6t_replac=
e *,
+		struct ip6t_counters_info *, int *);
+static int ip6t_exp_restore_counters(struct ip6t_counters_info *);
+
+/**
+ * struct for list of tables
+ */
+struct ip6t_exp_table {
+	/**
+	 * the table name
+	 */
+	char name[IP6T_TABLE_MAXNAMELEN];
+	/**
+	 * a list_head structure enabling list inclusion
+	 */
+	struct list_head list;
+};
+
+/**
+ * work_struct for scheduling the deletion of expired rules
+ */
+static DECLARE_WORK(ip6t_exp_work, &ip6t_exp_work_fn, NULL);
+
+/**
+ * ip6tables match
+ */
+static struct ip6t_match ip6t_expire_match =3D {
+	.name		=3D "expire",
+	.match		=3D &ip6t_exp_match,
+	.checkentry	=3D &ip6t_exp_checkentry,
+	.me		=3D THIS_MODULE
+};
+
+/**
+ * the list of tables contained expiring entries
+ */
+static spinlock_t ip6t_exp_tables_lock =3D SPIN_LOCK_UNLOCKED;
+static LIST_HEAD(ip6t_exp_tables);
+
+/**
+ * initialize module and register ip6tables match
+ * @see module_init()
+ * @see ip6t_register_match()
+ */
+static int __init
+ip6t_exp_init(void)
+{
+	dprintk("initializing");
+	ip6t_register_match(&ip6t_expire_match);
+	return 0;
+}
+
+/**
+ * cleanup module and unregister ip6tables match
+ * @see module_exit()
+ * @see ip6t_unregister_match()
+ */
+static void __exit
+ip6t_exp_exit(void)
+{
+	unsigned long flags;
+	struct ip6t_exp_table *t, *tmp;
+
+	dprintk("exiting");
+
+	ip6t_unregister_match(&ip6t_expire_match);
+	cancel_delayed_work(&ip6t_exp_work);
+=09
+	spin_lock_irqsave(&ip6t_exp_tables_lock, flags);
+	list_for_each_entry_safe(t, tmp, &ip6t_exp_tables, list)
+		kfree(t);
+	spin_unlock_irqrestore(&ip6t_exp_tables_lock, flags);
+}
+
+/**
+ * match if the expiration time has't passed
+ * @param skb socket buffer
+ * @param in inbound network device
+ * @param out outbound network device
+ * @param matchinfo match specific data
+ * @param offset match offset (?)
+ * @param header (?)
+ * @param len (?)
+ * @param hotdrop set to 1 to drop packet immediately when returning fal=
se
+ * @return non-zero for active rules, zero otherwise
+ * @see struct ip6t_match
+ */
+static int
+ip6t_exp_match(const struct sk_buff *skb,
+		const struct net_device *in, const struct net_device *out,
+		const void *matchinfo, int offset,
+		const void *header, u_int16_t len, int *hotdrop)
+{
+	const struct ip6t_exp_info *info =3D matchinfo;
+
+	if (get_seconds() < info->expiration)
+		return 1;
+
+	return 0;
+}
+
+/**
+ * check a new ip6tables entry
+ * @param tablename table name for new entry
+ * @param ip ip info for new entry
+ * @param matchinfo match specific data
+ * @param matchsize size of matchinfo data
+ * @param hookmask valid netfilter hooks (?)
+ * @return non-zero for valid entries, zero otherwise
+ */
+static int
+ip6t_exp_checkentry(const char *tablename, const struct ip6t_ip6 *ip,
+		void *matchinfo, unsigned int matchsize, unsigned int hookmask)
+{
+	struct ip6t_exp_info *info =3D matchinfo;
+
+	if (matchsize !=3D IP6T_ALIGN(sizeof(struct ip6t_exp_info)))
+		return 0;
+
+	if (info->expiration <=3D get_seconds())
+		return 0;
+
+	if (ip6t_exp_add_table(tablename))
+		return 0;
+
+	ip6t_exp_schedule_expiration(info->expiration);
+
+	return 1;
+}
+
+/**
+ * add a table to the set of tables to be searched for expired rules
+ * @param tablename the name of the table
+ * @return zero on success, non-zero on failure
+ */
+static int
+ip6t_exp_add_table(const char *tablename)
+{
+	unsigned long flags;
+	struct ip6t_exp_table *t;
+
+	spin_lock_irqsave(&ip6t_exp_tables_lock, flags);
+	list_for_each_entry(t, &ip6t_exp_tables, list)
+		if (strncmp(t->name, tablename, IP6T_TABLE_MAXNAMELEN) =3D=3D 0)
+			break;
+	spin_unlock_irqrestore(&ip6t_exp_tables_lock, flags);
+
+	if (&t->list =3D=3D &ip6t_exp_tables) {
+		if (!(t =3D kmalloc(sizeof(struct ip6t_exp_table), GFP_KERNEL))) {
+			dprintk("error allocating memory");
+			return -ENOMEM;
+		}
+		strlcpy(t->name, tablename, IP6T_TABLE_MAXNAMELEN);
+		spin_lock_irqsave(&ip6t_exp_tables_lock, flags);
+		list_add_tail(&t->list, &ip6t_exp_tables);
+		spin_unlock_irqrestore(&ip6t_exp_tables_lock, flags);
+	}
+	return 0;
+}
+
+/**
+ * remove a table from the set of tables to be searched for expired rule=
s
+ * @param tablename the name of the table to be removed
+ */
+static void
+ip6t_exp_remove_table(const char *tablename)
+{
+	unsigned long flags;
+	struct ip6t_exp_table *t, *tmp;
+
+	spin_lock_irqsave(&ip6t_exp_tables_lock, flags);
+	list_for_each_entry_safe(t, tmp, &ip6t_exp_tables, list) {
+		if (strncmp(t->name, tablename, IP6T_TABLE_MAXNAMELEN) =3D=3D 0) {
+			list_del(&t->list);
+			kfree(t);
+		}
+	}
+	spin_unlock_irqrestore(&ip6t_exp_tables_lock, flags);
+}
+
+/**
+ * schedule the next removal of expired rules
+ * @param expiration the time to be scheduled
+ */
+static void
+ip6t_exp_schedule_expiration(time_t expiration)
+{
+	unsigned long delay =3D (expiration - get_seconds() < 1) ? HZ :
+					(expiration - get_seconds()) * HZ;
+
+	schedule_delayed_work(&ip6t_exp_work, delay);
+}
+
+/**
+ * delete expired ip6tables rules
+ * @param __notused
+ * @see schedule_delayed_work()
+ */
+static void
+ip6t_exp_work_fn(void *__notused)
+{
+	struct ip6t_exp_table *t;
+
+	/*
+	 * FIXME what about locking here?
+	 */
+	list_for_each_entry(t, &ip6t_exp_tables, list) {
+		size_t sz;
+		struct ip6t_getinfo info;
+		struct ip6t_get_entries *entries =3D NULL;
+		struct ip6t_replace *replace =3D NULL;
+		struct ip6t_counters_info *counters =3D NULL;
+
+		dprintk("expiring %s entries", t->name);
+
+		/* get table info */
+		if (ip6t_exp_get_info(t->name, &info))
+			continue;
+
+		/* allocate memory */
+		sz =3D sizeof(struct ip6t_get_entries) + info.size;
+		if (!(entries =3D vmalloc(sz))) {
+			dprintk("error allocating entry table");
+			break;
+		}
+		sz =3D sizeof(struct ip6t_replace) + info.size;
+		if (!(replace =3D vmalloc(sz))) {
+			dprintk("error allocating replacement table");
+			goto out_free_entries;
+		}
+		memset(replace, 0, sz);
+		sz =3D sizeof(struct ip6t_counters) * info.num_entries;
+		if (!(replace->counters =3D vmalloc(sz))) {
+			dprintk("error allocating counters");
+			goto out_free_entries_replace;
+		}
+		memset(replace->counters, 0, sz);
+		sz +=3D sizeof(struct ip6t_counters_info);
+		if (!(counters =3D vmalloc(sz))) {
+			dprintk("error allocating new counters");
+			goto out_free_entries_replace_counters;
+		}
+		memset(counters, 0, sz);
+
+		/* get all entries, then copy active ones */
+		if (ip6t_exp_get_entries(&info, entries))
+			goto out_free_entries_replace_counters_info;
+		if (ip6t_exp_get_active(&info, entries, replace))
+			goto out_free_entries_replace_counters_info;
+
+		/* replace table */
+		if (replace->size < info.size) {
+			if (ip6t_exp_get_counters(entries, replace, counters))
+				goto out_free_entries_replace_counters_info;
+			if (ip6t_exp_replace_expired(replace))
+				goto out_free_entries_replace_counters_info;
+			if (ip6t_exp_restore_counters(counters))
+				goto out_free_entries_replace_counters_info;
+		}
+
+		dprintk("expired %s entries", t->name);
+
+out_free_entries_replace_counters_info:
+		vfree(counters);
+out_free_entries_replace_counters:
+		vfree(replace->counters);
+out_free_entries_replace:
+		vfree(replace);
+out_free_entries:
+		vfree(entries);
+	}
+}
+
+/**
+ * get info on an a table
+ * @param name the name of the table
+ * @param info the location to store the retrieved info
+ * @return zero on success, non-zero otherwise
+ */
+static int
+ip6t_exp_get_info(const char *name, struct ip6t_getinfo *info)
+{
+	int ret =3D 0;
+	int sz =3D sizeof(struct ip6t_getinfo);
+
+	dprintk("getting entry info");
+
+	strlcpy(info->name, name, IP6T_TABLE_MAXNAMELEN);
+	ret =3D nf_getsockopt(NULL, PF_INET, IP6T_SO_GET_INFO, (char *)info, &s=
z);
+	switch (ret) {
+		case 0:
+			break;
+		case -ENOENT:
+			/* table is gone */
+			ip6t_exp_remove_table(name);
+			break;
+		default:
+			dprintk("error getting ip6tables info");
+			break;
+	}
+
+	return ret;
+}
+
+/**
+ * get the entries for a table
+ * @param info the location of info about the table
+ * @param entries the location to allocate and store the retrieved entri=
es
+ * @return zero on success, non-zero otherwise
+ */
+static int
+ip6t_exp_get_entries(struct ip6t_getinfo *info, struct ip6t_get_entries =
*entries)
+{
+	int ret =3D 0;
+	int sz =3D sizeof(struct ip6t_get_entries) + info->size;
+
+	dprintk("getting existing entries");
+
+	strlcpy(entries->name, info->name, IP6T_TABLE_MAXNAMELEN);
+	entries->size =3D info->size;
+	ret =3D nf_getsockopt(NULL, PF_INET,
+			IP6T_SO_GET_ENTRIES, (char *)entries, &sz);
+	if (ret)
+		dprintk("error getting ip6tables entries");
+
+	return ret;
+}
+
+/**
+ * iterate over a tables entries, copying entries which
+ * are not expired to the replacement table
+ * @param info the location of info about the table
+ * @param entries the location of the table entries
+ * @param replace the location to allocate and store the replacement ent=
ries
+ * @return zero on success, non-zero otherwise
+ */
+static int
+ip6t_exp_get_active(struct ip6t_getinfo *info,
+		struct ip6t_get_entries *entries, struct ip6t_replace *replace)
+{
+	dprintk("copying active entries");
+
+	/* copy stuff */
+	strlcpy(replace->name, info->name, IP6T_TABLE_MAXNAMELEN);
+	memcpy(replace->hook_entry, info->hook_entry, sizeof(info->hook_entry))=
;
+	memcpy(replace->underflow, info->underflow, sizeof(info->underflow));
+	replace->valid_hooks =3D info->valid_hooks;
+	replace->num_counters =3D info->num_entries;
+
+	/* set size and entry count */
+	replace->size =3D 0;
+	replace->num_entries =3D 0;
+
+	return IP6T_ENTRY_ITERATE(entries->entrytable, entries->size,=20
+					ip6t_exp_copy_active, replace);
+}
+
+/**
+ * copy a table entry if it is not expired
+ * @param entry the source entry
+ * @param replace the replacement table
+ * @return zero;
+ */
+static int
+ip6t_exp_copy_active(struct ip6t_entry *entry, struct ip6t_replace *repl=
ace)
+{
+	if (!(IP6T_MATCH_ITERATE(entry, ip6t_exp_is_expired))) {
+		struct ip6t_entry *dest =3D
+				(void *)replace->entries + replace->size;
+		memcpy(dest, entry, entry->next_offset);
+		replace->size +=3D entry->next_offset;
+		replace->num_entries++;
+	}
+
+	return 0;
+}
+
+/**
+ * determine if an entry is expired
+ * @param match the entry match to check for expiration
+ * @return non-zero for expired entries, zero otherwise
+ */
+static int
+ip6t_exp_is_expired(struct ip6t_entry_match *match)
+{
+	if (strcmp(match->u.user.name, "expire") =3D=3D 0) {
+		struct ip6t_exp_info *info =3D (struct ip6t_exp_info *)match->data;
+		if (info->expiration <=3D get_seconds())
+			return 1;
+	}
+	return 0;
+}
+
+/**
+ * update a table
+ * @param replace the replacement table
+ * @return zero on success, non-zero otherwise
+ */
+static int
+ip6t_exp_replace_expired(struct ip6t_replace *replace)
+{
+	int ret =3D 0;
+	int sz =3D sizeof(struct ip6t_replace) + replace->size;
+
+	dprintk("replacing table %s", replace->name);
+
+	ret =3D nf_setsockopt(NULL, PF_INET,
+			IP6T_SO_SET_REPLACE, (char *)replace, sz);
+	/*
+	 * FIXME remove this verbosity once tested?
+	 */
+	switch (ret) {
+		case 0:
+			break;
+		case -EFAULT:
+			dprintk("EFAULT replacing ip6tables");
+			break;
+		case -ENOPROTOOPT:
+			dprintk("ENOPROTOOPT replacing ip6tables");
+			break;
+		case -ENOMEM:
+			dprintk("ENOMEM replacing ip6tables");
+			break;
+		case -ENOENT:
+			dprintk("ENOENT replacing ip6tables");
+			break;
+		case -ELOOP:
+			dprintk("ELOOP replacing ip6tables");
+			break;
+		case -EINVAL:
+			dprintk("EINVAL replacing ip6tables");
+			break;
+		default:
+			dprintk("unknown error (%d) replacing ip6tables", ret);
+			break;
+	}
+	return ret;
+}
+
+/**
+ * get counters for unexpired entries
+ * @param entries the entries info
+ * @param replace the replacement structure, containing the old counters
+ * @param counters the new counter info
+ * @return zero on success, non-zero on failure
+ */
+static int
+ip6t_exp_get_counters(struct ip6t_get_entries *entries,
+		struct ip6t_replace *replace,
+		struct ip6t_counters_info *counters)
+{
+	int index =3D 0;
+	dprintk("copying active counters");
+
+	/* init stuff */
+	strlcpy(counters->name, replace->name, IP6T_TABLE_MAXNAMELEN);
+	counters->num_counters =3D 0;
+
+	return IP6T_ENTRY_ITERATE(entries->entrytable, entries->size,=20
+			ip6t_exp_copy_counter, replace, counters, &index);
+}
+
+/**
+ * copy a rule counter if the rule is still active
+ * @param entry the entry
+ * @param replace the replacement structure containing the old counters
+ * @param counter the new counter info
+ * @param index the current entry index
+ * @return zero
+ */
+static int
+ip6t_exp_copy_counter(struct ip6t_entry *entry, struct ip6t_replace *rep=
lace,
+		struct ip6t_counters_info *counters, int *index)
+{
+	if (!(IP6T_MATCH_ITERATE(entry, ip6t_exp_is_expired)))
+		counters->counters[counters->num_counters++] =3D
+				replace->counters[*index];
+	(*index)++;
+	return 0;
+}
+
+/**
+ * restore the counters for a table
+ * @param counter the counters
+ * @return zero on success, non-zero otherwise
+ */
+static int
+ip6t_exp_restore_counters(struct ip6t_counters_info *counters)
+{
+	int ret =3D 0;
+	int sz =3D sizeof(struct ip6t_counters_info) +
+			sizeof(struct ip6t_counters) * counters->num_counters;
+
+	dprintk("restoring counters for %s", counters->name);
+
+	ret =3D nf_setsockopt(NULL, PF_INET,
+			IP6T_SO_SET_ADD_COUNTERS, (char *)counters, sz);
+	if (ret)
+		dprintk("error restoring counters (%d)", ret);
+	return ret;
+}

--3V7upXqbjpZ4EhLz--
