Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 681D61F9ED9
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2024 21:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734470465; cv=none; b=ufjn+yYpR/AUGGmFGvo+KUnDqk62W5r92rMYBFLuGgWih1tH7iZc+GiUZf+lX+3g8/GSdzVbzLj/mxodHHqm9Phww7pSupGJET7B69WS8/pUDGXfeeVjAN5IMt8ysKSHjQV1znlJDz4+p/8NQLDSUWr/5MVHjFgkoO1hBtp6pwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734470465; c=relaxed/simple;
	bh=d02c55NVLg2HMxT9G+ayDuX+r86KvZwmIhzrx5+rfzk=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P59sFnBUkmaDT9pH/ryQEPyXJJq7ilJme16GncgH2HTa7gyZ886T4m89Yvq+/6Kx6FWOdPn8vKEYoRnBTCAXnoNOmcfyD+r8HaMP+0Zevrsxo/xo0fT6ASPyDsWNsdySByd3MvjePqgQwjhHgl4H4kT5YZ88dpcrHjLQKaP0Vlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/6] intervals: do not merge intervals with different timeout
Date: Tue, 17 Dec 2024 22:15:12 +0100
Message-Id: <20241217211516.1644623-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241217211516.1644623-1-pablo@netfilter.org>
References: <20241217211516.1644623-1-pablo@netfilter.org>
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
 src/intervals.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/intervals.c b/src/intervals.c
index 44fdda36e35f..6308cc8e2c08 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -175,7 +175,9 @@ static void setelem_automerge(struct set_automerge_ctx *ctx)
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

