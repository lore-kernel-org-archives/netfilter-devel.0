From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.4]: Fix logging of AH spis, verify datalen for IP options
Date: Mon, 21 Jul 2003 03:46:00 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F1B45D8.1080303@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040502010309050401050503"
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
--------------040502010309050401050503
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch is equal to the 2.5 version (fix logging of AH header), in 
addition it also
makes sure the packet is really long enough when logging IP Options (for 
local packets
from raw-sockets). struct esphdr gets added the seq_no field so behavior 
wrt. incomplete
headers is identical to 2.5.

Best regards,
Patrick

--------------040502010309050401050503
Content-Type: text/plain;
 name="24-ipt_LOG-ahhdr+optlen.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="24-ipt_LOG-ahhdr+optlen.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1021  -> 1.1022 
#	net/ipv4/netfilter/ipt_LOG.c	1.4     -> 1.5    
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/07/21	kaber@trash.net	1.1022
# [NETFILTER]: Fix logging of AH spis, verify datalen for IP options
# --------------------------------------------
#
diff -Nru a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
--- a/net/ipv4/netfilter/ipt_LOG.c	Mon Jul 21 02:21:23 2003
+++ b/net/ipv4/netfilter/ipt_LOG.c	Mon Jul 21 02:21:23 2003
@@ -3,15 +3,14 @@
  */
 #include <linux/module.h>
 #include <linux/skbuff.h>
-#include <linux/ip.h>
 #include <linux/spinlock.h>
+#include <linux/ip.h>
 #include <net/icmp.h>
 #include <net/udp.h>
 #include <net/tcp.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
-
-struct in_device;
 #include <net/route.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_LOG.h>
 
 #if 0
@@ -20,10 +19,20 @@
 #define DEBUGP(format, args...)
 #endif
 
+/* FIXME: move to ip.h like in 2.5 */
+struct ahhdr {
+	__u8    nexthdr;
+	__u8    hdrlen;
+	__u16   reserved;
+	__u32   spi;
+	__u32   seq_no;
+};
+
 struct esphdr {
 	__u32   spi;
-}; /* FIXME evil kludge */
-        
+	__u32   seq_no;
+};
+
 /* Use lock to serialize, so printks don't overlap */
 static spinlock_t log_lock = SPIN_LOCK_UNLOCKED;
 
@@ -58,7 +67,8 @@
 		printk("FRAG:%u ", ntohs(iph->frag_off) & IP_OFFSET);
 
 	if ((info->logflags & IPT_LOG_IPOPT)
-	    && iph->ihl * 4 != sizeof(struct iphdr)) {
+	    && iph->ihl * 4 != sizeof(struct iphdr)
+	    && iph->ihl * 4 >= datalen) {
 		unsigned int i;
 
 		/* Max length: 127 "OPT (" 15*4*2chars ") " */
@@ -231,13 +241,30 @@
 		break;
 	}
 	/* Max Length */
-	case IPPROTO_AH:
+	case IPPROTO_AH: {
+		struct ahhdr *ah = protoh;
+
+		/* Max length: 9 "PROTO=AH " */
+		printk("PROTO=AH ");
+
+		if (ntohs(iph->frag_off) & IP_OFFSET)
+			break;
+
+		/* Max length: 25 "INCOMPLETE [65535 bytes] " */
+		if (datalen < sizeof (*ah)) {
+			printk("INCOMPLETE [%u bytes] ", datalen);
+			break;
+		}
+
+		/* Length: 15 "SPI=0xF1234567 " */
+		printk("SPI=0x%x ", ntohl(ah->spi) );
+		break;
+	}
 	case IPPROTO_ESP: {
 		struct esphdr *esph = protoh;
-		int esp= (iph->protocol==IPPROTO_ESP);
 
 		/* Max length: 10 "PROTO=ESP " */
-		printk("PROTO=%s ",esp? "ESP" : "AH");
+		printk("PROTO=ESP ");
 
 		if (ntohs(iph->frag_off) & IP_OFFSET)
 			break;

--------------040502010309050401050503--
