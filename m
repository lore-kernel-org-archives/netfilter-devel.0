Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65A5C1F9AAE
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2024 21:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734470465; cv=none; b=Tu07WvQc5zcJSZ6XNi32UbCz9gANMP70XqIw0ZRlLIBKS2X6l2J7YYiclVlHBTLPYZX3/tecAaBxtO20BbPpEi+hYTMnOw0++1CUrLTRUtEqEg1RmmVdghNJgLKLYAe8gFBCM+lS9kqvPxFFJROio+Tr0El0DHDyVHMd6km4VDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734470465; c=relaxed/simple;
	bh=5C8f1Ylnt6oYSWm3Vlrm+f4GaIKc23KKuBSQ0+FyNG8=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FogTDMe3508WtNsC1KPLkQjUw66dhlqowdWJO0aka3sHNV4JZs2kWLEooiK03eVAfASSyxdX8dpVHgKaeqcA/15pcTJHQopp4cv1B/8d4APiMjpQA6BApGP22T0JiH1OrmXA2cT+yYoanM2Q4pLQ37iFpsElLNME1+2kyWz3QKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/6] intervals: add helper function to set previous element
Date: Tue, 17 Dec 2024 22:15:11 +0100
Message-Id: <20241217211516.1644623-2-pablo@netfilter.org>
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

Add helper function to set previous element during the automerge
iteration. No functional changes are intended.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
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

