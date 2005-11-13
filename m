From: Pablo Neira <pablo@netfilter.org>
Subject: [PATCH 1/2] define NETLINK_NETFILTER if it's undefined
Date: Sun, 13 Nov 2005 18:14:04 +0100
Message-ID: <4377745C.9060906@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040300010504080400090709"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------040300010504080400090709
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi Harald,

This patch applies to libnfnetlink.

o It define NETLINK_NETFILTER if it's not defined.
o Kill KERNELDIR in Makefile.am, it's not set anymore.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------040300010504080400090709
Content-Type: text/plain;
 name="01-libnfnetlink.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01-libnfnetlink.patch"

Index: include/libnfnetlink/libnfnetlink.h
===================================================================
--- include/libnfnetlink/libnfnetlink.h	(revision 4511)
+++ include/libnfnetlink/libnfnetlink.h	(working copy)
@@ -4,6 +4,8 @@
  *
  * 2005-10-29 Pablo Neira Ayuso <pablo@netfilter.org>:
  * 	Fix NFNL_HEADER_LEN
+ * 2005-11-13 Pablo Neira Ayuso <pablo@netfilter.org>:
+ * 	Define NETLINK_NETFILTER if it's undefined
  */
 
 #ifndef __LIBNFNETLINK_H
@@ -18,6 +20,10 @@
 #include <linux/netlink.h>
 #include <libnfnetlink/linux_nfnetlink.h>
 
+#ifndef NETLINK_NETFILTER
+#define NETLINK_NETFILTER 12
+#endif
+
 #define NLMSG_TAIL(nlh) \
 	(((void *) (nlh)) + NLMSG_ALIGN((nlh)->nlmsg_len))
 
Index: src/Makefile.am
===================================================================
--- src/Makefile.am	(revision 4511)
+++ src/Makefile.am	(working copy)
@@ -2,7 +2,7 @@
 
 #EXTRA_DIST = $(man_MANS) acinclude.m4
 
-INCLUDES = $(all_includes) -I$(top_srcdir)/include -I${KERNELDIR} 
+INCLUDES = $(all_includes) -I$(top_srcdir)/include
 AM_CFLAGS=-fPIC -Wall
 LIBS=
 

--------------040300010504080400090709--
