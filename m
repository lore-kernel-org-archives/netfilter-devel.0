From: Frederic Leroy <fredo@starox.org>
Subject: Re: [arptables] rfc: add classify target
Date: Tue, 9 Nov 2010 21:18:34 +0100
Message-ID: <20101109211834.4da8e412@caresse>
References: <20101107152636.56f62235@caresse>
	<alpine.LNX.2.01.1011071616150.21289@obet.zrqbmnf.qr>
	<4CD959D6.1090705@trash.net>
	<20101109161047.GB25549@sd-11162.dedibox.fr>
	<4CD98746.4050100@pandora.be>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/dZdd3M_9yyDyblMcWL3n+y8"
Cc: Patrick McHardy <kaber@trash.net>,
	Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sd-11162.dedibox.fr ([88.191.70.230]:38334 "EHLO
	sd-11162.dedibox.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab0KIURp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:17:45 -0500
In-Reply-To: <4CD98746.4050100@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--MP_/dZdd3M_9yyDyblMcWL3n+y8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello Bart,

Le Tue, 09 Nov 2010 18:39:18 +0100,
Bart De Schuymer <bdschuym@pandora.be> a =C3=A9crit :

> Op 9/11/2010 17:10, Frederic Leroy schreef:
> > On Tue, Nov 09, 2010 at 03:25:26PM +0100, Patrick McHardy wrote:
> >> Am 07.11.2010 16:18, schrieb Jan Engelhardt:
> >>> On Sunday 2010-11-07 15:26, Frederic Leroy wrote:
> >> Actually we already register for NFPROTO_UNSPEC, so simply
> >> adding a userspace extension should do the job.
> > Not really, the mangle table for arp seems to be inexistnet.
> > And hacking and using the filter table  I got arptables complaining
> > about chain INPUT missing although the command line with -A OUTPUT.
> >
> > It seems there need a big work on arptables userspace side.
> >
> I'm not sure why you think this requires a lot of work on the
> userspace side. If you get stuck, feel free to post what you already
> have and I'll have a look at it. As it seems the kernel functionality
> is already there, I'd be glad to submit your userspace patch.

It may not requires a lot of work to the userspace side, but it doesn't
seem straight for me.
By the way, I joined what I've done for the moment. My free time is
sparse, but I wan't to go until the end :)

+#include <linux/netfilter/xt_CLASSIFY.h>

I have a doubt with this include because arptables have copies of the
kernel header. Should I copy it in arptables ? (compiles fine without
it here)

For the kernel part,I didn't add modalias command because the
userspace don't work yet :

# ./arptables -A OUTPUT -o eth0 -j CLASSIFY --set-class 0:7
x_tables: arp_tables: CLASSIFY target: used from hooks INPUT, but only
usable from FORWARD/OUTPUT/POSTROUTING

--=20
Fr=C3=A9d=C3=A9ric Leroy

--MP_/dZdd3M_9yyDyblMcWL3n+y8
Content-Type: text/x-patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=xt_CLASSIFY.all_table.patch

commit 01c54593df8a3e975d76b1ab745abdc26b477379
Author: Fr=C3=A9d=C3=A9ric Leroy <fredo@starox.org>
Date:   Tue Nov 9 20:54:47 2010 +0100

    netfilter: xtables: allow xt_CLASSIFY in all tables

diff --git a/net/netfilter/xt_CLASSIFY.c b/net/netfilter/xt_CLASSIFY.c
index c2c0e4a..eb7057a 100644
--- a/net/netfilter/xt_CLASSIFY.c
+++ b/net/netfilter/xt_CLASSIFY.c
@@ -39,7 +39,6 @@ static struct xt_target classify_tg_reg __read_mostly =3D=
 {
 	.name       =3D "CLASSIFY",
 	.revision   =3D 0,
 	.family     =3D NFPROTO_UNSPEC,
-	.table      =3D "mangle",
 	.hooks      =3D (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_FORWARD) |
 		      (1 << NF_INET_POST_ROUTING),
 	.target     =3D classify_tg,

--MP_/dZdd3M_9yyDyblMcWL3n+y8
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=userspace_arptables_CLASSIFY.patch

diff -r e7c5081f9739 arptables.8
--- a/arptables.8	Sat Nov 06 23:20:16 2010 +0100
+++ b/arptables.8	Tue Nov 09 21:13:44 2010 +0100
@@ -297,6 +297,10 @@
 .BR "--mangle-target target "
 Target of ARP mangle operation
 .BR "" ( DROP ", " CONTINUE " or " ACCEPT " -- default is " ACCEPT ).
+.SS CLASSIFY
+.TP
+.BR "--set-class-mac major:minor"
+Classifies arp packet
 
 .SH MAILINGLISTS
 .BR "" "See " http://netfilter.org/mailinglists.html
diff -r e7c5081f9739 extensions/Makefile
--- a/extensions/Makefile	Sat Nov 06 23:20:16 2010 +0100
+++ b/extensions/Makefile	Tue Nov 09 21:13:44 2010 +0100
@@ -1,6 +1,6 @@
 #! /usr/bin/make
 
-EXT_FUNC+=standard mangle
+EXT_FUNC+=standard mangle CLASSIFY
 EXT_OBJS+=$(foreach T,$(EXT_FUNC), extensions/arpt_$(T).o)
 
 extensions/ebt_%.o: extensions/arpt_%.c include/arptables.h include/arptables_common.h
diff -r e7c5081f9739 extensions/arpt_CLASSIFY.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/extensions/arpt_CLASSIFY.c	Tue Nov 09 21:13:44 2010 +0100
@@ -0,0 +1,112 @@
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
+			if (sscanf(argv[optind-1], "%x:%x", &i, &j) != 2)
+				return 0;
+			classify->priority = TC_H_MAKE(i<<16, j);
+			break;
+		default:
+			return 0;
+	}
+	return 1;
+}
+
+static void final_check(unsigned int flags)
+{
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
+struct arptables_target change
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
+	register_target(&change);
+}

--MP_/dZdd3M_9yyDyblMcWL3n+y8--
