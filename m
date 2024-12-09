Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBFACDDD3
	for <netfilter-devel@vger.kernel.org>; Mon,  9 Dec 2024 17:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733765630; cv=none; b=ORqo69wH8qoyMhLYvu8JJpjYtQztsWYFT2PTTKPuy53EYIdZDz08NvOktL/Axp8BmgX0vhp8oSiqbOQoW4d+LXuPRvEd1MGWsupzqSFGKFwBgnetJhOS9JAtrKUlKk5ldiGpxn57JbLmbDWE3f7jAQ6ufy10lg4ymi/dt1q9Xzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733765630; c=relaxed/simple;
	bh=6R7QPz9b++0QYCD0gDXQA4y2J9rBn1TiQjI2TwEXnBw=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mY0CnDocVT+qEW59y/Hqh0Bmo0eBNiRLrsm7I4VdYTg2nsSnyYIhgOEFRSA+M64a8VmaLKX1TInjjfEPwlmHNME6fCDolZcm1MqSFJJT3RGkRkbKrDNrjgs66gcZt7XF+FHJBcTuV6bwvRo6q/CDZjHUoKgQnkeQrQa03lWR0hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] src: remove unused token_offset from struct location
Date: Mon,  9 Dec 2024 18:33:34 +0100
Message-Id: <20241209173334.512591-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241209173334.512591-1-pablo@netfilter.org>
References: <20241209173334.512591-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This saves 8 bytes in x86_64 in struct location which is embedded in
every expression.

This shrinks struct expr to 120 bytes according to pahole.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
low hanging fruit to shrink struct expr.

 include/nftables.h | 1 -
 src/parser_bison.y | 2 --
 src/scanner.l      | 1 -
 3 files changed, 4 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index c25deb3676dd..7d891b439a2d 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -158,7 +158,6 @@ struct location {
 	const struct input_descriptor		*indesc;
 	union {
 		struct {
-			off_t			token_offset;
 			off_t			line_offset;
 
 			unsigned int		first_line;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 6e6f3cf8335d..6e8b639104fc 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -102,7 +102,6 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 {
 	if (n) {
 		loc->indesc       = rhs[n].indesc;
-		loc->token_offset = rhs[1].token_offset;
 		loc->line_offset  = rhs[1].line_offset;
 		loc->first_line   = rhs[1].first_line;
 		loc->first_column = rhs[1].first_column;
@@ -110,7 +109,6 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 		loc->last_column  = rhs[n].last_column;
 	} else {
 		loc->indesc       = rhs[0].indesc;
-		loc->token_offset = rhs[0].token_offset;
 		loc->line_offset  = rhs[0].line_offset;
 		loc->first_line   = loc->last_line   = rhs[0].last_line;
 		loc->first_column = loc->last_column = rhs[0].last_column;
diff --git a/src/scanner.l b/src/scanner.l
index c825fa79cfd9..ecdba404b2cd 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -90,7 +90,6 @@ static void update_offset(struct parser_state *state, struct location *loc,
 			  unsigned int len)
 {
 	state->indesc->token_offset	+= len;
-	loc->token_offset		= state->indesc->token_offset;
 	loc->line_offset		= state->indesc->line_offset;
 }
 
-- 
2.30.2

