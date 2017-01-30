From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft] src: Always print range expressions numerically
Date: Mon, 30 Jan 2017 12:05:20 -0200
Message-ID: <20170130140520.GA5818@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:35209 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753557AbdA3OMj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Jan 2017 09:12:39 -0500
Received: by mail-qt0-f193.google.com with SMTP id s58so14904653qtc.2
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Jan 2017 06:12:39 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Because the rules are more legible this way. Also, the parser doesn't
accept strings on ranges, so, printing ranges numerically better match
the rules definition.

Fixes(Bug 1046 - mobility header with range gives illegible rule).

A new NUMERIC constant was defined to fill the previous role of
NUMERIC_ALL, so the option -nnn doesn't affect symbolic constants.

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---
 include/nftables.h |  1 +
 src/datatype.c     | 11 +++++++----
 src/expression.c   |  2 ++
 src/main.c         |  3 ++-
 src/meta.c         |  4 ++--
 5 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index 6f54155..2730f65 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -9,6 +9,7 @@ enum numeric_level {
 	NUMERIC_NONE,
 	NUMERIC_ADDR,
 	NUMERIC_PORT,
+	NUMERIC_PROTO_UGID,
 	NUMERIC_ALL,
 };
 
diff --git a/src/datatype.c b/src/datatype.c
index 1518606..f9981a6 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -175,9 +175,12 @@ void symbolic_constant_print(const struct symbol_table *tbl,
 		return expr_basetype(expr)->print(expr);
 
 	if (quotes)
-		printf("\"%s\"", s->identifier);
-	else
-		printf("%s", s->identifier);
+		printf("\"");
+
+	numeric_output >= NUMERIC_ALL ? printf("%lu", val) : printf("%s", s->identifier);
+
+	if (quotes)
+		printf("\"");
 }
 
 static void switch_byteorder(void *data, unsigned int len)
@@ -530,7 +533,7 @@ static void inet_protocol_type_print(const struct expr *expr)
 {
 	struct protoent *p;
 
-	if (numeric_output < NUMERIC_ALL) {
+	if (numeric_output < NUMERIC_PROTO_UGID) {
 		p = getprotobynumber(mpz_get_uint8(expr->value));
 		if (p != NULL) {
 			printf("%s", p->p_name);
diff --git a/src/expression.c b/src/expression.c
index 1567870..bdbbd45 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -597,9 +597,11 @@ struct expr *relational_expr_alloc(const struct location *loc, enum ops op,
 
 static void range_expr_print(const struct expr *expr)
 {
+	numeric_output += NUMERIC_ALL;
 	expr_print(expr->left);
 	printf("-");
 	expr_print(expr->right);
+	numeric_output -= NUMERIC_ALL;
 }
 
 static void range_expr_clone(struct expr *new, const struct expr *expr)
diff --git a/src/main.c b/src/main.c
index 6ba752b..1b28836 100644
--- a/src/main.c
+++ b/src/main.c
@@ -288,7 +288,8 @@ int main(int argc, char * const *argv)
 			include_paths[num_include_paths++] = optarg;
 			break;
 		case OPT_NUMERIC:
-			numeric_output++;
+			if (numeric_output + 1 < NUMERIC_ALL)
+				numeric_output++;
 			break;
 		case OPT_STATELESS:
 			stateless_output++;
diff --git a/src/meta.c b/src/meta.c
index cb7c136..9e8a987 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -226,7 +226,7 @@ static void uid_type_print(const struct expr *expr)
 {
 	struct passwd *pw;
 
-	if (numeric_output < NUMERIC_ALL) {
+	if (numeric_output < NUMERIC_PROTO_UGID) {
 		uint32_t uid = mpz_get_uint32(expr->value);
 
 		pw = getpwuid(uid);
@@ -278,7 +278,7 @@ static void gid_type_print(const struct expr *expr)
 {
 	struct group *gr;
 
-	if (numeric_output < NUMERIC_ALL) {
+	if (numeric_output < NUMERIC_PROTO_UGID) {
 		uint32_t gid = mpz_get_uint32(expr->value);
 
 		gr = getgrgid(gid);
-- 
2.7.4

