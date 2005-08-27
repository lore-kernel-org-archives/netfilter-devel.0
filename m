From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 1/2] New ipt_TTL target
Date: Sat, 27 Aug 2005 15:21:28 +0200
Message-ID: <20050827132128.GF4407@rama.de.gnumonks.org>
References: <20050826183151.GD4226@rama.de.gnumonks.org>
	<20050826.123018.21840974.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9Iq5ULCa7nGtWwZS"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline
In-Reply-To: <20050826.123018.21840974.davem@davemloft.net>
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


--9Iq5ULCa7nGtWwZS
Content-Type: multipart/mixed; boundary="dgjlcl3Tl+kb3YDk"
Content-Disposition: inline


--dgjlcl3Tl+kb3YDk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

here's the revised version with no extra-dangerous config option.

Please apply,

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--dgjlcl3Tl+kb3YDk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="49-ttl_target.patch"
Content-Transfer-Encoding: quoted-printable

[NETFILTER] Add new iptables TTL target

This new iptables target allows manipulation of the TTL of an IPv4 packet.

Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit 14d9d70998a369cb3806e570d653fc7b0a13a195
tree f240795aa48b1467b58c88432cdff6f1a5d0bb96
parent 2a4bde3e92bd6856a8b8ad479e90d7b0a41cda22
author Harald Welte <laforge@netfilter.org> Sa, 27 Aug 2005 15:17:27 +0200
committer Harald Welte <laforge@netfilter.org> Sa, 27 Aug 2005 15:17:27 +02=
00

 include/linux/netfilter_ipv4/ipt_TTL.h |   21 ++++++
 net/ipv4/netfilter/Kconfig             |   14 ++++
 net/ipv4/netfilter/Makefile            |    1=20
 net/ipv4/netfilter/ipt_TTL.c           |  119 ++++++++++++++++++++++++++++=
++++
 4 files changed, 155 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ipt_TTL.h b/include/linux/netfilt=
er_ipv4/ipt_TTL.h
new file mode 100644
--- /dev/null
+++ b/include/linux/netfilter_ipv4/ipt_TTL.h
@@ -0,0 +1,21 @@
+/* TTL modification module for IP tables
+ * (C) 2000 by Harald Welte <laforge@netfilter.org> */
+
+#ifndef _IPT_TTL_H
+#define _IPT_TTL_H
+
+enum {
+	IPT_TTL_SET =3D 0,
+	IPT_TTL_INC,
+	IPT_TTL_DEC
+};
+
+#define IPT_TTL_MAXMODE	IPT_TTL_DEC
+
+struct ipt_TTL_info {
+	u_int8_t	mode;
+	u_int8_t	ttl;
+};
+
+
+#endif
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -664,6 +664,20 @@ config IP_NF_TARGET_CLASSIFY
=20
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
+config IP_NF_TARGET_TTL
+	tristate  'TTL target support'
+	depends on IP_NF_MANGLE
+	help
+	  This option adds a `TTL' target, which enables the user to modify
+	  the TTL value of the IP header.
+
+	  While it is safe to decrement/lower the TTL, this target also enables
+	  functionality to increment and set the TTL value of the IP header to
+	  arbitrary values.  This is EXTREMELY DANGEROUS since you can easily
+	  create immortal packets that loop forever on the network.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config IP_NF_TARGET_CONNMARK
 	tristate  'CONNMARK target support'
 	depends on IP_NF_CONNTRACK_MARK && IP_NF_MANGLE
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -85,6 +85,7 @@ obj-$(CONFIG_IP_NF_TARGET_ULOG) +=3D ipt_U
 obj-$(CONFIG_IP_NF_TARGET_TCPMSS) +=3D ipt_TCPMSS.o
 obj-$(CONFIG_IP_NF_TARGET_NOTRACK) +=3D ipt_NOTRACK.o
 obj-$(CONFIG_IP_NF_TARGET_CLUSTERIP) +=3D ipt_CLUSTERIP.o
+obj-$(CONFIG_IP_NF_TARGET_TTL) +=3D ipt_TTL.o
=20
 # generic ARP tables
 obj-$(CONFIG_IP_NF_ARPTABLES) +=3D arp_tables.o
diff --git a/net/ipv4/netfilter/ipt_TTL.c b/net/ipv4/netfilter/ipt_TTL.c
new file mode 100644
--- /dev/null
+++ b/net/ipv4/netfilter/ipt_TTL.c
@@ -0,0 +1,119 @@
+/* TTL modification target for IP tables
+ * (C) 2000,2005 by Harald Welte <laforge@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <net/checksum.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_TTL.h>
+
+MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
+MODULE_DESCRIPTION("IP tables TTL modification module");
+MODULE_LICENSE("GPL");
+
+static unsigned int=20
+ipt_ttl_target(struct sk_buff **pskb, const struct net_device *in,=20
+		const struct net_device *out, unsigned int hooknum,=20
+		const void *targinfo, void *userinfo)
+{
+	struct iphdr *iph;
+	const struct ipt_TTL_info *info =3D targinfo;
+	u_int16_t diffs[2];
+	int new_ttl;
+
+	if (!skb_make_writable(pskb, (*pskb)->len))
+		return NF_DROP;
+
+	iph =3D (*pskb)->nh.iph;
+
+	switch (info->mode) {
+		case IPT_TTL_SET:
+			new_ttl =3D info->ttl;
+			break;
+		case IPT_TTL_INC:
+			new_ttl =3D iph->ttl + info->ttl;
+			if (new_ttl > 255)
+				new_ttl =3D 255;
+			break;
+		case IPT_TTL_DEC:
+			new_ttl =3D iph->ttl - info->ttl;
+			if (new_ttl < 0)
+				new_ttl =3D 0;
+			break;
+		default:
+			new_ttl =3D iph->ttl;
+			break;
+	}
+
+	if (new_ttl !=3D iph->ttl) {
+		diffs[0] =3D htons(((unsigned)iph->ttl) << 8) ^ 0xFFFF;
+		iph->ttl =3D new_ttl;
+		diffs[1] =3D htons(((unsigned)iph->ttl) << 8);
+		iph->check =3D csum_fold(csum_partial((char *)diffs,
+						    sizeof(diffs),
+						    iph->check^0xFFFF));
+	}
+
+	return IPT_CONTINUE;
+}
+
+static int ipt_ttl_checkentry(const char *tablename,
+		const struct ipt_entry *e,
+		void *targinfo,
+		unsigned int targinfosize,
+		unsigned int hook_mask)
+{
+	struct ipt_TTL_info *info =3D targinfo;
+
+	if (targinfosize !=3D IPT_ALIGN(sizeof(struct ipt_TTL_info))) {
+		printk(KERN_WARNING "ipt_TTL: targinfosize %u !=3D %Zu\n",
+				targinfosize,
+				IPT_ALIGN(sizeof(struct ipt_TTL_info)));
+		return 0;
+	}
+
+	if (strcmp(tablename, "mangle")) {
+		printk(KERN_WARNING "ipt_TTL: can only be called from "
+			"\"mangle\" table, not \"%s\"\n", tablename);
+		return 0;
+	}
+
+	if (info->mode > IPT_TTL_MAXMODE) {
+		printk(KERN_WARNING "ipt_TTL: invalid or unknown Mode %u\n",=20
+			info->mode);
+		return 0;
+	}
+
+	if ((info->mode !=3D IPT_TTL_SET) && (info->ttl =3D=3D 0))
+		return 0;
+
+	return 1;
+}
+
+static struct ipt_target ipt_TTL =3D {=20
+	.name 		=3D "TTL",
+	.target 	=3D ipt_ttl_target,=20
+	.checkentry 	=3D ipt_ttl_checkentry,=20
+	.me 		=3D THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	return ipt_register_target(&ipt_TTL);
+}
+
+static void __exit fini(void)
+{
+	ipt_unregister_target(&ipt_TTL);
+}
+
+module_init(init);
+module_exit(fini);

--dgjlcl3Tl+kb3YDk--

--9Iq5ULCa7nGtWwZS
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDEGjXXaXGVTD0i/8RAtzOAKCu6jkkT1Hw6Jt79W+q/vfcD19TKQCggRsu
iJRmfta16WLbXnqYnhKOwTQ=
=Wkwb
-----END PGP SIGNATURE-----

--9Iq5ULCa7nGtWwZS--
