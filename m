From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: xt_gateway 20070605 (iptables)
Date: Tue, 5 Jun 2007 13:18:50 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0706051318140.20829@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0706051317150.20829@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0706051317150.20829@yvahk01.tjqt.qr>
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


Subject: Add ipt_gateway to iptables

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 extensions/.gateway-test      |    3 
 extensions/libipt_gateway.c   |  160 ++++++++++++++++++++++++++++++++++++++++++
 extensions/libipt_gateway.man |    9 ++
 3 files changed, 172 insertions(+)

Index: iptables/extensions/.gateway-test
===================================================================
--- /dev/null
+++ iptables/extensions/.gateway-test
@@ -0,0 +1,3 @@
+#!/bin/sh
+# True if gateway match patch is applied.
+[ -f "$KERNEL_DIR/include/linux/netfilter/xt_gateway.h" ] && echo gateway
Index: iptables/extensions/libipt_gateway.c
===================================================================
--- /dev/null
+++ iptables/extensions/libipt_gateway.c
@@ -0,0 +1,160 @@
+/*
+ * Shared library add-on to iptables to add gateway IP address matching support.
+ * Based on iprange
+ * (C) UFO Mechanic <azez@ufomechanic.net>
+ * © Jan Engelhardt <jengelh@gmx.de>, 2007
+ */
+#include <sys/types.h>
+#include <getopt.h>
+#include <netdb.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include <iptables.h>
+#include <linux/netfilter/xt_gateway.h>
+
+static const struct option gateway_opts[] = {
+	{"gateway", 1, NULL, '1'},
+	{"nexthop", 1, NULL, '2'},
+	{NULL},
+};
+
+/* Function which prints out usage message. */
+static void gateway_help(void)
+{
+	printf(
+		"gateway match v%s options:\n"
+		"[!] --gateway ip        Match IP address of routed gateway\n"
+		"[!] --nexthop ip        Match IP address of next hop\n"
+		"\n",
+		IPTABLES_VERSION);
+}
+
+/*
+ * Function which parses command options;
+ * returns true if it ate an option.
+ */
+static int gateway_parse(int c, char **argv, int invert, unsigned int *flags,
+			 const struct ipt_entry *entry, unsigned int *nfcache,
+			 struct ipt_entry_match **match)
+{
+	struct xt_gateway_info *info = (void *)(*match)->data;
+	struct in_addr *ip;
+
+	switch (c) {
+	case '1':
+		if (*flags)
+			exit_error(PARAMETER_PROBLEM, "gateway match: You "
+				"cannot specify both \"--gateway\" and "
+				"\"--nexthop\"");
+
+		check_inverse(optarg, &invert, &optind, 0);
+		if (invert)
+			info->flags |= XT_GATEWAY_INV;
+
+		ip = dotted_to_addr(optarg);
+		if (ip == NULL)
+			exit_error(PARAMETER_PROBLEM, "gateway match: Bad IP "
+				"address \"%s\"\n", optarg);
+
+		info->gateway = ip->s_addr;
+		info->flags  |= XT_GATEWAY_ROUTE;
+		*flags = 1;
+		break;
+
+	case '2':
+		if (*flags)
+			exit_error(PARAMETER_PROBLEM, "gateway match: You "
+				"cannot specify both \"--gateway\" and "
+				"\"--nexthop\"");
+
+		check_inverse(optarg, &invert, &optind, 0);
+		if (invert)
+			info->flags |= XT_GATEWAY_INV;
+
+		ip = dotted_to_addr(optarg);
+		if (ip == NULL)
+			exit_error(PARAMETER_PROBLEM,
+				"gateway match: Bad IP address `%s'\n", optarg);
+
+		info->gateway = ip->s_addr;
+		info->flags  &= XT_GATEWAY_ROUTE;
+		*flags = 1;
+		break;
+
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+/* Final check; must have specified --gateway */
+static void gateway_final_check(unsigned int flags)
+{
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM,
+			"gateway match: You must specify `--gateway' "
+			"or `--nexthop'");
+}
+
+/* Prints out the info. */
+static void gateway_print(const struct ipt_ip *ip,
+			  const struct ipt_entry_match *match, int numeric)
+{
+	const struct xt_gateway_info *info = (const void *)match->data;
+	struct in_addr a;
+
+	a.s_addr = info->gateway;
+
+	if (info->flags & XT_GATEWAY_ROUTE)
+		printf("gateway ");
+	else
+		printf("nexthop ");
+
+	if (info->flags & XT_GATEWAY_INV)
+		printf("! ");
+
+	printf("%s", addr_to_dotted(&a));
+}
+
+/* Saves the union ipt_info in parsable form to stdout. */
+static void gateway_save(const struct ipt_ip *ip,
+			 const struct ipt_entry_match *match)
+{
+	const struct xt_gateway_info *info = (const void *)match->data;
+	struct in_addr a;
+
+	a.s_addr = info->gateway;
+
+	if (info->flags & XT_GATEWAY_INV)
+		printf("! ");
+
+	if (info->flags & XT_GATEWAY_ROUTE)
+		printf("--gateway ");
+	else
+		printf("--nexthop ");
+
+	printf("%s ", addr_to_dotted(&a));
+}
+
+static struct iptables_match gateway_reg = {
+	.next		= NULL,
+	.name		= "gateway",
+	.version	= IPTABLES_VERSION,
+	.size		= IPT_ALIGN(sizeof(struct xt_gateway_info)),
+	.userspacesize	= IPT_ALIGN(sizeof(struct xt_gateway_info)),
+	.help		= gateway_help,
+	.parse		= gateway_parse,
+	.final_check	= gateway_final_check,
+	.print		= gateway_print,
+	.save		= gateway_save,
+	.extra_opts	= gateway_opts,
+};
+
+static __attribute__((constructor)) void libipt_gateway_init(void)
+{
+	register_match(&gateway_reg);
+	return;
+}
Index: iptables/extensions/libipt_gateway.man
===================================================================
--- /dev/null
+++ iptables/extensions/libipt_gateway.man
@@ -0,0 +1,9 @@
+This matches the gateway by IP address on routed packets.
+It does not mach packets that are not routed, or which
+are directly addresses to the gateway.
+.TP
+.BI "[!]" "--gateway " "ip"
+Check that the packet is routed to a gateway with the specified ip address.
+.BI "[!]" "--nexthop " "ip"
+Check if the packet is being directed to the specified ip address
+either directly or as a route.
