From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 04/18] Document group 0 usage and suppress address_family
Date: Mon,  1 Dec 2008 22:36:02 +0100
Message-ID: <1228167376-22101-5-git-send-email-eric@inl.fr>
References: <1228167376-22101-1-git-send-email-eric@inl.fr>
Cc: pablo@netfilter.org, Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:39296 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751784AbYLAVgU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2008 16:36:20 -0500
In-Reply-To: <1228167376-22101-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Document the fact that group 0 is used by system logging and
update stack and plugin definition to match the suppression
of the address_family variable.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 ulogd.conf.in |   37 ++++++++++++++++++++-----------------
 1 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/ulogd.conf.in b/ulogd.conf.in
index e24e6b6..a48af3f 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -45,20 +45,17 @@ plugin="@libdir@/ulogd/ulogd_output_SYSLOG.so"
 #plugin="@libdir@/ulogd/ulogd_output_DBI.so"
 plugin="@libdir@/ulogd/ulogd_raw2packet_BASE.so"
 
-# this is a stack for IPv4 packet-based logging via LOGEMU
+# this is a stack for logging packet send by system via LOGEMU
 #stack=log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU
 
-# this is a stack for IPv6 packet-based logging via LOGEMU
+# this is a stack for packet-based logging via LOGEMU
 #stack=log2:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU
 
-# this is a stack for ebtables packet-based logging via LOGEMU
-#stack=log3:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU
-
 # this is a stack for ULOG packet-based logging via LOGEMU
 #stack=ulog1:ULOG,base1:BASE,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU
 
-# this is a stack for IPv4 packet-based logging via LOGEMU with filtering on MARK
-#stack=log1:NFLOG,mark1:MARK,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU
+# this is a stack for packet-based logging via LOGEMU with filtering on MARK
+#stack=log2:NFLOG,mark1:MARK,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU
 
 # this is a stack for flow-based logging via LOGEMU
 #stack=ct1:NFCT,ip2str1:IP2STR,print1:PRINTFLOW,emu1:LOGEMU
@@ -67,15 +64,15 @@ plugin="@libdir@/ulogd/ulogd_raw2packet_BASE.so"
 #stack=ct1:NFCT,op1:OPRINT
 
 # this is a stack for NFLOG packet-based logging to PCAP
-#stack=log1:NFLOG,base1:BASE,pcap1:PCAP
+#stack=log2:NFLOG,base1:BASE,pcap1:PCAP
 
 # this is a stack for logging packet to MySQL
-#stack=log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2bin1:IP2BIN,mac2str1:MAC2STR,mysql1:MYSQL
+#stack=log2:NFLOG,base1:BASE,ifi1:IFINDEX,ip2bin1:IP2BIN,mac2str1:MAC2STR,mysql1:MYSQL
 
-# this is a stack for logging IPv6 packet to PGsql after a collect via NFLOG
+# this is a stack for logging packet to PGsql after a collect via NFLOG
 #stack=log2:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,mac2str1:MAC2STR,pgsql1:PGSQL
 
-# this is a stack for logging ebtables packets to syslog after a collect via NFLOG
+# this is a stack for logging packets to syslog after a collect via NFLOG
 #stack=log3:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,sys1:SYSLOG
 
 # this is a stack for flow-based logging to MySQL
@@ -100,23 +97,29 @@ plugin="@libdir@/ulogd/ulogd_raw2packet_BASE.so"
 #netlink_socket_buffer_maxsize=1085440
 hash_enable=0
 
-# IPv4 logging through NFLOG
+# Logging of system packet through NFLOG
 [log1]
 # netlink multicast group (the same as the iptables --nflog-group param)
+# Group O is used by the kernel to log connection tracking invalid message
 group=0
 #netlink_socket_buffer_size=217088
 #netlink_socket_buffer_maxsize=1085440
 
-# IPv6 logging through NFLOG
+# packet logging through NFLOG for group 1
 [log2]
+# netlink multicast group (the same as the iptables --nflog-group param)
 group=1 # Group has to be different from the one use in log1
-addressfamily=10 # 10 is value of AF_INET6
-numeric_label=1 # you can label the log info based on the packet verdict
+#netlink_socket_buffer_size=217088
+#netlink_socket_buffer_maxsize=1085440
 
-# ebtables logging through NFLOG
+# packet logging through NFLOG for group 2, numeric_label is
+# set to 1
 [log3]
+# netlink multicast group (the same as the iptables --nflog-group param)
 group=2 # Group has to be different from the one use in log1/log2
-addressfamily=7 # 7 is value of AF_BRIDGE
+numeric_label=1 # you can label the log info based on the packet verdict
+#netlink_socket_buffer_size=217088
+#netlink_socket_buffer_maxsize=1085440
 
 [ulog1]
 # netlink multicast group (the same as the iptables --ulog-nlgroup param)
-- 
1.5.6.3

