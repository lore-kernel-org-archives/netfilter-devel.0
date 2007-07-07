From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 11/50]: Add u32 match
Date: Sat,  7 Jul 2007 14:23:16 +0200 (MEST)
Message-ID: <20070707122232.1589.52684.sendpatchset@localhost.localdomain>
References: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Add u32 match

Along comes... xt_u32, a revamped ipt_u32 from POM-NG,
Plus:

    *	2007-06-02: added ipv6 support

    *	2007-06-05: uses kmalloc for the big buffer

    *   2007-06-05: added inversion

    *   2007-06-20: use skb_copy_bits() and get rid of the big buffer
        and lock (suggested by Pablo Neira Ayuso)

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5cb387afbe7647a31338bd7adc2711f2627ebac6
tree 8b945bb0ceb9264d3fb5c5e6a3ccd407d20488b5
parent 162018a88b4545a9a8be5b4720ae913ecd519928
author Jan Engelhardt <jengelh@gmx.de> Sat, 07 Jul 2007 12:15:20 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:15:20 +0200

 include/linux/netfilter/xt_u32.h |   40 +++++++++++
 net/netfilter/Kconfig            |   13 ++++
 net/netfilter/Makefile           |    1 
 net/netfilter/xt_u32.c           |  135 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 189 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/xt_u32.h b/include/linux/netfilter/xt_u32.h
new file mode 100644
index 0000000..9947f56
--- /dev/null
+++ b/include/linux/netfilter/xt_u32.h
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
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index a567dae..aa567fa 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
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
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index b2b5c75..3cf5b9c 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -72,4 +72,5 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_STATISTIC) += xt_statistic.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STRING) += xt_string.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_TCPMSS) += xt_tcpmss.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_PHYSDEV) += xt_physdev.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_U32) += xt_u32.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_HASHLIMIT) += xt_hashlimit.o
diff --git a/net/netfilter/xt_u32.c b/net/netfilter/xt_u32.c
new file mode 100644
index 0000000..685e311
--- /dev/null
+++ b/net/netfilter/xt_u32.c
@@ -0,0 +1,135 @@
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
+static bool u32_match_it(const struct xt_u32 *data,
+			 const struct sk_buff *skb)
+{
+	const struct xt_u32_test *ct;
+	unsigned int testind;
+	unsigned int nnums;
+	unsigned int nvals;
+	unsigned int i;
+	u_int32_t pos;
+	u_int32_t val;
+	u_int32_t at;
+	int ret;
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
+		if (skb->len < 4 || pos > skb->len - 4);
+			return false;
+
+		ret   = skb_copy_bits(skb, pos, &val, sizeof(val));
+		BUG_ON(ret < 0);
+		val   = ntohl(val);
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
+				if (at + val < at)
+					return false;
+				at += val;
+				pos = number;
+				if (at + 4 < at || skb->len < at + 4 ||
+				    pos > skb->len - at - 4)
+					return false;
+
+				ret = skb_copy_bits(skb, at + pos, &val,
+						    sizeof(val));
+				BUG_ON(ret < 0);
+				val = ntohl(val);
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
+static bool u32_match(const struct sk_buff *skb,
+		      const struct net_device *in,
+		      const struct net_device *out,
+		      const struct xt_match *match, const void *matchinfo,
+		      int offset, unsigned int protoff, bool *hotdrop)
+{
+	const struct xt_u32 *data = matchinfo;
+	bool ret;
+
+	ret = u32_match_it(data, skb);
+	return ret ^ data->invert;
+}
+
+static struct xt_match u32_reg[] = {
+	{
+		.name       = "u32",
+		.family     = AF_INET,
+		.match      = u32_match,
+		.matchsize  = sizeof(struct xt_u32),
+		.me         = THIS_MODULE,
+	},
+	{
+		.name       = "u32",
+		.family     = AF_INET6,
+		.match      = u32_match,
+		.matchsize  = sizeof(struct xt_u32),
+		.me         = THIS_MODULE,
+	},
+};
+
+static int __init xt_u32_init(void)
+{
+	return xt_register_matches(u32_reg, ARRAY_SIZE(u32_reg));
+}
+
+static void __exit xt_u32_exit(void)
+{
+	xt_unregister_matches(u32_reg, ARRAY_SIZE(u32_reg));
+}
+
+module_init(xt_u32_init);
+module_exit(xt_u32_exit);
+MODULE_AUTHOR("Jan Engelhardt <jengelh@gmx.de>");
+MODULE_DESCRIPTION("netfilter u32 match module");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_u32");
+MODULE_ALIAS("ip6t_u32");
