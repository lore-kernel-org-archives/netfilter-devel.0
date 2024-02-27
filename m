Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B247A72E
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Feb 2024 15:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709046799; cv=none; b=ueOenCMuLt5ldHZjQMQsaytzdQnh6r2wH79is2L+N9MBaRqsPhjEk95ecAsHQAePugTKcpjFQjfcV7kuLykQXoZwYmbPPQmgCsJ0R6u0rioMYYrMNhGg9q4lCfj7efeoKOEA575I39POM+1xUItyAz18G4Lg85V+AIn12fXVTRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709046799; c=relaxed/simple;
	bh=YQUtbaK0Ty4X0F6uefzt3yWpHTRQaaACWfjdj2L84Nc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NlXhsLdM/hNcm1PYtQ+fNQcwEd1TwWmH+CMiGLkJAOoyPH6rFUMk3NQQhbQ6KmyMUjDBLRSwaAe4YORKWKDuYtX0UqtHJy8k7DT99m6ST7IkNSSGJATyDtzXGfAd0aLUvbg2bc5TI175DddvZo78TmLx4nusVTTcrw3gxbwyP3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rez8n-0005KK-6p; Tue, 27 Feb 2024 16:13:09 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] parser: compact interval typeof rules
Date: Tue, 27 Feb 2024 15:50:05 +0100
Message-ID: <20240227145008.7256-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are two nearly identical blocks for typeof maps:
one with INTERVAL keyword present and one without.

Compact this into a single block.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 17edaef8b0bc..2b4968280042 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -812,8 +812,8 @@ int nft_lex(void *, void *, void *);
 
 %type <expr>			symbol_expr verdict_expr integer_expr variable_expr chain_expr policy_expr
 %destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr variable_expr chain_expr policy_expr
-%type <expr>			primary_expr shift_expr and_expr typeof_expr typeof_data_expr
-%destructor { expr_free($$); }	primary_expr shift_expr and_expr typeof_expr typeof_data_expr
+%type <expr>			primary_expr shift_expr and_expr typeof_expr typeof_data_expr typeof_verdict_expr
+%destructor { expr_free($$); }	primary_expr shift_expr and_expr typeof_expr typeof_data_expr typeof_verdict_expr
 %type <expr>			exclusive_or_expr inclusive_or_expr
 %destructor { expr_free($$); }	exclusive_or_expr inclusive_or_expr
 %type <expr>			basic_expr
@@ -2110,7 +2110,7 @@ subchain_block		:	/* empty */	{ $$ = $<chain>-1; }
 			}
 			;
 
-typeof_data_expr	:	primary_expr
+typeof_verdict_expr	:	primary_expr
 			{
 				struct expr *e = $1;
 
@@ -2142,6 +2142,17 @@ typeof_data_expr	:	primary_expr
 			}
 			;
 
+typeof_data_expr	:	INTERVAL	typeof_expr
+			{
+				$2->flags |= EXPR_F_INTERVAL;
+				$$ = $2;
+			}
+			|	typeof_verdict_expr
+			{
+				$$ = $1;
+			}
+			;
+
 typeof_expr		:	primary_expr
 			{
 				if (expr_ops($1)->build_udata == NULL) {
@@ -2321,23 +2332,6 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 				$1->flags |= NFT_SET_MAP;
 				$$ = $1;
 			}
-			|	map_block	TYPEOF
-						typeof_expr	COLON	INTERVAL	typeof_expr
-						stmt_separator
-			{
-				if (already_set($1->key, &@2, state)) {
-					expr_free($3);
-					expr_free($6);
-					YYERROR;
-				}
-
-				$1->key = $3;
-				$1->data = $6;
-				$1->data->flags |= EXPR_F_INTERVAL;
-
-				$1->flags |= NFT_SET_MAP;
-				$$ = $1;
-			}
 			|	map_block	TYPE
 						data_type_expr	COLON	map_block_obj_type
 						stmt_separator	close_scope_type
-- 
2.43.0

