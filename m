From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 36/43] Unifies libip[6]t_length.c into libxt_length.c
Date: Sun, 15 Jul 2007 03:12:38 +0900 (JST)
Message-ID: <200707141812.l6EICd8W009554@toshiba.co.jp>
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
 extensions/Makefile                        |    6 +-
 extensions/libip6t_length.c                |  152 -------------------------
 extensions/libipt_length.c                 |  151 -------------------------
 extensions/libxt_length.c                  |  168 ++++++++++++++++++++++++++++
 include/linux/netfilter/xt_length.h        |    9 ++
 include/linux/netfilter_ipv4/ipt_length.h  |    9 --
 include/linux/netfilter_ipv6/ip6t_length.h |   10 --
 7 files changed, 180 insertions(+), 325 deletions(-)
 delete mode 100644 extensions/libip6t_length.c
 delete mode 100644 extensions/libipt_length.c
 create mode 100644 extensions/libxt_length.c
 create mode 100644 include/linux/netfilter/xt_length.h
 delete mode 100644 include/linux/netfilter_ipv4/ipt_length.h
 delete mode 100644 include/linux/netfilter_ipv6/ip6t_length.h

diff --git a/extensions/Makefile b/extensions/Makefile
index b81d7d6..7a76ce0 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -5,9 +5,9 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack dscp ecn esp hashlimit helper icmp iprange length owner policy realm state tos ttl unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE REDIRECT REJECT SAME SNAT TCPMSS TOS TTL TRACE ULOG
-PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 length owner policy state CONNMARK HL LOG NFQUEUE MARK TCPMSS TRACE
-PFX_EXT_SLIB:=limit mac mark multiport physdev pkttype sctp standard tcp tcpmss udp NOTRACK
+PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack dscp ecn esp hashlimit helper icmp iprange owner policy realm state tos ttl unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE REDIRECT REJECT SAME SNAT TCPMSS TOS TTL TRACE ULOG
+PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 owner policy state CONNMARK HL LOG NFQUEUE MARK TCPMSS TRACE
+PFX_EXT_SLIB:=length limit mac mark multiport physdev pkttype sctp standard tcp tcpmss udp NOTRACK
 
 ifeq ($(DO_SELINUX), 1)
 PF_EXT_SE_SLIB:=SECMARK CONNSECMARK
diff --git a/extensions/libip6t_length.c b/extensions/libip6t_length.c
deleted file mode 100644
index d89f028..0000000
--- a/extensions/libip6t_length.c
+++ /dev/null
@@ -1,152 +0,0 @@
-/* Shared library add-on to ip6tables to add packet length matching support. */
-
-#include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
-#include <ip6tables.h>
-#include <linux/netfilter_ipv6/ip6t_length.h>
-
-/* Function which prints out usage message. */
-static void
-help(void)
-{
-	printf(
-"length v%s options:\n"
-"[!] --length length[:length]    Match packet length against value or range\n"
-"                                of values (inclusive)\n",
-IPTABLES_VERSION);
-
-}
-  
-static struct option opts[] = {
-	{ "length", 1, 0, '1' },
-	{0}
-};
-
-static u_int16_t
-parse_length(const char *s)
-{
-
-	unsigned int len;
-	
-	if (string_to_number(s, 0, 0xFFFF, &len) == -1)
-		exit_error(PARAMETER_PROBLEM, "length invalid: `%s'\n", s);
-	else
-		return (u_int16_t )len;
-}
-
-/* If a single value is provided, min and max are both set to the value */
-static void
-parse_lengths(const char *s, struct ip6t_length_info *info)
-{
-	char *buffer;
-	char *cp;
-
-	buffer = strdup(s);
-	if ((cp = strchr(buffer, ':')) == NULL)
-		info->min = info->max = parse_length(buffer);
-	else {
-		*cp = '\0';
-		cp++;
-
-		info->min = buffer[0] ? parse_length(buffer) : 0;
-		info->max = cp[0] ? parse_length(cp) : 0xFFFF;
-	}
-	free(buffer);
-	
-	if (info->min > info->max)
-		exit_error(PARAMETER_PROBLEM,
-		           "length min. range value `%u' greater than max. "
-		           "range value `%u'", info->min, info->max);
-	
-}
-
-/* Function which parses command options; returns true if it
-   ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      unsigned int *nfcache,
-      struct xt_entry_match **match)
-{
-	struct ip6t_length_info *info = (struct ip6t_length_info *)(*match)->data;
-
-	switch (c) {
-		case '1':
-			if (*flags)
-				exit_error(PARAMETER_PROBLEM,
-				           "length: `--length' may only be "
-				           "specified once");
-			check_inverse(optarg, &invert, &optind, 0);
-			parse_lengths(argv[optind-1], info);
-			if (invert)
-				info->invert = 1;
-			*flags = 1;
-			break;
-			
-		default:
-			return 0;
-	}
-	return 1;
-}
-
-/* Final check; must have specified --length. */
-static void
-final_check(unsigned int flags)
-{
-	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
-			   "length: You must specify `--length'");
-}
-
-/* Common match printing code. */
-static void
-print_length(struct ip6t_length_info *info)
-{
-	if (info->invert)
-		printf("! ");
-	
-	if (info->max == info->min)
-		printf("%u ", info->min);
-	else
-		printf("%u:%u ", info->min, info->max);
-}
-
-/* Prints out the matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
-{
-	printf("length ");
-	print_length((struct ip6t_length_info *)match->data);
-}
-
-/* Saves the union ip6t_matchinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_match *match)
-{
-	printf("--length ");
-	print_length((struct ip6t_length_info *)match->data);
-}
-
-struct ip6tables_match length = {
-	.name		= "length",
-	.version	= IPTABLES_VERSION,
-	.size		= IP6T_ALIGN(sizeof(struct ip6t_length_info)),
-	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_length_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts,
-};
-
-void _init(void)
-{
-	register_match6(&length);
-}
diff --git a/extensions/libipt_length.c b/extensions/libipt_length.c
deleted file mode 100644
index f542a35..0000000
--- a/extensions/libipt_length.c
+++ /dev/null
@@ -1,151 +0,0 @@
-/* Shared library add-on to iptables to add packet length matching support. */
-#include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
-#include <iptables.h>
-#include <linux/netfilter_ipv4/ipt_length.h>
-
-/* Function which prints out usage message. */
-static void
-help(void)
-{
-	printf(
-"length v%s options:\n"
-"[!] --length length[:length]    Match packet length against value or range\n"
-"                                of values (inclusive)\n",
-IPTABLES_VERSION);
-
-}
-  
-static struct option opts[] = {
-	{ "length", 1, 0, '1' },
-	{0}
-};
-
-static u_int16_t
-parse_length(const char *s)
-{
-	unsigned int len;
-	
-	if (string_to_number(s, 0, 0xFFFF, &len) == -1)
-		exit_error(PARAMETER_PROBLEM, "length invalid: `%s'\n", s);
-	else
-		return (u_int16_t )len;
-}
-
-/* If a single value is provided, min and max are both set to the value */
-static void
-parse_lengths(const char *s, struct ipt_length_info *info)
-{
-	char *buffer;
-	char *cp;
-
-	buffer = strdup(s);
-	if ((cp = strchr(buffer, ':')) == NULL)
-		info->min = info->max = parse_length(buffer);
-	else {
-		*cp = '\0';
-		cp++;
-
-		info->min = buffer[0] ? parse_length(buffer) : 0;
-		info->max = cp[0] ? parse_length(cp) : 0xFFFF;
-	}
-	free(buffer);
-	
-	if (info->min > info->max)
-		exit_error(PARAMETER_PROBLEM,
-		           "length min. range value `%u' greater than max. "
-		           "range value `%u'", info->min, info->max);
-	
-}
-
-/* Function which parses command options; returns true if it
-   ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      unsigned int *nfcache,
-      struct xt_entry_match **match)
-{
-	struct ipt_length_info *info = (struct ipt_length_info *)(*match)->data;
-
-	switch (c) {
-		case '1':
-			if (*flags)
-				exit_error(PARAMETER_PROBLEM,
-				           "length: `--length' may only be "
-				           "specified once");
-			check_inverse(optarg, &invert, &optind, 0);
-			parse_lengths(argv[optind-1], info);
-			if (invert)
-				info->invert = 1;
-			*flags = 1;
-			break;
-			
-		default:
-			return 0;
-	}
-	return 1;
-}
-
-/* Final check; must have specified --length. */
-static void
-final_check(unsigned int flags)
-{
-	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
-			   "length: You must specify `--length'");
-}
-
-/* Common match printing code. */
-static void
-print_length(struct ipt_length_info *info)
-{
-	if (info->invert)
-		printf("! ");
-	
-	if (info->max == info->min)
-		printf("%u ", info->min);
-	else
-		printf("%u:%u ", info->min, info->max);
-}
-
-/* Prints out the matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
-{
-	printf("length ");
-	print_length((struct ipt_length_info *)match->data);
-}
-
-/* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_match *match)
-{
-	printf("--length ");
-	print_length((struct ipt_length_info *)match->data);
-}
-
-static struct iptables_match length = { 
-	.next		= NULL,
-	.name		= "length",
-	.version	= IPTABLES_VERSION,
-	.size		= IPT_ALIGN(sizeof(struct ipt_length_info)),
-	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_length_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
-};
-
-void _init(void)
-{
-	register_match(&length);
-}
diff --git a/extensions/libxt_length.c b/extensions/libxt_length.c
new file mode 100644
index 0000000..5b6453e
--- /dev/null
+++ b/extensions/libxt_length.c
@@ -0,0 +1,168 @@
+/* Shared library add-on to iptables to add packet length matching support. */
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+
+#include <xtables.h>
+#include <linux/netfilter/xt_length.h>
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf(
+"length v%s options:\n"
+"[!] --length length[:length]    Match packet length against value or range\n"
+"                                of values (inclusive)\n",
+IPTABLES_VERSION);
+
+}
+  
+static struct option opts[] = {
+	{ "length", 1, 0, '1' },
+	{0}
+};
+
+static u_int16_t
+parse_length(const char *s)
+{
+	unsigned int len;
+	
+	if (string_to_number(s, 0, 0xFFFF, &len) == -1)
+		exit_error(PARAMETER_PROBLEM, "length invalid: `%s'\n", s);
+	else
+		return (u_int16_t )len;
+}
+
+/* If a single value is provided, min and max are both set to the value */
+static void
+parse_lengths(const char *s, struct xt_length_info *info)
+{
+	char *buffer;
+	char *cp;
+
+	buffer = strdup(s);
+	if ((cp = strchr(buffer, ':')) == NULL)
+		info->min = info->max = parse_length(buffer);
+	else {
+		*cp = '\0';
+		cp++;
+
+		info->min = buffer[0] ? parse_length(buffer) : 0;
+		info->max = cp[0] ? parse_length(cp) : 0xFFFF;
+	}
+	free(buffer);
+	
+	if (info->min > info->max)
+		exit_error(PARAMETER_PROBLEM,
+		           "length min. range value `%u' greater than max. "
+		           "range value `%u'", info->min, info->max);
+	
+}
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const void *entry,
+      unsigned int *nfcache,
+      struct xt_entry_match **match)
+{
+	struct xt_length_info *info = (struct xt_length_info *)(*match)->data;
+
+	switch (c) {
+		case '1':
+			if (*flags)
+				exit_error(PARAMETER_PROBLEM,
+				           "length: `--length' may only be "
+				           "specified once");
+			check_inverse(optarg, &invert, &optind, 0);
+			parse_lengths(argv[optind-1], info);
+			if (invert)
+				info->invert = 1;
+			*flags = 1;
+			break;
+			
+		default:
+			return 0;
+	}
+	return 1;
+}
+
+/* Final check; must have specified --length. */
+static void
+final_check(unsigned int flags)
+{
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM,
+			   "length: You must specify `--length'");
+}
+
+/* Common match printing code. */
+static void
+print_length(struct xt_length_info *info)
+{
+	if (info->invert)
+		printf("! ");
+	
+	if (info->max == info->min)
+		printf("%u ", info->min);
+	else
+		printf("%u:%u ", info->min, info->max);
+}
+
+/* Prints out the matchinfo. */
+static void
+print(const void *ip,
+      const struct xt_entry_match *match,
+      int numeric)
+{
+	printf("length ");
+	print_length((struct xt_length_info *)match->data);
+}
+
+/* Saves the union ipt_matchinfo in parsable form to stdout. */
+static void
+save(const void *ip, const struct xt_entry_match *match)
+{
+	printf("--length ");
+	print_length((struct xt_length_info *)match->data);
+}
+
+static struct xtables_match length = { 
+	.next		= NULL,
+	.family		= AF_INET,
+	.name		= "length",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_length_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_length_info)),
+	.help		= &help,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+static struct xtables_match length6 = { 
+	.next		= NULL,
+	.family		= AF_INET6,
+	.name		= "length",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_length_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_length_info)),
+	.help		= &help,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+void _init(void)
+{
+	xtables_register_match(&length);
+	xtables_register_match(&length6);
+}
diff --git a/include/linux/netfilter/xt_length.h b/include/linux/netfilter/xt_length.h
new file mode 100644
index 0000000..7c2b439
--- /dev/null
+++ b/include/linux/netfilter/xt_length.h
@@ -0,0 +1,9 @@
+#ifndef _XT_LENGTH_H
+#define _XT_LENGTH_H
+
+struct xt_length_info {
+    u_int16_t	min, max;
+    u_int8_t	invert;
+};
+
+#endif /*_XT_LENGTH_H*/
diff --git a/include/linux/netfilter_ipv4/ipt_length.h b/include/linux/netfilter_ipv4/ipt_length.h
deleted file mode 100644
index 6e08852..0000000
--- a/include/linux/netfilter_ipv4/ipt_length.h
+++ /dev/null
@@ -1,9 +0,0 @@
-#ifndef _IPT_LENGTH_H
-#define _IPT_LENGTH_H
-
-struct ipt_length_info {
-    u_int16_t	min, max;
-    u_int8_t	invert;
-};
-
-#endif /*_IPT_LENGTH_H*/
diff --git a/include/linux/netfilter_ipv6/ip6t_length.h b/include/linux/netfilter_ipv6/ip6t_length.h
deleted file mode 100644
index 7fc09f9..0000000
--- a/include/linux/netfilter_ipv6/ip6t_length.h
+++ /dev/null
@@ -1,10 +0,0 @@
-#ifndef _IP6T_LENGTH_H
-#define _IP6T_LENGTH_H
-
-struct ip6t_length_info {
-	u_int16_t  min, max;
-	u_int8_t   invert;
-};
-
-#endif /*_IP6T_LENGTH_H*/
-	
-- 
1.5.2.2
