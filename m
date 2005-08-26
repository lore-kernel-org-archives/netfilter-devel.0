From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2/2] New ip6t_HL target
Date: Fri, 26 Aug 2005 20:32:34 +0200
Message-ID: <20050826183234.GE4226@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3199z2xwsLUuj0Hj"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David Miller <davem@davemloft.net>
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


--3199z2xwsLUuj0Hj
Content-Type: multipart/mixed; boundary="eu8nj/18vubUeVCi"
Content-Disposition: inline


--eu8nj/18vubUeVCi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,=20

please apply to net-2.6.14

Thanks!

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--eu8nj/18vubUeVCi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="50-hoplimit_target.patch"
Content-Transfer-Encoding: quoted-printable

[NETFILTER6] Add new ip6tables HOPLIMIT target

This target allows users to modify the hoplimit header field of the IPv6
header.

Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit 2accaf6a2b243cf1a4a0e50053759e01211f8b7d
tree 1ca883faa675af2c2ba597f0770cdcbf306aa760
parent cc7aa6d99761490f788fa3c61135e477172f1133
author Harald Welte <laforge@netfilter.org> Fr, 26 Aug 2005 20:30:03 +0200
committer Harald Welte <laforge@netfilter.org> Fr, 26 Aug 2005 20:30:03 +02=
00

 include/linux/netfilter_ipv6/ip6t_HL.h |   22 +++++
 net/ipv6/netfilter/Kconfig             |   21 +++++
 net/ipv6/netfilter/Makefile            |    1=20
 net/ipv6/netfilter/ip6t_HL.c           |  134 ++++++++++++++++++++++++++++=
++++
 4 files changed, 178 insertions(+), 0 deletions(-)

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
@@ -239,6 +239,27 @@ config IP6_NF_TARGET_MARK
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
+	  If you want to compile it as a module, say M here and read
+	  Documentation/modules.txt.  If unsure, say `N'.
+
+config IP6_NF_TARGET_HL_INC
+	bool  'HL (hoplimit) incrementing support (DANGEROUS)'
+	depends on IP6_NF_TARGET_HL
+	help
+	  This option enables functionality to increment and set the hoplimit
+	  value of the IPv6 header to arbitrary values.  This is EXTREMELY
+	  DANGEROUS since you can easily create immortal packets that loop
+	  forever on the network.  Please only enable if you really know
+	  that you will need it.
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
@@ -0,0 +1,134 @@
+/*=20
+ * Hop Limit modification target for ip6tables
+ * Maciej Soltysiak <solt@dns.toxicfilms.tv>
+ * Based on HW's TTL module
+ *
+ * This software is distributed under the terms of GNU GPL
+ */
+
+#include <linux/config.h>
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
+#ifndef CONFIG_IP6_NF_TARGET_HL_INC
+		if (new_hl > ip6h->hop_limit)
+			return IP6T_CONTINUE;
+#endif
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
+#ifndef CONFIG_IP6_NF_TARGET_HL_INC
+	if (info->mode =3D=3D IP6T_HL_INC) {
+		printk(KERN_WARNING "ip6t_HL: increment of hoplimit not "
+			"supported\n");
+		return 0;
+	} else if (info->mode =3D=3D IP6T_HL_SET) {
+		printk(KERN_INFO "ip6t_HL: will only set hoplimit to values "
+			"lower than current value of packet\n");
+		return 0;
+	}
+#endif
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

--eu8nj/18vubUeVCi--

--3199z2xwsLUuj0Hj
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDD2BCXaXGVTD0i/8RAuhEAJ9QbxfhXQmwSYU9YggbrUjNhlEh9ACfUIRv
sx0iEdB9d7fKEsMh3G7ezvQ=
=OhtG
-----END PGP SIGNATURE-----

--3199z2xwsLUuj0Hj--
