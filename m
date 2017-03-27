From: Gargi Sharma <gs051095@gmail.com>
Subject: [PATCH 1/4] extensions: libebt_limit: Constify option struct
Date: Tue, 28 Mar 2017 00:15:27 +0530
Message-ID: <e4b9436c807b5f0a2fd37937ee29c7ab481b5686.1490640256.git.gs051095@gmail.com>
References: <cover.1490640256.git.gs051095@gmail.com>
Cc: pablo@netfilter.orgm, outreachy-kernel@googlegroups.com,
        Gargi Sharma <gs051095@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:32771 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752110AbdC0SqR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Mar 2017 14:46:17 -0400
Received: by mail-pg0-f65.google.com with SMTP id 79so15078183pgf.0
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Mar 2017 11:46:11 -0700 (PDT)
In-Reply-To: <cover.1490640256.git.gs051095@gmail.com>
In-Reply-To: <cover.1490640256.git.gs051095@gmail.com>
References: <cover.1490640256.git.gs051095@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The struct brlimit_opts of the type option is only used to
initialise a field inside the xtables_match struct and is
not modified anywhere.

Signed-off-by: Gargi Sharma <gs051095@gmail.com>
---
 extensions/libebt_limit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libebt_limit.c b/extensions/libebt_limit.c
index 6b9bb16..988f678 100644
--- a/extensions/libebt_limit.c
+++ b/extensions/libebt_limit.c
@@ -29,7 +29,7 @@
 #define ARG_LIMIT		'1'
 #define ARG_LIMIT_BURST		'2'
 
-static struct option brlimit_opts[] =
+static const struct option brlimit_opts[] =
 {
 	{ .name = "limit",	.has_arg = true,	.val = ARG_LIMIT },
 	{ .name = "limit-burst",.has_arg = true,	.val = ARG_LIMIT_BURST },
-- 
2.7.4

