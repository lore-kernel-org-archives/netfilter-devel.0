From: Michael Rash <mbr@cipherdyne.org>
Subject: [PATCH] libipt_string.c bugfixes
Date: Sun, 4 Jan 2004 23:33:30 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040105043330.GA4320@orthanc.gambrl01.md.comcast.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0OAP2g/MAC+5xKAE"
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


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The attached patch fixes bugs 167 and 168 in the netfilter bugzilla.

167: space in ascii string breaks iptables-save/restore
168: null char in hex-string breaks iptables-save/restore

--Mike

Michael Rash
http://www.cipherdyne.org
Key fingerprint = 53EA 13EA 472E 3771 894F  AC69 95D8 5D6B A742 839F

--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="libipt_string.c_charfixes"

Index: libipt_string.c
===================================================================
RCS file: /cvspublic/netfilter/userspace/extensions/libipt_string.c,v
retrieving revision 1.10
diff -u -r1.10 libipt_string.c
--- libipt_string.c	30 Apr 2003 16:04:41 -0000	1.10
+++ libipt_string.c	5 Jan 2004 04:17:30 -0000
@@ -3,6 +3,13 @@
  * Copyright (C) 2000 Emmanuel Roger  <winfield@freegates.be>
  *
  * ChangeLog
+ *     29.12.2003: Michael Rash <mbr@cipherdyne.org>
+ *             Fixed iptables save/restore for ascii strings
+ *             that contain space chars, and hex strings that
+ *             contain embedded NULL chars.  Updated to print
+ *             strings in hex mode if any non-printable char
+ *             is contained within the string.
+ *
  *     27.01.2001: Gianni Tedesco <gianni@ecsc.co.uk>
  *             Changed --tos to --string in save(). Also
  *             updated to work with slightly modified
@@ -77,8 +84,12 @@
 		} else if (s[i] == '|') {
 			if (hex_f)
 				hex_f = 0;
-			else
+			else {
 				hex_f = 1;
+				/* get past any initial whitespace just after the '|' */
+				while (s[i+1] == ' ')
+					i++;
+			}
 			if (i+1 >= slen)
 				break;
 			else
@@ -178,9 +189,53 @@
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
-			   "STRING match: You must specify `--string'");
+			   "STRING match: You must specify `--string' or `--hex-string'");
+}
+
+/* Test to see if the string contains non-printable chars or quotes */
+static unsigned short int
+is_hex_string(const char *str, const unsigned short int len)
+{
+	unsigned int i;
+	for (i=0; i < len; i++)
+		if (! isprint(str[i]))
+			return 1;  /* string contains at least one non-printable char */
+	/* use hex output if the last char is a "\" */
+	if ((unsigned char) str[len-1] == 0x5c)
+		return 1;
+	return 0;
+}
+
+/* Print string with "|" chars included as one would pass to --hex-string */
+static void
+print_hex_string(const char *str, const unsigned short int len)
+{
+	unsigned int i;
+	/* start hex block */
+	printf("\"|");
+	for (i=0; i < len; i++) {
+		/* see if we need to prepend a zero */
+		if ((unsigned char) str[i] <= 0x0F)
+			printf("0%x", (unsigned char) str[i]);
+		else
+			printf("%x", (unsigned char) str[i]);
+	}
+	/* close hex block */
+	printf("|\" ");
 }
 
+static void
+print_string(const char *str, const unsigned short int len)
+{
+	unsigned int i;
+	printf("\"");
+	for (i=0; i < len; i++) {
+		if ((unsigned char) str[i] == 0x22)  /* escape any embedded quotes */
+			printf("%c", 0x5c);
+		printf("%c", (unsigned char) str[i]);
+	}
+	printf("\" ");  /* closing space and quote */
+}
 
 /* Prints out the matchinfo. */
 static void
@@ -191,7 +246,13 @@
 	const struct ipt_string_info *info =
 	    (const struct ipt_string_info*) match->data;
 
-	printf("STRING match %s%s ", (info->invert) ? "!" : "", info->string);
+	if (is_hex_string(info->string, info->len)) {
+		printf("STRING match %s", (info->invert) ? "!" : "");
+		print_hex_string(info->string, info->len);
+	} else {
+		printf("STRING match %s", (info->invert) ? "!" : "");
+		print_string(info->string, info->len);
+	}
 }
 
 
@@ -202,7 +263,13 @@
 	const struct ipt_string_info *info =
 	    (const struct ipt_string_info*) match->data;
 
-	printf("--string %s%s ", (info->invert) ? "! ": "", info->string);
+	if (is_hex_string(info->string, info->len)) {
+		printf("--hex-string %s", (info->invert) ? "! ": "");
+		print_hex_string(info->string, info->len);
+	} else {
+		printf("--string %s", (info->invert) ? "! ": "");
+		print_string(info->string, info->len);
+	}
 }
 
 

--0OAP2g/MAC+5xKAE--
