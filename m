From: Michael Rash <mbr@cipherdyne.org>
Subject: [PATCH] libipt_string.c save/restore and -nL output fixes
Date: Tue, 9 Dec 2003 00:08:57 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031209050857.GA25392@orthanc.gambrl01.md.comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This patch does the following:

 - Fixes iptables-save/restore for normal ascii strings that
   contain space characters, and hex strings that contain embedded
   NULL chars.

 - Changes -nL output for hex strings so they are clearly
   delineated with a "HEXSTRING" tag instead of the normal "STRING"
   tag.  For example:

iptables -A INPUT -p icmp --icmp-type 8 -m string --hex-string "|0000000000000000000000000809ab|" -j LOG --log-prefix "SID370 "

...results in the following under "iptables -nL":

<src, dst, etc> ... icmp type 8 HEXSTRING match "|0000000000000000000000000809ab|" LOG flags 0 level 4 prefix `SID370 '


--Mike

Michael Rash
http://www.cipherdyne.org
Key fingerprint = 53EA 13EA 472E 3771 894F  AC69 95D8 5D6B A742 839F



diff -u -r1.10 libipt_string.c
--- libipt_string.c	30 Apr 2003 16:04:41 -0000	1.10
+++ libipt_string.c	9 Dec 2003 04:25:51 -0000
@@ -3,6 +3,12 @@
  * Copyright (C) 2000 Emmanuel Roger  <winfield@freegates.be>
  *
  * ChangeLog
+ *     07.12.2003: Michael Rash <mbr@cipherdyne.org>
+ *             Added HEXSTRING output for -L, fixed iptables
+ *             save/restore (spaces in ascii strings and
+ *             embedded NULL chars in hex strings are handled
+ *             properly now).
+ *
  *     27.01.2001: Gianni Tedesco <gianni@ecsc.co.uk>
  *             Changed --tos to --string in save(). Also
  *             updated to work with slightly modified
@@ -18,6 +24,8 @@
 #include <iptables.h>
 #include <linux/netfilter_ipv4/ipt_string.h>
 
+/* Turn on/off debug statements */
+/* #define DEBUG */
 
 /* Function which prints out usage message. */
 static void
@@ -57,8 +65,8 @@
 static void
 parse_hex_string(const unsigned char *s, struct ipt_string_info *info)
 {
-	int i=0, slen, sindex=0, schar;
-	short hex_f = 0, literal_f = 0;
+	unsigned int i=0, slen, schar;
+	unsigned short int hex_f = 0, literal_f = 0, sindex=0;
 	char hextmp[3];
 
 	slen = strlen(s);
@@ -69,16 +77,21 @@
 	}
 
 	while (i < slen) {
-		if (s[i] == '\\' && !hex_f) {
-			literal_f = 1;
-		} else if (s[i] == '\\') {
-			exit_error(PARAMETER_PROBLEM,
-				"Cannot include literals in hex data");
+		if (s[i] == '\\') {
+			if (hex_f) {
+				exit_error(PARAMETER_PROBLEM,
+					"Cannot include literals in hex data");
+			} else
+				literal_f = 1;
 		} else if (s[i] == '|') {
 			if (hex_f)
 				hex_f = 0;
-			else
+			else {
+				/* get past any initial whitespace just after the '|' */
+				while (s[i+1] == ' ')
+					i++;
 				hex_f = 1;
+			}
 			if (i+1 >= slen)
 				break;
 			else
@@ -86,10 +99,12 @@
 		}
 
 		if (literal_f) {
-			if (i+1 >= slen) {
+			if (i+1 >= slen)
 				exit_error(PARAMETER_PROBLEM,
 					"Bad literal placement at end of string");
-			}
+#ifdef DEBUG
+	printf("DEBUG literal char: %c (%d)\n", schar, schar);
+#endif
 			info->string[sindex] = s[i+1];
 			i += 2;  /* skip over literal char */
 			literal_f = 0;
@@ -112,12 +127,21 @@
 			if (! sscanf(hextmp, "%x", &schar))
 				exit_error(PARAMETER_PROBLEM,
 					"Invalid hex char `%c'", s[i]);
+#ifdef DEBUG
+	printf("DEBUG hex char: %x (%d)\n", schar, schar);
+#endif
+			if ((char) schar == '|')
+				exit_error(PARAMETER_PROBLEM,
+					"Unsupported \"|\" (code 7c) character in hex block");
 			info->string[sindex] = (char) schar;
 			if (s[i+2] == ' ')
 				i += 3;  /* spaces included in the hex block */
 			else
 				i += 2;
 		} else {  /* the char is not part of hex data, so just copy */
+#ifdef DEBUG
+	printf("DEBUG printable char: %c (%d)\n", s[i], s[i]);
+#endif
 			info->string[sindex] = s[i];
 			i++;
 		}
@@ -125,6 +149,9 @@
 			exit_error(PARAMETER_PROBLEM, "STRING too long `%s'", s);
 		sindex++;
 	}
+#ifdef DEBUG
+	printf("strlen: %d\n", sindex);
+#endif
 	info->len = sindex;
 }
 
@@ -178,9 +205,67 @@
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
-			   "STRING match: You must specify `--string'");
+			   "STRING match: You must specify `--string' or `--hex-string'");
+}
+
+/* Test to see if string contains non-printable chars */
+static unsigned short int
+is_hex_string(const char *str, const unsigned short int len)
+{
+	unsigned int i;
+	for (i=0; i < len; i++)
+		if (! isprint(str[i]))
+			return 1;  /* string contains at least one non-printable char */
+	return 0;
 }
 
+/* Print string with "|" chars included as one would pass to --hex-string */
+static void
+print_hex_string(const char *str, const unsigned short int len)
+{
+	unsigned int i;
+	unsigned short int hex_f=0;
+	unsigned char index_char;
+
+	/* prepend quote just like for normal strings */
+	printf("\"");
+	for (i=0; i < len; i++) {
+		index_char = (unsigned char) str[i];
+		if (! isprint(index_char)) { /* it is a hex char */
+			if (! hex_f) {
+				printf("%c", '|');
+				hex_f = 1;
+			}
+			if (index_char <= 0x09) {
+				printf("%c", '0'); /* prepend a zero */
+#ifdef DEBUG
+	printf("DEBUG prepend zero (0) char.\n");
+#endif
+			}
+			printf("%x", index_char);
+#ifdef DEBUG
+	printf("DEBUG hex char: %x (%d)\n", index_char, index_char);
+#endif
+		} else {
+			if (hex_f) {
+				printf("%c", '|');
+				hex_f = 0;
+			}
+			printf("%c", index_char);
+#ifdef DEBUG
+	printf("DEBUG printable char: %c (%d)\n", index_char, index_char);
+#endif
+		}
+	}
+	if (hex_f) /* be sure to close hex portion if we haven't already */
+		printf("%c", '|');
+	/* append trailing quote and space just like for normal strings */
+	printf("\" ");
+
+#ifdef DEBUG
+	printf("DEBUG strlen: %i\n", i);
+#endif
+}
 
 /* Prints out the matchinfo. */
 static void
@@ -191,20 +276,25 @@
 	const struct ipt_string_info *info =
 	    (const struct ipt_string_info*) match->data;
 
-	printf("STRING match %s%s ", (info->invert) ? "!" : "", info->string);
+	if (is_hex_string(info->string, info->len)) {
+		printf("HEXSTRING match %s", (info->invert) ? "!" : "");
+		print_hex_string(info->string, info->len);
+	} else
+		printf("STRING match %s\"%s\" ", (info->invert) ? "!" : "", info->string);
 }
 
-
 /* Saves the union ipt_matchinfo in parseable form to stdout. */
 static void
 save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
 {
 	const struct ipt_string_info *info =
 	    (const struct ipt_string_info*) match->data;
-
-	printf("--string %s%s ", (info->invert) ? "! ": "", info->string);
+	if (is_hex_string(info->string, info->len)) {
+		printf("--hex-string %s", (info->invert) ? "! ": "");
+		print_hex_string(info->string, info->len);
+	} else
+		printf("--string %s\"%s\" ", (info->invert) ? "! ": "", info->string);
 }
-
 
 static struct iptables_match string = {
     .name          = "string",
