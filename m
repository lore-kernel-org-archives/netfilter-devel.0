Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DFF746E
	for <netfilter-devel@vger.kernel.org>; Sat, 13 Apr 2024 03:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712977517; cv=none; b=DSAIbvnAITnc8TzLi/G92RyYtkz5CKBEFe5xnLadrfJ7Z5sIHnnKMrv3EqwPCLQPoqJAteX+OxLJpSwQXl6fIAbP7ig/2F3tp4N4ObNIEz+LgfWXG2BAx2cbfsJDY1SCHibh8EbuxMo2aQ/6CdCMGxRUwAeqd3JgOqV1cnwiDCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712977517; c=relaxed/simple;
	bh=MiFKrBhgioJkBkU6Unad7WQhmW/6BwKhelMX5aS/t3w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=egR2gjJ9fpDOHB2fpJXovVREylBHLRoOHHtY6toMJb/c7kRnXg5MGB3SJ01G/nttnxP5MWiT3n6ZJeoONY7kIUfGYgIDgUxKTUs8T62vBlkgtDeBfrYnnzJoLff/TmBCLHKXf3Srmat4OV1Y2mIEbv3pITBH8QK5EBO6Uc4lqiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=bfDapG44; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="bfDapG44"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=YQIMknU49M0NWCT4S5pduUcuaFRezyJRIfJhUnoUirg=; b=bfDapG44YOMhWicFBuXMZNVYOq
	fecQj68Zl/qx/3QqbgEHGcg+V+40lP3GnK20OjZ+vZe9TliBlAjC7FBBmM7X0ew9gySH7TSO4metO
	HSp7lKmJwFNkQX0Bj37naGlOjRoZb2yv41Ydv0OGolrSQQRk2E8H2tgHkV4IxDQmv5nxhqm+9Qmek
	XQ8VLchmySxNZ2EEP9qF2l3XhN1pwCxhtKi756G0ItcfDS13MwM2NeK3tGJD80ZACLWs14yDxsL1V
	q98m3bw2wMB8LHxW+qB6nPSinTwCHm0JGKhVaWgH2vHwcC5wXzDyoqs22pIxpEbb0hKjfNT/ofohk
	MHV2OzAw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rvThY-000000004iR-2j5B;
	Sat, 13 Apr 2024 05:05:12 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Cyril <boite.pour.spam@gmail.com>
Subject: [nft PATCH] limit: Support arbitrary unit values
Date: Sat, 13 Apr 2024 05:05:10 +0200
Message-ID: <20240413030510.15643-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

By accepting an optional denominator value, odd rates like e.g. 2
packets per 3 minutes may be specified.

Feature originally implemented by Cyril, applied to current HEAD with a
few minor improvements by me.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1214
Signed-off-by: Cyril <boite.pour.spam@gmail.com>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Sadly, the implementation in bison is pretty fragile:

These work:
- limit rate 3 bytes / hour
- limit rate 3bytes / hour
- limit rate 3bytes /hour
- limit rate 3bytes/hour

- limit rate 3 mbytes / hour

- limit rate 3 bytes / 2 hour
- limit rate 3bytes / 2 hour
- limit rate 3bytes /2 hour

And these don't:
- limit rate 3bytes/ hour

- limit rate 3mbytes / hour

- limit rate 3bytes/ 2 hour
- limit rate 3bytes / 2hour
- limit rate 3bytes /2hour
- limit rate 3bytes/2hour

Also, 'limit rate 3 mbytes / 2 hour' fails with "Value too large for
defined data type" - but this seems to be a different issue.
---
 doc/libnftables-json.adoc    |  9 ++--
 doc/statements.txt           |  2 +-
 include/statement.h          |  2 +-
 src/json.c                   | 28 +++++++++---
 src/parser_bison.y           | 16 ++++---
 src/parser_json.c            | 40 +++++++++++++----
 src/rule.c                   | 22 ++++++----
 src/statement.c              | 55 +++++++++++++++--------
 tests/py/any/limit.t         |  7 +++
 tests/py/any/limit.t.json    | 84 ++++++++++++++++++++++++++++++++++++
 tests/py/any/limit.t.payload | 27 ++++++++++++
 11 files changed, 238 insertions(+), 54 deletions(-)

diff --git a/doc/libnftables-json.adoc b/doc/libnftables-json.adoc
index a8a6165fde59d..25db43c9df026 100644
--- a/doc/libnftables-json.adoc
+++ b/doc/libnftables-json.adoc
@@ -547,13 +547,16 @@ ____
 	"name":* 'STRING'*,
 	"handle":* 'NUMBER'*,
 	"rate":* 'NUMBER'*,
-	"per":* 'STRING'*,
+	"per":* 'TIME_SPEC'*,
 	"burst":* 'NUMBER'*,
 	"unit":* 'LIMIT_UNIT'*,
 	"inv":* 'BOOLEAN'
 *}}*
 
 'LIMIT_UNIT' := *"packets"* | *"bytes"*
+'TIME_SPEC' := 'TIME_UNIT' | 'TIME_SPEC_ARRAY'
+'TIME_SPEC_ARRAY' := *[* 'NUMBER' *,* 'TIME_UNIT' *]*
+'TIME_UNIT' := *"second"* | *"minute"* | *"hour"* | *"day"* | *"week"*
 ____
 
 This object represents a named limit.
@@ -569,8 +572,8 @@ This object represents a named limit.
 *rate*::
 	The limit's rate value.
 *per*::
-	Time unit to apply the limit to, e.g. *"week"*, *"day"*, *"hour"*, etc.
-	If omitted, defaults to *"second"*.
+	Time unit to apply the limit to, by default *"second"*. The
+	'TIME_SPEC_ARRAY' format may specify multiples of 'TIME_UNIT'.
 *burst*::
 	The limit's burst value. If omitted, defaults to *0*.
 *unit*::
diff --git a/doc/statements.txt b/doc/statements.txt
index 39b31fd2c8259..7776d49810041 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -368,7 +368,7 @@ ____
 *limit rate* [*over*] 'packet_number' */* 'TIME_UNIT' [*burst* 'packet_number' *packets*]
 *limit rate* [*over*] 'byte_number' 'BYTE_UNIT' */* 'TIME_UNIT' [*burst* 'byte_number' 'BYTE_UNIT']
 
-'TIME_UNIT' := *second* | *minute* | *hour* | *day*
+'TIME_UNIT' := ['number'] { *second* | *minute* | *hour* | *day* }
 'BYTE_UNIT' := *bytes* | *kbytes* | *mbytes*
 ____
 
diff --git a/include/statement.h b/include/statement.h
index 662f99ddef796..a7a6de60b6d0c 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -422,6 +422,6 @@ extern void stmt_list_free(struct list_head *list);
 extern void stmt_print(const struct stmt *stmt, struct output_ctx *octx);
 
 const char *get_rate(uint64_t byte_rate, uint64_t *rate);
-const char *get_unit(uint64_t u);
+const char *get_time(uint64_t seconds, uint64_t *val);
 
 #endif /* NFTABLES_STATEMENT_H */
diff --git a/src/json.c b/src/json.c
index 3753017169930..c0a509e3395c1 100644
--- a/src/json.c
+++ b/src/json.c
@@ -330,10 +330,10 @@ static json_t *timeout_policy_json(uint8_t l4, const uint32_t *timeout)
 
 static json_t *obj_print_json(const struct obj *obj)
 {
-	const char *rate_unit = NULL, *burst_unit = NULL;
+	const char *rate_unit = NULL, *burst_unit = NULL, *time_unit;
 	const char *type = obj_type_name(obj->type);
 	json_t *root, *tmp, *flags;
-	uint64_t rate, burst;
+	uint64_t rate, burst, tval;
 
 	root = json_pack("{s:s, s:s, s:s, s:I}",
 			"family", family2str(obj->handle.family),
@@ -408,9 +408,15 @@ static json_t *obj_print_json(const struct obj *obj)
 			burst_unit = get_rate(obj->limit.burst, &burst);
 		}
 
-		tmp = json_pack("{s:I, s:s}",
+		time_unit = get_time(obj->limit.unit, &tval);
+		if (tval > 1)
+			tmp = json_pack("[I, s]", tval, time_unit);
+		else
+			tmp = json_string(time_unit);
+
+		tmp = json_pack("{s:I, s:o}",
 				"rate", rate,
-				"per", get_unit(obj->limit.unit));
+				"per", tmp);
 
 		if (obj->limit.flags & NFT_LIMIT_F_INV)
 			json_object_set_new(tmp, "inv", json_true());
@@ -1252,21 +1258,29 @@ json_t *ct_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 
 json_t *limit_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 {
-	const char *rate_unit = NULL, *burst_unit = NULL;
+	const char *rate_unit = NULL, *burst_unit = NULL, *time_unit;
 	bool inv = stmt->limit.flags & NFT_LIMIT_F_INV;
 	uint64_t burst = stmt->limit.burst;
 	uint64_t rate = stmt->limit.rate;
+	uint64_t tval;
 	json_t *root;
 
+	time_unit = get_time(stmt->limit.unit, &tval);
+
 	if (stmt->limit.type == NFT_LIMIT_PKT_BYTES) {
 		rate_unit = get_rate(stmt->limit.rate, &rate);
 		burst_unit = get_rate(stmt->limit.burst, &burst);
 	}
 
-	root = json_pack("{s:I, s:I, s:s}",
+	if (tval > 1)
+		root = json_pack("[I, s]", tval, time_unit);
+	else
+		root = json_string(time_unit);
+
+	root = json_pack("{s:I, s:I, s:o}",
 			 "rate", rate,
 			 "burst", burst,
-			 "per", get_unit(stmt->limit.unit));
+			 "per", root);
 	if (inv)
 		json_object_set_new(root, "inv", json_boolean(inv));
 	if (rate_unit)
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 53f45315ef469..098be597dafa8 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -781,7 +781,7 @@ int nft_lex(void *, void *, void *);
 %type <val>			level_type log_flags log_flags_tcp log_flag_tcp
 %type <stmt>			limit_stmt quota_stmt connlimit_stmt
 %destructor { stmt_free($$); }	limit_stmt quota_stmt connlimit_stmt
-%type <val>			limit_burst_pkts limit_burst_bytes limit_mode limit_bytes time_unit quota_mode
+%type <val>			limit_burst_pkts limit_burst_bytes limit_mode limit_bytes time_unit time_unit_val quota_mode
 %type <stmt>			reject_stmt reject_stmt_alloc
 %destructor { stmt_free($$); }	reject_stmt reject_stmt_alloc
 %type <stmt>			nat_stmt nat_stmt_alloc masq_stmt masq_stmt_alloc redir_stmt redir_stmt_alloc
@@ -3714,11 +3714,15 @@ limit_bytes		:	NUM	BYTES		{ $$ = $1; }
 			}
 			;
 
-time_unit		:	SECOND		{ $$ = 1ULL; }
-			|	MINUTE		{ $$ = 1ULL * 60; }
-			|	HOUR		{ $$ = 1ULL * 60 * 60; }
-			|	DAY		{ $$ = 1ULL * 60 * 60 * 24; }
-			|	WEEK		{ $$ = 1ULL * 60 * 60 * 24 * 7; }
+time_unit_val		:	NUM		{ $$ = $1; }
+			|	/* empty */	{ $$ = 1ULL; }
+			;
+
+time_unit		:	time_unit_val	SECOND	{ $$ = $1; }
+			|	time_unit_val	MINUTE	{ $$ = $1 * 60; }
+			|	time_unit_val	HOUR	{ $$ = $1 * 60 * 60; }
+			|	time_unit_val	DAY	{ $$ = $1 * 60 * 60 * 24; }
+			|	time_unit_val	WEEK	{ $$ = $1 * 60 * 60 * 24 * 7; }
 			;
 
 reject_stmt		:	reject_stmt_alloc	reject_opts
diff --git a/src/parser_json.c b/src/parser_json.c
index 8b7efaf226627..83ead5ec355e3 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1948,13 +1948,14 @@ static uint64_t seconds_from_unit(const char *unit)
 static struct stmt *json_parse_limit_stmt(struct json_ctx *ctx,
 					  const char *key, json_t *value)
 {
+	const char *rate_unit = "packets", *time_unit, *burst_unit = "bytes";
+	uint64_t rate, burst = 0, tval;
 	struct stmt *stmt;
-	uint64_t rate, burst = 0;
-	const char *rate_unit = "packets", *time, *burst_unit = "bytes";
+	json_t *time_obj;
 	int inv = 0;
 
-	if (!json_unpack(value, "{s:I, s:s}",
-			 "rate", &rate, "per", &time)) {
+	if (!json_unpack(value, "{s:I, s:o}",
+			 "rate", &rate, "per", &time_obj)) {
 		json_unpack(value, "{s:s}", "rate_unit", &rate_unit);
 		json_unpack(value, "{s:b}", "inv", &inv);
 		json_unpack(value, "{s:I}", "burst", &burst);
@@ -1974,7 +1975,16 @@ static struct stmt *json_parse_limit_stmt(struct json_ctx *ctx,
 			stmt->limit.rate = rate_to_bytes(rate, rate_unit);
 			stmt->limit.burst = rate_to_bytes(burst, burst_unit);
 		}
-		stmt->limit.unit = seconds_from_unit(time);
+		if (!json_unpack(time_obj, "[I, s!]", &tval, &time_unit)) {
+			stmt->limit.unit = tval;
+		} else if (!json_unpack(time_obj, "s", &time_unit)) {
+			stmt->limit.unit = 1;
+		} else {
+			json_error(ctx, "Invalid limit 'per' value.");
+			stmt_free(stmt);
+			return NULL;
+		}
+		stmt->limit.unit *= seconds_from_unit(time_unit);
 		stmt->limit.flags = inv ? NFT_LIMIT_F_INV : 0;
 		return stmt;
 	}
@@ -3585,9 +3595,11 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 	const char *family, *tmp, *rate_unit = "packets", *burst_unit = "bytes";
 	uint32_t l3proto = NFPROTO_UNSPEC;
 	int inv = 0, flags = 0, i, j;
+	json_t *jflags, *time_obj;
 	struct handle h = { 0 };
+	const char *time_unit;
 	struct obj *obj;
-	json_t *jflags;
+	uint64_t tval;
 
 	if (json_unpack_err(ctx, root, "{s:s, s:s}",
 			    "family", &family,
@@ -3745,9 +3757,9 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 		break;
 	case CMD_OBJ_LIMIT:
 		obj->type = NFT_OBJECT_LIMIT;
-		if (json_unpack_err(ctx, root, "{s:I, s:s}",
+		if (json_unpack_err(ctx, root, "{s:I, s:o}",
 				    "rate", &obj->limit.rate,
-				    "per", &tmp)) {
+				    "per", &time_obj)) {
 			obj_free(obj);
 			return NULL;
 		}
@@ -3756,6 +3768,16 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 		json_unpack(root, "{s:i}", "burst", &obj->limit.burst);
 		json_unpack(root, "{s:s}", "burst_unit", &burst_unit);
 
+		if (!json_unpack(time_obj, "[I, s!]", &tval, &time_unit)) {
+			obj->limit.unit = tval;
+		} else if (!json_unpack(time_obj, "s", &time_unit)) {
+			obj->limit.unit = 1;
+		} else {
+			json_error(ctx, "Invalid limit 'per' value.");
+			obj_free(obj);
+			return NULL;
+		}
+
 		if (!strcmp(rate_unit, "packets")) {
 			obj->limit.type = NFT_LIMIT_PKTS;
 		} else {
@@ -3765,7 +3787,7 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 			obj->limit.burst = rate_to_bytes(obj->limit.burst,
 							 burst_unit);
 		}
-		obj->limit.unit = seconds_from_unit(tmp);
+		obj->limit.unit *= seconds_from_unit(time_unit);
 		obj->limit.flags = inv ? NFT_LIMIT_F_INV : 0;
 		break;
 	case CMD_OBJ_SYNPROXY:
diff --git a/src/rule.c b/src/rule.c
index 65ff0fbbe21f1..c70054d5e78fc 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1865,8 +1865,10 @@ static void obj_print_data(const struct obj *obj,
 		break;
 	case NFT_OBJECT_LIMIT: {
 		bool inv = obj->limit.flags & NFT_LIMIT_F_INV;
-		const char *data_unit;
-		uint64_t rate;
+		const char *data_unit, *time_unit;
+		uint64_t rate, timeval;
+
+		time_unit = get_time(obj->limit.unit, &timeval);
 
 		nft_print(octx, " %s {", obj->handle.obj.name);
 		if (nft_output_handle(octx))
@@ -1876,9 +1878,11 @@ static void obj_print_data(const struct obj *obj,
 		nft_print(octx, "%s%s%s", opts->nl, opts->tab, opts->tab);
 		switch (obj->limit.type) {
 		case NFT_LIMIT_PKTS:
-			nft_print(octx, "rate %s%" PRIu64 "/%s",
-				  inv ? "over " : "", obj->limit.rate,
-				  get_unit(obj->limit.unit));
+			nft_print(octx, "rate %s%" PRIu64 "/",
+				  inv ? "over " : "", obj->limit.rate);
+			if (timeval > 1)
+				nft_print(octx, "%"PRIu64" ", timeval);
+			nft_print(octx, "%s", time_unit);
 			if (obj->limit.burst > 0 && obj->limit.burst != 5)
 				nft_print(octx, " burst %u packets",
 					  obj->limit.burst);
@@ -1886,9 +1890,11 @@ static void obj_print_data(const struct obj *obj,
 		case NFT_LIMIT_PKT_BYTES:
 			data_unit = get_rate(obj->limit.rate, &rate);
 
-			nft_print(octx, "rate %s%" PRIu64 " %s/%s",
-				  inv ? "over " : "", rate, data_unit,
-				  get_unit(obj->limit.unit));
+			nft_print(octx, "rate %s%" PRIu64 " %s/",
+				  inv ? "over " : "", rate, data_unit);
+			if (timeval > 1)
+				nft_print(octx, "%"PRIu64" ", timeval);
+			nft_print(octx, "%s", time_unit);
 			if (obj->limit.burst > 0) {
 				uint64_t burst;
 
diff --git a/src/statement.c b/src/statement.c
index ab144d6393189..0eff61db561d6 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -435,17 +435,28 @@ struct stmt *log_stmt_alloc(const struct location *loc)
 	return stmt_alloc(loc, &log_stmt_ops);
 }
 
-const char *get_unit(uint64_t u)
-{
-	switch (u) {
-	case 1: return "second";
-	case 60: return "minute";
-	case 60 * 60: return "hour";
-	case 60 * 60 * 24: return "day";
-	case 60 * 60 * 24 * 7: return "week";
-	}
+const char *get_time(uint64_t seconds, uint64_t *val)
+{
+	static const struct {
+		unsigned int size;
+		const char *name;
+	} units[] = {
+		{ 0,  "second" },
+		{ 60, "minute" },
+		{ 60, "hour" },
+		{ 24, "day" },
+		{ 7,  "week" }
+	};
+	unsigned int i;
 
-	return "error";
+	for (i = 1; i < array_size(units); i++) {
+		if (seconds % units[i].size)
+			break;
+		seconds /= units[i].size;
+	}
+	if (val)
+		*val = seconds;
+	return units[i - 1].name;
 }
 
 static const char * const data_unit[] = {
@@ -477,22 +488,28 @@ const char *get_rate(uint64_t byte_rate, uint64_t *rate)
 static void limit_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
 	bool inv = stmt->limit.flags & NFT_LIMIT_F_INV;
-	const char *data_unit;
-	uint64_t rate;
+	const char *data_unit, *time_unit;
+	uint64_t rate, tval;
+
+	time_unit = get_time(stmt->limit.unit, &tval);
 
 	switch (stmt->limit.type) {
 	case NFT_LIMIT_PKTS:
-		nft_print(octx, "limit rate %s%" PRIu64 "/%s",
-			  inv ? "over " : "", stmt->limit.rate,
-			  get_unit(stmt->limit.unit));
-		nft_print(octx, " burst %u packets", stmt->limit.burst);
+		nft_print(octx, "limit rate %s%" PRIu64 "/",
+			  inv ? "over " : "", stmt->limit.rate);
+		if (tval > 1)
+			nft_print(octx, "%"PRIu64" ", tval);
+		nft_print(octx, "%s burst %u packets",
+			  time_unit, stmt->limit.burst);
 		break;
 	case NFT_LIMIT_PKT_BYTES:
 		data_unit = get_rate(stmt->limit.rate, &rate);
 
-		nft_print(octx,	"limit rate %s%" PRIu64 " %s/%s",
-			  inv ? "over " : "", rate, data_unit,
-			  get_unit(stmt->limit.unit));
+		nft_print(octx,	"limit rate %s%" PRIu64 " %s/",
+			  inv ? "over " : "", rate, data_unit);
+		if (tval > 1)
+			nft_print(octx, "%"PRIu64" ", tval);
+		nft_print(octx,	"%s", time_unit);
 		if (stmt->limit.burst != 0) {
 			uint64_t burst;
 
diff --git a/tests/py/any/limit.t b/tests/py/any/limit.t
index 2a84e3f56e4ef..ddfc96f1cf6f5 100644
--- a/tests/py/any/limit.t
+++ b/tests/py/any/limit.t
@@ -29,6 +29,13 @@ limit rate 1 kbytes / second;ok;limit rate 1 kbytes/second
 limit rate 1 mbytes / second;ok;limit rate 1 mbytes/second
 limit rate 1 gbytes / second;fail
 
+limit rate 400/3 minute;ok;limit rate 400/3 minute burst 5 packets
+limit rate 20/14 second;ok;limit rate 20/14 second burst 5 packets
+limit rate 400/15 hour;ok;limit rate 400/15 hour burst 5 packets
+limit rate 40/92 day;ok;limit rate 40/92 day burst 5 packets
+limit rate 400/65 week;ok;limit rate 400/65 week burst 5 packets
+limit rate 1023/35 second burst 10 packets;ok
+
 limit rate 1025 bytes/second burst 512 bytes;ok
 limit rate 1025 kbytes/second burst 1023 kbytes;ok
 limit rate 1025 mbytes/second burst 1025 kbytes;ok
diff --git a/tests/py/any/limit.t.json b/tests/py/any/limit.t.json
index 73160b27fad81..596024ac858bf 100644
--- a/tests/py/any/limit.t.json
+++ b/tests/py/any/limit.t.json
@@ -153,6 +153,90 @@
     }
 ]
 
+# limit rate 400/3 minute
+[
+    {
+        "limit": {
+            "burst": 5,
+            "per": [
+                3,
+                "minute"
+            ],
+            "rate": 400
+        }
+    }
+]
+
+# limit rate 20/14 second
+[
+    {
+        "limit": {
+            "burst": 5,
+            "per": [
+                14,
+                "second"
+            ],
+            "rate": 20
+        }
+    }
+]
+
+# limit rate 400/15 hour
+[
+    {
+        "limit": {
+            "burst": 5,
+            "per": [
+                15,
+                "hour"
+            ],
+            "rate": 400
+        }
+    }
+]
+
+# limit rate 40/92 day
+[
+    {
+        "limit": {
+            "burst": 5,
+            "per": [
+                92,
+                "day"
+            ],
+            "rate": 40
+        }
+    }
+]
+
+# limit rate 400/65 week
+[
+    {
+        "limit": {
+            "burst": 5,
+            "per": [
+                65,
+                "week"
+            ],
+            "rate": 400
+        }
+    }
+]
+
+# limit rate 1023/35 second burst 10 packets
+[
+    {
+        "limit": {
+            "burst": 10,
+            "per": [
+                35,
+                "second"
+            ],
+            "rate": 1023
+        }
+    }
+]
+
 # limit rate 1025 bytes/second burst 512 bytes
 [
     {
diff --git a/tests/py/any/limit.t.payload b/tests/py/any/limit.t.payload
index dc6701b3521c9..4e0a86613cd26 100644
--- a/tests/py/any/limit.t.payload
+++ b/tests/py/any/limit.t.payload
@@ -54,6 +54,33 @@ ip
 ip
   [ limit rate 1048576/second burst 0 type bytes flags 0x0 ]
 
+# limit rate 400/3 minute
+ip test-ip4 output
+  [ limit rate 400/3 minute burst 5 type packets flags 0x0 ]
+
+# limit rate 20/14 second
+ip test-ip4 output
+  [ limit rate 20/14 second burst 5 type packets flags 0x0 ]
+
+# limit rate 400/15 hour
+ip test-ip4 output
+  [ limit rate 400/15 hour burst 5 type packets flags 0x0 ]
+
+# limit rate 40/92 day
+ip test-ip4 output
+  [ limit rate 40/92 day burst 5 type packets flags 0x0 ]
+
+# limit rate 400/65 week
+ip test-ip4 output
+  [ limit rate 400/65 week burst 5 type packets flags 0x0 ]
+
+# limit rate 1023/35 second burst 10 packets
+ip test-ip4 output
+  [ limit rate 1023/35 second burst 10 type packets flags 0x0 ]
+
+# limit rate 400/8
+ip test-ip4 output
+  [ limit rate 400/8 second burst 0 type packets flags 0x0 ]
 
 # limit rate 1025 bytes/second burst 512 bytes
 ip test-ip4 output
-- 
2.43.0

