From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] remove unnecessary initialization to 0
Date: Wed, 26 Mar 2003 16:45:10 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E81CB06.90208@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060806040107040802020305"
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
--------------060806040107040802020305
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch removes a couple of unnecessary memset()s for
data which is located in the bss segment.

Regards,
Patrick

--------------060806040107040802020305
Content-Type: text/plain;
 name="netfilter-nobssinit.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="netfilter-nobssinit.diff"

diff -urN a/net/ipv4/netfilter/ip_conntrack_ftp.c b/net/ipv4/netfilter/ip_conntrack_ftp.c
--- a/net/ipv4/netfilter/ip_conntrack_ftp.c	2002-11-29 00:53:15.000000000 +0100
+++ b/net/ipv4/netfilter/ip_conntrack_ftp.c	2003-03-26 16:35:51.000000000 +0100
@@ -405,7 +405,6 @@
 		ports[0] = FTP_PORT;
 
 	for (i = 0; (i < MAX_PORTS) && ports[i]; i++) {
-		memset(&ftp[i], 0, sizeof(struct ip_conntrack_helper));
 		ftp[i].tuple.src.u.tcp.port = htons(ports[i]);
 		ftp[i].tuple.dst.protonum = IPPROTO_TCP;
 		ftp[i].mask.src.u.tcp.port = 0xFFFF;
diff -urN a/net/ipv4/netfilter/ip_conntrack_irc.c b/net/ipv4/netfilter/ip_conntrack_irc.c
--- a/net/ipv4/netfilter/ip_conntrack_irc.c	2002-11-29 00:53:15.000000000 +0100
+++ b/net/ipv4/netfilter/ip_conntrack_irc.c	2003-03-26 16:35:32.000000000 +0100
@@ -259,8 +259,6 @@
 
 	for (i = 0; (i < MAX_PORTS) && ports[i]; i++) {
 		hlpr = &irc_helpers[i];
-		memset(hlpr, 0,
-		       sizeof(struct ip_conntrack_helper));
 		hlpr->tuple.src.u.tcp.port = htons(ports[i]);
 		hlpr->tuple.dst.protonum = IPPROTO_TCP;
 		hlpr->mask.src.u.tcp.port = 0xFFFF;
diff -urN a/net/ipv4/netfilter/ip_nat_ftp.c b/net/ipv4/netfilter/ip_nat_ftp.c
--- a/net/ipv4/netfilter/ip_nat_ftp.c	2002-11-29 00:53:15.000000000 +0100
+++ b/net/ipv4/netfilter/ip_nat_ftp.c	2003-03-26 16:35:41.000000000 +0100
@@ -306,9 +306,6 @@
 		ports[0] = FTP_PORT;
 
 	for (i = 0; (i < MAX_PORTS) && ports[i]; i++) {
-
-		memset(&ftp[i], 0, sizeof(struct ip_nat_helper));
-
 		ftp[i].tuple.dst.protonum = IPPROTO_TCP;
 		ftp[i].tuple.src.u.tcp.port = htons(ports[i]);
 		ftp[i].mask.dst.protonum = 0xFFFF;
diff -urN a/net/ipv4/netfilter/ip_nat_irc.c b/net/ipv4/netfilter/ip_nat_irc.c
--- a/net/ipv4/netfilter/ip_nat_irc.c	2002-11-29 00:53:15.000000000 +0100
+++ b/net/ipv4/netfilter/ip_nat_irc.c	2003-03-26 16:35:21.000000000 +0100
@@ -243,9 +243,6 @@
 
 	for (i = 0; (i < MAX_PORTS) && ports[i] != 0; i++) {
 		hlpr = &ip_nat_irc_helpers[i];
-		memset(hlpr, 0,
-		       sizeof(struct ip_nat_helper));
-
 		hlpr->tuple.dst.protonum = IPPROTO_TCP;
 		hlpr->tuple.src.u.tcp.port = htons(ports[i]);
 		hlpr->mask.src.u.tcp.port = 0xFFFF;
diff -urN a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
--- a/net/ipv4/netfilter/ipt_ULOG.c	2002-11-29 00:53:15.000000000 +0100
+++ b/net/ipv4/netfilter/ipt_ULOG.c	2003-03-26 16:36:11.000000000 +0100
@@ -320,7 +320,6 @@
 
 	/* initialize ulog_buffers */
 	for (i = 0; i < ULOG_MAXNLGROUPS; i++) {
-		memset(&ulog_buffers[i], 0, sizeof(ulog_buff_t));
 		init_timer(&ulog_buffers[i].timer);
 		ulog_buffers[i].timer.function = ulog_timer;
 		ulog_buffers[i].timer.data = i;

--------------060806040107040802020305--
