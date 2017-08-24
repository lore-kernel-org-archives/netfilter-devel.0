From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 4/4] parser: Fix for memleak when commands fail
Date: Thu, 24 Aug 2017 19:14:13 +0200
Message-ID: <20170824171413.31737-5-phil@nwl.cc>
References: <20170824171413.31737-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:41095 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753416AbdHXROb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2017 13:14:31 -0400
In-Reply-To: <20170824171413.31737-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In case of failing command evaluation, commands need to be freed as
their memory becomes orphaned afterwards.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_bison.y | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index a8b71cddc1920..d149178c2679b 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -692,6 +692,7 @@ input			:	/* empty */
 
 					list_add_tail(&$2->list, &list);
 					if (cmd_evaluate(&state->ectx, $2) < 0) {
+						cmd_free($2);
 						if (++state->nerrs == nft->parser_max_errors)
 							YYABORT;
 					} else
@@ -758,6 +759,7 @@ line			:	common_block			{ $$ = NULL; }
 
 					list_add_tail(&$1->list, &list);
 					if (cmd_evaluate(&state->ectx, $1) < 0) {
+						cmd_free($1);
 						if (++state->nerrs == nft->parser_max_errors)
 							YYABORT;
 					} else
-- 
2.13.1

