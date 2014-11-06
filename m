From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 4/5] include: add cli.h
Date: Thu,  6 Nov 2014 19:25:48 +0100
Message-ID: <1415298349-985-5-git-send-email-pablo@netfilter.org>
References: <1415298349-985-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38977 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbaKFSYJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:24:09 -0500
In-Reply-To: <1415298349-985-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Needed by follow up patches to use autotools.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/cli.h      |   18 ++++++++++++++++++
 include/nftables.h |   14 ++------------
 src/cli.c          |    1 +
 src/main.c         |    1 +
 4 files changed, 22 insertions(+), 12 deletions(-)
 create mode 100644 include/cli.h

diff --git a/include/cli.h b/include/cli.h
new file mode 100644
index 0000000..89cb976
--- /dev/null
+++ b/include/cli.h
@@ -0,0 +1,18 @@
+#ifndef _NFT_CLI_H_
+#define _NFT_CLI_H_
+
+#include <config.h>
+
+struct parser_state;
+#ifdef HAVE_LIBREADLINE
+extern int cli_init(struct parser_state *state);
+#else
+static inline int cli_init(struct parser_state *state)
+{
+        return -1;
+}
+#endif
+extern void cli_exit(void);
+extern void cli_display(const char *fmt, va_list ap) __fmtstring(1, 0);
+
+#endif
diff --git a/include/nftables.h b/include/nftables.h
index 4c33ec6..cf19de8 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -31,18 +31,6 @@ extern unsigned int handle_output;
 extern unsigned int debug_level;
 extern const char *include_paths[INCLUDE_PATHS_MAX];
 
-struct parser_state;
-#ifdef HAVE_LIBREADLINE
-extern int cli_init(struct parser_state *state);
-#else
-static inline int cli_init(struct parser_state *state)
-{
-	return -1;
-}
-#endif
-extern void cli_exit(void);
-extern void cli_display(const char *fmt, va_list ap) __fmtstring(1, 0);
-
 enum nftables_exit_codes {
 	NFT_EXIT_SUCCESS	= 0,
 	NFT_EXIT_FAILURE	= 1,
@@ -116,6 +104,8 @@ struct input_descriptor {
 	off_t				line_offset;
 };
 
+struct parser_state;
+
 int nft_run(void *scanner, struct parser_state *state, struct list_head *msgs);
 
 #endif /* NFTABLES_NFTABLES_H */
diff --git a/src/cli.c b/src/cli.c
index f748a0e..6f2847b 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -27,6 +27,7 @@
 #include <parser.h>
 #include <erec.h>
 #include <utils.h>
+#include <cli.h>
 
 #define CMDLINE_HISTFILE	".nft.history"
 
diff --git a/src/main.c b/src/main.c
index 1625914..b447aad 100644
--- a/src/main.c
+++ b/src/main.c
@@ -25,6 +25,7 @@
 #include <netlink.h>
 #include <erec.h>
 #include <mnl.h>
+#include <cli.h>
 
 unsigned int max_errors = 10;
 unsigned int numeric_output;
-- 
1.7.10.4

