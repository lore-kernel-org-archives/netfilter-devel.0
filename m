From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] netfilter: ipset: remove unnecessary includes
Date: Tue, 01 Feb 2011 16:59:40 +0100
Message-ID: <4D482DEC.6070703@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040307080502080603020009"
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44836 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab1BAP7n (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Feb 2011 10:59:43 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040307080502080603020009
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit


--------------040307080502080603020009
Content-Type: text/plain;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="02.diff"

commit 582e1fc85ca3727abd4e99109a267c514ea5c260
Author: Patrick McHardy <kaber@trash.net>
Date:   Tue Feb 1 16:57:37 2011 +0100

    netfilter: ipset: remove unnecessary includes
    
    None of the set types need uaccess.h since this is handled centrally
    in ip_set_core. Most set types additionally don't need bitops.h and
    spinlock.h since they use neither. tcp.h is only needed by those
    using before(), udp.h is not needed at all.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
index 0474400..bca9699 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -13,7 +13,6 @@
 #include <linux/ip.h>
 #include <linux/skbuff.h>
 #include <linux/errno.h>
-#include <linux/uaccess.h>
 #include <linux/bitops.h>
 #include <linux/spinlock.h>
 #include <linux/netlink.h>
diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index d826332..5e79017 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -15,9 +15,6 @@
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/errno.h>
-#include <linux/uaccess.h>
-#include <linux/bitops.h>
-#include <linux/spinlock.h>
 #include <linux/if_ether.h>
 #include <linux/netlink.h>
 #include <linux/jiffies.h>
diff --git a/net/netfilter/ipset/ip_set_bitmap_port.c b/net/netfilter/ipset/ip_set_bitmap_port.c
index 92074bb..165f09b 100644
--- a/net/netfilter/ipset/ip_set_bitmap_port.c
+++ b/net/netfilter/ipset/ip_set_bitmap_port.c
@@ -9,13 +9,8 @@
 
 #include <linux/module.h>
 #include <linux/ip.h>
-#include <linux/tcp.h>
-#include <linux/udp.h>
 #include <linux/skbuff.h>
 #include <linux/errno.h>
-#include <linux/uaccess.h>
-#include <linux/bitops.h>
-#include <linux/spinlock.h>
 #include <linux/netlink.h>
 #include <linux/jiffies.h>
 #include <linux/timer.h>
diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
index 53964bc..43bcce2 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -12,9 +12,6 @@
 #include <linux/ip.h>
 #include <linux/skbuff.h>
 #include <linux/errno.h>
-#include <linux/uaccess.h>
-#include <linux/bitops.h>
-#include <linux/spinlock.h>
 #include <linux/random.h>
 #include <net/ip.h>
 #include <net/ipv6.h>
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
index d9b1928..adbe787 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -12,9 +12,6 @@
 #include <linux/ip.h>
 #include <linux/skbuff.h>
 #include <linux/errno.h>
-#include <linux/uaccess.h>
-#include <linux/bitops.h>
-#include <linux/spinlock.h>
 #include <linux/random.h>
 #include <net/ip.h>
 #include <net/ipv6.h>
diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/ipset/ip_set_hash_ipportip.c
index 80dae9d..22e23ab 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -12,9 +12,6 @@
 #include <linux/ip.h>
 #include <linux/skbuff.h>
 #include <linux/errno.h>
-#include <linux/uaccess.h>
-#include <linux/bitops.h>
-#include <linux/spinlock.h>
 #include <linux/random.h>
 #include <net/ip.h>
 #include <net/ipv6.h>
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index 8eacd8a..6033e8b 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -12,9 +12,6 @@
 #include <linux/ip.h>
 #include <linux/skbuff.h>
 #include <linux/errno.h>
-#include <asm/uaccess.h>
-#include <asm/bitops.h>
-#include <linux/spinlock.h>
 #include <linux/random.h>
 #include <net/ip.h>
 #include <net/ipv6.h>
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/ip_set_hash_net.c
index fb0e6a6..c4db202 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -12,9 +12,6 @@
 #include <linux/ip.h>
 #include <linux/skbuff.h>
 #include <linux/errno.h>
-#include <linux/uaccess.h>
-#include <linux/bitops.h>
-#include <linux/spinlock.h>
 #include <linux/random.h>
 #include <net/ip.h>
 #include <net/ipv6.h>
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ipset/ip_set_hash_netport.c
index 342250f..34a1656 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -12,9 +12,6 @@
 #include <linux/ip.h>
 #include <linux/skbuff.h>
 #include <linux/errno.h>
-#include <linux/uaccess.h>
-#include <linux/bitops.h>
-#include <linux/spinlock.h>
 #include <linux/random.h>
 #include <net/ip.h>
 #include <net/ipv6.h>

--------------040307080502080603020009--
