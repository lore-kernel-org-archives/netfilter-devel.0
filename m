From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 9/9] src: remove faulty deprecated marker in libipt_LOG source
Date: Wed, 10 Oct 2012 14:26:32 +0200
Message-ID: <1349871992-31115-10-git-send-email-jengelh@inai.de>
References: <1349871992-31115-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:57562 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016Ab2JJM0j (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Oct 2012 08:26:39 -0400
In-Reply-To: <1349871992-31115-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The "err" loglevel is not actually deprecated - it is the only name
available to mean the LOG_ERR level.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/libip6t_LOG.c |    2 +-
 extensions/libipt_LOG.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index 2b1ae28..8dc94e3 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -68,7 +68,7 @@ static const struct ip6t_log_names ip6t_log_names[]
     { .name = "crit",    .level = LOG_CRIT },
     { .name = "debug",   .level = LOG_DEBUG },
     { .name = "emerg",   .level = LOG_EMERG },
-    { .name = "error",   .level = LOG_ERR },		/* DEPRECATED */
+    { .name = "error",   .level = LOG_ERR },
     { .name = "info",    .level = LOG_INFO },
     { .name = "notice",  .level = LOG_NOTICE },
     { .name = "panic",   .level = LOG_EMERG },		/* DEPRECATED */
diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index 77f16d1..971f3ca 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -68,7 +68,7 @@ static const struct ipt_log_names ipt_log_names[]
     { .name = "crit",    .level = LOG_CRIT },
     { .name = "debug",   .level = LOG_DEBUG },
     { .name = "emerg",   .level = LOG_EMERG },
-    { .name = "error",   .level = LOG_ERR },		/* DEPRECATED */
+    { .name = "error",   .level = LOG_ERR },
     { .name = "info",    .level = LOG_INFO },
     { .name = "notice",  .level = LOG_NOTICE },
     { .name = "panic",   .level = LOG_EMERG },		/* DEPRECATED */
-- 
1.7.10.4

