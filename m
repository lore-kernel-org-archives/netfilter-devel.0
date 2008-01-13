From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [xt_RAWNAT 3/3] xt_RAWNAT code
Date: Sun, 13 Jan 2008 17:25:32 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801131722580.21665@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801131648010.21665@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0801131710110.21665@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49399 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbYAMQZd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Jan 2008 11:25:33 -0500
In-Reply-To: <Pine.LNX.4.64.0801131710110.21665@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


fixes compile error (3/3 resend).

diff --git a/include/linux/netfilter/xt_RAWNAT.h b/include/linux/netfil=
ter/xt_RAWNAT.h
new file mode 100644
index 0000000..f948166
--- /dev/null
+++ b/include/linux/netfilter/xt_RAWNAT.h
@@ -0,0 +1,9 @@
+#ifndef _LINUX_NETFILTER_XT_TARGET_RAWNAT
+#define _LINUX_NETFILTER_XT_TARGET_RAWNAT 1
+
+struct xt_rawnat_tginfo {
+	union nf_inet_addr addr;
+	uint8_t mask;
+};
+
+#endif /* _LINUX_NETFILTER_XT_TARGET_RAWNAT */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index eec3d24..7611e1b 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -385,6 +385,15 @@ config NETFILTER_XT_TARGET_RATEEST
=20
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
+config NETFILTER_XT_TARGET_RAWNAT
+	tristate '"RAWNAT" raw address translation w/o conntrack'
+	depends on NETFILTER_XTABLES
+	depends on IP_NF_RAW || IP_NF6_RAW
+	---help---
+	This option adds the RAWSNAT and RAWDNAT targets which can do Network
+	Address Translation (no port translation) without requiring Netfilter
+	connection tracking.
+
 config NETFILTER_XT_TARGET_REJECT
 	tristate '"REJECT" target support'
 	depends on NETFILTER_XTABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index b170ef1..e5132fd 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -47,6 +47,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_NFLOG) +=3D xt_NFLOG=
=2Eo
 obj-$(CONFIG_NETFILTER_XT_TARGET_NFQUEUE) +=3D xt_NFQUEUE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NOTRACK) +=3D xt_NOTRACK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_RATEEST) +=3D xt_RATEEST.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_RAWNAT) +=3D xt_RAWNAT.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_REJECT) +=3D xt_REJECT.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) +=3D xt_SECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_STEAL) +=3D xt_STEAL.o
diff --git a/net/netfilter/xt_RAWNAT.c b/net/netfilter/xt_RAWNAT.c
new file mode 100644
index 0000000..42072d3
--- /dev/null
+++ b/net/netfilter/xt_RAWNAT.c
@@ -0,0 +1,195 @@
+/*
+ *	xt_RAWNAT - Netfilter module to do untracked NAT
+ *
+ *	Copyright =C2=A9 CC Computer Consultants GmbH, 2008
+ *	Jan Engelhardt <jengelh@computergmbh.de>
+ */
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_conntrack_common.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_RAWNAT.h>
+#include <net/netfilter/nf_conntrack.h>
+
+static inline u_int32_t
+remask(u_int32_t addr, u_int32_t repl, unsigned int shift)
+{
+	u_int32_t mask =3D (shift =3D=3D 32) ? 0 : (~(u_int32_t)0 >> shift);
+	return htonl((ntohl(addr) & ~mask) | ntohl(repl));
+}
+
+static void
+rawnat_ipv6_mask(__be32 *addr, const __be32 *repl, unsigned int mask)
+{
+	switch (mask) {
+		case 0:
+			break;
+		case 1 ... 31:
+			addr[0] =3D remask(addr[0], repl[0], mask);
+			break;
+		case 32:
+			addr[0] =3D repl[0];
+			break;
+		case 33 ... 63:
+			addr[0] =3D repl[0];
+			addr[1] =3D remask(addr[1], repl[1], mask - 64);
+			break;
+		case 64:
+			addr[0] =3D repl[0];
+			addr[1] =3D repl[1];
+			break;
+		case 65 ... 95:
+			addr[0] =3D repl[0];
+			addr[1] =3D repl[1];
+			addr[2] =3D remask(addr[2], repl[2], mask - 96);
+		case 96:
+			addr[0] =3D repl[0];
+			addr[1] =3D repl[1];
+			addr[2] =3D repl[2];
+			break;
+		case 97 ... 127:
+			addr[0] =3D repl[0];
+			addr[1] =3D repl[1];
+			addr[2] =3D repl[2];
+			addr[3] =3D remask(addr[3], repl[3], mask - 128);
+			break;
+		case 128:
+			addr[0] =3D repl[0];
+			addr[1] =3D repl[1];
+			addr[2] =3D repl[2];
+			addr[3] =3D repl[3];
+			break;
+	}
+}
+
+static unsigned int
+rawsnat_tg4(struct sk_buff *skb, const struct net_device *in,
+            const struct net_device *out, unsigned int hooknum,
+            const struct xt_target *target, const void *targinfo)
+{
+	const struct xt_rawnat_tginfo *info =3D targinfo;
+	struct iphdr *iph;
+	u_int32_t na;
+
+	if (!skb_make_writable(skb, sizeof(struct iphdr)))
+		return NF_DROP;
+
+	iph =3D ip_hdr(skb);
+	na  =3D remask(iph->saddr, info->addr.ip, info->mask);
+	csum_replace4(&iph->check, iph->saddr, na);
+	iph->saddr =3D na;
+	return XT_CONTINUE;
+}
+
+static unsigned int
+rawdnat_tg4(struct sk_buff *skb, const struct net_device *in,
+            const struct net_device *out, unsigned int hooknum,
+            const struct xt_target *target, const void *targinfo)
+{
+	const struct xt_rawnat_tginfo *info =3D targinfo;
+	struct iphdr *iph;
+	u_int32_t na;
+
+	if (!skb_make_writable(skb, sizeof(struct iphdr)))
+		return NF_DROP;
+
+	iph =3D ip_hdr(skb);
+	na  =3D remask(iph->daddr, info->addr.ip, info->mask);
+	csum_replace4(&iph->check, iph->daddr, na);
+	iph->daddr =3D na;
+	return XT_CONTINUE;
+}
+
+static unsigned int
+rawsnat_tg6(struct sk_buff *skb, const struct net_device *in,
+            const struct net_device *out, unsigned int hooknum,
+            const struct xt_target *target, const void *targinfo)
+{
+	const struct xt_rawnat_tginfo *info =3D targinfo;
+	struct ipv6hdr *iph;
+
+	if (!skb_make_writable(skb, sizeof(struct ipv6hdr)))
+		return NF_DROP;
+
+	iph =3D ipv6_hdr(skb);
+	rawnat_ipv6_mask(iph->saddr.s6_addr32, info->addr.ip6, info->mask);
+	return XT_CONTINUE;
+}
+
+static unsigned int
+rawdnat_tg6(struct sk_buff *skb, const struct net_device *in,
+            const struct net_device *out, unsigned int hooknum,
+            const struct xt_target *target, const void *targinfo)
+{
+	const struct xt_rawnat_tginfo *info =3D targinfo;
+	struct ipv6hdr *iph;
+
+	if (!skb_make_writable(skb, sizeof(struct ipv6hdr)))
+		return NF_DROP;
+
+	iph =3D ipv6_hdr(skb);
+	rawnat_ipv6_mask(iph->daddr.s6_addr32, info->addr.ip6, info->mask);
+	return XT_CONTINUE;
+}
+
+static struct xt_target rawnat_tg_reg[] __read_mostly =3D {
+	{
+		.name       =3D "RAWSNAT",
+		.revision   =3D 0,
+		.family     =3D AF_INET,
+		.table      =3D "raw",
+		.target     =3D rawsnat_tg4,
+		.targetsize =3D sizeof(struct xt_rawnat_tginfo),
+		.me         =3D THIS_MODULE,
+	},
+	{
+		.name       =3D "RAWSNAT",
+		.revision   =3D 0,
+		.family     =3D AF_INET6,
+		.table      =3D "raw",
+		.target     =3D rawsnat_tg6,
+		.targetsize =3D sizeof(struct xt_rawnat_tginfo),
+		.me         =3D THIS_MODULE,
+	},
+	{
+		.name       =3D "RAWDNAT",
+		.revision   =3D 0,
+		.family     =3D AF_INET,
+		.table      =3D "raw",
+		.target     =3D rawdnat_tg4,
+		.targetsize =3D sizeof(struct xt_rawnat_tginfo),
+		.me         =3D THIS_MODULE,
+	},
+	{
+		.name       =3D "RAWDNAT",
+		.revision   =3D 0,
+		.family     =3D AF_INET6,
+		.table      =3D "raw",
+		.target     =3D rawdnat_tg6,
+		.targetsize =3D sizeof(struct xt_rawnat_tginfo),
+		.me         =3D THIS_MODULE,
+	},
+};
+
+static int __init rawnat_tg_init(void)
+{
+	return xt_register_targets(rawnat_tg_reg, ARRAY_SIZE(rawnat_tg_reg));
+}
+
+static void __exit rawnat_tg_exit(void)
+{
+	xt_unregister_targets(rawnat_tg_reg, ARRAY_SIZE(rawnat_tg_reg));
+}
+
+module_init(rawnat_tg_init);
+module_exit(rawnat_tg_exit);
+MODULE_AUTHOR("Jan Engelhardt <jengelh@computergmbh.de>");
+MODULE_DESCRIPTION("Netfilter: conntrack-less raw NAT");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_RAWSNAT");
+MODULE_ALIAS("ipt_RAWDNAT");
+MODULE_ALIAS("ip6t_RAWSNAT");
+MODULE_ALIAS("ip6t_RAWDNAT");
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
