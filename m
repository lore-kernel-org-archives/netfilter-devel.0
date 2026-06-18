Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CA716A395
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Jun 2026 22:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781822123; cv=none; b=PXU2cXseKNZuENM1QroDVjt2ai8kcor6dWF59FvcBfcI6P0NryL/HEJT4wH662Mu+9F2PWv6gc1jQr9/Uop+FCRXd/TU6s7IdyHcqVJCvuiExApUyS70VVhmyLbDvpVfiQM2pv81l7ioYr8XyeZZ9r/2KnJ3/5d7D5nGwqIqw5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781822123; c=relaxed/simple;
	bh=2MkB5Ag7DrXhvUxDF1N+Mdve7FMdJBQJeyWmzW1+uLA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I8v4xEQOIGdd8aF0T+QIYIWScQPa08w4irYCxWoZyERzZC3ivY2+of+DR2ZEkITDzK8kSgsojRNuiGCow9Bd9l1Frs31ZC3yfNfyVa3HjppEcOJbrbVlxA0ll6GKoKwwLfLJJblH0fLN3O888Lj+s8p8FDTnabcvRkWo2/0KoZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C5ED960491; Fri, 19 Jun 2026 00:35:19 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nft_meta_bridge: fix NFT_META_BRI_IIFPVID stack leak
Date: Fri, 19 Jun 2026 00:34:49 +0200
Message-ID: <20260618223449.14896-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This needs to test for nonzero retval.

Fixes: c54c7c685494 ("netfilter: nft_meta_bridge: add NFT_META_BRI_IIFPVID support")
Closes: https://sashiko.dev/#/patchset/20260618061631.21919-1-fw%40strlen.de
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/bridge/netfilter/nft_meta_bridge.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index 3d95f68e0906..e4c9aa1f64e2 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -44,7 +44,9 @@ static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
 		if (!br_dev || !br_vlan_enabled(br_dev))
 			goto err;
 
-		br_vlan_get_pvid_rcu(in, &p_pvid);
+		if (br_vlan_get_pvid_rcu(in, &p_pvid))
+			goto err;
+
 		nft_reg_store16(dest, p_pvid);
 		return;
 	}
-- 
2.53.0

