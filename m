From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.4]: Fix wrong AH-header
Date: Mon, 21 Jul 2003 03:48:51 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F1B4683.3040103@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020306020707090300050003"
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
--------------020306020707090300050003
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

I'm beginning to feel guilty for not warning you before bombing you with 
patches ..
sorry .. only this and one more.

This patch fixes spi-matching in ipt_ah like the 2.5 version.

Best regards,
Patrick


--------------020306020707090300050003
Content-Type: text/plain;
 name="24-ipt_ah-wrong-ahhdr.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="24-ipt_ah-wrong-ahhdr.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1020  -> 1.1021 
#	net/ipv4/netfilter/ipt_ah.c	1.2     -> 1.3    
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/07/21	kaber@trash.net	1.1021
# [NETFILTER]: Fix wrong AH-header
# --------------------------------------------
#
diff -Nru a/net/ipv4/netfilter/ipt_ah.c b/net/ipv4/netfilter/ipt_ah.c
--- a/net/ipv4/netfilter/ipt_ah.c	Mon Jul 21 02:20:52 2003
+++ b/net/ipv4/netfilter/ipt_ah.c	Mon Jul 21 02:20:52 2003
@@ -15,7 +15,11 @@
 #endif
 
 struct ahhdr {
+	__u8    nexthdr;
+	__u8    hdrlen;
+	__u16   reserved;
 	__u32   spi;
+	__u32   seq_no;
 };
 
 /* Returns 1 if the spi is matched by the range, 0 otherwise */

--------------020306020707090300050003--
