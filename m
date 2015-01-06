From: Steven Barth <cyrus@openwrt.org>
Subject: [PATCH 3/4] erec: use stdio vasprintf instead of gmp_vasprintf
Date: Tue,  6 Jan 2015 23:40:24 +0100
Message-ID: <1420584025-7817-4-git-send-email-cyrus@openwrt.org>
References: <1420584025-7817-1-git-send-email-cyrus@openwrt.org>
Cc: Steven Barth <cyrus@openwrt.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.core-networks.de ([82.96.72.7]:52736 "EHLO
	mail.core-networks.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbbAFWlD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Jan 2015 17:41:03 -0500
In-Reply-To: <1420584025-7817-1-git-send-email-cyrus@openwrt.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use stdio's vasprintf instead of gmp_vasprintf which is not part
of the mini-gmp function subset. Furthermore convert the only
gmp-specific user and allow the compiler to verify format-strings.

Signed-off-by: Steven Barth <cyrus@openwrt.org>
---
 src/erec.c     | 6 +++++-
 src/evaluate.c | 8 ++++++--
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/src/erec.c b/src/erec.c
index 82543e6..810e9bf 100644
--- a/src/erec.c
+++ b/src/erec.c
@@ -44,6 +44,7 @@ static void erec_destroy(struct error_record *erec)
 	xfree(erec);
 }
 
+__attribute__((format(printf, 3, 0)))
 struct error_record *erec_vcreate(enum error_record_types type,
 				  const struct location *loc,
 				  const char *fmt, va_list ap)
@@ -55,10 +56,13 @@ struct error_record *erec_vcreate(enum error_record_types type,
 	erec->num_locations	= 0;
 	erec_add_location(erec, loc);
 
-	gmp_vasprintf(&erec->msg, fmt, ap);
+	if (vasprintf(&erec->msg, fmt, ap) < 0)
+		erec->msg = NULL;
+
 	return erec;
 }
 
+__attribute__((format(printf, 3, 4)))
 struct error_record *erec_create(enum error_record_types type,
 				 const struct location *loc,
 				 const char *fmt, ...)
diff --git a/src/evaluate.c b/src/evaluate.c
index 8f0acf7..593cc33 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -232,9 +232,13 @@ static int expr_evaluate_value(struct eval_ctx *ctx, struct expr **expr)
 	case TYPE_INTEGER:
 		mpz_init_bitmask(mask, ctx->ectx.len);
 		if (mpz_cmp((*expr)->value, mask) > 0) {
+			char *valstr = mpz_get_str(NULL, 10, (*expr)->value);
+			char *rangestr = mpz_get_str(NULL, 10, mask);
 			expr_error(ctx->msgs, *expr,
-				   "Value %Zu exceeds valid range 0-%Zu",
-				   (*expr)->value, mask);
+				   "Value %s exceeds valid range 0-%s",
+				   valstr, rangestr);
+			free(valstr);
+			free(rangestr);
 			mpz_clear(mask);
 			return -1;
 		}
-- 
2.1.4

