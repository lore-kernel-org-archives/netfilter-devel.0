From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [NEW TARGET] target for modifying conntrack timeout value
Date: Sun, 02 Jan 2005 01:22:21 +0100
Message-ID: <41D73EBD.3060706@eurodev.net>
References: <EINSTEINH71yEXUIEAO0000093b@einstein.systemmetrics.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020406010108000701040705"
Cc: 'Netfilter Development Mailinglist' <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Richard <richard@o-matrix.org>
In-Reply-To: <EINSTEINH71yEXUIEAO0000093b@einstein.systemmetrics.com>
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

This is a multi-part message in MIME format.
--------------020406010108000701040705
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Richard,

Richard wrote:

>I drop it and also implemented other suggestions. Here is the latest.
>  
>

I've converted your target to a match because that way we can use 
ctexpire together with NAT actions in the same rule. This was inspired 
by reading ipt_limit. I've done some minor cleanups and a checking to 
make sure that this match is never used in the raw table.

Would like to send to the list a version for patch-o-matic-ng? Then we 
could push it to the SVN repository.

--
Pablo

--------------020406010108000701040705
Content-Type: text/x-patch;
 name="ctexpire-kernel.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ctexpire-kernel.patch"

--- /dev/null	2004-09-23 01:18:13.000000000 +0200
+++ net/ipv4/netfilter/ipt_ctexpire.c	2005-01-02 01:15:04.000000000 +0100
@@ -0,0 +1,132 @@
+/* ctexpire modification match for IP tables
+ * (C) 2004 by Richard Zheng <richard@o-matrix.org>
+ *
+ * 020105 -- converted to match. Pablo Neira Ayuso <pablo@eurodev.net>
+ * 
+ * Version: 1.1
+ *
+ * This software is distributed under the terms of GNU GPL version 2
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <net/checksum.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_ctexpire.h>
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+
+MODULE_AUTHOR("Richard Zheng <richard@o-matrix.org>");
+MODULE_DESCRIPTION("IP tables ctexpire modification module");
+MODULE_LICENSE("GPL");
+
+static int
+ipt_ctexpire_match(const struct sk_buff *skb,
+		   const struct net_device *in,
+		   const struct net_device *out,
+		   const void *matchinfo,
+		   int offset,
+		   int *hotdrop)
+{
+	const struct ipt_ctexpire_info *info = matchinfo;
+	unsigned long new_expires = 0UL;
+	enum ip_conntrack_info ctinfo;
+	struct ip_conntrack *ct = ip_conntrack_get(skb, &ctinfo);
+
+	if (ct == NULL) 
+		return 0;
+
+	IP_NF_ASSERT(ct->timeout.data == (unsigned long)ct);
+
+	new_expires = info->expires*HZ;
+
+#ifdef EXTRADEBUG
+	DEBUGP(KERN_WARNING "ctexpire: fired = %s, mode %d, value %ld\n",
+	       !is_confirmed(ct) ? "no" : "yes", info->mode, info->expires);
+	unsigned long enter = ct->timeout.expires;
+#endif
+
+	switch (info->mode) {
+	case IPT_CTEXPIRE_SET:
+		break;
+	case IPT_CTEXPIRE_INC:
+		/* If not in hash table, timer will not be active yet */
+		if (!is_confirmed(ct)) 
+			/* TODO should we check if counter overflow?
+			 * other kernel function didn't check this */
+			new_expires += ct->timeout.expires; 
+		 else 
+			new_expires += ct->timeout.expires - jiffies;
+		break;
+	case IPT_CTEXPIRE_DEC:
+		/* If not in hash table, timer will not be active yet */
+		if (!is_confirmed(ct)) {
+			new_expires = (ct->timeout.expires <= new_expires) ?
+				 0 : (ct->timeout.expires - new_expires);
+		} else {
+			new_expires = 
+			    (ct->timeout.expires - jiffies <= new_expires) ? 
+			     0 : (ct->timeout.expires - jiffies - new_expires);
+			}
+			break;
+		default:
+			/* Shouldn't happen */
+			break;
+	}
+
+
+	ip_ct_refresh_acct(ct, 0, NULL, new_expires);
+
+#ifdef EXTRADEBUG
+	printk(KERN_WARNING 
+	       "ctexpire: enter = %ld/%ld, exit = %ld/%ld, diff = %ld\n", 
+	       enter, enter-jiffies, ct->timeout.expires, 
+	       ct->timeout.expires-jiffies, ct->timeout.expires - enter);
+#endif
+
+	return 0;
+}
+
+static int
+ipt_ctexpire_checkentry(const char *tablename,
+			const struct ipt_ip *ip,
+			void *matchinfo,
+			unsigned int matchsize,
+			unsigned int hook_mask)
+{
+	if (matchsize != IPT_ALIGN(sizeof(struct ipt_ctexpire_info))) {
+		printk(KERN_WARNING "ctexpire: targinfosize %u != %Zu\n",
+			matchsize,
+			IPT_ALIGN(sizeof(struct ipt_ctexpire_info)));
+		return 0;
+	}
+
+	if (strcmp(tablename, "raw") == 0) {
+		printk(KERN_WARNING "ctexpire can't be used in the raw' table");
+		return 0;
+	}
+
+	return 1;
+}
+
+static struct ipt_match ipt_ctexpire = {
+	.name 		= "ctexpire",
+	.match 		= ipt_ctexpire_match,
+	.checkentry 	= ipt_ctexpire_checkentry,
+	.me 		= THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	return ipt_register_match(&ipt_ctexpire);
+}
+
+static void __exit fini(void)
+{
+	ipt_unregister_match(&ipt_ctexpire);
+}
+
+module_init(init);
+module_exit(fini);
+
--- /dev/null	2004-09-23 01:18:13.000000000 +0200
+++ include/linux/netfilter_ipv4/ipt_ctexpire.h	2005-01-02 00:18:18.000000000 +0100
@@ -0,0 +1,19 @@
+/* CTEXPIRE modification module for IP tables
+ * (C) 2004 by Richard Zheng <richard@o-matrix.org> */
+
+#ifndef _IPT_CTEXPIRE_H
+#define _IPT_CTEXPIRE_H
+
+enum {
+	IPT_CTEXPIRE_SET = 0,
+	IPT_CTEXPIRE_INC,
+	IPT_CTEXPIRE_DEC
+};
+
+#define IPT_CTEXPIRE_MAXMODE	IPT_CTEXPIRE_DEC
+
+struct ipt_ctexpire_info {
+	u_int8_t	mode;
+	unsigned long expires;
+};
+#endif

--------------020406010108000701040705
Content-Type: text/x-patch;
 name="ctexpire-iptables.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ctexpire-iptables.patch"

Index: include/linux/netfilter_ipv4/ipt_ctexpire.h
===================================================================
--- include/linux/netfilter_ipv4/ipt_ctexpire.h	(revision 0)
+++ include/linux/netfilter_ipv4/ipt_ctexpire.h	(revision 0)
@@ -0,0 +1,23 @@
+/* CTEXPIRE modification module for IP tables
+ * (C) 2004 by Richard Zheng <richard@o-matrix.org> */
+
+#ifndef _IPT_CTEXPIRE_H
+#define _IPT_CTEXPIRE_H
+
+enum {
+	IPT_CTEXPIRE_SET = 0,
+	IPT_CTEXPIRE_INC,
+	IPT_CTEXPIRE_DEC
+};
+
+#define IPT_CTEXPIRE_MAXMODE	IPT_CTEXPIRE_DEC
+
+struct ipt_ctexpire_info {
+	u_int8_t	mode;
+#ifdef KERNEL_64_USERSPACE_32
+	unsigned long long expires;
+#else
+	unsigned long expires;
+#endif
+};
+#endif
Index: extensions/libipt_ctexpire.c
===================================================================
--- extensions/libipt_ctexpire.c	(revision 0)
+++ extensions/libipt_ctexpire.c	(revision 0)
@@ -0,0 +1,199 @@
+/* Shared library add-on to iptables for the ctexpire match
+ * (C) 2004 by Richard Zheng <richard@o-matrix.org>
+ *
+ * $Id: libipt_ctexpire.c,v 1.0 2004/12/01 16:08:16 richard Exp $
+ *
+ * 020105 Converted to match -- Pablo Neira Ayuso <pablo@eurodev.net>
+ *
+ * This program is distributed under the terms of GNU GPL version 2
+ */
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <iptables.h>
+#include <sys/param.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include "../include/linux/netfilter_ipv4/ipt_ctexpire.h"
+
+#define IPT_CTEXPIRE_USED	1
+
+static void init(struct ipt_entry_match *t, unsigned int *nfcache) 
+{
+}
+
+static void help(void) 
+{
+	printf(
+"ctexpire match v%s options\n"
+"  --ctexpire-set value		Set conntrack expire to <value>\n"
+"  --ctexpire-dec value		Decrement conntrack expire by <value>\n"
+"  --ctexpire-inc value		Increment conntrack expire by <value>\n"
+, IPTABLES_VERSION);
+}
+
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ipt_entry *entry,
+      unsigned int *nfcache,
+      struct ipt_entry_match **match)
+{
+	struct ipt_ctexpire_info *info = 
+		(struct ipt_ctexpire_info *) (*match)->data;
+#ifdef KERNEL_64_USERSPACE_32
+	unsigned long long value, HZ_value;
+#else
+	unsigned long value, HZ_value;
+#endif
+
+	if (*flags & IPT_CTEXPIRE_USED) {
+		exit_error(PARAMETER_PROBLEM, 
+		           "Can't specify conntrack expire option twice");
+	}
+
+	if (!optarg) 
+		exit_error(PARAMETER_PROBLEM, 
+		           "ctexpire: You must specify a value");
+
+	if (check_inverse(optarg, &invert, NULL, 0))
+		exit_error(PARAMETER_PROBLEM,
+		       	   "ctexpire: unexpected `!'");
+	
+#ifdef KERNEL_64_USERSPACE_32
+	if (string_to_number_ll(optarg, 0, 0, &value) == -1)
+		exit_error(PARAMETER_PROBLEM, 
+			   "expire value invalid: `%s'\n", optarg);
+#else
+	if (string_to_number_l(optarg, 0, 0, &value) == -1)
+		exit_error(PARAMETER_PROBLEM, 
+		           "expire value invalid: `%s'\n", optarg);
+#endif
+
+	HZ_value = value*HZ;
+
+	if (HZ_value < value) {
+		/* if user specified value is too big, 
+		 * *HZ can overflow the counter
+		 */
+		exit_error(PARAMETER_PROBLEM, 
+		 "expire value too big, will overflow counter: `%s'\n", optarg);
+	}
+
+	switch (c) {
+		case '1':
+			info->mode = IPT_CTEXPIRE_SET;
+			break;
+
+		case '2':
+			if (value == 0) {
+				exit_error(PARAMETER_PROBLEM,
+					"ctexpire: decreasing by 0?");
+			}
+
+			info->mode = IPT_CTEXPIRE_DEC;
+			break;
+
+		case '3':
+			if (value == 0) {
+				exit_error(PARAMETER_PROBLEM,
+					"ctexpire: increasing by 0?");
+			}
+
+			info->mode = IPT_CTEXPIRE_INC;
+			break;
+
+		default:
+			return 0;
+
+	}
+	
+	info->expires = value;
+	*flags |= IPT_CTEXPIRE_USED;
+
+	return 1;
+}
+
+static void final_check(unsigned int flags)
+{
+	if (!(flags & IPT_CTEXPIRE_USED))
+		exit_error(PARAMETER_PROBLEM, 
+				"ctexpire: You must specify an action");
+}
+
+static void save(const struct ipt_ip *ip,
+		const struct ipt_entry_match *match)
+{
+	const struct ipt_ctexpire_info *info = 
+		(struct ipt_ctexpire_info *) match->data;
+
+	switch (info->mode) {
+		case IPT_CTEXPIRE_SET:
+			printf("--ctexpire-set ");
+			break;
+		case IPT_CTEXPIRE_DEC:
+			printf("--ctexpire-dec ");
+			break;
+
+		case IPT_CTEXPIRE_INC:
+			printf("--ctexpire-inc ");
+			break;
+	}
+#ifdef KERNEL_64_USERSPACE_32
+	printf("%llu ", info->expires);
+#else
+	printf("%lu ", info->expires);
+#endif
+}
+
+static void print(const struct ipt_ip *ip,
+		const struct ipt_entry_match *match, int numeric)
+{
+	const struct ipt_ctexpire_info *info =
+		(struct ipt_ctexpire_info *) match->data;
+
+	printf("ctexpire ");
+	switch (info->mode) {
+		case IPT_CTEXPIRE_SET:
+			printf("set to ");
+			break;
+		case IPT_CTEXPIRE_DEC:
+			printf("decrement by ");
+			break;
+		case IPT_CTEXPIRE_INC:
+			printf("increment by ");
+			break;
+	}
+#ifdef KERNEL_64_USERSPACE_32
+	printf("%llu ", info->expires);
+#else
+	printf("%lu ", info->expires);
+#endif
+}
+
+static struct option opts[] = {
+	{ "ctexpire-set", 1, 0, '1' },
+	{ "ctexpire-dec", 1, 0, '2' },
+	{ "ctexpire-inc", 1, 0, '3' },
+	{ 0 }
+};
+
+static
+struct iptables_match ipt_ctexpire = {
+	.name 		= "ctexpire",
+	.version	= IPTABLES_VERSION,
+	.size		= IPT_ALIGN(sizeof(struct ipt_ctexpire_info)),
+	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_ctexpire_info)),
+	.help		= help,
+	.init		= init,
+	.parse		= parse,
+	.final_check	= final_check,
+	.print 		= print,
+	.save		= save,
+	.extra_opts	= opts
+};
+
+void _init(void)
+{
+	register_match(&ipt_ctexpire);
+}

--------------020406010108000701040705--
