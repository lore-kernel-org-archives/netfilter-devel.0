From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 1/3] Add some plugin loading and stack example to configuration file.
Date: Mon, 17 Mar 2008 01:07:01 +0100
Message-ID: <12057124233799-git-send-email-eric@inl.fr>
References: <12057124233723-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:44217 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753183AbYCQAHG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Mar 2008 20:07:06 -0400
In-Reply-To: <12057124233723-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch updates included configuration file example by adding some plugins
loading and stack example.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 ulogd.conf.in |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/ulogd.conf.in b/ulogd.conf.in
index d2c038c..ff46146 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -33,6 +33,7 @@ bufsize=150000
 
 
 plugin="@libdir@/ulogd/ulogd_inppkt_NFLOG.so"
+#plugin="@libdir@/ulogd/ulogd_inppkt_ULOG.so"
 plugin="@libdir@/ulogd/ulogd_inpflow_NFCT.so"
 plugin="@libdir@/ulogd/ulogd_filter_IFINDEX.so"
 plugin="@libdir@/ulogd/ulogd_filter_IP2STR.so"
@@ -40,7 +41,11 @@ plugin="@libdir@/ulogd/ulogd_filter_IP2BIN.so"
 plugin="@libdir@/ulogd/ulogd_filter_PRINTPKT.so"
 plugin="@libdir@/ulogd/ulogd_filter_PRINTFLOW.so"
 plugin="@libdir@/ulogd/ulogd_output_LOGEMU.so"
+plugin="@libdir@/ulogd/ulogd_output_SYSLOG.so"
 plugin="@libdir@/ulogd/ulogd_output_OPRINT.so"
+#plugin="@libdir@/ulogd/ulogd_output_PCAP.so"
+#plugin="@libdir@/ulogd/ulogd_output_PGSQL.so"
+#plugin="@libdir@/ulogd/ulogd_output_MYSQL.so"
 plugin="@libdir@/ulogd/ulogd_raw2packet_BASE.so"
 
 # this is a stack for IPv4 packet-based logging via LOGEMU
@@ -61,6 +66,9 @@ plugin="@libdir@/ulogd/ulogd_raw2packet_BASE.so"
 # this is a stack for flow-based logging via OPRINT
 #stack=ct1:NFCT,op1:OPRINT
 
+# this is a stack for NFLOG packet-based logging to PCAP
+#stack=log1:NFLOG,base1:BASE,pcap1:PCAP
+
 # this is a stack for logging packet to MySQL
 #stack=log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2bin1:IP2BIN,mysql1:MYSQL
 
@@ -102,6 +110,9 @@ sync=1
 file="/var/log/ulogd_oprint.log"
 sync=1
 
+[pcap1]
+sync=1
+
 [mysql1]
 db="nulog"
 host="localhost"
-- 
1.5.4.3

