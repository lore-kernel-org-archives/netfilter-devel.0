Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821B830F55B
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Nov 2025 15:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764170047; cv=none; b=D5Rlw5FJHeObgnl/TrSQbmc4iY1JdQJDmOcfVCD1Pm92PFAiqkY8pBIvtW3tJDbrCj062My8p+VdBxDdiLC1hffXfysZoJVxcRlCEvyGyRSdHrWV3e9tvDORKWa047MRog7DNecSehT2CXPTlia+GZug8ljreioKeZzb1aBiYnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764170047; c=relaxed/simple;
	bh=Iv9cBfSpg4sU8vmsKuC3WfxemlBfgcmD1HTZHPUgzGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UNegS5MonSxeixcqHKjqMd3n/pcLZJb7riNS6Ajx2lvWKm+fD5CXauMja60/9vl7TMuISkUlqpPTxjJElozee8aH6C/Pfpg+WAiD7e7ZshugbMaUJCfNPJNPGkRob8OSfcCYNXVPSIDc+DfezU2IE2QOVuoj33tJmF9MLEfHxok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=pD8kBiiU; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="pD8kBiiU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=TYiUk9OeUqMfYbjvySdfkOes5or80AWF3f6246/l10s=; b=pD8kBiiUUSza2Lw0sssNPMiUf0
	Y8lyq/kniAGvn1TzB715FbLc//7jOIEvMZ5268Y5PCs1Ill0UU+RUeEG7lGp4zcLWlyd7ticUtWIT
	u2e0CPfmB5X51ZXyvB44vip8ituDlyT/WNip8G7yihSYX3mn6p32u4qjY6/5BIJU5+Jum16qnuDaB
	LPBcbq3Yz3VbK2jEITcihv8dxTq6dm/vFa3RjFviT3kCyxNOgMzjQwOyM1qpdGhPACruNYZplfBrZ
	+3Qdp2141i1AP4MIVROd6ZwRzSsEALymrB84jY1bMSBI36iVoVfiDOPe4Ik8zs1b5bltDqO61j+aC
	YI2Rk6Dg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vOHDN-000000001AT-3rkA;
	Wed, 26 Nov 2025 16:13:54 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [nft PATCH RFC 5/6] parser_bison: Introduce bytes_unit
Date: Wed, 26 Nov 2025 16:13:45 +0100
Message-ID: <20251126151346.1132-6-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251126151346.1132-1-phil@nwl.cc>
References: <20251126151346.1132-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce scoped tokens for "kbytes" and "mbytes", completing already
existing "bytes" one. Then generalize the unit for byte values and
replace both quota_unit and limit_bytes by a combination of NUM and
bytes_unit.

With this in place, data_unit_parse() is not called outside of
datatype.c, so make it static.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/datatype.h |  3 --
 src/datatype.c     |  4 +--
 src/parser_bison.y | 75 +++++++++++-----------------------------------
 src/scanner.l      |  2 ++
 4 files changed, 22 insertions(+), 62 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 4fb47f158fc2f..63dba330137a0 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -313,9 +313,6 @@ extern struct error_record *rate_parse(const struct location *loc,
 				       const char *str, uint64_t *rate,
 				       uint64_t *unit);
 
-extern struct error_record *data_unit_parse(const struct location *loc,
-					    const char *str, uint64_t *rate);
-
 struct limit_rate {
 	uint64_t rate, unit;
 };
diff --git a/src/datatype.c b/src/datatype.c
index fac4eb9cdcecd..1950a2f3757b8 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1507,8 +1507,8 @@ static struct error_record *time_unit_parse(const struct location *loc,
 	return NULL;
 }
 
-struct error_record *data_unit_parse(const struct location *loc,
-				     const char *str, uint64_t *rate)
+static struct error_record *data_unit_parse(const struct location *loc,
+					    const char *str, uint64_t *rate)
 {
 	if (strcmp(str, "bytes") == 0)
 		*rate = 1ULL;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 91a03f78c611a..a7e5ace067bf5 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -617,6 +617,8 @@ int nft_lex(void *, void *, void *);
 %token NAME			"name"
 %token PACKETS			"packets"
 %token BYTES			"bytes"
+%token KBYTES			"kbytes"
+%token MBYTES			"mbytes"
 %token AVGPKT			"avgpkt"
 
 %token LAST			"last"
@@ -774,8 +776,8 @@ int nft_lex(void *, void *, void *);
 %type <prio_spec>		extended_prio_spec prio_spec
 %destructor { expr_free($$.expr); } extended_prio_spec prio_spec
 
-%type <string>			extended_prio_name quota_unit	basehook_device_name
-%destructor { free_const($$); }	extended_prio_name quota_unit	basehook_device_name
+%type <string>			extended_prio_name basehook_device_name
+%destructor { free_const($$); }	extended_prio_name basehook_device_name
 
 %type <expr>			dev_spec
 %destructor { free($$); }	dev_spec
@@ -828,7 +830,7 @@ int nft_lex(void *, void *, void *);
 %type <val>			level_type log_flags log_flags_tcp log_flag_tcp
 %type <stmt>			limit_stmt quota_stmt connlimit_stmt
 %destructor { stmt_free($$); }	limit_stmt quota_stmt connlimit_stmt
-%type <val>			limit_burst_pkts limit_burst_bytes limit_mode limit_bytes time_unit quota_mode
+%type <val>			limit_burst_pkts limit_burst_bytes limit_mode bytes_unit time_unit quota_mode
 %type <stmt>			reject_stmt reject_stmt_alloc
 %destructor { stmt_free($$); }	reject_stmt reject_stmt_alloc
 %type <stmt>			nat_stmt nat_stmt_alloc masq_stmt masq_stmt_alloc redir_stmt redir_stmt_alloc
@@ -3596,23 +3598,15 @@ quota_mode		:	OVER		{ $$ = NFT_QUOTA_F_INV; }
 			|	/* empty */	{ $$ = 0; }
 			;
 
-quota_unit		:	BYTES		{ $$ = xstrdup("bytes"); }
-			|	STRING		{ $$ = $1; }
+bytes_unit		:	BYTES		{ $$ = 1; }
+			|	KBYTES		{ $$ = 1024; }
+			|	MBYTES		{ $$ = 1024 * 1024; }
 			;
 
 quota_used		:	/* empty */	{ $$ = 0; }
-			|	USED NUM quota_unit
+			|	USED NUM bytes_unit
 			{
-				struct error_record *erec;
-				uint64_t rate;
-
-				erec = data_unit_parse(&@$, $3, &rate);
-				free_const($3);
-				if (erec != NULL) {
-					erec_queue(erec, state->msgs);
-					YYERROR;
-				}
-				$$ = $2 * rate;
+				$$ = $2 * $3;
 			}
 			;
 
@@ -3625,22 +3619,14 @@ quota_stmt_alloc	:	QUOTA
 quota_stmt		:	quota_stmt_alloc quota_args
 			;
 
-quota_args		:	quota_mode NUM quota_unit quota_used
+quota_args		:	quota_mode NUM bytes_unit quota_used
 			{
-				struct error_record *erec;
 				struct quota_stmt *quota;
-				uint64_t rate;
 
 				assert($<stmt>0->type == STMT_QUOTA);
 
-				erec = data_unit_parse(&@$, $3, &rate);
-				free_const($3);
-				if (erec != NULL) {
-					erec_queue(erec, state->msgs);
-					YYERROR;
-				}
 				quota = &$<stmt>0->quota;
-				quota->bytes = $2 * rate;
+				quota->bytes = $2 * $3;
 				quota->used = $4;
 				quota->flags = $1;
 			}
@@ -3663,7 +3649,7 @@ limit_rate_pkts		:	NUM     SLASH	time_unit
 			;
 
 limit_burst_bytes	:	/* empty */			{ $$ = 0; }
-			|	BURST	limit_bytes		{ $$ = $2; }
+			|	BURST	NUM	bytes_unit	{ $$ = $2 * $3; }
 			;
 
 limit_rate_bytes	:	NUM     STRING
@@ -3680,26 +3666,10 @@ limit_rate_bytes	:	NUM     STRING
 				$$.rate = rate * $1;
 				$$.unit = unit;
 			}
-			|	limit_bytes SLASH time_unit
+			|	NUM bytes_unit SLASH time_unit
 			{
-				$$.rate = $1;
-				$$.unit = $3;
-			}
-			;
-
-limit_bytes		:	NUM	BYTES		{ $$ = $1; }
-			|	NUM	STRING
-			{
-				struct error_record *erec;
-				uint64_t rate;
-
-				erec = data_unit_parse(&@$, $2, &rate);
-				free_const($2);
-				if (erec != NULL) {
-					erec_queue(erec, state->msgs);
-					YYERROR;
-				}
-				$$ = $1 * rate;
+				$$.rate = $1 * $2;
+				$$.unit = $4;
 			}
 			;
 
@@ -4767,21 +4737,12 @@ counter_obj		:	/* empty */
 			}
 			;
 
-quota_config		:	quota_mode NUM quota_unit quota_used
+quota_config		:	quota_mode NUM bytes_unit quota_used
 			{
-				struct error_record *erec;
 				struct quota *quota;
-				uint64_t rate;
-
-				erec = data_unit_parse(&@$, $3, &rate);
-				free_const($3);
-				if (erec != NULL) {
-					erec_queue(erec, state->msgs);
-					YYERROR;
-				}
 
 				quota = &$<obj>0->quota;
-				quota->bytes	= $2 * rate;
+				quota->bytes	= $2 * $3;
 				quota->used	= $4;
 				quota->flags	= $1;
 			}
diff --git a/src/scanner.l b/src/scanner.l
index ca570e2bfe066..4cbc8a44c89c8 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -414,6 +414,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 <SCANSTATE_COUNTER,SCANSTATE_LIMIT,SCANSTATE_QUOTA,SCANSTATE_STMT_SYNPROXY,SCANSTATE_EXPR_OSF,SCANSTATE_TUNNEL>"name"			{ return NAME; }
 <SCANSTATE_COUNTER,SCANSTATE_CT,SCANSTATE_LIMIT>"packets"		{ return PACKETS; }
 <SCANSTATE_COUNTER,SCANSTATE_CT,SCANSTATE_LIMIT,SCANSTATE_QUOTA>"bytes"	{ return BYTES; }
+<SCANSTATE_LIMIT,SCANSTATE_QUOTA>"kbytes"	{ return KBYTES; }
+<SCANSTATE_LIMIT,SCANSTATE_QUOTA>"mbytes"	{ return MBYTES; }
 
 "last"				{ scanner_push_start_cond(yyscanner, SCANSTATE_LAST); return LAST; }
 <SCANSTATE_LAST>{
-- 
2.51.0

