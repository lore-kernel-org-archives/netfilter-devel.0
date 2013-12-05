From: Shawn Landden <shawn@churchofgit.com>
Subject: [PATCH] netlink: do not SIGSEGV when socket() fails
Date: Wed,  4 Dec 2013 19:18:53 -0800
Message-ID: <1386213533-2149-1-git-send-email-shawn@churchofgit.com>
References: <20131204203030.GE2767@breakpoint.cc>
Cc: Shawn Landden <shawn@churchofgit.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from frostfang.bitronictech.net ([198.20.106.155]:35860 "EHLO
	www.churchofgit.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754023Ab3LEDTu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Dec 2013 22:19:50 -0500
In-Reply-To: <20131204203030.GE2767@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Program received signal SIGSEGV, Segmentation fault.
mnl_socket_close (nl=0x0) at socket.c:248
248        int ret = close(nl->fd);
(gdb) bt
 #0  mnl_socket_close (nl=0x0) at socket.c:248
 #1  0x0000000000410f79 in netlink_close_sock () at src/netlink.c:45
 #2  0x00007ffff7de9fcf in _dl_fini () at dl-fini.c:253
 #3  0x00007ffff717fa91 in __run_exit_handlers (status=2, listp=0x7ffff74ec5c8
<__exit_funcs>,
    run_list_atexit=run_list_atexit@entry=true) at exit.c:77
 #4  0x00007ffff717fb15 in __GI_exit (status=<optimized out>) at exit.c:99
 #5  0x0000000000419b60 in memory_allocation_error () at src/utils.c:24
 #6  0x0000000000410f3a in netlink_open_sock () at src/netlink.c:37
 #7  0x00000000004291cd in __libc_csu_init ()
 #8  0x00007ffff7167925 in __libc_start_main (main=0x405219 <main>, argc=1,
    ubp_av=0x7fffffffe738, init=0x429170 <__libc_csu_init>, fini=<optimized
out>,
    rtld_fini=<optimized out>, stack_end=0x7fffffffe728) at libc-start.c:235
 #9  0x0000000000404d49 in _start ()

The include of <nftables.h> is wierd so I can't use NFT_EXIT_NOMEM in this file.

Signed-off-by: Shawn Landden <shawn@churchofgit.com>
---
 src/netlink.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 533634a..5240633 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -33,8 +33,11 @@ static struct mnl_socket *nf_sock;
 static void __init netlink_open_sock(void)
 {
 	nf_sock = mnl_socket_open(NETLINK_NETFILTER);
-	if (nf_sock == NULL)
+	if (nf_sock == NULL) {
+		dprintf(STDERR_FILENO,
+			"Could not open AF_NETLINK socket: %m\n");
 		memory_allocation_error();
+	}
 
 	fcntl(mnl_socket_get_fd(nf_sock), F_SETFL, O_NONBLOCK);
 	mnl_batch_init();
@@ -42,7 +45,8 @@ static void __init netlink_open_sock(void)
 
 static void __exit netlink_close_sock(void)
 {
-	mnl_socket_close(nf_sock);
+	if (nf_sock)
+		mnl_socket_close(nf_sock);
 }
 
 int netlink_io_error(struct netlink_ctx *ctx, const struct location *loc,
-- 
1.8.5.1

