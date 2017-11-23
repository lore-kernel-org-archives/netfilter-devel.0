From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] evaluate: print error for null string befort assert statement
Date: Fri, 24 Nov 2017 00:25:14 +0530
Message-ID: <20171123185514.16711-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pl0-f54.google.com ([209.85.160.54]:39147 "EHLO
        mail-pl0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753195AbdKWSzp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Nov 2017 13:55:45 -0500
Received: by mail-pl0-f54.google.com with SMTP id l16so3086568pli.6
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Nov 2017 10:55:45 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Print error "Null string is not allowed" before assert statement.
For e.g.
nft add rule filter input meta iifname '""'
Error: Null String is not allowed
add rule filter input meta iifname ""

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 src/evaluate.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index fd61e75..ad044a4 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -235,6 +235,10 @@ static int expr_evaluate_string(struct eval_ctx *ctx, struct expr **exprp)
 	memset(data + len, 0, data_len - len);
 	mpz_export_data(data, expr->value, BYTEORDER_HOST_ENDIAN, len);
 
+	if (strlen(data) == 0) {
+		return expr_error(ctx->msgs, expr,
+				  "Null String is not allowed");
+	}
 	assert(strlen(data) > 0);
 	datalen = strlen(data) - 1;
 	if (data[datalen] != '*') {
-- 
2.11.0

