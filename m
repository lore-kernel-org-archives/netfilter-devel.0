From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH] Add RAWMAC plugin information to configuration file.
Date: Wed, 23 Jul 2008 23:36:44 +0200
Message-ID: <1216849004-13777-1-git-send-email-eric@inl.fr>
References: <20080723213110.GG31572@bayen.regit.org>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:33906 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754858AbYGWVgq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jul 2008 17:36:46 -0400
In-Reply-To: <20080723213110.GG31572@bayen.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch modifies the stacks to use the RAWMAC plugin where it is necessary.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 ulogd.conf.in |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/ulogd.conf.in b/ulogd.conf.in
index a32234d..dc9cdf2 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -39,6 +39,7 @@ plugin="@libdir@/ulogd/ulogd_filter_IFINDEX.so"
 plugin="@libdir@/ulogd/ulogd_filter_IP2STR.so"
 plugin="@libdir@/ulogd/ulogd_filter_IP2BIN.so"
 plugin="@libdir@/ulogd/ulogd_filter_PRINTPKT.so"
+plugin="@libdir@/ulogd/ulogd_filter_RAWMAC.so"
 plugin="@libdir@/ulogd/ulogd_filter_MAC2STR.so"
 plugin="@libdir@/ulogd/ulogd_filter_PRINTFLOW.so"
 #plugin="@libdir@/ulogd/ulogd_filter_MARK.so"
@@ -76,10 +77,10 @@ plugin="@libdir@/ulogd/ulogd_raw2packet_BASE.so"
 #stack=log1:NFLOG,base1:BASE,pcap1:PCAP
 
 # this is a stack for logging packet to MySQL
-#stack=log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2bin1:IP2BIN,mac2str1:MAC2STR,mysql1:MYSQL
+#stack=log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2bin1:IP2BIN,rawmac1:RAWMAC,mac2str1:MAC2STR,mysql1:MYSQL
 
 # this is a stack for logging IPv6 packet to PGsql after a collect via NFLOG
-#stack=log2:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,mac2str1:MAC2STR,pgsql1:PGSQL
+#stack=log2:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,rawmac1:RAWMAC,mac2str1:MAC2STR,pgsql1:PGSQL
 
 # this is a stack for logging ebtables packets to syslog after a collect via NFLOG
 #stack=log3:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,sys1:SYSLOG
-- 
1.5.4.3

