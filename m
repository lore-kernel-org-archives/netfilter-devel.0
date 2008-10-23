From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: [patch] iptables 1.4.2: Fix compile warnings
Date: Thu, 23 Oct 2008 14:58:00 +0200
Message-ID: <200810231458.00929.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_YTHAJuJII+1c5mf"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re01.intra2net.com ([82.165.28.202]:57575 "EHLO
	re01.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbYJWM6K (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Oct 2008 08:58:10 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--Boundary-00=_YTHAJuJII+1c5mf
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello Patrick,

attached is a small patch to fix compilation warnings
of iptables 1.4.2 using gcc 4.3.2.

Cheers,
Thomas


--Boundary-00=_YTHAJuJII+1c5mf
Content-Type: text/x-patch;
  charset="us-ascii";
  name="iptables-1.4.2-fix-compile-warnings.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="iptables-1.4.2-fix-compile-warnings.patch"

Fix compile warnings using gcc 4.3.2

libxt_dccp.c: In function 'port_to_service':
libxt_dccp.c:196: warning: implicit declaration of function 'htons'
libxt_sctp.c: In function 'port_to_service':
libxt_sctp.c:321: warning: implicit declaration of function 'htons'
libxt_tcp.c: In function 'port_to_service':
libxt_tcp.c:220: warning: implicit declaration of function 'htons'
libxt_udp.c: In function 'port_to_service':
libxt_udp.c:104: warning: implicit declaration of function 'htons'

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
diff -u -r -p iptables-1.4.2.orig/extensions/libxt_dccp.c iptables-1.4.2/extensions/libxt_dccp.c
--- iptables-1.4.2.orig/extensions/libxt_dccp.c	Thu Oct 23 12:33:44 2008
+++ iptables-1.4.2/extensions/libxt_dccp.c	Thu Oct 23 14:19:09 2008
@@ -12,6 +12,7 @@
 #include <netdb.h>
 #include <ctype.h>
 
+#include <netinet/in.h>
 #include <xtables.h>
 #include <linux/dccp.h>
 #include <linux/netfilter/x_tables.h>
diff -u -r -p iptables-1.4.2.orig/extensions/libxt_sctp.c iptables-1.4.2/extensions/libxt_sctp.c
--- iptables-1.4.2.orig/extensions/libxt_sctp.c	Thu Oct 23 12:33:45 2008
+++ iptables-1.4.2/extensions/libxt_sctp.c	Thu Oct 23 14:18:28 2008
@@ -14,6 +14,7 @@
 #include <netdb.h>
 #include <ctype.h>
 
+#include <netinet/in.h>
 #include <xtables.h>
 
 #ifndef ARRAY_SIZE
diff -u -r -p iptables-1.4.2.orig/extensions/libxt_tcp.c iptables-1.4.2/extensions/libxt_tcp.c
--- iptables-1.4.2.orig/extensions/libxt_tcp.c	Thu Oct 23 12:33:44 2008
+++ iptables-1.4.2/extensions/libxt_tcp.c	Thu Oct 23 14:18:39 2008
@@ -4,6 +4,7 @@
 #include <string.h>
 #include <stdlib.h>
 #include <getopt.h>
+#include <netinet/in.h>
 #include <xtables.h>
 #include <linux/netfilter/xt_tcpudp.h>
 
diff -u -r -p iptables-1.4.2.orig/extensions/libxt_udp.c iptables-1.4.2/extensions/libxt_udp.c
--- iptables-1.4.2.orig/extensions/libxt_udp.c	Thu Oct 23 12:33:44 2008
+++ iptables-1.4.2/extensions/libxt_udp.c	Thu Oct 23 14:18:47 2008
@@ -4,6 +4,7 @@
 #include <string.h>
 #include <stdlib.h>
 #include <getopt.h>
+#include <netinet/in.h>
 #include <xtables.h>
 #include <linux/netfilter/xt_tcpudp.h>
 

--Boundary-00=_YTHAJuJII+1c5mf--
