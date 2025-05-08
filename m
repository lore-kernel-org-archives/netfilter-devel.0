Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5362279356
	for <netfilter-devel@vger.kernel.org>; Thu,  8 May 2025 14:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716022; cv=none; b=ASPHqFKT2QWOCQjB6RSCvSE9Hj6fHij1zKuTOMX76J3oQMpKkuif7Z8SZMts7yHasvx86M6MB2l+9/o+JPTYAS2NO1pG/968mTVH2KZykekwIiOTMYZOlVWpJ7qGY7ZR9CoXgX530BcDfOUniRHt1QWJobY1LRdk3HwH6nnPiVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716022; c=relaxed/simple;
	bh=jxIq0Fjx48g/pAQpg+AiY9lZiNvKUfeJU8I9DHkJxKI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fSzPPqGsRivUC4/32QglazgfnRQ17ZakZVHxsKMHNT5rN/Ddpj1+eziKDBo83GRPUF5d1l7g2pmW2GHgtxQSxkVGcFB//dFxLU9rV4kBjyhdDypvK5yOWVHWgZBw68rzxI+frypQW00SwT85pYsuo8OX1kLrvul3NQtQC/6KtPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1uD2Fv-0004X5-Ag; Thu, 08 May 2025 16:29:47 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] src: netlink: fix crash when ops doesn't support udata
Date: Thu,  8 May 2025 16:29:04 +0200
Message-ID: <20250508142907.4871-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Whenever a new version adds udata support to an expression, then old
versions of nft will crash when trying to list such a ruleset generated
by a more recent version of nftables.

Fix this by falling back to 'type' format.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/netlink.c b/src/netlink.c
index 25ee3419772b..5825a68d03bc 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -913,7 +913,7 @@ static struct expr *set_make_key(const struct nftnl_udata *attr)
 
 	etype = nftnl_udata_get_u32(ud[NFTNL_UDATA_SET_TYPEOF_EXPR]);
 	ops = expr_ops_by_type_u32(etype);
-	if (!ops)
+	if (!ops || !ops->parse_udata)
 		return NULL;
 
 	expr = ops->parse_udata(ud[NFTNL_UDATA_SET_TYPEOF_DATA]);
-- 
2.49.0

