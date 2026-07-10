Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F89413D9C
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jul 2026 10:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783680459; cv=none; b=enELWgtnZpXYKC23lIKpqarqeE957iFZqDtK55wFGGgbg9BjRrJq+bih3qCoydmleYMQZs4N+9JmeEAzHbOGh+6DwGpukO/cE97yAiECgX7d6219UTzoUv5SMBAUxtXdTqPvXWu6k5Hcl6vFo1pO5FU24KSEA08uBnQ7RyRQBC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783680459; c=relaxed/simple;
	bh=v+MyMtFMwnZ5HOv09A0sC5zX3IS4ojfSfloxazMnuJY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=aMfWgGltXXBxpa3s6sPrpJRKTdWRraeaLjdUBMH+5y0ULD6ewXUsy2dutoAIJkDnA900tbGhovCT26SZWfNcvJkW1iAPX2cciJ3Ho1Aln2l9JJ6KHdO1l6orjjv0AtAc/5RkfuHCQDE03msKpULk5vqWJyq1qOdZ5SEceTPLQKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A9CDB60491; Fri, 10 Jul 2026 12:47:31 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf] netfilter: x_physdev: masks are not c-strings
Date: Fri, 10 Jul 2026 12:47:23 +0200
Message-ID: <20260710104727.23363-1-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

... and must not be subjected to the 'nul terminated' constraint.
If the interface name is 15 characters long, the mask is 16-bytes
'0xff' (to cover for \0) and the valid device name is rejected.

Fixes: 8df772afc9d0 ("netfilter: x_physdev: reject empty or not-nul terminated device names")
Cc: stable@vger.kernel.org
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 I'm dumb.  I pushed a test case to iptables.git and will include
 this in todays nf -> net batch.

 net/netfilter/xt_physdev.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index dd98f758176c..a388881c68d4 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -130,11 +130,6 @@ static int physdev_mt_check(const struct xt_mtchk_param *par)
 		if (X(physoutdev))
 			return -ENAMETOOLONG;
 	}
-
-	if (X(in_mask))
-		return -ENAMETOOLONG;
-	if (X(out_mask))
-		return -ENAMETOOLONG;
 #undef X
 
 	if (!brnf_probed) {
-- 
2.54.0

