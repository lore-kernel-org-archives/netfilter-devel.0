Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FECE143870
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Jul 2024 21:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720128871; cv=none; b=lPp0nKNgPZW7lTDUzQcqmOQkrwow45yEr5CqPDoLEgjJH8QLx4ZQYFxOZuvYTXgPqbS2SMAokQf9chukVmcIhrkcZmOpjoFbmdvsmfwhwW+E+ixvZnbIB21Yz+i55lrzIjs+V+OiKSW9iG0C9Vv0xLw0ETGGW6JbRThKuLrDnzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720128871; c=relaxed/simple;
	bh=MChetaW6NfZVO2w7cmEppsmbaUfwODxahDl1Z/oS1rs=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=d2Jd3hqrN8BOHcO/9lNyNTDCLdTGycxG/KcH/Evhc7d1cdYJRYJEHvzl9EbIElNJ7E+umWLcRxLmUXNNKUIv69aO7pLjLlhfiXVjM9pN+jjVaeLfnJJm00L6Y/zbbIVAexGiaYFftik7u9xIu7aXiM35BaXD2atr2iP767+sYmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/4] segtree: set on EXPR_F_KERNEL flag for catchall elements in the cache
Date: Thu,  4 Jul 2024 23:34:21 +0200
Message-Id: <20240704213423.254356-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240704213423.254356-1-pablo@netfilter.org>
References: <20240704213423.254356-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Catchall set element deletion requires this flag to be set on,
otherwise it bogusly reports that such element does not exist
in the set.

Fixes: f1cc44edb218 ("src: add EXPR_F_KERNEL to identify expression in the kernel")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/segtree.c b/src/segtree.c
index 5e6f857f85b7..4df96467c3f5 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -629,8 +629,10 @@ void interval_map_decompose(struct expr *set)
 	expr_free(i);
 
 out:
-	if (catchall)
+	if (catchall) {
+		catchall->flags |= EXPR_F_KERNEL;
 		compound_expr_add(set, catchall);
+	}
 
 	free(ranges);
 	free(elements);
-- 
2.30.2

