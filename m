From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCH] add helper text to manpage, change helptext in
	libipt_helper.c
Date: 03 Mar 2003 22:38:04 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1046727484.31624.46.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-6S/fHdN9U1/vOd03Ziys"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-6S/fHdN9U1/vOd03Ziys
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Harald,

Here's two small patches to fix the help for the helper match.

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat you with experience.

--=-6S/fHdN9U1/vOd03Ziys
Content-Disposition: attachment; filename=iptables.8-helper.patch
Content-Type: text/plain; name=iptables.8-helper.patch; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

--- ../old/iptables.8	2003-03-03 22:31:12.000000000 +0100
+++ userspace/iptables.8	2003-03-03 22:31:22.000000000 +0100
@@ -445,6 +445,17 @@
 This module matches the SPIs in ESP header of IPSec packets.
 .TP
 .BR "--espspi " "[!] \fIspi\fP[:\fIspi\fP]"
+.SS helper
+This module matches packets related to a specific conntrack-helper.
+.TP
+.BI "--helper " "string"
+Matches packets related to the specified conntrack-helper.
+.TP
+string can be "ftp" for packets related to a ftp-session on default port.
+For other ports append -portnr to the value, ie. "ftp-2121".
+.br
+Same rules apply for other conntrack-helpers.
+.br
 .SS icmp
 This extension is loaded if `--protocol icmp' is specified.  It
 provides the following option:

--=-6S/fHdN9U1/vOd03Ziys
Content-Disposition: attachment; filename=libipt_helper.c-help.patch
Content-Type: text/plain; name=libipt_helper.c-help.patch; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

--- ../old/libipt_helper.c	2003-03-03 22:31:48.000000000 +0100
+++ userspace/extensions/libipt_helper.c	2003-03-03 22:33:40.000000000 +010=
0
@@ -14,7 +14,7 @@
 {
 	printf(
 "helper match v%s options:\n"
-"[!] --helper value         Match helper value\n"
+"[!] --helper string        Match helper identified by string\n"
 "\n",
 IPTABLES_VERSION);
 }

--=-6S/fHdN9U1/vOd03Ziys--
