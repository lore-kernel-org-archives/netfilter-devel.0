Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FFA1E008B
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Jun 2025 17:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750958511; cv=none; b=hKRvCQOjxz2Er6AhF50YR9F3hU7s0RkiVVUPOkHwgAN1cU/D5R20zF88Ctzh/7etLoz5ObeSZG15fNm3lz3mKqQTjet4w9iMGuyHaBf0LoFLjLhNgWZRorI+h5xbRTs4DJ7DOs4gx+68Qw1ND5SfZBAaKwwQXOgFQkwzuD7wO+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750958511; c=relaxed/simple;
	bh=YdvQVRga3jfyJkzKX1VkinaZ7965f13dffhom4O5cAA=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=jBWbnkUbYGrfUhyh9Vmt3m3YpVuIVkHDfSS/WugQ+ypE9z/qqK5QGcHBFDzr0Ocw6UluLGADRVobvebKgB9CsZnhqkp33foa8/ZTR2r/QMilJk99SXeLScuxfaG1T5llVVunJ3nlKjnlfvv0/zGF8Rzd1DxWE3S6P/9MRyyUV+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=D4n18Een; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=D4n18Een; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="D4n18Een";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="D4n18Een"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C4C9A6029E; Thu, 26 Jun 2025 19:21:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750958503;
	bh=xQBXFQSrb5+kByR0M5vSCEtJYb84NFqdVFl/AsqrDXY=;
	h=From:To:Subject:Date:From;
	b=D4n18EenzbnUjfkDTJ3+3mJ7iw3afdEXcS6NsmRgpnQtdVLK96NGn8DYjrMS27HWO
	 If9CeijMZxNv41B/Q+kjQKSjafdMXmW/HNkh7NQ0lAopDbiTLebB8Hnv2K4QpmzM92
	 JP0vtRwTbUO15LKyFZ+iTQcvC5qujwPSVcUgbOYjHaAdvdrRHzvWRtUz82q/BxQM38
	 RRKU7qqGyru9X0QDvAZSXKqnGDDbVwOvqbL6v96c2bPcm7VMO7JjZxSQK2AsAob0ej
	 EN9JXAhpfBZKxc6bTR/mSGAa0uoH0w2iiriCi1Q2Urem+A4fg6c8SPDAzfTZwAM6Az
	 sepYbZZOMuFzA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 128036029C
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Jun 2025 19:21:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750958503;
	bh=xQBXFQSrb5+kByR0M5vSCEtJYb84NFqdVFl/AsqrDXY=;
	h=From:To:Subject:Date:From;
	b=D4n18EenzbnUjfkDTJ3+3mJ7iw3afdEXcS6NsmRgpnQtdVLK96NGn8DYjrMS27HWO
	 If9CeijMZxNv41B/Q+kjQKSjafdMXmW/HNkh7NQ0lAopDbiTLebB8Hnv2K4QpmzM92
	 JP0vtRwTbUO15LKyFZ+iTQcvC5qujwPSVcUgbOYjHaAdvdrRHzvWRtUz82q/BxQM38
	 RRKU7qqGyru9X0QDvAZSXKqnGDDbVwOvqbL6v96c2bPcm7VMO7JjZxSQK2AsAob0ej
	 EN9JXAhpfBZKxc6bTR/mSGAa0uoH0w2iiriCi1Q2Urem+A4fg6c8SPDAzfTZwAM6Az
	 sepYbZZOMuFzA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: provide elem_stmt structure to shrink compact counters
Date: Thu, 26 Jun 2025 19:21:37 +0200
Message-Id: <20250626172137.1350024-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add struct elem_stmt with same layout as struct stmt, this introduces a
variant of the statement object with a flexible array to allocate the
data area for counter/quota/limit/ct count/last.

Shrink from 52.48 Mbytes to 48.86 Mbytes for a set of 100k elements with
counters, this provides a reduction of 6.89% in memory footprint.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/statement.h | 23 +++++++++++++++
 src/intervals.c     |  8 +++--
 src/optimize.c      | 18 +++++++-----
 src/parser_bison.y  | 72 ++++++++++++++++++++++++++++++++++++++++-----
 src/statement.c     | 58 ++++++++++++++++++++++++++++++++----
 5 files changed, 157 insertions(+), 22 deletions(-)

diff --git a/include/statement.h b/include/statement.h
index e8724dde63d0..ab1ff2476db8 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -348,6 +348,7 @@ enum stmt_types {
  * struct stmt_ops
  *
  * @type:	statement type
+ * @size:	size
  * @name:	name
  * @destroy:	destructor
  * @print:	function to print statement
@@ -355,6 +356,7 @@ enum stmt_types {
 struct stmt;
 struct stmt_ops {
 	enum stmt_types		type;
+	uint32_t		size;
 	const char		*name;
 	void			(*destroy)(struct stmt *stmt);
 	void			(*print)(const struct stmt *stmt,
@@ -426,4 +428,25 @@ const struct stmt_ops *stmt_ops(const struct stmt *stmt);
 const char *get_rate(uint64_t byte_rate, uint64_t *rate);
 const char *get_unit(uint64_t u);
 
+struct elem_stmt {
+	/* same layout as struct stmt. */
+	struct list_head		list;
+	struct location			location;
+	enum stmt_flags			flags;
+	enum stmt_types			type:8;
+
+	char				data[] __attribute__ ((aligned (__alignof__(sizeof(long)))));;
+};
+
+struct elem_stmt *elem_stmt_alloc(const struct location *loc,
+				  const struct stmt_ops *ops);
+void elem_stmt_free(const struct elem_stmt *elem_stmt);
+const struct stmt_ops *elem_stmt_ops(const struct elem_stmt *stmt);
+
+extern const struct stmt_ops counter_stmt_ops;
+extern const struct stmt_ops limit_stmt_ops;
+extern const struct stmt_ops quota_stmt_ops;
+extern const struct stmt_ops connlimit_stmt_ops;
+extern const struct stmt_ops last_stmt_ops;
+
 #endif /* NFTABLES_STATEMENT_H */
diff --git a/src/intervals.c b/src/intervals.c
index bf125a0c59d3..5462eca29685 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -723,11 +723,13 @@ int set_to_intervals(const struct set *set, struct expr *init, bool add)
 /* This only works for the supported stateful statements. */
 static void set_elem_stmt_clone(struct expr *dst, const struct expr *src)
 {
-	struct stmt *stmt, *nstmt;
+	struct elem_stmt *stmt, *nstmt;
+	const struct stmt_ops *ops;
 
 	list_for_each_entry(stmt, &src->stmt_list, list) {
-		nstmt = xzalloc(sizeof(*stmt));
-		*nstmt = *stmt;
+		ops = elem_stmt_ops(stmt);
+		nstmt = xzalloc(sizeof(*stmt) + ops->size);
+		memcpy(nstmt, stmt, sizeof(*stmt) + ops->size);
 		list_add_tail(&nstmt->list, &dst->stmt_list);
 	}
 }
diff --git a/src/optimize.c b/src/optimize.c
index 89ba0d9dee6a..999e89c206ff 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -746,14 +746,15 @@ static void build_verdict_map(struct expr *expr, struct stmt *verdict,
 			      struct expr *set, struct stmt *counter)
 {
 	struct expr *item, *elem, *mapping;
-	struct stmt *counter_elem;
+	struct elem_stmt *counter_elem;
 
 	switch (expr->etype) {
 	case EXPR_LIST:
 		list_for_each_entry(item, &expr->expressions, list) {
 			elem = set_elem_expr_alloc(&internal_location, expr_get(item));
 			if (counter) {
-				counter_elem = counter_stmt_alloc(&counter->location);
+				counter_elem = elem_stmt_alloc(&counter->location,
+							       &counter_stmt_ops);
 				list_add_tail(&counter_elem->list, &elem->stmt_list);
 			}
 
@@ -761,13 +762,13 @@ static void build_verdict_map(struct expr *expr, struct stmt *verdict,
 						     expr_get(verdict->expr));
 			compound_expr_add(set, mapping);
 		}
-		stmt_free(counter);
 		break;
 	case EXPR_SET:
 		list_for_each_entry(item, &expr->expressions, list) {
 			elem = set_elem_expr_alloc(&internal_location, expr_get(item->key));
 			if (counter) {
-				counter_elem = counter_stmt_alloc(&counter->location);
+				counter_elem = elem_stmt_alloc(&counter->location,
+							       &counter_stmt_ops);
 				list_add_tail(&counter_elem->list, &elem->stmt_list);
 			}
 
@@ -775,7 +776,6 @@ static void build_verdict_map(struct expr *expr, struct stmt *verdict,
 						     expr_get(verdict->expr));
 			compound_expr_add(set, mapping);
 		}
-		stmt_free(counter);
 		break;
 	case EXPR_PREFIX:
 	case EXPR_RANGE_SYMBOL:
@@ -785,8 +785,11 @@ static void build_verdict_map(struct expr *expr, struct stmt *verdict,
 	case EXPR_SYMBOL:
 	case EXPR_CONCAT:
 		elem = set_elem_expr_alloc(&internal_location, expr_get(expr));
-		if (counter)
-			list_add_tail(&counter->list, &elem->stmt_list);
+		if (counter) {
+			counter_elem = elem_stmt_alloc(&counter->location,
+						       &counter_stmt_ops);
+			list_add_tail(&counter_elem->list, &elem->stmt_list);
+		}
 
 		mapping = mapping_expr_alloc(&internal_location, elem,
 					     expr_get(verdict->expr));
@@ -796,6 +799,7 @@ static void build_verdict_map(struct expr *expr, struct stmt *verdict,
 		assert(0);
 		break;
 	}
+	stmt_free(counter);
 }
 
 static void remove_counter(const struct optimize_ctx *ctx, uint32_t from)
diff --git a/src/parser_bison.y b/src/parser_bison.y
index f9cc909836bc..11de82155ab1 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -247,6 +247,7 @@ int nft_lex(void *, void *, void *);
 		uint8_t field;
 	} tcp_kind_field;
 	struct timeout_state	*timeout_state;
+	struct elem_stmt	*elem_stmt;
 }
 
 %token TOKEN_EOF 0		"end of file"
@@ -766,8 +767,8 @@ int nft_lex(void *, void *, void *);
 
 %type <list>			stmt_list stateful_stmt_list set_elem_stmt_list
 %destructor { stmt_list_free($$); free($$); } stmt_list stateful_stmt_list set_elem_stmt_list
-%type <stmt>			stmt match_stmt verdict_stmt set_elem_stmt
-%destructor { stmt_free($$); }	stmt match_stmt verdict_stmt set_elem_stmt
+%type <stmt>			stmt match_stmt verdict_stmt
+%destructor { stmt_free($$); }	stmt match_stmt verdict_stmt
 %type <stmt>			counter_stmt counter_stmt_alloc stateful_stmt last_stmt
 %destructor { stmt_free($$); }	counter_stmt counter_stmt_alloc stateful_stmt last_stmt
 %type <stmt>			limit_stmt_alloc quota_stmt_alloc last_stmt_alloc ct_limit_stmt_alloc
@@ -775,6 +776,16 @@ int nft_lex(void *, void *, void *);
 %type <stmt>			objref_stmt objref_stmt_counter objref_stmt_limit objref_stmt_quota objref_stmt_ct objref_stmt_synproxy
 %destructor { stmt_free($$); }	objref_stmt objref_stmt_counter objref_stmt_limit objref_stmt_quota objref_stmt_ct objref_stmt_synproxy
 
+%type <elem_stmt>		counter_elem_stmt_alloc quota_elem_stmt_alloc ct_limit_elem_stmt_alloc
+%destructor { elem_stmt_free($$); } counter_elem_stmt_alloc quota_elem_stmt_alloc ct_limit_elem_stmt_alloc
+%type <elem_stmt>		limit_elem_stmt_alloc last_elem_stmt_alloc
+%destructor { elem_stmt_free($$); } limit_elem_stmt_alloc last_elem_stmt_alloc
+
+%type <elem_stmt>		set_elem_stmt counter_elem_stmt
+%destructor { elem_stmt_free($$); } set_elem_stmt counter_elem_stmt
+%type <elem_stmt>		quota_elem_stmt limit_elem_stmt connlimit_elem_stmt last_elem_stmt
+%destructor { elem_stmt_free($$); } quota_elem_stmt limit_elem_stmt connlimit_elem_stmt last_elem_stmt
+
 %type <stmt>			payload_stmt
 %destructor { stmt_free($$); }	payload_stmt
 %type <stmt>			ct_stmt
@@ -4663,11 +4674,58 @@ set_elem_stmt_list	:	set_elem_stmt
 			}
 			;
 
-set_elem_stmt		:	counter_stmt	close_scope_counter
-			|	limit_stmt	close_scope_limit
-			|	connlimit_stmt	close_scope_ct
-			|	quota_stmt	close_scope_quota
-			|	last_stmt	close_scope_last
+set_elem_stmt		:	counter_elem_stmt	close_scope_counter
+			|	limit_elem_stmt		close_scope_limit
+			|	connlimit_elem_stmt	close_scope_ct
+			|	quota_elem_stmt		close_scope_quota
+			|	last_elem_stmt		close_scope_last
+			;
+
+counter_elem_stmt	:	counter_elem_stmt_alloc
+			|	counter_elem_stmt_alloc	counter_args
+			;
+
+counter_elem_stmt_alloc	:	COUNTER
+			{
+				$$ = elem_stmt_alloc(&@$, &counter_stmt_ops);
+			}
+			;
+
+limit_elem_stmt_alloc	:	LIMIT RATE
+			{
+				$$ = elem_stmt_alloc(&@$, &limit_stmt_ops);
+			}
+			;
+
+limit_elem_stmt		:	limit_elem_stmt_alloc	limit_args
+			;
+
+quota_elem_stmt_alloc	:	QUOTA
+			{
+				$$ = elem_stmt_alloc(&@$, &quota_stmt_ops);
+			}
+			;
+
+quota_elem_stmt		:	quota_elem_stmt_alloc	quota_args
+			;
+
+ct_limit_elem_stmt_alloc:	CT	COUNT
+			{
+				$$ = elem_stmt_alloc(&@$, &connlimit_stmt_ops);
+			}
+			;
+
+connlimit_elem_stmt	:	ct_limit_elem_stmt_alloc	ct_limit_args
+			;
+
+last_elem_stmt_alloc	:	LAST
+			{
+				$$ = elem_stmt_alloc(&@$, &last_stmt_ops);
+			}
+			;
+
+last_elem_stmt		:	last_elem_stmt_alloc
+			|	last_elem_stmt_alloc	last_args
 			;
 
 set_elem_expr_option	:	TIMEOUT		set_elem_time_spec
diff --git a/src/statement.c b/src/statement.c
index 695b57a6cc65..ed2e37a32566 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -74,6 +74,23 @@ void stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 	ops->print(stmt, octx);
 }
 
+struct elem_stmt *elem_stmt_alloc(const struct location *loc,
+				  const struct stmt_ops *ops)
+{
+	struct elem_stmt *elem_stmt;
+
+	elem_stmt = xzalloc(sizeof(*elem_stmt) + ops->size);
+	init_list_head(&elem_stmt->list);
+	elem_stmt->location = *loc;
+	elem_stmt->type = ops->type;
+	return elem_stmt;
+}
+
+void elem_stmt_free(const struct elem_stmt *elem_stmt)
+{
+	stmt_free((struct stmt *)elem_stmt);
+}
+
 static void expr_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
 	expr_print(stmt->expr, octx);
@@ -210,9 +227,10 @@ static void connlimit_stmt_print(const struct stmt *stmt, struct output_ctx *oct
 		  stmt->connlimit.flags ? "over " : "", stmt->connlimit.count);
 }
 
-static const struct stmt_ops connlimit_stmt_ops = {
+const struct stmt_ops connlimit_stmt_ops = {
 	.type		= STMT_CONNLIMIT,
 	.name		= "connlimit",
+	.size		= sizeof(struct connlimit_stmt),
 	.print		= connlimit_stmt_print,
 	.json		= connlimit_stmt_json,
 };
@@ -237,9 +255,10 @@ static void counter_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 		  stmt->counter.packets, stmt->counter.bytes);
 }
 
-static const struct stmt_ops counter_stmt_ops = {
+const struct stmt_ops counter_stmt_ops = {
 	.type		= STMT_COUNTER,
 	.name		= "counter",
+	.size		= sizeof(struct counter_stmt),
 	.print		= counter_stmt_print,
 	.json		= counter_stmt_json,
 };
@@ -268,9 +287,10 @@ static void last_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 		nft_print(octx, "never");
 }
 
-static const struct stmt_ops last_stmt_ops = {
+const struct stmt_ops last_stmt_ops = {
 	.type		= STMT_LAST,
 	.name		= "last",
+	.size		= sizeof(struct last_stmt),
 	.print		= last_stmt_print,
 	.json		= last_stmt_json,
 };
@@ -505,9 +525,10 @@ static void limit_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 	}
 }
 
-static const struct stmt_ops limit_stmt_ops = {
+const struct stmt_ops limit_stmt_ops = {
 	.type		= STMT_LIMIT,
 	.name		= "limit",
+	.size		= sizeof(struct limit_stmt),
 	.print		= limit_stmt_print,
 	.json		= limit_stmt_json,
 };
@@ -584,9 +605,10 @@ static void quota_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 	}
 }
 
-static const struct stmt_ops quota_stmt_ops = {
+const struct stmt_ops quota_stmt_ops = {
 	.type		= STMT_QUOTA,
 	.name		= "quota",
+	.size		= sizeof(struct quota_stmt),
 	.print		= quota_stmt_print,
 	.json		= quota_stmt_json,
 };
@@ -1085,6 +1107,32 @@ struct stmt *synproxy_stmt_alloc(const struct location *loc)
 	return stmt_alloc(loc, &synproxy_stmt_ops);
 }
 
+static const struct stmt_ops *__elem_stmt_ops_by_type(enum stmt_types type)
+{
+	switch (type) {
+	case STMT_COUNTER: return &counter_stmt_ops;
+	case STMT_LIMIT: return &limit_stmt_ops;
+	case STMT_QUOTA: return &quota_stmt_ops;
+	case STMT_CONNLIMIT: return &connlimit_stmt_ops;
+	case STMT_LAST: return &last_stmt_ops;
+	default:
+		break;
+	}
+
+	return NULL;
+}
+
+const struct stmt_ops *elem_stmt_ops(const struct elem_stmt *stmt)
+{
+	const struct stmt_ops *ops;
+
+	ops = __elem_stmt_ops_by_type(stmt->type);
+	if (!ops)
+		BUG("Unknown element statement type %d\n", stmt->type);
+
+	return ops;
+}
+
 /* For src/optimize.c */
 static struct stmt_ops invalid_stmt_ops = {
 	.type	= STMT_INVALID,
-- 
2.30.2

