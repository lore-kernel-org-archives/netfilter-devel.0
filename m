From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH][IPTABLES] userspace u32 match support
Date: Fri, 10 Nov 2006 02:31:23 +0100
Message-ID: <4553D66B.2010309@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020003080805020305040409"
Cc: Harald Welte <laforge@netfilter.org>, Michael Rash <mbr@cipherdyne.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------020003080805020305040409
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Add support for u32 match in userspace

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------020003080805020305040409
Content-Type: text/plain;
 name="u32.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="u32.patch"

Index: extensions/libipt_u32.c
===================================================================
--- extensions/libipt_u32.c	(revisión: 6678)
+++ extensions/libipt_u32.c	(copia de trabajo)
@@ -1,264 +1,159 @@
-/* Shared library add-on to iptables to add u32 matching,
- * generalized matching on values found at packet offsets
- *
- * Detailed doc is in the kernel module source
- * net/ipv4/netfilter/ipt_u32.c
- *
- * (C) 2002 by Don Cohen <don-netf@isis.cs3-inc.com>
- * Released under the terms of GNU GPL v2
+/* Shared library add-on to iptables to add u32 matching. 
+ * 
+ * Copyright (C) 2006 Pablo Neira Ayuso <pablo@netfilter.org>
  */
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
 #include <stdlib.h>
 #include <getopt.h>
+#include <ctype.h>
 #include <iptables.h>
 #include <linux/netfilter_ipv4/ipt_u32.h>
-#include <errno.h>
-#include <ctype.h>
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void help(void)
 {
-	printf( "u32 v%s options:\n"
-		" --u32 tests\n"
-		" tests := location = value | tests && location = value\n"
-		" value := range | value , range\n"
-		" range := number | number : number\n"
-		" location := number | location operator number\n"
-		" operator := & | << | >> | @\n"
-		,IPTABLES_VERSION);
+	printf("U32 match options:\n"
+	       "--offset integer             offset\n"
+	       "--mask xhhxhhxhhxhh          32 bits hexadecimal mask\n"
+	       "--value [!] xhhxhhxhhxhh     32 bits hexadecimal value\n");
 }
 
-/* defined in /usr/include/getopt.h maybe in man getopt */
 static struct option opts[] = {
-	{ "u32", 1, 0, '1' },
-	{ 0 }
+	{ "offset", 1, 0, '1' },
+	{ "mask", 1, 0, '2' },
+	{ "value", 1, 0, '3' },
+	{0}
 };
 
-/* shared printing code */
-static void print_u32(struct ipt_u32 *data)
+static void init(struct ipt_entry_match *m, unsigned int *nfcache)
 {
-	unsigned int testind;
+	struct ipt_u32_info *info = (struct ipt_u32_info *) m->data;
 
-	for (testind=0; testind < data->ntests; testind++) {
-		if (testind) printf("&&");
-		{
-			unsigned int i;
-
-			printf("0x%x", data->tests[testind].location[0].number);
-			for (i = 1; i < data->tests[testind].nnums; i++) {
-				switch (data->tests[testind].location[i].nextop) {
-				case IPT_U32_AND: printf("&"); break;
-				case IPT_U32_LEFTSH: printf("<<"); break;
-				case IPT_U32_RIGHTSH: printf(">>"); break;
-				case IPT_U32_AT: printf("@"); break;
-				}
-				printf("0x%x", data->tests[testind].location[i].number);
-			}
-			printf("=");
-			for (i = 0; i < data->tests[testind].nvalues; i++) {
-				if (i) printf(",");
-				if (data->tests[testind].value[i].min
-				    == data->tests[testind].value[i].max)
-					printf("0x%x", data->tests[testind].value[i].min);
-				else printf("0x%x:0x%x", data->tests[testind].value[i].min,
-					    data->tests[testind].value[i].max);
-			}
-		}
-	}
-	printf(" ");
+	info->mask = 0xffffffff;
 }
 
-/* string_to_number is not quite what we need here ... */
-u_int32_t parse_number(char **s, int pos)
+static int parse_hex(const char *str, unsigned int *res)
 {
-	u_int32_t number;
-	char *end;
-	errno = 0;
+	int a, b, c, d;
 
-	number = strtoul(*s, &end, 0);
-	if (end == *s)
-		exit_error(PARAMETER_PROBLEM, 
-			   "u32: at char %d expected number", pos);
-	if (errno)
-		exit_error(PARAMETER_PROBLEM, 
-			   "u32: at char %d error reading number", pos);
-	*s = end;
-	return number;
+	if (sscanf(str, "x%2xx%2xx%2xx%2x", &a, &b, &c, &d) != 4)
+		return -1;
+
+	*res = (a << 24) | (b << 16) | (c << 8) | d;
+
+	return 0;
 }
 
-/* Function which parses command options; returns true if it ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
-      unsigned int *nfcache,
-      struct ipt_entry_match **match)
+#define OFFSET 0x1
+#define MASK   0x2
+#define VALUE  0x4
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int parse(int c, char **argv, int invert, unsigned int *flags,
+		 const struct ipt_entry *entry, unsigned int *nfcache,
+		 struct ipt_entry_match **match)
 {
-	struct ipt_u32 *data = (struct ipt_u32 *)(*match)->data;
-	char *arg = argv[optind-1]; /* the argument string */
-	char *start = arg;
-	int state=0, testind=0, locind=0, valind=0;
+	struct ipt_u32_info *info = (struct ipt_u32_info *)(*match)->data;
 
-	if (c != '1') return 0;
-	/* states: 0 = looking for numbers and operations, 1 = looking for ranges */
-	while (1) { /* read next operand/number or range */
-		while (isspace(*arg)) 
-			arg++;  /* skip white space */
-		if (! *arg) { /* end of argument found */
-			if (state == 0)
-				exit_error(PARAMETER_PROBLEM, 
-					   "u32: input ended in location spec");
-			if (valind == 0)
-				exit_error(PARAMETER_PROBLEM, 
-					   "u32: test ended with no value spec");
-			data->tests[testind].nnums = locind;
-			data->tests[testind].nvalues = valind;
-			testind++;
-			data->ntests=testind;
-			if (testind > U32MAXSIZE)
-				exit_error(PARAMETER_PROBLEM, 
-					   "u32: at char %d too many &&'s",
-					   arg-start);
-			/* debugging 
-			   print_u32(data);printf("\n");
-			   exit_error(PARAMETER_PROBLEM, "debugging output done"); */
-			return 1;
-		}
-		if (state == 0) {
-			/* reading location: read a number if nothing read yet,
-			   otherwise either op number or = to end location spec */	 
-			if (*arg == '=') {
-				if (locind == 0)
-					exit_error(PARAMETER_PROBLEM,
-						   "u32: at char %d location spec missing", arg-start);
-				else {
-					arg++; 
-					state=1;
-				}
-			}
-			else {
-				if (locind) { /* need op before number */
-					if (*arg == '&') {
-						data->tests[testind].location[locind].nextop = IPT_U32_AND;
-					}
-					else if (*arg == '<') {
-						arg++;
-						if (*arg != '<')
-							exit_error(PARAMETER_PROBLEM,
-								   "u32: at char %d a second < expected", arg-start);
-						data->tests[testind].location[locind].nextop = IPT_U32_LEFTSH;
-					}
-					else if (*arg == '>') {
-						arg++;
-						if (*arg != '>')
-							exit_error(PARAMETER_PROBLEM,
-								   "u32: at char %d a second > expected", arg-start);
-						data->tests[testind].location[locind].nextop = IPT_U32_RIGHTSH;
-					}
-					else if (*arg == '@') {
-						data->tests[testind].location[locind].nextop = IPT_U32_AT;
-					}
-					else exit_error(PARAMETER_PROBLEM,
-							"u32: at char %d operator expected", arg-start);
-					arg++;
-				}
-				/* now a number; string_to_number skips white space? */
-				data->tests[testind].location[locind].number =
-					parse_number(&arg, arg-start);
-				locind++;
-				if (locind > U32MAXSIZE)
-					exit_error(PARAMETER_PROBLEM,
-						   "u32: at char %d too many operators", arg-start);
-			}
-		}
-		else {
-			/* state 1 - reading values: read a range if nothing read yet,
-			   otherwise either ,range or && to end test spec */
-			if (*arg == '&') {
-				arg++;
-				if (*arg != '&')
-					exit_error(PARAMETER_PROBLEM,
-						   "u32: at char %d a second & expected", arg-start);
-				if (valind == 0)
-					exit_error(PARAMETER_PROBLEM,
-						   "u32: at char %d value spec missing", arg-start);
-				else {
-					data->tests[testind].nnums = locind;
-					data->tests[testind].nvalues = valind;
-					testind++;
-					if (testind > U32MAXSIZE)
-						exit_error(PARAMETER_PROBLEM,
-							   "u32: at char %d too many &&'s", arg-start);
-					arg++; state=0; locind=0; valind=0;
-				}
-			}
-			else { /* read value range */
-				if (valind) { /* need , before number */
-					if (*arg != ',')
-						exit_error(PARAMETER_PROBLEM,
-							   "u32: at char %d expected , or &&", arg-start);
-					arg++;
-				}
-				data->tests[testind].value[valind].min = parse_number(&arg, arg-start);
-				while (isspace(*arg)) 
-					arg++;  /* another place white space could be */
-				if (*arg==':') {
-					arg++;
-					data->tests[testind].value[valind].max
-						= parse_number(&arg, arg-start);
-				}
-				else data->tests[testind].value[valind].max
-					     = data->tests[testind].value[valind].min;
-				valind++;
-				if (valind > U32MAXSIZE)
-					exit_error(PARAMETER_PROBLEM,
-						   "u32: at char %d too many ,'s", arg-start);
-			}
-		}
+	switch (c) {
+	case '1':
+		if (*flags & OFFSET)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify multiple --offset");
+		info->offset = atoi(optarg);
+		*flags |= OFFSET;
+		break;
+	case '2':
+		if (*flags & MASK)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify multiple --mask");
+		if (parse_hex(optarg, &info->mask) == -1)
+			exit_error(PARAMETER_PROBLEM,
+				   "Mask must be in hexadecimal: use format xhhxhhxhhxhh where h=[0-f]");
+		*flags |= MASK;
+		break;
+	case '3':
+		if (*flags & VALUE)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify multiple --value");
+		if (parse_hex(optarg, &info->val) == -1)
+			exit_error(PARAMETER_PROBLEM,
+				   "Value must be in hexadecimal: use format xhhxhhxhhxhh where h=[0-f]");
+		*flags |= VALUE;
+		break;
+	default:
+		return 0;
 	}
+	return 1;
 }
 
-/* Final check; must specify something. */
-static void
-final_check(unsigned int flags)
+
+/* Final check; must have specified --offset and --value. */
+static void final_check(unsigned int flags)
 {
+	if (!(flags & OFFSET))
+		exit_error(PARAMETER_PROBLEM,
+			   "U32 match: You must specify `--offset'");
+	if (!(flags & VALUE))
+		exit_error(PARAMETER_PROBLEM,
+			   "U32 match: You must specify `--value'");
 }
 
 /* Prints out the matchinfo. */
-static void
-print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
-      int numeric)
+static void print(const struct ipt_ip *ip,
+		  const struct ipt_entry_match *match,
+		  int numeric)
 {
-	printf("u32 ");
-	print_u32((struct ipt_u32 *)match->data);
+	const struct ipt_u32_info *info =
+	    (const struct ipt_u32_info*) match->data;
+
+	printf("OFFSET %d ", info->offset);
+	printf("MASK %.2x%.2x%.2x%.2x ", (info->mask >> 24) & 0xFF,
+				         (info->mask >> 16) & 0xFF,
+				         (info->mask >> 8) & 0xFF,
+				         (info->mask) & 0xFF);
+	printf("VALUE %.2x%.2x%.2x%.2x ", (info->val >> 24) & 0xFF,
+				          (info->val >> 16) & 0xFF,
+				          (info->val >> 8) & 0xFF,
+				          (info->val) & 0xFF);
 }
 
-/* Saves the union ipt_matchinfo in parsable form to stdout. */
+
+/* Saves the union ipt_matchinfo in parseable form to stdout. */
 static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
 {
-	printf("--u32 ");
-	print_u32((struct ipt_u32 *)match->data);
+	const struct ipt_u32_info *info =
+	    (const struct ipt_u32_info*) match->data;
+
+	printf("--offset %d ", info->offset);
+	printf("--mask x%.2xx%.2xx%.2xx%.2x ", (info->mask >> 24) & 0xFF,
+				               (info->mask >> 16) & 0xFF,
+				               (info->mask >> 8)  & 0xFF,
+				               info->mask & 0xFF);
+	printf("--value x%.2xx%.2xx%.2xx%.2x ", (info->val >> 24) & 0xFF,
+				                (info->val >> 16) & 0xFF,
+				                (info->val >> 8) & 0xFF,
+				                info->val & 0xFF);
 }
 
-struct iptables_match u32 = {
-	.next		= NULL,
-	.name		= "u32",
-	.version	= IPTABLES_VERSION,
-	.size		= IPT_ALIGN(sizeof(struct ipt_u32)),
-	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_u32)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+static struct iptables_match u32 = {
+    .name		= "u32",
+    .version		= IPTABLES_VERSION,
+    .size		= IPT_ALIGN(sizeof(struct ipt_u32_info)),
+    .userspacesize	= IPT_ALIGN(sizeof(struct ipt_u32_info)),
+    .help		= help,
+    .init		= init,
+    .parse		= parse,
+    .final_check	= final_check,
+    .print		= print,
+    .save		= save,
+    .extra_opts		= opts
 };
 
-void
-_init(void)
+void _init(void)
 {
 	register_match(&u32);
 }

--------------020003080805020305040409--
