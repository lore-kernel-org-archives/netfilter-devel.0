From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: xt_u32 kernel 20070620
Date: Wed, 20 Jun 2007 00:39:07 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706200037570.5731@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-699020219-715702319-1182292747=:5731"
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---699020219-715702319-1182292747=:5731
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


Subject: Add the U32 match from POM-NG

Along comes... xt_u32, a revamped ipt_u32 from POM-NG,
Plus ipv6 support, kmalloc the buffer, inversion support.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 include/linux/netfilter/xt_u32.h |   40 ++++++++++
 net/netfilter/Kconfig            |   13 +++
 net/netfilter/Makefile           |    1=20
 net/netfilter/xt_u32.c           |  148 ++++++++++++++++++++++++++++++++=
+++++++
 4 files changed, 202 insertions(+)

Index: linux-2.6.22-rc4/include/linux/netfilter/xt_u32.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ linux-2.6.22-rc4/include/linux/netfilter/xt_u32.h
@@ -0,0 +1,40 @@
+#ifndef _XT_U32_H
+#define _XT_U32_H 1
+
+enum xt_u32_ops {
+	XT_U32_AND,
+	XT_U32_LEFTSH,
+	XT_U32_RIGHTSH,
+	XT_U32_AT,
+};
+
+struct xt_u32_location_element {
+	u_int32_t number;
+	u_int8_t nextop;
+};
+
+struct xt_u32_value_element {
+	u_int32_t min;
+	u_int32_t max;
+};
+
+/*
+ * Any way to allow for an arbitrary number of elements?
+ * For now, I settle with a limit of 10 each.
+ */
+#define XT_U32_MAXSIZE 10
+
+struct xt_u32_test {
+	struct xt_u32_location_element location[XT_U32_MAXSIZE+1];
+	struct xt_u32_value_element value[XT_U32_MAXSIZE+1];
+	u_int8_t nnums;
+	u_int8_t nvalues;
+};
+
+struct xt_u32 {
+	struct xt_u32_test tests[XT_U32_MAXSIZE+1];
+	u_int8_t ntests;
+	u_int8_t invert;
+};
+
+#endif /* _XT_U32_H */
Index: linux-2.6.22-rc4/net/netfilter/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.22-rc4.orig/net/netfilter/Kconfig
+++ linux-2.6.22-rc4/net/netfilter/Kconfig
@@ -635,6 +635,19 @@ config NETFILTER_XT_MATCH_TCPMSS
=20
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
+config NETFILTER_XT_MATCH_U32
+	tristate '"u32" match support'
+	depends on NETFILTER_XTABLES
+	---help---
+	  u32 allows you to extract quantities of up to 4 bytes from a packet,
+	  AND them with specified masks, shift them by specified amounts and
+	  test whether the results are in any of a set of specified ranges.
+	  The specification of what to extract is general enough to skip over
+	  headers with lengths stored in the packet, as in IP or TCP header
+	  lengths.
+
+	  Details and examples are in the kernel module source.
+
 config NETFILTER_XT_MATCH_HASHLIMIT
 	tristate '"hashlimit" match support'
 	depends on NETFILTER_XTABLES && (IP6_NF_IPTABLES || IP6_NF_IPTABLES=3Dn=
)
Index: linux-2.6.22-rc4/net/netfilter/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.22-rc4.orig/net/netfilter/Makefile
+++ linux-2.6.22-rc4/net/netfilter/Makefile
@@ -72,4 +72,5 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_STATISTI
 obj-$(CONFIG_NETFILTER_XT_MATCH_STRING) +=3D xt_string.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_TCPMSS) +=3D xt_tcpmss.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_PHYSDEV) +=3D xt_physdev.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_U32) +=3D xt_u32.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_HASHLIMIT) +=3D xt_hashlimit.o
Index: linux-2.6.22-rc4/net/netfilter/xt_u32.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ linux-2.6.22-rc4/net/netfilter/xt_u32.c
@@ -0,0 +1,148 @@
+/*
+ *	xt_u32 - kernel module to match u32 packet content
+ *
+ *	Original author: Don Cohen <don@isis.cs3-inc.com>
+ *	=C2=A9 Jan Engelhardt <jengelh@gmx.de>, 2007
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/spinlock.h>
+#include <linux/skbuff.h>
+#include <linux/types.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_u32.h>
+
+#define XT_U32_BUFFER_SIZE	(64 * 1024)
+
+/* This is slow, but it's simple. --RR */
+
+static DEFINE_SPINLOCK(u32_lock);
+static char *u32_buffer;
+
+static bool u32_match_it(const struct xt_u32 *data,
+			 const struct sk_buff *skb)
+{
+	const struct xt_u32_test *ct;
+	const unsigned char *base;
+	const unsigned char *head;
+	unsigned int testind;
+	unsigned int nnums;
+	unsigned int nvals;
+	unsigned int i;
+	u_int32_t pos;
+	u_int32_t val;
+	u_int32_t at;
+
+	base =3D head =3D skb_header_pointer(skb, 0, skb->len, u32_buffer);
+	BUG_ON(head =3D=3D NULL);
+
+	/*
+	 * Small example: "0 >> 28 =3D=3D 4 && 8 & 0xFF0000 >> 16 =3D 6, 17"
+	 * (=3DIPv4 and (TCP or UDP)). Outer loop runs over the "&&" operands.
+	 */
+	for (testind =3D 0; testind < data->ntests; ++testind) {
+		ct  =3D &data->tests[testind];
+		at  =3D 0;
+		pos =3D ct->location[0].number;
+
+		if (at + pos + 3 > skb->len || at + pos < 0)
+			return false;
+
+		val =3D (base[pos] << 24) | (base[pos+1] << 16) |
+		      (base[pos+2] << 8) | base[pos+3];
+		nnums =3D ct->nnums;
+
+		/* Inner loop runs over "&", "<<", ">>" and "@" operands */
+		for (i =3D 1; i < nnums; ++i) {
+			u_int32_t number =3D ct->location[i].number;
+			switch (ct->location[i].nextop) {
+			case XT_U32_AND:
+				val &=3D number;
+				break;
+			case XT_U32_LEFTSH:
+				val <<=3D number;
+				break;
+			case XT_U32_RIGHTSH:
+				val >>=3D number;
+				break;
+			case XT_U32_AT:
+				at +=3D val;
+				pos =3D number;
+				if (at + pos + 3 > skb->len || at + pos < 0)
+					return false;
+
+				val =3D (base[at+pos] << 24) |
+				      (base[at+pos+1] << 16) |
+				      (base[at+pos+2] << 8) | base[at+pos+3];
+				break;
+			}
+		}
+
+		/* Run over the "," and ":" operands */
+		nvals =3D ct->nvalues;
+		for (i =3D 0; i < nvals; ++i)
+			if (ct->value[i].min <=3D val && val <=3D ct->value[i].max)
+				break;
+
+		if (i >=3D ct->nvalues)
+			return false;
+	}
+
+	return true;
+}
+
+static bool u32_match(const struct sk_buff *skb,
+		      const struct net_device *in,
+		      const struct net_device *out,
+		      const struct xt_match *match, const void *matchinfo,
+		      int offset, unsigned int protoff, bool *hotdrop)
+{
+	const struct xt_u32 *data =3D matchinfo;
+	bool ret;
+
+	spin_lock_bh(&u32_lock);
+	ret =3D u32_match_it(data, skb);
+	spin_unlock_bh(&u32_lock);
+
+	return ret ^ data->invert;
+}
+
+static struct xt_match u32_reg[] =3D {
+	{
+		.name       =3D "u32",
+		.family     =3D AF_INET,
+		.match      =3D u32_match,
+		.matchsize  =3D sizeof(struct xt_u32),
+		.me         =3D THIS_MODULE,
+	},
+	{
+		.name       =3D "u32",
+		.family     =3D AF_INET6,
+		.match      =3D u32_match,
+		.matchsize  =3D sizeof(struct xt_u32),
+		.me         =3D THIS_MODULE,
+	},
+};
+
+static int __init xt_u32_init(void)
+{
+	u32_buffer =3D kmalloc(XT_U32_BUFFER_SIZE, GFP_KERNEL);
+	if (u32_buffer =3D=3D NULL)
+		return -ENOMEM;
+	return xt_register_matches(u32_reg, ARRAY_SIZE(u32_reg));
+}
+
+static void __exit xt_u32_exit(void)
+{
+	xt_unregister_matches(u32_reg, ARRAY_SIZE(u32_reg));
+	kfree(u32_buffer);
+}
+
+module_init(xt_u32_init);
+module_exit(xt_u32_exit);
+MODULE_AUTHOR("Don Cohen <don@isis.cs3-inc.com>");
+MODULE_DESCRIPTION("netfilter u32 match module");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_u32");
+MODULE_ALIAS("ip6t_u32");
---699020219-715702319-1182292747=:5731--
