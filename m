Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3142236F0
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Jun 2025 21:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750111058; cv=none; b=c2bdpOiIjSMi2Mziywb7YHzVaT0DiZ/alzZlVFrs4nYZp/qcGHnMxkgg5MTrfKmk6y7w1ozFGMMuUdwG/AxDT7oQbNiyx6PkxxUobepnzdLRCQTuK2gZfGonRCkpwNZ9o2NjA78ovaTSchqGdB43mAWPgWbPbsildhsM65QhjvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750111058; c=relaxed/simple;
	bh=ZaFbk1JcpCvgoU1LPrhxzYOQ+hHylYW2lKahWsymdnw=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gvR1l8yLh99OfivXNPN3DHSGVWIksO65+hhS+aNkDPNNKwreNuA7/67+2KquMwxejOzBzpFyQJonK1i8LVtaLyTp+tr3s//5wqt6/k19TH8lsbNST8ohY1t6mQN4TDuOgdoWs+BdAGJzqFY79FvMthNXvljmduhlqDVDQIeLnFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lj0cZMWj; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lj0cZMWj; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lj0cZMWj";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lj0cZMWj"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id EE89A603B6; Mon, 16 Jun 2025 23:57:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750111048;
	bh=sb9jMxqjnVZGfln5Uvgf1xYM3KAu4wVO9cBqEZp1HyM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=lj0cZMWjIDu8HHZK+XpGgHFTUyg8ga7pUJFbi4ZK6dkBQ4pMdFs7ANRHYx6ghdzhp
	 JcxbsXekuAMc5Zfv3fztPegmnmxvwpyD8LE4KINFJbZ8OPUVTM9a2EARmg4+cfdFOk
	 NYRIq0QPS/aBQrkpDbjNAvvYPYB5UygooxFhBZYovwvEHaBHPigXYGZso3pgd5msGZ
	 tb4hQE4oUD/nxG26WMXyjvhBRyxYQ8WIkUYm33L/3U7zM0f28ULRnHjd7Ytly58XRU
	 KGETdrzkxOzFfy5P3WtHKw7BIWbLYsWOMA/NMMEI4hwDJGalORJE7CWmk4zmwtOEqW
	 TbMAHVo0ZlEtg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 979A9603B6
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Jun 2025 23:57:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750111048;
	bh=sb9jMxqjnVZGfln5Uvgf1xYM3KAu4wVO9cBqEZp1HyM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=lj0cZMWjIDu8HHZK+XpGgHFTUyg8ga7pUJFbi4ZK6dkBQ4pMdFs7ANRHYx6ghdzhp
	 JcxbsXekuAMc5Zfv3fztPegmnmxvwpyD8LE4KINFJbZ8OPUVTM9a2EARmg4+cfdFOk
	 NYRIq0QPS/aBQrkpDbjNAvvYPYB5UygooxFhBZYovwvEHaBHPigXYGZso3pgd5msGZ
	 tb4hQE4oUD/nxG26WMXyjvhBRyxYQ8WIkUYm33L/3U7zM0f28ULRnHjd7Ytly58XRU
	 KGETdrzkxOzFfy5P3WtHKw7BIWbLYsWOMA/NMMEI4hwDJGalORJE7CWmk4zmwtOEqW
	 TbMAHVo0ZlEtg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/3] expression: constant range is not a singleton
Date: Mon, 16 Jun 2025 23:57:22 +0200
Message-Id: <20250616215723.608990-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250616215723.608990-1-pablo@netfilter.org>
References: <20250616215723.608990-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the EXPR_F_SINGLETON flag in EXPR_RANGE_VALUE so it can be used
in maps.

expr_evaluate_set() does not toggle NFT_SET_INTERVAL for anonymous sets
because a singleton is assumed to be place, leading to this BUG:

 BUG: invalid data expression type range_value
 nft: src/netlink.c:577: netlink_gen_key: Assertion `0' failed.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expression.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/expression.c b/src/expression.c
index dc9a44677b28..aa97413d0794 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -612,7 +612,7 @@ struct expr *constant_range_expr_alloc(const struct location *loc,
 	struct expr *expr;
 
 	expr = expr_alloc(loc, EXPR_RANGE_VALUE, dtype, byteorder, len);
-	expr->flags = EXPR_F_CONSTANT | EXPR_F_SINGLETON;
+	expr->flags = EXPR_F_CONSTANT;
 
 	mpz_init_set(expr->range.low, low);
 	mpz_init_set(expr->range.high, high);
-- 
2.30.2

