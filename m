Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88C7DC433FE
	for <netfilter-devel@archiver.kernel.org>; Sun,  2 Jan 2022 22:15:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbiABWPC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 2 Jan 2022 17:15:02 -0500
Received: from mail.netfilter.org ([217.70.188.207]:56128 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiABWPB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 2 Jan 2022 17:15:01 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8F39B63F57
        for <netfilter-devel@vger.kernel.org>; Sun,  2 Jan 2022 23:12:16 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables,v2 1/7] erec: expose print_location() and line_location()
Date:   Sun,  2 Jan 2022 23:14:46 +0100
Message-Id: <20220102221452.86469-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220102221452.86469-1-pablo@netfilter.org>
References: <20220102221452.86469-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a few helper functions to reuse code in the new rule optimization
infrastructure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/erec.h |  5 ++++
 include/rule.h |  1 -
 src/erec.c     | 81 +++++++++++++++++++++++++++++++-------------------
 3 files changed, 56 insertions(+), 31 deletions(-)

diff --git a/include/erec.h b/include/erec.h
index 79a162902304..c17f5def5302 100644
--- a/include/erec.h
+++ b/include/erec.h
@@ -76,4 +76,9 @@ extern int __fmtstring(4, 5) __stmt_binary_error(struct eval_ctx *ctx,
 #define stmt_binary_error(ctx, s1, s2, fmt, args...) \
 	__stmt_binary_error(ctx, &(s1)->location, &(s2)->location, fmt, ## args)
 
+void print_location(FILE *f, const struct input_descriptor *indesc,
+		    const struct location *loc);
+const char *line_location(const struct input_descriptor *indesc,
+			  const struct location *loc, char *buf, size_t bufsiz);
+
 #endif /* NFTABLES_EREC_H */
diff --git a/include/rule.h b/include/rule.h
index be31695636df..150576641b39 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -311,7 +311,6 @@ void rule_stmt_append(struct rule *rule, struct stmt *stmt);
 void rule_stmt_insert_at(struct rule *rule, struct stmt *nstmt,
 			 struct stmt *stmt);
 
-
 /**
  * struct set - nftables set
  *
diff --git a/src/erec.c b/src/erec.c
index 5c3351a51246..7c9165c290d8 100644
--- a/src/erec.c
+++ b/src/erec.c
@@ -81,11 +81,57 @@ struct error_record *erec_create(enum error_record_types type,
 	return erec;
 }
 
+void print_location(FILE *f, const struct input_descriptor *indesc,
+		    const struct location *loc)
+{
+	const struct input_descriptor *tmp;
+	const struct location *iloc;
+
+	if (indesc->location.indesc != NULL) {
+		const char *prefix = "In file included from";
+		iloc = &indesc->location;
+		for (tmp = iloc->indesc;
+		     tmp != NULL && tmp->type != INDESC_INTERNAL;
+		     tmp = iloc->indesc) {
+			fprintf(f, "%s %s:%u:%u-%u:\n", prefix,
+				tmp->name,
+				iloc->first_line, iloc->first_column,
+				iloc->last_column);
+			prefix = "                 from";
+			iloc = &tmp->location;
+		}
+	}
+	if (indesc->name != NULL)
+		fprintf(f, "%s:%u:%u-%u: ", indesc->name,
+			loc->first_line, loc->first_column,
+			loc->last_column);
+}
+
+const char *line_location(const struct input_descriptor *indesc,
+			  const struct location *loc, char *buf, size_t bufsiz)
+{
+	const char *line;
+	FILE *f;
+
+	f = fopen(indesc->name, "r");
+	if (!f)
+		return NULL;
+
+	if (!fseek(f, loc->line_offset, SEEK_SET) &&
+	    fread(buf, 1, bufsiz - 1, f) > 0) {
+		*strchrnul(buf, '\n') = '\0';
+		line = buf;
+	}
+	fclose(f);
+
+	return line;
+}
+
 void erec_print(struct output_ctx *octx, const struct error_record *erec,
 		unsigned int debug_mask)
 {
-	const struct location *loc = erec->locations, *iloc;
-	const struct input_descriptor *indesc = loc->indesc, *tmp;
+	const struct location *loc = erec->locations;
+	const struct input_descriptor *indesc = loc->indesc;
 	const char *line = NULL;
 	char buf[1024] = {};
 	char *pbuf = NULL;
@@ -100,16 +146,7 @@ void erec_print(struct output_ctx *octx, const struct error_record *erec,
 		*strchrnul(line, '\n') = '\0';
 		break;
 	case INDESC_FILE:
-		f = fopen(indesc->name, "r");
-		if (!f)
-			break;
-
-		if (!fseek(f, loc->line_offset, SEEK_SET) &&
-		    fread(buf, 1, sizeof(buf) - 1, f) > 0) {
-			*strchrnul(buf, '\n') = '\0';
-			line = buf;
-		}
-		fclose(f);
+		line = line_location(indesc, loc, buf, sizeof(buf));
 		break;
 	case INDESC_INTERNAL:
 	case INDESC_NETLINK:
@@ -132,24 +169,8 @@ void erec_print(struct output_ctx *octx, const struct error_record *erec,
 		return;
 	}
 
-	if (indesc->location.indesc != NULL) {
-		const char *prefix = "In file included from";
-		iloc = &indesc->location;
-		for (tmp = iloc->indesc;
-		     tmp != NULL && tmp->type != INDESC_INTERNAL;
-		     tmp = iloc->indesc) {
-			fprintf(f, "%s %s:%u:%u-%u:\n", prefix,
-				tmp->name,
-				iloc->first_line, iloc->first_column,
-				iloc->last_column);
-			prefix = "                 from";
-			iloc = &tmp->location;
-		}
-	}
-	if (indesc->name != NULL)
-		fprintf(f, "%s:%u:%u-%u: ", indesc->name,
-			loc->first_line, loc->first_column,
-			loc->last_column);
+	print_location(f, indesc, loc);
+
 	if (error_record_names[erec->type])
 		fprintf(f, "%s: ", error_record_names[erec->type]);
 	fprintf(f, "%s\n", erec->msg);
-- 
2.30.2

