Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D33E154B2
	for <netfilter-devel@vger.kernel.org>; Sat, 20 Jan 2024 21:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705787426; cv=none; b=ioIgbrhSsLhZAGiHYBlBZhZXnV1ospuTYb+8WyjM0tdsK2gFD8Ee9GwH74tURPCG/yBNKUqi/NdJY1EK/EfQrtgNDODsX2duxsOvy4DKRCAlrRyoVjMGbSZ3A+AqvcCIv2OYLnZaRQgK9FcFKLUyYlyPQ4hPEd8hh5KCNfFb4us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705787426; c=relaxed/simple;
	bh=BokEfaINx/skbDoK//QHT25W9uhzo91/vn1kdwCt684=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BsTpEziB2oxAnPkMJno+S2bmxIYSpk2YfSTpLO/Ho9Fi6uDnjdvca2gn32awlw9fG0JwYy/EhtnJwDknKCFWpu6x487EfGsQSO/z+9odaqgIYYWvxX9MBCCRgFxnRI84e/za2/hn1+hszG5tB/9XsOHd1j1D9qo5l2aBJWQXsX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rRJEH-0006oH-9v; Sat, 20 Jan 2024 22:50:17 +0100
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Notselwyn <notselwyn@pwning.tech>
Subject: [PATCH nf] netfilter: nf_tables: reject QUEUE/DROP verdict parameters
Date: Sat, 20 Jan 2024 22:50:04 +0100
Message-ID: <20240120215012.129529-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit e0abdadcc6e1.

core.c:nf_hook_slow assumes that the upper 16 bits of NF_DROP
verdicts contain a valid errno, i.e. -EPERM, -EHOSTUNREACH or similar,
or 0.

Due to the reverted commit, its possible to provide a positive
value, e.g. NF_ACCEPT (1), which results in use-after-free.

Its not clear to me why this commit was made.

NF_QUEUE is not used by nftables; "queue" rules in nftables
will result in use of "nft_queue" expression.

If we later need to allow specifiying errno values from userspace
(do not know why), this has to call NF_DROP_GETERR and check that
"err <= 0" holds true.

Reported-by: Notselwyn <notselwyn@pwning.tech>
Fixes: e0abdadcc6e1 ("netfilter: nf_tables: accept QUEUE/DROP verdict parameters")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4b55533ce5ca..868c82b7febf 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10988,16 +10988,10 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
 	data->verdict.code = ntohl(nla_get_be32(tb[NFTA_VERDICT_CODE]));
 
 	switch (data->verdict.code) {
-	default:
-		switch (data->verdict.code & NF_VERDICT_MASK) {
-		case NF_ACCEPT:
-		case NF_DROP:
-		case NF_QUEUE:
-			break;
-		default:
-			return -EINVAL;
-		}
-		fallthrough;
+	case NF_ACCEPT:
+	case NF_DROP:
+	case NF_QUEUE:
+		break;
 	case NFT_CONTINUE:
 	case NFT_BREAK:
 	case NFT_RETURN:
@@ -11032,6 +11026,8 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
 
 		data->verdict.chain = chain;
 		break;
+	default:
+		return -EINVAL;
 	}
 
 	desc->len = sizeof(data->verdict);
-- 
2.43.0

