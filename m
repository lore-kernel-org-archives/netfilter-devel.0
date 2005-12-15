From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] connbytes match connbytes-direction argument
Date: Wed, 14 Dec 2005 17:57:48 -0800
Message-ID: <20051215015748.GA6699@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="tKW2IUtsqtDRztdT"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Connbytes match should accept the full connbytes-direction argument
as the help notes.  At present, it only accepts 'connbytes-dir'.
This closes bugzilla #410.

Phil



--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-connbytes

--- ipt-orig/extensions/libipt_connbytes.c	2005-12-05 04:08:03.000000000 -0800
+++ ipt-new/extensions/libipt_connbytes.c	2005-12-14 17:44:38.000000000 -0800
@@ -22,7 +22,7 @@
 
 static struct option opts[] = {
 	{ "connbytes", 1, 0, '1' },
-	{ "connbytes-dir", 1, 0, '2' },
+	{ "connbytes-direction", 1, 0, '2' },
 	{ "connbytes-mode", 1, 0, '3' },
 	{0}
 };

--tKW2IUtsqtDRztdT--
