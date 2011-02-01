From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] netfilter: ipset: install ipset related header files
Date: Tue, 01 Feb 2011 18:54:54 +0100
Message-ID: <4D4848EE.2050000@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050006000505020609090101"
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46748 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab1BARy4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Feb 2011 12:54:56 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050006000505020609090101
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit


--------------050006000505020609090101
Content-Type: text/plain;
 name="03.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="03.diff"

commit e3e241b2769b27669d05f0a05083acd21b4faa2c
Author: Patrick McHardy <kaber@trash.net>
Date:   Tue Feb 1 18:52:42 2011 +0100

    netfilter: ipset: install ipset related header files
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbuild
index 89c0d1e..ba19544 100644
--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -1,3 +1,5 @@
+header-y += ipset/
+
 header-y += nf_conntrack_common.h
 header-y += nf_conntrack_ftp.h
 header-y += nf_conntrack_sctp.h
@@ -55,6 +57,7 @@ header-y += xt_quota.h
 header-y += xt_rateest.h
 header-y += xt_realm.h
 header-y += xt_recent.h
+header-y += xt_set.h
 header-y += xt_sctp.h
 header-y += xt_socket.h
 header-y += xt_state.h
diff --git a/include/linux/netfilter/ipset/Kbuild b/include/linux/netfilter/ipset/Kbuild
new file mode 100644
index 0000000..601fe71
--- /dev/null
+++ b/include/linux/netfilter/ipset/Kbuild
@@ -0,0 +1,4 @@
+header-y += ip_set.h
+header-y += ip_set_bitmap.h
+header-y += ip_set_hash.h
+header-y += ip_set_list.h
diff --git a/include/linux/netfilter/xt_set.h b/include/linux/netfilter/xt_set.h
index 69b2bd1..081f1de 100644
--- a/include/linux/netfilter/xt_set.h
+++ b/include/linux/netfilter/xt_set.h
@@ -1,6 +1,7 @@
 #ifndef _XT_SET_H
 #define _XT_SET_H
 
+#include <linux/types.h>
 #include <linux/netfilter/ipset/ip_set.h>
 
 /* Revision 0 interface: backward compatible with netfilter/iptables */

--------------050006000505020609090101--
