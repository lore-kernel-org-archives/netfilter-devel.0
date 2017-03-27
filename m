From: Gargi Sharma <gs051095@gmail.com>
Subject: [PATCH 3/4] extensions: libebt_mark: Constify option struct
Date: Tue, 28 Mar 2017 00:15:29 +0530
Message-ID: <a95fb3da52de09e103736a49b838b78f091a3460.1490640256.git.gs051095@gmail.com>
References: <cover.1490640256.git.gs051095@gmail.com>
Cc: pablo@netfilter.orgm, outreachy-kernel@googlegroups.com,
        Gargi Sharma <gs051095@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33031 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752206AbdC0Sqn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Mar 2017 14:46:43 -0400
Received: by mail-pg0-f66.google.com with SMTP id 79so15079991pgf.0
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Mar 2017 11:46:37 -0700 (PDT)
In-Reply-To: <cover.1490640256.git.gs051095@gmail.com>
In-Reply-To: <cover.1490640256.git.gs051095@gmail.com>
References: <cover.1490640256.git.gs051095@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The struct brmark_opts of the type option is only
used to initialise the extra_opts field in xtables_target
struct and is no modified anywhere.

Signed-off-by: Gargi Sharma <gs051095@gmail.com>
---
 extensions/libebt_mark.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libebt_mark.c b/extensions/libebt_mark.c
index a1a208c..7b80b22 100644
--- a/extensions/libebt_mark.c
+++ b/extensions/libebt_mark.c
@@ -25,7 +25,7 @@ static int mark_supplied;
 #define MARK_ORMARK  '3'
 #define MARK_ANDMARK '4'
 #define MARK_XORMARK '5'
-static struct option brmark_opts[] = {
+static const struct option brmark_opts[] = {
 	{ .name = "mark-target",.has_arg = true,	.val = MARK_TARGET },
 	/* an oldtime messup, we should have always used the scheme
 	 * <extension-name>-<option> */
-- 
2.7.4

