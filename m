Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2819E30B529
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Nov 2025 15:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764170044; cv=none; b=MWKnva/iv2wyUs13HU6nEEOGJnh+sSvnQyvH67q4Xusu1ew9+st277MTIlIFGQXAki44G13OXwQvbGfTiWe90qtWMf4M13DwAfwm2/JwHnAEQ/vpLZd3CNeondSdx5W3UEy6P55tGufVyLpf5N4iF1tgAczpgXdUq2Bx1gnnKsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764170044; c=relaxed/simple;
	bh=90WQ7eKU48BfUBL7pHOxikptggGMlHSrvUlgAAoOQj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GCxioa1waYUXYmbPAfus+G90q9PCtzWhL+daHduKIksFTk7wwwt6RgcW6tbTneuMVh3UIjRZ9hiF09Wwv1qeuwHuTbFgqn+n/DoknGMtbFGHNJiofD2Q9VoV6sPwoyyBNVOLE8Ahyj2nGgF6MfXDLpGTW9as595AfN7P7Gddu3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=fkHHC8JA; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="fkHHC8JA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=96ka3+L7fJeEXfvLiBUISgz0PHhx+uI5HgjUO0KXbFU=; b=fkHHC8JAhf7TCjTjcVTIcfty02
	dz9cw/a1tI9Q+QW/MZP0+U6KojSBZ0wCVxUWEYTklb5Ba1JsoI0DBxbwjh6qrhXl5kIbJaVpAaKry
	zvkBD+MyVyok+MtVTcJd+gJqQSXEk7NpjJ945coED79K12RbHMUOqSdAo9TTSpNCY4u7syryc81dh
	LwEkU117e8eEDeeaTLRWwoNM5JjhKPXbS3dz5a2KnUeIpHAM6uSms3/fEYhbN/K4/Uq7ch1HeKaoe
	L0w0D2Hts8RoIuUvRIoRntHnmLmNCmkGPKJWz+rFVnUsxsDAmjyXQ8S89MevLqXg1874l50WFRyok
	GwKsxQdg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vOHDL-000000001A8-2ERu;
	Wed, 26 Nov 2025 16:13:51 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [nft PATCH RFC 4/6] parser_bison: Introduce tokens for log levels
Date: Wed, 26 Nov 2025 16:13:44 +0100
Message-ID: <20251126151346.1132-5-phil@nwl.cc>
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

Since log statement is scoped already, it's just a matter of declaring
the tokens in that scope and using them. This eliminates the redundant
copy of log level string parsing in parser_bison.y - the remaining one,
namely log_level_parse() in statement.c is used by JSON parser.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_bison.y | 46 ++++++++++++++++++----------------------------
 src/scanner.l      |  9 +++++++++
 2 files changed, 27 insertions(+), 28 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index a190cbbbd6dee..91a03f78c611a 100644
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

