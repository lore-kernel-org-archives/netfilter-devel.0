From: Frederic Leroy <fredo@starox.org>
Subject: Re: [arptables] rfc: add classify target
Date: Mon, 15 Nov 2010 13:32:48 +0100
Message-ID: <20101115133248.5815e9c1@caresse>
References: <20101107152636.56f62235@caresse>
	<alpine.LNX.2.01.1011071616150.21289@obet.zrqbmnf.qr>
	<4CD959D6.1090705@trash.net>
	<20101109161047.GB25549@sd-11162.dedibox.fr>
	<4CD98746.4050100@pandora.be>
	<20101109211834.4da8e412@caresse>
	<alpine.LNX.2.01.1011092121210.10710@obet.zrqbmnf.qr>
	<20101109215126.502a155e@caresse>
	<4CDBC7B1.2020101@trash.net>
	<20101111124505.345643a3@caresse>
	<4CDCF1A7.2050402@trash.net>
	<20101113162934.768e4a3c@caresse>
	<4CE001F2.8020600@pandora.be>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/g9ZHauubJlljhY_IcwEcfMF"
Cc: Patrick McHardy <kaber@trash.net>,
	Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sd-11162.dedibox.fr ([88.191.70.230]:39289 "EHLO
	sd-11162.dedibox.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab0KOMdC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Nov 2010 07:33:02 -0500
In-Reply-To: <4CE001F2.8020600@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--MP_/g9ZHauubJlljhY_IcwEcfMF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Le Sun, 14 Nov 2010 16:36:18 +0100,
Bart De Schuymer <bdschuym@pandora.be> a =C3=A9crit :

> Apart from my comments below, the userspace patch looks ok:
> - I would line up the help and man page entries between arptables and
> iptables so noone gets confused. Also, the man page entry refers to
> set-class-mac.
> - In final_check() you should make sure that the priority has been set
> (similar to what's done in libxt_CLASSIFY.c).

Here it is, largely borrowed from iptables.

Cheers,

--=20
Fr=C3=A9d=C3=A9ric Leroy

--MP_/g9ZHauubJlljhY_IcwEcfMF
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=userspace_arptables_CLASSIFY_20101115.patch

diff -r e7c5081f9739 arptables.8
--- a/arptables.8	Sat Nov 06 23:20:16 2010 +0100
+++ b/arptables.8	Mon Nov 15 11:17:34 2010 +0100
@@ -297,6 +297,15 @@
 .BR "--mangle-target target "
 Target of ARP mangle operation
 .BR "" ( DROP ", " CONTINUE " or " ACCEPT " -- default is " ACCEPT ).
+.SS CLASSIFY
+This  module  allows you to set the skb->priority value (and thus clas-
+sify the packet into a specific CBQ class).
+
+.TP
+.BR "--set-class major:minor"
+
+Set the major and minor  class  value.  The  values  are  always
+interpreted as hexadecimal even if no 0x prefix is given.
 
 .SH MAILINGLISTS
 .BR "" "See " http://netfilter.org/mailinglists.html
diff -r e7c5081f9739 extensions/Makefile
--- a/extensions/Makefile	Sat Nov 06 23:20:16 2010 +0100
+++ b/extensions/Makefile	Mon Nov 15 11:17:34 2010 +0100
@@ -1,6 +1,6 @@
 #! /usr/bin/make
 
-EXT_FUNC+=standard mangle
+EXT_FUNC+=standard mangle CLASSIFY
 EXT_OBJS+=$(foreach T,$(EXT_FUNC), extensions/arpt_$(T).o)
 
 extensions/ebt_%.o: extensions/arpt_%.c include/arptables.h include/arptables_common.h
diff -r e7c5081f9739 extensions/arpt_CLASSIFY.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/extensions/arpt_CLASSIFY.c	Mon Nov 15 11:17:34 2010 +0100
@@ -0,0 +1,121 @@
+/*
+ * (C) 2010 by Frederic Leroy <fredo@starox.org>
+ *
+ * arpt_classify.c -- arptables extension to classify arp packet
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License as published by
+ *	the Free Software Foundation; either version 2 of the License, or
+ *	(at your option) any later version.
+ *
+ *	This program is distributed in the hope that it will be useful,
+ *	but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *	GNU General Public License for more details.
+ *
+ *	You should have received a copy of the GNU General Public License
+ *	along with this program; if not, write to the Free Software
+ *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <stdio.h>
+#include <getopt.h>
+#include <arptables.h>
+#include <linux/netfilter/xt_CLASSIFY.h>
+
+#define TC_H_MAJ_MASK (0xFFFF0000U)
+#define TC_H_MIN_MASK (0x0000FFFFU)
+#define TC_H_MAJ(h) ((h)&TC_H_MAJ_MASK)
+#define TC_H_MIN(h) ((h)&TC_H_MIN_MASK)
+#define TC_H_MAKE(maj,min) (((maj)&TC_H_MAJ_MASK)|((min)&TC_H_MIN_MASK))
+
+static void
+help(void)
+{
+	printf(
+"CLASSIFY target v%s options:\n"
+"--set-class major:minor : set the major and minor class value\n",
+	ARPTABLES_VERSION);
+}
+
+#define CLASSIFY_OPT 1
+
+static struct option opts[] = {
+	{ "set-class"   , required_argument, 0, CLASSIFY_OPT },
+	{0}
+};
+
+static void
+init(struct arpt_entry_target *t)
+{
+	struct xt_classify_target_info *classify = (struct xt_classify_target_info *) t->data;
+	classify->priority = 0;
+}
+
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+	const struct arpt_entry *e,
+	struct arpt_entry_target **t)
+{
+	struct xt_classify_target_info *classify = (struct xt_classify_target_info *)(*t)->data;
+	int i,j;
+
+	switch (c) {
+		case CLASSIFY_OPT:
+			if (sscanf(argv[optind-1], "%x:%x", &i, &j) != 2) {
+				exit_error(PARAMETER_PROBLEM,
+						"Bad class value `%s'", optarg);
+				return 0;
+			}
+			classify->priority = TC_H_MAKE(i<<16, j);
+			if (*flags)
+				exit_error(PARAMETER_PROBLEM,
+						"CLASSIFY: Can't specify --set-class twice");
+			*flags = 1;
+			break;
+		default:
+			return 0;
+	}
+	return 1;
+}
+
+static void final_check(unsigned int flags)
+{
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM, "CLASSIFY: Parameter --set-class is required");
+}
+
+static void print(const struct arpt_arp *ip,
+	const struct arpt_entry_target *target, int numeric)
+{
+	struct xt_classify_target_info *t = (struct xt_classify_target_info *)(target->data);
+
+	printf("--set-class %x:%x ", TC_H_MAJ(t->priority)>>16, TC_H_MIN(t->priority));
+}
+
+static void
+save(const struct arpt_arp *ip, const struct arpt_entry_target *target)
+{
+}
+
+static
+struct arptables_target classify
+= { NULL,
+	"CLASSIFY",
+	ARPTABLES_VERSION,
+	ARPT_ALIGN(sizeof(struct xt_classify_target_info)),
+	ARPT_ALIGN(sizeof(struct xt_classify_target_info)),
+	&help,
+	&init,
+	&parse,
+	&final_check,
+	&print,
+	&save,
+	opts
+};
+
+static void _init(void) __attribute__ ((constructor));
+static void _init(void)
+{
+	register_target(&classify);
+}

--MP_/g9ZHauubJlljhY_IcwEcfMF--
