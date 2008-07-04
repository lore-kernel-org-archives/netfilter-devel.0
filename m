From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH,RFC] Route match v2
Date: Fri, 4 Jul 2008 11:43:31 -0700
Message-ID: <20080704184331.GA24793@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="KsGdsel6WgEHnImy"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:42385
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751164AbYGDSnc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jul 2008 14:43:32 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Attached is a new "route" match, which matches against entries
in the kernel routing table.

Changes since v1:
  * IPv6 support in kernel
  * Invert support for ALL options
  * Various cleanup in userspace code (C99 initializers & unified v4/v6 parse)

I've tested the IPv6 support as best I can, but I'd appreciate someone who
actually has production v6 nets giving it a run through.


Options:

[!] --route-src-exists      Route for src exists
[!] --route-src-eq value    Route for src exists with prefix-length == value
[!] --route-src-gt value    Route for src exists with prefix-length  > value
[!] --route-src-lt value    Route for src exists with prefix-length  < value
[!] --route-dst-exists      Route for dst exists
[!] --route-dst-eq value    Route for dst exists with prefix-length == value
[!] --route-dst-gt value    Route for dst exists with prefix-length  > value
[!] --route-dst-lt value    Route for dst exists with prefix-length  < value


Examples:

        Egress filtering (similar to rp_filter, but not silently dropped):
                iptables -N spoofer -j LOG --log-prefix "Spoofed packet dropped: "
                iptables -N spoofer -j DROP
                iptables -A FORWARD -i $INTERNAL_IF -m route ! --route-src-exists -j spoofer

        rp_filter functionality on IPv6:
                ip6tables -A FORWARD -i $EXTERNAL_IF -m route --route-src-exists -j DROP

        Allow a user to only browse internal websites:
                iptables -A FORWARD -p tcp --dport 80 -m route --route-dst-exists -j ACCEPT

        Allow an SNMP collector to reach all internal routers (/30 or /32)
                iptables -A FORWARD -p udp --dport 161 -m route --route-dst-gt 29 -j ACCEPT


Comments?

Phil



--KsGdsel6WgEHnImy
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
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 1ee4fa1..5d6419f 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -897,6 +897,8 @@ struct fib6_node * fib6_lookup(struct fib6_node *root, struct in6_addr *daddr,
 	return fn;
 }
 
+EXPORT_SYMBOL_GPL(fib6_lookup);
+
 /*
  *	Get node with specified destination prefix (and source prefix,
  *	if subtrees are used)
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
index 0000000..87b0b0f
--- /dev/null
+++ b/net/netfilter/xt_route.c
@@ -0,0 +1,197 @@
+/* Kernel module to match against the kernel routing table.
+ * (C) 2008 Phil Oester <kernel@linuxace.com>
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
+#include <net/ip6_fib.h>
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
+			return true ^ info->invert;
+		}
+		break;
+	case XT_ROUTE_SRC_GT:
+		fl.nl_u.ip4_u.daddr = iph->saddr;
+		ret = fib_lookup(dev_net(in), &fl, &res);
+		if (ret == 0 && res.prefixlen > info->prefixlen) {
+			fib_res_put(&res);
+			return true ^ info->invert;
+		}
+		break;
+	case XT_ROUTE_SRC_LT:
+		fl.nl_u.ip4_u.daddr = iph->saddr;
+		ret = fib_lookup(dev_net(in), &fl, &res);
+		if (ret == 0 && res.prefixlen < info->prefixlen) {
+			fib_res_put(&res);
+			return true ^ info->invert;
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
+			return true ^ info->invert;
+		}
+		break;
+	case XT_ROUTE_DST_GT:
+		fl.nl_u.ip4_u.daddr = iph->daddr;
+		ret = fib_lookup(dev_net(in), &fl, &res);
+		if (ret == 0 && res.prefixlen > info->prefixlen) {
+			fib_res_put(&res);
+			return true ^ info->invert;
+		}
+		break;
+	case XT_ROUTE_DST_LT:
+		fl.nl_u.ip4_u.daddr = iph->daddr;
+		ret = fib_lookup(dev_net(in), &fl, &res);
+		if (ret == 0 && res.prefixlen < info->prefixlen) {
+			fib_res_put(&res);
+			return true ^ info->invert;
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
+	const struct xt_route_info *info = matchinfo;
+	const struct ipv6hdr *iph = ipv6_hdr(skb);
+	struct fib6_node *fn;
+	struct flowi fl = {0};
+
+	switch (info->mode) {
+	case XT_ROUTE_SRC_EXISTS:
+		fl.nl_u.ip6_u.daddr = iph->saddr;
+		fn = fib6_lookup(&dev_net(in)->ipv6.fib6_main_tbl->tb6_root, &fl.fl6_dst, NULL);
+		if (fn && fn->fn_bit != 0)
+			return true ^ info->invert;
+		break;
+	case XT_ROUTE_SRC_EQ:
+		fl.nl_u.ip6_u.daddr = iph->saddr;
+		fn = fib6_lookup(&dev_net(in)->ipv6.fib6_main_tbl->tb6_root, &fl.fl6_dst, NULL);
+		if (fn && fn->fn_bit == info->prefixlen)
+			return true ^ info->invert;
+		break;
+	case XT_ROUTE_SRC_GT:
+		fl.nl_u.ip6_u.daddr = iph->saddr;
+		fn = fib6_lookup(&dev_net(in)->ipv6.fib6_main_tbl->tb6_root, &fl.fl6_dst, NULL);
+		if (fn && fn->fn_bit > info->prefixlen)
+			return true ^ info->invert;
+		break;
+	case XT_ROUTE_SRC_LT:
+		fl.nl_u.ip6_u.daddr = iph->saddr;
+		fn = fib6_lookup(&dev_net(in)->ipv6.fib6_main_tbl->tb6_root, &fl.fl6_dst, NULL);
+		if (fn && fn->fn_bit < info->prefixlen)
+			return true ^ info->invert;
+		break;
+	case XT_ROUTE_DST_EXISTS:
+		fl.nl_u.ip6_u.daddr = iph->daddr;
+		fn = fib6_lookup(&dev_net(in)->ipv6.fib6_main_tbl->tb6_root, &fl.fl6_dst, NULL);
+		if (fn && fn->fn_bit != 0)
+			return true ^ info->invert;
+		break;
+	case XT_ROUTE_DST_EQ:
+		fl.nl_u.ip6_u.daddr = iph->daddr;
+		fn = fib6_lookup(&dev_net(in)->ipv6.fib6_main_tbl->tb6_root, &fl.fl6_dst, NULL);
+		if (fn && fn->fn_bit == info->prefixlen)
+			return true ^ info->invert;
+		break;
+	case XT_ROUTE_DST_GT:
+		fl.nl_u.ip6_u.daddr = iph->daddr;
+		fn = fib6_lookup(&dev_net(in)->ipv6.fib6_main_tbl->tb6_root, &fl.fl6_dst, NULL);
+		if (fn && fn->fn_bit > info->prefixlen)
+			return true ^ info->invert;
+		break;
+	case XT_ROUTE_DST_LT:
+		fl.nl_u.ip6_u.daddr = iph->daddr;
+		fn = fib6_lookup(&dev_net(in)->ipv6.fib6_main_tbl->tb6_root, &fl.fl6_dst, NULL);
+		if (fn && fn->fn_bit < info->prefixlen)
+			return true ^ info->invert;
+		break;
+	}
+	return false;
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

--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-route-user

diff --git a/extensions/libxt_route.c b/extensions/libxt_route.c
new file mode 100644
index 0000000..5add129
--- /dev/null
+++ b/extensions/libxt_route.c
@@ -0,0 +1,267 @@
+/* Shared library add-on to iptables for route matching support 
+ * (C) 2008 Phil Oester <kernel@linuxace.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
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
+"  [!] --route-src-eq value	Route for src exists with prefix-length == value\n"
+"  [!] --route-src-gt value	Route for src exists with prefix-length  > value\n"
+"  [!] --route-src-lt value	Route for src exists with prefix-length  < value\n"
+"  [!] --route-dst-exists	Route for dst exists\n"
+"  [!] --route-dst-eq value	Route for dst exists with prefix-length == value\n"
+"  [!] --route-dst-gt value	Route for dst exists with prefix-length  > value\n"
+"  [!] --route-dst-lt value	Route for dst exists with prefix-length  < value\n");
+}
+
+static const struct option route_opts[] = {
+	{ .name = "route-src-exists", .has_arg = 0, .val = '1' },
+	{ .name = "route-src-eq",     .has_arg = 1, .val = '2' },
+	{ .name = "route-src-gt",     .has_arg = 1, .val = '3' },
+	{ .name = "route-src-lt",     .has_arg = 1, .val = '4' },
+	{ .name = "route-dst-exists", .has_arg = 0, .val = '5' },
+	{ .name = "route-dst-eq",     .has_arg = 1, .val = '6' },
+	{ .name = "route-dst-gt",     .has_arg = 1, .val = '7' },
+	{ .name = "route-dst-lt",     .has_arg = 1, .val = '8' },
+	{ .name = NULL }
+};
+
+static int route_parse(int c, int invert, unsigned int *flags,
+                       struct xt_route_info *info, unsigned int maxplen)
+{
+	unsigned int value;
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
+				info->invert = 1;
+
+			if (string_to_number(optarg, 1, maxplen, &value) == -1)
+				exit_error(PARAMETER_PROBLEM,
+				           "route: Expected prefix between 1 and %u", maxplen);
+
+			info->mode = XT_ROUTE_SRC_EQ;
+			info->value = value;
+			break;
+		case '3':
+			if (invert)
+				info->invert = 1;
+
+			if (string_to_number(optarg, 0, maxplen-1, &value) == -1)
+				exit_error(PARAMETER_PROBLEM,
+				           "route: Expected prefix between 0 and %u", maxplen-1);
+
+			info->mode = XT_ROUTE_SRC_GT;
+			info->value = value;
+			break;
+		case '4':
+			if (invert)
+				info->invert = 1;
+
+			if (string_to_number(optarg, 2, maxplen, &value) == -1)
+				exit_error(PARAMETER_PROBLEM,
+				           "route: Expected prefix between 2 and %u", maxplen);
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
+				info->invert = 1;
+
+			if (string_to_number(optarg, 1, maxplen, &value) == -1)
+				exit_error(PARAMETER_PROBLEM,
+				           "route: Expected prefix between 1 and %u", maxplen);
+
+			info->mode = XT_ROUTE_DST_EQ;
+			info->value = value;
+			break;
+		case '7':
+			if (invert)
+				info->invert = 1;
+
+			if (string_to_number(optarg, 0, maxplen-1, &value) == -1)
+				exit_error(PARAMETER_PROBLEM,
+				           "route: Expected prefix between 0 and %u", maxplen-1);
+
+			info->mode = XT_ROUTE_DST_GT;
+			info->value = value;
+			break;
+		case '8':
+			if (invert)
+				info->invert = 1;
+
+			if (string_to_number(optarg, 2, maxplen, &value) == -1)
+				exit_error(PARAMETER_PROBLEM,
+				           "route: Expected prefix between 2 and %u", maxplen);
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
+static int route_parse4(int c, char **argv, int invert, unsigned int *flags,
+			const void *entry, struct xt_entry_match **match)
+{
+	return route_parse(c, invert, flags, (void *)(*match)->data, 32);
+}
+
+static int route_parse6(int c, char **argv, int invert, unsigned int *flags,
+			const void *entry, struct xt_entry_match **match)
+{
+	return route_parse(c, invert, flags, (void *)(*match)->data, 128);
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
+	if (info->invert)
+		printf("! ");
+	switch (info->mode) {
+		case XT_ROUTE_SRC_EXISTS:
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
+	if (info->invert)
+		printf("! ");
+	switch (info->mode) {
+		case XT_ROUTE_SRC_EXISTS:
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
+			printf("--route-dst-exists ");
+			break;
+		case XT_ROUTE_DST_EQ:
+			printf("--route-dst-eq %u ", info->value);
+			break;
+		case XT_ROUTE_DST_GT:
+			printf("--route-dst-gt %u ", info->value);
+			break;
+		case XT_ROUTE_DST_LT:
+			printf("--route-dst-lt %u ", info->value);
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
+	.parse		= route_parse4,
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

--KsGdsel6WgEHnImy--
