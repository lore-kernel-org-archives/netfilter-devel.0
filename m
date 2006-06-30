From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] iptables trivial compile warning cleanup
Date: Fri, 30 Jun 2006 13:55:02 -0700
Message-ID: <20060630205502.GA9243@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="zYM0uCDKw75PZbzx"
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


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Cleanup a few compile warnings in latest snapshot:

extensions/libipt_dscp_helper.c:69: warning: 'dscp_to_name' defined but not used
extensions/libipt_sctp.c: In function 'print_chunks':
extensions/libipt_sctp.c:465: warning: value computed is not used
extensions/libipt_sctp.c:477: warning: value computed is not used

Resolves bug #457.

Phil



--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-compilewarn

diff -ru ipt-orig/extensions/libipt_dscp_helper.c ipt-new/extensions/libipt_dscp_helper.c
--- ipt-orig/extensions/libipt_dscp_helper.c	2002-08-26 06:09:40.000000000 -0700
+++ ipt-new/extensions/libipt_dscp_helper.c	2006-06-30 13:44:49.000000000 -0700
@@ -63,7 +63,7 @@
 }
 
 
-
+#if 0
 static const char *
 dscp_to_name(unsigned int dscp)
 {
@@ -78,5 +78,5 @@
 	exit_error(PARAMETER_PROBLEM,
 			"Invalid DSCP value `%d'\n", dscp);
 }
-
+#endif
 
diff -ru ipt-orig/extensions/libipt_sctp.c ipt-new/extensions/libipt_sctp.c
--- ipt-orig/extensions/libipt_sctp.c	2006-02-01 04:58:28.000000000 -0800
+++ ipt-new/extensions/libipt_sctp.c	2006-06-30 13:47:38.000000000 -0700
@@ -462,7 +462,8 @@
 	flag = 0;
 	for (i = 0; i < 256; i++) {
 		if (SCTP_CHUNKMAP_IS_SET(chunkmap, i)) {
-			flag && printf(",");
+			if (flag)
+				printf(",");
 			flag = 1;
 			print_chunk(i, numeric);
 			for (j = 0; j < flag_count; j++) {
@@ -474,7 +475,8 @@
 		}
 	}
 
-	flag && printf(" ");
+	if (flag)
+		printf(" ");
 out:
 	return;
 }

--zYM0uCDKw75PZbzx--
