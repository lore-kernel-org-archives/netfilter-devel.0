From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/3] build: enable -Wshadow compiler flag
Date: Wed, 25 Mar 2009 00:31:08 +0100
Message-ID: <1237937468-31476-4-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34662 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443AbZCXXbM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Mar 2009 19:31:12 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Enable said flag and fix up the warnings (or errors, since we are
using -Werror) that it caused.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |    2 +-
 src/main.c   |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/configure.ac b/configure.ac
index 0227817..4a6a0e6 100644
--- a/configure.ac
+++ b/configure.ac
@@ -96,7 +96,7 @@ regular_CFLAGS="-D_FILE_OFFSET_BITS=64 -D_REENTRANT -Wall -Waggregate-return \
 	-Wbad-function-cast -Wcast-align -Wdeclaration-after-statement \
 	-Werror -Wformat=2 -Winit-self -Winline -Wmissing-declarations \
 	-Wmissing-format-attribute -Wmissing-prototypes \
-	-Wsign-compare -Wstrict-prototypes -Wundef -Wunused \
+	-Wshadow -Wsign-compare -Wstrict-prototypes -Wundef -Wunused \
 	-Wwrite-strings -fno-strict-aliasing -pipe";
 AC_SUBST([regular_CFLAGS])
 
diff --git a/src/main.c b/src/main.c
index 2fa540c..865c19c 100644
--- a/src/main.c
+++ b/src/main.c
@@ -183,14 +183,14 @@ int main(int argc, char * const *argv)
 		goto out;
 
 	{
-		struct netlink_ctx ctx;
+		struct netlink_ctx ctx2;
 		struct cmd *cmd, *next;
 
 		list_for_each_entry_safe(cmd, next, &state.cmds, list) {
-			memset(&ctx, 0, sizeof(ctx));
-			ctx.msgs = &msgs;
-			init_list_head(&ctx.list);
-			if (do_command(&ctx, cmd) < 0)
+			memset(&ctx2, 0, sizeof(ctx2));
+			ctx2.msgs = &msgs;
+			init_list_head(&ctx2.list);
+			if (do_command(&ctx2, cmd) < 0)
 				goto out;
 			list_del(&cmd->list);
 			cmd_free(cmd);
-- 
1.6.2

