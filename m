From: Michael Rash <mbr@cipherdyne.com>
Subject: [PATCH] snort hex strings and libipt_string.c (revisited)
Date: Tue, 18 Feb 2003 18:03:44 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030218180344.B23930@orthanc.gambrl01.md.comcast.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="+QahgC5+KEYLbs62"
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


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Ok, after thinking about it a bit more I removed the --hex-string
option in favor of a more flexible strategy.  Snort signatures can
have content fields that mix both ascii and hex strings like so:

|3200000006000000|Drives|2400|

The attached patch extends the original parse_string() function to
handle hex data embedded between two "|" characters.  It also
handles escaping (necessary if you actually want to use the "|" in
ascii data now since it has a special meaning).  With any luck we
should now just be able to take the content fields right out of
snort and iptables should be able to handle them.

BTW, snort2iptables was the inspiration for this patch.  Thanks
for the great original idea!

(Hopefully the code is in the correct format now, but let me know
if anything needs to be changed.)

--Mike

Michael Rash
http://www.cipherdyne.com
Key fingerprint = 4EE3 816C 413A 41AA 72C8  4463 70C3 783C 1B91 F85E

--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="libipt_string.c.patch"

--- libipt_string.c.old	Wed May 29 09:08:16 2002
+++ libipt_string.c	Tue Feb 18 17:53:42 2003
@@ -13,6 +13,7 @@
 #include <string.h>
 #include <stdlib.h>
 #include <getopt.h>
+#include <ctype.h>
 
 #include <iptables.h>
 #include <linux/netfilter_ipv4/ipt_string.h>
@@ -44,8 +45,70 @@
 static void
 parse_string(const unsigned char *s, struct ipt_string_info *info)
 {	
-        if (strlen(s) <= BM_MAX_NLEN) strcpy(info->string, s);
-	else exit_error(PARAMETER_PROBLEM, "STRING too long `%s'", s);
+	int i=0, slen, sindex=0, schar;
+	short hex_f = 0, literal_f = 0;
+	char hextmp[3];
+
+	slen = strlen(s);
+
+	if (slen == 0) {
+		exit_error(PARAMETER_PROBLEM,
+			"STRING must contain at least one char");
+	}
+
+	while (i < slen) {
+		if (s[i] == '\\' && !hex_f) {
+			literal_f = 1;
+		} else if (s[i] == '\\') {
+			exit_error(PARAMETER_PROBLEM,
+				"Cannot include literals in hex data");
+		} else if (s[i] == '|') {
+			if (hex_f)
+				hex_f = 0;
+			else
+				hex_f = 1;
+			if (i+1 >= slen)
+				break;
+			else
+				i++;  /* advance to the next character */
+		}
+
+		if (literal_f) {
+			if (i+1 >= slen) {
+				exit_error(PARAMETER_PROBLEM,
+					"Bad literal placement at end of string");
+			}
+			info->string[sindex] = s[i+1];
+			i += 2;  /* skip over literal char */
+			literal_f = 0;
+		} else if (hex_f) {
+			if (i+1 >= slen) {
+				exit_error(PARAMETER_PROBLEM,
+					"Odd number of hex digits");
+			}
+			if (i+2 >= slen) {
+				/* must end with a "|" */
+				exit_error(PARAMETER_PROBLEM, "Invalid hex block");
+			}
+			hextmp[0] = s[i];
+			hextmp[1] = s[i+1];
+			hextmp[2] = '\0';
+			if (! sscanf(hextmp, "%x", &schar))
+				exit_error(PARAMETER_PROBLEM,
+					"Invalid hex char `%c'", s[i]);
+			info->string[sindex] = (char) schar;
+			if (s[i+2] == ' ')
+				i += 3;  /* spaces included in the hex block */
+			else
+				i += 2;
+		} else {  /* the char is not part of hex data, so just copy */
+			info->string[sindex] = s[i];
+			i++;
+		}
+		if (sindex > BM_MAX_NLEN)
+			exit_error(PARAMETER_PROBLEM, "STRING too long `%s'", s);
+		sindex++;
+	}
 }
 
 /* Function which parses command options; returns true if it

--+QahgC5+KEYLbs62--
