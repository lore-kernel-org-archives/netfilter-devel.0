From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2/8] scanner: don't update location's line_offset for newlines
Date: Tue,  4 Feb 2014 08:35:14 +0000
Message-ID: <1391502920-19186-3-git-send-email-kaber@trash.net>
References: <1391502920-19186-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43622 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaBDIf0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Feb 2014 03:35:26 -0500
In-Reply-To: <1391502920-19186-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When reset_pos() is invoked, YY_USER_ACTION() has already advanced the
line offset to the next line. This causes errors for unexpected newlines
to incorrectly show the following line when reading from files.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/scanner.l | 1 -
 1 file changed, 1 deletion(-)

diff --git a/src/scanner.l b/src/scanner.l
index 47ab1e2..11965cd 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -88,7 +88,6 @@ static void reset_pos(struct parser_state *state, struct location *loc)
 	state->indesc->line_offset	= state->indesc->token_offset;
 	state->indesc->lineno		+= 1;
 	state->indesc->column		= 1;
-	loc->line_offset		= state->indesc->line_offset;
 }
 
 #define YY_USER_ACTION {					\
-- 
1.8.5.3

