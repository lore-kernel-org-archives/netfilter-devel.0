From: Peter Warasin <peter@endian.com>
Subject: [PATCH 5/5] Adds ebtables nflog stack samples to config file
Date: Mon, 11 Feb 2008 23:07:58 +0100
Message-ID: <20080211221057.138011477@endian.com>
References: <20080211220753.796791654@endian.com>
Cc: ebtables-devel@lists.sourceforge.net,
	Peter Warasin <peter@endian.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from solaria.endian.it ([80.190.199.145]:42251 "EHLO
	solaria.endian.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757335AbYBKWLA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Feb 2008 17:11:00 -0500
Content-Disposition: inline; filename=ulogd2-PF_BRIDGE-ulogdconf.patch
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a sample configuration for logging
with ebtables through nflog out to LOGEMU and SYSLOG.

It also fixes a config bug with ipv6 (log2)

Signed-off-by: Peter Warasin <peter@endian.com>

---
 ulogd.conf.in |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

Index: ulogd2/ulogd.conf.in
===================================================================
--- ulogd2.orig/ulogd.conf.in	2008-02-11 22:59:58.000000000 +0100
+++ ulogd2/ulogd.conf.in	2008-02-11 23:05:08.000000000 +0100
@@ -49,6 +49,9 @@
 # this is a stack for IPv6 packet-based logging via LOGEMU
 #stack=log2:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU
 
+# this is a stack for ebtables packet-based logging via LOGEMU
+#stack=log3:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU
+
 # this is a stack for ULOG packet-based logging via LOGEMU
 #stack=ulog1:ULOG,base1:BASE,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU
 
@@ -64,6 +67,9 @@
 # this is a stack for logging IPv6 packet to PGsql after a collect via NFLOG
 #stack=log2:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,pgsql1:PGSQL
 
+# this is a stack for logging ebtables packets to syslog after a collect via NFLOG
+#stack=log3:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,sys1:SYSLOG
+
 # this is a stack for flow-based logging to MySQL
 #stack=ct1:NFCT,ip2bin1:IP2BIN,mysql2:MYSQL
 
@@ -75,10 +81,15 @@
 group=0
 
 # IPv6 logging through NFLOG
-[log1]
+[log2]
 group=1 # Group has to be different from the one use in log1
 addressfamily=10 # 10 is value of AF_INET6
 
+# ebtables logging through NFLOG
+[log3]
+group=2 # Group has to be different from the one use in log1/log2
+addressfamily=7 # 7 is value of AF_BRIDGE
+
 [ulog1]
 # netlink multicast group (the same as the iptables --ulog-nlgroup param)
 nlgroup=1
@@ -106,3 +117,6 @@
 table="ulog"
 pass="changeme"
 procedure="INSERT_PACKET_FULL"
+
+[sys2]
+facility=LOG_LOCAL2

-- 
