From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: [PATCH 2/2] xt_u32 (iptables) - match arbitrary bits and bytes of
 a packet
Date: Sat, 2 Jun 2007 23:51:20 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0706022350200.10578@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0706022322340.28357@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Mailing List <netfilter@lists.netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@lists.netfilter.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1763400AbXFBVw2@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0706022322340.28357@yvahk01.tjqt.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 extensions/.u32-test      |    2 
 extensions/libipt_u32.c   |  290 ++++++++++++++++++++++++++++++++++++++++++++++
 extensions/libipt_u32.man |    8 +
 3 files changed, 300 insertions(+)

Index: iptables/extensions/.u32-test
===================================================================
--- /dev/null
+++ iptables/extensions/.u32-test
@@ -0,0 +1,2 @@
+#!/bin/sh
+[ -f "$KERNEL_DIR/include/linux/netfilter/xt_u32.h" ] && echo u32
Index: iptables/extensions/libipt_u32.c
===================================================================
--- /dev/null
+++ iptables/extensions/libipt_u32.c
@@ -0,0 +1,290 @@
+/* Shared library add-on to iptables to add u32 matching,
+ * generalized matching on values found at packet offsets
+ *
+ * Detailed doc is in the kernel module source
+ * net/netfilter/xt_u32.c
+ *
+ * (C) 2002 by Don Cohen <don-netf@isis.cs3-inc.com>
+ * Released under the terms of GNU GPL v2
+ */
+#include <sys/types.h>
+#include <ctype.h>
+#include <errno.h>
+#include <getopt.h>
+#include <netdb.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+
+#include <iptables.h>
+#include <linux/netfilter/xt_u32.h>
+
+/* Function which prints out usage message. */
+static void help(void)
+{
+	printf( "u32 v%s options:\n"
+		" --u32 tests\n"
+		" tests := location = value | tests && location = value\n"
+		" value := range | value , range\n"
+		" range := number | number : number\n"
+		" location := number | location operator number\n"
+		" operator := & | << | >> | @\n",
+		IPTABLES_VERSION);
+}
+
+/* defined in /usr/include/getopt.h maybe in man getopt */
+static struct option opts[] = {
+	{"u32", 1, NULL, '1'},
+	{NULL},
+};
+
+/* shared printing code */
+static void print_u32(const struct xt_u32 *data)
+{
+	const struct xt_u32_test *ct;
+	unsigned int testind, i;
+
+	for (testind = 0; testind < data->ntests; ++testind) {
+		ct = &data->tests[testind];
+
+		if (testind > 0)
+			printf("&&");
+
+		printf("0x%x", ct->location[0].number);
+		for (i = 1; i < ct->nnums; ++i) {
+			switch (ct->location[i].nextop) {
+			case XT_U32_AND:
+				printf("&");
+				break;
+			case XT_U32_LEFTSH:
+				printf("<<");
+				break;
+			case XT_U32_RIGHTSH:
+				printf(">>");
+				break;
+			case XT_U32_AT:
+				printf("@");
+				break;
+			}
+			printf("0x%x", ct->location[i].number);
+		}
+
+		printf("=");
+		for (i = 0; i < ct->nvalues; ++i) {
+			if (i > 0)
+				printf(",");
+			if (ct->value[i].min == ct->value[i].max)
+				printf("0x%x", ct->value[i].min);
+			else
+				printf("0x%x:0x%x", ct->value[i].min,
+				       ct->value[i].max);
+		}
+	}
+	printf(" ");
+}
+
+/* string_to_number is not quite what we need here ... */
+uint32_t parse_number(char **s, int pos)
+{
+	uint32_t number;
+	char *end;
+	errno = 0;
+
+	number = strtoul(*s, &end, 0);
+	if (end == *s)
+		exit_error(PARAMETER_PROBLEM,
+			   "u32: at char %d: expected number", pos);
+	if (errno)
+		exit_error(PARAMETER_PROBLEM,
+			   "u32: at char %d: error reading number", pos);
+	*s = end;
+	return number;
+}
+
+/* Function which parses command options; returns true if it ate an option */
+static int parse(int c, char **argv, int invert, unsigned int *flags,
+		 const struct ipt_entry *entry, unsigned int *nfcache,
+		 struct ipt_entry_match **match)
+{
+	struct xt_u32 *data = (void *)(*match)->data;
+	char *arg = argv[optind-1]; /* the argument string */
+	char *start = arg;
+	int state = 0, testind = 0, locind = 0, valind = 0;
+
+	if (c != '1')
+		return 0;
+
+	/*
+	 * states:
+	 * 0 = looking for numbers and operations,
+	 * 1 = looking for ranges
+	 */
+	while (1) {
+		/* read next operand/number or range */
+		while (isspace(*arg))
+			++arg;
+
+		if (*arg == '\0') {
+			/* end of argument found */
+			if (state == 0)
+				exit_error(PARAMETER_PROBLEM,
+					   "u32: input ended in location spec");
+			if (valind == 0)
+				exit_error(PARAMETER_PROBLEM,
+					   "u32: test ended with no value spec");
+
+			data->tests[testind].nnums   = locind;
+			data->tests[testind].nvalues = valind;
+			testind++;
+			data->ntests = testind;
+
+			if (testind > XT_U32_MAXSIZE)
+				exit_error(PARAMETER_PROBLEM,
+				           "u32: at char %d: too many \"&&\"s",
+				           arg - start);
+			return 1;
+		}
+
+		if (state == 0) {
+			/*
+			 * reading location: read a number if nothing read yet,
+			 * otherwise either op number or = to end location spec
+			 */
+			if (*arg == '=') {
+				if (locind == 0) {
+					exit_error(PARAMETER_PROBLEM,
+					           "u32: at char %d: "
+					           "location spec missing",
+					           arg - start);
+				} else {
+					arg++;
+					state = 1;
+				}
+			} else {
+				if (locind != 0) {
+					/* need op before number */
+					if (*arg == '&') {
+						data->tests[testind].location[locind].nextop = XT_U32_AND;
+					} else if (*arg == '<') {
+						arg++;
+						if (*arg != '<')
+							exit_error(PARAMETER_PROBLEM,
+								   "u32: at char %d: a second < expected", arg - start);
+						data->tests[testind].location[locind].nextop = XT_U32_LEFTSH;
+					} else if (*arg == '>') {
+						arg++;
+						if (*arg != '>')
+							exit_error(PARAMETER_PROBLEM,
+								   "u32: at char %d: a second > expected", arg - start);
+						data->tests[testind].location[locind].nextop = XT_U32_RIGHTSH;
+					} else if (*arg == '@') {
+						data->tests[testind].location[locind].nextop = XT_U32_AT;
+					} else {
+						exit_error(PARAMETER_PROBLEM,
+							"u32: at char %d: operator expected", arg - start);
+					}
+					++arg;
+				}
+				/* now a number; string_to_number skips white space? */
+				data->tests[testind].location[locind].number =
+					parse_number(&arg, arg - start);
+				locind++;
+				if (locind > XT_U32_MAXSIZE)
+					exit_error(PARAMETER_PROBLEM,
+						   "u32: at char %d: too many operators", arg - start);
+			}
+		} else {
+			/*
+			 * state 1 - reading values: read a range if nothing
+			 * read yet, otherwise either ,range or && to end
+			 * test spec
+			 */
+			if (*arg == '&') {
+				arg++;
+				if (*arg != '&')
+					exit_error(PARAMETER_PROBLEM,
+						   "u32: at char %d: a second & was expected", arg - start);
+				if (valind == 0) {
+					exit_error(PARAMETER_PROBLEM,
+						   "u32: at char %d: value spec missing", arg - start);
+				} else {
+					data->tests[testind].nnums   = locind;
+					data->tests[testind].nvalues = valind;
+					++testind;
+					if (testind > XT_U32_MAXSIZE)
+						exit_error(PARAMETER_PROBLEM,
+							   "u32: at char %d: too many \"&&\"s", arg - start);
+					++arg;
+					state  = 0;
+					locind = 0;
+					valind = 0;
+				}
+			}
+			else { /* read value range */
+				if (valind) { /* need , before number */
+					if (*arg != ',')
+						exit_error(PARAMETER_PROBLEM,
+							   "u32: at char %d: expected , or &&", arg - start);
+					arg++;
+				}
+				data->tests[testind].value[valind].min = parse_number(&arg, arg - start);
+
+				while (isspace(*arg))
+					++arg;
+
+				if (*arg==':') {
+					arg++;
+					data->tests[testind].value[valind].max =
+						parse_number(&arg, arg-start);
+				} else {
+					data->tests[testind].value[valind].max =
+						data->tests[testind].value[valind].min;
+				}
+
+				valind++;
+				if (valind > XT_U32_MAXSIZE)
+					exit_error(PARAMETER_PROBLEM,
+						   "u32: at char %d: too many ,'s", arg-start);
+			}
+		}
+	}
+}
+
+/* Final check; must specify something. */
+static void final_check(unsigned int flags)
+{
+}
+
+/* Prints out the matchinfo. */
+static void print(const struct ipt_ip *ip, const struct ipt_entry_match *match,
+	          int numeric)
+{
+	printf("u32 ");
+	print_u32((const void *)match->data);
+}
+
+/* Saves the union ipt_matchinfo in parsable form to stdout. */
+static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+{
+	printf("--u32 ");
+	print_u32((const void *)match->data);
+}
+
+struct iptables_match u32 = {
+	.next		= NULL,
+	.name		= "u32",
+	.version	= IPTABLES_VERSION,
+	.size		= IPT_ALIGN(sizeof(struct xt_u32)),
+	.userspacesize	= IPT_ALIGN(sizeof(struct xt_u32)),
+	.help		= &help,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts,
+};
+
+static __attribute__((constructor)) void libipt_u32_init(void)
+{
+	register_match(&u32);
+}
Index: iptables/extensions/libipt_u32.man
===================================================================
--- /dev/null
+++ iptables/extensions/libipt_u32.man
@@ -0,0 +1,8 @@
+U32 allows you to extract quantities of up to 4 bytes from a packet,
+AND them with specified masks, shift them by specified amounts and
+test whether the results are in any of a set of specified ranges.
+The specification of what to extract is general enough to skip over
+headers with lengths stored in the packet, as in IP or TCP header
+lengths.
+
+Details and examples are in the kernel module source.
