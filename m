Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E3B40D565
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2026 19:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781033579; cv=none; b=MDU8qFkk/WrDLipYVtM9BX1jEHxDd48BHZbgBpGFdtQUH83xljnB8GL4kZz8QWHTLVoDWFaPXcerQdOnZhYLSZlROeJiB5tmhVyneEZ8TFQnTqxUHMumaMbrB0GLxG/c2mI2ICbAJo5TkqWXVc5IM4YgINnl82x4ovg/JMIhpj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781033579; c=relaxed/simple;
	bh=5TPpBf7q6AbT31wVJcAaTiiBq/OBgBRSA6YpM6NrGF0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=AQ2gNcpS+OlsWaaFCKtppl05uSsqnHPWZOgqdntTcrIU49nQXluZsGxXnYeKlxjCiNeYnlSrii8xwX5ywFKaI2KdeXsZrDT081LANNvFRFdWifhkfeKM6lUP989OhFsi+M4qGnyWQ954RaBlCxRFWGhjNYONNXjyH6C9Evdp6GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3C167605BD; Tue, 09 Jun 2026 21:32:56 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Subject: [PATCH v3 nf] netfilter: nft_exthdr: fix register tracking for F_PRESENT flag
Date: Tue,  9 Jun 2026 21:28:09 +0200
Message-ID: <20260609193251.7931-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nft_exthdr_init() passes user-controlled priv->len to
nft_parse_register_store(), which marks that many bytes in the
register bitmap as initialized.  However, when NFT_EXTHDR_F_PRESENT
is set, the eval paths write only 1 byte (nft_reg_store8) or
4 bytes (*dest = 0 on TCP/DCCP error path).  When len > 4,
registers beyond the first are never written, retaining
uninitialized stack data from nft_regs.

Bail out if userspace requests too much data when F_PRESENT is set.

Reported-by: Ji'an Zhou <eilaimemedsnaimel@gmail.com>
Fixes: c078ca3b0c5b ("netfilter: nft_exthdr: Add support for existence check")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v3: Test 'flags', not priv->flags :-|

 net/netfilter/nft_exthdr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index e6a07c0df207..d3fc7969f123 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -532,6 +532,9 @@ static int nft_exthdr_init(const struct nft_ctx *ctx,
 			return err;
 	}
 
+	if ((flags & NFT_EXTHDR_F_PRESENT) && len != 1)
+		return -EINVAL;
+
 	priv->type   = nla_get_u8(tb[NFTA_EXTHDR_TYPE]);
 	priv->offset = offset;
 	priv->len    = len;
-- 
2.53.0

