From: Henry Culver <henry@culcon.com>
Subject: ipset-6.11 patch to fix inclusion of linux/export.h
Date: Thu, 19 Jan 2012 11:31:21 -0700
Message-ID: <1326997881.6724.8.camel@moby.culcon.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-2T09IxgMAG9E5C8Ufn3e"
Cc: henry@culcon.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from culcon.com ([70.56.42.38]:33786 "EHLO ahab.culcon.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932520Ab2ASTCp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jan 2012 14:02:45 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-2T09IxgMAG9E5C8Ufn3e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

The tests for inclusion of linux/export.h in
ipset-6.11:kernel/net/netfilter/ipset/{ip_set_getport.c,pfxlen.c} are
incorrect.  linux/export.h did not go in until 3.2.0, check the 3.2
patch set.  Attached is a patch to correct this.

-Henry Culver

--=-2T09IxgMAG9E5C8Ufn3e
Content-Disposition: attachment; filename="ipset-export.h.patch"
Content-Type: text/x-patch; name="ipset-export.h.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

diff -uprN ipset-6.11/kernel/net/netfilter/ipset/ip_set_getport.c ipset-6.11-patched/kernel/net/netfilter/ipset/ip_set_getport.c
--- ipset-6.11/kernel/net/netfilter/ipset/ip_set_getport.c	2012-01-13 13:26:27.000000000 -0700
+++ ipset-6.11-patched/kernel/net/netfilter/ipset/ip_set_getport.c	2012-01-19 08:01:07.000000000 -0700
@@ -8,7 +8,7 @@
 /* Get Layer-4 data from the packets */
 
 #include <linux/version.h>
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,0,0)
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,0)
 #include <linux/export.h>
 #endif
 #include <linux/ip.h>
diff -uprN ipset-6.11/kernel/net/netfilter/ipset/pfxlen.c ipset-6.11-patched/kernel/net/netfilter/ipset/pfxlen.c
--- ipset-6.11/kernel/net/netfilter/ipset/pfxlen.c	2012-01-13 13:26:37.000000000 -0700
+++ ipset-6.11-patched/kernel/net/netfilter/ipset/pfxlen.c	2012-01-19 08:00:58.000000000 -0700
@@ -1,5 +1,5 @@
 #include <linux/version.h>
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,0,0)
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,0)
 #include <linux/export.h>
 #endif
 #include <linux/netfilter/ipset/pfxlen.h>

--=-2T09IxgMAG9E5C8Ufn3e--

