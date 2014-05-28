From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] netlink: fix crash if kernel doesn't support nfnetlink / nf_tables
Date: Wed, 28 May 2014 10:31:39 +0200
Message-ID: <1401265899-6685-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60403 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbaE1Ibt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 May 2014 04:31:49 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When trying to close a descriptor which failed to be opened.

==6231== Process terminating with default action of signal 11 (SIGSEGV)
==6231==  Access not within mapped region at address 0x0
==6231==    at 0x5503E21: mnl_socket_close (socket.c:248)
==6231==    by 0x40517F: netlink_close_sock (netlink.c:68)
==6231==    by 0x400EFEE: _dl_fini (dl-fini.c:253)
==6231==    by 0x5740AA0: __run_exit_handlers (exit.c:77)
==6231==    by 0x5740B24: exit (exit.c:99)
==6231==    by 0x40F16F: netlink_open_error (netlink.c:105)
==6231==    by 0x405642: netlink_open_sock (netlink.c:54)
==6231==    by 0x424E6C: __libc_csu_init (in /usr/sbin/nft)
==6231==    by 0x5728924: (below main) (libc-start.c:219)
==6231==  If you believe this happened as a result of a stack
==6231==  overflow in your program's main thread (unlikely but
==6231==  possible), you can try to increase the size of the
==6231==  main thread stack using the --main-stacksize= flag.
==6231==  The main thread stack size used in this run was 8388608.

Closes: http://bugzilla.netfilter.org/show_bug.cgi?id=881

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/netlink.c b/src/netlink.c
index db42884..edefc76 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -64,7 +64,8 @@ static void __init netlink_open_sock(void)
 
 static void __exit netlink_close_sock(void)
 {
-	mnl_socket_close(nf_sock);
+	if (nf_sock)
+		mnl_socket_close(nf_sock);
 	if (nf_mon_sock)
 		mnl_socket_close(nf_mon_sock);
 }
-- 
1.7.10.4

