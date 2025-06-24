Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836A026CE0D
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Jun 2025 16:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750783100; cv=none; b=KDT2YJ3Yc/7L1vkHI4gUu4ailgT7bw07ERBuSPgBGwig0fNRwJxfgCqht98DfyXBfj6on6+v8UPjlmqjpHtdPHY9Xl83dSBX77igcjX6/Eo1/J7zr/1YnRfD1VtTIaqM8yAE6idJ+01eJoWcsQ/0acVl7suO12XkVtyuamZf1sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750783100; c=relaxed/simple;
	bh=9cbu+rYBcAvw191H5FTSI8juCoAUDy0JjpuvVQklt74=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=i0+CE4fi9GjYCmIBNiaEiGNVp6RDnTpGkJUYMV1lOfMSHM4bxa0HNlkEVO7uuvKDEwhXUvSf8+Q5mIjJqrQMNv7iMnzeGUFLw5NUkzd28d6B+35BVImJlDbgvQet9epgfBxtnMh7DBwefP/o6ZqMguBf1Goe1G50Cudwadm7e88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DHGL783I; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RdUgSdOC; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DHGL783I";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RdUgSdOC"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 50B0C60265; Tue, 24 Jun 2025 18:38:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750783088;
	bh=GSUQEMb0egKqqg9PGmU/HpNDFNO+suKYrM2k4VrKQww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DHGL783Ip7xICqmQHYQPKr6LBmkEy+SWk0/Nk4bTysmDfBRq6ZHjN6CWBMLYKM3Qy
	 0QD2r6o7nvmlZEHF1wNSQSL2Ag9pR8bH+YnMwupNjMfrWMYpSKzT0iDBS6/cbGVGHX
	 vU+PLBzVDPILw11yHLGQKQ39dXmXnYLD9Mux44B1Qv1lF46kxow05tahn32qT+DheM
	 nf0mRJgwGu/DTBPreubkKU394zSKXt4qerlIprGL1cJQuBWtEcrAbYThIKXxAwl+RZ
	 vfaLdaHaIDgB3FFQ+hfqDmNv2FBFqLVp2ZBU73nO1rBxeLkOfnfeWzH5djlbKIliD1
	 LPVLGsnfEM0TQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 32DC260264;
	Tue, 24 Jun 2025 18:38:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750783087;
	bh=GSUQEMb0egKqqg9PGmU/HpNDFNO+suKYrM2k4VrKQww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RdUgSdOChvpPkCvCjwTneSD0IPssboxNV5HelxnPYSaS0SDBhTsGQlbDdl5Ut9dne
	 MYskOTaG3IipD02B/kR7RcYveCVFkQSFkGOyJyiEBhhHCgThix4oOWJ35H9OBA3Quw
	 F3pjTjvQD2LJii+dFcIcR1Gzug6hRe6C4tqzzrlbYs9yHKDwVG/oFrj1QtlVkwQYzf
	 lhf0/HCXGLYobobIzNGgTAQWd8oaM/pHgKSMoP3lxAzgg/AuzPs+WW4PvuN6hdDnDV
	 DdzdZAZ9lu/pAwrPweiSCnU7D7mnOXcw3OIvVkcsVMSDNyHRwTf+3bC0Hpwabu2dsh
	 iePR4FWlc72zg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	phil@nwl.cc
Subject: [PATCH nft 1/2] fib: allow to check if route exists in maps
Date: Tue, 24 Jun 2025 18:38:00 +0200
Message-Id: <20250624163801.215307-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250624163801.215307-1-pablo@netfilter.org>
References: <20250624163801.215307-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

f686a17eafa0 ("fib: Support existence check") adds EXPR_F_BOOLEAN as a
workaround to infer from the rhs of the relational expression if the fib
lookup wants to check for a specific output interface or, instead,
simply check for existence. This, however, does not work with maps.

The NFT_FIB_F_PRESENT flag can be used both with NFT_FIB_RESULT_OIF and
NFT_FIB_RESULT_OFINAME, my understanding is that they serve the same
purpose which is to check if a route exists, so they are redundant.

Add a 'check' fib result to check for routes while still keeping the
inference workaround for backward compatibility, but prefer the new
syntax in the listing.

Update man nft(8) and tests/py.

Fixes: f686a17eafa0 ("fib: Support existence check")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/data-types.txt          |  2 +-
 doc/primary-expression.txt  |  5 ++++-
 include/fib.h               |  2 +-
 src/fib.c                   | 12 ++++++++++--
 src/json.c                  |  2 +-
 src/parser_bison.y          | 21 +++++++++++++++------
 src/scanner.l               |  4 ++++
 tests/py/inet/fib.t         |  6 ++++--
 tests/py/inet/fib.t.payload |  8 +++++++-
 9 files changed, 47 insertions(+), 15 deletions(-)

diff --git a/doc/data-types.txt b/doc/data-types.txt
index 6c0e2f9420fe..46b0867cb5a4 100644
--- a/doc/data-types.txt
+++ b/doc/data-types.txt
@@ -166,7 +166,7 @@ Check TCP option header existence.
 .Boolean specification
 ----------------------
 # match if route exists
-filter input fib daddr . iif oif exists
+filter input fib daddr . iif check exists
 
 # match only non-fragmented packets in IPv6 traffic
 filter input exthdr frag missing
diff --git a/doc/primary-expression.txt b/doc/primary-expression.txt
index 40aca3d3fcf6..ea231fe57f7b 100644
--- a/doc/primary-expression.txt
+++ b/doc/primary-expression.txt
@@ -312,7 +312,7 @@ FIB EXPRESSIONS
 [verse]
 *fib* 'FIB_TUPLE' 'FIB_RESULT'
 'FIB_TUPLE' := { *saddr* | *daddr*} [ *.* { *iif* | *oif* } *.* *mark* ]
-'FIB_RESULT'  := { *oif* | *oifname* | *type* }
+'FIB_RESULT'  := { *oif* | *oifname* | *check* | *type* }
 
 
 A fib expression queries the fib (forwarding information base) to obtain information
@@ -355,6 +355,9 @@ address types can be shown with *nft* *describe* *fib_addrtype*.
 |oif|
 Output interface index|
 iface_index
+|check|
+Output interface check|
+boolean
 |oifname|
 Output interface name|
 ifname
diff --git a/include/fib.h b/include/fib.h
index 67edccfea0d5..07bb2210d223 100644
--- a/include/fib.h
+++ b/include/fib.h
@@ -3,7 +3,7 @@
 
 #include <linux/netfilter/nf_tables.h>
 
-extern const char *fib_result_str(enum nft_fib_result result);
+extern const char *fib_result_str(const struct expr *expr);
 extern struct expr *fib_expr_alloc(const struct location *loc,
 				   unsigned int flags,
 				   unsigned int result);
diff --git a/src/fib.c b/src/fib.c
index 5a7c1170b240..e28c52243f42 100644
--- a/src/fib.c
+++ b/src/fib.c
@@ -53,8 +53,16 @@ const struct datatype fib_addr_type = {
 	.sym_tbl	= &addrtype_tbl,
 };
 
-const char *fib_result_str(enum nft_fib_result result)
+const char *fib_result_str(const struct expr *expr)
 {
+	enum nft_fib_result result = expr->fib.result;
+	uint32_t flags = expr->fib.flags;
+
+	/* Exception: check if route exists. */
+	if (result == NFT_FIB_RESULT_OIF &&
+	    flags & NFTA_FIB_F_PRESENT)
+		return "check";
+
 	if (result <= NFT_FIB_RESULT_MAX)
 		return fib_result[result];
 
@@ -87,7 +95,7 @@ static void fib_expr_print(const struct expr *expr, struct output_ctx *octx)
 	if (flags)
 		nft_print(octx, "0x%x", flags);
 
-	nft_print(octx, " %s", fib_result_str(expr->fib.result));
+	nft_print(octx, " %s", fib_result_str(expr));
 }
 
 static bool fib_expr_cmp(const struct expr *e1, const struct expr *e2)
diff --git a/src/json.c b/src/json.c
index 5bd5daf3f7fa..f0430776851c 100644
--- a/src/json.c
+++ b/src/json.c
@@ -938,7 +938,7 @@ json_t *fib_expr_json(const struct expr *expr, struct output_ctx *octx)
 	unsigned int flags = expr->fib.flags & ~NFTA_FIB_F_PRESENT;
 	json_t *root;
 
-	root = nft_json_pack("{s:s}", "result", fib_result_str(expr->fib.result));
+	root = nft_json_pack("{s:s}", "result", fib_result_str(expr));
 
 	if (flags) {
 		json_t *tmp = json_array();
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 9278b67a2931..e1afbbb6e56e 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -284,6 +284,7 @@ int nft_lex(void *, void *, void *);
 %token UNDEFINE			"undefine"
 
 %token FIB			"fib"
+%token CHECK			"check"
 
 %token SOCKET			"socket"
 %token TRANSPARENT		"transparent"
@@ -4360,30 +4361,38 @@ primary_expr		:	symbol_expr			{ $$ = $1; }
 
 fib_expr		:	FIB	fib_tuple	fib_result	close_scope_fib
 			{
-				if (($2 & (NFTA_FIB_F_SADDR|NFTA_FIB_F_DADDR)) == 0) {
+				uint32_t flags = $2, result = $3;
+
+				if (result == __NFT_FIB_RESULT_MAX) {
+					result = NFT_FIB_RESULT_OIF;
+					flags |= NFTA_FIB_F_PRESENT;
+				}
+
+				if ((flags & (NFTA_FIB_F_SADDR|NFTA_FIB_F_DADDR)) == 0) {
 					erec_queue(error(&@2, "fib: need either saddr or daddr"), state->msgs);
 					YYERROR;
 				}
 
-				if (($2 & (NFTA_FIB_F_SADDR|NFTA_FIB_F_DADDR)) ==
-					  (NFTA_FIB_F_SADDR|NFTA_FIB_F_DADDR)) {
+				if ((flags & (NFTA_FIB_F_SADDR|NFTA_FIB_F_DADDR)) ==
+					     (NFTA_FIB_F_SADDR|NFTA_FIB_F_DADDR)) {
 					erec_queue(error(&@2, "fib: saddr and daddr are mutually exclusive"), state->msgs);
 					YYERROR;
 				}
 
-				if (($2 & (NFTA_FIB_F_IIF|NFTA_FIB_F_OIF)) ==
-					  (NFTA_FIB_F_IIF|NFTA_FIB_F_OIF)) {
+				if ((flags & (NFTA_FIB_F_IIF|NFTA_FIB_F_OIF)) ==
+					     (NFTA_FIB_F_IIF|NFTA_FIB_F_OIF)) {
 					erec_queue(error(&@2, "fib: iif and oif are mutually exclusive"), state->msgs);
 					YYERROR;
 				}
 
-				$$ = fib_expr_alloc(&@$, $2, $3);
+				$$ = fib_expr_alloc(&@$, flags, result);
 			}
 			;
 
 fib_result		:	OIF	{ $$ =NFT_FIB_RESULT_OIF; }
 			|	OIFNAME { $$ =NFT_FIB_RESULT_OIFNAME; }
 			|	TYPE	close_scope_type	{ $$ =NFT_FIB_RESULT_ADDRTYPE; }
+			|	CHECK	{ $$ = __NFT_FIB_RESULT_MAX; }	/* actually, NFT_FIB_F_PRESENT. */
 			;
 
 fib_flag		:       SADDR	{ $$ = NFTA_FIB_F_SADDR; }
diff --git a/src/scanner.l b/src/scanner.l
index 4787cc12f993..b69d8e81fd8c 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -795,6 +795,10 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "fib"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_FIB); return FIB; }
 
+<SCANSTATE_EXPR_FIB>{
+	"check"		{ return CHECK; }
+}
+
 "osf"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_OSF); return OSF; }
 
 "synproxy"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_SYNPROXY); return SYNPROXY; }
diff --git a/tests/py/inet/fib.t b/tests/py/inet/fib.t
index dbe45d95b4cf..f9c03b3ad2be 100644
--- a/tests/py/inet/fib.t
+++ b/tests/py/inet/fib.t
@@ -13,5 +13,7 @@ fib daddr . iif type local;ok
 fib daddr . iif type vmap { blackhole : drop, prohibit : drop, unicast : accept };ok
 fib daddr . oif type local;fail
 
-fib daddr oif exists;ok
-fib daddr oif missing;ok
+fib daddr check missing;ok
+fib daddr oif exists;ok;fib daddr check exists
+
+fib daddr check vmap { missing : drop, exists : accept };ok
diff --git a/tests/py/inet/fib.t.payload b/tests/py/inet/fib.t.payload
index 050857d96994..e09a260cc41e 100644
--- a/tests/py/inet/fib.t.payload
+++ b/tests/py/inet/fib.t.payload
@@ -26,7 +26,13 @@ ip test-ip prerouting
   [ fib daddr oif present => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
-# fib daddr oif missing
+# fib daddr check missing
 ip test-ip prerouting
   [ fib daddr oif present => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
+
+# fib daddr check vmap { missing : drop, exists : accept }
+        element 00000000  : drop 0 [end]        element 00000001  : accept 0 [end]
+ip test-ip prerouting
+  [ fib daddr oif present => reg 1 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
-- 
2.30.2

