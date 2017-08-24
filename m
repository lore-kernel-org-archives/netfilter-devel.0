From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 3/4] scanner: Make use of yylex_init_extra()
Date: Thu, 24 Aug 2017 19:14:12 +0200
Message-ID: <20170824171413.31737-4-phil@nwl.cc>
References: <20170824171413.31737-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:50327 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753736AbdHXROu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2017 13:14:50 -0400
In-Reply-To: <20170824171413.31737-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This combines the calls to yylex_init() and yyset_extra().

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/scanner.l | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/src/scanner.l b/src/scanner.l
index 7d57cc1465d3a..f0021c5c0fbae 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -849,8 +849,7 @@ void *scanner_init(struct parser_state *state)
 
 	state->indesc = state->indescs;
 
-	yylex_init(&scanner);
-	yyset_extra(state, scanner),
+	yylex_init_extra(state, &scanner);
 	yyset_out(NULL, scanner);
 
 	return scanner;
-- 
2.13.1

