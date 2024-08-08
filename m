Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AA655769
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Aug 2024 23:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723160231; cv=none; b=gAqP1P56E2bSu/Sz+JRpaSojIoAiKPf4QLcJV0Sui5SaZ/UBATHLpXMnLlXP++GMj8d6vCnLqIS7VT4rvVwcxBf07nsvqyDNgF73zPV2ZoVh2DaDVk+zG0iE7VfWeFysflvgyGqpzTUJPXnN8RTW/o3iPAcCCtN+WVlUuuDnxDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723160231; c=relaxed/simple;
	bh=v5pk5trzYMmgU1A4kn6mnrMgwEbZhtAyIUMJYMiP9g0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iPYKjCeN6GUAuaLybwYEKz2jRh5h+ZfHwlll605BUpYfEehazyFZ3gNKRphTszhheUAOmyutXmpzxRPB2TEWhoe4ypMcjxCO9t1BOorP0FueVKoWno5LddPdVm8UdbmOOTkl0FSLpAiVu210lrUTIvGFSCexiL92Tl/ZSfrDC9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1scCgt-0003s8-G5; Fri, 09 Aug 2024 01:37:07 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] optimize: compare meta inner_desc pointers too
Date: Fri,  9 Aug 2024 01:31:17 +0200
Message-ID: <20240808233121.19725-1-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We can't merge if one referes inner and other outer header.
Payload checks this but meta did not.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/optimize.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/optimize.c b/src/optimize.c
index 62dd9082a587..5903694de5de 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -63,6 +63,8 @@ static bool __expr_cmp(const struct expr *expr_a, const struct expr *expr_b)
 			return false;
 		if (expr_a->meta.base != expr_b->meta.base)
 			return false;
+		if (expr_a->meta.inner_desc != expr_b->meta.inner_desc)
+			return false;
 		break;
 	case EXPR_CT:
 		if (expr_a->ct.key != expr_b->ct.key)
-- 
2.44.2

