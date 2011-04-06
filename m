From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 04/10] libxt_socket: use guided option parser
Date: Wed,  6 Apr 2011 13:31:11 +0200
Message-ID: <1302089478-15022-5-git-send-email-jengelh@medozas.de>
References: <1302089478-15022-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46490 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755592Ab1DFLbZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:31:25 -0400
In-Reply-To: <1302089478-15022-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_socket.c |   29 +++++++++++++++--------------
 1 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/extensions/libxt_socket.c b/extensions/libxt_socket.c
index e89d1c5..3901649 100644
--- a/extensions/libxt_socket.c
+++ b/extensions/libxt_socket.c
@@ -3,15 +3,17 @@
  *
  * Copyright (C) 2007 BalaBit IT Ltd.
  */
-#include <getopt.h>
-#include <stdbool.h>
 #include <stdio.h>
 #include <xtables.h>
 #include <linux/netfilter/xt_socket.h>
 
-static const struct option socket_mt_opts[] = {
-	{.name = "transparent", .has_arg = false, .val = 't'},
-	XT_GETOPT_TABLEEND,
+enum {
+	O_TRANSPARENT = 0,
+};
+
+static const struct xt_option_entry socket_mt_opts[] = {
+	{.name = "transparent", .id = O_TRANSPARENT, .type = XTTYPE_NONE},
+	XTOPT_TABLEEND,
 };
 
 static void socket_mt_help(void)
@@ -21,17 +23,16 @@ static void socket_mt_help(void)
 		"  --transparent    Ignore non-transparent sockets\n\n");
 }
 
-static int socket_mt_parse(int c, char **argv, int invert, unsigned int *flags,
-			   const void *entry, struct xt_entry_match **match)
+static void socket_mt_parse(struct xt_option_call *cb)
 {
-	struct xt_socket_mtinfo1 *info = (void *)(*match)->data;
+	struct xt_socket_mtinfo1 *info = cb->data;
 
-	switch (c) {
-	case 't':
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_TRANSPARENT:
 		info->flags |= XT_SOCKET_TRANSPARENT;
-		return true;
+		break;
 	}
-	return false;
 }
 
 static void
@@ -68,10 +69,10 @@ static struct xtables_match socket_mt_reg[] = {
 		.size          = XT_ALIGN(sizeof(struct xt_socket_mtinfo1)),
 		.userspacesize = XT_ALIGN(sizeof(struct xt_socket_mtinfo1)),
 		.help          = socket_mt_help,
-		.parse         = socket_mt_parse,
 		.print         = socket_mt_print,
 		.save          = socket_mt_save,
-		.extra_opts    = socket_mt_opts,
+		.x6_parse      = socket_mt_parse,
+		.x6_options    = socket_mt_opts,
 	},
 };
 
-- 
1.7.1

