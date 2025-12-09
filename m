Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131DF2E7198
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Dec 2025 16:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765298752; cv=none; b=g47xayMmCiQDvCfjeWnZEOIW0HYw/21zL2Rqwumcc3PSStD9c4DEdPrj/qWvR21y3ZENW5iwrscEbzWt9deObq5zIa3lX0MNbCziAJ+U5eBAPUOQtGQ86reXBLeY/ONeyCzdSHhdpqyRGsJPhoLDTlPqLvFHr/TAY07LNqeNPn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765298752; c=relaxed/simple;
	bh=APyXPtPr6b/maeF8faqUgA/xDf/9HVG99EN4I2Rvnq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MrxybFyNZ5ylyFl1rxjhXFGwHKqb4db6zMCjKd7PeO34B0gSEBN1LiBShxyu5J1MklV/+E5ALqZhPgPusTp1xMj1zYAg530inu+8i8O9pRVqJSKucBapHdS1uorMU5gA3DbShLbDw1a5HJ+DBGR6WwCd9PudltsZthewNnBxuI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=nfYbSJ36; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="nfYbSJ36"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Sel8fPWqg+XOeuhOwEKZTLEmH+jbPcOAShmhbmRXmWk=; b=nfYbSJ36gbK+zLwAOiDelgkTM2
	gTs/947ZFf03TN7oTWwnQB7XPn53+wha23ng4zXj7BfyBED6nWlbWmMuXb1cdIy5PonV+j90vj6wt
	P3ac8R+JSiHizPeMwIcPoNvdtT2Ufw0iUc2ffv7F7MWWNgq91XHaDYpvE+ZsR8dWG4K/AV8nLmJeE
	2VTEqhasZWujdiTUo3GTnG5ZwJLvgsaz0vJnCYOjB9NqISupEy3YoiYvj6uqD1myBO2Z2E2WScQ6z
	ka0Kk5wloM6EjUkTWtLSyObFurRCPuP1FwMZ3kqGWah5NNGjck6bqjct0ReRQCZKW/vvdvm3DxiTr
	ssikDrgw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vT0qR-000000007tU-1NkM;
	Tue, 09 Dec 2025 17:45:47 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/6] parser_bison: Introduce tokens for chain types
Date: Tue,  9 Dec 2025 17:45:37 +0100
Message-ID: <20251209164541.13425-3-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251209164541.13425-1-phil@nwl.cc>
References: <20251209164541.13425-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the already existing SCANSTATE_TYPE for keyword scoping.
This is a bit of back-n-forth from string to token and back to string
but it eliminates the helper function and also takes care of error
handling.

Note that JSON parser does not validate the type string at all but
relies upon the kernel to reject wrong ones.
---
Changes since RFC:
- Fix for leaking chain_type token.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/rule.h     |  1 -
 src/parser_bison.y | 28 ++++++++++++++--------------
 src/rule.c         | 19 -------------------
 src/scanner.l      |  6 ++++++
 4 files changed, 20 insertions(+), 34 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index e67a01522d318..7c704be846485 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -260,7 +260,6 @@ struct chain {
 
 #define STD_PRIO_BUFSIZE 100
 extern int std_prio_lookup(const char *std_prio_name, int family, int hook);
-extern const char *chain_type_name_lookup(const char *name);
 extern const char *chain_hookname_lookup(const char *name);
 extern struct chain *chain_alloc(void);
 extern struct chain *chain_get(struct chain *chain);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 96d0e151b1586..405fe8f2690ca 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -715,6 +715,10 @@ int nft_lex(void *, void *, void *);
 
 %token XT		"xt"
 
+%token FILTER		"filter"
+%token NAT		"nat"
+%token ROUTE		"route"
+
 %type <limit_rate>		limit_rate_pkts
 %type <limit_rate>		limit_rate_bytes
 
@@ -1034,6 +1038,9 @@ int nft_lex(void *, void *, void *);
 %type <expr>			set_elem_key_expr
 %destructor { expr_free($$); }	set_elem_key_expr
 
+%type <string>			chain_type
+%destructor { free_const($$); }	chain_type
+
 %%
 
 input			:	/* empty */
@@ -2736,22 +2743,10 @@ type_identifier		:	STRING	{ $$ = $1; }
 			|	CLASSID { $$ = xstrdup("classid"); }
 			;
 
-hook_spec		:	TYPE		close_scope_type	STRING		HOOK		STRING		dev_spec	prio_spec
+hook_spec		:	TYPE		chain_type	close_scope_type	HOOK		STRING		dev_spec	prio_spec
 			{
-				const char *chain_type = chain_type_name_lookup($3);
-
-				if (chain_type == NULL) {
-					erec_queue(error(&@3, "unknown chain type"),
-						   state->msgs);
-					free_const($3);
-					free_const($5);
-					expr_free($6);
-					expr_free($7.expr);
-					YYERROR;
-				}
 				$<chain>0->type.loc = @3;
-				$<chain>0->type.str = xstrdup(chain_type);
-				free_const($3);
+				$<chain>0->type.str = $2;
 
 				$<chain>0->loc = @$;
 				$<chain>0->hook.loc = @5;
@@ -2772,6 +2767,11 @@ hook_spec		:	TYPE		close_scope_type	STRING		HOOK		STRING		dev_spec	prio_spec
 			}
 			;
 
+chain_type		:	FILTER	{ $$ = xstrdup("filter"); }
+			|	NAT	{ $$ = xstrdup("nat"); }
+			|	ROUTE	{ $$ = xstrdup("route"); }
+			;
+
 prio_spec		:	PRIORITY extended_prio_spec
 			{
 				$$ = $2;
diff --git a/src/rule.c b/src/rule.c
index dabc16204f108..c32e08319d149 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -676,25 +676,6 @@ struct symbol *symbol_lookup_fuzzy(const struct scope *scope,
 	return st.obj;
 }
 
-static const char * const chain_type_str_array[] = {
-	"filter",
-	"nat",
-	"route",
-	NULL,
-};
-
-const char *chain_type_name_lookup(const char *name)
-{
-	int i;
-
-	for (i = 0; chain_type_str_array[i]; i++) {
-		if (!strcmp(name, chain_type_str_array[i]))
-			return chain_type_str_array[i];
-	}
-
-	return NULL;
-}
-
 static const char * const chain_hookname_str_array[] = {
 	"prerouting",
 	"input",
diff --git a/src/scanner.l b/src/scanner.l
index 99ace05773816..b397a147ef9bd 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -858,6 +858,12 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"out"			{ return OUT; }
 }
 
+<SCANSTATE_TYPE>{
+	"filter"		{ return FILTER; }
+	"nat"			{ return NAT; }
+	"route"			{ return ROUTE; }
+}
+
 "secmark"		{ scanner_push_start_cond(yyscanner, SCANSTATE_SECMARK); return SECMARK; }
 
 "xt"			{ scanner_push_start_cond(yyscanner, SCANSTATE_XT); return XT; }
-- 
2.51.0

