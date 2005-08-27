From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2/2] New ip6t_HL target
Date: Sat, 27 Aug 2005 15:22:46 +0200
Message-ID: <20050827132246.GG4407@rama.de.gnumonks.org>
References: <20050826183151.GD4226@rama.de.gnumonks.org>
	<20050826.123018.21840974.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pe+tqlI1iYzVj1X/"
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


--pe+tqlI1iYzVj1X/
Content-Type: multipart/mixed; boundary="fmEUq8M7S0s+Fl0V"
Content-Disposition: inline


--fmEUq8M7S0s+Fl0V
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

--fmEUq8M7S0s+Fl0V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="50-hoplimit_target.patch"
Content-Transfer-Encoding: quoted-printable

[NETFILTER6] Add new ip6tables HOPLIMIT target

This target allows users to modify the hoplimit header field of the IPv6
header.

Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit 733e40cdff92274036b6131c50196cc3d3741555
tree f18cd65100f97e9632d10837f531ef86c7f6aee9
parent 14d9d70998a369cb3806e570d653fc7b0a13a195
author Harald Welte <laforge@netfilter.org> Sa, 27 Aug 2005 15:19:59 +0200
committer Harald Welte <laforge@netfilter.org> Sa, 27 Aug 2005 15:19:59 +02=
00

 include/linux/netfilter_ipv6/ip6t_HL.h |   22 ++++++
 net/ipv6/netfilter/Kconfig             |   16 ++++
 net/ipv6/netfilter/Makefile            |    1=20
 net/ipv6/netfilter/ip6t_HL.c           |  118 ++++++++++++++++++++++++++++=
++++
 4 files changed, 157 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter_ipv6/ip6t_HL.h b/include/linux/netfilt=
er_ipv6/ip6t_HL.h
new file mode 100644
--- /dev/null
+++ b/include/linux/netfilter_ipv6/ip6t_HL.h
@@ -0,0 +1,22 @@
+/* Hop Limit modification module for ip6tables
+ * Maciej Soltysiak <solt@dns.toxicfilms.tv>
+ * Based on HW's TTL module */
+
+#ifndef _IP6T_HL_H
+#define _IP6T_HL_H
+
+enum {
+	IP6T_HL_SET =3D 0,
+	IP6T_HL_INC,
+	IP6T_HL_DEC
+};
+
+#define IP6T_HL_MAXMODE	IP6T_HL_DEC
+
+struct ip6t_HL_info {
+	u_int8_t	mode;
+	u_int8_t	hop_limit;
+};
+
+
+#endif
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -239,6 +239,22 @@ config IP6_NF_TARGET_MARK
=20
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
+config IP6_NF_TARGET_HL
+	tristate  'HL (hoplimit) target support'
+	depends on IP6_NF_MANGLE
+	help
+	  This option adds a `HL' target, which enables the user to decrement
+	  the hoplimit value of the IPv6 header or set it to a given (lower)
+	  value.
+=09
+	  While it is safe to decrement the hoplimit value, this option also
+	  enables functionality to increment and set the hoplimit value of the
+	  IPv6 header to arbitrary values.  This is EXTREMELY DANGEROUS since
+	  you can easily create immortal packets that loop forever on the
+	  network. =20
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 #dep_tristate '  LOG target support' CONFIG_IP6_NF_TARGET_LOG $CONFIG_IP6_=
NF_IPTABLES
 config IP6_NF_RAW
 	tristate  'raw table support (required for TRACE)'
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_IP6_NF_MATCH_PHYSDEV) +=3D ip
 obj-$(CONFIG_IP6_NF_FILTER) +=3D ip6table_filter.o
 obj-$(CONFIG_IP6_NF_MANGLE) +=3D ip6table_mangle.o
 obj-$(CONFIG_IP6_NF_TARGET_MARK) +=3D ip6t_MARK.o
+obj-$(CONFIG_IP6_NF_TARGET_HL) +=3D ip6t_HL.o
 obj-$(CONFIG_IP6_NF_QUEUE) +=3D ip6_queue.o
 obj-$(CONFIG_IP6_NF_TARGET_LOG) +=3D ip6t_LOG.o
 obj-$(CONFIG_IP6_NF_RAW) +=3D ip6table_raw.o
diff --git a/net/ipv6/netfilter/ip6t_HL.c b/net/ipv6/netfilter/ip6t_HL.c
new file mode 100644
--- /dev/null
+++ b/net/ipv6/netfilter/ip6t_HL.c
@@ -0,0 +1,118 @@
+/*=20
+ * Hop Limit modification target for ip6tables
+ * Maciej Soltysiak <solt@dns.toxicfilms.tv>
+ * Based on HW's TTL module
+ *
+ * This software is distributed under the terms of GNU GPL
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_ipv6/ip6t_HL.h>
+
+MODULE_AUTHOR("Maciej Soltysiak <solt@dns.toxicfilms.tv>");
+MODULE_DESCRIPTION("IP tables Hop Limit modification module");
+MODULE_LICENSE("GPL");
+
+static unsigned int ip6t_hl_target(struct sk_buff **pskb,=20
+				   const struct net_device *in,
+				   const struct net_device *out,
+				   unsigned int hooknum,
+				   const void *targinfo, void *userinfo)
+{
+	struct ipv6hdr *ip6h;
+	const struct ip6t_HL_info *info =3D targinfo;
+	u_int16_t diffs[2];
+	int new_hl;
+
+	if (!skb_make_writable(pskb, (*pskb)->len))
+		return NF_DROP;
+
+	ip6h =3D (*pskb)->nh.ipv6h;
+
+	switch (info->mode) {
+		case IP6T_HL_SET:
+			new_hl =3D info->hop_limit;
+			break;
+		case IP6T_HL_INC:
+			new_hl =3D ip6h->hop_limit + info->hop_limit;
+			if (new_hl > 255)
+				new_hl =3D 255;
+			break;
+		case IP6T_HL_DEC:
+			new_hl =3D ip6h->hop_limit - info->hop_limit;
+			if (new_hl < 0)
+				new_hl =3D 0;
+			break;
+		default:
+			new_hl =3D ip6h->hop_limit;
+			break;
+	}
+
+	if (new_hl !=3D ip6h->hop_limit) {
+		diffs[0] =3D htons(((unsigned)ip6h->hop_limit) << 8) ^ 0xFFFF;
+		ip6h->hop_limit =3D new_hl;
+		diffs[1] =3D htons(((unsigned)ip6h->hop_limit) << 8);
+	}
+
+	return IP6T_CONTINUE;
+}
+
+static int ip6t_hl_checkentry(const char *tablename,
+		const struct ip6t_entry *e,
+		void *targinfo,
+		unsigned int targinfosize,
+		unsigned int hook_mask)
+{
+	struct ip6t_HL_info *info =3D targinfo;
+
+	if (targinfosize !=3D IP6T_ALIGN(sizeof(struct ip6t_HL_info))) {
+		printk(KERN_WARNING "ip6t_HL: targinfosize %u !=3D %Zu\n",
+				targinfosize,
+				IP6T_ALIGN(sizeof(struct ip6t_HL_info)));
+		return 0;=09
+	}=09
+
+	if (strcmp(tablename, "mangle")) {
+		printk(KERN_WARNING "ip6t_HL: can only be called from "
+			"\"mangle\" table, not \"%s\"\n", tablename);
+		return 0;
+	}
+
+	if (info->mode > IP6T_HL_MAXMODE) {
+		printk(KERN_WARNING "ip6t_HL: invalid or unknown Mode %u\n",=20
+			info->mode);
+		return 0;
+	}
+
+	if ((info->mode !=3D IP6T_HL_SET) && (info->hop_limit =3D=3D 0)) {
+		printk(KERN_WARNING "ip6t_HL: increment/decrement doesn't "
+			"make sense with value 0\n");
+		return 0;
+	}
+=09
+	return 1;
+}
+
+static struct ip6t_target ip6t_HL =3D {=20
+	.name 		=3D "HL",=20
+	.target		=3D ip6t_hl_target,=20
+	.checkentry	=3D ip6t_hl_checkentry,=20
+	.me		=3D THIS_MODULE
+};
+
+static int __init init(void)
+{
+	return ip6t_register_target(&ip6t_HL);
+}
+
+static void __exit fini(void)
+{
+	ip6t_unregister_target(&ip6t_HL);
+}
+
+module_init(init);
+module_exit(fini);

--fmEUq8M7S0s+Fl0V--

--pe+tqlI1iYzVj1X/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDEGkmXaXGVTD0i/8RAuvCAJ0RXddG7ggWScWC8FzBFvMhsHebIgCgswcE
79rH/glsUf3sRJ0vqQ3vDgM=
=BWK9
-----END PGP SIGNATURE-----

--pe+tqlI1iYzVj1X/--
