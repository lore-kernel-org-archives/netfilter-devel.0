From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.4]: fix uninitialized return value in ip_nat_tftp.c
Date: Mon, 21 Jul 2003 03:42:07 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F1B44EF.50800@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080909010002090503030607"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------080909010002090503030607
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch fixes an uninitialized return value in ip_nat_tftp.c

Best regards,
Patrick

--------------080909010002090503030607
Content-Type: text/plain;
 name="24-ip_nat_tftp-uninitialized-return-value.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="24-ip_nat_tftp-uninitialized-return-value.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1019  -> 1.1020 
#	net/ipv4/netfilter/ip_nat_tftp.c	1.1     -> 1.2    
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/07/21	kaber@trash.net	1.1020
# [NETFILTER]: fix uninitialized return value in ip_nat_tftp.c
# --------------------------------------------
#
diff -Nru a/net/ipv4/netfilter/ip_nat_tftp.c b/net/ipv4/netfilter/ip_nat_tftp.c
--- a/net/ipv4/netfilter/ip_nat_tftp.c	Mon Jul 21 02:20:24 2003
+++ b/net/ipv4/netfilter/ip_nat_tftp.c	Mon Jul 21 02:20:24 2003
@@ -153,7 +153,7 @@
 
 static int __init init(void)
 {
-	int i, ret;
+	int i, ret = 0;
 	char *tmpname;
 
 	if (!ports[0])

--------------080909010002090503030607--
