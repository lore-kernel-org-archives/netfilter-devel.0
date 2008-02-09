From: Eric Leblond <eric@inl.fr>
Subject: [RESEND PATCH] Improve ulogd.conf.in
Date: Sat,  9 Feb 2008 13:45:06 +0100
Message-ID: <12025611062935-git-send-email-eric@inl.fr>
References: <12023725412380-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:55144 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754017AbYBIMpI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Feb 2008 07:45:08 -0500
In-Reply-To: <12023725412380-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch documents IPv4 and IPv6 usage by adding some examples of stacks.
It also adds IP2BIN to the list of loaded plugins and fixes some comments.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
:100644 100644 465b224... 6d76909... M	ulogd.conf.in
 ulogd.conf.in |   33 +++++++++++++++++++++++++++------
 1 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/ulogd.conf.in b/ulogd.conf.in
index 465b224..6d76909 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -36,20 +36,21 @@ plugin="@libdir@/ulogd/ulogd_inppkt_NFLOG.so"
 plugin="@libdir@/ulogd/ulogd_inpflow_NFCT.so"
 plugin="@libdir@/ulogd/ulogd_filter_IFINDEX.so"
 plugin="@libdir@/ulogd/ulogd_filter_IP2STR.so"
+plugin="@libdir@/ulogd/ulogd_filter_IP2BIN.so"
 plugin="@libdir@/ulogd/ulogd_filter_PRINTPKT.so"
 plugin="@libdir@/ulogd/ulogd_filter_PRINTFLOW.so"
 plugin="@libdir@/ulogd/ulogd_output_LOGEMU.so"
 plugin="@libdir@/ulogd/ulogd_output_OPRINT.so"
 plugin="@libdir@/ulogd/ulogd_raw2packet_BASE.so"
 
-# this is a stack for packet-based logging via LOGEMU
+# this is a stack for IPv4 packet-based logging via LOGEMU
 #stack=log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU
 
 # this is a stack for IPv6 packet-based logging via LOGEMU
 #stack=log2:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU
 
 # this is a stack for ULOG packet-based logging via LOGEMU
-#stack=ulog1:ULOG,base1:BASE,print1:PRINTPKT,emu1:LOGEMU
+#stack=ulog1:ULOG,base1:BASE,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU
 
 # this is a stack for flow-based logging via LOGEMU
 #stack=ct1:NFCT,print1:PRINTFLOW,emu1:LOGEMU
@@ -57,17 +58,29 @@ plugin="@libdir@/ulogd/ulogd_raw2packet_BASE.so"
 # this is a stack for flow-based logging via OPRINT
 #stack=ct1:NFCT,op1:OPRINT
 
+# this is a stack for logging packet to MySQL
+#stack=log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2bin1:IP2BIN,mysql1:MYSQL
+
+# this is a stack for logging IPv6 packet to PGsql after a collect via NFLOG
+#stack=log2:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,pgsql1:PGSQL
+
+# this is a stack for flow-based logging to MySQL
+#stack=ct1:NFCT,ip2bin1:IP2BIN,mysql2:MYSQL
+
 [ct1]
 
+# IPv4 logging through NFLOG
 [log1]
-# netlink multicast group (the same as the iptables --ulog-nlgroup param)
+# netlink multicast group (the same as the iptables --nflog-group param)
 group=0
 
-[log2]
-group=1
-addressfamily=10
+# IPv6 logging through NFLOG
+[log1]
+group=1 # Group has to be different from the one use in log1
+addressfamily=10 # 10 is value of AF_INET6
 
 [ulog1]
+# netlink multicast group (the same as the iptables --ulog-nlgroup param)
 nlgroup=1
 
 [emu1]
@@ -85,3 +98,11 @@ user="nupik"
 table="ulog"
 pass="changeme"
 procedure="INSERT_PACKET_FULL"
+
+[pgsql1]
+db="nulog"
+host="localhost"
+user="nupik"
+table="ulog"
+pass="changeme"
+procedure="INSERT_PACKET_FULL"
-- 
1.5.2.5

