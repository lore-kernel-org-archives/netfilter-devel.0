Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCD8329C4E
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Dec 2025 16:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765298752; cv=none; b=In+k4HgAOjC0okl/DaLNTMvkstDwmD372nbZfV8XaDOW9oLu8acAWk15aVPMdvHTtJhSPsAc4F/zH2OiU5PX/fCinfgjJmo5tck/p6FetC/sJFAyWd8oz5ZyJADgHH0jIgMpmwgHCHC7ul7dqvdDA6MtQVIgZStdGrxvxwEn7k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765298752; c=relaxed/simple;
	bh=rOYTK204+DKfSGllOBtKRjRitUV+/QdObgy+JobhpXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QocvmQqsI83Z9xtekGWRTucWcCW1QO+bpoXyhZv2jcLtEHR7+hC0vzKiHpaS+wAcYsSVjoj7FnCtp1W5V5MkAJqCunp1xNHvhqAv7cdAsKfHiNBtOGGzeXsbGv5I7kR//2L0q4isOMZ4r8GMUSeRqTMutSy2evXXovQD1YA7FOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=b201Wblo; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="b201Wblo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ja/5aHT7XHyisoCwKTtBmaYK9VZPMYwtDDfu9/pdiiw=; b=b201WbloC/TCx3oIJOOX50CnE9
	vZyT0o9SXv4nGd2r9o4N5W/a4MthoQW4J8862rToJP+RHMFNfUnTWsy7tSKdkyvWXbWqJzwWL80tu
	ZSqennLLyV0Kkb5zN7IW96PkexOSWzCSQFg9R4YY4PTZQR740U80d6SkbSW0wtAHgOZKqsQBs+tYf
	UvHAarg5IvruiyhWslosi/fwWzi874Qop1RqbWaU2S0QYqTY7oBdyzkYfzj7uBHz9bIZUsq4zXWLZ
	I6rjjwLmvNymJu9RXF0X7il9t62DJ9z20xYMEjXNGRVWrZ+6Cb5MRJOGcooWcxNcYhZzUb6yu+k/5
	7jRiZ6NQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vT0qT-000000007tx-1rfJ;
	Tue, 09 Dec 2025 17:45:49 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 6/6] scanner: Introduce SCANSTATE_RATE
Date: Tue,  9 Dec 2025 17:45:41 +0100
Message-ID: <20251209164541.13425-7-phil@nwl.cc>
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

This is a first exclusive start condition, i.e. one which rejects
unscoped tokens. When tokenizing, flex all too easily falls back into
treating something as STRING when it could be split into tokens instead.
Via an exclusive start condition, the string-fallback can be disabled as
needed.

With rates in typical formatting <NUM><bytes-unit>/<time-unit>,
tokenizer result depended on whitespace placement. SCANSTATE_RATE forces
flex to split the string into tokens and fall back to JUNK upon failure.
For this to work, tokens which shall still be recognized must be enabled
in SCANSTATE_RATE (or all scopes denoted by '*'). This includes any
tokens possibly following SCANSTATE_RATE to please the parser's
lookahead behaviour.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/datatype.h           |  4 ---
 include/parser.h             |  1 +
 src/datatype.c               | 61 -------------------------------
 src/parser_bison.y           | 23 +++---------
 src/scanner.l                | 55 ++++++++++++++--------------
 tests/py/any/limit.t         |  6 ++++
 tests/py/any/limit.t.json    | 70 ++++++++++++++++++++++++++++++++++++
 tests/py/any/limit.t.payload | 20 +++++++++++
 8 files changed, 130 insertions(+), 110 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 63dba330137a0..4c5d6ff8d9002 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -309,10 +309,6 @@ extern void time_print(uint64_t msec, struct output_ctx *octx);
 extern struct error_record *time_parse(const struct location *loc,
 				       const char *c, uint64_t *res);
 
-extern struct error_record *rate_parse(const struct location *loc,
-				       const char *str, uint64_t *rate,
-				       uint64_t *unit);
-
 struct limit_rate {
 	uint64_t rate, unit;
 };
diff --git a/include/parser.h b/include/parser.h
index 8cfd22e9e6c42..889302baf5950 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -47,6 +47,7 @@ enum startcond_type {
 	PARSER_SC_META,
 	PARSER_SC_POLICY,
 	PARSER_SC_QUOTA,
+	PARSER_SC_RATE,
 	PARSER_SC_SCTP,
 	PARSER_SC_SECMARK,
 	PARSER_SC_TCP,
diff --git a/src/datatype.c b/src/datatype.c
index 1950a2f3757b8..189738513bf8c 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1488,67 +1488,6 @@ const struct datatype *set_datatype_alloc(const struct datatype *orig_dtype,
 	return dtype;
 }
 
-static struct error_record *time_unit_parse(const struct location *loc,
-					    const char *str, uint64_t *unit)
-{
-	if (strcmp(str, "second") == 0)
-		*unit = 1ULL;
-	else if (strcmp(str, "minute") == 0)
-		*unit = 1ULL * 60;
-	else if (strcmp(str, "hour") == 0)
-		*unit = 1ULL * 60 * 60;
-	else if (strcmp(str, "day") == 0)
-		*unit = 1ULL * 60 * 60 * 24;
-	else if (strcmp(str, "week") == 0)
-		*unit = 1ULL * 60 * 60 * 24 * 7;
-	else
-		return error(loc, "Wrong time format, expecting second, minute, hour, day or week");
-
-	return NULL;
-}
-
-static struct error_record *data_unit_parse(const struct location *loc,
-					    const char *str, uint64_t *rate)
-{
-	if (strcmp(str, "bytes") == 0)
-		*rate = 1ULL;
-	else if (strcmp(str, "kbytes") == 0)
-		*rate = 1024;
-	else if (strcmp(str, "mbytes") == 0)
-		*rate = 1024 * 1024;
-	else
-		return error(loc, "Wrong unit format, expecting bytes, kbytes or mbytes");
-
-	return NULL;
-}
-
-struct error_record *rate_parse(const struct location *loc, const char *str,
-				uint64_t *rate, uint64_t *unit)
-{
-	const char *slash, *rate_str;
-	struct error_record *erec;
-
-	slash = strchr(str, '/');
-	if (!slash)
-		return error(loc, "wrong rate format, expecting {bytes,kbytes,mbytes}/{second,minute,hour,day,week}");
-
-	rate_str = strndup(str, slash - str);
-	if (!rate_str)
-		memory_allocation_error();
-
-	erec = data_unit_parse(loc, rate_str, rate);
-	free_const(rate_str);
-
-	if (erec != NULL)
-		return erec;
-
-	erec = time_unit_parse(loc, slash + 1, unit);
-	if (erec != NULL)
-		return erec;
-
-	return NULL;
-}
-
 static const struct symbol_table boolean_tbl = {
 	.base		= BASE_DECIMAL,
 	.symbols	= {
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 9639352a4b47d..18174859434c8 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1113,6 +1113,7 @@ close_scope_osf		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_OSF); }
 close_scope_policy	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_POLICY); };
 close_scope_quota	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_QUOTA); };
 close_scope_queue	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_QUEUE); };
+close_scope_rate	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_RATE); };
 close_scope_reject	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_STMT_REJECT); };
 close_scope_reset	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CMD_RESET); };
 close_scope_rt		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_RT); };
@@ -3557,7 +3558,7 @@ limit_stmt_alloc	:	LIMIT	RATE
 			}
 			;
 
-limit_stmt		:	limit_stmt_alloc limit_args
+limit_stmt		:	limit_stmt_alloc limit_args close_scope_rate
 			;
 
 limit_args		:	limit_mode	limit_rate_pkts	limit_burst_pkts
@@ -3652,21 +3653,7 @@ limit_burst_bytes	:	/* empty */			{ $$ = 0; }
 			|	BURST	NUM	bytes_unit	{ $$ = $2 * $3; }
 			;
 
-limit_rate_bytes	:	NUM     STRING
-			{
-				struct error_record *erec;
-				uint64_t rate, unit;
-
-				erec = rate_parse(&@$, $2, &rate, &unit);
-				free_const($2);
-				if (erec != NULL) {
-					erec_queue(erec, state->msgs);
-					YYERROR;
-				}
-				$$.rate = rate * $1;
-				$$.unit = unit;
-			}
-			|	NUM bytes_unit SLASH time_unit
+limit_rate_bytes	:	NUM bytes_unit SLASH time_unit
 			{
 				$$.rate = $1 * $2;
 				$$.unit = $4;
@@ -4897,7 +4884,7 @@ ct_obj_alloc		:	/* empty */
 			}
 			;
 
-limit_config		:	RATE	limit_mode	limit_rate_pkts	limit_burst_pkts
+limit_config		:	RATE	limit_mode	limit_rate_pkts	limit_burst_pkts	close_scope_rate
 			{
 				struct limit *limit;
 
@@ -4908,7 +4895,7 @@ limit_config		:	RATE	limit_mode	limit_rate_pkts	limit_burst_pkts
 				limit->type	= NFT_LIMIT_PKTS;
 				limit->flags	= $2;
 			}
-			|	RATE	limit_mode	limit_rate_bytes	limit_burst_bytes
+			|	RATE	limit_mode	limit_rate_bytes	limit_burst_bytes close_scope_rate
 			{
 				struct limit *limit;
 
diff --git a/src/scanner.l b/src/scanner.l
index 4cbc8a44c89c8..9d8fade8308d3 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -219,6 +219,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_META
 %s SCANSTATE_POLICY
 %s SCANSTATE_QUOTA
+%x SCANSTATE_RATE
 %s SCANSTATE_SCTP
 %s SCANSTATE_SECMARK
 %s SCANSTATE_TCP
@@ -275,12 +276,12 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "ge"			{ return GTE; }
 ">"			{ return GT; }
 "gt"			{ return GT; }
-","			{ return COMMA; }
+<*>","			{ return COMMA; }
 "."			{ return DOT; }
 ":"			{ return COLON; }
-";"			{ return SEMICOLON; }
+<*>";"			{ return SEMICOLON; }
 "{"			{ return '{'; }
-"}"			{ return '}'; }
+<*>"}"			{ return '}'; }
 "["			{ return '['; }
 "]"			{ return ']'; }
 "("			{ return '('; }
@@ -297,7 +298,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "or"			{ return '|'; }
 "!"			{ return NOT; }
 "not"			{ return NOT; }
-"/"			{ return SLASH; }
+<*>"/"			{ return SLASH; }
 "-"			{ return DASH; }
 "*"			{ return ASTERISK; }
 "@"			{ scanner_push_start_cond(yyscanner, SCANSTATE_AT); return AT; }
@@ -410,12 +411,12 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"hooks"			{ return HOOKS; }
 }
 
-"counter"		{ scanner_push_start_cond(yyscanner, SCANSTATE_COUNTER); return COUNTER; }
+<*>"counter"		{ scanner_push_start_cond(yyscanner, SCANSTATE_COUNTER); return COUNTER; }
 <SCANSTATE_COUNTER,SCANSTATE_LIMIT,SCANSTATE_QUOTA,SCANSTATE_STMT_SYNPROXY,SCANSTATE_EXPR_OSF,SCANSTATE_TUNNEL>"name"			{ return NAME; }
-<SCANSTATE_COUNTER,SCANSTATE_CT,SCANSTATE_LIMIT>"packets"		{ return PACKETS; }
-<SCANSTATE_COUNTER,SCANSTATE_CT,SCANSTATE_LIMIT,SCANSTATE_QUOTA>"bytes"	{ return BYTES; }
-<SCANSTATE_LIMIT,SCANSTATE_QUOTA>"kbytes"	{ return KBYTES; }
-<SCANSTATE_LIMIT,SCANSTATE_QUOTA>"mbytes"	{ return MBYTES; }
+<SCANSTATE_COUNTER,SCANSTATE_CT,SCANSTATE_LIMIT,SCANSTATE_RATE>"packets"		{ return PACKETS; }
+<SCANSTATE_COUNTER,SCANSTATE_CT,SCANSTATE_LIMIT,SCANSTATE_QUOTA,SCANSTATE_RATE>"bytes"	{ return BYTES; }
+<SCANSTATE_LIMIT,SCANSTATE_QUOTA,SCANSTATE_RATE>"kbytes"	{ return KBYTES; }
+<SCANSTATE_LIMIT,SCANSTATE_QUOTA,SCANSTATE_RATE>"mbytes"	{ return MBYTES; }
 
 "last"				{ scanner_push_start_cond(yyscanner, SCANSTATE_LAST); return LAST; }
 <SCANSTATE_LAST>{
@@ -428,7 +429,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"rules"			{ return RULES; }
 }
 
-"log"			{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_LOG); return LOG; }
+<*>"log"			{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_LOG); return LOG; }
 <SCANSTATE_STMT_LOG,SCANSTATE_STMT_NAT,SCANSTATE_IP,SCANSTATE_IP6>"prefix"		{ return PREFIX; }
 <SCANSTATE_STMT_LOG>{
 	"snaplen"		{ return SNAPLEN; }
@@ -453,8 +454,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"fanout"	{ return FANOUT;}
 }
 "limit"			{ scanner_push_start_cond(yyscanner, SCANSTATE_LIMIT); return LIMIT; }
-<SCANSTATE_LIMIT>{
-	"rate"			{ return RATE; }
+<SCANSTATE_LIMIT,SCANSTATE_RATE>{
+	"rate"			{ scanner_push_start_cond(yyscanner, SCANSTATE_RATE); return RATE; }
 	"burst"			{ return BURST; }
 
 	/* time_unit */
@@ -462,17 +463,17 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"minute"		{ return MINUTE; }
 	"week"			{ return WEEK; }
 }
-<SCANSTATE_CT,SCANSTATE_LIMIT,SCANSTATE_QUOTA>"over"		{ return OVER; }
+<SCANSTATE_CT,SCANSTATE_LIMIT,SCANSTATE_QUOTA,SCANSTATE_RATE>"over"		{ return OVER; }
 
 "quota"			{ scanner_push_start_cond(yyscanner, SCANSTATE_QUOTA); return QUOTA; }
-<SCANSTATE_QUOTA>{
+<SCANSTATE_QUOTA,SCANSTATE_RATE>{
 	"until"		{ return UNTIL; }
 }
 
 <SCANSTATE_QUOTA,SCANSTATE_LAST>"used"		{ return USED; }
 
-"hour"			{ return HOUR; }
-"day"			{ return DAY; }
+<*>"hour"		{ return HOUR; }
+<*>"day"		{ return DAY; }
 
 "reject"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_REJECT); return _REJECT; }
 <SCANSTATE_STMT_REJECT>{
@@ -901,7 +902,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 				return STRING;
 			}
 
-{hexstring}		{
+<*>{hexstring}		{
 				errno = 0;
 				yylval->val = strtoull(yytext, NULL, 16);
 				if (errno != 0) {
@@ -911,7 +912,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 				return NUM;
 			}
 
-{decstring}		{
+<*>{decstring}		{
 				int base = yytext[0] == '0' ? 8 : 10;
 				char *end;
 
@@ -945,32 +946,32 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 				return STRING;
 			}
 
-{newline_crlf}		{	return CRLF; }
+<*>{newline_crlf}	{	return CRLF; }
 
-\\{newline}		{
+<*>\\{newline}		{
 				reset_pos(yyget_extra(yyscanner), yylloc);
 			}
 
-{newline}		{
+<*>{newline}		{
 				reset_pos(yyget_extra(yyscanner), yylloc);
 				return NEWLINE;
 			}
 
-{tab}+
-{space}+
-{comment_line}		{
+<*>{tab}+
+<*>{space}+
+<*>{comment_line}	{
 				reset_pos(yyget_extra(yyscanner), yylloc);
 			}
-{comment}
+<*>{comment}
 
-<<EOF>> 		{
+<*><<EOF>> 		{
 				update_pos(yyget_extra(yyscanner), yylloc, 1);
 				scanner_pop_buffer(yyscanner);
 				if (YY_CURRENT_BUFFER == NULL)
 					return TOKEN_EOF;
 			}
 
-.			{ return JUNK; }
+<*>.			{ return JUNK; }
 
 %%
 
diff --git a/tests/py/any/limit.t b/tests/py/any/limit.t
index 2a84e3f56e4ef..5c95ffa52ee8a 100644
--- a/tests/py/any/limit.t
+++ b/tests/py/any/limit.t
@@ -49,3 +49,9 @@ limit rate over 10230 mbytes/second;ok
 limit rate over 1025 bytes/second burst 512 bytes;ok
 limit rate over 1025 kbytes/second burst 1023 kbytes;ok
 limit rate over 1025 mbytes/second burst 1025 kbytes;ok
+
+limit rate over 1025bytes/second burst 512bytes;ok;limit rate over 1025 bytes/second burst 512 bytes
+limit rate over 1025bytes /second burst 512bytes;ok;limit rate over 1025 bytes/second burst 512 bytes
+limit rate over 1025bytes/ second burst 512bytes;ok;limit rate over 1025 bytes/second burst 512 bytes
+limit rate over 1025bytes / second burst 512bytes;ok;limit rate over 1025 bytes/second burst 512 bytes
+limit rate over 1025 bytes / second burst 512bytes;ok;limit rate over 1025 bytes/second burst 512 bytes
diff --git a/tests/py/any/limit.t.json b/tests/py/any/limit.t.json
index 73160b27fad81..49a48960ecf86 100644
--- a/tests/py/any/limit.t.json
+++ b/tests/py/any/limit.t.json
@@ -360,3 +360,73 @@
         }
     }
 ]
+
+# limit rate over 1025bytes/second burst 512bytes
+[
+    {
+        "limit": {
+            "burst": 512,
+            "burst_unit": "bytes",
+            "inv": true,
+            "per": "second",
+            "rate": 1025,
+            "rate_unit": "bytes"
+        }
+    }
+]
+
+# limit rate over 1025bytes /second burst 512bytes
+[
+    {
+        "limit": {
+            "burst": 512,
+            "burst_unit": "bytes",
+            "inv": true,
+            "per": "second",
+            "rate": 1025,
+            "rate_unit": "bytes"
+        }
+    }
+]
+
+# limit rate over 1025bytes/ second burst 512bytes
+[
+    {
+        "limit": {
+            "burst": 512,
+            "burst_unit": "bytes",
+            "inv": true,
+            "per": "second",
+            "rate": 1025,
+            "rate_unit": "bytes"
+        }
+    }
+]
+
+# limit rate over 1025bytes / second burst 512bytes
+[
+    {
+        "limit": {
+            "burst": 512,
+            "burst_unit": "bytes",
+            "inv": true,
+            "per": "second",
+            "rate": 1025,
+            "rate_unit": "bytes"
+        }
+    }
+]
+
+# limit rate over 1025 bytes / second burst 512bytes
+[
+    {
+        "limit": {
+            "burst": 512,
+            "burst_unit": "bytes",
+            "inv": true,
+            "per": "second",
+            "rate": 1025,
+            "rate_unit": "bytes"
+        }
+    }
+]
diff --git a/tests/py/any/limit.t.payload b/tests/py/any/limit.t.payload
index dc6701b3521c9..901275dafcaa0 100644
--- a/tests/py/any/limit.t.payload
+++ b/tests/py/any/limit.t.payload
@@ -122,3 +122,23 @@ ip test-ip4 output
 # limit rate over 1025 mbytes/second burst 1025 kbytes
 ip test-ip4 output
   [ limit rate 1074790400/second burst 1049600 type bytes flags 0x1 ]
+
+# limit rate over 1025bytes/second burst 512bytes
+ip test-ip4 output
+  [ limit rate 1025/second burst 512 type bytes flags 0x1 ]
+
+# limit rate over 1025bytes /second burst 512bytes
+ip test-ip4 output
+  [ limit rate 1025/second burst 512 type bytes flags 0x1 ]
+
+# limit rate over 1025bytes/ second burst 512bytes
+ip test-ip4 output
+  [ limit rate 1025/second burst 512 type bytes flags 0x1 ]
+
+# limit rate over 1025bytes / second burst 512bytes
+ip test-ip4 output
+  [ limit rate 1025/second burst 512 type bytes flags 0x1 ]
+
+# limit rate over 1025 bytes / second burst 512bytes
+ip test-ip4 output
+  [ limit rate 1025/second burst 512 type bytes flags 0x1 ]
-- 
2.51.0

