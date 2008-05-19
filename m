From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 9/9] Update config file to be in sync with latest modifications.
Date: Tue, 20 May 2008 00:31:35 +0200
Message-ID: <1211236295-30207-10-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:38778 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757293AbYESWai (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 May 2008 18:30:38 -0400
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds some examples to the configuration file.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 ulogd.conf.in |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/ulogd.conf.in b/ulogd.conf.in
index be5e585..ca1334b 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -83,6 +83,13 @@ plugin="@libdir@/ulogd/ulogd_raw2packet_BASE.so"
 # this is a stack for flow-based logging to MySQL
 #stack=ct1:NFCT,ip2bin1:IP2BIN,mysql2:MYSQL
 
+# this is a stack for flow-based logging to PGSQL
+#stack=ct1:NFCT,ip2str1:IP2STR,pgsql2:PGSQL
+
+# this is a stack for flow-based logging to PGSQL without local hash
+#stack=ct1:NFCT,ip2str1:IP2STR,pgsql3:PGSQL
+
+
 # this is a stack for flow-based logging in NACCT compatible format
 #stack=ct1:NFCT,ip2str1:IP2STR,nacct1:NACCT
 
@@ -90,6 +97,11 @@ plugin="@libdir@/ulogd/ulogd_raw2packet_BASE.so"
 #netlink_socket_buffer_size=217088
 #netlink_socket_buffer_maxsize=1085440
 
+[ct2]
+#netlink_socket_buffer_size=217088
+#netlink_socket_buffer_maxsize=1085440
+hash_enable=0
+
 # IPv4 logging through NFLOG
 [log1]
 # netlink multicast group (the same as the iptables --nflog-group param)
@@ -132,6 +144,14 @@ table="ulog"
 pass="changeme"
 procedure="INSERT_PACKET_FULL"
 
+[mysql2]
+db="nulog"
+host="localhost"
+user="nupik"
+table="ulog"
+pass="changeme"
+procedure="INSERT_CT"
+
 [pgsql1]
 db="nulog"
 host="localhost"
@@ -140,6 +160,22 @@ table="ulog"
 pass="changeme"
 procedure="INSERT_PACKET_FULL"
 
+[pgsql2]
+db="nulog"
+host="localhost"
+user="nupik"
+table="ulog2_ct"
+pass="changeme"
+procedure="INSERT_CT"
+
+[pgsql3]
+db="nulog"
+host="localhost"
+user="nupik"
+table="ulog2_ct"
+pass="changeme"
+procedure="INSERT_OR_REPLACE_CT"
+
 [sys2]
 facility=LOG_LOCAL2
 
-- 
1.5.4.3

