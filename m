From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH 2/2] string match userspace part
Date: Sat, 20 Aug 2005 18:08:50 +0200
Message-ID: <43075592.2080704@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040604070304040703080904"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
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
--------------040604070304040703080904
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Here attached the iptables part. It's based on the previous 
implementation with some modifications to:

- add functionality to match packets by using window offsets
- add functionality to select the string matching algorithm

--
Pablo

--------------040604070304040703080904
Content-Type: text/x-patch;
 name="string.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="string.patch"

Index: extensions/libipt_string.c
===================================================================
--- extensions/libipt_string.c	(revision 3906)
+++ extensions/libipt_string.c	(working copy)
@@ -2,6 +2,11 @@
  * 
  * Copyright (C) 2000 Emmanuel Roger  <winfield@freegates.be>
  *
+ * 2005-08-05 Pablo Neira Ayuso <pablo@eurodev.net>
+ * 	- reimplemented to use new string matching iptables match
+ * 	- add functionality to match packets by using window offsets
+ * 	- add functionality to select the string matching algorithm
+ *
  * ChangeLog
  *     29.12.2003: Michael Rash <mbr@cipherdyne.org>
  *             Fixed iptables save/restore for ascii strings
@@ -21,36 +26,62 @@
 #include <stdlib.h>
 #include <getopt.h>
 #include <ctype.h>
-
 #include <iptables.h>
+#include <stddef.h>
 #include <linux/netfilter_ipv4/ipt_string.h>
 
-
 /* Function which prints out usage message. */
 static void
 help(void)
 {
 	printf(
 "STRING match v%s options:\n"
+"--from                       Offset to start searching from\n"
+"--to                         Offset to stop searching\n"
+"--algo	                      Algorithm\n"
 "--string [!] string          Match a string in a packet\n"
 "--hex-string [!] string      Match a hex string in a packet\n",
 IPTABLES_VERSION);
 }
 
-
 static struct option opts[] = {
-	{ .name = "string",     .has_arg = 1, .flag = 0, .val = '1' },
-	{ .name = "hex-string", .has_arg = 1, .flag = 0, .val = '2' },
-	{ .name = 0 }
+	{ "from", 1, 0, '1' },
+	{ "to", 1, 0, '2' },
+	{ "algo", 1, 0, '3' },
+	{ "string", 1, 0, '4' },
+	{ "hex-string", 1, 0, '5' },
+	{0}
 };
 
 static void
+init(struct ipt_entry_match *m, unsigned int *nfcache)
+{
+	struct ipt_string_info *i = (struct ipt_string_info *) m->data;
+
+	if (i->to_offset == 0)
+		i->to_offset = (u_int16_t) ~0UL;
+}
+
+static void
 parse_string(const unsigned char *s, struct ipt_string_info *info)
 {	
-	if (strlen(s) <= BM_MAX_NLEN) strcpy(info->string, s);
-	else exit_error(PARAMETER_PROBLEM, "STRING too long `%s'", s);
+	if (strlen(s) <= IPT_STRING_MAX_PATTERN_SIZE) {
+		strncpy(info->pattern, s, IPT_STRING_MAX_PATTERN_SIZE);
+		info->patlen = strlen(s);
+		return;
+	}
+	exit_error(PARAMETER_PROBLEM, "STRING too long `%s'", s);
 }
 
+static void
+parse_algo(const unsigned char *s, struct ipt_string_info *info)
+{
+	if (strlen(s) <= IPT_STRING_MAX_ALGO_NAME_SIZE) {
+		strncpy(info->algo, s, IPT_STRING_MAX_ALGO_NAME_SIZE);
+		return;
+	}
+	exit_error(PARAMETER_PROBLEM, "ALGO too long `%s'", s);
+}
 
 static void
 parse_hex_string(const unsigned char *s, struct ipt_string_info *info)
@@ -92,7 +123,7 @@
 				exit_error(PARAMETER_PROBLEM,
 					"Bad literal placement at end of string");
 			}
-			info->string[sindex] = s[i+1];
+			info->pattern[sindex] = s[i+1];
 			i += 2;  /* skip over literal char */
 			literal_f = 0;
 		} else if (hex_f) {
@@ -114,22 +145,26 @@
 			if (! sscanf(hextmp, "%x", &schar))
 				exit_error(PARAMETER_PROBLEM,
 					"Invalid hex char `%c'", s[i]);
-			info->string[sindex] = (char) schar;
+			info->pattern[sindex] = (char) schar;
 			if (s[i+2] == ' ')
 				i += 3;  /* spaces included in the hex block */
 			else
 				i += 2;
 		} else {  /* the char is not part of hex data, so just copy */
-			info->string[sindex] = s[i];
+			info->pattern[sindex] = s[i];
 			i++;
 		}
-		if (sindex > BM_MAX_NLEN)
+		if (sindex > IPT_STRING_MAX_PATTERN_SIZE)
 			exit_error(PARAMETER_PROBLEM, "STRING too long `%s'", s);
 		sindex++;
 	}
-	info->len = sindex;
+	info->patlen = sindex;
 }
 
+#define STRING 0x1
+#define ALGO   0x2
+#define FROM   0x4
+#define TO     0x8
 
 /* Function which parses command options; returns true if it
    ate an option */
@@ -143,28 +178,48 @@
 
 	switch (c) {
 	case '1':
-		if (*flags)
+		if (*flags & FROM)
 			exit_error(PARAMETER_PROBLEM,
-				   "Can't specify multiple strings");
-
+				   "Can't specify multiple --from");
+		stringinfo->from_offset = atoi(optarg);
+		*flags |= FROM;
+		break;
+	case '2':
+		if (*flags & TO)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify multiple --to");
+		stringinfo->to_offset = atoi(optarg);
+		*flags |= TO;
+		break;
+	case '3':
+		if (*flags & ALGO)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify multiple --algo");
+		parse_algo(optarg, stringinfo);
+		*flags |= ALGO;
+		break;
+	case '4':
+		if (*flags & STRING)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify multiple --string");
 		check_inverse(optarg, &invert, &optind, 0);
 		parse_string(argv[optind-1], stringinfo);
 		if (invert)
 			stringinfo->invert = 1;
-		stringinfo->len=strlen((char *)&stringinfo->string);
-		*flags = 1;
+		stringinfo->patlen=strlen((char *)&stringinfo->pattern);
+		*flags |= STRING;
 		break;
 
-	case '2':
-		if (*flags)
+	case '5':
+		if (*flags & STRING)
 			exit_error(PARAMETER_PROBLEM,
-				   "Can't specify multiple strings");
+				   "Can't specify multiple --hex-string");
 
 		check_inverse(optarg, &invert, &optind, 0);
 		parse_hex_string(argv[optind-1], stringinfo);  /* sets length */
 		if (invert)
 			stringinfo->invert = 1;
-		*flags = 1;
+		*flags |= STRING;
 		break;
 
 	default:
@@ -178,9 +233,13 @@
 static void
 final_check(unsigned int flags)
 {
-	if (!flags)
+	if (!(flags & STRING))
 		exit_error(PARAMETER_PROBLEM,
-			   "STRING match: You must specify `--string' or `--hex-string'");
+			   "STRING match: You must specify `--string' or "
+			   "`--hex-string'");
+	if (!(flags & ALGO))
+		exit_error(PARAMETER_PROBLEM,
+			   "STRING match: You must specify `--algo'");
 }
 
 /* Test to see if the string contains non-printable chars or quotes */
@@ -237,13 +296,18 @@
 	const struct ipt_string_info *info =
 	    (const struct ipt_string_info*) match->data;
 
-	if (is_hex_string(info->string, info->len)) {
+	if (is_hex_string(info->pattern, info->patlen)) {
 		printf("STRING match %s", (info->invert) ? "!" : "");
-		print_hex_string(info->string, info->len);
+		print_hex_string(info->pattern, info->patlen);
 	} else {
 		printf("STRING match %s", (info->invert) ? "!" : "");
-		print_string(info->string, info->len);
+		print_string(info->pattern, info->patlen);
 	}
+	printf("ALGO name %s ", info->algo);
+	if (info->from_offset != 0)
+		printf("FROM %u ", info->from_offset);
+	if (info->to_offset != 0)
+		printf("TO %u", info->to_offset);
 }
 
 
@@ -254,27 +318,33 @@
 	const struct ipt_string_info *info =
 	    (const struct ipt_string_info*) match->data;
 
-	if (is_hex_string(info->string, info->len)) {
+	if (is_hex_string(info->pattern, info->patlen)) {
 		printf("--hex-string %s", (info->invert) ? "! ": "");
-		print_hex_string(info->string, info->len);
+		print_hex_string(info->pattern, info->patlen);
 	} else {
 		printf("--string %s", (info->invert) ? "! ": "");
-		print_string(info->string, info->len);
+		print_string(info->pattern, info->patlen);
 	}
+	printf("--algo %s ", info->algo);
+	if (info->from_offset != 0)
+		printf("--from-offset %u ", info->from_offset);
+	if (info->to_offset != 0)
+		printf("--to-offset %u ", info->to_offset);
 }
 
 
 static struct iptables_match string = {
-    .name          = "string",
-    .version       = IPTABLES_VERSION,
-    .size          = IPT_ALIGN(sizeof(struct ipt_string_info)),
-    .userspacesize = IPT_ALIGN(sizeof(struct ipt_string_info)),
-    .help          = &help,
-    .parse         = &parse,
-    .final_check   = &final_check,
-    .print         = &print,
-    .save          = &save,
-    .extra_opts    = opts
+    .name		= "string",
+    .version		= IPTABLES_VERSION,
+    .size		= IPT_ALIGN(sizeof(struct ipt_string_info)),
+    .userspacesize	= offsetof(struct ipt_string_info, config),
+    .help		= help,
+    .init		= init,
+    .parse		= parse,
+    .final_check	= final_check,
+    .print		= print,
+    .save		= save,
+    .extra_opts		= opts
 };
 
 

--------------040604070304040703080904--
