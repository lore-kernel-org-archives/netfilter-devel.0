From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 08/13] src: remove faulty deprecated marker in libipt_LOG source
Date: Wed, 26 Dec 2012 00:11:24 +0100
Message-ID: <1356477089-13241-9-git-send-email-jengelh@inai.de>
References: <1356477089-13241-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:38908 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473Ab2LYXLe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Dec 2012 18:11:34 -0500
In-Reply-To: <1356477089-13241-1-git-send-email-jengelh@inai.de>
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

