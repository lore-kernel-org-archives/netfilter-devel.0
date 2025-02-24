Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B46525B667
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Feb 2025 17:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740419604; cv=none; b=KDmuf+3Xz4ij6YhVt4okdmi2rBXj/6VQrQb3F/F3t11iNL2NhLIZ6p2dQo64uIDbzTlG6zZll5/FAaRk6XToeNKvtxMsCd991PCHKvU5IsW8jT9fDhnQwNuvmAc/NgWGbafIpIKUYBMTER3ROp4mJllVj9XbB+EGAmWfCAtfpls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740419604; c=relaxed/simple;
	bh=+om4f4N4RCCIlpxAAlWmzZWoWSZalM+xsB+etPT9yAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XVCr5asMgA1pvqsTmgR1HB9vwftGPnmofPuuxt5UJi1RPbv/rmvC26GGBpXZZl5ID1/x9rpE+zXn63OktZde94t7+UbDihgFQXELgFtozqmkamKUrPp10wCe2lr+0lLdbywAaXocoYH1KNIRlYSSb/JLA8GxChqOKyg0MULqlUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tmcdr-0004NN-H8; Mon, 24 Feb 2025 18:53:19 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] parser_bison: get rid of unneeded statement
Date: Mon, 24 Feb 2025 18:52:11 +0100
Message-ID: <20250224175214.19053-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Was used for the legacy flow statement, but that was removed in
2ee93ca27ddc ("parser_bison: remove deprecated flow statement")

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index f55127839a9b..e494079d6373 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -811,8 +811,8 @@ int nft_lex(void *, void *, void *);
 %type <val>			set_stmt_op
 %type <stmt>			map_stmt
 %destructor { stmt_free($$); }	map_stmt
-%type <stmt>			meter_stmt meter_stmt_alloc
-%destructor { stmt_free($$); }	meter_stmt meter_stmt_alloc
+%type <stmt>			meter_stmt
+%destructor { stmt_free($$); }	meter_stmt
 
 %type <expr>			symbol_expr verdict_expr integer_expr variable_expr chain_expr policy_expr
 %destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr variable_expr chain_expr policy_expr
@@ -4192,10 +4192,7 @@ map_stmt		:	set_stmt_op	set_ref_expr '{' set_elem_expr_stmt	COLON	set_elem_expr_
 			}
 			;
 
-meter_stmt		:	meter_stmt_alloc		{ $$ = $1; }
-			;
-
-meter_stmt_alloc	:	METER	identifier		'{' meter_key_expr stmt '}'
+meter_stmt 		:	METER	identifier		'{' meter_key_expr stmt '}'
 			{
 				$$ = meter_stmt_alloc(&@$);
 				$$->meter.name = $2;
-- 
2.45.3

