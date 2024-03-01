Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBA74F1E5
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Mar 2024 12:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709295572; cv=none; b=Gw9UAMQ2kBpo42dgIz+a/oOM1fcmYrxwHbw4y2rNnEJ52wSUF+f31h1/hR/y3jMm6BTlayFOpwvXn71Sq+xsqCot7DdvlP9TZIEyOCiUXs+YwL8WvoMniKBbAiz3iMPEjmx8xPFu7Hd4PFONL0joLTyw15SkjzuxNM10ZVfUT24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709295572; c=relaxed/simple;
	bh=GYlShT9C5rsWXiGtB/VEcFNta55t5sexGelXXx8mOLo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=og3W/NnPiLFsYQ3t46lKUPN6RFCxTUEPFuHnW4P8J174AEZLXulw6tP4QJkAJB8cdNbt6cNDp1Yo6rvZTZgaNktjCZXguDbcRplZrtggIiH+wVvVOmsUWNhIAx5rE/vtQffGBoySekxFvdnwDROd8ahtanmMjm2MeBFsEWO7Yt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rg1rH-00026M-5j; Fri, 01 Mar 2024 13:19:23 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nft_ct: fix l3num expectations with inet pseudo family
Date: Fri,  1 Mar 2024 13:14:28 +0100
Message-ID: <20240301121431.14076-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Following is rejected but should be allowed:

table inet t {
        ct expectation exp1 {
                [..]
                l3proto ip

Valid combos are:
table ip t, l3proto ip
table ip6 t, l3proto ip6
table inet t, l3proto ip OR l3proto ip6

Disallow inet pseudeo family, the l3num must be a on-wire protocol known
to conntrack.

Fixes: 8059918a1377 ("netfilter: nft_ct: sanitize layer 3 and 4 protocol number in custom expectations")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 I'll submit a test case for nftables/shell soon.

 net/netfilter/nft_ct.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index bfd3e5a14dab..13b74fe9b0f0 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1256,12 +1256,12 @@ static int nft_ct_expect_obj_init(const struct nft_ctx *ctx,
 	switch (priv->l3num) {
 	case NFPROTO_IPV4:
 	case NFPROTO_IPV6:
-		if (priv->l3num != ctx->family)
-			return -EINVAL;
+		if (priv->l3num == ctx->family || ctx->family == NFPROTO_INET)
+			break;
 
-		fallthrough;
-	case NFPROTO_INET:
-		break;
+		return -EINVAL;
+	case NFPROTO_INET: /* tuple.src.l3num supports NFPROTO_IPV4/6 only */
+		return -EAFNOSUPPORT;
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.43.0

