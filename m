From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [PATCH] IPv6 port of the fuzzy match.
Date: Wed, 9 Apr 2003 15:40:40 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0304091539010.7529@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

here is a patch to the netfilter tree to add fuzzy match support
to IPv6.

I asked earlier about why did not the HL target made it into the kernel,
but the hl match did.

Regards,
Maciej Soltysiak

diff -Nru netfilter.orig/patch-o-matic/base/fuzzy6.patch.ipv6 netfilter/patch-o-matic/base/fuzzy6.patch.ipv6
--- netfilter.orig/patch-o-matic/base/fuzzy6.patch.ipv6	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/fuzzy6.patch.ipv6	2003-04-09 13:17:06.000000000 +0200
@@ -0,0 +1,218 @@
+diff -Nru linux.bak/include/linux/netfilter_ipv6/ip6t_fuzzy.h linux/include/linux/netfilter_ipv6/ip6t_fuzzy.h
+--- linux.bak/include/linux/netfilter_ipv6/ip6t_fuzzy.h	1970-01-01 01:00:00.000000000 +0100
++++ linux/include/linux/netfilter_ipv6/ip6t_fuzzy.h	2003-04-08 21:47:05.000000000 +0200
+@@ -0,0 +1,21 @@
++#ifndef _IP6T_FUZZY_H
++#define _IP6T_FUZZY_H
++
++#include <linux/param.h>
++#include <linux/types.h>
++
++#define MAXFUZZYRATE 10000000
++#define MINFUZZYRATE 3
++
++struct ip6t_fuzzy_info {
++	u_int32_t minimum_rate;
++	u_int32_t maximum_rate;
++	u_int32_t packets_total;
++	u_int32_t bytes_total;
++	u_int32_t previous_time;
++	u_int32_t present_time;
++	u_int32_t mean_rate;
++	u_int8_t acceptance_rate;
++};
++
++#endif /*_IP6T_FUZZY_H*/
+diff -Nru linux.bak/net/ipv6/netfilter/ip6t_fuzzy.c linux/net/ipv6/netfilter/ip6t_fuzzy.c
+--- linux.bak/net/ipv6/netfilter/ip6t_fuzzy.c	1970-01-01 01:00:00.000000000 +0100
++++ linux/net/ipv6/netfilter/ip6t_fuzzy.c	2003-04-09 13:07:47.000000000 +0200
+@@ -0,0 +1,189 @@
++/*
++ * This module implements a simple TSK FLC
++ * (Takagi-Sugeno-Kang Fuzzy Logic Controller) that aims
++ * to limit , in an adaptive and flexible way , the packet rate crossing
++ * a given stream . It serves as an initial and very simple (but effective)
++ * example of how Fuzzy Logic techniques can be applied to defeat DoS attacks.
++ *  As a matter of fact , Fuzzy Logic can help us to insert any "behavior"
++ * into our code in a precise , adaptive and efficient manner.
++ *  The goal is very similar to that of "limit" match , but using techniques of
++ * Fuzzy Control , that allow us to shape the transfer functions precisely ,
++ * avoiding over and undershoots - and stuff like that .
++ *
++ *
++ * 2002-08-10  Hime Aguiar e Oliveira Jr. <hime@engineer.com> : Initial version.
++ * 2002-08-17  : Changed to eliminate floating point operations .
++ * 2002-08-23  : Coding style changes .
++ * 2003-04-08  Maciej Soltysiak <solt@dns.toxicilms.tv> : IPv6 Port
++ */
++
++#include <linux/module.h>
++#include <linux/skbuff.h>
++#include <linux/ipv6.h>
++#include <linux/random.h>
++#include <net/tcp.h>
++#include <linux/spinlock.h>
++#include <linux/netfilter_ipv6/ip6_tables.h>
++#include <linux/netfilter_ipv6/ip6t_fuzzy.h>
++
++/*
++ Packet Acceptance Rate - LOW and Packet Acceptance Rate - HIGH
++ Expressed in percentage
++*/
++
++#define PAR_LOW		0.01
++#define PAR_HIGH	1
++
++static spinlock_t fuzzy_lock = SPIN_LOCK_UNLOCKED;
++
++MODULE_AUTHOR("Hime Aguiar e Oliveira Junior <hime@engineer.com>");
++MODULE_DESCRIPTION("IP tables Fuzzy Logic Controller match module");
++MODULE_LICENSE("GPL");
++
++static  u_int8_t mf_high(u_int32_t tx,u_int32_t mini,u_int32_t maxi)
++{
++	if (tx >= maxi) return 100;
++
++	if (tx <= mini) return 0;
++
++	return ((100 * (tx-mini)) / (maxi-mini));
++}
++
++static u_int8_t mf_low(u_int32_t tx,u_int32_t mini,u_int32_t maxi)
++{
++	if (tx <= mini) return 100;
++
++	if (tx >= maxi) return 0;
++
++	return ((100 * (maxi - tx)) / (maxi - mini));
++
++}
++
++static int
++ip6t_fuzzy_match(const struct sk_buff *pskb,
++	       const struct net_device *in,
++	       const struct net_device *out,
++	       const void *matchinfo,
++	       int offset,
++	       const void *hdr,
++	       u_int16_t datalen,
++	       int *hotdrop)
++{
++	/* From userspace */
++
++	struct ip6t_fuzzy_info *info = (struct ip6t_fuzzy_info *) matchinfo;
++
++	u_int8_t random_number;
++	unsigned long amount;
++	u_int8_t howhigh, howlow;
++
++
++	spin_lock_bh(&fuzzy_lock); /* Rise the lock */
++
++	info->bytes_total += pskb->len;
++	info->packets_total++;
++
++	info->present_time = jiffies;
++
++	if (info->present_time >= info->previous_time)
++		amount = info->present_time - info->previous_time;
++	else {
++	       	/* There was a transition : I choose to re-sample
++		   and keep the old acceptance rate...
++	        */
++
++		amount = 0;
++		info->previous_time = info->present_time;
++		info->bytes_total = info->packets_total = 0;
++	     };
++
++	if ( amount > HZ/10) {/* More than 100 ms elapsed ... */
++
++		info->mean_rate = (u_int32_t) ((HZ * info->packets_total) \
++		  		        / amount);
++
++		info->previous_time = info->present_time;
++		info->bytes_total = info->packets_total = 0;
++
++		howhigh = mf_high(info->mean_rate,info->minimum_rate,info->maximum_rate);
++		howlow  = mf_low(info->mean_rate,info->minimum_rate,info->maximum_rate);
++
++		info->acceptance_rate = (u_int8_t) \
++				(PAR_LOW * howhigh + PAR_HIGH * howlow);
++
++	/* In fact, the above defuzzification would require a denominator
++	 * proportional to (howhigh+howlow) but, in this particular case,
++	 * that expression is constant.
++	 * An imediate consequence is that it is not necessary to call
++	 * both mf_high and mf_low - but to keep things understandable,
++	 * I did so.
++	 */
++
++	}
++
++	spin_unlock_bh(&fuzzy_lock); /* Release the lock */
++
++
++	if (info->acceptance_rate < 100)
++	{
++		get_random_bytes((void *)(&random_number), 1);
++
++		/*  If within the acceptance , it can pass => don't match */
++		if (random_number <= 2.55 * info->acceptance_rate)
++			return 0;
++		else
++			return 1; /* It can't pass (It matches) */
++	};
++
++	return 0; /* acceptance_rate == 100 % => Everything passes ... */
++
++}
++
++static int
++ip6t_fuzzy_checkentry(const char *tablename,
++		   const struct ip6t_ip6 *ip,
++		   void *matchinfo,
++		   unsigned int matchsize,
++		   unsigned int hook_mask)
++{
++
++	const struct ip6t_fuzzy_info *info = matchinfo;
++
++	if (matchsize != IP6T_ALIGN(sizeof(struct ip6t_fuzzy_info))) {
++		printk("ip6t_fuzzy: matchsize %u != %u\n", matchsize,
++		       IP6T_ALIGN(sizeof(struct ip6t_fuzzy_info)));
++		return 0;
++	}
++
++	if ((info->minimum_rate < MINFUZZYRATE) || (info->maximum_rate > MAXFUZZYRATE)
++	 || (info->minimum_rate >= info->maximum_rate)) {
++		printk("ip6t_fuzzy: BAD limits , please verify !!!\n");
++		return 0;
++	}
++
++	return 1;
++}
++
++static struct ip6t_match ip6t_fuzzy_reg = {
++	{NULL, NULL},
++	"fuzzy",
++	ip6t_fuzzy_match,
++	ip6t_fuzzy_checkentry,
++	NULL,
++	THIS_MODULE };
++
++static int __init init(void)
++{
++	if (ip6t_register_match(&ip6t_fuzzy_reg))
++		return -EINVAL;
++
++	return 0;
++}
++
++static void __exit fini(void)
++{
++	ip6t_unregister_match(&ip6t_fuzzy_reg);
++}
++
++module_init(init);
++module_exit(fini);
diff -Nru netfilter.orig/patch-o-matic/base/fuzzy6.patch.ipv6.config.in netfilter/patch-o-matic/base/fuzzy6.patch.ipv6.config.in
--- netfilter.orig/patch-o-matic/base/fuzzy6.patch.ipv6.config.in	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/fuzzy6.patch.ipv6.config.in	2003-04-09 15:27:35.000000000 +0200
@@ -0,0 +1,4 @@
+  dep_tristate '  MAC address match support' CONFIG_IP6_NF_MATCH_MAC $CONFIG_IP6_NF_IPTABLES
+  if [ "$CONFIG_EXPERIMENTAL" = "y" ]; then
+    dep_tristate '    Fuzzy match support' CONFIG_IP6_NF_MATCH_FUZZY $CONFIG_IP6_NF_FILTER
+  fi
diff -Nru netfilter.orig/patch-o-matic/base/fuzzy6.patch.ipv6.configure.help netfilter/patch-o-matic/base/fuzzy6.patch.ipv6.configure.help
--- netfilter.orig/patch-o-matic/base/fuzzy6.patch.ipv6.configure.help	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/fuzzy6.patch.ipv6.configure.help	2003-04-09 13:16:56.000000000 +0200
@@ -0,0 +1,9 @@
+CONFIG_IP6_NF_MATCH_MAC
+Fuzzy Logic Controller match support
+CONFIG_IP6_NF_MATCH_FUZZY
+  This option adds a `fuzzy' match, which allows you to match
+  packets according to a fuzzy logic based law.
+
+  If you want to compile it as a module, say M here and read
+  Documentation/modules.txt.  If unsure, say `N'.
+
diff -Nru netfilter.orig/patch-o-matic/base/fuzzy6.patch.ipv6.help netfilter/patch-o-matic/base/fuzzy6.patch.ipv6.help
--- netfilter.orig/patch-o-matic/base/fuzzy6.patch.ipv6.help	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/fuzzy6.patch.ipv6.help	2003-04-09 15:18:49.000000000 +0200
@@ -0,0 +1,15 @@
+Author: Hime Aguiar e Oliveira Jr. <hime@engineer.com>
+Ported: Maciej Soltysiak <solt@dns.toxicfilms.tv>
+Status: Under development, but works.
+
+This option adds CONFIG_IP6_NF_MATCH_FUZZY,
+which allows you to match packets according to a dynamic profile
+implemented by means of a simple Fuzzy Logic Controller (FLC).
+
+Suppported options are:
+
+--upper-limit => Desired upper bound for traffic rate
+
+--lower-limit => Lower bound over which the FLC starts to limit traffic
+
+This is an IPv6 port from IPv4 module.
diff -Nru netfilter.orig/patch-o-matic/base/fuzzy6.patch.ipv6.makefile netfilter/patch-o-matic/base/fuzzy6.patch.ipv6.makefile
--- netfilter.orig/patch-o-matic/base/fuzzy6.patch.ipv6.makefile	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/fuzzy6.patch.ipv6.makefile	2003-04-09 15:27:59.000000000 +0200
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP6_NF_MATCH_MAC) += ip6t_mac.o
+obj-$(CONFIG_IP6_NF_MATCH_FUZZY) += ip6t_fuzzy.o
diff -Nru netfilter.orig/userspace/extensions/Makefile netfilter/userspace/extensions/Makefile
--- netfilter.orig/userspace/extensions/Makefile	2003-04-08 21:49:15.000000000 +0200
+++ netfilter/userspace/extensions/Makefile	2003-04-09 15:34:13.000000000 +0200
@@ -6,7 +6,7 @@
 # package (HW)
 #
 PF_EXT_SLIB:=ah conntrack dscp ecn esp helper icmp iplimit length limit mac mark multiport owner physdev pkttype rpc standard state tcp tcpmss tos ttl udp unclean DNAT DSCP ECN LOG MARK MASQUERADE MIRROR REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS TTL ULOG
-PF6_EXT_SLIB:=eui64 hl icmpv6 length limit mac mark multiport owner standard tcp udp HL LOG MARK
+PF6_EXT_SLIB:=eui64 hl icmpv6 length limit mac mark multiport owner standard tcp udp HL LOG MARK fuzzy

 # Optionals
 PF_EXT_SLIB_OPTS:=$(foreach T,$(wildcard extensions/.*-test),$(shell KERNEL_DIR=$(KERNEL_DIR) $(T)))
diff -Nru netfilter.orig/userspace/extensions/libip6t_fuzzy.c netfilter/userspace/extensions/libip6t_fuzzy.c
--- netfilter.orig/userspace/extensions/libip6t_fuzzy.c	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/userspace/extensions/libip6t_fuzzy.c	2003-04-09 12:11:30.000000000 +0200
@@ -0,0 +1,157 @@
+/*
+   Shared library add-on to iptables to add match support for the fuzzy match.
+
+   This file is distributed under the terms of the GNU General Public
+   License (GPL). Copies of the GPL can be obtained from:
+   ftp://prep.ai.mit.edu/pub/gnu/GPL
+
+2002-08-07 Hime Aguiar e Oliveira Jr. <hime@engineer.com> : Initial version.
+2003-04-08 Maciej Soltysiak <solt@dns.toxicfilms.tv> : IPv6 Port
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
+#include <linux/netfilter_ipv6/ip6t_fuzzy.h>
+
+
+static void
+help(void)
+{
+	printf(
+"fuzzy v%s options:\n"
+"                      --lower-limit number (in packets per second)\n"
+"                      --upper-limit number\n"
+,IPTABLES_VERSION);
+};
+
+static struct option opts[] = {
+	{ "lower-limit", 1 , 0 , '1' } ,
+	{ "upper-limit", 1 , 0 , '2' } ,
+	{ 0 }
+};
+
+/* Initialize data structures */
+static void
+init(struct ip6t_entry_match *m, unsigned int *nfcache)
+{
+	struct ip6t_fuzzy_info *presentinfo = (struct ip6t_fuzzy_info *)(m)->data;
+	*nfcache |= NFC_UNKNOWN;
+
+	/*
+	 * Default rates ( I'll improve this very soon with something based
+	 * on real statistics of the running machine ) .
+	*/
+
+	presentinfo->minimum_rate = 1000;
+	presentinfo->maximum_rate = 2000;
+}
+
+#define IP6T_FUZZY_OPT_MINIMUM	0x01
+#define IP6T_FUZZY_OPT_MAXIMUM	0x02
+
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ip6t_entry *entry,
+      unsigned int *nfcache,
+      struct ip6t_entry_match **match)
+{
+
+struct ip6t_fuzzy_info *fuzzyinfo = (struct ip6t_fuzzy_info *)(*match)->data;
+
+	u_int32_t num;
+
+	switch (c) {
+
+	case '1':
+
+	if (invert)
+	       	exit_error(PARAMETER_PROBLEM,"Can't specify ! --lower-limit");
+
+	if (*flags & IP6T_FUZZY_OPT_MINIMUM)
+       	      exit_error(PARAMETER_PROBLEM,"Can't specify --lower-limit twice");
+
+	if (string_to_number(optarg,1,MAXFUZZYRATE,&num) == -1 || num < 1)
+			exit_error(PARAMETER_PROBLEM,"BAD --lower-limit");
+
+		fuzzyinfo->minimum_rate = num ;
+
+		*flags |= IP6T_FUZZY_OPT_MINIMUM;
+
+		break;
+
+	case '2':
+
+	if (invert)
+		exit_error(PARAMETER_PROBLEM,"Can't specify ! --upper-limit");
+
+	if (*flags & IP6T_FUZZY_OPT_MAXIMUM)
+	   exit_error(PARAMETER_PROBLEM,"Can't specify --upper-limit twice");
+
+	if (string_to_number(optarg,1,MAXFUZZYRATE,&num) == -1 || num < 1)
+		exit_error(PARAMETER_PROBLEM,"BAD --upper-limit");
+
+		fuzzyinfo->maximum_rate = num ;
+
+		*flags |= IP6T_FUZZY_OPT_MAXIMUM;
+
+		break ;
+
+	default:
+		return 0;
+	}
+	return 1;
+}
+
+static void final_check(unsigned int flags)
+{
+}
+
+static void
+print(const struct ip6t_ip6 *ipv6,
+      const struct ip6t_entry_match *match,
+      int numeric)
+{
+	const struct ip6t_fuzzy_info *fuzzyinfo
+		= (const struct ip6t_fuzzy_info *)match->data;
+
+	printf(" fuzzy: lower limit = %u pps - upper limit = %u pps ",fuzzyinfo->minimum_rate,fuzzyinfo->maximum_rate);
+
+}
+
+/* Saves the union ip6t_targinfo in parsable form to stdout. */
+static void
+save(const struct ip6t_ip6 *ipv6, const struct ip6t_entry_match *match)
+{
+	const struct ip6t_fuzzy_info *fuzzyinfo
+		= (const struct ip6t_fuzzy_info *)match->data;
+
+	printf("--upper-limit %u ",fuzzyinfo->minimum_rate);
+	printf("--lower-limit %u ",fuzzyinfo->maximum_rate);
+
+}
+
+struct ip6tables_match fuzzy_match
+= { NULL,
+    "fuzzy",
+    IPTABLES_VERSION,
+    IP6T_ALIGN(sizeof(struct ip6t_fuzzy_info)),
+    IP6T_ALIGN(sizeof(struct ip6t_fuzzy_info)),
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
+	register_match6(&fuzzy_match);
+}
diff -Nru netfilter.orig/userspace/include/linux/netfilter_ipv6/ip6t_fuzzy.h netfilter/userspace/include/linux/netfilter_ipv6/ip6t_fuzzy.h
--- netfilter.orig/userspace/include/linux/netfilter_ipv6/ip6t_fuzzy.h	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/userspace/include/linux/netfilter_ipv6/ip6t_fuzzy.h	2003-04-08 21:47:05.000000000 +0200
@@ -0,0 +1,21 @@
+#ifndef _IP6T_FUZZY_H
+#define _IP6T_FUZZY_H
+
+#include <linux/param.h>
+#include <linux/types.h>
+
+#define MAXFUZZYRATE 10000000
+#define MINFUZZYRATE 3
+
+struct ip6t_fuzzy_info {
+	u_int32_t minimum_rate;
+	u_int32_t maximum_rate;
+	u_int32_t packets_total;
+	u_int32_t bytes_total;
+	u_int32_t previous_time;
+	u_int32_t present_time;
+	u_int32_t mean_rate;
+	u_int8_t acceptance_rate;
+};
+
+#endif /*_IP6T_FUZZY_H*/
