Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6798B22313
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Jul 2024 22:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720130762; cv=none; b=Nkz+hyScLRvquw/a/ZI9fSGFjjDZftQreKJL7wYPfp/wo1Zem4zx703eAA2RXav0KZqrzK/PgDw1Fz5xi64Xi6pQg2m6qUD7Jpd8p3v12dNr63cX1G71qGtKaXTB/1tkAkCsIvCzZyOhDUwpV+Z/Cs7FhKyIyIaH3Nfusif1t1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720130762; c=relaxed/simple;
	bh=GVlSGOW0er6Qs1P+2NZ8uGaEE7SbBMycbrHFBCG5Vsc=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=EKZXMl0ILQ7zDmocfA5/MpCvhLisIwrq9EAlTud4ho6DSolZLqqAbdRUJxBjin9yn5ZvJ7TBqQipi49WMVf4pgM2SDBdd3YYdDwByrgZXrChu7MqlOMXqlgzHop/Jg9VwnpDiGyrKeB64hvTGq5NTIRlLg0GgAgqKUsVDvD/EDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] parser_bison: remove deprecated flow statement
Date: Fri,  5 Jul 2024 00:05:54 +0200
Message-Id: <20240704220554.277702-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Dynamic set/maps are used these days to represent what
3ed5e31f4a32 ("src: add flow statement") provides.

Unlikely meter statement, this statement was never documented
other than in the source code. Ditch it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 6b167080cd93..11ca957bbd29 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -809,8 +809,8 @@ int nft_lex(void *, void *, void *);
 %type <val>			set_stmt_op
 %type <stmt>			map_stmt
 %destructor { stmt_free($$); }	map_stmt
-%type <stmt>			meter_stmt meter_stmt_alloc flow_stmt_legacy_alloc
-%destructor { stmt_free($$); }	meter_stmt meter_stmt_alloc flow_stmt_legacy_alloc
+%type <stmt>			meter_stmt meter_stmt_alloc
+%destructor { stmt_free($$); }	meter_stmt meter_stmt_alloc
 
 %type <expr>			symbol_expr verdict_expr integer_expr variable_expr chain_expr policy_expr
 %destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr variable_expr chain_expr policy_expr
@@ -4212,21 +4212,7 @@ map_stmt		:	set_stmt_op	set_ref_expr '{' set_elem_expr_stmt	COLON	set_elem_expr_
 			}
 			;
 
-meter_stmt		:	flow_stmt_legacy_alloc		TABLE identifier	'{' meter_key_expr stmt '}'
-			{
-				$1->meter.name = $3;
-				$1->meter.key  = $5;
-				$1->meter.stmt = $6;
-				$$->location  = @$;
-				$$ = $1;
-			}
-			|	meter_stmt_alloc		{ $$ = $1; }
-			;
-
-flow_stmt_legacy_alloc	:	FLOW
-			{
-				$$ = meter_stmt_alloc(&@$);
-			}
+meter_stmt		:	meter_stmt_alloc		{ $$ = $1; }
 			;
 
 meter_stmt_alloc	:	METER	identifier		'{' meter_key_expr stmt '}'
-- 
2.30.2

