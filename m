From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: rfc3514
Date: 01 Apr 2003 16:15:44 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1049206544.10856.76.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-HsqhyWtHlU0KfZAPi8VV"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-HsqhyWtHlU0KfZAPi8VV
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi

Here's a partial implementation of rfc3514.
It just implements a match and a target.

There's a small problem with the match, it doesn't take any options thus
doesn't accept an invert flag... oh well.

And there's another small problem regarding conntrack... conntrack tries
to reassemble all fragments and this doesn't really work with these
packets :)

Patches against kernel 2.5 (Kconfig stuff need converting to Config.in
for 2.4)

-- 
/Martin

--=-HsqhyWtHlU0KfZAPi8VV
Content-Disposition: attachment; filename=EVIL.patch-2.5
Content-Type: text/plain; name=EVIL.patch-2.5; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

--- linux-2.5.65.orig/include/linux/netfilter_ipv4/ipt_EVIL.h	1970-01-01 01=
:00:00.000000000 +0100
+++ linux-2.5.65.evil/include/linux/netfilter_ipv4/ipt_EVIL.h	2003-04-01 14=
:59:20.000000000 +0200
@@ -0,0 +1,11 @@
+#ifndef _IPT_EVIL_H_target
+#define _IPT_EVIL_H_target
+
+struct ipt_evil_target_info {
+	u_int8_t mode;
+};
+
+#define IPT_EVIL_SET 0x1
+#define IPT_EVIL_CLEAR 0x2
+
+#endif /*_IPT_EVIL_H_target*/
--- linux-2.5.65.orig/net/ipv4/netfilter/ipt_EVIL.c	1970-01-01 01:00:00.000=
000000 +0100
+++ linux-2.5.65.evil/net/ipv4/netfilter/ipt_EVIL.c	2003-04-01 14:59:47.000=
000000 +0200
@@ -0,0 +1,97 @@
+/* This is a module which is used for setting the Evil bit of a packet. */
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <net/checksum.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_EVIL.h>
+
+static unsigned int
+target(struct sk_buff **pskb,
+       unsigned int hooknum,
+       const struct net_device *in,
+       const struct net_device *out,
+       const void *targinfo,
+       void *userinfo)
+{
+	struct iphdr *iph =3D (*pskb)->nh.iph;
+	const struct ipt_evil_target_info *evilinfo =3D targinfo;
+	u_int16_t diffs[2];
+
+	/* raw socket (tcpdump) may have clone of incoming
+                  skb: don't disturb it --RR */
+	if (skb_cloned(*pskb) && !(*pskb)->sk) {
+		struct sk_buff *nskb =3D skb_copy(*pskb, GFP_ATOMIC);
+		if (!nskb)
+			return NF_DROP;
+		kfree_skb(*pskb);
+		*pskb =3D nskb;
+		iph =3D (*pskb)->nh.iph;
+	}
+
+	diffs[0] =3D htons(iph->frag_off) ^ 0xFFFF;
+
+	if (evilinfo->mode =3D=3D IPT_EVIL_SET)
+		iph->frag_off |=3D 0x8000;
+	else
+		iph->frag_off &=3D 0x7fff;
+
+	diffs[1] =3D htons(iph->frag_off);
+	iph->check =3D csum_fold(csum_partial((char *)diffs,
+	                                    sizeof(diffs),
+	                                    iph->check^0xFFFF));
+	(*pskb)->nfcache |=3D NFC_ALTERED;
+
+	return IPT_CONTINUE;
+}
+
+static int
+checkentry(const char *tablename,
+	   const struct ipt_entry *e,
+           void *targinfo,
+           unsigned int targinfosize,
+           unsigned int hook_mask)
+{
+	const u_int8_t mode =3D ((struct ipt_evil_target_info *)targinfo)->mode;
+
+	if (targinfosize !=3D IPT_ALIGN(sizeof(struct ipt_evil_target_info))) {
+		printk(KERN_WARNING "Evil: targinfosize %u !=3D %Zu\n",
+		       targinfosize,
+		       IPT_ALIGN(sizeof(struct ipt_evil_target_info)));
+		return 0;
+	}
+
+	if (strcmp(tablename, "mangle") !=3D 0) {
+		printk(KERN_WARNING "Evil: can only be called from \"mangle\" table, not=
 \"%s\"\n", tablename);
+		return 0;
+	}
+
+	if (mode !=3D IPT_EVIL_SET
+	    && mode !=3D IPT_EVIL_CLEAR) {
+		printk(KERN_WARNING "Evil: bad evil value %#x\n", mode);
+		return 0;
+	}
+
+	return 1;
+}
+
+static struct ipt_target ipt_evil_reg
+=3D { { NULL, NULL }, "EVIL", target, checkentry, NULL, THIS_MODULE };
+
+static int __init init(void)
+{
+	if (ipt_register_target(&ipt_evil_reg))
+		return -EINVAL;
+
+	return 0;
+}
+
+static void __exit fini(void)
+{
+	ipt_unregister_target(&ipt_evil_reg);
+}
+
+module_init(init);
+module_exit(fini);
+MODULE_LICENSE("GPL");
--- linux-2.5.65.orig/net/ipv4/netfilter/Kconfig	2003-03-17 22:44:41.000000=
000 +0100
+++ linux-2.5.65.evil/net/ipv4/netfilter/Kconfig	2003-04-01 14:57:45.000000=
000 +0200
@@ -402,6 +412,16 @@
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/modules.txt>.  If unsure, say `N'.
=20
+config IP_NF_TARGET_EVIL
+	tristate "EVIL target support"
+	depends on IP_NF_MANGLE
+	help
+	  This option adds a `EVIL' target, which allows you to create rules in
+	  the `mangle' table which alter the Evil bit an IP packet prior to routi=
ng.
+
+	  If you want to compile it as a module, say M here and read
+	  <file:Documentation/modules.txt>.  If unsure, say `N'.
+
 config IP_NF_TARGET_ECN
 	tristate "ECN target support"
 	depends on IP_NF_MANGLE
--- linux-2.5.65.orig/net/ipv4/netfilter/Makefile	2003-03-17 22:43:47.00000=
0000 +0100
+++ linux-2.5.65.evil/net/ipv4/netfilter/Makefile	2003-04-01 14:56:45.00000=
0000 +0200
@@ -67,6 +68,7 @@
 obj-$(CONFIG_IP_NF_TARGET_REJECT) +=3D ipt_REJECT.o
 obj-$(CONFIG_IP_NF_TARGET_MIRROR) +=3D ipt_MIRROR.o
 obj-$(CONFIG_IP_NF_TARGET_TOS) +=3D ipt_TOS.o
+obj-$(CONFIG_IP_NF_TARGET_EVIL) +=3D ipt_EVIL.o
 obj-$(CONFIG_IP_NF_TARGET_ECN) +=3D ipt_ECN.o
 obj-$(CONFIG_IP_NF_TARGET_DSCP) +=3D ipt_DSCP.o
 obj-$(CONFIG_IP_NF_TARGET_MARK) +=3D ipt_MARK.o

--=-HsqhyWtHlU0KfZAPi8VV
Content-Disposition: attachment; filename=evil.patch-2.5
Content-Type: text/plain; name=evil.patch-2.5; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

--- linux-2.5.65.orig/include/linux/netfilter_ipv4/ipt_evil.h	1970-01-01 01=
:00:00.000000000 +0100
+++ linux-2.5.65.evil/include/linux/netfilter_ipv4/ipt_evil.h	2003-04-01 14=
:17:49.000000000 +0200
@@ -0,0 +1,8 @@
+#ifndef _IPT_EVIL_H
+#define _IPT_EVIL_H
+
+struct ipt_evil_info {
+    u_int8_t invert;
+};
+
+#endif /*_IPT_EVIL_H*/
--- linux-2.5.65.orig/net/ipv4/netfilter/ipt_evil.c	1970-01-01 01:00:00.000=
000000 +0100
+++ linux-2.5.65.evil/net/ipv4/netfilter/ipt_evil.c	2003-04-01 14:25:15.000=
000000 +0200
@@ -0,0 +1,52 @@
+/* Kernel module to match Evil packets. */
+#include <linux/module.h>
+#include <linux/skbuff.h>
+
+#include <linux/netfilter_ipv4/ipt_evil.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      const void *hdr,
+      u_int16_t datalen,
+      int *hotdrop)
+{
+	const struct ipt_evil_info *info =3D matchinfo;
+	const struct iphdr *iph =3D skb->nh.iph;
+
+	return (iph->frag_off & 0x8000) ^ info->invert;
+}
+
+static int
+checkentry(const char *tablename,
+           const struct ipt_ip *ip,
+           void *matchinfo,
+           unsigned int matchsize,
+           unsigned int hook_mask)
+{
+	if (matchsize !=3D IPT_ALIGN(sizeof(struct ipt_evil_info)))
+		return 0;
+
+	return 1;
+}
+
+static struct ipt_match evil_match
+=3D { { NULL, NULL }, "evil", &match, &checkentry, NULL, THIS_MODULE };
+
+static int __init init(void)
+{
+	return ipt_register_match(&evil_match);
+}
+
+static void __exit fini(void)
+{
+	ipt_unregister_match(&evil_match);
+}
+
+module_init(init);
+module_exit(fini);
+MODULE_LICENSE("GPL");
--- linux-2.5.65.orig/net/ipv4/netfilter/Kconfig	2003-03-17 22:44:41.000000=
000 +0100
+++ linux-2.5.65.evil/net/ipv4/netfilter/Kconfig	2003-04-01 14:23:27.000000=
000 +0200
@@ -135,6 +135,16 @@
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/modules.txt>.  If unsure, say `N'.
=20
+config IP_NF_MATCH_EVIL
+	tristate "Evil match support"
+	depends on IP_NF_IPTABLES
+	help
+	  Evil matching allows you to match packets based on the Evil bit
+	  in the IP packet.
+
+	  If you want to compile it as a module, say M here and read
+	  <file:Documentation/modules.txt>.  If unsure, say `N'.
+
 config IP_NF_MATCH_ECN
 	tristate "ECN match support"
 	depends on IP_NF_IPTABLES
--- linux-2.5.65.orig/net/ipv4/netfilter/Makefile	2003-03-17 22:43:47.00000=
0000 +0100
+++ linux-2.5.65.evil/net/ipv4/netfilter/Makefile	2003-04-01 14:22:33.00000=
0000 +0200
@@ -49,6 +49,7 @@
 obj-$(CONFIG_IP_NF_MATCH_MULTIPORT) +=3D ipt_multiport.o
 obj-$(CONFIG_IP_NF_MATCH_OWNER) +=3D ipt_owner.o
 obj-$(CONFIG_IP_NF_MATCH_TOS) +=3D ipt_tos.o
+obj-$(CONFIG_IP_NF_MATCH_EVIL) +=3D ipt_evil.o
 obj-$(CONFIG_IP_NF_MATCH_ECN) +=3D ipt_ecn.o
 obj-$(CONFIG_IP_NF_MATCH_DSCP) +=3D ipt_dscp.o
 obj-$(CONFIG_IP_NF_MATCH_AH_ESP) +=3D ipt_ah.o ipt_esp.o

--=-HsqhyWtHlU0KfZAPi8VV
Content-Disposition: attachment; filename=libipt_EVIL.c
Content-Type: text/x-c; name=libipt_EVIL.c; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

/* Shared library add-on to iptables to add EVIL target support. */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <getopt.h>

#include <iptables.h>
#include <linux/netfilter_ipv4/ip_tables.h>
#include <linux/netfilter_ipv4/ipt_EVIL.h>

/* Function which prints out usage message. */
static void
help(void)
{
	printf(
"EVIL target v%s options:\n"
"  --evil-set                    Set the Evil bit.\n"
"  --evil-clear                  Clear the Evil bit.\n",
IPTABLES_VERSION);
}

static struct option opts[] =3D {
	{ "evil-set", 0, 0, '1' },
	{ "evil-clear", 0, 0, '2' },
	{ 0 }
};

/* Initialize the target. */
static void
init(struct ipt_entry_target *t, unsigned int *nfcache)
{
}

/* Function which parses command options; returns true if it
   ate an option */
static int
parse(int c, char **argv, int invert, unsigned int *flags,
      const struct ipt_entry *entry,
      struct ipt_entry_target **target)
{
	struct ipt_evil_target_info *evilinfo
		=3D (struct ipt_evil_target_info *)(*target)->data;

	switch (c) {
	case '1':
		if (*flags & IPT_EVIL_SET)
			exit_error(PARAMETER_PROBLEM,
			           "EVIL target: Cant specify --evil-set twice");
		*flags |=3D IPT_EVIL_SET;
		evilinfo->mode =3D IPT_EVIL_SET;
		break;
	case '2':
		if (*flags & IPT_EVIL_CLEAR)
			exit_error(PARAMETER_PROBLEM,
			           "EVIL target: Cant specify --evil-clear twice");
		*flags |=3D IPT_EVIL_CLEAR;
		evilinfo->mode =3D IPT_EVIL_CLEAR;
		break;

	default:
		return 0;
	}

	return 1;
}

static void
final_check(unsigned int flags)
{
	if (!flags)
		exit_error(PARAMETER_PROBLEM,
		           "EVIL target: Parameter --evil-set or --evil-clear is required=
");
}

/* Prints out the targinfo. */
static void
print(const struct ipt_ip *ip,
      const struct ipt_entry_target *target,
      int numeric)
{
	const struct ipt_evil_target_info *evilinfo =3D
		(const struct ipt_evil_target_info *)target->data;
	printf("EVIL ");
	if (evilinfo->mode & IPT_EVIL_SET)
		printf("set ");
	else
		printf("clear ");
}

/* Saves the union ipt_targinfo in parsable form to stdout. */
static void
save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
{
	const struct ipt_evil_target_info *evilinfo =3D
		(const struct ipt_evil_target_info *)target->data;

	if (evilinfo->mode & IPT_EVIL_SET)
		printf("--evil-set ");
	else
		printf("--evil-clear ");
}

static
struct iptables_target evil
=3D { NULL,
    "EVIL",
    IPTABLES_VERSION,
    IPT_ALIGN(sizeof(struct ipt_evil_target_info)),
    IPT_ALIGN(sizeof(struct ipt_evil_target_info)),
    &help,
    &init,
    &parse,
    &final_check,
    &print,
    &save,
    opts
};

void _init(void)
{
	register_target(&evil);
}

--=-HsqhyWtHlU0KfZAPi8VV
Content-Disposition: attachment; filename=libipt_evil.c
Content-Type: text/x-c; name=libipt_evil.c; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

/* Shared library add-on to iptables to add Evil matching support. */
#include <stdio.h>
#include <netdb.h>
#include <string.h>
#include <stdlib.h>
#include <getopt.h>

#include <iptables.h>
#include <linux/netfilter_ipv4/ipt_evil.h>

/* Function which prints out usage message. */
static void
help(void)
{
	printf(
"Evil match v%s options:\n"
"This match doesn't take any options\n",
IPTABLES_VERSION);
}

static struct option opts[] =3D {
	{0}
};

/* Initialize the match. */
static void
init(struct ipt_entry_match *m, unsigned int *nfcache)
{
	*nfcache |=3D NFC_UNKNOWN;
}

/* Function which parses command options; returns true if it
   ate an option */
static int
parse(int c, char **argv, int invert, unsigned int *flags,
      const struct ipt_entry *entry,
      unsigned int *nfcache,
      struct ipt_entry_match **match)
{
	struct ipt_evil_info *evilinfo =3D (struct ipt_evil_info *)(*match)->data;

	switch (c) {
	case '1':
		check_inverse(optarg, &invert, &optind, 0);
		if (invert)
			evilinfo->invert =3D 1;
		break;

	default:
		return 0;
	}
	return 1;
}

/* Final check. */
static void
final_check(unsigned int flags)
{
}

/* Prints out the matchinfo. */
static void
print(const struct ipt_ip *ip,
      const struct ipt_entry_match *match,
      int numeric)
{
	const struct ipt_evil_info *info =3D (const struct ipt_evil_info *)match->=
data;
   =20
	if (info->invert)
		printf("!");
	printf("Evil match ");
}

/* Saves the union ipt_matchinfo in parsable form to stdout. */
static void
save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
{
	const struct ipt_evil_info *info =3D (const struct ipt_evil_info *)match->=
data;
   =20
	if (info->invert)
		printf("! ");
}

static
struct iptables_match evil
=3D { NULL,
    "evil",
    IPTABLES_VERSION,
    IPT_ALIGN(sizeof(struct ipt_evil_info)),
    IPT_ALIGN(sizeof(struct ipt_evil_info)),
    &help,
    &init,
    &parse,
    &final_check,
    &print,
    &save,
    opts
};

void _init(void)
{
	register_match(&evil);
}

--=-HsqhyWtHlU0KfZAPi8VV--
