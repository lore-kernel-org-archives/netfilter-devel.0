From: Michael Rash <mbr@cipherdyne.org>
Subject: [PATCH] iptables-restore.c bugfix
Date: Sun, 4 Jan 2004 23:39:50 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040105043950.GA4796@orthanc.gambrl01.md.comcast.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="azLHFNyN32YCQGCU"
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


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The attached (trivial) patch fixes bug 171 in the netfilter bugzilla.

--Mike

Michael Rash
http://www.cipherdyne.org
Key fingerprint = 53EA 13EA 472E 3771 894F  AC69 95D8 5D6B A742 839F

--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="iptables-restore.c_escape_quote"

Index: iptables-restore.c
===================================================================
RCS file: /cvspublic/netfilter/userspace/iptables-restore.c,v
retrieving revision 1.26
diff -u -r1.26 iptables-restore.c
--- iptables-restore.c	2 May 2003 15:30:11 -0000	1.26
+++ iptables-restore.c	5 Jan 2004 03:48:35 -0000
@@ -318,7 +318,7 @@
 			
 			for (curchar = parsestart; *curchar; curchar++) {
 				if (*curchar == '"') {
-					if (quote_open) {
+					if (quote_open && *(curchar-1) != '\\') {
 						quote_open = 0;
 						*curchar = ' ';
 					} else {

--azLHFNyN32YCQGCU--
