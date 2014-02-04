From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 3/8] scanner: update last_line in struct location
Date: Tue,  4 Feb 2014 08:35:15 +0000
Message-ID: <1391502920-19186-4-git-send-email-kaber@trash.net>
References: <1391502920-19186-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43624 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbaBDIf0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Feb 2014 03:35:26 -0500
In-Reply-To: <1391502920-19186-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently always has the value 0.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/scanner.l | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/scanner.l b/src/scanner.l
index 11965cd..e4cb398 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -70,6 +70,7 @@ static void update_pos(struct parser_state *state, struct location *loc,
 {
 	loc->indesc			= state->indesc;
 	loc->first_line			= state->indesc->lineno;
+	loc->last_line			= state->indesc->lineno;
 	loc->first_column		= state->indesc->column;
 	loc->last_column		= state->indesc->column + len - 1;
 	state->indesc->column		+= len;
-- 
1.8.5.3

