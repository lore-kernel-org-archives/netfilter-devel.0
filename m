From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] remove unnessesary 0-initilization of data in bss segment
Date: Tue, 08 Apr 2003 18:09:12 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E92F428.4050707@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050203040205020104060200"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------050203040205020104060200
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch removes a couple of memset(.., 0, ..) of data in the bss
segment.

Bye,
Patrick

--------------050203040205020104060200
Content-Type: text/plain;
 name="nobssinit-pom.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nobssinit-pom.diff"

diff -urN a/pending/30_netfilter-nobssinit.patch b/pending/30_netfilter-nobssinit.patch
--- a/pending/30_netfilter-nobssinit.patch	1970-01-01 01:00:00.000000000 +0100
+++ b/pending/30_netfilter-nobssinit.patch	2003-04-08 16:15:25.000000000 +0200
@@ -0,0 +1,77 @@
+# This is a BitKeeper generated patch for the following project:
+# Project Name: Linux kernel tree
+# This patch format is intended for GNU patch command version 2.5 or higher.
+# This patch includes the following deltas:
+#	           ChangeSet	1.1058  -> 1.1059 
+#	net/ipv4/netfilter/ip_nat_ftp.c	1.6     -> 1.7    
+#	net/ipv4/netfilter/ip_conntrack_irc.c	1.5     -> 1.6    
+#	net/ipv4/netfilter/ipt_ULOG.c	1.6     -> 1.7    
+#	net/ipv4/netfilter/ip_conntrack_ftp.c	1.8     -> 1.9    
+#	net/ipv4/netfilter/ip_nat_irc.c	1.3     -> 1.4    
+#
+# The following is the BitKeeper ChangeSet Log
+# --------------------------------------------
+# 03/03/27	kaber@trash.net	1.1059
+# [NETFILTER]: remove unnessasary initilization to zero of data located in bss segment
+# --------------------------------------------
+#
+diff -Nru a/net/ipv4/netfilter/ip_conntrack_ftp.c b/net/ipv4/netfilter/ip_conntrack_ftp.c
+--- a/net/ipv4/netfilter/ip_conntrack_ftp.c	Thu Mar 27 02:01:47 2003
++++ b/net/ipv4/netfilter/ip_conntrack_ftp.c	Thu Mar 27 02:01:47 2003
+@@ -405,7 +405,6 @@
+ 		ports[0] = FTP_PORT;
+ 
+ 	for (i = 0; (i < MAX_PORTS) && ports[i]; i++) {
+-		memset(&ftp[i], 0, sizeof(struct ip_conntrack_helper));
+ 		ftp[i].tuple.src.u.tcp.port = htons(ports[i]);
+ 		ftp[i].tuple.dst.protonum = IPPROTO_TCP;
+ 		ftp[i].mask.src.u.tcp.port = 0xFFFF;
+diff -Nru a/net/ipv4/netfilter/ip_conntrack_irc.c b/net/ipv4/netfilter/ip_conntrack_irc.c
+--- a/net/ipv4/netfilter/ip_conntrack_irc.c	Thu Mar 27 02:01:47 2003
++++ b/net/ipv4/netfilter/ip_conntrack_irc.c	Thu Mar 27 02:01:47 2003
+@@ -259,8 +259,6 @@
+ 
+ 	for (i = 0; (i < MAX_PORTS) && ports[i]; i++) {
+ 		hlpr = &irc_helpers[i];
+-		memset(hlpr, 0,
+-		       sizeof(struct ip_conntrack_helper));
+ 		hlpr->tuple.src.u.tcp.port = htons(ports[i]);
+ 		hlpr->tuple.dst.protonum = IPPROTO_TCP;
+ 		hlpr->mask.src.u.tcp.port = 0xFFFF;
+diff -Nru a/net/ipv4/netfilter/ip_nat_ftp.c b/net/ipv4/netfilter/ip_nat_ftp.c
+--- a/net/ipv4/netfilter/ip_nat_ftp.c	Thu Mar 27 02:01:47 2003
++++ b/net/ipv4/netfilter/ip_nat_ftp.c	Thu Mar 27 02:01:47 2003
+@@ -306,9 +306,6 @@
+ 		ports[0] = FTP_PORT;
+ 
+ 	for (i = 0; (i < MAX_PORTS) && ports[i]; i++) {
+-
+-		memset(&ftp[i], 0, sizeof(struct ip_nat_helper));
+-
+ 		ftp[i].tuple.dst.protonum = IPPROTO_TCP;
+ 		ftp[i].tuple.src.u.tcp.port = htons(ports[i]);
+ 		ftp[i].mask.dst.protonum = 0xFFFF;
+diff -Nru a/net/ipv4/netfilter/ip_nat_irc.c b/net/ipv4/netfilter/ip_nat_irc.c
+--- a/net/ipv4/netfilter/ip_nat_irc.c	Thu Mar 27 02:01:47 2003
++++ b/net/ipv4/netfilter/ip_nat_irc.c	Thu Mar 27 02:01:47 2003
+@@ -243,9 +243,6 @@
+ 
+ 	for (i = 0; (i < MAX_PORTS) && ports[i] != 0; i++) {
+ 		hlpr = &ip_nat_irc_helpers[i];
+-		memset(hlpr, 0,
+-		       sizeof(struct ip_nat_helper));
+-
+ 		hlpr->tuple.dst.protonum = IPPROTO_TCP;
+ 		hlpr->tuple.src.u.tcp.port = htons(ports[i]);
+ 		hlpr->mask.src.u.tcp.port = 0xFFFF;
+diff -Nru a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
+--- a/net/ipv4/netfilter/ipt_ULOG.c	Thu Mar 27 02:01:47 2003
++++ b/net/ipv4/netfilter/ipt_ULOG.c	Thu Mar 27 02:01:47 2003
+@@ -322,7 +322,6 @@
+ 
+ 	/* initialize ulog_buffers */
+ 	for (i = 0; i < ULOG_MAXNLGROUPS; i++) {
+-		memset(&ulog_buffers[i], 0, sizeof(ulog_buff_t));
+ 		init_timer(&ulog_buffers[i].timer);
+ 		ulog_buffers[i].timer.function = ulog_timer;
+ 		ulog_buffers[i].timer.data = i;
diff -urN a/pending/30_netfilter-nobssinit.patch.help b/pending/30_netfilter-nobssinit.patch.help
--- a/pending/30_netfilter-nobssinit.patch.help	1970-01-01 01:00:00.000000000 +0100
+++ b/pending/30_netfilter-nobssinit.patch.help	2003-04-08 16:16:40.000000000 +0200
@@ -0,0 +1,5 @@
+Author: Patrick McHardy <kaber@trash.net>
+Status: Working
+
+This patch removes a couple of unneeded zero-initializations of data
+located in the bss segment.

--------------050203040205020104060200--
