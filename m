From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/5] socket: add support for revision 1
Date: Fri,  3 Dec 2010 22:58:43 +0100
Message-ID: <1291413524-15016-6-git-send-email-jengelh@medozas.de>
References: <1291413524-15016-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44597 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916Ab0LCV6v (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Dec 2010 16:58:51 -0500
In-Reply-To: <1291413524-15016-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_socket.c   |   76 +++++++++++++++++++++++++++++++++++++++----
 extensions/libxt_socket.man |    3 ++
 2 files changed, 72 insertions(+), 7 deletions(-)

diff --git a/extensions/libxt_socket.c b/extensions/libxt_socket.c
index 1490473..e4dff78 100644
--- a/extensions/libxt_socket.c
+++ b/extensions/libxt_socket.c
@@ -3,17 +3,79 @@
  *
  * Copyright (C) 2007 BalaBit IT Ltd.
  */
+#include <getopt.h>
+#include <stdbool.h>
+#include <stdio.h>
 #include <xtables.h>
+#include <linux/netfilter/xt_socket.h>
 
-static struct xtables_match socket_mt_reg = {
-	.name	       = "socket",
-	.version       = XTABLES_VERSION,
-	.family	       = NFPROTO_IPV4,
-	.size	       = XT_ALIGN(0),
-	.userspacesize = XT_ALIGN(0),
+static const struct option socket_mt_opts[] = {
+	{.name = "transparent", .has_arg = false, .val = 't'},
+	XT_GETOPT_TABLEEND,
+};
+
+static void socket_mt_help(void)
+{
+	printf(
+		"socket match options:\n"
+		"  --transparent    Ignore non-transparent sockets\n\n");
+}
+
+static int socket_mt_parse(int c, char **argv, int invert, unsigned int *flags,
+			   const void *entry, struct xt_entry_match **match)
+{
+	struct xt_socket_mtinfo1 *info = (void *)(*match)->data;
+
+	switch (c) {
+	case 't':
+		info->flags |= XT_SOCKET_TRANSPARENT;
+		return true;
+	}
+	return false;
+}
+
+static void
+socket_mt_save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_socket_mtinfo1 *info = (const void *)match->data;
+
+	if (info->flags & XT_SOCKET_TRANSPARENT)
+		printf("--transparent ");
+}
+
+static void
+socket_mt_print(const void *ip, const struct xt_entry_match *match,
+		int numeric)
+{
+	printf("socket ");
+	socket_mt_save(ip, match);
+}
+
+static struct xtables_match socket_mt_reg[] = {
+	{
+		.name          = "socket",
+		.revision      = 0,
+		.family        = NFPROTO_IPV4,
+		.version       = XTABLES_VERSION,
+		.size          = XT_ALIGN(0),
+		.userspacesize = XT_ALIGN(0),
+	},
+	{
+		.name          = "socket",
+		.revision      = 1,
+		.family        = NFPROTO_UNSPEC,
+		.version       = XTABLES_VERSION,
+		.size          = XT_ALIGN(sizeof(struct xt_socket_mtinfo1)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_socket_mtinfo1)),
+		.help          = socket_mt_help,
+		.parse         = socket_mt_parse,
+		.print         = socket_mt_print,
+		.save          = socket_mt_save,
+		.extra_opts    = socket_mt_opts,
+	},
 };
 
 void _init(void)
 {
-	xtables_register_match(&socket_mt_reg);
+	xtables_register_matches(socket_mt_reg, ARRAY_SIZE(socket_mt_reg));
 }
diff --git a/extensions/libxt_socket.man b/extensions/libxt_socket.man
index 50c8854..41e8d67 100644
--- a/extensions/libxt_socket.man
+++ b/extensions/libxt_socket.man
@@ -1,2 +1,5 @@
 This matches if an open socket can be found by doing a socket lookup on the
 packet.
+.TP
+\fB\-\-transparent\fP
+Ignore non-transparent sockets.
-- 
1.7.1

