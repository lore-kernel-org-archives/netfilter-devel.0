From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH v3 2/2] parser_bison: Use __error() to avoid syntax error
 message duplication
Date: Wed, 16 Nov 2016 20:05:34 -0200
Message-ID: <20161116220534.GA18817@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f68.google.com ([209.85.213.68]:34823 "EHLO
        mail-vk0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932212AbcKPWFl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Nov 2016 17:05:41 -0500
Received: by mail-vk0-f68.google.com with SMTP id x186so12999082vkd.2
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Nov 2016 14:05:40 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Calls to erec_queue() from yyerror() already have "syntax error" in the
body of the message, then __error() must be used.

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---
 v3: Separate changes in different patches

 src/parser_bison.y | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 91955c1..58385fa 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -47,7 +47,7 @@ void parser_init(struct parser_state *state, struct list_head *msgs)
 static void yyerror(struct location *loc, void *scanner,
 		    struct parser_state *state, const char *s)
 {
-	erec_queue(error(loc, "%s", s), state->msgs);
+	erec_queue(__error(loc, "%s", s), state->msgs);
 }
 
 static struct scope *current_scope(const struct parser_state *state)
-- 
2.7.4

