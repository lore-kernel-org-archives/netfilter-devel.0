Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5011B1684AC
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Jan 2025 17:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735925739; cv=none; b=LgJmqQxXnhH24xRb+9zFaxiaLvk5ZZ7KFhvIeNaoE596v6RsUFpE2SrUS2xSGTW4LkvdLqHKoi9h1/bX8yYD9zKumP0p84htyBqo6rrkklp1qoC3n7WFeJurxxhEHAVnOKchi4nsqGItiMZhVoa3BYw44ZznnB71CHxvJc+xOxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735925739; c=relaxed/simple;
	bh=tkiIfALGT8REp9hTKe6BC+/ywa1LHmnCbTxVON2EwIA=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=a2lGSWMh7bSRxMraFLMejAPVCAzNczGq2vgsKXsSU87hUfl9I2rmqYs1BsMdltAvU9jacq9q8VhurL5sFNRYfD9atZudpP4wKNrm1xTHp8WEnBhkGFtcZnV5pvVDqEWGPLqCQw5S+yqzZYFywuSeG6NP+oJtx4+MkVSDwb8oUX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
X-Spam-Level: 
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 2/7] intervals: do not merge intervals with different timeout
Date: Fri,  3 Jan 2025 18:35:17 +0100
Message-Id: <20250103173522.773063-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250103173522.773063-1-pablo@netfilter.org>
References: <20250103173522.773063-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If timeout/expiration of contiguous intervals is different, then do not
merge them.

Fixes: 81e36530fcac ("src: replace interval segment tree overlap and automerge")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: missing forward declaration, otherwise patch breaks bisection.

 src/intervals.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/src/intervals.c b/src/intervals.c
index 44fdda36e35f..ffd474fd595e 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -156,6 +156,8 @@ static void set_prev_elem(struct expr **prev, struct expr *i,
 	mpz_set(prev_range->high, range->high);
 }
 
+static struct expr *interval_expr_key(struct expr *i);
+
 static void setelem_automerge(struct set_automerge_ctx *ctx)
 {
 	struct expr *i, *next, *prev = NULL;
@@ -175,7 +177,9 @@ static void setelem_automerge(struct set_automerge_ctx *ctx)
 		range_expr_value_low(range.low, i);
 		range_expr_value_high(range.high, i);
 
-		if (!prev) {
+		if (!prev ||
+		    interval_expr_key(prev)->timeout != interval_expr_key(i)->timeout ||
+		    interval_expr_key(prev)->expiration != interval_expr_key(i)->expiration) {
 			set_prev_elem(&prev, i, &prev_range, &range);
 			continue;
 		}
-- 
2.30.2

