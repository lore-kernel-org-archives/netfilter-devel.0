From: Michael Rash <mbr@cipherdyne.com>
Subject: [PATCH] --hex-string
Date: Sun, 2 Mar 2003 09:57:43 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030302095743.A30640@orthanc.gambrl01.md.comcast.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="dDRMvlgZJXvWKvBx"
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


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Per the earlier thread, here is a patch that leaves the original
--string option alone, and implements a new --hex-string option.

The --hex-string option will accept both hex and ascii data, like
so:

iptables -A INPUT -m string --hex-string "|4e 45|blah|5d5d|" -j LOG

This patch is against libipt_string.c v1.7 in CVS.

--Mike

Michael Rash
http://www.cipherdyne.com
Key fingerprint = 53EA 13EA 472E 3771 894F  AC69 95D8 5D6B A742 839F

--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="libipt_string.c.patch"

--- libipt_string.c.old	Sun Mar  2 09:42:56 2003
+++ libipt_string.c	Sun Mar  2 09:33:32 2003
@@ -32,6 +32,7 @@
 
 static struct option opts[] = {
 	{ "string", 1, 0, '1' },
+	{ "hex-string", 1, 0, '2' },
 	{0}
 };
 
@@ -45,6 +46,13 @@
 static void
 parse_string(const unsigned char *s, struct ipt_string_info *info)
 {	
+	if (strlen(s) <= BM_MAX_NLEN) strcpy(info->string, s);
+	else exit_error(PARAMETER_PROBLEM, "STRING too long `%s'", s);
+}
+
+static void
+parse_hex_string(const unsigned char *s, struct ipt_string_info *info)
+{
 	int i=0, slen, sindex=0, schar;
 	short hex_f = 0, literal_f = 0;
 	char hextmp[3];
@@ -90,6 +98,10 @@
 				/* must end with a "|" */
 				exit_error(PARAMETER_PROBLEM, "Invalid hex block");
 			}
+			if (! isxdigit(s[i])) /* check for valid hex char */
+				exit_error(PARAMETER_PROBLEM, "Invalid hex char `%c'", s[i]);
+			if (! isxdigit(s[i+1])) /* check for valid hex char */
+				exit_error(PARAMETER_PROBLEM, "Invalid hex char `%c'", s[i+1]);
 			hextmp[0] = s[i];
 			hextmp[1] = s[i+1];
 			hextmp[2] = '\0';
@@ -127,7 +139,15 @@
 		parse_string(argv[optind-1], stringinfo);
 		if (invert)
 			stringinfo->invert = 1;
-                stringinfo->len=strlen((char *)&stringinfo->string);
+		stringinfo->len=strlen((char *)&stringinfo->string);
+		*flags = 1;
+		break;
+	case '2':
+		check_inverse(optarg, &invert, &optind, 0);
+		parse_hex_string(argv[optind-1], stringinfo);
+		if (invert)
+			stringinfo->invert = 1;
+		stringinfo->len=strlen((char *)&stringinfo->string);
 		*flags = 1;
 		break;
 

--dDRMvlgZJXvWKvBx--
