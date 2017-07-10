From: Eric Leblond <eric@regit.org>
Subject: [nft PATCH 4/7] parser: error if needed at EOF
Date: Tue, 11 Jul 2017 00:32:52 +0200
Message-ID: <20170710223255.29885-5-eric@regit.org>
References: <20170710223255.29885-1-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:41146 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754695AbdGJWdQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jul 2017 18:33:16 -0400
In-Reply-To: <20170710223255.29885-1-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/parser_bison.y | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index b898e1c..85cf131 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -756,6 +756,8 @@ line			:	common_block			{ $$ = NULL; }
 					} else
 						list_splice_tail(&list, &state->cmds);
 				}
+				if (state->nerrs)
+					YYABORT;
 				$$ = NULL;
 
 				YYACCEPT;
-- 
2.13.2

