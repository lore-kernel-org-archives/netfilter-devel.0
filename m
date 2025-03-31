Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B977D221D9B
	for <netfilter-devel@vger.kernel.org>; Mon, 31 Mar 2025 15:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743434644; cv=none; b=OtvGv0ulWvc/0rOgnrQtbGr8Pa8JvH94XeKTVjEbdftPU2mGIbf4ikr9LOCjupoGKwDKdZBwT/ztJjTLbgBXHH3NFjwYwYvG3meA7PuNxNM5rdtwOytrQmVt6WcZrAJrwNjC/0pZEHIQFMV4DoQzRVciYfO+zgMyk1QXXAHJIlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743434644; c=relaxed/simple;
	bh=Rdi5RrOayx3EJqxrTECDbnOzPhrgNbUXCziSgPLVeNs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uJAcq2kn+p21zgiNx7cArQhTvS/MprUlcpVLbR8jExASdSyt1JwD+INIqpSxBR/6cOwpD3gFZgGg/63G5wnqeahwEUkXVvgOyamDoo/8oVdivwDi5iThys0CKXez/UTJZ5N6ouENx2DCaoWFOQ4peBqtb0hfRXr6Q6NdERCnHvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tzGzX-0004zz-Mt; Mon, 31 Mar 2025 17:23:59 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/2] evaluate: compact STMT_F_STATEFUL checks
Date: Mon, 31 Mar 2025 17:23:19 +0200
Message-ID: <20250331152323.31093-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We'll gain another F_STATEFUL check in a followup patch,
so lets condense the pattern into a helper to reduce copypaste.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index e4a7b5ceaafa..e9ab829b6bbb 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3453,6 +3453,17 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 	return expr_evaluate(ctx, &stmt->payload.val);
 }
 
+static int stmt_evaluate_stateful(struct eval_ctx *ctx, struct stmt *stmt, const char *name)
+{
+	if (stmt_evaluate(ctx, stmt) < 0)
+		return -1;
+
+	if (!(stmt->flags & STMT_F_STATEFUL))
+		return stmt_error(ctx, stmt, "%s statement must be stateful", name);
+
+	return 0;
+}
+
 static int stmt_evaluate_meter(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	struct expr *key, *setref;
@@ -3526,11 +3537,8 @@ static int stmt_evaluate_meter(struct eval_ctx *ctx, struct stmt *stmt)
 
 	stmt->meter.set = setref;
 
-	if (stmt_evaluate(ctx, stmt->meter.stmt) < 0)
+	if (stmt_evaluate_stateful(ctx, stmt->meter.stmt, "meter") < 0)
 		return -1;
-	if (!(stmt->meter.stmt->flags & STMT_F_STATEFUL))
-		return stmt_binary_error(ctx, stmt->meter.stmt, stmt,
-					 "meter statement must be stateful");
 
 	return 0;
 }
@@ -4662,11 +4670,8 @@ static int stmt_evaluate_set(struct eval_ctx *ctx, struct stmt *stmt)
 		return expr_error(ctx->msgs, stmt->set.key,
 				  "Key expression comments are not supported");
 	list_for_each_entry(this, &stmt->set.stmt_list, list) {
-		if (stmt_evaluate(ctx, this) < 0)
+		if (stmt_evaluate_stateful(ctx, this, "set") < 0)
 			return -1;
-		if (!(this->flags & STMT_F_STATEFUL))
-			return stmt_error(ctx, this,
-					  "statement must be stateful");
 	}
 
 	this_set = stmt->set.set->set;
@@ -4726,11 +4731,8 @@ static int stmt_evaluate_map(struct eval_ctx *ctx, struct stmt *stmt)
 				  "Data expression timeouts are not supported");
 
 	list_for_each_entry(this, &stmt->map.stmt_list, list) {
-		if (stmt_evaluate(ctx, this) < 0)
+		if (stmt_evaluate_stateful(ctx, this, "map") < 0)
 			return -1;
-		if (!(this->flags & STMT_F_STATEFUL))
-			return stmt_error(ctx, this,
-					  "statement must be stateful");
 	}
 
 	return 0;
-- 
2.49.0

