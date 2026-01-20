Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7DA43E9FF
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Jan 2026 19:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768936414; cv=none; b=BAQXOcQe/yn4fnJFofesXhM4UauHM4Z+QB2OM5Llx4EQ3auH8fhvKUmHC0+rjcykWJ7EJsre3/na9i6LaqlTwxiIE/qTzZ8zD4kJpd4koxp9fhQ3/h60VAm2RbyUcR2oU8IB17RU/toPfyuRnTOIIjaNt3gGUDvhTQB8nkUMZ2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768936414; c=relaxed/simple;
	bh=ypn61WmiY797tqs8eQJ/21k9LwHu2TkB207u/nAW02k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Tob8a+X6DH+FyapWlF/Eu9k0YgWkm15Deubu0AV+cm4dT8eQXHsoW5NzBZAwuYtJzodXTk6/cwNHvks/ydTzBlPFNZ2MaNkfLFjro52m0U8sUIZ/XhjtfYc2/y6sS4HsYENbpinwgBNg02WSjuPdgekRBa54gxUVPeg3TQsCTPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E7C50602AB; Tue, 20 Jan 2026 20:13:29 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] parser: move qualified meta expression parsing to flex/bison
Date: Tue, 20 Jan 2026 20:13:16 +0100
Message-ID: <20260120191319.21383-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The meta keyword currently accepts 'STRING' arguments.
This was originally done to avoid pollution the global token namespace.

However, nowadays we do have flex scopes to avoid this.
Add the tokens currently handled implciitly via STRING within
META flex scope.

SECPATH is a compatibility alias, map this to IPSEC token.
IBRPORT/OBRPORT are also compatibility aliases, remove those tokens
and handle this directly in scanner.l.

This also avoids nft from printing tokens in help texts that are only
there for compatibility with old rulesets.

meta_key_parse() is retained for json input parser.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/libnftables-json.adoc |  2 +-
 src/parser_bison.y        | 54 +++++++++++++++------------------------
 src/scanner.l             | 19 ++++++++++++--
 3 files changed, 39 insertions(+), 36 deletions(-)

diff --git a/doc/libnftables-json.adoc b/doc/libnftables-json.adoc
index 049c3254ff03..c3af007e1917 100644
--- a/doc/libnftables-json.adoc
+++ b/doc/libnftables-json.adoc
@@ -1269,7 +1269,7 @@ ____
 'META_KEY' := *"length"* | *"protocol"* | *"priority"* | *"random"* | *"mark"* |
               *"iif"* | *"iifname"* | *"iiftype"* | *"oif"* | *"oifname"* |
 	      *"oiftype"* | *"skuid"* | *"skgid"* | *"nftrace"* |
-	      *"rtclassid"* | *"ibriport"* | *"obriport"* | *"ibridgename"* |
+	      *"rtclassid"* | *"ibrname"* | *"obrname"* | *"ibridgename"* |
 	      *"obridgename"* | *"pkttype"* | *"cpu"* | *"iifgroup"* |
 	      *"oifgroup"* | *"cgroup"* | *"nfproto"* | *"l4proto"* |
 	      *"secpath"*
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 33e2e3eaea73..74c3d25db4ff 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -584,8 +584,6 @@ int nft_lex(void *, void *, void *);
 %token SKGID			"skgid"
 %token NFTRACE			"nftrace"
 %token RTCLASSID		"rtclassid"
-%token IBRIPORT			"ibriport"
-%token OBRIPORT			"obriport"
 %token IBRIDGENAME		"ibrname"
 %token OBRIDGENAME		"obrname"
 %token PKTTYPE			"pkttype"
@@ -595,6 +593,17 @@ int nft_lex(void *, void *, void *);
 %token CGROUP			"cgroup"
 %token TIME			"time"
 
+%token NFPROTO			"nfproto"
+%token L4PROTO			"l4proto"
+%token IIFKIND			"iifkind"
+%token OIFKIND			"oifkind"
+%token IBRPVID			"ibrpvid"
+%token IBRVPROTO		"ibrvproto"
+%token SDIF			"sdif"
+%token SDIFNAME			"sdifname"
+%token BROUTE			"broute"
+%token BRIFHWADDR		"ibrhwaddr"
+
 %token CLASSID			"classid"
 %token NEXTHOP			"nexthop"
 
@@ -5421,20 +5430,6 @@ meta_expr		:	META	meta_key	close_scope_meta
 			{
 				$$ = meta_expr_alloc(&@$, $1);
 			}
-			|	META	STRING	close_scope_meta
-			{
-				struct error_record *erec;
-				unsigned int key;
-
-				erec = meta_key_parse(&@$, $2, &key);
-				free_const($2);
-				if (erec != NULL) {
-					erec_queue(erec, state->msgs);
-					YYERROR;
-				}
-
-				$$ = meta_expr_alloc(&@$, key);
-			}
 			;
 
 meta_key		:	meta_key_qualified
@@ -5446,6 +5441,16 @@ meta_key_qualified	:	LENGTH		{ $$ = NFT_META_LEN; }
 			|	PRIORITY	{ $$ = NFT_META_PRIORITY; }
 			|	RANDOM		{ $$ = NFT_META_PRANDOM; }
 			|	SECMARK	close_scope_secmark { $$ = NFT_META_SECMARK; }
+			|	NFPROTO		{ $$ = NFT_META_NFPROTO; }
+			|	L4PROTO		{ $$ = NFT_META_L4PROTO; }
+			|	IIFKIND		{ $$ = NFT_META_IIFKIND; }
+			|	OIFKIND		{ $$ = NFT_META_OIFKIND; }
+			|	IBRPVID		{ $$ = NFT_META_BRI_IIFPVID; }
+			|	IBRVPROTO	{ $$ = NFT_META_BRI_IIFVPROTO; }
+			|	SDIF		{ $$ = NFT_META_SDIF; }
+			|	SDIFNAME	{ $$ = NFT_META_SDIFNAME; }
+			|	BROUTE		{ $$ = NFT_META_BRI_BROUTE; }
+			|	BRIFHWADDR	{ $$ = NFT_META_BRI_IIFHWADDR; }
 			;
 
 meta_key_unqualified	:	MARK		{ $$ = NFT_META_MARK; }
@@ -5459,8 +5464,6 @@ meta_key_unqualified	:	MARK		{ $$ = NFT_META_MARK; }
 			|	SKGID		{ $$ = NFT_META_SKGID; }
 			|	NFTRACE		{ $$ = NFT_META_NFTRACE; }
 			|	RTCLASSID	{ $$ = NFT_META_RTCLASSID; }
-			|	IBRIPORT	{ $$ = NFT_META_BRI_IIFNAME; }
-			|       OBRIPORT	{ $$ = NFT_META_BRI_OIFNAME; }
 			|	IBRIDGENAME	{ $$ = NFT_META_BRI_IIFNAME; }
 			|       OBRIDGENAME	{ $$ = NFT_META_BRI_OIFNAME; }
 			|       PKTTYPE		{ $$ = NFT_META_PKTTYPE; }
@@ -5498,21 +5501,6 @@ meta_stmt		:	META	meta_key	SET	stmt_expr	close_scope_meta
 			{
 				$$ = meta_stmt_alloc(&@$, $1, $3);
 			}
-			|	META	STRING	SET	stmt_expr	close_scope_meta
-			{
-				struct error_record *erec;
-				unsigned int key;
-
-				erec = meta_key_parse(&@$, $2, &key);
-				free_const($2);
-				if (erec != NULL) {
-					erec_queue(erec, state->msgs);
-					expr_free($4);
-					YYERROR;
-				}
-
-				$$ = meta_stmt_alloc(&@$, key, $4);
-			}
 			|	NOTRACK
 			{
 				$$ = notrack_stmt_alloc(&@$);
diff --git a/src/scanner.l b/src/scanner.l
index 9d8fade8308d..1b4eb1cf13a4 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -754,15 +754,30 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "skgid"			{ return SKGID; }
 "nftrace"		{ return NFTRACE; }
 "rtclassid"		{ return RTCLASSID; }
-"ibriport"		{ return IBRIPORT; }
+"ibriport"		{ return IBRIDGENAME; } /* backwards compat */
 "ibrname"		{ return IBRIDGENAME; }
-"obriport"		{ return OBRIPORT; }
+"obriport"		{ return OBRIDGENAME; }	/* backwards compat */
 "obrname"		{ return OBRIDGENAME; }
 "pkttype"		{ return PKTTYPE; }
 "cpu"			{ return CPU; }
 "iifgroup"		{ return IIFGROUP; }
 "oifgroup"		{ return OIFGROUP; }
 "cgroup"		{ return CGROUP; }
+<SCANSTATE_META>{
+	"nfproto"	{ return NFPROTO; }
+	"l4proto"	{ return L4PROTO; }
+	"iifkind"	{ return IIFKIND; }
+	"oifkind"	{ return OIFKIND; }
+	"ibrpvid"	{ return IBRPVID; }
+	"ibrvproto"	{ return IBRVPROTO; }
+	"sdif"		{ return SDIF; }
+	"sdifname"	{ return SDIFNAME; }
+	"broute"	{ return BROUTE; }
+	"ibrhwaddr"	{ return BRIFHWADDR; }
+
+	/* backwards compat */
+	"secpath"	{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_IPSEC); return IPSEC; }
+}
 
 <SCANSTATE_EXPR_RT>{
 	"nexthop"		{ return NEXTHOP; }
-- 
2.52.0

