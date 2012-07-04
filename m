From: Eldad Zack <eldad@fogrefinery.com>
Subject: [PATCH] libxt_recent: remove unused variable
Date: Wed,  4 Jul 2012 23:53:54 +0200
Message-ID: <1341438834-24509-1-git-send-email-eldad@fogrefinery.com>
Cc: Eldad Zack <eldad@fogrefinery.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36779 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab2GDVyF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Jul 2012 17:54:05 -0400
Received: by bkwj10 with SMTP id j10so2938829bkw.19
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Jul 2012 14:54:03 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The info variable is assigned but never read in recent_check().

Signed-off-by: Eldad Zack <eldad@fogrefinery.com>
---
 extensions/libxt_recent.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/extensions/libxt_recent.c b/extensions/libxt_recent.c
index c7dce4e..3dcb41d 100644
--- a/extensions/libxt_recent.c
+++ b/extensions/libxt_recent.c
@@ -131,8 +131,6 @@ static void recent_parse(struct xt_option_call *cb)
 
 static void recent_check(struct xt_fcheck_call *cb)
 {
-	struct xt_recent_mtinfo *info = cb->data;
-
 	if (!(cb->xflags & F_ANY_OP))
 		xtables_error(PARAMETER_PROBLEM,
 			"recent: you must specify one of `--set', `--rcheck' "
-- 
1.7.10

