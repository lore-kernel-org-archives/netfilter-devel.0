Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30387A3D
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Mar 2024 13:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709298281; cv=none; b=FdtDGuLbEpjeE4bwSDFl5R2YxvF1KW5FadhmVJmgtnCDq4gHh/Khl0EQCOUb+9tQhI/Kpi5UgF29M/jC3aDTDK//Pz8eNsJMSnXygJmM7qcq04AP//jkMEXfLZoR9ZBN0v1rzBrwk6YOyCtGq7cV0RTweuTpiJa4F5TAYKbG2fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709298281; c=relaxed/simple;
	bh=u59ABRmvLVsSKwsJsSOk1f9WHEiWHzH5nbvYhXK7buY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nk1qkYLHnKVtAPOcDK7pP6TNpQTYbHZYd2ecIvFvSvlYQjn1RXPMfFaP0ySV2fQD7RCbS9D/d7N1mW6Ka3IiDL+LWnUL2bQ0FBR4orSKysD3ssKEOrfaLTCpKys++QeA2PBYLWSXJ1dnwoO52lbNYl8dFhFTWsHgaDtjCyn9JfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rg2Z3-0002Mq-FQ; Fri, 01 Mar 2024 14:04:37 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/3] parser: allow to define maps that contain timeouts and expectations
Date: Fri,  1 Mar 2024 13:59:36 +0100
Message-ID: <20240301125942.20170-2-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240301125942.20170-1-fw@strlen.de>
References: <20240301125942.20170-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Its currently not possible to use ct timeouts/expectations/helpers
in objref maps, bison parser lacks the relevant keywords.

This change adds support for timeouts and expectations.
Ct helpers are more problematic, this will come in a different change.

Support is only added for the "typeof" keyword, otherwise we'd
need to add pseudo-datatypes as well, but making "ct expectation"
available as "type" as well might be confusing.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index cd1dc658882d..05861c3e2f75 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -751,7 +751,7 @@ int nft_lex(void *, void *, void *);
 
 %type <set>			map_block_alloc map_block
 %destructor { set_free($$); }	map_block_alloc
-%type <val>			map_block_obj_type map_block_data_interval
+%type <val>			map_block_obj_type map_block_obj_typeof map_block_data_interval
 
 %type <flowtable>		flowtable_block_alloc flowtable_block
 %destructor { flowtable_free($$); }	flowtable_block_alloc
@@ -988,7 +988,7 @@ int nft_lex(void *, void *, void *);
 %destructor { expr_free($$); }	exthdr_exists_expr
 %type <val>			exthdr_key
 
-%type <val>			ct_l4protoname ct_obj_type ct_cmd_type
+%type <val>			ct_l4protoname ct_obj_type ct_cmd_type ct_obj_type_map
 
 %type <timeout_state>		timeout_state
 %destructor { timeout_state_free($$); }		timeout_state
@@ -2269,6 +2269,10 @@ map_block_alloc		:	/* empty */
 			}
 			;
 
+ct_obj_type_map		: 	TIMEOUT		{ $$ = NFT_OBJECT_CT_TIMEOUT; }
+			|	EXPECTATION	{ $$ = NFT_OBJECT_CT_EXPECT; }
+			;
+
 map_block_obj_type	:	COUNTER	close_scope_counter { $$ = NFT_OBJECT_COUNTER; }
 			|	QUOTA	close_scope_quota { $$ = NFT_OBJECT_QUOTA; }
 			|	LIMIT	close_scope_limit { $$ = NFT_OBJECT_LIMIT; }
@@ -2276,6 +2280,10 @@ map_block_obj_type	:	COUNTER	close_scope_counter { $$ = NFT_OBJECT_COUNTER; }
 			|	SYNPROXY close_scope_synproxy { $$ = NFT_OBJECT_SYNPROXY; }
 			;
 
+map_block_obj_typeof	:	map_block_obj_type
+			|	CT	ct_obj_type_map	close_scope_ct	{ $$ = $2; }
+			;
+
 map_block_data_interval :	INTERVAL { $$ = EXPR_F_INTERVAL; }
 			|	{ $$ = 0; }
 			;
@@ -2341,7 +2349,7 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 				$$ = $1;
 			}
 			|	map_block	TYPEOF
-						typeof_expr 	COLON	map_block_obj_type
+						typeof_expr 	COLON	map_block_obj_typeof
 						stmt_separator
 			{
 				$1->key = $3;
-- 
2.43.0

