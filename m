Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2712D768EF
	for <netfilter-devel@vger.kernel.org>; Sun, 22 Sep 2024 22:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727043383; cv=none; b=PO7PPrE9oWEwEa2EyniJRT2mIg77Ww5UCXIlNqfWuScQ+3oQt4w0QLZqf+290tDl4/wu6FVw2p8Mv5wzV1o9S442gMCwQnYxDIQWZEXPCH4nxX5+Rur7coz/32AryybOGIn3ddf8D32BasClFrPXd4kP9Kmtd9ceTGbthZ4KLN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727043383; c=relaxed/simple;
	bh=B46wpAZUsQKurH4iPpqCqnfkKOkWjIIRQpFqyN6INjY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cJYuA2W+4/VmfiSS/i51L0ZFmoCotp8UIRYnv7DVlKdeHJ7JjIxq/3t0B9kakDoLG8T7XC8tlETF//TR6TMT6gPPLWQPI1P0pGgE1YY3MKxP+rvvUvhWZ4eqB9VrjGC7NKh6L0XGR/dkNmuObzC72DOP/cHIbca6Xzy3Jil2hHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1ssUsF-0004Bu-QR; Mon, 23 Sep 2024 00:16:11 +0200
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnftnl] expr: dynset: validate expressions are of nested type
Date: Mon, 23 Sep 2024 00:16:02 +0200
Message-ID: <20240922221606.425225-1-fw@strlen.de>
X-Mailer: git-send-email 2.46.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This was not handled in the switch statement so far.
Also, use proper max value, SET_MAX is larger than whats is needed for
parsing.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/expr/dynset.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/expr/dynset.c b/src/expr/dynset.c
index 8a159f8ff520..9d2bfe5e206b 100644
--- a/src/expr/dynset.c
+++ b/src/expr/dynset.c
@@ -118,7 +118,7 @@ static int nftnl_expr_dynset_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_SET_MAX) < 0)
+	if (mnl_attr_type_valid(attr, NFTA_DYNSET_MAX) < 0)
 		return MNL_CB_OK;
 
 	switch (type) {
@@ -139,6 +139,7 @@ static int nftnl_expr_dynset_cb(const struct nlattr *attr, void *data)
 			abi_breakage();
 		break;
 	case NFTA_DYNSET_EXPR:
+	case NFTA_DYNSET_EXPRESSIONS:
 		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
 			abi_breakage();
 		break;
@@ -225,7 +226,7 @@ static int
 nftnl_expr_dynset_parse(struct nftnl_expr *e, struct nlattr *attr)
 {
 	struct nftnl_expr_dynset *dynset = nftnl_expr_data(e);
-	struct nlattr *tb[NFTA_SET_MAX+1] = {};
+	struct nlattr *tb[NFTA_DYNSET_MAX+1] = {};
 	struct nftnl_expr *expr, *next;
 	int ret = 0;
 
-- 
2.46.1

