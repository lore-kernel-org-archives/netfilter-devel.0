Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2374D4D5991;
	Wed, 16 Sep 2026 23:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600627; cv=none; b=YuaKsBOn0C9PsMTDY5SKetstLzmAb7CwsaRD7TVvaOP1XTKZ8rPTuTTjkTVOwla8XKeMjyeIH7sFeeHOdHly5eDPWqg/ol5ZtB/IrMqzgqdWQPBMdOb6txUB0LXGG8YX3QiKCuAQRbsE3SaiZDB+HqRDMMCRLCIVvUt9fI7PhLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600627; c=relaxed/simple;
	bh=pE28NPY90UD0ILyt7TwrgYXG8yrnhL/dDYROUIZ9dsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8/QDfDrAPctnnY1Id/H/7GmaGSC7WoUd11dMIiGb/+1lLOHNaHEqRZqHeOAOXlcWElAQ74MK+2zQrna8Wta1VviBybJo1z1jdLt7IIb8uuSE5KZb0JBh8VDab54Zb53UmLCgXj6jykl7NUGeDkq5gq24tuI6Hs0rQjZjAQDU78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=GDnj/Zkp; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="GDnj/Zkp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789600623;
	bh=azYOXXiaAE+HlioLyPG6TNLzwtbPax/e5gPYnraZ35E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GDnj/ZkpY4wLCVbCitluu5VX/QCcx2p73O/V9Du0rVCkDhmAiL6tHuy7dfIaagk81
	 CUgbWHhrNAiN0iWGmo0BVkbGsIvh3Mcpiza956FyCqhdPTJdBwk9wLYALDXG0GEc9K
	 O94oF+7I/eQluwvSh0CHHcP8tS+WNNWYAmMBgt5skuA+DTt66Ckc/3JL0qSa+DIVqc
	 unuhgqJyPm4KWvPgxxdkUYegu7ZK9mjXhH5PQDz7KB5wrZjZuMBciefjOUAVrrBf1B
	 fmsE6bxd2b0kHZR3XpXWSMjqJs1XJD/xg8Iw0bkMO2pv5SY3gRwrYMPMmcKDxmywIZ
	 XapphLKg83PMQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0020860092;
	Thu, 17 Sep 2026 01:17:02 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 05/10] netfilter: nft_synproxy: use the family-aware checksum helper
Date: Thu, 17 Sep 2026 01:16:46 +0200
Message-ID: <20260916231652.127456-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260916231652.127456-1-pablo@netfilter.org>
References: <20260916231652.127456-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Karl Mehltretter <kmehltretter@gmail.com>

nft_synproxy_do_eval() verifies the TCP checksum before it switches on
skb->protocol.  It uses nf_ip_checksum(), which constructs an IPv4
pseudo header and relies on the IPv4 header checksum when folding the
whole skb.  Neither operation is valid for an IPv6 packet.

A correctly checksummed IPv6 segment can therefore fail verification
when it reaches the hook as CHECKSUM_NONE or, at NF_INET_LOCAL_IN,
CHECKSUM_COMPLETE.  nft_synproxy_do_eval() returns NF_DROP before
nft_synproxy_eval_v6() can send a SYN-ACK.

nft_synproxy_validate() deliberately admits NFPROTO_IPV6 and
NFPROTO_INET, and the xtables counterpart ip6t_SYNPROXY.c already calls
nf_ip6_checksum().

Use nf_checksum() with nft_pf() so the checksum helper dispatches to the
packet family's implementation.

Fixes: ad49d86e07a4 ("netfilter: nf_tables: Add synproxy support")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_synproxy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index 9ed288c9d168..554a96a000f4 100644
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -118,7 +118,8 @@ static void nft_synproxy_do_eval(const struct nft_synproxy *priv,
 		return;
 	}
 
-	if (nf_ip_checksum(skb, nft_hook(pkt), thoff, IPPROTO_TCP)) {
+	if (nf_checksum(skb, nft_hook(pkt), thoff, IPPROTO_TCP,
+			nft_pf(pkt))) {
 		regs->verdict.code = NF_DROP;
 		return;
 	}
-- 
2.47.3

