Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CFFC5FBB3
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Mar 2024 15:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711122550; cv=none; b=UB8T7jyJCectrcqPf/zGYU3uzytt45em88tQviztk0LydLgIlGAdTht43NyLb5U19MGw0KFwjGOdRH8vImJ6HNOtOxoraZQ1NlQnYCU3RP7hNtN2u3gblar2FXpmW1ulCJZuKNzIWg5opUxvOvNswCY2aIzNuGekSuZ265otMcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711122550; c=relaxed/simple;
	bh=5jWgSBFUTQL74PHtvteLO2WdVLBesYkfJ8pHq/Xbb3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IpX8fjE1SPq6D8rInUpBmydX/HhbHol8pERSXAt2wKgTq1wUM19b/ZTloKL8HzQDq6fUOhgs0oenz/Qkhf08+OgINAVqoAKKYb2sOQEbOi3zTyoylml4Q+sP7Hmm9KgioiY0raqYsyclj6prwYHhV1q2nhnD9GgJ1fivtQMPrPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Dyf+wU4q; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Dyf+wU4q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=i84m+uEntp2xn+Ki6ksHyIJB5JMPc3P9ROT99O+jfNA=; b=Dyf+wU4q9VOMyvlU1rWCdZ/kqV
	8jc/YrC2eq+NTwXKpV6SFLAp5EvVytgbB/wQdKdcZZweHP+ElAEQwt9y7CfVBBLEfz3/xTSXgD8Aw
	+sogVHN1Vjz+TEZm5sV0AY9IvgBx9tsxsbNlm/pEaWYj1cvUGGEoPoAnzW168gNvQlwZo20FJqlBO
	cDhKioL1+4/CcOjxHEr4oRLfLOe+xpUiq+hDkvdkihJxJzjwkqMCDKmfZ6TgCEFG7Dk32RN3aUPDb
	NyO0sJmLQchZCSUy4TWGA9piwGYZmiaZGlR5SeVHi0YVNjKVqXkgQ8mfrMixnXPyBxwPTV9EBBqFQ
	WKuBhRrA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rnh8d-000000000nd-22Zi;
	Fri, 22 Mar 2024 16:48:59 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/2] Add support for table's persist flag
Date: Fri, 22 Mar 2024 16:48:55 +0100
Message-ID: <20240322154855.13857-3-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240322154855.13857-1-phil@nwl.cc>
References: <20240322154855.13857-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Bison parser lacked support for passing multiple flags, JSON parser
did not support table flags at all.

Document also 'owner' flag (and describe their relationship in nft.8.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/libnftables-json.adoc                   | 11 +++-
 doc/nft.txt                                 |  9 +++
 include/rule.h                              |  3 +-
 src/parser_bison.y                          | 42 +++++++++----
 src/parser_json.c                           | 68 ++++++++++++++++++++-
 src/rule.c                                  |  1 +
 tests/shell/features/table_flag_persist.nft |  3 +
 tests/shell/testcases/owner/0002-persist    | 36 +++++++++++
 8 files changed, 156 insertions(+), 17 deletions(-)
 create mode 100644 tests/shell/features/table_flag_persist.nft
 create mode 100755 tests/shell/testcases/owner/0002-persist

diff --git a/doc/libnftables-json.adoc b/doc/libnftables-json.adoc
index 3948a0bad47c1..a4adcde2a66a9 100644
--- a/doc/libnftables-json.adoc
+++ b/doc/libnftables-json.adoc
@@ -202,12 +202,19 @@ Rename a chain. The new name is expected in a dedicated property named
 
 === TABLE
 [verse]
+____
 *{ "table": {
 	"family":* 'STRING'*,
 	"name":* 'STRING'*,
-	"handle":* 'NUMBER'
+	"handle":* 'NUMBER'*,
+	"flags":* 'TABLE_FLAGS'
 *}}*
 
+'TABLE_FLAGS' := 'TABLE_FLAG' | *[* 'TABLE_FLAG_LIST' *]*
+'TABLE_FLAG_LIST' := 'TABLE_FLAG' [*,* 'TABLE_FLAG_LIST' ]
+'TABLE_FLAG' := *"dormant"* | *"owner"* | *"persist"*
+____
+
 This object describes a table.
 
 *family*::
@@ -217,6 +224,8 @@ This object describes a table.
 *handle*::
 	The table's handle. In input, it is used only in *delete* command as
 	alternative to *name*.
+*flags*::
+	The table's flags.
 
 === CHAIN
 [verse]
diff --git a/doc/nft.txt b/doc/nft.txt
index 248b29af369ad..2080c07350f6d 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -343,8 +343,17 @@ return an error.
 |Flag | Description
 |dormant |
 table is not evaluated any more (base chains are unregistered).
+|owner |
+table is owned by the creating process.
+|persist |
+table shall outlive the owning process.
 |=================
 
+Creating a table with flag *owner* excludes other processes from manipulating
+it or its contents. By default, it will be removed when the process exits.
+Setting flag *persist* will prevent this and the resulting orphaned table will
+accept a new owner, e.g. a restarting daemon maintaining the table.
+
 .*Add, change, delete a table*
 ---------------------------------------
 # start nft in interactive mode
diff --git a/include/rule.h b/include/rule.h
index 3a833cf3a4588..2f8292ee9dc32 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -130,8 +130,9 @@ struct symbol *symbol_get(const struct scope *scope, const char *identifier);
 enum table_flags {
 	TABLE_F_DORMANT		= (1 << 0),
 	TABLE_F_OWNER		= (1 << 1),
+	TABLE_F_PERSIST		= (1 << 2),
 };
-#define TABLE_FLAGS_MAX		2
+#define TABLE_FLAGS_MAX		3
 
 const char *table_flag_name(uint32_t flag);
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index bdb73911759c8..1ade7417f8d6a 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -742,6 +742,8 @@ int nft_lex(void *, void *, void *);
 %type <rule>			rule rule_alloc
 %destructor { rule_free($$); }	rule
 
+%type <val>			table_flags table_flag
+
 %type <val>			set_flag_list	set_flag
 
 %type <val>			set_policy_spec
@@ -1905,20 +1907,9 @@ table_block_alloc	:	/* empty */
 			}
 			;
 
-table_options		:	FLAGS		STRING
+table_options		:	FLAGS		table_flags
 			{
-				if (strcmp($2, "dormant") == 0) {
-					$<table>0->flags |= TABLE_F_DORMANT;
-					free_const($2);
-				} else if (strcmp($2, "owner") == 0) {
-					$<table>0->flags |= TABLE_F_OWNER;
-					free_const($2);
-				} else {
-					erec_queue(error(&@2, "unknown table option %s", $2),
-						   state->msgs);
-					free_const($2);
-					YYERROR;
-				}
+				$<table>0->flags |= $2;
 			}
 			|	comment_spec
 			{
@@ -1930,6 +1921,31 @@ table_options		:	FLAGS		STRING
 			}
 			;
 
+table_flags		:	table_flag
+			|	table_flags	COMMA	table_flag
+			{
+				$$ = $1 | $3;
+			}
+			;
+table_flag		:	STRING
+			{
+				if (strcmp($1, "dormant") == 0) {
+					$$ = TABLE_F_DORMANT;
+					free_const($1);
+				} else if (strcmp($1, "owner") == 0) {
+					$$ = TABLE_F_OWNER;
+				} else if (strcmp($1, "persist") == 0) {
+					$$ = TABLE_F_PERSIST;
+					free_const($1);
+				} else {
+					erec_queue(error(&@1, "unknown table option %s", $1),
+						   state->msgs);
+					free_const($1);
+					YYERROR;
+				}
+			}
+			;
+
 table_block		:	/* empty */	{ $$ = $<table>-1; }
 			|	table_block	common_block
 			|	table_block	stmt_separator
diff --git a/src/parser_json.c b/src/parser_json.c
index 4fc0479cf4972..04255688ca04c 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2954,6 +2954,64 @@ static struct stmt *json_parse_stmt(struct json_ctx *ctx, json_t *root)
 	return NULL;
 }
 
+static int string_to_table_flag(const char *str)
+{
+	const struct {
+		enum table_flags val;
+		const char *name;
+	} flag_tbl[] = {
+		{ TABLE_F_DORMANT, "dormant" },
+		{ TABLE_F_OWNER,   "owner" },
+		{ TABLE_F_PERSIST, "persist" },
+	};
+	unsigned int i;
+
+	for (i = 0; i < array_size(flag_tbl); i++) {
+		if (!strcmp(str, flag_tbl[i].name))
+			return flag_tbl[i].val;
+	}
+	return 0;
+}
+
+static int json_parse_table_flags(struct json_ctx *ctx, json_t *root,
+				  enum table_flags *flags)
+{
+	json_t *tmp, *tmp2;
+	size_t index;
+	int flag;
+
+	if (json_unpack(root, "{s:o}", "flags", &tmp))
+		return 0;
+
+	if (json_is_string(tmp)) {
+		flag = string_to_table_flag(json_string_value(tmp));
+		if (flag) {
+			*flags = flag;
+			return 0;
+		}
+		json_error(ctx, "Invalid table flag '%s'.",
+			   json_string_value(tmp));
+		return 1;
+	}
+	if (!json_is_array(tmp)) {
+		json_error(ctx, "Unexpected table flags value.");
+		return 1;
+	}
+	json_array_foreach(tmp, index, tmp2) {
+		if (json_is_string(tmp2)) {
+			flag = string_to_table_flag(json_string_value(tmp2));
+
+			if (flag) {
+				*flags |= flag;
+				continue;
+			}
+		}
+		json_error(ctx, "Invalid table flag at index %zu.", index);
+		return 1;
+	}
+	return 0;
+}
+
 static struct cmd *json_parse_cmd_add_table(struct json_ctx *ctx, json_t *root,
 					    enum cmd_ops op, enum cmd_obj obj)
 {
@@ -2962,6 +3020,7 @@ static struct cmd *json_parse_cmd_add_table(struct json_ctx *ctx, json_t *root,
 		.table.location = *int_loc,
 	};
 	struct table *table = NULL;
+	enum table_flags flags = 0;
 
 	if (json_unpack_err(ctx, root, "{s:s}",
 			    "family", &family))
@@ -2972,6 +3031,9 @@ static struct cmd *json_parse_cmd_add_table(struct json_ctx *ctx, json_t *root,
 			return NULL;
 
 		json_unpack(root, "{s:s}", "comment", &comment);
+		if (json_parse_table_flags(ctx, root, &flags))
+			return NULL;
+
 	} else if (op == CMD_DELETE &&
 		   json_unpack(root, "{s:s}", "name", &h.table.name) &&
 		   json_unpack(root, "{s:I}", "handle", &h.handle.id)) {
@@ -2985,10 +3047,12 @@ static struct cmd *json_parse_cmd_add_table(struct json_ctx *ctx, json_t *root,
 	if (h.table.name)
 		h.table.name = xstrdup(h.table.name);
 
-	if (comment) {
+	if (comment || flags) {
 		table = table_alloc();
 		handle_merge(&table->handle, &h);
-		table->comment = xstrdup(comment);
+		if (comment)
+			table->comment = xstrdup(comment);
+		table->flags = flags;
 	}
 
 	if (op == CMD_ADD)
diff --git a/src/rule.c b/src/rule.c
index 45289cc01dce8..6e56a129c81d1 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1215,6 +1215,7 @@ struct table *table_lookup_fuzzy(const struct handle *h,
 static const char *table_flags_name[TABLE_FLAGS_MAX] = {
 	"dormant",
 	"owner",
+	"persist",
 };
 
 const char *table_flag_name(uint32_t flag)
diff --git a/tests/shell/features/table_flag_persist.nft b/tests/shell/features/table_flag_persist.nft
new file mode 100644
index 0000000000000..0da3e6d4f03ff
--- /dev/null
+++ b/tests/shell/features/table_flag_persist.nft
@@ -0,0 +1,3 @@
+table t {
+	flags persist;
+}
diff --git a/tests/shell/testcases/owner/0002-persist b/tests/shell/testcases/owner/0002-persist
new file mode 100755
index 0000000000000..cf4b8f1327ec1
--- /dev/null
+++ b/tests/shell/testcases/owner/0002-persist
@@ -0,0 +1,36 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_table_flag_owner)
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_table_flag_persist)
+
+die() {
+	echo "$@"
+	exit 1
+}
+
+$NFT -f - <<EOF
+table ip t {
+	flags owner, persist
+}
+EOF
+[[ $? -eq 0 ]] || {
+	die "table add failed"
+}
+
+$NFT list ruleset | grep -q 'table ip t' || {
+	die "table does not persist"
+}
+$NFT list ruleset | grep -q 'flags persist$' || {
+	die "unexpected flags in orphaned table"
+}
+
+$NFT -f - <<EOF
+table ip t {
+	flags owner, persist
+}
+EOF
+[[ $? -eq 0 ]] || {
+	die "retake ownership failed"
+}
+
+exit 0
-- 
2.43.0

