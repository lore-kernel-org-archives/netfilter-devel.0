From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.5]: Fix wrong AH-header in ipt_ah.c
Date: Mon, 21 Jul 2003 03:33:59 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F1B4307.8070108@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090007030905070009060105"
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
--------------090007030905070009060105
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch uses the common struct ip_auth_hdr declaration from ip.h.
The header declared in ipt_ah.c was wrong, so this makes matching actually
work.

Best regards,
Patrick

--------------090007030905070009060105
Content-Type: text/plain;
 name="25-ipt_ah-wrong-ahhdr.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="25-ipt_ah-wrong-ahhdr.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1536  -> 1.1537 
#	net/ipv4/netfilter/ipt_esp.c	1.6     -> 1.7    
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/07/21	kaber@trash.net	1.1537
# [NETFILTER]: Fix wrong AH-header
# --------------------------------------------
#
diff -Nru a/net/ipv4/netfilter/ipt_ah.c b/net/ipv4/netfilter/ipt_ah.c
--- a/net/ipv4/netfilter/ipt_ah.c	Thu May 22 01:35:36 2003
+++ b/net/ipv4/netfilter/ipt_ah.c	Mon Jul 21 02:48:59 2003
@@ -1,6 +1,7 @@
 /* Kernel module to match AH parameters. */
 #include <linux/module.h>
 #include <linux/skbuff.h>
+#include <linux/ip.h>
 
 #include <linux/netfilter_ipv4/ipt_ah.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
@@ -13,10 +14,6 @@
 #define duprintf(format, args...)
 #endif
 
-struct ahhdr {
-	__u32   spi;
-};
-
 /* Returns 1 if the spi is matched by the range, 0 otherwise */
 static inline int
 spi_match(u_int32_t min, u_int32_t max, u_int32_t spi, int invert)
@@ -37,7 +34,7 @@
       int offset,
       int *hotdrop)
 {
-	struct ahhdr ah;
+	struct ip_auth_hdr ah;
 	const struct ipt_ah *ahinfo = matchinfo;
 
 	/* Must not be a fragment. */

--------------090007030905070009060105--
