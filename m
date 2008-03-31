From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 4/4] Add some example to ulogd.conf.in.
Date: Tue,  1 Apr 2008 01:09:50 +0200
Message-ID: <12070049903408-git-send-email-eric@inl.fr>
References: <1207004990315-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:41727 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751130AbYCaXJx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Mar 2008 19:09:53 -0400
In-Reply-To: <1207004990315-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds some example to the default configuration file. It modify
some stack to take my latest patches into account.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 ulogd.conf.in |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/ulogd.conf.in b/ulogd.conf.in
index d18ed5d..fde2e4e 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -43,7 +43,8 @@ plugin="@libdir@/ulogd/ulogd_filter_PRINTPKT.so"
 plugin="@libdir@/ulogd/ulogd_filter_PRINTFLOW.so"
 plugin="@libdir@/ulogd/ulogd_output_LOGEMU.so"
 plugin="@libdir@/ulogd/ulogd_output_SYSLOG.so"
-plugin="@libdir@/ulogd/ulogd_output_OPRINT.so"
+#plugin="@libdir@/ulogd/ulogd_output_OPRINT.so"
+#plugin="@libdir@/ulogd/ulogd_output_NACCT.so"
 #plugin="@libdir@/ulogd/ulogd_output_PCAP.so"
 #plugin="@libdir@/ulogd/ulogd_output_PGSQL.so"
 #plugin="@libdir@/ulogd/ulogd_output_MYSQL.so"
@@ -62,7 +63,7 @@ plugin="@libdir@/ulogd/ulogd_raw2packet_BASE.so"
 #stack=ulog1:ULOG,base1:BASE,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU
 
 # this is a stack for flow-based logging via LOGEMU
-#stack=ct1:NFCT,print1:PRINTFLOW,emu1:LOGEMU
+#stack=ct1:NFCT,ip2str1:IP2STR,print1:PRINTFLOW,emu1:LOGEMU
 
 # this is a stack for flow-based logging via OPRINT
 #stack=ct1:NFCT,op1:OPRINT
@@ -85,6 +86,9 @@ plugin="@libdir@/ulogd/ulogd_raw2packet_BASE.so"
 # this is a stack for flow-based logging to MySQL
 #stack=ct1:NFCT,ip2bin1:IP2BIN,mysql2:MYSQL
 
+# this is a stack for flow-based logging in NACCT compatible format
+#stack=ct1:NFCT,ip2str1:IP2STR,nacct1:NACCT
+
 [ct1]
 
 # IPv4 logging through NFLOG
@@ -137,3 +141,6 @@ procedure="INSERT_PACKET_FULL"
 
 [sys2]
 facility=LOG_LOCAL2
+
+[nacct1]
+sync = 1
-- 
1.5.2.5

