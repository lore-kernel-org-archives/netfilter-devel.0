Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E8A01D63E0
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Dec 2024 23:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734045240; cv=none; b=omZ1aFwt3ShtSl26SkbxtWXQ2/pvUV9OTq2cHLj5jaYlGM8fQDfnTXS8oZC7pjf3J0ZS579azGfsKeprPCditSXxcJN38UKA4I361tAG3WwnuBiuTLsZiUM7ZDkpudOV17A+9zwbTIio/W9GqT2P8qb+SHfSoL0+ne7E4Lu1b9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734045240; c=relaxed/simple;
	bh=opRGqG0iVk0Wx1W66o+qh8Q6TepL+6hlx155sjZP4Bc=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=i/QxGZSDglEhssJnkNsJrYjt8YFKkXh0dlPguCmzVxzUJPGx2r8osohZgPBYuwB2I+BbclOtmcQTpWe8iUChvdwySNA1PYa+GtyE2BfUbwPQVVclxuUXvMRCt7DF2rROOzmSx0DnqNoqPcr0p7rR2jDAN/1+3n4DWOQjyDkyrVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] src: remove last_line from struct location
Date: Fri, 13 Dec 2024 00:13:45 +0100
Message-Id: <20241212231346.181221-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This 4 bytes field is never used, remove it.

This does not shrink struct location in x86_64 due to alignment.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/nftables.h | 1 -
 src/parser_bison.y | 3 +--
 src/parser_json.c  | 1 -
 src/scanner.l      | 1 -
 4 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index 7d891b439a2d..a6f0e6128887 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -161,7 +161,6 @@ struct location {
 			off_t			line_offset;
 
 			unsigned int		first_line;
-			unsigned int		last_line;
 			unsigned int		first_column;
 			unsigned int		last_column;
 		};
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 6e8b639104fc..e107ddfd3e4e 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -105,12 +105,11 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 		loc->line_offset  = rhs[1].line_offset;
 		loc->first_line   = rhs[1].first_line;
 		loc->first_column = rhs[1].first_column;
-		loc->last_line    = rhs[n].last_line;
 		loc->last_column  = rhs[n].last_column;
 	} else {
 		loc->indesc       = rhs[0].indesc;
 		loc->line_offset  = rhs[0].line_offset;
-		loc->first_line   = loc->last_line   = rhs[0].last_line;
+		loc->first_line   = rhs[0].first_line;
 		loc->first_column = loc->last_column = rhs[0].last_column;
 	}
 }
diff --git a/src/parser_json.c b/src/parser_json.c
index 5ac5f0270d32..17bc38b565ae 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -123,7 +123,6 @@ static void json_lib_error(struct json_ctx *ctx, json_error_t *err)
 		.indesc = &json_indesc,
 		.line_offset = err->position - err->column,
 		.first_line = err->line,
-		.last_line = err->line,
 		.first_column = err->column,
 		/* no information where problematic part ends :( */
 		.last_column = err->column,
diff --git a/src/scanner.l b/src/scanner.l
index ecdba404b2cd..4a340b00fdc6 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -80,7 +80,6 @@ static void update_pos(struct parser_state *state, struct location *loc,
 {
 	loc->indesc			= state->indesc;
 	loc->first_line			= state->indesc->lineno;
-	loc->last_line			= state->indesc->lineno;
 	loc->first_column		= state->indesc->column;
 	loc->last_column		= state->indesc->column + len - 1;
 	state->indesc->column		+= len;
-- 
2.30.2

