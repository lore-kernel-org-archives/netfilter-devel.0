From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 13/14] Update default configuration to fit last changes
Date: Sun, 23 Mar 2008 17:25:21 +0100
Message-ID: <12062895231992-git-send-email-eric@inl.fr>
References: <1206289522679-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:55066 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753211AbYCWQZ1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Mar 2008 12:25:27 -0400
In-Reply-To: <1206289522679-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Default stacks needed to be modified to be in sync MAC2STR plugin which
is used by database output modules. The new state configuration variable
has been added to some ULOG and NFLOG instances to show that it exists.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 ulogd.conf.in |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/ulogd.conf.in b/ulogd.conf.in
index ff46146..d18ed5d 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -38,6 +38,7 @@ plugin="@libdir@/ulogd/ulogd_inpflow_NFCT.so"
 plugin="@libdir@/ulogd/ulogd_filter_IFINDEX.so"
 plugin="@libdir@/ulogd/ulogd_filter_IP2STR.so"
 plugin="@libdir@/ulogd/ulogd_filter_IP2BIN.so"
+plugin="@libdir@/ulogd/ulogd_filter_MAC2STR.so"
 plugin="@libdir@/ulogd/ulogd_filter_PRINTPKT.so"
 plugin="@libdir@/ulogd/ulogd_filter_PRINTFLOW.so"
 plugin="@libdir@/ulogd/ulogd_output_LOGEMU.so"
@@ -70,10 +71,13 @@ plugin="@libdir@/ulogd/ulogd_raw2packet_BASE.so"
 #stack=log1:NFLOG,base1:BASE,pcap1:PCAP
 
 # this is a stack for logging packet to MySQL
-#stack=log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2bin1:IP2BIN,mysql1:MYSQL
+#stack=log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2bin1:IP2BIN,mac2str1:MAC2STR,mysql1:MYSQL
+
+# this is a stack for logging packet to PGsql via ULOG
+#stack=ulog1:ULOG,base1:BASE,ip2str1:IP2STR,mac2str1:MAC2STR,pgsql1:PGSQL
 
 # this is a stack for logging IPv6 packet to PGsql after a collect via NFLOG
-#stack=log2:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,pgsql1:PGSQL
+#stack=log2:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,mac2str1:MAC2STR,pgsql1:PGSQL
 
 # this is a stack for logging ebtables packets to syslog after a collect via NFLOG
 #stack=log3:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,sys1:SYSLOG
@@ -92,6 +96,7 @@ group=0
 [log2]
 group=1 # Group has to be different from the one use in log1
 addressfamily=10 # 10 is value of AF_INET6
+state=1 # State can be used to define the decision applied to packet
 
 # ebtables logging through NFLOG
 [log3]
@@ -101,6 +106,7 @@ addressfamily=7 # 7 is value of AF_BRIDGE
 [ulog1]
 # netlink multicast group (the same as the iptables --ulog-nlgroup param)
 nlgroup=1
+#state=0 # optionnal argument
 
 [emu1]
 file="/var/log/ulogd_syslogemu.log"
-- 
1.5.2.5

