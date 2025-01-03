Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D45911CA0
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Jan 2025 17:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735925739; cv=none; b=JULIMXPIOz89YLKJiJQtnWZfR1OPrr1gHbZ0WrPqSGWWfMj04WIOqyhTOomIDwRmBwdDTeFX7BxEq+P4TRhnfEQngd8YDTCJbK9uDE/CkQN9eeIzR9gf5HxQu9GciJHy4I98wwD41oshBG3hzoA53BFRo3NpEiGraJP9fLRi444=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735925739; c=relaxed/simple;
	bh=bSpIxQXIYnDFmGYZIJDut4or8DBwF6t+vkwIYkyuS58=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=XPHX5gNeM61CaN3fMV3sl2rcZMDir8vC9YRHaHDNsLsYX0F8XhRp/ngLD6yEtpWbEFn4UqGZu/j58wnfxN9O3Xc7ZVe19y8VChdvLTLJvUQclI+O247wTmpX9mdUvUH+ZSu4OhI6ZqseFI1Tkmr6E1Jw4KlWSYoGYnBt/f0A5TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
X-Spam-Level: 
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 1/7] intervals: add helper function to set previous element
Date: Fri,  3 Jan 2025 18:35:16 +0100
Message-Id: <20250103173522.773063-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add helper function to set previous element during the automerge
iteration. No functional changes are intended.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes

 src/intervals.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/src/intervals.c b/src/intervals.c
index 12cccbdab752..44fdda36e35f 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -148,6 +148,14 @@ static void set_sort_splice(struct expr *init, struct set *set)
 	}
 }
 
+static void set_prev_elem(struct expr **prev, struct expr *i,
+			  struct range *prev_range, struct range *range)
+{
+	*prev = i;
+	mpz_set(prev_range->low, range->low);
+	mpz_set(prev_range->high, range->high);
+}
+
 static void setelem_automerge(struct set_automerge_ctx *ctx)
 {
 	struct expr *i, *next, *prev = NULL;
@@ -168,9 +176,7 @@ static void setelem_automerge(struct set_automerge_ctx *ctx)
 		range_expr_value_high(range.high, i);
 
 		if (!prev) {
-			prev = i;
-			mpz_set(prev_range.low, range.low);
-			mpz_set(prev_range.high, range.high);
+			set_prev_elem(&prev, i, &prev_range, &range);
 			continue;
 		}
 
@@ -192,9 +198,7 @@ static void setelem_automerge(struct set_automerge_ctx *ctx)
 			}
 		}
 
-		prev = i;
-		mpz_set(prev_range.low, range.low);
-		mpz_set(prev_range.high, range.high);
+		set_prev_elem(&prev, i, &prev_range, &range);
 	}
 
 	mpz_clear(prev_range.low);
-- 
2.30.2

