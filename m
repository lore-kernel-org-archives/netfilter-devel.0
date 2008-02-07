From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 3/3] Add examples to config file.
Date: Thu,  7 Feb 2008 09:22:21 +0100
Message-ID: <12023725412380-git-send-email-eric@inl.fr>
References: <12023725412-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:43543 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754485AbYBGIWX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Feb 2008 03:22:23 -0500
In-Reply-To: <12023725412-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds some examples of stack to the configuration file.
It also fixes some comments to avoid confusion. IP2BIN has been
added to the list of loaded modules.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
:100644 100644 465b224... 3fc3a41... M	ulogd.conf.in
 ulogd.conf.in |   30 +++++++++++++++++++++---------
 1 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/ulogd.conf.in b/ulogd.conf.in
index 465b224..3fc3a41 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -36,6 +36,7 @@ plugin="@libdir@/ulogd/ulogd_inppkt_NFLOG.so"
 plugin="@libdir@/ulogd/ulogd_inpflow_NFCT.so"
 plugin="@libdir@/ulogd/ulogd_filter_IFINDEX.so"
 plugin="@libdir@/ulogd/ulogd_filter_IP2STR.so"
+plugin="@libdir@/ulogd/ulogd_filter_IP2BIN.so"
 plugin="@libdir@/ulogd/ulogd_filter_PRINTPKT.so"
 plugin="@libdir@/ulogd/ulogd_filter_PRINTFLOW.so"
 plugin="@libdir@/ulogd/ulogd_output_LOGEMU.so"
@@ -45,11 +46,8 @@ plugin="@libdir@/ulogd/ulogd_raw2packet_BASE.so"
 # this is a stack for packet-based logging via LOGEMU
 #stack=log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU
 
-# this is a stack for IPv6 packet-based logging via LOGEMU
-#stack=log2:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU
-
 # this is a stack for ULOG packet-based logging via LOGEMU
-#stack=ulog1:ULOG,base1:BASE,print1:PRINTPKT,emu1:LOGEMU
+#stack=ulog1:ULOG,base1:BASE,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU
 
 # this is a stack for flow-based logging via LOGEMU
 #stack=ct1:NFCT,print1:PRINTFLOW,emu1:LOGEMU
@@ -57,17 +55,23 @@ plugin="@libdir@/ulogd/ulogd_raw2packet_BASE.so"
 # this is a stack for flow-based logging via OPRINT
 #stack=ct1:NFCT,op1:OPRINT
 
+# this is a stack for NFLOG packet logging to MySQL
+#stack=log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2bin1:IP2BIN,mysql1:MYSQL
+
+# this is a stack for NFLOG packet logging to PGsql
+#stack=log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,pgsql1:PGSQL
+
+# this is a stack for flow-based logging to MySQL
+#stack=ct1:NFCT,ip2bin1:IP2BIN,mysql2:MYSQL
+
 [ct1]
 
 [log1]
-# netlink multicast group (the same as the iptables --ulog-nlgroup param)
+# netlink multicast group (the same as the iptables --nflog-group param)
 group=0
 
-[log2]
-group=1
-addressfamily=10
-
 [ulog1]
+# netlink multicast group (the same as the iptables --ulog-nlgroup param)
 nlgroup=1
 
 [emu1]
@@ -85,3 +89,11 @@ user="nupik"
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

