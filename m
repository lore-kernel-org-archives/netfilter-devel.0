From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/7] xtables: set custom opts to NULL on free
Date: Mon, 31 Jan 2011 03:12:49 +0100
Message-ID: <1296439973-16089-5-git-send-email-jengelh@medozas.de>
References: <1296439973-16089-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:45277 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757Ab1AaCNB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Jan 2011 21:13:01 -0500
In-Reply-To: <1296439973-16089-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When inside ip6tables-restore, xtables_free_opts can be called
multiple times, especially when trying to exit with an error message
from outside do_command. So set it to NULL so that we do not attempt
to free a dangling pointer.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 xtables.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/xtables.c b/xtables.c
index 0036299..be103d7 100644
--- a/xtables.c
+++ b/xtables.c
@@ -75,8 +75,10 @@ void basic_exit_err(enum xtables_exittype status, const char *msg, ...)
 
 void xtables_free_opts(int unused)
 {
-	if (xt_params->opts != xt_params->orig_opts)
+	if (xt_params->opts != xt_params->orig_opts) {
 		free(xt_params->opts);
+		xt_params->opts = NULL;
+	}
 }
 
 struct option *xtables_merge_options(struct option *orig_opts,
-- 
1.7.1

