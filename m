From: Florian Westphal <fw@strlen.de>
Subject: [PATCH] bison: remove old log level tokens
Date: Wed, 30 Nov 2016 20:34:28 +0100
Message-ID: <1480534468-7388-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:48894 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753419AbcK3TeO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Nov 2016 14:34:14 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

not used anymore since 0423caa91ad26e7 ("src: don't need keyword for log level")

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index f07303e2102a..deaaf06fa1c6 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -370,14 +370,6 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token SNAPLEN			"snaplen"
 %token QUEUE_THRESHOLD		"queue-threshold"
 %token LEVEL			"level"
-%token LEVEL_EMERG		"emerg"
-%token LEVEL_ALERT		"alert"
-%token LEVEL_CRIT		"crit"
-%token LEVEL_ERR		"err"
-%token LEVEL_WARN		"warn"
-%token LEVEL_NOTICE		"notice"
-%token LEVEL_INFO		"info"
-%token LEVEL_DEBUG		"debug"
 
 %token LIMIT			"limit"
 %token RATE			"rate"
-- 
2.7.3

