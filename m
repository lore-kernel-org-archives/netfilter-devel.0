Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA093002D3
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Dec 2025 16:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765298752; cv=none; b=QweR01EILWXjUpLDSG/1x+dQXAxAEndvh6n9H30ZIPR2SaAEzijaArnt0dMMUNihu0JQ0cLgQPsM0ubczaYs7Y1+Bn0YrCc/uJ+hNiHDwzBpEV8b5hBbYDLid3qwrTVlHCtCDurGjVru0HdpBaY3uTpEmSaiHvpzhx0xqsZtTLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765298752; c=relaxed/simple;
	bh=ihVJFv3nxlRU4dcz0bJPdssDEKGjviLy/kYRSkqZD60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yj7NUB75FKGA4f4sWvVYaMauT5AGIF1jFdb1x1bh6Fiu4K4zaqkqMwodQDPAr3B7+tBfqQDZwIli1WyLXNljeNLPZ6dDBfQsPqnAJuTClvfxGlimfHwiroJvvl+gKf3RzvNj9WIc6ay99YX8dyXnS8gCfl+vfvi2wvCzPCOGzjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=HEOG5HD3; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="HEOG5HD3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=J4UDFFyqYn/9KTG6+FbqKxX7YGSjb1PK/qs5CSJcvEA=; b=HEOG5HD34pJlEmSfmVWu/BRaBW
	MAppNT7QVQUK6AhDuvPAA6h3yr5i6cgmP16xoqI3unggkEMEVOY8IRflIGhzpITxcjtM5FMIMbuew
	0XI+Jlr90dKw6mXnKNPNRWZbA0rkEc6EXbcUeTfTWqJB5ShKjar0CJTdNCugJXtoxz5f95YyiY3qY
	eCtLF2Gxo65eM5WXaatuHDA1ZOsUAvOJ5Q26Wq5iAHSnZ6OJg88lwYYaTDeMV56G9roYzkq2WVEji
	k9bwIBsTM+tLz6JWCJaPqXIsM2HMQHFlO7g3OOfnjNYtH88eDtbrEfHdOoJWDniU9384nqwh77zFW
	u/IWzB5w==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vT0qS-000000007tm-1dOE;
	Tue, 09 Dec 2025 17:45:48 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [nft PATCH 4/6] parser_bison: Introduce tokens for log levels
Date: Tue,  9 Dec 2025 17:45:39 +0100
Message-ID: <20251209164541.13425-5-phil@nwl.cc>
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

Since log statement is scoped already, it's just a matter of declaring
the tokens in that scope and using them. This eliminates the redundant
copy of log level string parsing in parser_bison.y - the remaining one,
namely log_level_parse() in statement.c is used by JSON parser.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Reviewed-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y | 46 ++++++++++++++++++----------------------------
 src/scanner.l      |  9 +++++++++
 2 files changed, 27 insertions(+), 28 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index ba485a8c25b50..8e07671cb80e9 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -643,6 +643,15 @@ int nft_lex(void *, void *, void *);
 %token SNAPLEN			"snaplen"
 %token QUEUE_THRESHOLD		"queue-threshold"
 %token LEVEL			"level"
+%token EMERG			"emerg"
+%token ALERT			"alert"
+%token CRIT			"crit"
+%token ERR			"err"
+%token WARN			"warn"
+%token NOTICE			"notice"
+%token INFO			"info"
+%token DEBUG_TOKEN		"debug"
+%token AUDIT			"audit"
 
 %token LIMIT			"limit"
 %token RATE			"rate"
@@ -3490,34 +3499,15 @@ log_arg			:	PREFIX			string
 			}
 			;
 
-level_type		:	string
-			{
-				if (!strcmp("emerg", $1))
-					$$ = NFT_LOGLEVEL_EMERG;
-				else if (!strcmp("alert", $1))
-					$$ = NFT_LOGLEVEL_ALERT;
-				else if (!strcmp("crit", $1))
-					$$ = NFT_LOGLEVEL_CRIT;
-				else if (!strcmp("err", $1))
-					$$ = NFT_LOGLEVEL_ERR;
-				else if (!strcmp("warn", $1))
-					$$ = NFT_LOGLEVEL_WARNING;
-				else if (!strcmp("notice", $1))
-					$$ = NFT_LOGLEVEL_NOTICE;
-				else if (!strcmp("info", $1))
-					$$ = NFT_LOGLEVEL_INFO;
-				else if (!strcmp("debug", $1))
-					$$ = NFT_LOGLEVEL_DEBUG;
-				else if (!strcmp("audit", $1))
-					$$ = NFT_LOGLEVEL_AUDIT;
-				else {
-					erec_queue(error(&@1, "invalid log level"),
-						   state->msgs);
-					free_const($1);
-					YYERROR;
-				}
-				free_const($1);
-			}
+level_type		:	EMERG		{ $$ = NFT_LOGLEVEL_EMERG; }
+			|	ALERT		{ $$ = NFT_LOGLEVEL_ALERT; }
+			|	CRIT		{ $$ = NFT_LOGLEVEL_CRIT; }
+			|	ERR		{ $$ = NFT_LOGLEVEL_ERR; }
+			|	WARN		{ $$ = NFT_LOGLEVEL_WARNING; }
+			|	NOTICE		{ $$ = NFT_LOGLEVEL_NOTICE; }
+			|	INFO		{ $$ = NFT_LOGLEVEL_INFO; }
+			|	DEBUG_TOKEN	{ $$ = NFT_LOGLEVEL_DEBUG; }
+			|	AUDIT		{ $$ = NFT_LOGLEVEL_AUDIT; }
 			;
 
 log_flags		:	TCP	log_flags_tcp	close_scope_tcp
diff --git a/src/scanner.l b/src/scanner.l
index e0f0aabb683a3..ca570e2bfe066 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -433,6 +433,15 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"queue-threshold"	{ return QUEUE_THRESHOLD; }
 	"level"			{ return LEVEL; }
 	"group"			{ return GROUP; }
+	"emerg"			{ return EMERG; }
+	"alert"			{ return ALERT; }
+	"crit"			{ return CRIT; }
+	"err"			{ return ERR; }
+	"warn"			{ return WARN; }
+	"notice"		{ return NOTICE; }
+	"info"			{ return INFO; }
+	"debug"			{ return DEBUG_TOKEN; }
+	"audit"			{ return AUDIT; }
 }
 
 "queue"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_QUEUE); return QUEUE;}
-- 
2.51.0

