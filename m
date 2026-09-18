Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B7E4E322E;
	Fri, 18 Sep 2026 11:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730939; cv=none; b=eUDjAio6Cqo+2SOePWsfmixqAUKvnen6vIr5yo5N2kILDl2IS5Lj1zlSrHeanSPDdRux9HGbK6cVmjQAm09Qa9qmV64lKo5PPURlUzgYN1iiSnYC1R4pK8+zHEjUKWggeOyPcDVzZekZqKSQYI5r4jm6l81HPmpRfTS2w16PWc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730939; c=relaxed/simple;
	bh=pE28NPY90UD0ILyt7TwrgYXG8yrnhL/dDYROUIZ9dsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sItH2/T/DfovS2ZuRXNdH15LIuyISQj2qNNe4GLWkWAs7Jj7whuvrLGUH2JDS/kFIvsBhIYIOkW8F75H8L19wuuH/i+Vl6pJFn1uiXOUp3DfktNNVs918tZhb70ZUaXg6z++Yomif6I1phmxmk6T6Ojxi2aoOUdTJoC1gR1i57k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BWun6hFl; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BWun6hFl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789730936;
	bh=azYOXXiaAE+HlioLyPG6TNLzwtbPax/e5gPYnraZ35E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BWun6hFlP3UR81OMTIAWOI5BPEWXL2uEX0aqzY3z+08si5soWO8SFoILaKDROJly1
	 ow3xDrDv1fpM1p28u1qxcjGaxsoY6yGobNJQxtMQGn70Pq0zQyK/IBDOV65TsWnvgu
	 bMa9/DoGXl3oqY8RuPwV/zd4B1Jkekjl1k/Wf/JtsLADa2CWkTghnodof3c5rgJAjw
	 3ytPPMbCuWmi+JkXflGxj2pMl1jxh3Wat0EJ+u0GvLxCpNVK0KzWRcTdgNvLBUO0a1
	 vHoavqyjf8IJ9FDevLrqkX3brNfy13HX+WzNW2xuMpF0qUKBmMByy0x1wWNw+Ksjva
	 NSza9eSC/XoVA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B73C96005D;
	Fri, 18 Sep 2026 13:28:55 +0200 (CEST)
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
Subject: [PATCH net 5/8] netfilter: nft_synproxy: use the family-aware checksum helper
Date: Fri, 18 Sep 2026 13:28:41 +0200
Message-ID: <20260918112844.194503-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260918112844.194503-1-pablo@netfilter.org>
References: <20260918112844.194503-1-pablo@netfilter.org>
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

