From: Gargi Sharma <gs051095@gmail.com>
Subject: [PATCH 4/4] extensions: libebt_nflog: Constify option struct
Date: Tue, 28 Mar 2017 00:15:30 +0530
Message-ID: <2811ba791e2e24bed3a7eabb354f06b9807404d4.1490640256.git.gs051095@gmail.com>
References: <cover.1490640256.git.gs051095@gmail.com>
Cc: pablo@netfilter.orgm, outreachy-kernel@googlegroups.com,
        Gargi Sharma <gs051095@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33135 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752238AbdC0Sqr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Mar 2017 14:46:47 -0400
Received: by mail-pg0-f67.google.com with SMTP id 79so15080643pgf.0
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Mar 2017 11:46:36 -0700 (PDT)
In-Reply-To: <cover.1490640256.git.gs051095@gmail.com>
In-Reply-To: <cover.1490640256.git.gs051095@gmail.com>
References: <cover.1490640256.git.gs051095@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The struct brnflog_opts of the type options is
used to initialise extra_opts field inside the
xtables_target struct and is not modified anywhere.

Signed-off-by: Gargi Sharma <gs051095@gmail.com>
---
 extensions/libebt_nflog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libebt_nflog.c b/extensions/libebt_nflog.c
index fef7196..5f1d13b 100644
--- a/extensions/libebt_nflog.c
+++ b/extensions/libebt_nflog.c
@@ -30,7 +30,7 @@ enum {
 	NFLOG_NFLOG	= 0x16,
 };
 
-static struct option brnflog_opts[] = {
+static const struct option brnflog_opts[] = {
 	{ .name = "nflog-group",     .has_arg = true,  .val = NFLOG_GROUP},
 	{ .name = "nflog-prefix",    .has_arg = true,  .val = NFLOG_PREFIX},
 	{ .name = "nflog-range",     .has_arg = true,  .val = NFLOG_RANGE},
-- 
2.7.4

