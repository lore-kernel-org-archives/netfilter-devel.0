From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 39/43] Add IPv6 support to dccp match.
Date: Sun, 15 Jul 2007 03:13:09 +0900 (JST)
Message-ID: <200707141813.l6EIDAPt000823@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
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


---
 extensions/.dccp-test    |    3 -
 extensions/.dccp-testx   |    3 +
 extensions/libipt_dccp.c |  374 -------------------------------------------
 extensions/libxt_dccp.c  |  392 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 395 insertions(+), 377 deletions(-)
 delete mode 100755 extensions/.dccp-test
 create mode 100755 extensions/.dccp-testx
 delete mode 100644 extensions/libipt_dccp.c
 create mode 100644 extensions/libxt_dccp.c

diff --git a/extensions/.dccp-test b/extensions/.dccp-test
deleted file mode 100755
index 5b67527..0000000
--- a/extensions/.dccp-test
+++ /dev/null
@@ -1,3 +0,0 @@
-#!/bin/sh
-# True if dccp is applied.
-[ -f $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_dccp.h ] && echo dccp
diff --git a/extensions/.dccp-testx b/extensions/.dccp-testx
new file mode 100755
index 0000000..a5ad74e
--- /dev/null
+++ b/extensions/.dccp-testx
@@ -0,0 +1,3 @@
+#!/bin/sh
+# True if dccp is applied.
+[ -f $KERNEL_DIR/include/linux/netfilter/xt_dccp.h ] && echo dccp
diff --git a/extensions/libipt_dccp.c b/extensions/libipt_dccp.c
deleted file mode 100644
index 306993a..0000000
--- a/extensions/libipt_dccp.c
+++ /dev/null
@@ -1,374 +0,0 @@
-/* Shared library add-on to iptables for DCCP matching
- *
- * (C) 2005 by Harald Welte <laforge@netfilter.org>
- *
- * This program is distributed under the terms of GNU GPL v2, 1991
- *
- */
-#include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-#include <netdb.h>
-#include <ctype.h>
-
-#include <iptables.h>
-#include <linux/dccp.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/ipt_dccp.h>
-
-#if 0
-#define DEBUGP(format, first...) printf(format, ##first)
-#define static
-#else
-#define DEBUGP(format, fist...) 
-#endif
-
-/* Initialize the match. */
-static void
-init(struct xt_entry_match *m,
-     unsigned int *nfcache)
-{
-	struct ipt_dccp_info *einfo = (struct ipt_dccp_info *)m->data;
-
-	memset(einfo, 0, sizeof(struct ipt_dccp_info));
-}
-
-static void help(void)
-{
-	printf(
-"DCCP match v%s options\n"
-" --source-port [!] port[:port]                          match source port(s)\n"
-" --sport ...\n"
-" --destination-port [!] port[:port]                     match destination port(s)\n"
-" --dport ...\n"
-,
-	IPTABLES_VERSION);
-}
-
-static struct option opts[] = {
-	{ .name = "source-port", .has_arg = 1, .flag = 0, .val = '1' },
-	{ .name = "sport", .has_arg = 1, .flag = 0, .val = '1' },
-	{ .name = "destination-port", .has_arg = 1, .flag = 0, .val = '2' },
-	{ .name = "dport", .has_arg = 1, .flag = 0, .val = '2' },
-	{ .name = "dccp-types", .has_arg = 1, .flag = 0, .val = '3' },
-	{ .name = "dccp-option", .has_arg = 1, .flag = 0, .val = '4' },
-	{ .name = 0 }
-};
-
-static void
-parse_dccp_ports(const char *portstring, 
-		 u_int16_t *ports)
-{
-	char *buffer;
-	char *cp;
-
-	buffer = strdup(portstring);
-	DEBUGP("%s\n", portstring);
-	if ((cp = strchr(buffer, ':')) == NULL) {
-		ports[0] = ports[1] = parse_port(buffer, "dccp");
-	}
-	else {
-		*cp = '\0';
-		cp++;
-
-		ports[0] = buffer[0] ? parse_port(buffer, "dccp") : 0;
-		ports[1] = cp[0] ? parse_port(cp, "dccp") : 0xFFFF;
-
-		if (ports[0] > ports[1])
-			exit_error(PARAMETER_PROBLEM,
-				   "invalid portrange (min > max)");
-	}
-	free(buffer);
-}
-
-static char *dccp_pkt_types[] = {
-	[DCCP_PKT_REQUEST] 	= "REQUEST",
-	[DCCP_PKT_RESPONSE]	= "RESPONSE",
-	[DCCP_PKT_DATA]		= "DATA",
-	[DCCP_PKT_ACK]		= "ACK",
-	[DCCP_PKT_DATAACK]	= "DATAACK",
-	[DCCP_PKT_CLOSEREQ]	= "CLOSEREQ",
-	[DCCP_PKT_CLOSE]	= "CLOSE",
-	[DCCP_PKT_RESET]	= "RESET",
-	[DCCP_PKT_SYNC]		= "SYNC",
-	[DCCP_PKT_SYNCACK]	= "SYNCACK",
-	[DCCP_PKT_INVALID]	= "INVALID",
-};
-
-static u_int16_t
-parse_dccp_types(const char *typestring)
-{
-	u_int16_t typemask = 0;
-	char *ptr, *buffer;
-
-	buffer = strdup(typestring);
-
-	for (ptr = strtok(buffer, ","); ptr; ptr = strtok(NULL, ",")) {
-		unsigned int i;
-		for (i = 0; i < sizeof(dccp_pkt_types)/sizeof(char *); i++) {
-			if (!strcasecmp(dccp_pkt_types[i], ptr)) {
-				typemask |= (1 << i);
-				break;
-			}
-		}
-		if (i == sizeof(dccp_pkt_types)/sizeof(char *))
-			exit_error(PARAMETER_PROBLEM,
-				   "Unknown DCCP type `%s'", ptr);
-	}
-
-	free(buffer);
-	return typemask;
-}
-
-static u_int8_t parse_dccp_option(char *optstring)
-{
-	unsigned int ret;
-
-	if (string_to_number(optstring, 1, 255, &ret) == -1)
-		exit_error(PARAMETER_PROBLEM, "Bad DCCP option `%s'",
-			   optstring);
-
-	return (u_int8_t)ret;
-}
-
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      unsigned int *nfcache,
-      struct xt_entry_match **match)
-{
-	struct ipt_dccp_info *einfo
-		= (struct ipt_dccp_info *)(*match)->data;
-
-	switch (c) {
-	case '1':
-		if (*flags & IPT_DCCP_SRC_PORTS)
-			exit_error(PARAMETER_PROBLEM,
-			           "Only one `--source-port' allowed");
-		einfo->flags |= IPT_DCCP_SRC_PORTS;
-		check_inverse(optarg, &invert, &optind, 0);
-		parse_dccp_ports(argv[optind-1], einfo->spts);
-		if (invert)
-			einfo->invflags |= IPT_DCCP_SRC_PORTS;
-		*flags |= IPT_DCCP_SRC_PORTS;
-		break;
-
-	case '2':
-		if (*flags & IPT_DCCP_DEST_PORTS)
-			exit_error(PARAMETER_PROBLEM,
-				   "Only one `--destination-port' allowed");
-		einfo->flags |= IPT_DCCP_DEST_PORTS;
-		check_inverse(optarg, &invert, &optind, 0);
-		parse_dccp_ports(argv[optind-1], einfo->dpts);
-		if (invert)
-			einfo->invflags |= IPT_DCCP_DEST_PORTS;
-		*flags |= IPT_DCCP_DEST_PORTS;
-		break;
-
-	case '3':
-		if (*flags & IPT_DCCP_TYPE)
-			exit_error(PARAMETER_PROBLEM,
-				   "Only one `--dccp-types' allowed");
-		einfo->flags |= IPT_DCCP_TYPE;
-		check_inverse(optarg, &invert, &optind, 0);
-		einfo->typemask = parse_dccp_types(argv[optind-1]);
-		if (invert)
-			einfo->invflags |= IPT_DCCP_TYPE;
-		*flags |= IPT_DCCP_TYPE;
-		break;
-
-	case '4':
-		if (*flags & IPT_DCCP_OPTION)
-			exit_error(PARAMETER_PROBLEM,
-				   "Only one `--dccp-option' allowed");
-		einfo->flags |= IPT_DCCP_OPTION;
-		check_inverse(optarg, &invert, &optind, 0);
-		einfo->option = parse_dccp_option(argv[optind-1]);
-		if (invert)
-			einfo->invflags |= IPT_DCCP_OPTION;
-		*flags |= IPT_DCCP_OPTION;
-		break;
-	default:
-		return 0;
-	}
-	return 1;
-}
-
-static void
-final_check(unsigned int flags)
-{
-}
-
-static char *
-port_to_service(int port)
-{
-	struct servent *service;
-
-	if ((service = getservbyport(htons(port), "dccp")))
-		return service->s_name;
-
-	return NULL;
-}
-
-static void
-print_port(u_int16_t port, int numeric)
-{
-	char *service;
-
-	if (numeric || (service = port_to_service(port)) == NULL)
-		printf("%u", port);
-	else
-		printf("%s", service);
-}
-
-static void
-print_ports(const char *name, u_int16_t min, u_int16_t max,
-	    int invert, int numeric)
-{
-	const char *inv = invert ? "!" : "";
-
-	if (min != 0 || max != 0xFFFF || invert) {
-		printf("%s", name);
-		if (min == max) {
-			printf(":%s", inv);
-			print_port(min, numeric);
-		} else {
-			printf("s:%s", inv);
-			print_port(min, numeric);
-			printf(":");
-			print_port(max, numeric);
-		}
-		printf(" ");
-	}
-}
-
-static void
-print_types(u_int16_t types, int inverted, int numeric)
-{
-	int have_type = 0;
-
-	if (inverted)
-		printf("! ");
-
-	while (types) {
-		unsigned int i;
-
-		for (i = 0; !(types & (1 << i)); i++);
-
-		if (have_type)
-			printf(",");
-		else
-			have_type = 1;
-
-		if (numeric)
-			printf("%u", i);
-		else
-			printf("%s", dccp_pkt_types[i]);
-
-		types &= ~(1 << i);
-	}
-}
-
-static void
-print_option(u_int8_t option, int invert, int numeric)
-{
-	if (option || invert)
-		printf("option=%s%u ", invert ? "!" : "", option);
-}
-
-/* Prints out the matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
-{
-	const struct ipt_dccp_info *einfo =
-		(const struct ipt_dccp_info *)match->data;
-
-	printf("dccp ");
-
-	if (einfo->flags & IPT_DCCP_SRC_PORTS) {
-		print_ports("spt", einfo->spts[0], einfo->spts[1],
-			einfo->invflags & IPT_DCCP_SRC_PORTS,
-			numeric);
-	}
-
-	if (einfo->flags & IPT_DCCP_DEST_PORTS) {
-		print_ports("dpt", einfo->dpts[0], einfo->dpts[1],
-			einfo->invflags & IPT_DCCP_DEST_PORTS,
-			numeric);
-	}
-
-	if (einfo->flags & IPT_DCCP_TYPE) {
-		print_types(einfo->typemask,
-			   einfo->invflags & IPT_DCCP_TYPE,
-			   numeric);
-	}
-
-	if (einfo->flags & IPT_DCCP_OPTION) {
-		print_option(einfo->option,
-			     einfo->invflags & IPT_DCCP_OPTION, numeric);
-	}
-}
-
-/* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void
-save(const void *ip,
-     const struct xt_entry_match *match)
-{
-	const struct ipt_dccp_info *einfo =
-		(const struct ipt_dccp_info *)match->data;
-
-	if (einfo->flags & IPT_DCCP_SRC_PORTS) {
-		if (einfo->invflags & IPT_DCCP_SRC_PORTS)
-			printf("! ");
-		if (einfo->spts[0] != einfo->spts[1])
-			printf("--sport %u:%u ", 
-			       einfo->spts[0], einfo->spts[1]);
-		else
-			printf("--sport %u ", einfo->spts[0]);
-	}
-
-	if (einfo->flags & IPT_DCCP_DEST_PORTS) {
-		if (einfo->invflags & IPT_DCCP_DEST_PORTS)
-			printf("! ");
-		if (einfo->dpts[0] != einfo->dpts[1])
-			printf("--dport %u:%u ",
-			       einfo->dpts[0], einfo->dpts[1]);
-		else
-			printf("--dport %u ", einfo->dpts[0]);
-	}
-
-	if (einfo->flags & IPT_DCCP_TYPE) {
-		printf("--dccp-type ");
-		print_types(einfo->typemask, einfo->invflags & IPT_DCCP_TYPE,0);
-	}
-
-	if (einfo->flags & IPT_DCCP_OPTION) {
-		printf("--dccp-option %s%u ", 
-			einfo->typemask & IPT_DCCP_OPTION ? "! " : "",
-			einfo->option);
-	}
-}
-
-static
-struct iptables_match dccp
-= { .name          = "dccp",
-    .version       = IPTABLES_VERSION,
-    .size          = IPT_ALIGN(sizeof(struct ipt_dccp_info)),
-    .userspacesize = IPT_ALIGN(sizeof(struct ipt_dccp_info)),
-    .help          = &help,
-    .init          = &init,
-    .parse         = &parse,
-    .final_check   = &final_check,
-    .print         = &print,
-    .save          = &save,
-    .extra_opts    = opts
-};
-
-void _init(void)
-{
-	register_match(&dccp);
-}
-
diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
new file mode 100644
index 0000000..f4918dd
--- /dev/null
+++ b/extensions/libxt_dccp.c
@@ -0,0 +1,392 @@
+/* Shared library add-on to iptables for DCCP matching
+ *
+ * (C) 2005 by Harald Welte <laforge@netfilter.org>
+ *
+ * This program is distributed under the terms of GNU GPL v2, 1991
+ *
+ */
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <netdb.h>
+#include <ctype.h>
+
+#include <xtables.h>
+#include <linux/dccp.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_dccp.h>
+
+#if 0
+#define DEBUGP(format, first...) printf(format, ##first)
+#define static
+#else
+#define DEBUGP(format, fist...) 
+#endif
+
+/* Initialize the match. */
+static void
+init(struct xt_entry_match *m,
+     unsigned int *nfcache)
+{
+	struct xt_dccp_info *einfo = (struct xt_dccp_info *)m->data;
+
+	memset(einfo, 0, sizeof(struct xt_dccp_info));
+}
+
+static void help(void)
+{
+	printf(
+"DCCP match v%s options\n"
+" --source-port [!] port[:port]                          match source port(s)\n"
+" --sport ...\n"
+" --destination-port [!] port[:port]                     match destination port(s)\n"
+" --dport ...\n"
+,
+	IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ .name = "source-port", .has_arg = 1, .flag = 0, .val = '1' },
+	{ .name = "sport", .has_arg = 1, .flag = 0, .val = '1' },
+	{ .name = "destination-port", .has_arg = 1, .flag = 0, .val = '2' },
+	{ .name = "dport", .has_arg = 1, .flag = 0, .val = '2' },
+	{ .name = "dccp-types", .has_arg = 1, .flag = 0, .val = '3' },
+	{ .name = "dccp-option", .has_arg = 1, .flag = 0, .val = '4' },
+	{ .name = 0 }
+};
+
+static void
+parse_dccp_ports(const char *portstring, 
+		 u_int16_t *ports)
+{
+	char *buffer;
+	char *cp;
+
+	buffer = strdup(portstring);
+	DEBUGP("%s\n", portstring);
+	if ((cp = strchr(buffer, ':')) == NULL) {
+		ports[0] = ports[1] = parse_port(buffer, "dccp");
+	}
+	else {
+		*cp = '\0';
+		cp++;
+
+		ports[0] = buffer[0] ? parse_port(buffer, "dccp") : 0;
+		ports[1] = cp[0] ? parse_port(cp, "dccp") : 0xFFFF;
+
+		if (ports[0] > ports[1])
+			exit_error(PARAMETER_PROBLEM,
+				   "invalid portrange (min > max)");
+	}
+	free(buffer);
+}
+
+static char *dccp_pkt_types[] = {
+	[DCCP_PKT_REQUEST] 	= "REQUEST",
+	[DCCP_PKT_RESPONSE]	= "RESPONSE",
+	[DCCP_PKT_DATA]		= "DATA",
+	[DCCP_PKT_ACK]		= "ACK",
+	[DCCP_PKT_DATAACK]	= "DATAACK",
+	[DCCP_PKT_CLOSEREQ]	= "CLOSEREQ",
+	[DCCP_PKT_CLOSE]	= "CLOSE",
+	[DCCP_PKT_RESET]	= "RESET",
+	[DCCP_PKT_SYNC]		= "SYNC",
+	[DCCP_PKT_SYNCACK]	= "SYNCACK",
+	[DCCP_PKT_INVALID]	= "INVALID",
+};
+
+static u_int16_t
+parse_dccp_types(const char *typestring)
+{
+	u_int16_t typemask = 0;
+	char *ptr, *buffer;
+
+	buffer = strdup(typestring);
+
+	for (ptr = strtok(buffer, ","); ptr; ptr = strtok(NULL, ",")) {
+		unsigned int i;
+		for (i = 0; i < sizeof(dccp_pkt_types)/sizeof(char *); i++) {
+			if (!strcasecmp(dccp_pkt_types[i], ptr)) {
+				typemask |= (1 << i);
+				break;
+			}
+		}
+		if (i == sizeof(dccp_pkt_types)/sizeof(char *))
+			exit_error(PARAMETER_PROBLEM,
+				   "Unknown DCCP type `%s'", ptr);
+	}
+
+	free(buffer);
+	return typemask;
+}
+
+static u_int8_t parse_dccp_option(char *optstring)
+{
+	unsigned int ret;
+
+	if (string_to_number(optstring, 1, 255, &ret) == -1)
+		exit_error(PARAMETER_PROBLEM, "Bad DCCP option `%s'",
+			   optstring);
+
+	return (u_int8_t)ret;
+}
+
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const void *entry,
+      unsigned int *nfcache,
+      struct xt_entry_match **match)
+{
+	struct xt_dccp_info *einfo
+		= (struct xt_dccp_info *)(*match)->data;
+
+	switch (c) {
+	case '1':
+		if (*flags & XT_DCCP_SRC_PORTS)
+			exit_error(PARAMETER_PROBLEM,
+			           "Only one `--source-port' allowed");
+		einfo->flags |= XT_DCCP_SRC_PORTS;
+		check_inverse(optarg, &invert, &optind, 0);
+		parse_dccp_ports(argv[optind-1], einfo->spts);
+		if (invert)
+			einfo->invflags |= XT_DCCP_SRC_PORTS;
+		*flags |= XT_DCCP_SRC_PORTS;
+		break;
+
+	case '2':
+		if (*flags & XT_DCCP_DEST_PORTS)
+			exit_error(PARAMETER_PROBLEM,
+				   "Only one `--destination-port' allowed");
+		einfo->flags |= XT_DCCP_DEST_PORTS;
+		check_inverse(optarg, &invert, &optind, 0);
+		parse_dccp_ports(argv[optind-1], einfo->dpts);
+		if (invert)
+			einfo->invflags |= XT_DCCP_DEST_PORTS;
+		*flags |= XT_DCCP_DEST_PORTS;
+		break;
+
+	case '3':
+		if (*flags & XT_DCCP_TYPE)
+			exit_error(PARAMETER_PROBLEM,
+				   "Only one `--dccp-types' allowed");
+		einfo->flags |= XT_DCCP_TYPE;
+		check_inverse(optarg, &invert, &optind, 0);
+		einfo->typemask = parse_dccp_types(argv[optind-1]);
+		if (invert)
+			einfo->invflags |= XT_DCCP_TYPE;
+		*flags |= XT_DCCP_TYPE;
+		break;
+
+	case '4':
+		if (*flags & XT_DCCP_OPTION)
+			exit_error(PARAMETER_PROBLEM,
+				   "Only one `--dccp-option' allowed");
+		einfo->flags |= XT_DCCP_OPTION;
+		check_inverse(optarg, &invert, &optind, 0);
+		einfo->option = parse_dccp_option(argv[optind-1]);
+		if (invert)
+			einfo->invflags |= XT_DCCP_OPTION;
+		*flags |= XT_DCCP_OPTION;
+		break;
+	default:
+		return 0;
+	}
+	return 1;
+}
+
+static void
+final_check(unsigned int flags)
+{
+}
+
+static char *
+port_to_service(int port)
+{
+	struct servent *service;
+
+	if ((service = getservbyport(htons(port), "dccp")))
+		return service->s_name;
+
+	return NULL;
+}
+
+static void
+print_port(u_int16_t port, int numeric)
+{
+	char *service;
+
+	if (numeric || (service = port_to_service(port)) == NULL)
+		printf("%u", port);
+	else
+		printf("%s", service);
+}
+
+static void
+print_ports(const char *name, u_int16_t min, u_int16_t max,
+	    int invert, int numeric)
+{
+	const char *inv = invert ? "!" : "";
+
+	if (min != 0 || max != 0xFFFF || invert) {
+		printf("%s", name);
+		if (min == max) {
+			printf(":%s", inv);
+			print_port(min, numeric);
+		} else {
+			printf("s:%s", inv);
+			print_port(min, numeric);
+			printf(":");
+			print_port(max, numeric);
+		}
+		printf(" ");
+	}
+}
+
+static void
+print_types(u_int16_t types, int inverted, int numeric)
+{
+	int have_type = 0;
+
+	if (inverted)
+		printf("! ");
+
+	while (types) {
+		unsigned int i;
+
+		for (i = 0; !(types & (1 << i)); i++);
+
+		if (have_type)
+			printf(",");
+		else
+			have_type = 1;
+
+		if (numeric)
+			printf("%u", i);
+		else
+			printf("%s", dccp_pkt_types[i]);
+
+		types &= ~(1 << i);
+	}
+}
+
+static void
+print_option(u_int8_t option, int invert, int numeric)
+{
+	if (option || invert)
+		printf("option=%s%u ", invert ? "!" : "", option);
+}
+
+/* Prints out the matchinfo. */
+static void
+print(const void *ip,
+      const struct xt_entry_match *match,
+      int numeric)
+{
+	const struct xt_dccp_info *einfo =
+		(const struct xt_dccp_info *)match->data;
+
+	printf("dccp ");
+
+	if (einfo->flags & XT_DCCP_SRC_PORTS) {
+		print_ports("spt", einfo->spts[0], einfo->spts[1],
+			einfo->invflags & XT_DCCP_SRC_PORTS,
+			numeric);
+	}
+
+	if (einfo->flags & XT_DCCP_DEST_PORTS) {
+		print_ports("dpt", einfo->dpts[0], einfo->dpts[1],
+			einfo->invflags & XT_DCCP_DEST_PORTS,
+			numeric);
+	}
+
+	if (einfo->flags & XT_DCCP_TYPE) {
+		print_types(einfo->typemask,
+			   einfo->invflags & XT_DCCP_TYPE,
+			   numeric);
+	}
+
+	if (einfo->flags & XT_DCCP_OPTION) {
+		print_option(einfo->option,
+			     einfo->invflags & XT_DCCP_OPTION, numeric);
+	}
+}
+
+/* Saves the union ipt_matchinfo in parsable form to stdout. */
+static void
+save(const void *ip,
+     const struct xt_entry_match *match)
+{
+	const struct xt_dccp_info *einfo =
+		(const struct xt_dccp_info *)match->data;
+
+	if (einfo->flags & XT_DCCP_SRC_PORTS) {
+		if (einfo->invflags & XT_DCCP_SRC_PORTS)
+			printf("! ");
+		if (einfo->spts[0] != einfo->spts[1])
+			printf("--sport %u:%u ", 
+			       einfo->spts[0], einfo->spts[1]);
+		else
+			printf("--sport %u ", einfo->spts[0]);
+	}
+
+	if (einfo->flags & XT_DCCP_DEST_PORTS) {
+		if (einfo->invflags & XT_DCCP_DEST_PORTS)
+			printf("! ");
+		if (einfo->dpts[0] != einfo->dpts[1])
+			printf("--dport %u:%u ",
+			       einfo->dpts[0], einfo->dpts[1]);
+		else
+			printf("--dport %u ", einfo->dpts[0]);
+	}
+
+	if (einfo->flags & XT_DCCP_TYPE) {
+		printf("--dccp-type ");
+		print_types(einfo->typemask, einfo->invflags & XT_DCCP_TYPE,0);
+	}
+
+	if (einfo->flags & XT_DCCP_OPTION) {
+		printf("--dccp-option %s%u ", 
+			einfo->typemask & XT_DCCP_OPTION ? "! " : "",
+			einfo->option);
+	}
+}
+
+static struct xtables_match dccp =
+{
+	.name		= "dccp",
+	.family		= AF_INET,
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_dccp_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_dccp_info)),
+	.help		= &help,
+	.init		= &init,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+static struct xtables_match dccp6 =
+{
+	.name		= "dccp",
+	.family		= AF_INET6,
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_dccp_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_dccp_info)),
+	.help		= &help,
+	.init		= &init,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+void _init(void)
+{
+	xtables_register_match(&dccp);
+	xtables_register_match(&dccp6);
+}
+
-- 
1.5.2.2
