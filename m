Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C011329C6D;
	Wed, 10 Jun 2026 16:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781108204; cv=none; b=rqHyhtUcqpbdw9wGqtY3Hf+93k6uOeEcP8npVbtatShvxlQjjxnNl8RCtjs2T/LQIshxBuP5LSG7tnNx613CaqvMmgpSUzhdmazBG0NYAY+40vnAFNvGrILRIPgNYT7scjd2xsi/TUUsfBuNL6pMZXMKNkFF+uknGZiIeVyVzb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781108204; c=relaxed/simple;
	bh=SqXNmArWujVyA6eQIKbGT6Hw0s8aIFhuIoDTnMvDkQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJC4GsQg3lWUoJQU+9a/qbhx/DpxxkhFtbvc0VEcwH5j2Qdww03aZR8Ye2HON6bB2a2wBHCwdykYpROESL8sCI0Ibejer8tpB1YCR1PfqEl3ajA2bQqL76BlAJHHzTDnE2SQh/Jq9dfQH1/T0CkU/0JtKoz/GGTilxrP++0FjZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=D3vGftFX; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="D3vGftFX"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 357D2601C3;
	Wed, 10 Jun 2026 18:16:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781108200;
	bh=o7KrY1GQGf33Q5CNPUfbBAqJJMjGl/9PXidLpxLAWL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D3vGftFXx/LkdFoS/hAjazzvY0WzEGDKvKnQtGk1yyJylhiTfmvr8WF+bZ7NChjM3
	 zM2rPie9x+xB7jSdcjNtmwA7avkCjCmdwJLNAzKZFqKaiTCd/4pdh6Dl/kRXh1Wd22
	 auXQGpDfb8DTKX4qQVMBat3ZNDNzKxieTjbm0a5HUUAe/jbZpo7ngE1fu0R+ycc7+q
	 nFvxkfAQbYVy56Niu1C4f5eKYKsTD9jrXL8veenpuefBElN0UgwFsCtv9k8dur+5io
	 rt5QaDKZT/gBbgY+tHlOWs0i+/hRJ5sfFSoenpTQD/owLtUGjHRWZa8ajKC7uCdMCn
	 9+cedg7XAiJmQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 6/8] netfilter: nft_exthdr: fix register tracking for F_PRESENT flag
Date: Wed, 10 Jun 2026 18:16:26 +0200
Message-ID: <20260610161629.214092-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260610161629.214092-1-pablo@netfilter.org>
References: <20260610161629.214092-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
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
2.47.3

