From: "Richard" <richard@o-matrix.org>
Subject: RE: [NEW TARGET] target for modifying conntrack timeout value
Date: Fri, 17 Dec 2004 08:10:04 -1000
Message-ID: <EINSTEINH71yEXUIEAO0000093b@einstein.systemmetrics.com>
References: <41C092B9.9020501@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0465_01C4E40F.D0BEBCE0"
Cc: 'Netfilter Development Mailinglist' <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "'Pablo Neira'" <pablo@eurodev.net>
In-Reply-To: <41C092B9.9020501@eurodev.net>
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

This is a multi-part message in MIME format.

------=_NextPart_000_0465_01C4E40F.D0BEBCE0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

> >>You should do those checkings in user space. Those error must be handle
> >>in iptables, not in kernel.
> >>
> >>
> >It is already done in user space. It is probably redundant doing the same
> >thing here. I will drop it.
> >
> >
> 
> yes, it's redudant. Please, drop that.
> 


I drop it and also implemented other suggestions. Here is the latest.

Thanks,
Richard


------=_NextPart_000_0465_01C4E40F.D0BEBCE0
Content-Type: application/octet-stream;
	name="CTEXPIRE.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="CTEXPIRE.diff"

Index: linux/include/linux/netfilter_ipv4/ipt_CTEXPIRE.h=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
--- linux/include/linux/netfilter_ipv4/ipt_CTEXPIRE.h	(revision 0)=0A=
+++ linux/include/linux/netfilter_ipv4/ipt_CTEXPIRE.h	(revision 0)=0A=
@@ -0,0 +1,19 @@=0A=
+/* CTEXPIRE modification module for IP tables=0A=
+ * (C) 2004 by Richard Zheng <richard@o-matrix.org> */=0A=
+=0A=
+#ifndef _IPT_CTEXPIRE_H=0A=
+#define _IPT_CTEXPIRE_H=0A=
+=0A=
+enum {=0A=
+	IPT_CTEXPIRE_SET =3D 0,=0A=
+	IPT_CTEXPIRE_INC,=0A=
+	IPT_CTEXPIRE_DEC=0A=
+};=0A=
+=0A=
+#define IPT_CTEXPIRE_MAXMODE	IPT_CTEXPIRE_DEC=0A=
+=0A=
+struct ipt_CTEXPIRE_info {=0A=
+	u_int8_t	mode;=0A=
+	unsigned long expires;=0A=
+};=0A=
+#endif=0A=
Index: linux/net/ipv4/netfilter/Makefile.ladd=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
--- linux/net/ipv4/netfilter/Makefile.ladd	(revision 0)=0A=
+++ linux/net/ipv4/netfilter/Makefile.ladd	(revision 0)=0A=
@@ -0,0 +1,2 @@=0A=
+obj-$(CONFIG_IP_NF_TARGET_LOG) +=3D ipt_LOG.o=0A=
+obj-$(CONFIG_IP_NF_TARGET_CTEXPIRE) +=3D ipt_CTEXPIRE.o=0A=
Index: linux/net/ipv4/netfilter/ipt_CTEXPIRE.c=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
--- linux/net/ipv4/netfilter/ipt_CTEXPIRE.c	(revision 0)=0A=
+++ linux/net/ipv4/netfilter/ipt_CTEXPIRE.c	(revision 0)=0A=
@@ -0,0 +1,133 @@=0A=
+/* CTEXPIRE modification target for IP tables=0A=
+ * (C) 2004 by Richard Zheng <richard@o-matrix.org>=0A=
+ *=0A=
+ * Version: 1.0=0A=
+ *=0A=
+ * This software is distributed under the terms of GNU GPL=0A=
+ */=0A=
+=0A=
+#include <linux/module.h>=0A=
+#include <linux/skbuff.h>=0A=
+#include <linux/ip.h>=0A=
+#include <net/checksum.h>=0A=
+=0A=
+#include <linux/netfilter_ipv4/ip_tables.h>=0A=
+#include <linux/netfilter_ipv4/ipt_CTEXPIRE.h>=0A=
+#include <linux/netfilter_ipv4/ip_conntrack.h>=0A=
+=0A=
+MODULE_AUTHOR("Richard Zheng <richard@o-matrix.org>");=0A=
+MODULE_DESCRIPTION("IP tables CTEXPIRE modification module");=0A=
+MODULE_LICENSE("GPL");=0A=
+=0A=
+#undef EXTRADEBUG=0A=
+=0A=
+static unsigned int=0A=
+ipt_ctexpire_target(struct sk_buff **pskb,=0A=
+	unsigned int hooknum,=0A=
+	const struct net_device *in,=0A=
+	const struct net_device *out,=0A=
+	const void *targinfo,=0A=
+	void *userinfo)=0A=
+=0A=
+{=0A=
+	const struct ipt_CTEXPIRE_info *info =3D targinfo;=0A=
+	unsigned long new_expires;=0A=
+=0A=
+	enum ip_conntrack_info ctinfo;=0A=
+	struct ip_conntrack *ct =3D ip_conntrack_get((*pskb), &ctinfo);=0A=
+=0A=
+	if (ct =3D=3D NULL) {=0A=
+		return IPT_CONTINUE;=0A=
+	}=0A=
+=0A=
+	IP_NF_ASSERT(ct->timeout.data =3D=3D (unsigned long)ct);=0A=
+=0A=
+	new_expires =3D info->expires*HZ;=0A=
+=0A=
+#ifdef EXTRADEBUG=0A=
+	printk(KERN_WARNING "CTEXPIRE: fired =3D %s, mode %d, value %ld\n",=0A=
+	       !is_confirmed(ct) ? "no" : "yes", info->mode, info->expires);=0A=
+	unsigned long enter =3D ct->timeout.expires;=0A=
+#endif=0A=
+=0A=
+	switch (info->mode) {=0A=
+		case IPT_CTEXPIRE_SET:=0A=
+			break;=0A=
+		case IPT_CTEXPIRE_INC:=0A=
+			/* If not in hash table, timer will not be active yet */=0A=
+			if (!is_confirmed(ct)) {=0A=
+				/* TODO should we check if counter overflow?=0A=
+				 * other kernel function didn't check this=0A=
+				 */=0A=
+				new_expires +=3D ct->timeout.expires; =0A=
+			} else {=0A=
+				new_expires +=3D ct->timeout.expires - jiffies;=0A=
+			}=0A=
+			break;=0A=
+		case IPT_CTEXPIRE_DEC:=0A=
+			/* If not in hash table, timer will not be active yet */=0A=
+			if (!is_confirmed(ct)) {=0A=
+				new_expires =3D =0A=
+				    (ct->timeout.expires <=3D new_expires) ? =0A=
+				    0 : (ct->timeout.expires - new_expires);=0A=
+			} else {=0A=
+				new_expires =3D =0A=
+				    (ct->timeout.expires - jiffies <=3D new_expires) ? =0A=
+					0 : (ct->timeout.expires - jiffies - new_expires);=0A=
+			}=0A=
+			break;=0A=
+		default:=0A=
+			break;=0A=
+	}=0A=
+=0A=
+=0A=
+	ip_ct_refresh(ct, new_expires);=0A=
+=0A=
+#ifdef EXTRADEBUG=0A=
+	printk(KERN_WARNING =0A=
+	       "CTEXPIRE: enter =3D %ld/%ld, exit =3D %ld/%ld, diff =3D =
%ld\n", =0A=
+	       enter, enter-jiffies, ct->timeout.expires, =0A=
+	       ct->timeout.expires-jiffies, ct->timeout.expires - enter);=0A=
+#endif=0A=
+=0A=
+	return IPT_CONTINUE;=0A=
+}=0A=
+=0A=
+static int ipt_ctexpire_checkentry(const char *tablename,=0A=
+		const struct ipt_entry *e,=0A=
+		void *targinfo,=0A=
+		unsigned int targinfosize,=0A=
+		unsigned int hook_mask)=0A=
+{=0A=
+	struct ipt_CTEXPIRE_info *info =3D targinfo;=0A=
+=0A=
+	if (targinfosize !=3D IPT_ALIGN(sizeof(struct ipt_CTEXPIRE_info))) {=0A=
+		printk(KERN_WARNING "CTEXPIRE: targinfosize %u !=3D %Zu\n",=0A=
+			targinfosize,=0A=
+			IPT_ALIGN(sizeof(struct ipt_CTEXPIRE_info)));=0A=
+		return 0;	=0A=
+	}	=0A=
+=0A=
+	return 1;=0A=
+}=0A=
+=0A=
+static struct ipt_target ipt_CTEXPIRE =3D {=0A=
+	.name =3D "CTEXPIRE",=0A=
+	.target =3D &ipt_ctexpire_target,=0A=
+	.checkentry =3D &ipt_ctexpire_checkentry,=0A=
+	.me =3D THIS_MODULE=0A=
+};=0A=
+=0A=
+static int __init init(void)=0A=
+{=0A=
+	return ipt_register_target(&ipt_CTEXPIRE);=0A=
+}=0A=
+=0A=
+static void __exit fini(void)=0A=
+{=0A=
+	ipt_unregister_target(&ipt_CTEXPIRE);=0A=
+}=0A=
+=0A=
+module_init(init);=0A=
+module_exit(fini);=0A=
+=0A=
Index: linux/net/ipv4/netfilter/Config.in.ladd=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
--- linux/net/ipv4/netfilter/Config.in.ladd	(revision 0)=0A=
+++ linux/net/ipv4/netfilter/Config.in.ladd	(revision 0)=0A=
@@ -0,0 +1,2 @@=0A=
+  dep_tristate '  LOG target support' CONFIG_IP_NF_TARGET_LOG =
$CONFIG_IP_NF_IPTABLES=0A=
+  dep_tristate '  CTEXPIRE target support' CONFIG_IP_NF_TARGET_CTEXPIRE =
$CONFIG_IP_NF_IPTABLES=0A=
Index: linux/Documentation/Configure.help.ladd=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
--- linux/Documentation/Configure.help.ladd	(revision 0)=0A=
+++ linux/Documentation/Configure.help.ladd	(revision 0)=0A=
@@ -0,0 +1,9 @@=0A=
+CONFIG_IP_NF_TARGET_LOG=0A=
+CTEXPIRE target support=0A=
+CONFIG_IP_NF_TARGET_CTEXPIRE=0A=
+  This option adds a `CTEXPIRE' target, which enables the user to set=0A=
+  the conntrack expire value or increment / decrement it by a given=0A=
+  amount (in seconds).=0A=
+=0A=
+  If you want to compile it as a module, say M here and read=0A=
+  Documentation/modules.txt.  If unsure, say `N'.=0A=
Index: iptables/extensions/libipt_CTEXPIRE.man=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
--- iptables/extensions/libipt_CTEXPIRE.man	(revision 0)=0A=
+++ iptables/extensions/libipt_CTEXPIRE.man	(revision 0)=0A=
@@ -0,0 +1,12 @@=0A=
+This is used to modify the conntrack expire field.  The conntrack =
expire field determines=0A=
+how much time left (in seconds) for the conntrack. The conntrack will =
be deleted or changed=0A=
+to a new state when the expire field reachs 0.=0A=
+.TP=0A=
+.BI "--ctexpire-set " "value"=0A=
+Set the conntrack expire value to `value' (in seconds).=0A=
+.TP=0A=
+.BI "--ctexpire-dec " "value"=0A=
+Decrement the conntrack expire value `value' (in seconds), i.e. make it =
live shorter.=0A=
+.TP=0A=
+.BI "--ctexpire-inc " "value"=0A=
+Increment the conntrack expire value `value' (in seconds), i.e. make it =
live longer.=0A=
Index: iptables/extensions/libipt_CTEXPIRE.c=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
--- iptables/extensions/libipt_CTEXPIRE.c	(revision 0)=0A=
+++ iptables/extensions/libipt_CTEXPIRE.c	(revision 0)=0A=
@@ -0,0 +1,196 @@=0A=
+/* Shared library add-on to iptables for the CTEXPIRE target=0A=
+ * (C) 2004 by Richard Zheng <richard@o-matrix.org>=0A=
+ *=0A=
+ * $Id: libipt_CTEXPIRE.c,v 1.0 2004/12/01 16:08:16 richard Exp $=0A=
+ *=0A=
+ * This program is distributed under the terms of GNU GPL=0A=
+ */=0A=
+#include <stdio.h>=0A=
+#include <string.h>=0A=
+#include <stdlib.h>=0A=
+#include <getopt.h>=0A=
+#include <iptables.h>=0A=
+#include <sys/param.h>=0A=
+=0A=
+#include <linux/netfilter_ipv4/ip_tables.h>=0A=
+#include <linux/netfilter_ipv4/ipt_CTEXPIRE.h>=0A=
+=0A=
+#define IPT_CTEXPIRE_USED	1=0A=
+=0A=
+static void init(struct ipt_entry_target *t, unsigned int *nfcache) =0A=
+{=0A=
+}=0A=
+=0A=
+static void help(void) =0A=
+{=0A=
+	printf(=0A=
+"CTEXPIRE target v%s options\n"=0A=
+"  --ctexpire-set value		Set conntrack expire to <value>\n"=0A=
+"  --ctexpire-dec value		Decrement conntrack expire by <value>\n"=0A=
+"  --ctexpire-inc value		Increment conntrack expire by <value>\n"=0A=
+, IPTABLES_VERSION);=0A=
+}=0A=
+=0A=
+static int parse(int c, char **argv, int invert, unsigned int *flags,=0A=
+		const struct ipt_entry *entry,=0A=
+		struct ipt_entry_target **target)=0A=
+{=0A=
+	struct ipt_CTEXPIRE_info *info =3D (struct ipt_CTEXPIRE_info *) =
(*target)->data;=0A=
+#ifdef KERNEL_64_USERSPACE_32=0A=
+	unsigned long long value, HZ_value;=0A=
+#else=0A=
+	unsigned long value, HZ_value;=0A=
+#endif=0A=
+=0A=
+	if (*flags & IPT_CTEXPIRE_USED) {=0A=
+		exit_error(PARAMETER_PROBLEM, =0A=
+		           "Can't specify conntrack expire option twice");=0A=
+	}=0A=
+=0A=
+	if (!optarg) =0A=
+		exit_error(PARAMETER_PROBLEM, =0A=
+		           "CTEXPIRE: You must specify a value");=0A=
+=0A=
+	if (check_inverse(optarg, &invert, NULL, 0))=0A=
+		exit_error(PARAMETER_PROBLEM,=0A=
+		       	   "CTEXPIRE: unexpected `!'");=0A=
+	=0A=
+#ifdef KERNEL_64_USERSPACE_32=0A=
+	if (string_to_number_ll(optarg, 0, 0, &value) =3D=3D -1)=0A=
+		exit_error(PARAMETER_PROBLEM, =0A=
+			   "expire value invalid: `%s'\n", optarg);=0A=
+#else=0A=
+	if (string_to_number_l(optarg, 0, 0, &value) =3D=3D -1)=0A=
+		exit_error(PARAMETER_PROBLEM, =0A=
+		           "expire value invalid: `%s'\n", optarg);=0A=
+#endif=0A=
+=0A=
+	HZ_value =3D value*HZ;=0A=
+=0A=
+	if (HZ_value < value) {=0A=
+		/* if user specified value is too big, =0A=
+		 * *HZ can overflow the counter=0A=
+		 */=0A=
+		exit_error(PARAMETER_PROBLEM, =0A=
+		 "expire value too big, will overflow counter: `%s'\n", optarg);=0A=
+	}=0A=
+=0A=
+=0A=
+	switch (c) {=0A=
+=0A=
+		case '1':=0A=
+			info->mode =3D IPT_CTEXPIRE_SET;=0A=
+			break;=0A=
+=0A=
+		case '2':=0A=
+			if (value =3D=3D 0) {=0A=
+				exit_error(PARAMETER_PROBLEM,=0A=
+					"CTEXPIRE: decreasing by 0?");=0A=
+			}=0A=
+=0A=
+			info->mode =3D IPT_CTEXPIRE_DEC;=0A=
+			break;=0A=
+=0A=
+		case '3':=0A=
+			if (value =3D=3D 0) {=0A=
+				exit_error(PARAMETER_PROBLEM,=0A=
+					"CTEXPIRE: increasing by 0?");=0A=
+			}=0A=
+=0A=
+			info->mode =3D IPT_CTEXPIRE_INC;=0A=
+			break;=0A=
+=0A=
+		default:=0A=
+			return 0;=0A=
+=0A=
+	}=0A=
+	=0A=
+	info->expires =3D value;=0A=
+	*flags |=3D IPT_CTEXPIRE_USED;=0A=
+=0A=
+	return 1;=0A=
+}=0A=
+=0A=
+static void final_check(unsigned int flags)=0A=
+{=0A=
+	if (!(flags & IPT_CTEXPIRE_USED))=0A=
+		exit_error(PARAMETER_PROBLEM,=0A=
+				"CTEXPIRE: You must specify an action");=0A=
+}=0A=
+=0A=
+static void save(const struct ipt_ip *ip,=0A=
+		const struct ipt_entry_target *target)=0A=
+{=0A=
+	const struct ipt_CTEXPIRE_info *info =3D =0A=
+		(struct ipt_CTEXPIRE_info *) target->data;=0A=
+=0A=
+	switch (info->mode) {=0A=
+		case IPT_CTEXPIRE_SET:=0A=
+			printf("--ctexpire-set ");=0A=
+			break;=0A=
+		case IPT_CTEXPIRE_DEC:=0A=
+			printf("--ctexpire-dec ");=0A=
+			break;=0A=
+=0A=
+		case IPT_CTEXPIRE_INC:=0A=
+			printf("--ctexpire-inc ");=0A=
+			break;=0A=
+	}=0A=
+#ifdef KERNEL_64_USERSPACE_32=0A=
+	printf("%llu ", info->expires);=0A=
+#else=0A=
+	printf("%lu ", info->expires);=0A=
+#endif=0A=
+}=0A=
+=0A=
+static void print(const struct ipt_ip *ip,=0A=
+		const struct ipt_entry_target *target, int numeric)=0A=
+{=0A=
+	const struct ipt_CTEXPIRE_info *info =3D=0A=
+		(struct ipt_CTEXPIRE_info *) target->data;=0A=
+=0A=
+	printf("CTEXPIRE ");=0A=
+	switch (info->mode) {=0A=
+		case IPT_CTEXPIRE_SET:=0A=
+			printf("set to ");=0A=
+			break;=0A=
+		case IPT_CTEXPIRE_DEC:=0A=
+			printf("decrement by ");=0A=
+			break;=0A=
+		case IPT_CTEXPIRE_INC:=0A=
+			printf("increment by ");=0A=
+			break;=0A=
+	}=0A=
+#ifdef KERNEL_64_USERSPACE_32=0A=
+	printf("%llu ", info->expires);=0A=
+#else=0A=
+	printf("%lu ", info->expires);=0A=
+#endif=0A=
+}=0A=
+=0A=
+static struct option opts[] =3D {=0A=
+	{ "ctexpire-set", 1, 0, '1' },=0A=
+	{ "ctexpire-dec", 1, 0, '2' },=0A=
+	{ "ctexpire-inc", 1, 0, '3' },=0A=
+	{ 0 }=0A=
+};=0A=
+=0A=
+static=0A=
+struct iptables_target CTEXPIRE =3D { NULL, =0A=
+	"CTEXPIRE",=0A=
+	IPTABLES_VERSION,=0A=
+	IPT_ALIGN(sizeof(struct ipt_CTEXPIRE_info)),=0A=
+	IPT_ALIGN(sizeof(struct ipt_CTEXPIRE_info)),=0A=
+	&help,=0A=
+	&init,=0A=
+	&parse,=0A=
+	&final_check,=0A=
+	&print,=0A=
+	&save,=0A=
+	opts =0A=
+};=0A=
+=0A=
+void _init(void)=0A=
+{=0A=
+	register_target(&CTEXPIRE);=0A=
+}=0A=
Index: iptables/extensions/.CTEXPIRE-test=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
--- iptables/extensions/.CTEXPIRE-test	(revision 0)=0A=
+++ iptables/extensions/.CTEXPIRE-test	(revision 0)=0A=
@@ -0,0 +1,2 @@=0A=
+#! /bin/sh=0A=
+[ -f $KERNEL_DIR/net/ipv4/netfilter/ipt_CTEXPIRE.c ] && echo CTEXPIRE=0A=
=0A=
Property changes on: iptables/extensions/.CTEXPIRE-test=0A=
___________________________________________________________________=0A=
Name: svn:executable=0A=
   + *=0A=
=0A=
Index: iptables/include/linux/netfilter_ipv4/ipt_CTEXPIRE.h=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
--- iptables/include/linux/netfilter_ipv4/ipt_CTEXPIRE.h	(revision 0)=0A=
+++ iptables/include/linux/netfilter_ipv4/ipt_CTEXPIRE.h	(revision 0)=0A=
@@ -0,0 +1,24 @@=0A=
+/* CTEXPIRE modification module for IP tables=0A=
+ * (C) 2004 by Richard Zheng <richard@o-matrix.org> */=0A=
+=0A=
+#ifndef _IPT_CTEXPIRE_H=0A=
+#define _IPT_CTEXPIRE_H=0A=
+=0A=
+enum {=0A=
+	IPT_CTEXPIRE_SET =3D 0,=0A=
+	IPT_CTEXPIRE_INC,=0A=
+	IPT_CTEXPIRE_DEC=0A=
+};=0A=
+=0A=
+#define IPT_CTEXPIRE_MAXMODE	IPT_CTEXPIRE_DEC=0A=
+=0A=
+struct ipt_CTEXPIRE_info {=0A=
+	u_int8_t	mode;=0A=
+#ifdef KERNEL_64_USERSPACE_32=0A=
+	unsigned long long expires;=0A=
+#else=0A=
+	unsigned long expires;=0A=
+#endif=0A=
+=0A=
+};=0A=
+#endif=0A=
Index: help=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
--- help	(revision 0)=0A=
+++ help	(revision 0)=0A=
@@ -0,0 +1,3 @@=0A=
+This adds an iptables CTEXPIRE manipulation target, which enables the =
user=0A=
+to set the expire value of a conntrack or to increment / decrement it =
by a =0A=
+given value.=0A=
Index: info=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
--- info	(revision 0)=0A=
+++ info	(revision 0)=0A=
@@ -0,0 +1,3 @@=0A=
+Author: Richard Zheng <richard@o-matrix.org>=0A=
+Status: Expirement=0A=
+Repository: extra=0A=

------=_NextPart_000_0465_01C4E40F.D0BEBCE0--
