From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.4]: Only match packets with full ESP header (like in 2.5)
Date: Mon, 21 Jul 2003 03:51:24 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F1B471C.4040108@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060806010701070006030301"
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
--------------060806010701070006030301
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch is pretty useless, it just adds an unused field to struct esphdr
so behaviour wrt. incomplete headers is identical to 2.5.

Best regards,
Patrick

--------------060806010701070006030301
Content-Type: text/plain;
 name="24-ipt_esp-esphdr.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="24-ipt_esp-esphdr.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1022  -> 1.1023 
#	net/ipv4/netfilter/ipt_esp.c	1.1     -> 1.2    
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/07/21	kaber@trash.net	1.1023
# [NETFILTER]: Only match packets with full ESP header (like in 2.5)
# --------------------------------------------
#
diff -Nru a/net/ipv4/netfilter/ipt_esp.c b/net/ipv4/netfilter/ipt_esp.c
--- a/net/ipv4/netfilter/ipt_esp.c	Mon Jul 21 02:22:20 2003
+++ b/net/ipv4/netfilter/ipt_esp.c	Mon Jul 21 02:22:20 2003
@@ -16,6 +16,7 @@
 
 struct esphdr {
 	__u32   spi;
+	__u32   seq_no;
 };
 
 /* Returns 1 if the spi is matched by the range, 0 otherwise */

--------------060806010701070006030301--
