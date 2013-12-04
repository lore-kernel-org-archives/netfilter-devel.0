From: Shawn Landden <shawn@churchofgit.com>
Subject: [PATCH] netlink: do not SIGSEGV when socket() fails
Date: Wed,  4 Dec 2013 11:12:20 -0800
Message-ID: <1386184340-74134-1-git-send-email-shawn@churchofgit.com>
Cc: Shawn Landden <shawn@churchofgit.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from frostfang.bitronictech.net ([198.20.106.155]:35606 "EHLO
	www.churchofgit.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755958Ab3LDTMn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Dec 2013 14:12:43 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 src/netlink.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 533634a..664487d 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -33,8 +33,11 @@ static struct mnl_socket *nf_sock;
 static void __init netlink_open_sock(void)
 {
 	nf_sock = mnl_socket_open(NETLINK_NETFILTER);
-	if (nf_sock == NULL)
+	if (nf_sock == NULL) {
+                fprintf(fdopen(STDERR_FILENO, "a"), "Could not open AF_NETLINK socket: %s\n",
+                                        strerror(errno));
 		memory_allocation_error();
+        }
 
 	fcntl(mnl_socket_get_fd(nf_sock), F_SETFL, O_NONBLOCK);
 	mnl_batch_init();
@@ -42,7 +45,8 @@ static void __init netlink_open_sock(void)
 
 static void __exit netlink_close_sock(void)
 {
-	mnl_socket_close(nf_sock);
+        if (nf_sock)
+                mnl_socket_close(nf_sock);
 }
 
 int netlink_io_error(struct netlink_ctx *ctx, const struct location *loc,
-- 
1.8.5.1

