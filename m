From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] psd option parsing
Date: Fri, 17 Sep 2004 16:49:02 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040917234902.GA1131@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="k+w/mQv8wyuph6w0"
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
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

psd match is too greedy with options, and doesn't play well with
other matches.  For example:

	# iptables -A INPUT -m psd -m recent --set -j DROP
	iptables v1.2.11: missing optarg
	Try `iptables -h' or 'iptables --help' for more information.

Below patch makes it less greedy.

This fixes bugzilla #18

Phil



--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-psd

diff -ru ipt-orig/extensions/libipt_psd.c ipt-new/extensions/libipt_psd.c
--- ipt-orig/extensions/libipt_psd.c	2003-07-14 16:01:29.000000000 -0400
+++ ipt-new/extensions/libipt_psd.c	2004-09-17 19:44:33.900825504 -0400
@@ -84,11 +84,6 @@
 	struct ipt_psd_info *psdinfo = (struct ipt_psd_info *)(*match)->data;
 	unsigned int num;
 	
-	if (!optarg)
-		exit_error(PARAMETER_PROBLEM, "missing optarg");
-
-	/* string_to_number needs a leading space */
-
 	switch (c) {
 	/* PSD-weight-threshold */
 	case '1':

--k+w/mQv8wyuph6w0--
