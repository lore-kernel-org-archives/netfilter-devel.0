Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DAB3C4542;
	Thu, 16 Apr 2026 13:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776345307; cv=none; b=UXMQSPQZelqSn55TjbTKdF1c7bW19kn/q1jq5Xxkgn5vrSGNHkh1hISABOvSlWqw8rGVQZOCMfbWriTZX5ZZ8KTJuCxpKyX0UNy4/tvtRHk4WYL9Ac7ZlpuYYRlCym/4vyME5XI+dZY4YAcflWzFcOi8tTtCLHQUBcMKhoC/TQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776345307; c=relaxed/simple;
	bh=aYSgQvT+PZxYyGPJb6C7g6YeX+WiAbZcu8eRnaH6H6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKK8fuR2fkm6m5ZHWMAWGxOtk2qzAH6UnAwnZZQ1rMN1n4OCN3D+PpEic7WG38rgXUCRNOei5+Nj3d0CKjGQ2E/3ZzWj9uec5anNeRarmG0fCUcEzB/a7WTHKx/Y2l9UXnPMeJJ2Ss+WoWp1Vwsrcdk/8guofqSR4MvqFc7yDqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vKwM+YI2; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vKwM+YI2"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5219A60255;
	Thu, 16 Apr 2026 15:15:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776345304;
	bh=RBi82MRm5pfmYw2R+MLbGyGBquLLveo8OLo+q1xI5Sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vKwM+YI2jBOlKhsBluh3IPy2Q/YPsw2Mgxu23TEYkO008N+C9rpsipNfyzN7z70Mr
	 OhhDYn19loIk+SdZvteKMgJq5FuHPw3DsAmYQv0wt8fnBSHHX0aJPRe1mtAehzt+LE
	 R0uD90Uh6D74ANvOBB+dIEBdOHQ3+T7o1mzAi39CMP13UjphAkuVF8xfohvGao7T8w
	 9VPgYnqACa1orKsZENTYBi3bmRcnX2uJZV9tR0dW9VRJMusK/Uv3tL2lXs060vJ7tT
	 JDFsMGM/5GGn9d7SiOuNKkbobpOME4IrCrwhxBCwclsrqtnb3anfA5vGmvL/w6MlpJ
	 F1oe0TzUJwAjA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 03/11] netfilter: nft_osf: restrict it to ipv4
Date: Thu, 16 Apr 2026 15:14:45 +0200
Message-ID: <20260416131453.308611-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260416131453.308611-1-pablo@netfilter.org>
References: <20260416131453.308611-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This expression only supports for ipv4, restrict it.

Fixes: b96af92d6eaf ("netfilter: nf_tables: implement Passive OS fingerprint module in nft_osf")
Acked-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_osf.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index 1c0b493ef0a9..bdc2f6c90e2f 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -28,6 +28,11 @@ static void nft_osf_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	struct nf_osf_data data;
 	struct tcphdr _tcph;
 
+	if (nft_pf(pkt) != NFPROTO_IPV4) {
+		regs->verdict.code = NFT_BREAK;
+		return;
+	}
+
 	if (pkt->tprot != IPPROTO_TCP) {
 		regs->verdict.code = NFT_BREAK;
 		return;
@@ -114,7 +119,6 @@ static int nft_osf_validate(const struct nft_ctx *ctx,
 
 	switch (ctx->family) {
 	case NFPROTO_IPV4:
-	case NFPROTO_IPV6:
 	case NFPROTO_INET:
 		hooks = (1 << NF_INET_LOCAL_IN) |
 			(1 << NF_INET_PRE_ROUTING) |
-- 
2.47.3

