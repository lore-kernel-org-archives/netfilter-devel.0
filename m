From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH] Document IPv4 and IPv6 logging difference in NFLOG
Date: Sun, 10 Feb 2008 00:19:18 +0100
Message-ID: <12025991581714-git-send-email-eric@inl.fr>
References: <47ADE654.5080604@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:37178 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754762AbYBIXTU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Feb 2008 18:19:20 -0500
In-Reply-To: <47ADE654.5080604@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Here's an update of the patch. This patch is usefull if the modification
in r7348 are reverted.

This patch documents difference between IPv4 and IPv6 logging.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 ulogd.conf.in |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/ulogd.conf.in b/ulogd.conf.in
index 3fc3a41..6d76909 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -43,9 +43,12 @@ plugin="@libdir@/ulogd/ulogd_output_LOGEMU.so"
 plugin="@libdir@/ulogd/ulogd_output_OPRINT.so"
 plugin="@libdir@/ulogd/ulogd_raw2packet_BASE.so"
 
-# this is a stack for packet-based logging via LOGEMU
+# this is a stack for IPv4 packet-based logging via LOGEMU
 #stack=log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU
 
+# this is a stack for IPv6 packet-based logging via LOGEMU
+#stack=log2:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU
+
 # this is a stack for ULOG packet-based logging via LOGEMU
 #stack=ulog1:ULOG,base1:BASE,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU
 
@@ -55,21 +58,27 @@ plugin="@libdir@/ulogd/ulogd_raw2packet_BASE.so"
 # this is a stack for flow-based logging via OPRINT
 #stack=ct1:NFCT,op1:OPRINT
 
-# this is a stack for NFLOG packet logging to MySQL
+# this is a stack for logging packet to MySQL
 #stack=log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2bin1:IP2BIN,mysql1:MYSQL
 
-# this is a stack for NFLOG packet logging to PGsql
-#stack=log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,pgsql1:PGSQL
+# this is a stack for logging IPv6 packet to PGsql after a collect via NFLOG
+#stack=log2:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,pgsql1:PGSQL
 
 # this is a stack for flow-based logging to MySQL
 #stack=ct1:NFCT,ip2bin1:IP2BIN,mysql2:MYSQL
 
 [ct1]
 
+# IPv4 logging through NFLOG
 [log1]
 # netlink multicast group (the same as the iptables --nflog-group param)
 group=0
 
+# IPv6 logging through NFLOG
+[log1]
+group=1 # Group has to be different from the one use in log1
+addressfamily=10 # 10 is value of AF_INET6
+
 [ulog1]
 # netlink multicast group (the same as the iptables --ulog-nlgroup param)
 nlgroup=1
-- 
1.5.2.5

