From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH 3/4] iptables part to match strings
Date: Sun, 09 Jan 2005 23:23:32 +0100
Message-ID: <41E1AEE4.2020106@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060509060007080405090707"
Cc: Harald Welte <laforge@netfilter.org>
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
--------------060509060007080405090707
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Attached the modification for iptables.

--
Pablo

--------------060509060007080405090707
Content-Type: text/x-patch;
 name="iptables-string.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables-string.patch"

Index: extensions/libipt_string.c
===================================================================
--- extensions/libipt_string.c	(revision 3514)
+++ extensions/libipt_string.c	(working copy)
@@ -3,6 +3,9 @@
  * Copyright (C) 2000 Emmanuel Roger  <winfield@freegates.be>
  *
  * ChangeLog
+ *     07.01.2005: Pablo Neira Ayuso <pablo@eurodev.net>
+ *     	       Adapated for the new match string.
+ * 
  *     29.12.2003: Michael Rash <mbr@cipherdyne.org>
  *             Fixed iptables save/restore for ascii strings
  *             that contain space chars, and hex strings that
@@ -21,11 +24,12 @@
 #include <stdlib.h>
 #include <getopt.h>
 #include <ctype.h>
+#include <stddef.h> /* for 'offsetof' */
 
 #include <iptables.h>
 #include <linux/netfilter_ipv4/ipt_string.h>
+#include <linux/netfilter_ipv4/nf_string_match.h>
 
-
 /* Function which prints out usage message. */
 static void
 help(void)
@@ -56,7 +60,7 @@
 static void
 parse_string(const unsigned char *s, struct ipt_string_info *info)
 {	
-	if (strlen(s) <= BM_MAX_NLEN) strcpy(info->string, s);
+	if (strlen(s) <= MAX_PATLEN) strcpy(info->pattern, s);
 	else exit_error(PARAMETER_PROBLEM, "STRING too long `%s'", s);
 }
 
@@ -101,7 +105,7 @@
 				exit_error(PARAMETER_PROBLEM,
 					"Bad literal placement at end of string");
 			}
-			info->string[sindex] = s[i+1];
+			info->pattern[sindex] = s[i+1];
 			i += 2;  /* skip over literal char */
 			literal_f = 0;
 		} else if (hex_f) {
@@ -123,20 +127,20 @@
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
+		if (sindex > MAX_PATLEN)
 			exit_error(PARAMETER_PROBLEM, "STRING too long `%s'", s);
 		sindex++;
 	}
-	info->len = sindex;
+	info->patlen = sindex;
 }
 
 
@@ -160,7 +164,7 @@
 		parse_string(argv[optind-1], stringinfo);
 		if (invert)
 			stringinfo->invert = 1;
-		stringinfo->len=strlen((char *)&stringinfo->string);
+		stringinfo->patlen = strlen(stringinfo->pattern);
 		*flags = 1;
 		break;
 
@@ -246,12 +250,12 @@
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
 }
 
@@ -263,12 +267,12 @@
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
 }
 
@@ -277,7 +281,7 @@
     .name          = "string",
     .version       = IPTABLES_VERSION,
     .size          = IPT_ALIGN(sizeof(struct ipt_string_info)),
-    .userspacesize = IPT_ALIGN(sizeof(struct ipt_string_info)),
+    .userspacesize = offsetof(struct ipt_string_info, invert),
     .help          = &help,
     .init          = &init,
     .parse         = &parse,

--------------060509060007080405090707--
