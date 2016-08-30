From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v2 1/4] evaluate: Fix datalen checks in expr_evaluate_string()
Date: Tue, 30 Aug 2016 19:39:49 +0200
Message-ID: <1472578792-2991-2-git-send-email-phil@nwl.cc>
References: <1472578792-2991-1-git-send-email-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:35277 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932516AbcH3RkF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Aug 2016 13:40:05 -0400
In-Reply-To: <1472578792-2991-1-git-send-email-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I have been told that the flex scanner won't return empty strings, so
strlen(data) should always be greater 0. To avoid a hard to debug issue
though, add an assert() to make sure this is always the case before
risking an unsigned variable underrun.

A real issue though is the check for 'datalen - 1 >= 0', which will
never fail due to datalen being unsigned. Fix this by incrementing both
sides by one, hence checking 'datalen >= 1'.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Based on the assumption that strlen(data) should never be less than 1,
  just add an assert() to be on the safe side.
- By modifying the '>= 0' check a bit, we can get by without making
  datalen a signed variable.
---
 src/evaluate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 7eb28f2c4b72d..fb9b82534d520 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -221,6 +221,7 @@ static int expr_evaluate_string(struct eval_ctx *ctx, struct expr **exprp)
 	memset(data + len, 0, data_len - len);
 	mpz_export_data(data, expr->value, BYTEORDER_HOST_ENDIAN, len);
 
+	assert(strlen(data) > 0);
 	datalen = strlen(data) - 1;
 	if (data[datalen] != '*') {
 		/* We need to reallocate the constant expression with the right
@@ -234,7 +235,7 @@ static int expr_evaluate_string(struct eval_ctx *ctx, struct expr **exprp)
 		return 0;
 	}
 
-	if (datalen - 1 >= 0 &&
+	if (datalen >= 1 &&
 	    data[datalen - 1] == '\\') {
 		char unescaped_str[data_len];
 
-- 
2.8.2

