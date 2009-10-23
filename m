From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: xt_ACCOUNT and big endian machines
Date: Fri, 23 Oct 2009 16:23:42 +0200
Message-ID: <200910231623.42725.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_uxb4KDFpnMAPvh0"
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re01.intra2net.com ([82.165.28.202]:49385 "EHLO
	re01.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbZJWOXk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Oct 2009 10:23:40 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--Boundary-00=_uxb4KDFpnMAPvh0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello Jan,

a user of ipt_ACCOUNT recently sent me some patches regarding
big endian support in ipt_ACCOUNT/xt_ACCOUNT:
http://developer.intra2net.com/mailarchive/html/ipt_ACCOUNT/2009/msg00014.html

I'm wondering if this is the best approach to support big endian machines
with all those #ifdefs?

Cheers,
Thomas

--Boundary-00=_uxb4KDFpnMAPvh0
Content-Type: text/x-patch;
  charset="UTF-8";
  name="ipt_ACCOUNT-1.15-byteorder.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ipt_ACCOUNT-1.15-byteorder.patch"

diff -ru ACCOUNT/linux-2.6/net/ipv4/netfilter/ipt_ACCOUNT.c ACCOUNT.byteorder/linux-2.6/net/ipv4/netfilter/ipt_ACCOUNT.c
--- ACCOUNT/linux-2.6/net/ipv4/netfilter/ipt_ACCOUNT.c	2009-04-08 15:35:42.000000000 +0200
+++ ACCOUNT.byteorder/linux-2.6/net/ipv4/netfilter/ipt_ACCOUNT.c	2009-10-13 15:11:52.000000000 +0200
@@ -32,6 +32,7 @@
 #include <linux/string.h>
 #include <linux/spinlock.h>
 #include <asm/uaccess.h>
+#include <asm/byteorder.h>
 
 #include <net/route.h>
 #include <linux/netfilter_ipv4/ipt_ACCOUNT.h>
@@ -362,8 +363,15 @@
     }
 
     /* Calculate array positions */
+#if defined(__LITTLE_ENDIAN_BITFIELD)
     src_slot = (unsigned char)((src_ip&0xFF000000) >> 24);
     dst_slot = (unsigned char)((dst_ip&0xFF000000) >> 24);
+#elif defined(__BIG_ENDIAN_BITFIELD)
+    src_slot = (unsigned char)(src_ip&0x000000FF);
+    dst_slot = (unsigned char)(dst_ip&0x000000FF);
+#else
+#error  "Please fix <asm/byteorder.h>"
+#endif
 
     /* Increase size counters */
     if (is_src) {
@@ -414,7 +422,13 @@
 {
     /* Do we need to process src IP? */
     if ((net_ip&netmask) == (src_ip&netmask)) {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
         unsigned char slot = (unsigned char)((src_ip&0x00FF0000) >> 16);
+#elif defined(__BIG_ENDIAN_BITFIELD)
+        unsigned char slot = (unsigned char)((src_ip&0x0000FF00) >> 8);
+#else
+#error  "Please fix <asm/byteorder.h>"
+#endif
         DEBUGP("ACCOUNT: Calculated SRC 16 bit network slot: %d\n", slot);
 
         /* Do we need to create a new mask_24 bucket? */
@@ -430,7 +444,13 @@
 
     /* Do we need to process dst IP? */
     if ((net_ip&netmask) == (dst_ip&netmask)) {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
         unsigned char slot = (unsigned char)((dst_ip&0x00FF0000) >> 16);
+#elif defined(__BIG_ENDIAN_BITFIELD)
+        unsigned char slot = (unsigned char)((dst_ip&0x0000FF00) >> 8);
+#else
+#error  "Please fix <asm/byteorder.h>"
+#endif
         DEBUGP("ACCOUNT: Calculated DST 16 bit network slot: %d\n", slot);
 
         /* Do we need to create a new mask_24 bucket? */
@@ -452,7 +472,13 @@
 {
     /* Do we need to process src IP? */
     if ((net_ip&netmask) == (src_ip&netmask)) {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
         unsigned char slot = (unsigned char)((src_ip&0x0000FF00) >> 8);
+#elif defined(__BIG_ENDIAN_BITFIELD)
+        unsigned char slot = (unsigned char)((src_ip&0x00FF0000) >> 16);
+#else
+#error  "Please fix <asm/byteorder.h>"
+#endif
         DEBUGP("ACCOUNT: Calculated SRC 24 bit network slot: %d\n", slot);
 
         /* Do we need to create a new mask_24 bucket? */
@@ -468,7 +494,13 @@
 
     /* Do we need to process dst IP? */
     if ((net_ip&netmask) == (dst_ip&netmask)) {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
         unsigned char slot = (unsigned char)((dst_ip&0x0000FF00) >> 8);
+#elif defined(__BIG_ENDIAN_BITFIELD)
+        unsigned char slot = (unsigned char)((dst_ip&0x00FF0000) >> 16);
+#else
+#error  "Please fix <asm/byteorder.h>"
+#endif
         DEBUGP("ACCOUNT: Calculated DST 24 bit network slot: %d\n", slot);
 
         /* Do we need to create a new mask_24 bucket? */
@@ -789,7 +821,13 @@
     
     for (i = 0; i <= 255; i++) {
         if (data->ip[i].src_packets || data->ip[i].dst_packets) {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
             handle_ip.ip = net_ip | net_OR_mask | (i<<24);
+#elif defined(__BIG_ENDIAN_BITFIELD)
+            handle_ip.ip = net_ip | net_OR_mask | i;
+#else
+#error  "Please fix <asm/byteorder.h>"
+#endif
             
             handle_ip.src_packets = data->ip[i].src_packets;
             handle_ip.src_bytes = data->ip[i].src_bytes;
@@ -862,7 +900,15 @@
                 struct ipt_acc_mask_24 *network = 
                     (struct ipt_acc_mask_24*)network_16->mask_24[b];
                 if (ipt_acc_handle_copy_data(to_user, &to_user_pos,
-                                      &tmpbuf_pos, network, net_ip, (b << 16)))
+                                      &tmpbuf_pos, network, net_ip,
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+				     (b << 16)
+#elif defined(__BIG_ENDIAN_BITFIELD)
+				     (b << 8)
+#else
+#error  "Please fix <asm/byteorder.h>"
+#endif
+		))
                     return -1;
             }
         }
@@ -890,7 +936,15 @@
                             (struct ipt_acc_mask_24*)network_16->mask_24[b];
                         if (ipt_acc_handle_copy_data(to_user,
                                        &to_user_pos, &tmpbuf_pos,
-                                       network, net_ip, (a << 8) | (b << 16)))
+                                       network, net_ip,
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+				       (a << 8) | (b << 16)
+#elif defined(__BIG_ENDIAN_BITFIELD)
+				       (a << 16) | (b << 8)
+#else
+#error  "Please fix <asm/byteorder.h>"
+#endif
+			))
                             return -1;
                     }
                 }

--Boundary-00=_uxb4KDFpnMAPvh0
Content-Type: text/x-patch;
  charset="UTF-8";
  name="libipt_ACCOUNT-1.3-byteorder.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="libipt_ACCOUNT-1.3-byteorder.patch"

diff -ru libipt_ACCOUNT-1.3/iptaccount/iptaccount.c libipt_ACCOUNT-1.3.byteorder/iptaccount/iptaccount.c
--- libipt_ACCOUNT-1.3/iptaccount/iptaccount.c	2007-12-14 10:42:42.000000000 +0100
+++ libipt_ACCOUNT-1.3.byteorder/iptaccount/iptaccount.c	2009-10-13 15:13:05.000000000 +0200
@@ -34,8 +34,9 @@
     static char buf[17];
     const unsigned char *bytep;
 
+    addr = htonl(addr);
     bytep = (const unsigned char *) &addr;
-    snprintf(buf, 16, "%u.%u.%u.%u", bytep[0], bytep[1], bytep[2], bytep[3]);
+    snprintf(buf, 16, "%u.%u.%u.%u", ((addr&0xFF000000)>>24), ((addr&0x00FF0000)>>16), ((addr&0x0000FF00)>>8),(addr&0x000000FF));
     buf[16] = 0;
     return buf;
 }

--Boundary-00=_uxb4KDFpnMAPvh0--
