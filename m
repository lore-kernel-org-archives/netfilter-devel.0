From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 5/5] Update configfile for MARK module.
Date: Fri,  6 Jun 2008 15:13:55 +0200
Message-ID: <1212758035-19538-6-git-send-email-eric@inl.fr>
References: <>
 <1212758035-19538-1-git-send-email-eric@inl.fr>
 <1212758035-19538-2-git-send-email-eric@inl.fr>
 <1212758035-19538-3-git-send-email-eric@inl.fr>
 <1212758035-19538-4-git-send-email-eric@inl.fr>
 <1212758035-19538-5-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:43253 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750776AbYFFNMD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 09:12:03 -0400
In-Reply-To: <1212758035-19538-5-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add stack example for MARK and update some wrong stacks.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 ulogd.conf.in |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/ulogd.conf.in b/ulogd.conf.in
index ca1334b..a32234d 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -41,6 +41,7 @@ plugin="@libdir@/ulogd/ulogd_filter_IP2BIN.so"
 plugin="@libdir@/ulogd/ulogd_filter_PRINTPKT.so"
 plugin="@libdir@/ulogd/ulogd_filter_MAC2STR.so"
 plugin="@libdir@/ulogd/ulogd_filter_PRINTFLOW.so"
+#plugin="@libdir@/ulogd/ulogd_filter_MARK.so"
 plugin="@libdir@/ulogd/ulogd_output_LOGEMU.so"
 plugin="@libdir@/ulogd/ulogd_output_SYSLOG.so"
 #plugin="@libdir@/ulogd/ulogd_output_OPRINT.so"
@@ -62,6 +63,9 @@ plugin="@libdir@/ulogd/ulogd_raw2packet_BASE.so"
 # this is a stack for ULOG packet-based logging via LOGEMU
 #stack=ulog1:ULOG,base1:BASE,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU
 
+# this is a stack for IPv4 packet-based logging via LOGEMU with filtering on MARK
+#stack=log1:NFLOG,mark1:MARK,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU
+
 # this is a stack for flow-based logging via LOGEMU
 #stack=ct1:NFCT,ip2str1:IP2STR,print1:PRINTFLOW,emu1:LOGEMU
 
@@ -72,7 +76,7 @@ plugin="@libdir@/ulogd/ulogd_raw2packet_BASE.so"
 #stack=log1:NFLOG,base1:BASE,pcap1:PCAP
 
 # this is a stack for logging packet to MySQL
-#stack=log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2bin1:IP2BIN,mysql1:MYSQL
+#stack=log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2bin1:IP2BIN,mac2str1:MAC2STR,mysql1:MYSQL
 
 # this is a stack for logging IPv6 packet to PGsql after a collect via NFLOG
 #stack=log2:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,mac2str1:MAC2STR,pgsql1:PGSQL
@@ -181,3 +185,6 @@ facility=LOG_LOCAL2
 
 [nacct1]
 sync = 1
+
+[mark1]
+mark = 1
-- 
1.5.4.3

