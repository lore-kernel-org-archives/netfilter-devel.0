From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [PATCH] IPv6 port of the random match.
Date: Wed, 30 Apr 2003 17:08:15 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0304301706270.18169@dns.toxicfilms.tv>
References: <Pine.LNX.4.51.0304301648010.15553@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-23717851-1495294138-1051715295=:18169"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.51.0304301648010.15553@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---23717851-1495294138-1051715295=:18169
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hi,

this is an IPv6 port of the Fabrice Marie's random match.

Regards,
Maciej Soltysiak

diff -Nru netfilter.orig/patch-o-matic/base/random6.patch.ipv6 netfilter/patch-o-matic/base/random6.patch.ipv6
--- netfilter.orig/patch-o-matic/base/random6.patch.ipv6	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/random6.patch.ipv6	2003-04-30 16:59:54.000000000 +0200
@@ -0,0 +1,116 @@
+diff -Nru linux.orig/include/linux/netfilter_ipv6/ip6t_random.h linux/include/linux/netfilter_ipv6/ip6t_random.h
+--- linux.orig/include/linux/netfilter_ipv6/ip6t_random.h	1970-01-01 01:00:00.000000000 +0100
++++ linux/include/linux/netfilter_ipv6/ip6t_random.h	2003-04-30 16:06:42.000000000 +0200
+@@ -0,0 +1,11 @@
++#ifndef _IP6T_RAND_H
++#define _IP6T_RAND_H
++
++#include <linux/param.h>
++#include <linux/types.h>
++
++struct ip6t_rand_info {
++	u_int8_t average;
++};
++
++#endif /*_IP6T_RAND_H*/
+diff -Nru linux.orig/net/ipv6/netfilter/ip6t_random.c linux/net/ipv6/netfilter/ip6t_random.c
+--- linux.orig/net/ipv6/netfilter/ip6t_random.c	1970-01-01 01:00:00.000000000 +0100
++++ linux/net/ipv6/netfilter/ip6t_random.c	2003-04-30 16:12:13.000000000 +0200
+@@ -0,0 +1,97 @@
++/*
++  This is a module which is used for a "random" match support.
++  This file is distributed under the terms of the GNU General Public
++  License (GPL). Copies of the GPL can be obtained from:
++     ftp://prep.ai.mit.edu/pub/gnu/GPL
++
++  2001-10-14 Fabrice MARIE <fabrice@netfilter.org> : initial implementation.
++  2003-04-30 Maciej Soltysiak <solt@dns.toxicfilms.tv> : IPv6 Port
++*/
++
++#include <linux/module.h>
++#include <linux/skbuff.h>
++#include <linux/ip.h>
++#include <linux/random.h>
++#include <net/tcp.h>
++#include <linux/spinlock.h>
++#include <linux/netfilter_ipv6/ip6_tables.h>
++#include <linux/netfilter_ipv6/ip6t_random.h>
++
++MODULE_LICENSE("GPL");
++
++static int
++ip6t_rand_match(const struct sk_buff *pskb,
++	       const struct net_device *in,
++	       const struct net_device *out,
++	       const void *matchinfo,
++	       int offset,
++	       const void *hdr,
++	       u_int16_t datalen,
++	       int *hotdrop)
++{
++	/* Parameters from userspace */
++	const struct ip6t_rand_info *info = matchinfo;
++	u_int8_t random_number;
++
++	/* get 1 random number from the kernel random number generation routine */
++	get_random_bytes((void *)(&random_number), 1);
++
++	/* Do we match ? */
++	if (random_number <= info->average)
++		return 1;
++	else
++		return 0;
++}
++
++static int
++ip6t_rand_checkentry(const char *tablename,
++		   const struct ip6t_ip6 *e,
++		   void *matchinfo,
++		   unsigned int matchsize,
++		   unsigned int hook_mask)
++{
++	/* Parameters from userspace */
++	const struct ip6t_rand_info *info = matchinfo;
++
++	if (matchsize != IP6T_ALIGN(sizeof(struct ip6t_rand_info))) {
++		printk("ip6t_random: matchsize %u != %u\n", matchsize,
++		       IP6T_ALIGN(sizeof(struct ip6t_rand_info)));
++		return 0;
++	}
++
++	/* must be  1 <= average % <= 99 */
++	/* 1  x 2.55 = 2   */
++	/* 99 x 2.55 = 252 */
++	if ((info->average < 2) || (info->average > 252)) {
++		printk("ip6t_random:  invalid average %u\n", info->average);
++		return 0;
++	}
++
++	return 1;
++}
++
++static struct ip6t_match ip6t_rand_reg = {
++	{NULL, NULL},
++	"random",
++	ip6t_rand_match,
++	ip6t_rand_checkentry,
++	NULL,
++	THIS_MODULE };
++
++static int __init init(void)
++{
++	if (ip6t_register_match(&ip6t_rand_reg))
++		return -EINVAL;
++
++	printk("ip6t_random match loaded\n");
++	return 0;
++}
++
++static void __exit fini(void)
++{
++	ip6t_unregister_match(&ip6t_rand_reg);
++	printk("ip6t_random match unloaded\n");
++}
++
++module_init(init);
++module_exit(fini);
diff -Nru netfilter.orig/patch-o-matic/base/random6.patch.ipv6.config.in netfilter/patch-o-matic/base/random6.patch.ipv6.config.in
--- netfilter.orig/patch-o-matic/base/random6.patch.ipv6.config.in	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/random6.patch.ipv6.config.in	2003-04-30 17:02:00.000000000 +0200
@@ -0,0 +1,2 @@
+  dep_tristate '  MAC address match support' CONFIG_IP6_NF_MATCH_MAC $CONFIG_IP6_NF_IPTABLES
+  dep_tristate '  Random match support' CONFIG_IP6_NF_MATCH_RANDOM $CONFIG_IP6_NF_IPTABLES
diff -Nru netfilter.orig/patch-o-matic/base/random6.patch.ipv6.configure.help netfilter/patch-o-matic/base/random6.patch.ipv6.configure.help
--- netfilter.orig/patch-o-matic/base/random6.patch.ipv6.configure.help	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/random6.patch.ipv6.configure.help	2003-04-30 17:03:24.000000000 +0200
@@ -0,0 +1,10 @@
+CONFIG_IP6_NF_MATCH_MAC
+Random match support
+CONFIG_IP6_NF_MATCH_RANDOM
+  This option adds a `random' match,
+  which allow you to match packets randomly
+  following a given probability.
+
+  If you want to compile it as a module, say M here and read
+  Documentation/modules.txt.  If unsure, say `N'.
+
diff -Nru netfilter.orig/patch-o-matic/base/random6.patch.ipv6.help netfilter/patch-o-matic/base/random6.patch.ipv6.help
--- netfilter.orig/patch-o-matic/base/random6.patch.ipv6.help	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/random6.patch.ipv6.help	2003-04-30 17:01:34.000000000 +0200
@@ -0,0 +1,14 @@
+Author: Fabrice MARIE <fabrice@netfilter.org>
+Ported: Maciej Soltysiak <solt@dns.toxicfilms.tv>
+Status: Works For Me.
+
+This option adds CONFIG_IP6_NF_MATCH_RANDOM,
+which allow you to match packets randomly
+following a given probability.
+
+Suppported options are:
+
+[--average] 	percent	will match randomly packets with a probability of 'percent'
+		default is 50%
+
+This is an IPv6 port from IPv4 module.
diff -Nru netfilter.orig/patch-o-matic/base/random6.patch.ipv6.makefile netfilter/patch-o-matic/base/random6.patch.ipv6.makefile
--- netfilter.orig/patch-o-matic/base/random6.patch.ipv6.makefile	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/random6.patch.ipv6.makefile	2003-04-30 17:02:11.000000000 +0200
@@ -0,0 +1,3 @@
+obj-$(CONFIG_IP6_NF_TARGET_LOG) += ip6t_LOG.o
+
+obj-$(CONFIG_IP6_NF_MATCH_RANDOM) += ip6t_random.o
diff -Nru netfilter.orig/userspace/extensions/Makefile netfilter/userspace/extensions/Makefile
--- netfilter.orig/userspace/extensions/Makefile	2003-04-30 16:47:26.000000000 +0200
+++ netfilter/userspace/extensions/Makefile	2003-04-30 16:54:52.000000000 +0200
@@ -6,7 +6,7 @@
 # package (HW)
 #
 PF_EXT_SLIB:=ah conntrack dscp ecn esp helper icmp iplimit length limit mac mark multiport owner physdev pkttype rpc standard state tcp tcpmss tos ttl udp unclean DNAT DSCP ECN LOG MARK MASQUERADE MIRROR REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS TTL ULOG
-PF6_EXT_SLIB:=eui64 hl icmpv6 length nth limit mac mark multiport owner standard tcp udp HL LOG MARK
+PF6_EXT_SLIB:=eui64 hl icmpv6 random length nth limit mac mark multiport owner standard tcp udp HL LOG MARK

 # Optionals
 PF_EXT_SLIB_OPTS:=$(foreach T,$(wildcard extensions/.*-test),$(shell KERNEL_DIR=$(KERNEL_DIR) $(T)))
diff -Nru netfilter.orig/userspace/extensions/libip6t_random.c netfilter/userspace/extensions/libip6t_random.c
--- netfilter.orig/userspace/extensions/libip6t_random.c	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/userspace/extensions/libip6t_random.c	2003-04-30 16:51:24.000000000 +0200
@@ -0,0 +1,152 @@
+/*
+   Shared library add-on to iptables to add match support for random match.
+
+   This file is distributed under the terms of the GNU General Public
+   License (GPL). Copies of the GPL can be obtained from:
+   ftp://prep.ai.mit.edu/pub/gnu/GPL
+
+   2001-10-14 Fabrice MARIE <fabrice@netfilter.org> : initial development.
+   2003-04-30 Maciej Soltysiak <solt@dns.toxicfilms.tv> : IPv6 port.
+*/
+
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <syslog.h>
+#include <getopt.h>
+#include <ip6tables.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_ipv6/ip6t_random.h>
+
+/**
+ * The kernel random routing returns numbers between 0 and 255.
+ * To ease the task of the user in choosing the probability
+ * of matching, we want him to be able to use percentages.
+ * Therefore we have to accept numbers in percentage here,
+ * turn them into number between 0 and 255 for the kernel module,
+ * and turn them back to percentages when we print/save
+ * the rule.
+ */
+
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf(
+"random v%s options:\n"
+"  [--average]     percent      The probability in percentage of the match\n"
+"                               If ommited, a probability of 50%% percent is set.\n"
+"                               Percentage must be within : 1 <= percent <= 99.\n\n",
+IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ "average", 1, 0, '1' },
+	{ 0 }
+};
+
+/* Initialize the target. */
+static void
+init(struct ip6t_entry_match *m, unsigned int *nfcache)
+{
+	struct ip6t_rand_info *randinfo = (struct ip6t_rand_info *)(m)->data;
+	*nfcache |= NFC_UNKNOWN;
+
+	/* We assign the average to be 50 which is our default value */
+	/* 50 * 2.55 = 128 */
+	randinfo->average = 128;
+}
+
+#define IP6T_RAND_OPT_AVERAGE	0x01
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ip6t_entry *entry,
+      unsigned int *nfcache,
+      struct ip6t_entry_match **match)
+{
+	struct ip6t_rand_info *randinfo = (struct ip6t_rand_info *)(*match)->data;
+	unsigned int num;
+
+	switch (c) {
+	case '1':
+		/* check for common mistakes... */
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify ! --average");
+		if (*flags & IP6T_RAND_OPT_AVERAGE)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --average twice");
+
+		/* Remember, this function will interpret a leading 0 to be
+		   Octal, a leading 0x to be hexdecimal... */
+                if (string_to_number(optarg, 1, 99, &num) == -1 || num < 1)
+                        exit_error(PARAMETER_PROBLEM,
+                                   "bad --average `%s', must be between 1 and 99", optarg);
+
+		/* assign the values */
+		randinfo->average = (int)(num * 2.55);
+		*flags |= IP6T_RAND_OPT_AVERAGE;
+		break;
+	default:
+		return 0;
+	}
+	return 1;
+}
+
+/* Final check; nothing. */
+static void final_check(unsigned int flags)
+{
+}
+
+/* Prints out the targinfo. */
+static void
+print(const struct ip6t_ip6 *ip,
+      const struct ip6t_entry_match *match,
+      int numeric)
+{
+	const struct ip6t_rand_info *randinfo
+		= (const struct ip6t_rand_info *)match->data;
+	div_t result = div((randinfo->average*100), 255);
+	if (result.rem > 127)  /* round up... */
+		++result.quot;
+
+	printf(" random %u%% ", result.quot);
+}
+
+/* Saves the union ip6t_targinfo in parsable form to stdout. */
+static void
+save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
+{
+	const struct ip6t_rand_info *randinfo
+		= (const struct ip6t_rand_info *)match->data;
+	div_t result = div((randinfo->average *100), 255);
+	if (result.rem > 127)  /* round up... */
+		++result.quot;
+
+	printf("--average %u ", result.quot);
+}
+
+struct ip6tables_match rand_match
+= { NULL,
+    "random",
+    IPTABLES_VERSION,
+    IP6T_ALIGN(sizeof(struct ip6t_rand_info)),
+    IP6T_ALIGN(sizeof(struct ip6t_rand_info)),
+    &help,
+    &init,
+    &parse,
+    &final_check,
+    &print,
+    &save,
+    opts
+};
+
+void _init(void)
+{
+	register_match6(&rand_match);
+}
---23717851-1495294138-1051715295=:18169
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=random
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.51.0304301708150.18169@dns.toxicfilms.tv>
Content-Description: random6 match
Content-Disposition: attachment; filename=random

ZGlmZiAtTnJ1IG5ldGZpbHRlci5vcmlnL3BhdGNoLW8tbWF0aWMvYmFzZS9y
YW5kb202LnBhdGNoLmlwdjYgbmV0ZmlsdGVyL3BhdGNoLW8tbWF0aWMvYmFz
ZS9yYW5kb202LnBhdGNoLmlwdjYNCi0tLSBuZXRmaWx0ZXIub3JpZy9wYXRj
aC1vLW1hdGljL2Jhc2UvcmFuZG9tNi5wYXRjaC5pcHY2CTE5NzAtMDEtMDEg
MDE6MDA6MDAuMDAwMDAwMDAwICswMTAwDQorKysgbmV0ZmlsdGVyL3BhdGNo
LW8tbWF0aWMvYmFzZS9yYW5kb202LnBhdGNoLmlwdjYJMjAwMy0wNC0zMCAx
Njo1OTo1NC4wMDAwMDAwMDAgKzAyMDANCkBAIC0wLDAgKzEsMTE2IEBADQor
ZGlmZiAtTnJ1IGxpbnV4Lm9yaWcvaW5jbHVkZS9saW51eC9uZXRmaWx0ZXJf
aXB2Ni9pcDZ0X3JhbmRvbS5oIGxpbnV4L2luY2x1ZGUvbGludXgvbmV0Zmls
dGVyX2lwdjYvaXA2dF9yYW5kb20uaA0KKy0tLSBsaW51eC5vcmlnL2luY2x1
ZGUvbGludXgvbmV0ZmlsdGVyX2lwdjYvaXA2dF9yYW5kb20uaAkxOTcwLTAx
LTAxIDAxOjAwOjAwLjAwMDAwMDAwMCArMDEwMA0KKysrKyBsaW51eC9pbmNs
dWRlL2xpbnV4L25ldGZpbHRlcl9pcHY2L2lwNnRfcmFuZG9tLmgJMjAwMy0w
NC0zMCAxNjowNjo0Mi4wMDAwMDAwMDAgKzAyMDANCitAQCAtMCwwICsxLDEx
IEBADQorKyNpZm5kZWYgX0lQNlRfUkFORF9IDQorKyNkZWZpbmUgX0lQNlRf
UkFORF9IDQorKw0KKysjaW5jbHVkZSA8bGludXgvcGFyYW0uaD4NCisrI2lu
Y2x1ZGUgPGxpbnV4L3R5cGVzLmg+DQorKw0KKytzdHJ1Y3QgaXA2dF9yYW5k
X2luZm8gew0KKysJdV9pbnQ4X3QgYXZlcmFnZTsNCisrfTsNCisrDQorKyNl
bmRpZiAvKl9JUDZUX1JBTkRfSCovDQorZGlmZiAtTnJ1IGxpbnV4Lm9yaWcv
bmV0L2lwdjYvbmV0ZmlsdGVyL2lwNnRfcmFuZG9tLmMgbGludXgvbmV0L2lw
djYvbmV0ZmlsdGVyL2lwNnRfcmFuZG9tLmMNCistLS0gbGludXgub3JpZy9u
ZXQvaXB2Ni9uZXRmaWx0ZXIvaXA2dF9yYW5kb20uYwkxOTcwLTAxLTAxIDAx
OjAwOjAwLjAwMDAwMDAwMCArMDEwMA0KKysrKyBsaW51eC9uZXQvaXB2Ni9u
ZXRmaWx0ZXIvaXA2dF9yYW5kb20uYwkyMDAzLTA0LTMwIDE2OjEyOjEzLjAw
MDAwMDAwMCArMDIwMA0KK0BAIC0wLDAgKzEsOTcgQEANCisrLyoNCisrICBU
aGlzIGlzIGEgbW9kdWxlIHdoaWNoIGlzIHVzZWQgZm9yIGEgInJhbmRvbSIg
bWF0Y2ggc3VwcG9ydC4NCisrICBUaGlzIGZpbGUgaXMgZGlzdHJpYnV0ZWQg
dW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMNCisr
ICBMaWNlbnNlIChHUEwpLiBDb3BpZXMgb2YgdGhlIEdQTCBjYW4gYmUgb2J0
YWluZWQgZnJvbToNCisrICAgICBmdHA6Ly9wcmVwLmFpLm1pdC5lZHUvcHVi
L2dudS9HUEwNCisrDQorKyAgMjAwMS0xMC0xNCBGYWJyaWNlIE1BUklFIDxm
YWJyaWNlQG5ldGZpbHRlci5vcmc+IDogaW5pdGlhbCBpbXBsZW1lbnRhdGlv
bi4NCisrICAyMDAzLTA0LTMwIE1hY2llaiBTb2x0eXNpYWsgPHNvbHRAZG5z
LnRveGljZmlsbXMudHY+IDogSVB2NiBQb3J0DQorKyovDQorKw0KKysjaW5j
bHVkZSA8bGludXgvbW9kdWxlLmg+DQorKyNpbmNsdWRlIDxsaW51eC9za2J1
ZmYuaD4NCisrI2luY2x1ZGUgPGxpbnV4L2lwLmg+DQorKyNpbmNsdWRlIDxs
aW51eC9yYW5kb20uaD4NCisrI2luY2x1ZGUgPG5ldC90Y3AuaD4NCisrI2lu
Y2x1ZGUgPGxpbnV4L3NwaW5sb2NrLmg+DQorKyNpbmNsdWRlIDxsaW51eC9u
ZXRmaWx0ZXJfaXB2Ni9pcDZfdGFibGVzLmg+DQorKyNpbmNsdWRlIDxsaW51
eC9uZXRmaWx0ZXJfaXB2Ni9pcDZ0X3JhbmRvbS5oPg0KKysNCisrTU9EVUxF
X0xJQ0VOU0UoIkdQTCIpOw0KKysNCisrc3RhdGljIGludA0KKytpcDZ0X3Jh
bmRfbWF0Y2goY29uc3Qgc3RydWN0IHNrX2J1ZmYgKnBza2IsDQorKwkgICAg
ICAgY29uc3Qgc3RydWN0IG5ldF9kZXZpY2UgKmluLA0KKysJICAgICAgIGNv
bnN0IHN0cnVjdCBuZXRfZGV2aWNlICpvdXQsDQorKwkgICAgICAgY29uc3Qg
dm9pZCAqbWF0Y2hpbmZvLA0KKysJICAgICAgIGludCBvZmZzZXQsDQorKwkg
ICAgICAgY29uc3Qgdm9pZCAqaGRyLA0KKysJICAgICAgIHVfaW50MTZfdCBk
YXRhbGVuLA0KKysJICAgICAgIGludCAqaG90ZHJvcCkNCisrew0KKysJLyog
UGFyYW1ldGVycyBmcm9tIHVzZXJzcGFjZSAqLw0KKysJY29uc3Qgc3RydWN0
IGlwNnRfcmFuZF9pbmZvICppbmZvID0gbWF0Y2hpbmZvOw0KKysJdV9pbnQ4
X3QgcmFuZG9tX251bWJlcjsNCisrDQorKwkvKiBnZXQgMSByYW5kb20gbnVt
YmVyIGZyb20gdGhlIGtlcm5lbCByYW5kb20gbnVtYmVyIGdlbmVyYXRpb24g
cm91dGluZSAqLw0KKysJZ2V0X3JhbmRvbV9ieXRlcygodm9pZCAqKSgmcmFu
ZG9tX251bWJlciksIDEpOw0KKysNCisrCS8qIERvIHdlIG1hdGNoID8gKi8N
CisrCWlmIChyYW5kb21fbnVtYmVyIDw9IGluZm8tPmF2ZXJhZ2UpDQorKwkJ
cmV0dXJuIDE7DQorKwllbHNlDQorKwkJcmV0dXJuIDA7DQorK30NCisrDQor
K3N0YXRpYyBpbnQNCisraXA2dF9yYW5kX2NoZWNrZW50cnkoY29uc3QgY2hh
ciAqdGFibGVuYW1lLA0KKysJCSAgIGNvbnN0IHN0cnVjdCBpcDZ0X2lwNiAq
ZSwNCisrCQkgICB2b2lkICptYXRjaGluZm8sDQorKwkJICAgdW5zaWduZWQg
aW50IG1hdGNoc2l6ZSwNCisrCQkgICB1bnNpZ25lZCBpbnQgaG9va19tYXNr
KQ0KKyt7DQorKwkvKiBQYXJhbWV0ZXJzIGZyb20gdXNlcnNwYWNlICovDQor
Kwljb25zdCBzdHJ1Y3QgaXA2dF9yYW5kX2luZm8gKmluZm8gPSBtYXRjaGlu
Zm87DQorKw0KKysJaWYgKG1hdGNoc2l6ZSAhPSBJUDZUX0FMSUdOKHNpemVv
ZihzdHJ1Y3QgaXA2dF9yYW5kX2luZm8pKSkgew0KKysJCXByaW50aygiaXA2
dF9yYW5kb206IG1hdGNoc2l6ZSAldSAhPSAldVxuIiwgbWF0Y2hzaXplLA0K
KysJCSAgICAgICBJUDZUX0FMSUdOKHNpemVvZihzdHJ1Y3QgaXA2dF9yYW5k
X2luZm8pKSk7DQorKwkJcmV0dXJuIDA7DQorKwl9DQorKw0KKysJLyogbXVz
dCBiZSAgMSA8PSBhdmVyYWdlICUgPD0gOTkgKi8NCisrCS8qIDEgIHggMi41
NSA9IDIgICAqLw0KKysJLyogOTkgeCAyLjU1ID0gMjUyICovDQorKwlpZiAo
KGluZm8tPmF2ZXJhZ2UgPCAyKSB8fCAoaW5mby0+YXZlcmFnZSA+IDI1Mikp
IHsNCisrCQlwcmludGsoImlwNnRfcmFuZG9tOiAgaW52YWxpZCBhdmVyYWdl
ICV1XG4iLCBpbmZvLT5hdmVyYWdlKTsNCisrCQlyZXR1cm4gMDsNCisrCX0N
CisrDQorKwlyZXR1cm4gMTsNCisrfQ0KKysNCisrc3RhdGljIHN0cnVjdCBp
cDZ0X21hdGNoIGlwNnRfcmFuZF9yZWcgPSB7IA0KKysJe05VTEwsIE5VTEx9
LA0KKysJInJhbmRvbSIsDQorKwlpcDZ0X3JhbmRfbWF0Y2gsDQorKwlpcDZ0
X3JhbmRfY2hlY2tlbnRyeSwNCisrCU5VTEwsDQorKwlUSElTX01PRFVMRSB9
Ow0KKysNCisrc3RhdGljIGludCBfX2luaXQgaW5pdCh2b2lkKQ0KKyt7DQor
KwlpZiAoaXA2dF9yZWdpc3Rlcl9tYXRjaCgmaXA2dF9yYW5kX3JlZykpDQor
KwkJcmV0dXJuIC1FSU5WQUw7DQorKw0KKysJcHJpbnRrKCJpcDZ0X3JhbmRv
bSBtYXRjaCBsb2FkZWRcbiIpOw0KKysJcmV0dXJuIDA7DQorK30NCisrDQor
K3N0YXRpYyB2b2lkIF9fZXhpdCBmaW5pKHZvaWQpDQorK3sNCisrCWlwNnRf
dW5yZWdpc3Rlcl9tYXRjaCgmaXA2dF9yYW5kX3JlZyk7DQorKwlwcmludGso
ImlwNnRfcmFuZG9tIG1hdGNoIHVubG9hZGVkXG4iKTsNCisrfQ0KKysNCisr
bW9kdWxlX2luaXQoaW5pdCk7DQorK21vZHVsZV9leGl0KGZpbmkpOw0KZGlm
ZiAtTnJ1IG5ldGZpbHRlci5vcmlnL3BhdGNoLW8tbWF0aWMvYmFzZS9yYW5k
b202LnBhdGNoLmlwdjYuY29uZmlnLmluIG5ldGZpbHRlci9wYXRjaC1vLW1h
dGljL2Jhc2UvcmFuZG9tNi5wYXRjaC5pcHY2LmNvbmZpZy5pbg0KLS0tIG5l
dGZpbHRlci5vcmlnL3BhdGNoLW8tbWF0aWMvYmFzZS9yYW5kb202LnBhdGNo
LmlwdjYuY29uZmlnLmluCTE5NzAtMDEtMDEgMDE6MDA6MDAuMDAwMDAwMDAw
ICswMTAwDQorKysgbmV0ZmlsdGVyL3BhdGNoLW8tbWF0aWMvYmFzZS9yYW5k
b202LnBhdGNoLmlwdjYuY29uZmlnLmluCTIwMDMtMDQtMzAgMTc6MDI6MDAu
MDAwMDAwMDAwICswMjAwDQpAQCAtMCwwICsxLDIgQEANCisgIGRlcF90cmlz
dGF0ZSAnICBNQUMgYWRkcmVzcyBtYXRjaCBzdXBwb3J0JyBDT05GSUdfSVA2
X05GX01BVENIX01BQyAkQ09ORklHX0lQNl9ORl9JUFRBQkxFUw0KKyAgZGVw
X3RyaXN0YXRlICcgIFJhbmRvbSBtYXRjaCBzdXBwb3J0JyBDT05GSUdfSVA2
X05GX01BVENIX1JBTkRPTSAkQ09ORklHX0lQNl9ORl9JUFRBQkxFUw0KZGlm
ZiAtTnJ1IG5ldGZpbHRlci5vcmlnL3BhdGNoLW8tbWF0aWMvYmFzZS9yYW5k
b202LnBhdGNoLmlwdjYuY29uZmlndXJlLmhlbHAgbmV0ZmlsdGVyL3BhdGNo
LW8tbWF0aWMvYmFzZS9yYW5kb202LnBhdGNoLmlwdjYuY29uZmlndXJlLmhl
bHANCi0tLSBuZXRmaWx0ZXIub3JpZy9wYXRjaC1vLW1hdGljL2Jhc2UvcmFu
ZG9tNi5wYXRjaC5pcHY2LmNvbmZpZ3VyZS5oZWxwCTE5NzAtMDEtMDEgMDE6
MDA6MDAuMDAwMDAwMDAwICswMTAwDQorKysgbmV0ZmlsdGVyL3BhdGNoLW8t
bWF0aWMvYmFzZS9yYW5kb202LnBhdGNoLmlwdjYuY29uZmlndXJlLmhlbHAJ
MjAwMy0wNC0zMCAxNzowMzoyNC4wMDAwMDAwMDAgKzAyMDANCkBAIC0wLDAg
KzEsMTAgQEANCitDT05GSUdfSVA2X05GX01BVENIX01BQw0KK1JhbmRvbSBt
YXRjaCBzdXBwb3J0DQorQ09ORklHX0lQNl9ORl9NQVRDSF9SQU5ET00NCisg
IFRoaXMgb3B0aW9uIGFkZHMgYSBgcmFuZG9tJyBtYXRjaCwNCisgIHdoaWNo
IGFsbG93IHlvdSB0byBtYXRjaCBwYWNrZXRzIHJhbmRvbWx5DQorICBmb2xs
b3dpbmcgYSBnaXZlbiBwcm9iYWJpbGl0eS4NCisgDQorICBJZiB5b3Ugd2Fu
dCB0byBjb21waWxlIGl0IGFzIGEgbW9kdWxlLCBzYXkgTSBoZXJlIGFuZCBy
ZWFkDQorICBEb2N1bWVudGF0aW9uL21vZHVsZXMudHh0LiAgSWYgdW5zdXJl
LCBzYXkgYE4nLg0KKw0KZGlmZiAtTnJ1IG5ldGZpbHRlci5vcmlnL3BhdGNo
LW8tbWF0aWMvYmFzZS9yYW5kb202LnBhdGNoLmlwdjYuaGVscCBuZXRmaWx0
ZXIvcGF0Y2gtby1tYXRpYy9iYXNlL3JhbmRvbTYucGF0Y2guaXB2Ni5oZWxw
DQotLS0gbmV0ZmlsdGVyLm9yaWcvcGF0Y2gtby1tYXRpYy9iYXNlL3JhbmRv
bTYucGF0Y2guaXB2Ni5oZWxwCTE5NzAtMDEtMDEgMDE6MDA6MDAuMDAwMDAw
MDAwICswMTAwDQorKysgbmV0ZmlsdGVyL3BhdGNoLW8tbWF0aWMvYmFzZS9y
YW5kb202LnBhdGNoLmlwdjYuaGVscAkyMDAzLTA0LTMwIDE3OjAxOjM0LjAw
MDAwMDAwMCArMDIwMA0KQEAgLTAsMCArMSwxNCBAQA0KK0F1dGhvcjogRmFi
cmljZSBNQVJJRSA8ZmFicmljZUBuZXRmaWx0ZXIub3JnPg0KK1BvcnRlZDog
TWFjaWVqIFNvbHR5c2lhayA8c29sdEBkbnMudG94aWNmaWxtcy50dj4NCitT
dGF0dXM6IFdvcmtzIEZvciBNZS4NCisNCitUaGlzIG9wdGlvbiBhZGRzIENP
TkZJR19JUDZfTkZfTUFUQ0hfUkFORE9NLA0KK3doaWNoIGFsbG93IHlvdSB0
byBtYXRjaCBwYWNrZXRzIHJhbmRvbWx5DQorZm9sbG93aW5nIGEgZ2l2ZW4g
cHJvYmFiaWxpdHkuIA0KKw0KK1N1cHBwb3J0ZWQgb3B0aW9ucyBhcmU6DQor
DQorWy0tYXZlcmFnZV0gCXBlcmNlbnQJd2lsbCBtYXRjaCByYW5kb21seSBw
YWNrZXRzIHdpdGggYSBwcm9iYWJpbGl0eSBvZiAncGVyY2VudCcNCisJCWRl
ZmF1bHQgaXMgNTAlDQorDQorVGhpcyBpcyBhbiBJUHY2IHBvcnQgZnJvbSBJ
UHY0IG1vZHVsZS4NCmRpZmYgLU5ydSBuZXRmaWx0ZXIub3JpZy9wYXRjaC1v
LW1hdGljL2Jhc2UvcmFuZG9tNi5wYXRjaC5pcHY2Lm1ha2VmaWxlIG5ldGZp
bHRlci9wYXRjaC1vLW1hdGljL2Jhc2UvcmFuZG9tNi5wYXRjaC5pcHY2Lm1h
a2VmaWxlDQotLS0gbmV0ZmlsdGVyLm9yaWcvcGF0Y2gtby1tYXRpYy9iYXNl
L3JhbmRvbTYucGF0Y2guaXB2Ni5tYWtlZmlsZQkxOTcwLTAxLTAxIDAxOjAw
OjAwLjAwMDAwMDAwMCArMDEwMA0KKysrIG5ldGZpbHRlci9wYXRjaC1vLW1h
dGljL2Jhc2UvcmFuZG9tNi5wYXRjaC5pcHY2Lm1ha2VmaWxlCTIwMDMtMDQt
MzAgMTc6MDI6MTEuMDAwMDAwMDAwICswMjAwDQpAQCAtMCwwICsxLDMgQEAN
CitvYmotJChDT05GSUdfSVA2X05GX1RBUkdFVF9MT0cpICs9IGlwNnRfTE9H
Lm8NCisNCitvYmotJChDT05GSUdfSVA2X05GX01BVENIX1JBTkRPTSkgKz0g
aXA2dF9yYW5kb20ubw0KZGlmZiAtTnJ1IG5ldGZpbHRlci5vcmlnL3VzZXJz
cGFjZS9leHRlbnNpb25zL01ha2VmaWxlIG5ldGZpbHRlci91c2Vyc3BhY2Uv
ZXh0ZW5zaW9ucy9NYWtlZmlsZQ0KLS0tIG5ldGZpbHRlci5vcmlnL3VzZXJz
cGFjZS9leHRlbnNpb25zL01ha2VmaWxlCTIwMDMtMDQtMzAgMTY6NDc6MjYu
MDAwMDAwMDAwICswMjAwDQorKysgbmV0ZmlsdGVyL3VzZXJzcGFjZS9leHRl
bnNpb25zL01ha2VmaWxlCTIwMDMtMDQtMzAgMTY6NTQ6NTIuMDAwMDAwMDAw
ICswMjAwDQpAQCAtNiw3ICs2LDcgQEANCiAjIHBhY2thZ2UgKEhXKQ0KICMN
CiBQRl9FWFRfU0xJQjo9YWggY29ubnRyYWNrIGRzY3AgZWNuIGVzcCBoZWxw
ZXIgaWNtcCBpcGxpbWl0IGxlbmd0aCBsaW1pdCBtYWMgbWFyayBtdWx0aXBv
cnQgb3duZXIgcGh5c2RldiBwa3R0eXBlIHJwYyBzdGFuZGFyZCBzdGF0ZSB0
Y3AgdGNwbXNzIHRvcyB0dGwgdWRwIHVuY2xlYW4gRE5BVCBEU0NQIEVDTiBM
T0cgTUFSSyBNQVNRVUVSQURFIE1JUlJPUiBSRURJUkVDVCBSRUpFQ1QgU0FN
RSBTTkFUIFRBUlBJVCBUQ1BNU1MgVE9TIFRUTCBVTE9HDQotUEY2X0VYVF9T
TElCOj1ldWk2NCBobCBpY21wdjYgbGVuZ3RoIG50aCBsaW1pdCBtYWMgbWFy
ayBtdWx0aXBvcnQgb3duZXIgc3RhbmRhcmQgdGNwIHVkcCBITCBMT0cgTUFS
Sw0KK1BGNl9FWFRfU0xJQjo9ZXVpNjQgaGwgaWNtcHY2IHJhbmRvbSBsZW5n
dGggbnRoIGxpbWl0IG1hYyBtYXJrIG11bHRpcG9ydCBvd25lciBzdGFuZGFy
ZCB0Y3AgdWRwIEhMIExPRyBNQVJLDQogDQogIyBPcHRpb25hbHMNCiBQRl9F
WFRfU0xJQl9PUFRTOj0kKGZvcmVhY2ggVCwkKHdpbGRjYXJkIGV4dGVuc2lv
bnMvLiotdGVzdCksJChzaGVsbCBLRVJORUxfRElSPSQoS0VSTkVMX0RJUikg
JChUKSkpDQpkaWZmIC1OcnUgbmV0ZmlsdGVyLm9yaWcvdXNlcnNwYWNlL2V4
dGVuc2lvbnMvbGliaXA2dF9yYW5kb20uYyBuZXRmaWx0ZXIvdXNlcnNwYWNl
L2V4dGVuc2lvbnMvbGliaXA2dF9yYW5kb20uYw0KLS0tIG5ldGZpbHRlci5v
cmlnL3VzZXJzcGFjZS9leHRlbnNpb25zL2xpYmlwNnRfcmFuZG9tLmMJMTk3
MC0wMS0wMSAwMTowMDowMC4wMDAwMDAwMDAgKzAxMDANCisrKyBuZXRmaWx0
ZXIvdXNlcnNwYWNlL2V4dGVuc2lvbnMvbGliaXA2dF9yYW5kb20uYwkyMDAz
LTA0LTMwIDE2OjUxOjI0LjAwMDAwMDAwMCArMDIwMA0KQEAgLTAsMCArMSwx
NTIgQEANCisvKiANCisgICBTaGFyZWQgbGlicmFyeSBhZGQtb24gdG8gaXB0
YWJsZXMgdG8gYWRkIG1hdGNoIHN1cHBvcnQgZm9yIHJhbmRvbSBtYXRjaC4N
CisgICANCisgICBUaGlzIGZpbGUgaXMgZGlzdHJpYnV0ZWQgdW5kZXIgdGhl
IHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMNCisgICBMaWNlbnNl
IChHUEwpLiBDb3BpZXMgb2YgdGhlIEdQTCBjYW4gYmUgb2J0YWluZWQgZnJv
bToNCisgICBmdHA6Ly9wcmVwLmFpLm1pdC5lZHUvcHViL2dudS9HUEwNCisN
CisgICAyMDAxLTEwLTE0IEZhYnJpY2UgTUFSSUUgPGZhYnJpY2VAbmV0Zmls
dGVyLm9yZz4gOiBpbml0aWFsIGRldmVsb3BtZW50Lg0KKyAgIDIwMDMtMDQt
MzAgTWFjaWVqIFNvbHR5c2lhayA8c29sdEBkbnMudG94aWNmaWxtcy50dj4g
OiBJUHY2IHBvcnQuDQorKi8NCisNCisjaW5jbHVkZSA8c3RkaW8uaD4NCisj
aW5jbHVkZSA8bmV0ZGIuaD4NCisjaW5jbHVkZSA8c3RyaW5nLmg+DQorI2lu
Y2x1ZGUgPHN0ZGxpYi5oPg0KKyNpbmNsdWRlIDxzeXNsb2cuaD4NCisjaW5j
bHVkZSA8Z2V0b3B0Lmg+DQorI2luY2x1ZGUgPGlwNnRhYmxlcy5oPg0KKyNp
bmNsdWRlIDxsaW51eC9uZXRmaWx0ZXJfaXB2Ni9pcDZfdGFibGVzLmg+DQor
I2luY2x1ZGUgPGxpbnV4L25ldGZpbHRlcl9pcHY2L2lwNnRfcmFuZG9tLmg+
DQorDQorLyoqDQorICogVGhlIGtlcm5lbCByYW5kb20gcm91dGluZyByZXR1
cm5zIG51bWJlcnMgYmV0d2VlbiAwIGFuZCAyNTUuDQorICogVG8gZWFzZSB0
aGUgdGFzayBvZiB0aGUgdXNlciBpbiBjaG9vc2luZyB0aGUgcHJvYmFiaWxp
dHkNCisgKiBvZiBtYXRjaGluZywgd2Ugd2FudCBoaW0gdG8gYmUgYWJsZSB0
byB1c2UgcGVyY2VudGFnZXMuDQorICogVGhlcmVmb3JlIHdlIGhhdmUgdG8g
YWNjZXB0IG51bWJlcnMgaW4gcGVyY2VudGFnZSBoZXJlLA0KKyAqIHR1cm4g
dGhlbSBpbnRvIG51bWJlciBiZXR3ZWVuIDAgYW5kIDI1NSBmb3IgdGhlIGtl
cm5lbCBtb2R1bGUsDQorICogYW5kIHR1cm4gdGhlbSBiYWNrIHRvIHBlcmNl
bnRhZ2VzIHdoZW4gd2UgcHJpbnQvc2F2ZQ0KKyAqIHRoZSBydWxlLg0KKyAq
Lw0KKw0KKw0KKy8qIEZ1bmN0aW9uIHdoaWNoIHByaW50cyBvdXQgdXNhZ2Ug
bWVzc2FnZS4gKi8NCitzdGF0aWMgdm9pZA0KK2hlbHAodm9pZCkNCit7DQor
CXByaW50ZigNCisicmFuZG9tIHYlcyBvcHRpb25zOlxuIg0KKyIgIFstLWF2
ZXJhZ2VdICAgICBwZXJjZW50ICAgICAgVGhlIHByb2JhYmlsaXR5IGluIHBl
cmNlbnRhZ2Ugb2YgdGhlIG1hdGNoXG4iDQorIiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBJZiBvbW1pdGVkLCBhIHByb2JhYmlsaXR5IG9mIDUw
JSUgcGVyY2VudCBpcyBzZXQuXG4iDQorIiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBQZXJjZW50YWdlIG11c3QgYmUgd2l0aGluIDogMSA8PSBw
ZXJjZW50IDw9IDk5LlxuXG4iLA0KK0lQVEFCTEVTX1ZFUlNJT04pOw0KK30N
CisNCitzdGF0aWMgc3RydWN0IG9wdGlvbiBvcHRzW10gPSB7DQorCXsgImF2
ZXJhZ2UiLCAxLCAwLCAnMScgfSwNCisJeyAwIH0NCit9Ow0KKw0KKy8qIElu
aXRpYWxpemUgdGhlIHRhcmdldC4gKi8NCitzdGF0aWMgdm9pZA0KK2luaXQo
c3RydWN0IGlwNnRfZW50cnlfbWF0Y2ggKm0sIHVuc2lnbmVkIGludCAqbmZj
YWNoZSkNCit7DQorCXN0cnVjdCBpcDZ0X3JhbmRfaW5mbyAqcmFuZGluZm8g
PSAoc3RydWN0IGlwNnRfcmFuZF9pbmZvICopKG0pLT5kYXRhOw0KKwkqbmZj
YWNoZSB8PSBORkNfVU5LTk9XTjsNCisNCisJLyogV2UgYXNzaWduIHRoZSBh
dmVyYWdlIHRvIGJlIDUwIHdoaWNoIGlzIG91ciBkZWZhdWx0IHZhbHVlICov
DQorCS8qIDUwICogMi41NSA9IDEyOCAqLw0KKwlyYW5kaW5mby0+YXZlcmFn
ZSA9IDEyODsNCit9DQorDQorI2RlZmluZSBJUDZUX1JBTkRfT1BUX0FWRVJB
R0UJMHgwMQ0KKw0KKy8qIEZ1bmN0aW9uIHdoaWNoIHBhcnNlcyBjb21tYW5k
IG9wdGlvbnM7IHJldHVybnMgdHJ1ZSBpZiBpdA0KKyAgIGF0ZSBhbiBvcHRp
b24gKi8NCitzdGF0aWMgaW50DQorcGFyc2UoaW50IGMsIGNoYXIgKiphcmd2
LCBpbnQgaW52ZXJ0LCB1bnNpZ25lZCBpbnQgKmZsYWdzLA0KKyAgICAgIGNv
bnN0IHN0cnVjdCBpcDZ0X2VudHJ5ICplbnRyeSwNCisgICAgICB1bnNpZ25l
ZCBpbnQgKm5mY2FjaGUsDQorICAgICAgc3RydWN0IGlwNnRfZW50cnlfbWF0
Y2ggKiptYXRjaCkNCit7DQorCXN0cnVjdCBpcDZ0X3JhbmRfaW5mbyAqcmFu
ZGluZm8gPSAoc3RydWN0IGlwNnRfcmFuZF9pbmZvICopKCptYXRjaCktPmRh
dGE7DQorCXVuc2lnbmVkIGludCBudW07DQorDQorCXN3aXRjaCAoYykgew0K
KwljYXNlICcxJzoNCisJCS8qIGNoZWNrIGZvciBjb21tb24gbWlzdGFrZXMu
Li4gKi8NCisJCWlmIChpbnZlcnQpDQorCQkJZXhpdF9lcnJvcihQQVJBTUVU
RVJfUFJPQkxFTSwNCisJCQkJICAgIkNhbid0IHNwZWNpZnkgISAtLWF2ZXJh
Z2UiKTsNCisJCWlmICgqZmxhZ3MgJiBJUDZUX1JBTkRfT1BUX0FWRVJBR0Up
DQorCQkJZXhpdF9lcnJvcihQQVJBTUVURVJfUFJPQkxFTSwNCisJCQkJICAg
IkNhbid0IHNwZWNpZnkgLS1hdmVyYWdlIHR3aWNlIik7DQorDQorCQkvKiBS
ZW1lbWJlciwgdGhpcyBmdW5jdGlvbiB3aWxsIGludGVycHJldCBhIGxlYWRp
bmcgMCB0byBiZSANCisJCSAgIE9jdGFsLCBhIGxlYWRpbmcgMHggdG8gYmUg
aGV4ZGVjaW1hbC4uLiAqLw0KKyAgICAgICAgICAgICAgICBpZiAoc3RyaW5n
X3RvX251bWJlcihvcHRhcmcsIDEsIDk5LCAmbnVtKSA9PSAtMSB8fCBudW0g
PCAxKQ0KKyAgICAgICAgICAgICAgICAgICAgICAgIGV4aXRfZXJyb3IoUEFS
QU1FVEVSX1BST0JMRU0sDQorICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAiYmFkIC0tYXZlcmFnZSBgJXMnLCBtdXN0IGJlIGJldHdlZW4g
MSBhbmQgOTkiLCBvcHRhcmcpOw0KKw0KKwkJLyogYXNzaWduIHRoZSB2YWx1
ZXMgKi8NCisJCXJhbmRpbmZvLT5hdmVyYWdlID0gKGludCkobnVtICogMi41
NSk7DQorCQkqZmxhZ3MgfD0gSVA2VF9SQU5EX09QVF9BVkVSQUdFOw0KKwkJ
YnJlYWs7DQorCWRlZmF1bHQ6DQorCQlyZXR1cm4gMDsNCisJfQ0KKwlyZXR1
cm4gMTsNCit9DQorDQorLyogRmluYWwgY2hlY2s7IG5vdGhpbmcuICovDQor
c3RhdGljIHZvaWQgZmluYWxfY2hlY2sodW5zaWduZWQgaW50IGZsYWdzKQ0K
K3sNCit9DQorDQorLyogUHJpbnRzIG91dCB0aGUgdGFyZ2luZm8uICovDQor
c3RhdGljIHZvaWQNCitwcmludChjb25zdCBzdHJ1Y3QgaXA2dF9pcDYgKmlw
LA0KKyAgICAgIGNvbnN0IHN0cnVjdCBpcDZ0X2VudHJ5X21hdGNoICptYXRj
aCwNCisgICAgICBpbnQgbnVtZXJpYykNCit7DQorCWNvbnN0IHN0cnVjdCBp
cDZ0X3JhbmRfaW5mbyAqcmFuZGluZm8NCisJCT0gKGNvbnN0IHN0cnVjdCBp
cDZ0X3JhbmRfaW5mbyAqKW1hdGNoLT5kYXRhOw0KKwlkaXZfdCByZXN1bHQg
PSBkaXYoKHJhbmRpbmZvLT5hdmVyYWdlKjEwMCksIDI1NSk7DQorCWlmIChy
ZXN1bHQucmVtID4gMTI3KSAgLyogcm91bmQgdXAuLi4gKi8NCisJCSsrcmVz
dWx0LnF1b3Q7DQorDQorCXByaW50ZigiIHJhbmRvbSAldSUlICIsIHJlc3Vs
dC5xdW90KTsNCit9DQorDQorLyogU2F2ZXMgdGhlIHVuaW9uIGlwNnRfdGFy
Z2luZm8gaW4gcGFyc2FibGUgZm9ybSB0byBzdGRvdXQuICovDQorc3RhdGlj
IHZvaWQNCitzYXZlKGNvbnN0IHN0cnVjdCBpcDZ0X2lwNiAqaXAsIGNvbnN0
IHN0cnVjdCBpcDZ0X2VudHJ5X21hdGNoICptYXRjaCkNCit7DQorCWNvbnN0
IHN0cnVjdCBpcDZ0X3JhbmRfaW5mbyAqcmFuZGluZm8NCisJCT0gKGNvbnN0
IHN0cnVjdCBpcDZ0X3JhbmRfaW5mbyAqKW1hdGNoLT5kYXRhOw0KKwlkaXZf
dCByZXN1bHQgPSBkaXYoKHJhbmRpbmZvLT5hdmVyYWdlICoxMDApLCAyNTUp
Ow0KKwlpZiAocmVzdWx0LnJlbSA+IDEyNykgIC8qIHJvdW5kIHVwLi4uICov
DQorCQkrK3Jlc3VsdC5xdW90Ow0KKw0KKwlwcmludGYoIi0tYXZlcmFnZSAl
dSAiLCByZXN1bHQucXVvdCk7DQorfQ0KKw0KK3N0cnVjdCBpcDZ0YWJsZXNf
bWF0Y2ggcmFuZF9tYXRjaA0KKz0geyBOVUxMLA0KKyAgICAicmFuZG9tIiwN
CisgICAgSVBUQUJMRVNfVkVSU0lPTiwNCisgICAgSVA2VF9BTElHTihzaXpl
b2Yoc3RydWN0IGlwNnRfcmFuZF9pbmZvKSksDQorICAgIElQNlRfQUxJR04o
c2l6ZW9mKHN0cnVjdCBpcDZ0X3JhbmRfaW5mbykpLA0KKyAgICAmaGVscCwN
CisgICAgJmluaXQsDQorICAgICZwYXJzZSwNCisgICAgJmZpbmFsX2NoZWNr
LA0KKyAgICAmcHJpbnQsDQorICAgICZzYXZlLA0KKyAgICBvcHRzDQorfTsN
CisNCit2b2lkIF9pbml0KHZvaWQpDQorew0KKwlyZWdpc3Rlcl9tYXRjaDYo
JnJhbmRfbWF0Y2gpOw0KK30NCg==

---23717851-1495294138-1051715295=:18169--
