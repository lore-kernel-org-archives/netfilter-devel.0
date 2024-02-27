Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2BA13DBBC
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Feb 2024 15:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709046987; cv=none; b=nfdYZ2aRLauad9QWCr29WArj3XJhqDbG2xMfQmODzmx8euFQKJQBnTP3jmHvpSiOJDCygWe5oEJnAON+XidkeCgWLGPPJOXjdHy6C7aclVftgBeIbRXZ7LV57+UJrg4sFkrkFe9bqJ/9p5F6YqnaXlABtBZxVZpRKGNG/ErZvfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709046987; c=relaxed/simple;
	bh=qc6o4sc/sMQ/a9J094gSSm9dOrXUpNF+supq8ROR9To=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=szJ+C6BeK4IDq6T4v1UxMu/ejahNhk4YJPcf5nxX/V0HkKW+ta5fPmRci9azcnTA/m6J7WwabgxV1e3C9iOlbrO2rGcw9NCHBIHkaL1UhXUPkNioQcB/JIULQfahtkA/R07hPTbxoSSC3WrQZLjt07nyWEdDUVmZpalmDWQmlIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rezBv-0005LX-Ls; Tue, 27 Feb 2024 16:16:23 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] parser: compact type/typeof set rules
Date: Tue, 27 Feb 2024 15:53:19 +0100
Message-ID: <20240227145323.7377-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Set/maps keys can be declared either by 'type' or 'typeof' keyword.

Compact this to use a common block for both cases.

The datatype_set call is redundant, remove it:
at this point $3 == $1->key, so this is a no-op.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 2b4968280042..cba37c686f66 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -812,8 +812,8 @@ int nft_lex(void *, void *, void *);
 
 %type <expr>			symbol_expr verdict_expr integer_expr variable_expr chain_expr policy_expr
 %destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr variable_expr chain_expr policy_expr
-%type <expr>			primary_expr shift_expr and_expr typeof_expr typeof_data_expr typeof_verdict_expr
-%destructor { expr_free($$); }	primary_expr shift_expr and_expr typeof_expr typeof_data_expr typeof_verdict_expr
+%type <expr>			primary_expr shift_expr and_expr typeof_expr typeof_data_expr typeof_key_expr typeof_verdict_expr
+%destructor { expr_free($$); }	primary_expr shift_expr and_expr typeof_expr typeof_data_expr typeof_key_expr typeof_verdict_expr
 %type <expr>			exclusive_or_expr inclusive_or_expr
 %destructor { expr_free($$); }	exclusive_or_expr inclusive_or_expr
 %type <expr>			basic_expr
@@ -2182,27 +2182,21 @@ set_block_alloc		:	/* empty */
 			}
 			;
 
+typeof_key_expr		:	TYPEOF	typeof_expr { $$ = $2; }
+			|	TYPE	data_type_expr close_scope_type { $$ = $2; }
+			;
+
 set_block		:	/* empty */	{ $$ = $<set>-1; }
 			|	set_block	common_block
 			|	set_block	stmt_separator
-			|	set_block	TYPE		data_type_expr	stmt_separator	close_scope_type
+			|	set_block	typeof_key_expr	stmt_separator
 			{
 				if (already_set($1->key, &@2, state)) {
-					expr_free($3);
+					expr_free($2);
 					YYERROR;
 				}
 
-				$1->key = $3;
-				$$ = $1;
-			}
-			|	set_block	TYPEOF		typeof_expr	stmt_separator
-			{
-				if (already_set($1->key, &@2, state)) {
-					expr_free($3);
-					YYERROR;
-				}
-				$1->key = $3;
-				datatype_set($1->key, $3->dtype);
+				$1->key = $2;
 				$$ = $1;
 			}
 			|	set_block	FLAGS		set_flag_list	stmt_separator
-- 
2.43.0

