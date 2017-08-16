From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 3/5] src: cli: Remove cli_display() function.
Date: Wed, 16 Aug 2017 19:48:15 +0530
Message-ID: <20170816141817.20179-4-rvarsha016@gmail.com>
References: <20170816141817.20179-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:37225 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751637AbdHPOTL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Aug 2017 10:19:11 -0400
Received: by mail-pg0-f66.google.com with SMTP id 83so5374624pgb.4
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Aug 2017 07:19:10 -0700 (PDT)
In-Reply-To: <20170816141817.20179-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove cli_display() function, as it is not called anywhere in source
code.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 include/cli.h |  1 -
 src/cli.c     | 26 --------------------------
 2 files changed, 27 deletions(-)

diff --git a/include/cli.h b/include/cli.h
index e577400..40fc63e 100644
--- a/include/cli.h
+++ b/include/cli.h
@@ -15,6 +15,5 @@ static inline int cli_init(struct nft_ctx *nft, struct mnl_socket *nf_sock,
 }
 #endif
 extern void cli_exit(void);
-extern void cli_display(const char *fmt, va_list ap) __fmtstring(1, 0);
 
 #endif
diff --git a/src/cli.c b/src/cli.c
index a50fc58..d0ca9af 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -149,32 +149,6 @@ static char **cli_completion(const char *text, int start, int end)
 	return NULL;
 }
 
-void __fmtstring(1, 0) cli_display(const char *fmt, va_list ap)
-{
-	int point, end;
-	char *buf;
-
-	point = rl_point;
-	end   = rl_end;
-	rl_point = rl_end = 0;
-
-	rl_save_prompt();
-	rl_clear_message();
-
-	if (vasprintf(&buf, fmt, ap) < 0)
-		fprintf(rl_outstream, "cli_display: out of memory\n");
-	else {
-		fprintf(rl_outstream, "%s\n", buf);
-		xfree(buf);
-	}
-
-	rl_restore_prompt();
-
-	rl_point = point;
-	rl_end   = end;
-	rl_forced_update_display();
-}
-
 int cli_init(struct nft_ctx *nft, struct mnl_socket *nf_sock,
 	     struct nft_cache *cache, struct parser_state *_state)
 {
-- 
2.13.5

