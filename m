From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: [patch] iptables 1.4.2: Fix compile error
Date: Thu, 23 Oct 2008 14:56:25 +0200
Message-ID: <200810231456.26325.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_6RHAJEIKvd+A+N9"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re01.intra2net.com ([82.165.28.202]:43879 "EHLO
	re01.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbYJWM4h (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Oct 2008 08:56:37 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--Boundary-00=_6RHAJEIKvd+A+N9
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello Patrick,

attached is a small patch to fix compilation
of iptables 1.4.2 using gcc 4.3.2.

Cherrs,
Thomas


--Boundary-00=_6RHAJEIKvd+A+N9
Content-Type: text/x-patch;
  charset="us-ascii";
  name="iptables-1.4.2-libxt_iprange-compile-error.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="iptables-1.4.2-libxt_iprange-compile-error.patch"

Fix compile error in libxt_iprange.c using gcc 4.3.2

In file included from libxt_iprange.c:9:
../include/linux/netfilter.h:43: error: field 'in' has incomplete type
../include/linux/netfilter.h:44: error: field 'in6' has incomplete type
libxt_iprange.c: In function 'parse_iprange':
libxt_iprange.c:46: error: dereferencing pointer to incomplete type
libxt_iprange.c:53: error: dereferencing pointer to incomplete type
libxt_iprange.c: In function 'iprange_mt4_parse':
libxt_iprange.c:117: error: dereferencing pointer to incomplete type
libxt_iprange.c:121: error: dereferencing pointer to incomplete type
libxt_iprange.c:136: error: dereferencing pointer to incomplete type
libxt_iprange.c:140: error: dereferencing pointer to incomplete type
libxt_iprange.c: In function 'iprange_mt6_parse':
libxt_iprange.c:167: error: dereferencing pointer to incomplete type
libxt_iprange.c:171: error: dereferencing pointer to incomplete type
libxt_iprange.c:186: error: dereferencing pointer to incomplete type
libxt_iprange.c:190: error: dereferencing pointer to incomplete type

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
diff -u -r -p iptables-1.4.2.orig/extensions/libxt_iprange.c iptables-1.4.2/extensions/libxt_iprange.c
--- iptables-1.4.2.orig/extensions/libxt_iprange.c	Thu Oct 23 12:33:44 2008
+++ iptables-1.4.2/extensions/libxt_iprange.c	Thu Oct 23 14:16:00 2008
@@ -5,6 +5,7 @@
 #include <stdlib.h>
 #include <getopt.h>
 
+#include <netinet/in.h>
 #include <xtables.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/xt_iprange.h>

--Boundary-00=_6RHAJEIKvd+A+N9--
