From: Michael Rash <mbr@cipherdyne.org>
Subject: [PATCH] save/restore fix for ascii strings
Date: Tue, 23 Dec 2003 15:01:25 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031223200125.GA25531@orthanc.gambrl01.md.comcast.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="PEIAKu/WMn1b1Hv9"
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


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Due to lack of quotes, iptables-save/restore is currently broken for
ascii strings that contain a space character.  The attached trivial
patch fixes this.

Let me know if I'm supposed to submit a bug first through bugzilla
or something.

--Mike

Michael Rash
http://www.cipherdyne.org
Key fingerprint = 53EA 13EA 472E 3771 894F  AC69 95D8 5D6B A742 839F

--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="libipt_string.c_ascii_fix"

Index: libipt_string.c
===================================================================
RCS file: /cvspublic/netfilter/userspace/extensions/libipt_string.c,v
retrieving revision 1.10
diff -u -r1.10 libipt_string.c
--- libipt_string.c	30 Apr 2003 16:04:41 -0000	1.10
+++ libipt_string.c	23 Dec 2003 19:49:16 -0000
@@ -178,7 +178,7 @@
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
-			   "STRING match: You must specify `--string'");
+			   "STRING match: You must specify `--string' or `--hex-string'");
 }
 
 
@@ -191,7 +191,7 @@
 	const struct ipt_string_info *info =
 	    (const struct ipt_string_info*) match->data;
 
-	printf("STRING match %s%s ", (info->invert) ? "!" : "", info->string);
+	printf("STRING match %s\"%s\" ", (info->invert) ? "!" : "", info->string);
 }
 
 
@@ -202,7 +202,7 @@
 	const struct ipt_string_info *info =
 	    (const struct ipt_string_info*) match->data;
 
-	printf("--string %s%s ", (info->invert) ? "! ": "", info->string);
+	printf("--string %s\"%s\" ", (info->invert) ? "! ": "", info->string);
 }
 
 

--PEIAKu/WMn1b1Hv9--
