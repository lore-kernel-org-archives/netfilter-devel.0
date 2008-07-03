From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH,RFC] Route match
Date: Wed, 2 Jul 2008 17:39:42 -0700
Message-ID: <20080703003942.GA2012@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="G4iJoqBmSsgzjUCe"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:41431
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750899AbYGCAqX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jul 2008 20:46:23 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Attached is a new "route" match, which matches against entries
in the kernel routing table.  I've had a need for this functionality
for quite some time, and finally decided to code it up.  

TODO: add IPv6 support to kernel side

Options

[!] --route-src-exists      Route for src exists
    --route-src-eq value    Route for src exists with prefix-length == value
    --route-src-gt value    Route for src exists with prefix-length  > value
    --route-src-lt value    Route for src exists with prefix-length  < value
[!] --route-dst-exists      Route for dst exists
    --route-dst-eq value    Route for dst exists with prefix-length == value
    --route-dst-gt value    Route for dst exists with prefix-length  > value
    --route-dst-lt value    Route for dst exists with prefix-length  < value

Examples:

	Egress filtering:
		iptables -A FORWARD -m route ! --route-src-exists -j DROP

	Ingress filtering:
		iptables -A FORWARD -i $EXTERNAL_IF -m route --route-src-exists -j DROP

	Allow a user to only browse internal websites:
		iptables -A FORWARD -p tcp --dport 80 -m route --route-dst-exists -j ACCEPT

	Allow an SNMP collector to reach all internal routers (/30 or /32 interfaces)
		iptables -A FORWARD -p udp --dport 161 -m route --route-dst-gt 29 -j ACCEPT


Please let me know if anyone else finds this match useful.

Phil

--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-route-kernel

diff --git a/include/linux/netfilter/xt_route.h b/include/linux/netfilter/xt_route.h
new file mode 100644
index 0000000..0c90494
--- /dev/null
+++ b/include/linux/netfilter/xt_route.h
@@ -0,0 +1,21 @@
+#ifndef _XT_ROUTE_H
+#define _XT_ROUTE_H
+
+enum {
+	XT_ROUTE_SRC_EXISTS = 0,
+	XT_ROUTE_SRC_EQ,
+	XT_ROUTE_SRC_GT,
+	XT_ROUTE_SRC_LT,
+	XT_ROUTE_DST_EXISTS,
+	XT_ROUTE_DST_EQ,
+	XT_ROUTE_DST_GT,
+	XT_ROUTE_DST_LT,
+};
+
+struct xt_route_info {
+	u_int8_t	invert;
+	u_int8_t	mode;
+	u_int8_t	prefixlen;
+};
+
+#endif /*_XT_ROUTE_H*/
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 0d4d728..22bbdd5 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -156,6 +156,8 @@ void free_fib_info(struct fib_info *fi)
 	kfree(fi);
 }
 
+EXPORT_SYMBOL_GPL(free_fib_info);
+
 void fib_release_info(struct fib_info *fi)
 {
 	spin_lock_bh(&fib_info_lock);
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index aa8d80c..128b186 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -724,6 +724,16 @@ config NETFILTER_XT_MATCH_REALM
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
+config NETFILTER_XT_MATCH_ROUTE
+	tristate '"route" match support'
+	depends on NETFILTER_XTABLES
+	depends on NETFILTER_ADVANCED
+	help
+	  This option adds a `route' match, which allows you to match on
+	  the kernel routing table.  
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NETFILTER_XT_MATCH_SCTP
 	tristate  '"sctp" protocol match support (EXPERIMENTAL)'
 	depends on NETFILTER_XTABLES && EXPERIMENTAL
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 5c4b183..1035372 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -76,6 +76,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_POLICY) += xt_policy.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_QUOTA) += xt_quota.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_RATEEST) += xt_rateest.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_REALM) += xt_realm.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_ROUTE) += xt_route.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_SCTP) += xt_sctp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATE) += xt_state.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATISTIC) += xt_statistic.o
diff --git a/net/netfilter/xt_route.c b/net/netfilter/xt_route.c
new file mode 100644
index 0000000..c6e9f94
--- /dev/null
+++ b/net/netfilter/xt_route.c
@@ -0,0 +1,141 @@
+/* Kernel module to match against the kernel routing table. */
+/* (C) 2008 Phil Oester <kernel@linuxace.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ipv6.h>
+#include <net/ip.h>
+#include <net/flow.h>
+#include <net/ip_fib.h>
+
+#include <linux/netfilter/xt_route.h>
+#include <linux/netfilter/x_tables.h>
+
+MODULE_AUTHOR("Phil Oester <kernel@linuxace.com>");
+MODULE_DESCRIPTION("Xtables: Routing table match");
+MODULE_LICENSE("GPL");
+
+static bool
+route_mt(const struct sk_buff *skb, const struct net_device *in,
+          const struct net_device *out, const struct xt_match *match,
+          const void *matchinfo, int offset, unsigned int protoff,
+          bool *hotdrop)
+{
+	const struct xt_route_info *info = matchinfo;
+	const struct iphdr *iph = ip_hdr(skb);
+	struct fib_result res = {0};
+	struct flowi fl = {0};
+	int ret;
+
+	switch (info->mode) {
+	case XT_ROUTE_SRC_EXISTS:
+		fl.nl_u.ip4_u.daddr = iph->saddr;
+		ret = fib_lookup(dev_net(in), &fl, &res);
+		if (ret == 0 && res.prefixlen != 0) {
+			fib_res_put(&res);
+			return true ^ info->invert;
+		}
+	case XT_ROUTE_SRC_EQ:
+		fl.nl_u.ip4_u.daddr = iph->saddr;
+		ret = fib_lookup(dev_net(in), &fl, &res);
+		if (ret == 0 && res.prefixlen == info->prefixlen) {
+			fib_res_put(&res);
+			return true;
+		}
+		break;
+	case XT_ROUTE_SRC_GT:
+		fl.nl_u.ip4_u.daddr = iph->saddr;
+		ret = fib_lookup(dev_net(in), &fl, &res);
+		if (ret == 0 && res.prefixlen > info->prefixlen) {
+			fib_res_put(&res);
+			return true;
+		}
+		break;
+	case XT_ROUTE_SRC_LT:
+		fl.nl_u.ip4_u.daddr = iph->saddr;
+		ret = fib_lookup(dev_net(in), &fl, &res);
+		if (ret == 0 && res.prefixlen < info->prefixlen) {
+			fib_res_put(&res);
+			return true;
+		}
+		break;
+	case XT_ROUTE_DST_EXISTS:
+		fl.nl_u.ip4_u.daddr = iph->daddr;
+		ret = fib_lookup(dev_net(in), &fl, &res);
+		if (ret == 0 && res.prefixlen != 0) {
+			fib_res_put(&res);
+			return true ^ info->invert;
+		}
+		break;
+	case XT_ROUTE_DST_EQ:
+		fl.nl_u.ip4_u.daddr = iph->daddr;
+		ret = fib_lookup(dev_net(in), &fl, &res);
+		if (ret == 0 && res.prefixlen == info->prefixlen) {
+			fib_res_put(&res);
+			return true;
+		}
+		break;
+	case XT_ROUTE_DST_GT:
+		fl.nl_u.ip4_u.daddr = iph->daddr;
+		ret = fib_lookup(dev_net(in), &fl, &res);
+		if (ret == 0 && res.prefixlen > info->prefixlen) {
+			fib_res_put(&res);
+			return true;
+		}
+		break;
+	case XT_ROUTE_DST_LT:
+		fl.nl_u.ip4_u.daddr = iph->daddr;
+		ret = fib_lookup(dev_net(in), &fl, &res);
+		if (ret == 0 && res.prefixlen < info->prefixlen) {
+			fib_res_put(&res);
+			return true;
+		}
+		break;
+	}
+
+	return false;
+}
+
+static bool
+route_mt6(const struct sk_buff *skb, const struct net_device *in,
+           const struct net_device *out, const struct xt_match *match,
+           const void *matchinfo, int offset, unsigned int protoff,
+           bool *hotdrop)
+{
+	return 1;
+}
+
+static struct xt_match route_mt_reg[] __read_mostly = {
+	{
+		.name		= "route",
+		.family		= AF_INET,
+		.match		= route_mt,
+		.matchsize	= sizeof(struct xt_route_info),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "route",
+		.family		= AF_INET6,
+		.match		= route_mt6,
+		.matchsize	= sizeof(struct xt_route_info),
+		.me		= THIS_MODULE,
+	},
+};
+
+static int __init route_mt_init(void)
+{
+	return xt_register_matches(route_mt_reg, ARRAY_SIZE(route_mt_reg));
+}
+
+static void __exit route_mt_exit(void)
+{
+	xt_unregister_matches(route_mt_reg, ARRAY_SIZE(route_mt_reg));
+}
+
+module_init(route_mt_init);
+module_exit(route_mt_exit);

--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-route-user

diff --git a/extensions/libxt_route.c b/extensions/libxt_route.c
new file mode 100644
index 0000000..a2187cb
--- /dev/null
+++ b/extensions/libxt_route.c
@@ -0,0 +1,371 @@
+/* Shared library add-on to iptables to add route matching support 
+ * (C) 2008 by Phil Oester <kernel@linuxace.com>
+ *
+ * This program is released under the terms of GNU GPL */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <getopt.h>
+#include <iptables.h>
+
+#include <xtables.h>
+#include <linux/netfilter/xt_route.h>
+
+static void route_help(void)
+{
+	printf(
+"route match options:\n"
+"  [!] --route-src-exists	Route for src exists\n"
+"      --route-src-eq value	Route for src exists with prefix-length == value\n"
+"      --route-src-gt value	Route for src exists with prefix-length  > value\n"
+"      --route-src-lt value	Route for src exists with prefix-length  < value\n"
+"  [!] --route-dst-exists	Route for dst exists\n"
+"      --route-dst-eq value	Route for dst exists with prefix-length == value\n"
+"      --route-dst-gt value	Route for dst exists with prefix-length  > value\n"
+"      --route-dst-lt value	Route for dst exists with prefix-length  < value\n");
+}
+
+static const struct option route_opts[] = {
+	{ "route-src-exists", 0, NULL, '1' },
+	{ "route-src-eq", 1, NULL, '2' },
+	{ "route-src-gt", 1, NULL, '3' },
+	{ "route-src-lt", 1, NULL, '4' },
+	{ "route-dst-exists", 0, NULL, '5' },
+	{ "route-dst-eq", 1, NULL, '6' },
+	{ "route-dst-gt", 1, NULL, '7' },
+	{ "route-dst-lt", 1, NULL, '8' },
+	{ .name = NULL }
+};
+
+static int route_parse(int c, char **argv, int invert, unsigned int *flags,
+                       const void *entry, struct xt_entry_match **match)
+{
+	struct xt_route_info *info = (struct xt_route_info *) (*match)->data;
+	unsigned int value;
+
+	check_inverse(optarg, &invert, &optind, 0);
+
+	switch (c) {
+		case '1':
+			if (invert)
+				info->invert = 1;
+
+			info->mode = XT_ROUTE_SRC_EXISTS;			
+			break;
+		case '2':
+			if (invert) 
+				exit_error(PARAMETER_PROBLEM,
+						"route: unexpected `!'");
+
+			if (string_to_number(optarg, 1, 32, &value) == -1)
+				exit_error(PARAMETER_PROBLEM,
+				           "route: Expected prefix between 1 and 32");
+
+			info->mode = XT_ROUTE_SRC_EQ;
+			info->value = value;
+			break;
+		case '3':
+			if (invert) 
+				exit_error(PARAMETER_PROBLEM,
+						"route: unexpected `!'");
+
+			if (string_to_number(optarg, 0, 31, &value) == -1)
+				exit_error(PARAMETER_PROBLEM,
+				           "route: Expected prefix between 0 and 31");
+
+			info->mode = XT_ROUTE_SRC_GT;
+			info->value = value;
+			break;
+		case '4':
+			if (invert) 
+				exit_error(PARAMETER_PROBLEM,
+						"route: unexpected `!'");
+
+			if (string_to_number(optarg, 2, 32, &value) == -1)
+				exit_error(PARAMETER_PROBLEM,
+				           "route: Expected prefix between 2 and 32");
+
+			info->mode = XT_ROUTE_SRC_LT;
+			info->value = value;
+			break;
+		case '5':
+			if (invert)
+				info->invert = 1;
+
+			info->mode = XT_ROUTE_DST_EXISTS;			
+			break;
+		case '6':
+			if (invert) 
+				exit_error(PARAMETER_PROBLEM,
+						"route: unexpected `!'");
+
+			if (string_to_number(optarg, 1, 32, &value) == -1)
+				exit_error(PARAMETER_PROBLEM,
+				           "route: Expected prefix between 1 and 32");
+
+			info->mode = XT_ROUTE_DST_EQ;
+			info->value = value;
+			break;
+		case '7':
+			if (invert) 
+				exit_error(PARAMETER_PROBLEM,
+						"route: unexpected `!'");
+
+			if (string_to_number(optarg, 0, 31, &value) == -1)
+				exit_error(PARAMETER_PROBLEM,
+				           "route: Expected prefix between 0 and 31");
+
+			info->mode = XT_ROUTE_DST_GT;
+			info->value = value;
+			break;
+		case '8':
+			if (invert) 
+				exit_error(PARAMETER_PROBLEM,
+						"route: unexpected `!'");
+
+			if (string_to_number(optarg, 2, 32, &value) == -1)
+				exit_error(PARAMETER_PROBLEM,
+				           "route: Expected prefix between 2 and 32");
+
+			info->mode = XT_ROUTE_DST_LT;
+			info->value = value;
+			break;
+		default:
+			return 0;
+
+	}
+
+	if (*flags) 
+		exit_error(PARAMETER_PROBLEM, 
+				"Can't specify route match twice");
+	*flags = 1;
+
+	return 1;
+}
+
+static int route_parse6(int c, char **argv, int invert, unsigned int *flags,
+                       const void *entry, struct xt_entry_match **match)
+{
+	struct xt_route_info *info = (struct xt_route_info *) (*match)->data;
+	unsigned int value;
+
+	check_inverse(optarg, &invert, &optind, 0);
+
+	switch (c) {
+		case '1':
+			if (invert)
+				info->invert = 1;
+
+			info->mode = XT_ROUTE_SRC_EXISTS;			
+			break;
+		case '2':
+			if (invert) 
+				exit_error(PARAMETER_PROBLEM,
+						"route: unexpected `!'");
+
+			if (string_to_number(optarg, 1, 128, &value) == -1)
+				exit_error(PARAMETER_PROBLEM,
+				           "route: Expected prefix between 1 and 128");
+
+			info->mode = XT_ROUTE_SRC_EQ;
+			info->value = value;
+			break;
+		case '3':
+			if (invert) 
+				exit_error(PARAMETER_PROBLEM,
+						"route: unexpected `!'");
+
+			if (string_to_number(optarg, 0, 127, &value) == -1)
+				exit_error(PARAMETER_PROBLEM,
+				           "route: Expected prefix between 0 and 127");
+
+			info->mode = XT_ROUTE_SRC_GT;
+			info->value = value;
+			break;
+		case '4':
+			if (invert) 
+				exit_error(PARAMETER_PROBLEM,
+						"route: unexpected `!'");
+
+			if (string_to_number(optarg, 2, 128, &value) == -1)
+				exit_error(PARAMETER_PROBLEM,
+				           "route: Expected prefix between 2 and 128");
+
+			info->mode = XT_ROUTE_SRC_LT;
+			info->value = value;
+			break;
+		case '5':
+			if (invert)
+				info->invert = 1;
+
+			info->mode = XT_ROUTE_DST_EXISTS;			
+			break;
+		case '6':
+			if (invert) 
+				exit_error(PARAMETER_PROBLEM,
+						"route: unexpected `!'");
+
+			if (string_to_number(optarg, 1, 128, &value) == -1)
+				exit_error(PARAMETER_PROBLEM,
+				           "route: Expected prefix between 1 and 128");
+
+			info->mode = XT_ROUTE_DST_EQ;
+			info->value = value;
+			break;
+		case '7':
+			if (invert) 
+				exit_error(PARAMETER_PROBLEM,
+						"route: unexpected `!'");
+
+			if (string_to_number(optarg, 0, 127, &value) == -1)
+				exit_error(PARAMETER_PROBLEM,
+				           "route: Expected prefix between 0 and 127");
+
+			info->mode = XT_ROUTE_DST_GT;
+			info->value = value;
+			break;
+		case '8':
+			if (invert) 
+				exit_error(PARAMETER_PROBLEM,
+						"route: unexpected `!'");
+
+			if (string_to_number(optarg, 2, 128, &value) == -1)
+				exit_error(PARAMETER_PROBLEM,
+				           "route: Expected prefix between 2 and 128");
+
+			info->mode = XT_ROUTE_DST_LT;
+			info->value = value;
+			break;
+		default:
+			return 0;
+
+	}
+
+	if (*flags) 
+		exit_error(PARAMETER_PROBLEM, 
+				"Can't specify route match twice");
+	*flags = 1;
+
+	return 1;
+}
+
+static void route_check(unsigned int flags)
+{
+	if (!flags) 
+		exit_error(PARAMETER_PROBLEM,
+			"Route match: You must specify an option");
+}
+
+static void route_print(const void *ip, const struct xt_entry_match *match,
+                      int numeric)
+{
+	const struct xt_route_info *info = 
+		(struct xt_route_info *) match->data;
+
+	printf("Route: ");
+	switch (info->mode) {
+		case XT_ROUTE_SRC_EXISTS:
+			if (info->invert)
+				printf("! ");
+			printf("Src exists ");
+			break;
+		case XT_ROUTE_SRC_EQ:
+			printf("Src prefix == %u ", info->value);
+			break;
+		case XT_ROUTE_SRC_GT:
+			printf("Src prefix > %u ", info->value);
+			break;
+		case XT_ROUTE_SRC_LT:
+			printf("Src prefix < %u ", info->value);
+			break;
+		case XT_ROUTE_DST_EXISTS:
+			if (info->invert)
+				printf("! ");
+			printf("Dst exists ");
+			break;
+		case XT_ROUTE_DST_EQ:
+			printf("Dst prefix == %u ", info->value);
+			break;
+		case XT_ROUTE_DST_GT:
+			printf("Dst prefix > %u ", info->value);
+			break;
+		case XT_ROUTE_DST_LT:
+			printf("Dst prefix < %u ", info->value);
+			break;
+	}
+}
+
+static void route_save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_route_info *info =
+		(struct xt_route_info *) match->data;
+
+	switch (info->mode) {
+		case XT_ROUTE_SRC_EXISTS:
+			if (info->invert)
+				printf("! ");
+			printf("--route-src-exists ");
+			break;
+		case XT_ROUTE_SRC_EQ:
+			printf("--route-src-eq %u ", info->value);
+			break;
+		case XT_ROUTE_SRC_GT:
+			printf("--route-src-gt %u ", info->value);
+			break;
+		case XT_ROUTE_SRC_LT:
+			printf("--route-src-lt %u ", info->value);
+			break;
+		case XT_ROUTE_DST_EXISTS:
+			if (info->invert)
+				printf("! ");
+			printf("--route-dst-exists ");
+			break;
+		case XT_ROUTE_DST_EQ:
+			printf("--route-dst-eq %u ", info->value);
+			break;
+		case XT_ROUTE_DST_GT:
+			printf("--route-dst-gt < %u ", info->value);
+			break;
+		case XT_ROUTE_DST_LT:
+			printf("--route-dst-lt > %u ", info->value);
+			break;
+		default:
+			break;
+	}
+}
+
+static struct xtables_match route_mt = {
+	.name		= "route",
+	.version	= XTABLES_VERSION,
+	.family		= AF_INET,
+	.size		= XT_ALIGN(sizeof(struct xt_route_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_route_info)),
+	.help		= route_help,
+	.parse		= route_parse,
+	.final_check	= route_check,
+	.print		= route_print,
+	.save		= route_save,
+	.extra_opts	= route_opts,
+};
+
+static struct xtables_match route_mt6 = {
+	.name		= "route",
+	.version	= XTABLES_VERSION,
+	.family		= AF_INET6,
+	.size		= XT_ALIGN(sizeof(struct xt_route_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_route_info)),
+	.help		= route_help,
+	.parse		= route_parse6,
+	.final_check	= route_check,
+	.print		= route_print,
+	.save		= route_save,
+	.extra_opts	= route_opts,
+};
+
+
+void _init(void) 
+{
+	xtables_register_match(&route_mt);
+	xtables_register_match(&route_mt6);
+}
diff --git a/include/linux/netfilter/xt_route.h b/include/linux/netfilter/xt_route.h
new file mode 100644
index 0000000..0c90494
--- /dev/null
+++ b/include/linux/netfilter/xt_route.h
@@ -0,0 +1,21 @@
+#ifndef _XT_ROUTE_H
+#define _XT_ROUTE_H
+
+enum {
+	XT_ROUTE_SRC_EXISTS = 0,
+	XT_ROUTE_SRC_EQ,
+	XT_ROUTE_SRC_GT,
+	XT_ROUTE_SRC_LT,
+	XT_ROUTE_DST_EXISTS,
+	XT_ROUTE_DST_EQ,
+	XT_ROUTE_DST_GT,
+	XT_ROUTE_DST_LT,
+};
+
+struct xt_route_info {
+	u_int8_t	invert;
+	u_int8_t	mode;
+	u_int8_t	prefixlen;
+};
+
+#endif /*_XT_ROUTE_H*/

--G4iJoqBmSsgzjUCe--
