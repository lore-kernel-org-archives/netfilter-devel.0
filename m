From: Gargi Sharma <gs051095@gmail.com>
Subject: [PATCH 2/4] extenstions: libebt_mark_m: Constify option struct
Date: Tue, 28 Mar 2017 00:15:28 +0530
Message-ID: <9d799f7a47c06313121af2ceaa88130e781cbdb7.1490640256.git.gs051095@gmail.com>
References: <cover.1490640256.git.gs051095@gmail.com>
Cc: pablo@netfilter.orgm, outreachy-kernel@googlegroups.com,
        Gargi Sharma <gs051095@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:32888 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752149AbdC0Sqa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Mar 2017 14:46:30 -0400
Received: by mail-pg0-f68.google.com with SMTP id 79so15079111pgf.0
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Mar 2017 11:46:15 -0700 (PDT)
In-Reply-To: <cover.1490640256.git.gs051095@gmail.com>
In-Reply-To: <cover.1490640256.git.gs051095@gmail.com>
References: <cover.1490640256.git.gs051095@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The struct brmark_m_opts of the type option is only
used to initialise extra_opts field inside the xtables_match
struct and is not modified anywhere.

Signed-off-by: Gargi Sharma <gs051095@gmail.com>
---
 extensions/libebt_mark_m.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libebt_mark_m.c b/extensions/libebt_mark_m.c
index ab9d234..eb08dba 100644
--- a/extensions/libebt_mark_m.c
+++ b/extensions/libebt_mark_m.c
@@ -18,7 +18,7 @@
 
 #define MARK '1'
 
-static struct option brmark_m_opts[] = {
+static const struct option brmark_m_opts[] = {
 	{ .name = "mark",	.has_arg = true, .val = MARK },
 	XT_GETOPT_TABLEEND,
 };
-- 
2.7.4

