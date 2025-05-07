Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2800572616
	for <netfilter-devel@vger.kernel.org>; Wed,  7 May 2025 22:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746658228; cv=none; b=hByiqFZ0iVTzB6YUedsRvjK5rZdWDxopav6CNEgECnkPH6usTuLWv7Oh8VGLKjBnlAp/nJTbKuCYLE8hPYCgbWNwcM/P3AQDGTUBJZo2+341NXYWN6/hkKAC2UXtL+icbjZNaVIp+Ifw9dJG0G98wxX8QlWwRyXSLn7YEjTB3/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746658228; c=relaxed/simple;
	bh=c2gqZGqGqR598SLPzrGb5LACupizsPpnLllGEKjv+Dg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KKz4rknnskLunXzZ91DzuNU0ZZoQhjm/6z+g0v7bL2sQzgyU9i3t4jInvMS/CO/z+R+UMJ4lLFTrcobQO5MLcI8WHMiMxb92RByI4L1SFe16XE1gK89cuAlreoBF2lRYpTwWK/mAU/RnnSNWlHXIKhoSB2gSvfPcaVcYJHg8PGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=CGGB82zp; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="CGGB82zp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=UOh0ynsmG/zai/20DU3a70B67fVAnsLs5V3hETrOwAQ=; b=CGGB82zpsWFvxZrAEMwyUV0KJU
	+JNeeolvPeXgE6/H9mzwmAIQ+qxOUfWtU+rTqWSMqL1qg4pfXT38AakbupVjLnxC2862hWQau2oAk
	/Ipdb78C3X8orUFbLOmhDoV0C/Jk+agMbAEDoB7KXoIMFeFT8GoEr9OmVPQt+RJqrydRc+nZEEqQe
	QLrCtyooC9hvPgCRZLOsB93jLBkhoZBauE5kzdGJexkXEAh9DmU/M/eXlD50MUChnau/lmqb18qBp
	ugjuMlrnv6RrO0guUFqmDBSrtB6sLH9X+Ok9FWsAFtQxhKf8YsBYjZo4iTEVfgwEPsE8sEkBCkoqG
	wUSoGiSg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uCnFj-0000000036Y-3e0n;
	Thu, 08 May 2025 00:28:35 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] parser_json: Introduce parse_flags_array()
Date: Thu,  8 May 2025 00:28:30 +0200
Message-ID: <20250507222830.22525-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Various objects support a 'flags' property with value usually being an
array of strings. There is a special case, when merely a single flag is
set: The value may be a string representing this flag.

Introduce a function assisting in parsing this polymorphic value. Have
callers pass a parser callback translating a single flag name into a
corresponding value. Luckily, these single flag parsers are very common
already.

As a side-effect, enable the single flag spec for set flags as well and
update the documentation accordingly.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/libnftables-json.adoc |   5 +-
 src/parser_json.c         | 466 +++++++++++---------------------------
 2 files changed, 136 insertions(+), 335 deletions(-)

diff --git a/doc/libnftables-json.adoc b/doc/libnftables-json.adoc
index 244eb412fbdc7..643884d5c1063 100644
--- a/doc/libnftables-json.adoc
+++ b/doc/libnftables-json.adoc
@@ -317,7 +317,7 @@ ____
 	"handle":* 'NUMBER'*,
 	"type":* 'SET_TYPE'*,
 	"policy":* 'SET_POLICY'*,
-	"flags": [* 'SET_FLAG_LIST' *],
+	"flags":* 'SET_FLAGS'*,
 	"elem":* 'SET_ELEMENTS'*,
 	"timeout":* 'NUMBER'*,
 	"gc-interval":* 'NUMBER'*,
@@ -333,7 +333,7 @@ ____
 	"type":* 'SET_TYPE'*,
 	"map":* 'STRING'*,
 	"policy":* 'SET_POLICY'*,
-	"flags": [* 'SET_FLAG_LIST' *],
+	"flags":* 'SET_FLAGS'*,
 	"elem":* 'SET_ELEMENTS'*,
 	"timeout":* 'NUMBER'*,
 	"gc-interval":* 'NUMBER'*,
@@ -344,6 +344,7 @@ ____
 'SET_TYPE' := 'STRING' | *[* 'SET_TYPE_LIST' *]* | *{ "typeof":* 'EXPRESSION' *}*
 'SET_TYPE_LIST' := 'STRING' [*,* 'SET_TYPE_LIST' ]
 'SET_POLICY' := *"performance"* | *"memory"*
+'SET_FLAGS' := 'SET_FLAG' | *[* 'SET_FLAG_LIST' *]*
 'SET_FLAG_LIST' := 'SET_FLAG' [*,* 'SET_FLAG_LIST' ]
 'SET_FLAG' := *"constant"* | *"interval"* | *"timeout"*
 'SET_ELEMENTS' := 'EXPRESSION' | *[* 'EXPRESSION_LIST' *]*
diff --git a/src/parser_json.c b/src/parser_json.c
index 724cba8816235..e3dd14cda3504 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -197,6 +197,60 @@ static int json_unpack_stmt(struct json_ctx *ctx, json_t *root,
 	return 1;
 }
 
+/**
+ * parse_flags_array - parse JSON property as an array of flags
+ *
+ * @ctx:		JSON parser context
+ * @obj:		JSON object to extract property from
+ * @key:		name of property containing the flags array
+ * @flag_parser:	Callback parsing a single flag, returns 0 on error
+ *
+ * The property value may be a string representing a single flag or an array of
+ * strings representing a number of flags whose values are ORed together.
+ *
+ * @return: Combined flag value, 0 if no such property found or -1 if data is
+ *          malformed or flag parsing failed.
+ */
+static int parse_flags_array(struct json_ctx *ctx, json_t *obj, const char *key,
+			     unsigned int (*flag_parser)(const char *flag))
+{
+	json_t *value = json_object_get(obj, key), *tmp;
+	size_t index;
+	int ret = 0;
+
+	if (!value)
+		return 0;
+
+	if (json_is_string(value)) {
+		ret = flag_parser(json_string_value(value));
+		return ret ?: -1;
+	}
+
+	if (!json_is_array(value)) {
+		json_error(ctx,
+			   "Expecting string or array in '%s' property.", key);
+		return -1;
+	}
+
+	json_array_foreach(value, index, tmp) {
+		int flag = 0;
+
+		if (json_is_string(tmp))
+			flag = flag_parser(json_string_value(tmp));
+
+		if (!flag) {
+			json_error(ctx,
+				   "Invalid flag in '%s' property array at index %zu.",
+				   key, index);
+			return -1;
+		}
+
+		ret |= flag;
+	}
+
+	return ret;
+}
+
 static int parse_family(const char *name, uint32_t *family)
 {
 	unsigned int i;
@@ -1077,7 +1131,7 @@ static struct expr *json_parse_hash_expr(struct json_ctx *ctx,
 	return hash_expr;
 }
 
-static int fib_flag_parse(const char *name, int *flags)
+static unsigned int fib_flag_parse(const char *name)
 {
 	const char *fib_flags[] = {
 		"saddr",
@@ -1089,12 +1143,10 @@ static int fib_flag_parse(const char *name, int *flags)
 	unsigned int i;
 
 	for (i = 0; i < array_size(fib_flags); i++) {
-		if (!strcmp(name, fib_flags[i])) {
-			*flags |= (1 << i);
-			return 0;
-		}
+		if (!strcmp(name, fib_flags[i]))
+			return 1 << i;
 	}
-	return 1;
+	return 0;
 }
 
 static struct expr *json_parse_fib_expr(struct json_ctx *ctx,
@@ -1107,11 +1159,9 @@ static struct expr *json_parse_fib_expr(struct json_ctx *ctx,
 		[NFT_FIB_RESULT_ADDRTYPE] = "type",
 	};
 	enum nft_fib_result resultval = NFT_FIB_RESULT_UNSPEC;
-	json_t *flags, *value;
 	const char *result;
-	unsigned int i;
-	size_t index;
 	int flagval = 0;
+	unsigned int i;
 
 	if (json_unpack_err(ctx, root, "{s:s}", "result", &result))
 		return NULL;
@@ -1127,34 +1177,9 @@ static struct expr *json_parse_fib_expr(struct json_ctx *ctx,
 		return NULL;
 	}
 
-	if (!json_unpack(root, "{s:o}", "flags", &flags)) {
-		const char *flag;
-
-		if (json_is_string(flags)) {
-			flag = json_string_value(flags);
-
-			if (fib_flag_parse(flag, &flagval)) {
-				json_error(ctx, "Invalid fib flag '%s'.", flag);
-				return NULL;
-			}
-		} else if (!json_is_array(flags)) {
-			json_error(ctx, "Unexpected object type in fib tuple.");
-			return NULL;
-		}
-
-		json_array_foreach(flags, index, value) {
-			if (!json_is_string(value)) {
-				json_error(ctx, "Unexpected object type in fib flags array at index %zd.", index);
-				return NULL;
-			}
-			flag = json_string_value(value);
-
-			if (fib_flag_parse(flag, &flagval)) {
-				json_error(ctx, "Invalid fib flag '%s'.", flag);
-				return NULL;
-			}
-		}
-	}
+	flagval = parse_flags_array(ctx, root, "flags", fib_flag_parse);
+	if (flagval < 0)
+		return NULL;
 
 	/* sanity checks from fib_expr in parser_bison.y */
 
@@ -2151,8 +2176,7 @@ static struct stmt *json_parse_secmark_stmt(struct json_ctx *ctx,
 	return stmt;
 }
 
-static int json_parse_nat_flag(struct json_ctx *ctx,
-			       json_t *root, int *flags)
+static unsigned int json_parse_nat_flag(const char *flag)
 {
 	const struct {
 		const char *flag;
@@ -2163,51 +2187,16 @@ static int json_parse_nat_flag(struct json_ctx *ctx,
 		{ "persistent", NF_NAT_RANGE_PERSISTENT },
 		{ "netmap", NF_NAT_RANGE_NETMAP },
 	};
-	const char *flag;
 	unsigned int i;
 
-	assert(flags);
-
-	if (!json_is_string(root)) {
-		json_error(ctx, "Invalid nat flag type %s, expected string.",
-			   json_typename(root));
-		return 1;
-	}
-	flag = json_string_value(root);
 	for (i = 0; i < array_size(flag_tbl); i++) {
-		if (!strcmp(flag, flag_tbl[i].flag)) {
-			*flags |= flag_tbl[i].val;
-			return 0;
-		}
-	}
-	json_error(ctx, "Unknown nat flag '%s'.", flag);
-	return 1;
-}
-
-static int json_parse_nat_flags(struct json_ctx *ctx, json_t *root)
-{
-	int flags = 0;
-	json_t *value;
-	size_t index;
-
-	if (json_is_string(root)) {
-		json_parse_nat_flag(ctx, root, &flags);
-		return flags;
-	} else if (!json_is_array(root)) {
-		json_error(ctx, "Invalid nat flags type %s.",
-			   json_typename(root));
-		return -1;
-	}
-	json_array_foreach(root, index, value) {
-		if (json_parse_nat_flag(ctx, value, &flags))
-			json_error(ctx, "Parsing nat flag at index %zu failed.",
-				   index);
+		if (!strcmp(flag, flag_tbl[i].flag))
+			return flag_tbl[i].val;
 	}
-	return flags;
+	return 0;
 }
 
-static int json_parse_nat_type_flag(struct json_ctx *ctx,
-				    json_t *root, int *flags)
+static unsigned int json_parse_nat_type_flag(const char *flag)
 {
 	const struct {
 		const char *flag;
@@ -2217,47 +2206,13 @@ static int json_parse_nat_type_flag(struct json_ctx *ctx,
 		{ "prefix", STMT_NAT_F_PREFIX },
 		{ "concat", STMT_NAT_F_CONCAT },
 	};
-	const char *flag;
 	unsigned int i;
 
-	assert(flags);
-
-	if (!json_is_string(root)) {
-		json_error(ctx, "Invalid nat type flag type %s, expected string.",
-			   json_typename(root));
-		return 1;
-	}
-	flag = json_string_value(root);
 	for (i = 0; i < array_size(flag_tbl); i++) {
-		if (!strcmp(flag, flag_tbl[i].flag)) {
-			*flags |= flag_tbl[i].val;
-			return 0;
-		}
-	}
-	json_error(ctx, "Unknown nat type flag '%s'.", flag);
-	return 1;
-}
-
-static int json_parse_nat_type_flags(struct json_ctx *ctx, json_t *root)
-{
-	int flags = 0;
-	json_t *value;
-	size_t index;
-
-	if (json_is_string(root)) {
-		json_parse_nat_type_flag(ctx, root, &flags);
-		return flags;
-	} else if (!json_is_array(root)) {
-		json_error(ctx, "Invalid nat flags type %s.",
-			   json_typename(root));
-		return -1;
-	}
-	json_array_foreach(root, index, value) {
-		if (json_parse_nat_type_flag(ctx, value, &flags))
-			json_error(ctx, "Parsing nat type flag at index %zu failed.",
-				   index);
+		if (!strcmp(flag, flag_tbl[i].flag))
+			return flag_tbl[i].val;
 	}
-	return flags;
+	return 0;
 }
 
 static int nat_type_parse(const char *type)
@@ -2280,7 +2235,7 @@ static int nat_type_parse(const char *type)
 static struct stmt *json_parse_nat_stmt(struct json_ctx *ctx,
 					const char *key, json_t *value)
 {
-	int type, familyval;
+	int type, familyval, flags;
 	struct stmt *stmt;
 	json_t *tmp;
 
@@ -2313,24 +2268,20 @@ static struct stmt *json_parse_nat_stmt(struct json_ctx *ctx,
 			return NULL;
 		}
 	}
-	if (!json_unpack(value, "{s:o}", "flags", &tmp)) {
-		int flags = json_parse_nat_flags(ctx, tmp);
-
-		if (flags < 0) {
-			stmt_free(stmt);
-			return NULL;
-		}
-		stmt->nat.flags = flags;
+	flags = parse_flags_array(ctx, value, "flags", json_parse_nat_flag);
+	if (flags < 0) {
+		stmt_free(stmt);
+		return NULL;
 	}
-	if (!json_unpack(value, "{s:o}", "type_flags", &tmp)) {
-		int flags = json_parse_nat_type_flags(ctx, tmp);
+	stmt->nat.flags = flags;
 
-		if (flags < 0) {
-			stmt_free(stmt);
-			return NULL;
-		}
-		stmt->nat.type_flags = flags;
+	flags = parse_flags_array(ctx, value, "type_flags",
+				  json_parse_nat_type_flag);
+	if (flags < 0) {
+		stmt_free(stmt);
+		return NULL;
 	}
+	stmt->nat.type_flags = flags;
 
 	return stmt;
 }
@@ -2563,8 +2514,7 @@ static struct stmt *json_parse_map_stmt(struct json_ctx *ctx,
 	return stmt;
 }
 
-static int json_parse_log_flag(struct json_ctx *ctx,
-			       json_t *root, int *flags)
+static unsigned int json_parse_log_flag(const char *flag)
 {
 	const struct {
 		const char *flag;
@@ -2577,47 +2527,13 @@ static int json_parse_log_flag(struct json_ctx *ctx,
 		{ "ether", NF_LOG_MACDECODE },
 		{ "all", NF_LOG_MASK },
 	};
-	const char *flag;
 	unsigned int i;
 
-	assert(flags);
-
-	if (!json_is_string(root)) {
-		json_error(ctx, "Invalid log flag type %s, expected string.",
-			   json_typename(root));
-		return 1;
-	}
-	flag = json_string_value(root);
 	for (i = 0; i < array_size(flag_tbl); i++) {
-		if (!strcmp(flag, flag_tbl[i].flag)) {
-			*flags |= flag_tbl[i].val;
-			return 0;
-		}
-	}
-	json_error(ctx, "Unknown log flag '%s'.", flag);
-	return 1;
-}
-
-static int json_parse_log_flags(struct json_ctx *ctx, json_t *root)
-{
-	int flags = 0;
-	json_t *value;
-	size_t index;
-
-	if (json_is_string(root)) {
-		json_parse_log_flag(ctx, root, &flags);
-		return flags;
-	} else if (!json_is_array(root)) {
-		json_error(ctx, "Invalid log flags type %s.",
-			   json_typename(root));
-		return -1;
-	}
-	json_array_foreach(root, index, value) {
-		if (json_parse_log_flag(ctx, value, &flags))
-			json_error(ctx, "Parsing log flag at index %zu failed.",
-				   index);
+		if (!strcmp(flag, flag_tbl[i].flag))
+			return flag_tbl[i].val;
 	}
-	return flags;
+	return 0;
 }
 
 static struct stmt *json_parse_log_stmt(struct json_ctx *ctx,
@@ -2625,8 +2541,7 @@ static struct stmt *json_parse_log_stmt(struct json_ctx *ctx,
 {
 	const char *tmpstr;
 	struct stmt *stmt;
-	json_t *jflags;
-	int tmp;
+	int tmp, flags;
 
 	stmt = log_stmt_alloc(int_loc);
 
@@ -2657,20 +2572,17 @@ static struct stmt *json_parse_log_stmt(struct json_ctx *ctx,
 		stmt->log.level = level;
 		stmt->log.flags |= STMT_LOG_LEVEL;
 	}
-	if (!json_unpack(value, "{s:o}", "flags", &jflags)) {
-		int flags = json_parse_log_flags(ctx, jflags);
-
-		if (flags < 0) {
-			stmt_free(stmt);
-			return NULL;
-		}
-		stmt->log.logflags = flags;
+	flags = parse_flags_array(ctx, value, "flags", json_parse_log_flag);
+	if (flags < 0) {
+		stmt_free(stmt);
+		return NULL;
 	}
+	stmt->log.logflags = flags;
+
 	return stmt;
 }
 
-static int json_parse_synproxy_flag(struct json_ctx *ctx,
-				    json_t *root, int *flags)
+static unsigned int json_parse_synproxy_flag(const char *flag)
 {
 	const struct {
 		const char *flag;
@@ -2679,54 +2591,19 @@ static int json_parse_synproxy_flag(struct json_ctx *ctx,
 		{ "timestamp", NF_SYNPROXY_OPT_TIMESTAMP },
 		{ "sack-perm", NF_SYNPROXY_OPT_SACK_PERM },
 	};
-	const char *flag;
 	unsigned int i;
 
-	assert(flags);
-
-	if (!json_is_string(root)) {
-		json_error(ctx, "Invalid synproxy flag type %s, expected string.",
-			   json_typename(root));
-		return 1;
-	}
-	flag = json_string_value(root);
 	for (i = 0; i < array_size(flag_tbl); i++) {
-		if (!strcmp(flag, flag_tbl[i].flag)) {
-			*flags |= flag_tbl[i].val;
-			return 0;
-		}
-	}
-	json_error(ctx, "Unknown synproxy flag '%s'.", flag);
-	return 1;
-}
-
-static int json_parse_synproxy_flags(struct json_ctx *ctx, json_t *root)
-{
-	int flags = 0;
-	json_t *value;
-	size_t index;
-
-	if (json_is_string(root)) {
-		json_parse_synproxy_flag(ctx, root, &flags);
-		return flags;
-	} else if (!json_is_array(root)) {
-		json_error(ctx, "Invalid synproxy flags type %s.",
-			   json_typename(root));
-		return -1;
-	}
-	json_array_foreach(root, index, value) {
-		if (json_parse_synproxy_flag(ctx, value, &flags))
-			json_error(ctx, "Parsing synproxy flag at index %zu failed.",
-				   index);
+		if (!strcmp(flag, flag_tbl[i].flag))
+			return flag_tbl[i].val;
 	}
-	return flags;
+	return 0;
 }
 
 static struct stmt *json_parse_synproxy_stmt(struct json_ctx *ctx,
 					     const char *key, json_t *value)
 {
 	struct stmt *stmt = NULL;
-	json_t *jflags;
 	int tmp, flags;
 
 	if (json_typeof(value) == JSON_NULL) {
@@ -2756,15 +2633,16 @@ static struct stmt *json_parse_synproxy_stmt(struct json_ctx *ctx,
 		stmt->synproxy.wscale = tmp;
 		stmt->synproxy.flags |= NF_SYNPROXY_OPT_WSCALE;
 	}
-	if (!json_unpack(value, "{s:o}", "flags", &jflags)) {
+
+	flags = parse_flags_array(ctx, value, "flags",
+				  json_parse_synproxy_flag);
+	if (flags < 0) {
+		stmt_free(stmt);
+		return NULL;
+	}
+	if (flags) {
 		if (!stmt)
 			stmt = synproxy_stmt_alloc(int_loc);
-		flags = json_parse_synproxy_flags(ctx, jflags);
-
-		if (flags < 0) {
-			stmt_free(stmt);
-			return NULL;
-		}
 		stmt->synproxy.flags |= flags;
 	}
 
@@ -2859,14 +2737,12 @@ static struct stmt *json_parse_meter_stmt(struct json_ctx *ctx,
 	return stmt;
 }
 
-static int queue_flag_parse(const char *name, uint16_t *flags)
+static unsigned int queue_flag_parse(const char *name)
 {
 	if (!strcmp(name, "bypass"))
-		*flags |= NFT_QUEUE_FLAG_BYPASS;
+		return NFT_QUEUE_FLAG_BYPASS;
 	else if (!strcmp(name, "fanout"))
-		*flags |= NFT_QUEUE_FLAG_CPU_FANOUT;
-	else
-		return 1;
+		return NFT_QUEUE_FLAG_CPU_FANOUT;
 	return 0;
 }
 
@@ -2874,8 +2750,8 @@ static struct stmt *json_parse_queue_stmt(struct json_ctx *ctx,
 					  const char *key, json_t *value)
 {
 	struct expr *qexpr = NULL;
-	uint16_t flags = 0;
 	json_t *tmp;
+	int flags;
 
 	if (!json_unpack(value, "{s:o}", "num", &tmp)) {
 		qexpr = json_parse_stmt_expr(ctx, tmp);
@@ -2884,43 +2760,13 @@ static struct stmt *json_parse_queue_stmt(struct json_ctx *ctx,
 			return NULL;
 		}
 	}
-	if (!json_unpack(value, "{s:o}", "flags", &tmp)) {
-		const char *flag;
-		size_t index;
-		json_t *val;
-
-		if (json_is_string(tmp)) {
-			flag = json_string_value(tmp);
-
-			if (queue_flag_parse(flag, &flags)) {
-				json_error(ctx, "Invalid queue flag '%s'.",
-					   flag);
-				expr_free(qexpr);
-				return NULL;
-			}
-		} else if (!json_is_array(tmp)) {
-			json_error(ctx, "Unexpected object type in queue flags.");
-			expr_free(qexpr);
-			return NULL;
-		}
-
-		json_array_foreach(tmp, index, val) {
-			if (!json_is_string(val)) {
-				json_error(ctx, "Invalid object in queue flag array at index %zu.",
-					   index);
-				expr_free(qexpr);
-				return NULL;
-			}
-			flag = json_string_value(val);
 
-			if (queue_flag_parse(flag, &flags)) {
-				json_error(ctx, "Invalid queue flag '%s'.",
-					   flag);
-				expr_free(qexpr);
-				return NULL;
-			}
-		}
+	flags = parse_flags_array(ctx, value, "flags", queue_flag_parse);
+	if (flags < 0) {
+		expr_free(qexpr);
+		return NULL;
 	}
+
 	return queue_stmt_alloc(int_loc, qexpr, flags);
 }
 
@@ -3031,45 +2877,6 @@ static struct stmt *json_parse_stmt(struct json_ctx *ctx, json_t *root)
 	return NULL;
 }
 
-static int json_parse_table_flags(struct json_ctx *ctx, json_t *root,
-				  enum table_flags *flags)
-{
-	json_t *tmp, *tmp2;
-	size_t index;
-	int flag;
-
-	if (json_unpack(root, "{s:o}", "flags", &tmp))
-		return 0;
-
-	if (json_is_string(tmp)) {
-		flag = parse_table_flag(json_string_value(tmp));
-		if (flag) {
-			*flags = flag;
-			return 0;
-		}
-		json_error(ctx, "Invalid table flag '%s'.",
-			   json_string_value(tmp));
-		return 1;
-	}
-	if (!json_is_array(tmp)) {
-		json_error(ctx, "Unexpected table flags value.");
-		return 1;
-	}
-	json_array_foreach(tmp, index, tmp2) {
-		if (json_is_string(tmp2)) {
-			flag = parse_table_flag(json_string_value(tmp2));
-
-			if (flag) {
-				*flags |= flag;
-				continue;
-			}
-		}
-		json_error(ctx, "Invalid table flag at index %zu.", index);
-		return 1;
-	}
-	return 0;
-}
-
 static struct cmd *json_parse_cmd_add_table(struct json_ctx *ctx, json_t *root,
 					    enum cmd_ops op, enum cmd_obj obj)
 {
@@ -3078,7 +2885,7 @@ static struct cmd *json_parse_cmd_add_table(struct json_ctx *ctx, json_t *root,
 		.table.location = *int_loc,
 	};
 	struct table *table = NULL;
-	enum table_flags flags = 0;
+	int flags = 0;
 
 	if (json_unpack_err(ctx, root, "{s:s}",
 			    "family", &family))
@@ -3089,9 +2896,10 @@ static struct cmd *json_parse_cmd_add_table(struct json_ctx *ctx, json_t *root,
 			return NULL;
 
 		json_unpack(root, "{s:s}", "comment", &comment);
-		if (json_parse_table_flags(ctx, root, &flags))
-			return NULL;
 
+		flags = parse_flags_array(ctx, root, "flags", parse_table_flag);
+		if (flags < 0)
+			return NULL;
 	} else if (op == CMD_DELETE &&
 		   json_unpack(root, "{s:s}", "name", &h.table.name) &&
 		   json_unpack(root, "{s:I}", "handle", &h.handle.id)) {
@@ -3363,7 +3171,7 @@ static int string_to_nft_object(const char *str)
 	return 0;
 }
 
-static int string_to_set_flag(const char *str)
+static unsigned int string_to_set_flag(const char *str)
 {
 	const struct {
 		enum nft_set_flags val;
@@ -3390,6 +3198,7 @@ static struct cmd *json_parse_cmd_add_set(struct json_ctx *ctx, json_t *root,
 	const char *family = "", *policy;
 	json_t *tmp, *stmt_json;
 	struct set *set;
+	int flags;
 
 	if (json_unpack_err(ctx, root, "{s:s, s:s}",
 			    "family", &family,
@@ -3472,23 +3281,16 @@ static struct cmd *json_parse_cmd_add_set(struct json_ctx *ctx, json_t *root,
 			return NULL;
 		}
 	}
-	if (!json_unpack(root, "{s:o}", "flags", &tmp)) {
-		json_t *value;
-		size_t index;
-
-		json_array_foreach(tmp, index, value) {
-			int flag;
 
-			if (!json_is_string(value) ||
-			    !(flag = string_to_set_flag(json_string_value(value)))) {
-				json_error(ctx, "Invalid set flag at index %zu.", index);
-				set_free(set);
-				handle_free(&h);
-				return NULL;
-			}
-			set->flags |= flag;
-		}
+	flags = parse_flags_array(ctx, root, "flags", string_to_set_flag);
+	if (flags < 0) {
+		json_error(ctx, "Invalid set flags in set '%s'.", h.set.name);
+		set_free(set);
+		handle_free(&h);
+		return NULL;
 	}
+	set->flags |= flags;
+
 	if (!json_unpack(root, "{s:o}", "elem", &tmp)) {
 		set->init = json_parse_set_expr(ctx, "elem", tmp);
 		if (!set->init) {
@@ -3673,7 +3475,6 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 	int inv = 0, flags = 0, i, j;
 	struct handle h = { 0 };
 	struct obj *obj;
-	json_t *jflags;
 
 	if (json_unpack_err(ctx, root, "{s:s, s:s}",
 			    "family", &family,
@@ -3853,13 +3654,12 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 		obj->synproxy.wscale = j;
 		obj->synproxy.flags |= NF_SYNPROXY_OPT_MSS;
 		obj->synproxy.flags |= NF_SYNPROXY_OPT_WSCALE;
-		if (!json_unpack(root, "{s:o}", "flags", &jflags)) {
-			flags = json_parse_synproxy_flags(ctx, jflags);
-			if (flags < 0)
-				goto err_free_obj;
+		flags = parse_flags_array(ctx, root, "flags",
+					  json_parse_synproxy_flag);
+		if (flags < 0)
+			goto err_free_obj;
 
-			obj->synproxy.flags |= flags;
-		}
+		obj->synproxy.flags |= flags;
 		break;
 	default:
 		BUG("Invalid CMD '%d'", cmd_obj);
-- 
2.49.0

