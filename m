Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E007047F78
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Dec 2023 21:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Kw7Y+KOE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=EOHBy1rdtUQyl33OuDIpqIOe7VlCBppn/WFK54Zl+xc=; b=Kw7Y+KOElAF0PQ7CNSu/PCY5cy
	+ztlTf1lilEuF9M3h68WnKWyNja/ojGd5/tQs0sE+YNDhuujYpEDFgdrJZxygM0bJBUoVviUaIQPC
	/DIWQIJ1h4pWPYCgBvAsIpXvb0PGMLLBewfL9fH27VuLcXPc2vNJmlcF/9wnye19qucWhZFHIPmaZ
	d5nbA1iL2B9Vgny6WBA88G7Uei38FH5kElqBcJ8O7nsU8pqGJzT5Qnfv+woK7mPuh2nYGK0G/rGcC
	ekjG3Z6KSm4FUzkdUIYh+VekwuG+Gb4IxfdI1fFKUJTe616yfVACRFAfwyZ1uOKgOwP4/OoDAQrvP
	hHATpXHw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rEG82-0001ZO-4z; Fri, 15 Dec 2023 22:53:54 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [libnftnl PATCH 6/6] expr: Enforce attr_policy compliance in nftnl_expr_set()
Date: Fri, 15 Dec 2023 22:53:50 +0100
Message-ID: <20231215215350.17691-7-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231215215350.17691-1-phil@nwl.cc>
References: <20231215215350.17691-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Every expression type defines an attr_policy array, so deny setting
attributes if not present. Also deny if maxlen field is non-zero and
lower than the given data_len.

Some attributes' max length is not fixed (e.g. NFTNL_EXPR_{TG,MT}_INFO )
or is not sensible to check (e.g.  NFTNL_EXPR_DYNSET_EXPR). The zero
maxlen "nop" is also used for deprecated attributes, just to not
silently ignore them.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/expr.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/src/expr.c b/src/expr.c
index 74d211bcaa123..4e32189c6e8d0 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -74,6 +74,13 @@ int nftnl_expr_set(struct nftnl_expr *expr, uint16_t type,
 		if (type < NFTNL_EXPR_BASE || type > expr->ops->nftnl_max_attr)
 			return -1;
 
+		if (!expr->ops->attr_policy)
+			return -1;
+
+		if (expr->ops->attr_policy[type].maxlen &&
+		    expr->ops->attr_policy[type].maxlen < data_len)
+			return -1;
+
 		if (expr->ops->set(expr, type, data, data_len) < 0)
 			return -1;
 	}
-- 
2.43.0

