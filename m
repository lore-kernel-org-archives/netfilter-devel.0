From: Michael Rash <mbr@cipherdyne.com>
Subject: [PATCH] snort hex strings and libipt_string.c
Date: Tue, 18 Feb 2003 10:14:18 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030218101418.A11762@orthanc.gambrl01.md.comcast.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="GvXjxJ+pjyke8COw"
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


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

(Reposting since I was not subscribed to the list at the time.)

The attached patch adds an option "--hex-string" to the string match
module to allow snort-style hex strings to be specified on the
command line.  This is useful because there are many signatures that
consist of non-printable characters and without this patch there is
no way to easily tell iptables to search for them.

E.x:

iptables -I INPUT 1 -p udp --dport 53 -m string --hex-string
"31 c0 b0 02 cd 80 85 c0 75 4c eb 4c 5e b0" -j LOG --log-prefix
"DNS EXPLOIT x86 linux overflow attempt "

(This is my first patch to iptables so let me know if I need to do
anything differently).

Thanks,

--Mike

Michael Rash
http://www.cipherdyne.com
Key fingerprint = 4EE3 816C 413A 41AA 72C8  4463 70C3 783C 1B91 F85E

--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="libipt_string.c.patch"

--- iptables-1.2.7a/extensions/libipt_string.c.old	Wed May 29 09:08:16 2002
+++ iptables-1.2.7a/extensions/libipt_string.c		Sun Feb 16 22:52:16 2003
@@ -31,6 +31,7 @@
 
 static struct option opts[] = {
 	{ "string", 1, 0, '1' },
+	{ "hex-string", 1, 0, '2' },
 	{0}
 };
 
@@ -48,6 +49,31 @@
 	else exit_error(PARAMETER_PROBLEM, "STRING too long `%s'", s);
 }
 
+static void
+parse_hex_string(const unsigned char *s, struct ipt_string_info *info)
+{
+    int slen, schar, sindex=0, i;
+    char hextmp[3];
+    slen = strlen(s);
+    if(slen <= 3*(BM_MAX_NLEN)) { /* hex input like "71 61 7a" */
+        for (i=0; i<slen; i+=3) {
+            hextmp[0] = s[i];
+            hextmp[1] = s[i+1];
+            if (s[i+2] == ' ' || s[i+2] == '\0') {
+                hextmp[2] = '\0';
+                if (! sscanf(hextmp, "%x", &schar))
+                    exit_error(PARAMETER_PROBLEM, "Invalid hex char `%c'", s[i]);
+                info->string[sindex] = (char) schar;
+                sindex++;
+            } else {
+                exit_error(PARAMETER_PROBLEM, "Enter hex chars separated by spaces");
+            }
+        }
+    } else {
+        exit_error(PARAMETER_PROBLEM, "HEX STRING too long `%s'", s);
+    }
+}
+
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -67,7 +93,14 @@
                 stringinfo->len=strlen((char *)&stringinfo->string);
 		*flags = 1;
 		break;
-
+    case '2':
+        check_inverse(optarg, &invert, &optind, 0);
+        parse_hex_string(argv[optind-1], stringinfo);
+        if (invert)
+            stringinfo->invert = 1;
+        stringinfo->len=strlen((char *)&stringinfo->string);
+        *flags = 1;
+        break;
 	default:
 		return 0;
 	}

--GvXjxJ+pjyke8COw--
