From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 1/4] fix loading shared library of ICMPv6 match
Date: Fri, 07 Apr 2006 20:31:01 +0900 (JST)
Message-ID: <200604071131.k37BV2CJ025099@toshiba.co.jp>
References: <200603290725.k2T7PRIa020651@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Fri_Apr__7_20_31_01_2006_687)--"
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200603290725.k2T7PRIa020651@toshiba.co.jp>
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

----Next_Part(Fri_Apr__7_20_31_01_2006_687)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Date: Wed, 29 Mar 2006 16:25:27 +0900 (JST)

> From: "Daniel De Graaf" <danieldegraaf@gmail.com>
> Date: Sun, 26 Mar 2006 22:19:27 -0600
> 
> > libip6t_icmpv6.c registers a match called "icmp6", which means that
> > ip6tables -vL and ip6tables-save cannot output the match correctly.
> 
> There are 2 solutions.
> 
> 	1. just rename libip6t_icmpv6.c to libip6t_icmp6.c. This can
> 	   conform names of internal structure, library and kernel module.
> 	2. apply attached patch to fix find_match() so that ip6tables can
> 	   load libip6t_icmpv6.so.
> 
> I like 1 but I'm not sure we can do it. Anyone knows any historical
> problem about it ?

No problem ? OK, then I take 1.

----Next_Part(Fri_Apr__7_20_31_01_2006_687)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="01-load-icmpv6.patch"

[IP6TABLES] fix loading shared library of ICMPv6 match

The current ip6tables tries to load libip6t_icmp6.so when user types
'ip6tables -p icmpv6 ...' or 'ip6tables ... -m icmpv6' ...', and it fails.

This patch renames libip6t_icmpv6.c to libip6t_icmp6.c so that ip6tables
can load it. Now kernel module and user library has same name 'icmp6'.
It can reduce confusion about name mismatch. That's why I renamed it
instead of reverting change in find_match() which brought this bug.

This patch keeps compatibiity and we can use '-p icmpv6', '-p ipv6-icmpv6',
'-m icmpv6', '-m ipv6-icmpv6', and '-m icmp6', as ever.

---
commit f7eed26853dda6a51d70221f5c9ef0fac60f73a7
tree b064a28c63406f4ec54762731ad32a7a68234ae7
parent c94b52d4b6fff1bfc2da3e192b39e0f45cd12750
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 06 Apr 2006 22:18:27 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 06 Apr 2006 22:18:27 +0900

 extensions/Makefile           |    2 
 extensions/libip6t_icmp6.c    |  272 +++++++++++++++++++++++++++++++++++++++++
 extensions/libip6t_icmp6.man  |   14 ++
 extensions/libip6t_icmpv6.c   |  272 -----------------------------------------
 extensions/libip6t_icmpv6.man |   14 --
 5 files changed, 287 insertions(+), 287 deletions(-)

diff --git a/extensions/Makefile b/extensions/Makefile
index 7164e1d..af051f8 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -6,7 +6,7 @@
 # package (HW)
 #
 PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack dscp ecn esp hashlimit helper icmp iprange length limit mac mark multiport owner physdev pkttype policy realm rpc sctp standard state tcp tcpmss tos ttl udp unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE NOTRACK REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS TRACE TTL ULOG
-PF6_EXT_SLIB:=connmark eui64 hl icmpv6 length limit mac mark multiport owner physdev policy standard state tcp udp CONNMARK HL LOG NFQUEUE MARK TRACE
+PF6_EXT_SLIB:=connmark eui64 hl icmp6 length limit mac mark multiport owner physdev policy standard state tcp udp CONNMARK HL LOG NFQUEUE MARK TRACE
 
 # Optionals
 PF_EXT_SLIB_OPTS:=$(foreach T,$(wildcard extensions/.*-test),$(shell KERNEL_DIR=$(KERNEL_DIR) $(T)))
diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
new file mode 100644
index 0000000..a29bb38
--- /dev/null
+++ b/extensions/libip6t_icmp6.c
@@ -0,0 +1,272 @@
+/* Shared library add-on to iptables to add ICMP support. */
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <ip6tables.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+
+struct icmpv6_names {
+	const char *name;
+	u_int8_t type;
+	u_int8_t code_min, code_max;
+};
+
+static const struct icmpv6_names icmpv6_codes[] = {
+	{ "destination-unreachable", 1, 0, 0xFF },
+	{   "no-route", 1, 0, 0 },
+	{   "communication-prohibited", 1, 1, 1 },
+	{   "address-unreachable", 1, 3, 3 },
+	{   "port-unreachable", 1, 4, 4 },
+
+	{ "packet-too-big", 2, 0, 0xFF },
+
+	{ "time-exceeded", 3, 0, 0xFF },
+	/* Alias */ { "ttl-exceeded", 3, 0, 0xFF },
+	{   "ttl-zero-during-transit", 3, 0, 0 },
+	{   "ttl-zero-during-reassembly", 3, 1, 1 },
+
+	{ "parameter-problem", 4, 0, 0xFF },
+	{   "bad-header", 4, 0, 0 },
+	{   "unknown-header-type", 4, 1, 1 },
+	{   "unknown-option", 4, 2, 2 },
+
+	{ "echo-request", 128, 0, 0xFF },
+	/* Alias */ { "ping", 128, 0, 0xFF },
+
+	{ "echo-reply", 129, 0, 0xFF },
+	/* Alias */ { "pong", 129, 0, 0xFF },
+
+	{ "router-solicitation", 133, 0, 0xFF },
+
+	{ "router-advertisement", 134, 0, 0xFF },
+
+	{ "neighbour-solicitation", 135, 0, 0xFF },
+	/* Alias */ { "neighbor-solicitation", 135, 0, 0xFF },
+
+	{ "neighbour-advertisement", 136, 0, 0xFF },
+	/* Alias */ { "neighbor-advertisement", 136, 0, 0xFF },
+
+	{ "redirect", 137, 0, 0xFF },
+
+};
+
+static void
+print_icmpv6types()
+{
+	unsigned int i;
+	printf("Valid ICMPv6 Types:");
+
+	for (i = 0; i < sizeof(icmpv6_codes)/sizeof(struct icmpv6_names); i++) {
+		if (i && icmpv6_codes[i].type == icmpv6_codes[i-1].type) {
+			if (icmpv6_codes[i].code_min == icmpv6_codes[i-1].code_min
+			    && (icmpv6_codes[i].code_max
+				== icmpv6_codes[i-1].code_max))
+				printf(" (%s)", icmpv6_codes[i].name);
+			else
+				printf("\n   %s", icmpv6_codes[i].name);
+		}
+		else
+			printf("\n%s", icmpv6_codes[i].name);
+	}
+	printf("\n");
+}
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf(
+"ICMPv6 v%s options:\n"
+" --icmpv6-type [!] typename	match icmpv6 type\n"
+"				(or numeric type or type/code)\n"
+"\n", IPTABLES_VERSION);
+	print_icmpv6types();
+}
+
+static struct option opts[] = {
+	{ "icmpv6-type", 1, 0, '1' },
+	{0}
+};
+
+static void
+parse_icmpv6(const char *icmpv6type, u_int8_t *type, u_int8_t code[])
+{
+	unsigned int limit = sizeof(icmpv6_codes)/sizeof(struct icmpv6_names);
+	unsigned int match = limit;
+	unsigned int i;
+
+	for (i = 0; i < limit; i++) {
+		if (strncasecmp(icmpv6_codes[i].name, icmpv6type, strlen(icmpv6type))
+		    == 0) {
+			if (match != limit)
+				exit_error(PARAMETER_PROBLEM,
+					   "Ambiguous ICMPv6 type `%s':"
+					   " `%s' or `%s'?",
+					   icmpv6type,
+					   icmpv6_codes[match].name,
+					   icmpv6_codes[i].name);
+			match = i;
+		}
+	}
+
+	if (match != limit) {
+		*type = icmpv6_codes[match].type;
+		code[0] = icmpv6_codes[match].code_min;
+		code[1] = icmpv6_codes[match].code_max;
+	} else {
+		char *slash;
+		char buffer[strlen(icmpv6type) + 1];
+		unsigned int number;
+
+		strcpy(buffer, icmpv6type);
+		slash = strchr(buffer, '/');
+
+		if (slash)
+			*slash = '\0';
+
+		if (string_to_number(buffer, 0, 255, &number) == -1)
+			exit_error(PARAMETER_PROBLEM,
+				   "Invalid ICMPv6 type `%s'\n", buffer);
+		*type = number;
+		if (slash) {
+			if (string_to_number(slash+1, 0, 255, &number) == -1)
+				exit_error(PARAMETER_PROBLEM,
+					   "Invalid ICMPv6 code `%s'\n",
+					   slash+1);
+			code[0] = code[1] = number;
+		} else {
+			code[0] = 0;
+			code[1] = 0xFF;
+		}
+	}
+}
+
+/* Initialize the match. */
+static void
+init(struct ip6t_entry_match *m, unsigned int *nfcache)
+{
+	struct ip6t_icmp *icmpv6info = (struct ip6t_icmp *)m->data;
+
+	icmpv6info->code[1] = 0xFF;
+}
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ip6t_entry *entry,
+      unsigned int *nfcache,
+      struct ip6t_entry_match **match)
+{
+	struct ip6t_icmp *icmpv6info = (struct ip6t_icmp *)(*match)->data;
+
+	switch (c) {
+	case '1':
+		check_inverse(optarg, &invert, &optind, 0);
+		parse_icmpv6(argv[optind-1], &icmpv6info->type, 
+			     icmpv6info->code);
+		if (invert)
+			icmpv6info->invflags |= IP6T_ICMP_INV;
+		break;
+
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+static void print_icmpv6type(u_int8_t type,
+			   u_int8_t code_min, u_int8_t code_max,
+			   int invert,
+			   int numeric)
+{
+	if (!numeric) {
+		unsigned int i;
+
+		for (i = 0;
+		     i < sizeof(icmpv6_codes)/sizeof(struct icmpv6_names);
+		     i++) {
+			if (icmpv6_codes[i].type == type
+			    && icmpv6_codes[i].code_min == code_min
+			    && icmpv6_codes[i].code_max == code_max)
+				break;
+		}
+
+		if (i != sizeof(icmpv6_codes)/sizeof(struct icmpv6_names)) {
+			printf("%s%s ",
+			       invert ? "!" : "",
+			       icmpv6_codes[i].name);
+			return;
+		}
+	}
+
+	if (invert)
+		printf("!");
+
+	printf("type %u", type);
+	if (code_min == 0 && code_max == 0xFF)
+		printf(" ");
+	else if (code_min == code_max)
+		printf(" code %u ", code_min);
+	else
+		printf(" codes %u-%u ", code_min, code_max);
+}
+
+/* Prints out the union ipt_matchinfo. */
+static void
+print(const struct ip6t_ip6 *ip,
+      const struct ip6t_entry_match *match,
+      int numeric)
+{
+	const struct ip6t_icmp *icmpv6 = (struct ip6t_icmp *)match->data;
+
+	printf("ipv6-icmp ");
+	print_icmpv6type(icmpv6->type, icmpv6->code[0], icmpv6->code[1],
+		       icmpv6->invflags & IP6T_ICMP_INV,
+		       numeric);
+
+	if (icmpv6->invflags & ~IP6T_ICMP_INV)
+		printf("Unknown invflags: 0x%X ",
+		       icmpv6->invflags & ~IP6T_ICMP_INV);
+}
+
+/* Saves the match in parsable form to stdout. */
+static void save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
+{
+	const struct ip6t_icmp *icmpv6 = (struct ip6t_icmp *)match->data;
+
+	if (icmpv6->invflags & IP6T_ICMP_INV)
+		printf("! ");
+
+	printf("--icmpv6-type %u", icmpv6->type);
+	if (icmpv6->code[0] != 0 || icmpv6->code[1] != 0xFF)
+		printf("/%u", icmpv6->code[0]);
+	printf(" ");
+}
+
+/* Final check; we don't care. */
+static void final_check(unsigned int flags)
+{
+}
+
+static struct ip6tables_match icmpv6 = {
+	.name 		= "icmp6",
+	.version 	= IPTABLES_VERSION,
+	.size		= IP6T_ALIGN(sizeof(struct ip6t_icmp)),
+	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_icmp)),
+	.help		= &help,
+	.init		= &init,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts,
+};
+
+void _init(void)
+{
+	register_match6(&icmpv6);
+}
diff --git a/extensions/libip6t_icmp6.man b/extensions/libip6t_icmp6.man
new file mode 100644
index 0000000..2047180
--- /dev/null
+++ b/extensions/libip6t_icmp6.man
@@ -0,0 +1,14 @@
+This extension is loaded if `--protocol ipv6-icmp' or `--protocol icmpv6' is
+specified. It provides the following option:
+.TP
+.BR "--icmpv6-type " "[!] \fItype\fP[/\fIcode\fP]|\fItypename\fP"
+This allows specification of the ICMPv6 type, which can be a numeric
+ICMPv6
+.IR type ,
+.IR type
+and
+.IR code ,
+or one of the ICMPv6 type names shown by the command
+.nf
+ ip6tables -p ipv6-icmp -h
+.fi
diff --git a/extensions/libip6t_icmpv6.c b/extensions/libip6t_icmpv6.c
deleted file mode 100644
index a29bb38..0000000
--- a/extensions/libip6t_icmpv6.c
+++ /dev/null
@@ -1,272 +0,0 @@
-/* Shared library add-on to iptables to add ICMP support. */
-#include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-#include <ip6tables.h>
-#include <linux/netfilter_ipv6/ip6_tables.h>
-
-struct icmpv6_names {
-	const char *name;
-	u_int8_t type;
-	u_int8_t code_min, code_max;
-};
-
-static const struct icmpv6_names icmpv6_codes[] = {
-	{ "destination-unreachable", 1, 0, 0xFF },
-	{   "no-route", 1, 0, 0 },
-	{   "communication-prohibited", 1, 1, 1 },
-	{   "address-unreachable", 1, 3, 3 },
-	{   "port-unreachable", 1, 4, 4 },
-
-	{ "packet-too-big", 2, 0, 0xFF },
-
-	{ "time-exceeded", 3, 0, 0xFF },
-	/* Alias */ { "ttl-exceeded", 3, 0, 0xFF },
-	{   "ttl-zero-during-transit", 3, 0, 0 },
-	{   "ttl-zero-during-reassembly", 3, 1, 1 },
-
-	{ "parameter-problem", 4, 0, 0xFF },
-	{   "bad-header", 4, 0, 0 },
-	{   "unknown-header-type", 4, 1, 1 },
-	{   "unknown-option", 4, 2, 2 },
-
-	{ "echo-request", 128, 0, 0xFF },
-	/* Alias */ { "ping", 128, 0, 0xFF },
-
-	{ "echo-reply", 129, 0, 0xFF },
-	/* Alias */ { "pong", 129, 0, 0xFF },
-
-	{ "router-solicitation", 133, 0, 0xFF },
-
-	{ "router-advertisement", 134, 0, 0xFF },
-
-	{ "neighbour-solicitation", 135, 0, 0xFF },
-	/* Alias */ { "neighbor-solicitation", 135, 0, 0xFF },
-
-	{ "neighbour-advertisement", 136, 0, 0xFF },
-	/* Alias */ { "neighbor-advertisement", 136, 0, 0xFF },
-
-	{ "redirect", 137, 0, 0xFF },
-
-};
-
-static void
-print_icmpv6types()
-{
-	unsigned int i;
-	printf("Valid ICMPv6 Types:");
-
-	for (i = 0; i < sizeof(icmpv6_codes)/sizeof(struct icmpv6_names); i++) {
-		if (i && icmpv6_codes[i].type == icmpv6_codes[i-1].type) {
-			if (icmpv6_codes[i].code_min == icmpv6_codes[i-1].code_min
-			    && (icmpv6_codes[i].code_max
-				== icmpv6_codes[i-1].code_max))
-				printf(" (%s)", icmpv6_codes[i].name);
-			else
-				printf("\n   %s", icmpv6_codes[i].name);
-		}
-		else
-			printf("\n%s", icmpv6_codes[i].name);
-	}
-	printf("\n");
-}
-
-/* Function which prints out usage message. */
-static void
-help(void)
-{
-	printf(
-"ICMPv6 v%s options:\n"
-" --icmpv6-type [!] typename	match icmpv6 type\n"
-"				(or numeric type or type/code)\n"
-"\n", IPTABLES_VERSION);
-	print_icmpv6types();
-}
-
-static struct option opts[] = {
-	{ "icmpv6-type", 1, 0, '1' },
-	{0}
-};
-
-static void
-parse_icmpv6(const char *icmpv6type, u_int8_t *type, u_int8_t code[])
-{
-	unsigned int limit = sizeof(icmpv6_codes)/sizeof(struct icmpv6_names);
-	unsigned int match = limit;
-	unsigned int i;
-
-	for (i = 0; i < limit; i++) {
-		if (strncasecmp(icmpv6_codes[i].name, icmpv6type, strlen(icmpv6type))
-		    == 0) {
-			if (match != limit)
-				exit_error(PARAMETER_PROBLEM,
-					   "Ambiguous ICMPv6 type `%s':"
-					   " `%s' or `%s'?",
-					   icmpv6type,
-					   icmpv6_codes[match].name,
-					   icmpv6_codes[i].name);
-			match = i;
-		}
-	}
-
-	if (match != limit) {
-		*type = icmpv6_codes[match].type;
-		code[0] = icmpv6_codes[match].code_min;
-		code[1] = icmpv6_codes[match].code_max;
-	} else {
-		char *slash;
-		char buffer[strlen(icmpv6type) + 1];
-		unsigned int number;
-
-		strcpy(buffer, icmpv6type);
-		slash = strchr(buffer, '/');
-
-		if (slash)
-			*slash = '\0';
-
-		if (string_to_number(buffer, 0, 255, &number) == -1)
-			exit_error(PARAMETER_PROBLEM,
-				   "Invalid ICMPv6 type `%s'\n", buffer);
-		*type = number;
-		if (slash) {
-			if (string_to_number(slash+1, 0, 255, &number) == -1)
-				exit_error(PARAMETER_PROBLEM,
-					   "Invalid ICMPv6 code `%s'\n",
-					   slash+1);
-			code[0] = code[1] = number;
-		} else {
-			code[0] = 0;
-			code[1] = 0xFF;
-		}
-	}
-}
-
-/* Initialize the match. */
-static void
-init(struct ip6t_entry_match *m, unsigned int *nfcache)
-{
-	struct ip6t_icmp *icmpv6info = (struct ip6t_icmp *)m->data;
-
-	icmpv6info->code[1] = 0xFF;
-}
-
-/* Function which parses command options; returns true if it
-   ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
-      unsigned int *nfcache,
-      struct ip6t_entry_match **match)
-{
-	struct ip6t_icmp *icmpv6info = (struct ip6t_icmp *)(*match)->data;
-
-	switch (c) {
-	case '1':
-		check_inverse(optarg, &invert, &optind, 0);
-		parse_icmpv6(argv[optind-1], &icmpv6info->type, 
-			     icmpv6info->code);
-		if (invert)
-			icmpv6info->invflags |= IP6T_ICMP_INV;
-		break;
-
-	default:
-		return 0;
-	}
-
-	return 1;
-}
-
-static void print_icmpv6type(u_int8_t type,
-			   u_int8_t code_min, u_int8_t code_max,
-			   int invert,
-			   int numeric)
-{
-	if (!numeric) {
-		unsigned int i;
-
-		for (i = 0;
-		     i < sizeof(icmpv6_codes)/sizeof(struct icmpv6_names);
-		     i++) {
-			if (icmpv6_codes[i].type == type
-			    && icmpv6_codes[i].code_min == code_min
-			    && icmpv6_codes[i].code_max == code_max)
-				break;
-		}
-
-		if (i != sizeof(icmpv6_codes)/sizeof(struct icmpv6_names)) {
-			printf("%s%s ",
-			       invert ? "!" : "",
-			       icmpv6_codes[i].name);
-			return;
-		}
-	}
-
-	if (invert)
-		printf("!");
-
-	printf("type %u", type);
-	if (code_min == 0 && code_max == 0xFF)
-		printf(" ");
-	else if (code_min == code_max)
-		printf(" code %u ", code_min);
-	else
-		printf(" codes %u-%u ", code_min, code_max);
-}
-
-/* Prints out the union ipt_matchinfo. */
-static void
-print(const struct ip6t_ip6 *ip,
-      const struct ip6t_entry_match *match,
-      int numeric)
-{
-	const struct ip6t_icmp *icmpv6 = (struct ip6t_icmp *)match->data;
-
-	printf("ipv6-icmp ");
-	print_icmpv6type(icmpv6->type, icmpv6->code[0], icmpv6->code[1],
-		       icmpv6->invflags & IP6T_ICMP_INV,
-		       numeric);
-
-	if (icmpv6->invflags & ~IP6T_ICMP_INV)
-		printf("Unknown invflags: 0x%X ",
-		       icmpv6->invflags & ~IP6T_ICMP_INV);
-}
-
-/* Saves the match in parsable form to stdout. */
-static void save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
-{
-	const struct ip6t_icmp *icmpv6 = (struct ip6t_icmp *)match->data;
-
-	if (icmpv6->invflags & IP6T_ICMP_INV)
-		printf("! ");
-
-	printf("--icmpv6-type %u", icmpv6->type);
-	if (icmpv6->code[0] != 0 || icmpv6->code[1] != 0xFF)
-		printf("/%u", icmpv6->code[0]);
-	printf(" ");
-}
-
-/* Final check; we don't care. */
-static void final_check(unsigned int flags)
-{
-}
-
-static struct ip6tables_match icmpv6 = {
-	.name 		= "icmp6",
-	.version 	= IPTABLES_VERSION,
-	.size		= IP6T_ALIGN(sizeof(struct ip6t_icmp)),
-	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_icmp)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts,
-};
-
-void _init(void)
-{
-	register_match6(&icmpv6);
-}
diff --git a/extensions/libip6t_icmpv6.man b/extensions/libip6t_icmpv6.man
deleted file mode 100644
index 2047180..0000000
--- a/extensions/libip6t_icmpv6.man
+++ /dev/null
@@ -1,14 +0,0 @@
-This extension is loaded if `--protocol ipv6-icmp' or `--protocol icmpv6' is
-specified. It provides the following option:
-.TP
-.BR "--icmpv6-type " "[!] \fItype\fP[/\fIcode\fP]|\fItypename\fP"
-This allows specification of the ICMPv6 type, which can be a numeric
-ICMPv6
-.IR type ,
-.IR type
-and
-.IR code ,
-or one of the ICMPv6 type names shown by the command
-.nf
- ip6tables -p ipv6-icmp -h
-.fi

----Next_Part(Fri_Apr__7_20_31_01_2006_687)----
