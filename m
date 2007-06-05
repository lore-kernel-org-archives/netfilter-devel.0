From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: xt_u32 20070605 (kernel)
Date: Tue, 5 Jun 2007 13:12:51 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0706051312370.20829@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0706051311220.20829@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0706051311220.20829@yvahk01.tjqt.qr>
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


Subject: Add the U32 match from POM-NG

Along comes... xt_u32, a revamped ipt_u32 from POM-NG,
Plus:

    *	2007-06-02: added ipv6 support

    *	2007-06-05: uses kmalloc for the big buffer

    *   2007-06-05: added inversion


Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 include/linux/netfilter/xt_u32.h |   37 +++++++++
 net/netfilter/Kconfig            |   13 +++
 net/netfilter/Makefile           |    1 
 net/netfilter/xt_u32.c           |  151 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 202 insertions(+)

Index: linux-2.6.22-rc4/include/linux/netfilter/xt_u32.h
===================================================================
--- /dev/null
+++ linux-2.6.22-rc4/include/linux/netfilter/xt_u32.h
@@ -0,0 +1,37 @@
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
+	uint32_t number;
+	uint8_t nextop;
+};
+
+struct xt_u32_value_element {
+	uint32_t min, max;
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
+	uint8_t nnums, nvalues;
+};
+
+struct xt_u32 {
+	struct xt_u32_test tests[XT_U32_MAXSIZE+1];
+	uint8_t ntests, invert;
+};
+
+#endif /* _XT_U32_H */
Index: linux-2.6.22-rc4/net/netfilter/Kconfig
===================================================================
--- linux-2.6.22-rc4.orig/net/netfilter/Kconfig
+++ linux-2.6.22-rc4/net/netfilter/Kconfig
@@ -635,6 +635,19 @@ config NETFILTER_XT_MATCH_TCPMSS
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
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
 	depends on NETFILTER_XTABLES && (IP6_NF_IPTABLES || IP6_NF_IPTABLES=n)
Index: linux-2.6.22-rc4/net/netfilter/Makefile
===================================================================
--- linux-2.6.22-rc4.orig/net/netfilter/Makefile
+++ linux-2.6.22-rc4/net/netfilter/Makefile
@@ -72,4 +72,5 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_STATISTI
 obj-$(CONFIG_NETFILTER_XT_MATCH_STRING) += xt_string.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_TCPMSS) += xt_tcpmss.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_PHYSDEV) += xt_physdev.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_U32) += xt_u32.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_HASHLIMIT) += xt_hashlimit.o
Index: linux-2.6.22-rc4/net/netfilter/xt_u32.c
===================================================================
--- /dev/null
+++ linux-2.6.22-rc4/net/netfilter/xt_u32.c
@@ -0,0 +1,151 @@
+/*
+ *	xt_u32 - kernel module to match u32 packet content
+ *
+ *	Original author: Don Cohen <don@isis.cs3-inc.com>
+ *	© Jan Engelhardt <jengelh@gmx.de>, 2007
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
+/* This is slow, but it's simple. --RR */
+
+static DEFINE_SPINLOCK(xt_u32_lock);
+static unsigned int xt_u32_buffer_size = 64 * 1024;
+static char *xt_u32_buffer;
+
+static bool xt_u32_match_it(const struct xt_u32 *data,
+			    const struct sk_buff *skb)
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
+	base = head = skb_header_pointer(skb, 0, skb->len, xt_u32_buffer);
+	BUG_ON(head == NULL);
+
+	/*
+	 * Small example: "0 >> 28 == 4 && 8 & 0xFF0000 >> 16 = 6, 17"
+	 * (=IPv4 and (TCP or UDP)). Outer loop runs over the "&&" operands.
+	 */
+	for (testind = 0; testind < data->ntests; ++testind) {
+		ct  = &data->tests[testind];
+		at  = 0;
+		pos = ct->location[0].number;
+
+		if (at + pos + 3 > skb->len || at + pos < 0)
+			return false;
+
+		val = (base[pos] << 24) | (base[pos+1] << 16) |
+		      (base[pos+2] << 8) | base[pos+3];
+		nnums = ct->nnums;
+
+		/* Inner loop runs over "&", "<<", ">>" and "@" operands */
+		for (i = 1; i < nnums; ++i) {
+			u_int32_t number = ct->location[i].number;
+			switch (ct->location[i].nextop) {
+			case XT_U32_AND:
+				val &= number;
+				break;
+			case XT_U32_LEFTSH:
+				val <<= number;
+				break;
+			case XT_U32_RIGHTSH:
+				val >>= number;
+				break;
+			case XT_U32_AT:
+				at += val;
+				pos = number;
+				if (at + pos + 3 > skb->len || at + pos < 0)
+					return false;
+
+				val = (base[at+pos] << 24) |
+				      (base[at+pos+1] << 16) |
+				      (base[at+pos+2] << 8) | base[at+pos+3];
+				break;
+			}
+		}
+
+		/* Run over the "," and ":" operands */
+		nvals = ct->nvalues;
+		for (i = 0; i < nvals; ++i)
+			if (ct->value[i].min <= val && val <= ct->value[i].max)
+				break;
+
+		if (i >= ct->nvalues)
+			return false;
+	}
+
+	return true;
+}
+
+static bool xt_u32_match(const struct sk_buff *skb,
+			 const struct net_device *in,
+			 const struct net_device *out,
+			 const struct xt_match *match, const void *matchinfo,
+			 int offset, unsigned int protoff, bool *hotdrop)
+{
+	const struct xt_u32 *data = matchinfo;
+	bool ret;
+
+	spin_lock_bh(&xt_u32_lock);
+	ret = xt_u32_match_it(data, skb);
+	spin_unlock_bh(&xt_u32_lock);
+
+	return ret ^ data->invert;
+}
+
+static struct xt_match xt_u32_reg[] = {
+	{
+		.name       = "u32",
+		.family     = AF_INET,
+		.match      = xt_u32_match,
+		.matchsize  = sizeof(struct xt_u32),
+		.me         = THIS_MODULE,
+	},
+	{
+		.name       = "u32",
+		.family     = AF_INET6,
+		.match      = xt_u32_match,
+		.matchsize  = sizeof(struct xt_u32),
+		.me         = THIS_MODULE,
+	},
+};
+
+static int __init xt_u32_init(void)
+{
+	xt_u32_buffer = kmalloc(xt_u32_buffer_size, GFP_KERNEL);
+	if (xt_u32_buffer == NULL)
+		return -ENOMEM;
+	return xt_register_matches(xt_u32_reg, ARRAY_SIZE(xt_u32_reg));
+}
+
+static void __exit xt_u32_exit(void)
+{
+	xt_unregister_matches(xt_u32_reg, ARRAY_SIZE(xt_u32_reg));
+	kfree(xt_u32_buffer);
+	return;
+}
+
+module_init(xt_u32_init);
+module_exit(xt_u32_exit);
+module_param_named(buffer_size, xt_u32_buffer_size, uint, S_IRUGO);
+MODULE_PARM_DESC(buffer_size, "Buffer size to hold a packet "
+	"(default: 65536 bytes)");
+MODULE_AUTHOR("Don Cohen <don@isis.cs3-inc.com>");
+MODULE_DESCRIPTION("netfilter u32 match module");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_u32");
+MODULE_ALIAS("ip6t_u32");
