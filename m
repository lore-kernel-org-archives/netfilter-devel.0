Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3ADD39AF3
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2024 19:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710876330; cv=none; b=cIMtL3RanYQg5B+B9VXYwV2Zi0OfGnnxWwPA9DTcksb984kueQcQGuXZsMS33hMep0Ru4R/klyWI2lzG2hDciF+Sb0RMJ/beiFLEF8cdaKCbg0CJB7Fg6KfRsXHByj3xKk5cXgoGqoJyQEQu0LZJTkJG2bdsOXkxJe72rHREhCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710876330; c=relaxed/simple;
	bh=FFRC53Lk3WL/vprWgK9STiAycEhh+apNgFDjjNRN4JQ=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=KPRDSRT52RcVG4+AMhQjCE6+fXd7T2k+q/rhp64KgOncYILw7LEL0BT/jcNl0fBQ4goP6DP30P6yit559cwcdrbTCuGF3/JKp4W08vsGiYU0APTmEgJxfQrdxj7+9V0W7IOWxGdXOue1QooZ4q29smmirQtRZ9TASymVBBldy0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] evaluate: display "Range negative size" error
Date: Tue, 19 Mar 2024 20:25:19 +0100
Message-Id: <20240319192519.206632-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

zero length ranges now allowed, therefore, update error message to refer
to negative ranges which are not possible.

Fixes: 7a6e16040d65 ("evaluate: allow for zero length ranges")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index e3ead3329636..1682ba58989e 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1275,8 +1275,8 @@ static int expr_evaluate_range(struct eval_ctx *ctx, struct expr **expr)
 	right = range->right;
 
 	if (mpz_cmp(left->value, right->value) > 0)
-		return expr_error(ctx->msgs, range,
-				  "Range has zero or negative size");
+		return expr_error(ctx->msgs, range, "Range negative size");
+
 	datatype_set(range, left->dtype);
 	range->flags |= EXPR_F_CONSTANT;
 	return 0;
-- 
2.30.2

