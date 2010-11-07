From: Frederic Leroy <fredo@starox.org>
Subject: [arptables] rfc: add classify target
Date: Sun, 7 Nov 2010 15:26:36 +0100
Message-ID: <20101107152636.56f62235@caresse>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/EiV3T=mBx6//2mutJLqY6Z9"
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sd-11162.dedibox.fr ([88.191.70.230]:52764 "EHLO
	sd-11162.dedibox.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab0KGOe4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Nov 2010 09:34:56 -0500
Received: from sd-11162.dedibox.fr (localhost.localdomain [127.0.0.1])
	by sd-11162.dedibox.fr (Postfix) with ESMTP id 4103992BA1
	for <netfilter-devel@vger.kernel.org>; Sun,  7 Nov 2010 15:25:45 +0100 (CET)
Received: from caresse (88-139-61-75.adslgp.cegetel.net [88.139.61.75])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sd-11162.dedibox.fr (Postfix) with ESMTPSA id E8E6492960
	for <netfilter-devel@vger.kernel.org>; Sun,  7 Nov 2010 15:25:44 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--MP_/EiV3T=mBx6//2mutJLqY6Z9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

I ran into an old problem with Linux [1]. I need to touch the
skb->priority field for arp packet in order to map it to vlan cos.

I wrote a new classify target. Patches for both current linux-stable and
arptables cvs are joined.

For example, if you wan't to put arp packets on vlan 100 with priority,
you can do it like this :=20

vconfig set_egressmap eth0.100 7 7
arptables -A OUTPUT -o eth0.100 -j classify --set-class 0:7


[1] http://lists.openwall.net/netdev/2007/06/04/71

--=20
Fr=C3=A9d=C3=A9ric Leroy

--MP_/EiV3T=mBx6//2mutJLqY6Z9
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=arptables_classify.patch

diff -r e7c5081f9739 arptables.8
--- a/arptables.8	Sat Nov 06 23:20:16 2010 +0100
+++ b/arptables.8	Sun Nov 07 15:07:59 2010 +0100
@@ -297,6 +297,10 @@
 .BR "--mangle-target target "
 Target of ARP mangle operation
 .BR "" ( DROP ", " CONTINUE " or " ACCEPT " -- default is " ACCEPT ).
+.SS classify
+.TP
+.BR "--set-class-mac major:minor"
+Classifies arp packet
 
 .SH MAILINGLISTS
 .BR "" "See " http://netfilter.org/mailinglists.html
diff -r e7c5081f9739 extensions/Makefile
--- a/extensions/Makefile	Sat Nov 06 23:20:16 2010 +0100
+++ b/extensions/Makefile	Sun Nov 07 15:07:59 2010 +0100
@@ -1,6 +1,6 @@
 #! /usr/bin/make
 
-EXT_FUNC+=standard mangle
+EXT_FUNC+=standard mangle classify
 EXT_OBJS+=$(foreach T,$(EXT_FUNC), extensions/arpt_$(T).o)
 
 extensions/ebt_%.o: extensions/arpt_%.c include/arptables.h include/arptables_common.h
diff -r e7c5081f9739 extensions/arpt_classify.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/extensions/arpt_classify.c	Sun Nov 07 15:07:59 2010 +0100
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
+#include <linux/netfilter_arp/arpt_classify.h>
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
+"classify target v%s options:\n"
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
+	struct arpt_classify *classify = (struct arpt_classify *) t->data;
+	classify->priority = 0;
+}
+
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+	const struct arpt_entry *e,
+	struct arpt_entry_target **t)
+{
+	struct arpt_classify *classify = (struct arpt_classify *)(*t)->data;
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
+	struct arpt_classify *t = (struct arpt_classify *)(target->data);
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
+	"classify",
+	ARPTABLES_VERSION,
+	ARPT_ALIGN(sizeof(struct arpt_classify)),
+	ARPT_ALIGN(sizeof(struct arpt_classify)),
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
diff -r e7c5081f9739 include/linux/netfilter_arp/arpt_classify.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/linux/netfilter_arp/arpt_classify.h	Sun Nov 07 15:07:59 2010 +0100
@@ -0,0 +1,9 @@
+#ifndef _ARPT_CLASSIFY_H
+#define _ARPT_CLASSIFY_H
+
+struct arpt_classify
+{
+	__u32 priority;
+};
+
+#endif /* _ARPT_CLASSIFY */

--MP_/EiV3T=mBx6//2mutJLqY6Z9
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=arptables_classify_linux.patch

diff --git a/include/linux/netfilter_arp/arpt_classify.h b/include/linux/netfilter_arp/arpt_classify.h
new file mode 100644
index 0000000..1bbc6d0
--- /dev/null
+++ b/include/linux/netfilter_arp/arpt_classify.h
@@ -0,0 +1,9 @@
+#ifndef _ARPT_CLASSIFY_H
+#define _ARPT_CLASSIFY_H
+
+struct arpt_classify
+{
+	__u32 priority;
+};
+
+#endif /* _ARPT_CLASSIFY */
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index babd1a2..4f10dbf 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -386,6 +386,17 @@ config IP_NF_ARP_MANGLE
 	  Allows altering the ARP packet payload: source and destination
 	  hardware and network addresses.
 
+config IP_NF_ARP_CLASSIFY
+	tristate "ARP packet classification target"
+	help
+	  This option adds a `classify' target, which enables the user to set
+	  the priority of an arp packet. Some qdiscs can use this value for
+	  classification, among these are:
+
+  	  atm, cbq, dsmark, pfifo_fast, htb, prio
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 endif # IP_NF_ARPTABLES
 
 endmenu
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 4811159..a5387dc 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -65,6 +65,7 @@ obj-$(CONFIG_IP_NF_TARGET_ULOG) += ipt_ULOG.o
 # generic ARP tables
 obj-$(CONFIG_IP_NF_ARPTABLES) += arp_tables.o
 obj-$(CONFIG_IP_NF_ARP_MANGLE) += arpt_mangle.o
+obj-$(CONFIG_IP_NF_ARP_CLASSIFY) += arpt_classify.o
 
 # just filtering instance of ARP tables for now
 obj-$(CONFIG_IP_NF_ARPFILTER) += arptable_filter.o
diff --git a/net/ipv4/netfilter/arpt_classify.c b/net/ipv4/netfilter/arpt_classify.c
new file mode 100644
index 0000000..39aa0c3
--- /dev/null
+++ b/net/ipv4/netfilter/arpt_classify.c
@@ -0,0 +1,41 @@
+/* module that allows classification of arp packet */
+#include <linux/module.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_arp/arpt_classify.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Frederic Leroy <fredo@starox.org>");
+MODULE_DESCRIPTION("arptables arp classify target");
+
+static unsigned int
+target(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	const struct arpt_classify *classify = par->targinfo;
+
+	skb->priority=classify->priority;
+
+	return XT_CONTINUE;
+}
+
+static struct xt_target arpt_classify_reg __read_mostly = {
+	.name		= "classify",
+	.family		= NFPROTO_ARP,
+	.target		= target,
+	.targetsize	= sizeof(struct arpt_classify),
+	.checkentry	= NULL,
+	.me		= THIS_MODULE,
+};
+
+static int __init arpt_classify_init(void)
+{
+	return xt_register_target(&arpt_classify_reg);
+}
+
+static void __exit arpt_classify_fini(void)
+{
+	xt_unregister_target(&arpt_classify_reg);
+}
+
+module_init(arpt_classify_init);
+module_exit(arpt_classify_fini);

--MP_/EiV3T=mBx6//2mutJLqY6Z9--
