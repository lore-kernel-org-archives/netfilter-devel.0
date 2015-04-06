From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/2] src: introduce netlink_init_error()
Date: Mon,  6 Apr 2015 14:06:30 +0200
Message-ID: <1428321991-10125-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35265 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896AbbDFMC2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Apr 2015 08:02:28 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Based on the existing netlink_open_error(), but indicate file and line
where the error happens. This will helps us to diagnose what is going
wrong when users can back to us to report problems.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/netlink.h |    4 +++-
 src/netlink.c     |    9 +++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index c1ff9c6..9f24ea5 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -145,7 +145,9 @@ extern void netlink_restart(void);
 extern void __noreturn __netlink_abi_error(const char *file, int line, const char *reason);
 extern int netlink_io_error(struct netlink_ctx *ctx,
 			    const struct location *loc, const char *fmt, ...);
-extern void netlink_open_error(void) __noreturn;
+#define netlink_init_error()	\
+	__netlink_init_error(__FILE__, __LINE__, strerror(errno));
+extern void __noreturn __netlink_init_error(const char *file, int line, const char *reason);
 
 extern int netlink_flush_ruleset(struct netlink_ctx *ctx,
 				 const struct handle *h,
diff --git a/src/netlink.c b/src/netlink.c
index a33bb0b..4155763 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -52,7 +52,7 @@ static struct mnl_socket *nfsock_open(void)
 
 	s = mnl_socket_open(NETLINK_NETFILTER);
 	if (s == NULL)
-		netlink_open_error();
+		netlink_init_error();
 	return s;
 }
 
@@ -110,10 +110,11 @@ int netlink_io_error(struct netlink_ctx *ctx, const struct location *loc,
 	return -1;
 }
 
-void __noreturn netlink_open_error(void)
+void __noreturn __netlink_init_error(const char *filename, int line,
+				     const char *reason)
 {
-	fprintf(stderr, "E: Unable to open Netlink socket: %s\n",
-		strerror(errno));
+	fprintf(stderr, "%s:%d: Unable to initialize Netlink socket: %s\n",
+		filename, line, reason);
 	exit(NFT_EXIT_NONL);
 }
 
-- 
1.7.10.4

