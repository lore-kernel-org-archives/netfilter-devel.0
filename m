From: Patrick McHardy <kaber@trash.net>
Subject: [Fwd: [PATCH 2.5]: Fix logging of AH spis]
Date: Mon, 21 Jul 2003 03:40:54 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F1B44A6.8020102@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040108010401070805010000"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------040108010401070805010000
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Sent this to majordomo by accident ;)

-------- Original Message --------
Subject: 	[PATCH 2.5]: Fix logging of AH spis
Date: 	Mon, 21 Jul 2003 03:36:51 +0200
From: 	Patrick McHardy <kaber@trash.net>
To: 	Harald Welte <laforge@gnumonks.org>
CC: 	netfilter-devel-request@lists.netfilter.org



This patch makes ipt_LOG.c use the common struct ip_auth_hdr and struct 
ip_esp_hdr
declarations from ip.h. The struct ahhdr was wrong, so the patch also 
splits AH and
ESP spi logging.

Best regards,
Patrick




--------------040108010401070805010000
Content-Type: text/plain;
 name="25-ipt_LOG-ahhdr.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="25-ipt_LOG-ahhdr.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1535  -> 1.1536 
#	net/ipv4/netfilter/ipt_LOG.c	1.7     -> 1.8    
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/07/21	kaber@trash.net	1.1536
# [NETFILTER]: Fix logging of AH spis
# --------------------------------------------
#
diff -Nru a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
--- a/net/ipv4/netfilter/ipt_LOG.c	Thu May 22 01:36:54 2003
+++ b/net/ipv4/netfilter/ipt_LOG.c	Mon Jul 21 01:30:34 2003
@@ -2,16 +2,15 @@
  * This is a module which is used for logging packets.
  */
 #include <linux/module.h>
+#include <linux/spinlock.h>
 #include <linux/skbuff.h>
 #include <linux/ip.h>
-#include <linux/spinlock.h>
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
@@ -20,10 +19,6 @@
 #define DEBUGP(format, args...)
 #endif
 
-struct esphdr {
-	__u32   spi;
-}; /* FIXME evil kludge */
-        
 /* Use lock to serialize, so printks don't overlap */
 static spinlock_t log_lock = SPIN_LOCK_UNLOCKED;
 
@@ -256,13 +251,31 @@
 		break;
 	}
 	/* Max Length */
-	case IPPROTO_AH:
+	case IPPROTO_AH: {
+		struct ip_auth_hdr ah;
+
+		if (ntohs(iph.frag_off) & IP_OFFSET)
+			break;
+		
+		/* Max length: 9 "PROTO=AH " */
+		printk("PROTO=AH ");
+
+		/* Max length: 25 "INCOMPLETE [65535 bytes] " */
+		if (skb_copy_bits(skb, iphoff+iph.ihl*4, &ah, sizeof(ah)) < 0) {
+			printk("INCOMPLETE [%u bytes] ",
+			       skb->len - iphoff - iph.ihl*4);
+			break;
+		}
+
+		/* Length: 15 "SPI=0xF1234567 " */
+		printk("SPI=0x%x ", ntohl(ah.spi));
+		break;
+	}
 	case IPPROTO_ESP: {
-		struct esphdr esph;
-		int esp = (iph.protocol==IPPROTO_ESP);
+		struct ip_esp_hdr esph;
 
 		/* Max length: 10 "PROTO=ESP " */
-		printk("PROTO=%s ",esp? "ESP" : "AH");
+		printk("PROTO=ESP ");
 
 		if (ntohs(iph.frag_off) & IP_OFFSET)
 			break;


--------------040108010401070805010000--
