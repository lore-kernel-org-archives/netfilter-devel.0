From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] netlink: include file and line in netlink ABI errors
Date: Mon, 15 Sep 2014 14:10:45 +0200
Message-ID: <20140915121044.28234.72435.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:39698 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752447AbaIOMKy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Sep 2014 08:10:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's give some more information when netlink ABI errors happens.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/netlink.h |    4 +++-
 src/netlink.c     |    5 +++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index f611452..2df3742 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -139,7 +139,9 @@ extern void netlink_dump_set(struct nft_set *nls);
 extern int netlink_batch_send(struct list_head *err_list);
 
 extern void netlink_restart(void);
-extern void netlink_abi_error(void) __noreturn;
+#define netlink_abi_error()	\
+	__netlink_abi_error(__FILE__, __LINE__, strerror(errno));
+extern void __noreturn __netlink_abi_error(const char *file, int line, const char *reason);
 extern int netlink_io_error(struct netlink_ctx *ctx,
 			    const struct location *loc, const char *fmt, ...);
 extern void netlink_open_error(void) __noreturn;
diff --git a/src/netlink.c b/src/netlink.c
index 7d42ad6..1ce74e7 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -80,10 +80,11 @@ static void netlink_open_mon_sock(void)
 	nf_mon_sock = nfsock_open();
 }
 
-void __noreturn netlink_abi_error(void)
+void __noreturn __netlink_abi_error(const char *file, int line,
+				    const char *reason)
 {
 	fprintf(stderr, "E: Contact urgently your Linux kernel vendor. "
-		"Netlink ABI is broken: %s\n", strerror(errno));
+		"Netlink ABI is broken: %s:%d %s\n", file, line, reason);
 	exit(NFT_EXIT_FAILURE);
 }
 

