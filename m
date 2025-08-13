Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745CC2E92BE
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 14:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755094316; cv=none; b=R3Z4sccr+M0Tj4aFFkZHfvrAq2Yg0CV53v6fBA782C+xC5M3wuSmSAvH9bvpdLdulTegeK3RTM/EfFxHynAUNVTPs43Br+dV7QuythJDJ5GwPb7e/CfP7JKWxjIf/8X6wmlhrkqOPoM2SYqTndlQ2Ba9oDxuX6fCHUbEyF+ZdwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755094316; c=relaxed/simple;
	bh=1+c5cgYbNJim5mIWrX7gbLpN4tyciPRrVU4fDmglA5s=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=p6MuAYpoeb5N1C/RNBR+RhLU42UyR9L4KTqfQz3WESMy4yelO65Zr5x9M7menKbyfQ2/lJawxyIj+v2JziIE2hcTHz2kPtS+u6rAsd0eBrBd1Es0e2dqdiP/wIZ3hId8RZOCqjIJGEu0smjGfnaXBWW1zwFH3woX3QuZa8exPro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=C9ZRY1Nl; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=C9ZRY1Nl; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="C9ZRY1Nl";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="C9ZRY1Nl"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 97AAC606FE; Wed, 13 Aug 2025 16:11:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755094311;
	bh=BPk/1oe06W/cshUXhmPe/lJQeSWjDD34polYxOkgz/o=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=C9ZRY1NlX3Ws+fDoe8z24/zdG67qzNPR5aJH3ktHSla7aaLamKyA0OFd8I6xx1TJW
	 V16F9m/L7WNX7n1/Xitiw+MmA84JfrF59tXfB+R8JdJjVgjWkZK8kmA4ZbqwRTuO51
	 HyPszblERuUOiowUP0l39pA6S6D+rYjiNFGpnCkmAoFConYGVld+kyYBmwq+uVz8ch
	 tS6/W4FgbLCy8H1COhU0vOMkkXdqq2x+0+AFcJc0IfHOPU40Yr21LAHivc9d3oefiI
	 gveyXqoLiwwDKskXe/butJud+UyV+rD+x0CQHyk9dXK5Si0ZgSS/G4BprotPjrxZlC
	 LdzaW2c11Kfrg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4123C606F1
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 16:11:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755094311;
	bh=BPk/1oe06W/cshUXhmPe/lJQeSWjDD34polYxOkgz/o=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=C9ZRY1NlX3Ws+fDoe8z24/zdG67qzNPR5aJH3ktHSla7aaLamKyA0OFd8I6xx1TJW
	 V16F9m/L7WNX7n1/Xitiw+MmA84JfrF59tXfB+R8JdJjVgjWkZK8kmA4ZbqwRTuO51
	 HyPszblERuUOiowUP0l39pA6S6D+rYjiNFGpnCkmAoFConYGVld+kyYBmwq+uVz8ch
	 tS6/W4FgbLCy8H1COhU0vOMkkXdqq2x+0+AFcJc0IfHOPU40Yr21LAHivc9d3oefiI
	 gveyXqoLiwwDKskXe/butJud+UyV+rD+x0CQHyk9dXK5Si0ZgSS/G4BprotPjrxZlC
	 LdzaW2c11Kfrg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 01/12] segtree: incorrect type when aggregating concatenated set ranges
Date: Wed, 13 Aug 2025 16:11:33 +0200
Message-Id: <20250813141144.333784-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250813141144.333784-1-pablo@netfilter.org>
References: <20250813141144.333784-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Uncovered by the compound_expr_remove() replacement by type safe function
coming after this patch.

Add expression to the concatenation which is reachable via expr_value().

This bug is subtle, I could not spot any reproducible buggy behaviour
when using the wrong type when running the existing tests.

Fixes: 8ac2f3b2fca3 ("src: Add support for concatenated set ranges")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/segtree.c b/src/segtree.c
index 70b4416cf39b..fd77e03fbff5 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -448,7 +448,7 @@ next:
 			mpz_clear(range);
 
 			r2 = list_entry(r2_next, typeof(*r2), list);
-			compound_expr_remove(start, r1);
+			compound_expr_remove(expr_value(start), r1);
 
 			if (free_r1)
 				expr_free(r1);
-- 
2.30.2

