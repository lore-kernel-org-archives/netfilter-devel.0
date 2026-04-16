Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32CE0B640;
	Thu, 16 Apr 2026 01:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776303077; cv=none; b=LdhGkLQqsya8BZjh3QgzB4BIhsf4W78py++20Hdi5renI042jW1+/Ig1iMlyflKk80mcZ+nyf2MM+aYNX29HU5Ctr2O4Hbgi4er2mZ69P4aRLi7PSTQpR7pXy/mo11YNk/CU6E+ogDYjKBv9Y8AWqrhG8uN67GJ/8PckKyDX31A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776303077; c=relaxed/simple;
	bh=aYSgQvT+PZxYyGPJb6C7g6YeX+WiAbZcu8eRnaH6H6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXqtmqVtjx5G1O6f0NUpwqB+1avGWkNBSTdl2jdf0b+kzT3xgsv5+wdThcu/iN/cxSqe9d6fPuGz8rXeVyK0w4PaWPcsLD1bi45DILoHzticpPGBMdSaQmmkBQ/vL+VB6CWfqCWYiSezkMV9QkusBUNXpJLUv4g0RrQcpcfaO0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Uf2eixts; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Uf2eixts"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D93116017E;
	Thu, 16 Apr 2026 03:31:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776303074;
	bh=RBi82MRm5pfmYw2R+MLbGyGBquLLveo8OLo+q1xI5Sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uf2eixtsnNj5e1untSsSsOSAH4pucbTwM7QmG+IWBXGKlESUdfl05puegMYY8acBi
	 00sy5GkFdwYrbpcSxAYZSLjFWV1DE8EpuNyvpSDYLyI8GlanJz9CbZii6W+rNetGXZ
	 9xJ9hMueIKSnwvtI1AKBG25bpu2HbSgqyQHk242e38AZTpecid677DSNv5kH9NYjAZ
	 Jteat+jUiGf9Lx/EZgN96SL6Xm4fjF3Fvm7FsCjvBf72BeNfIt/CaNAhJ7cDe+eFr5
	 GGYUAK4lRpfoZ4nTZNR8aTa+zQio2hYwEadgj96RXo8bfn6C09JsbJjWbzwBxNrBjH
	 nMmNrzxChyIgg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 05/14] netfilter: nft_osf: restrict it to ipv4
Date: Thu, 16 Apr 2026 03:30:52 +0200
Message-ID: <20260416013101.221555-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260416013101.221555-1-pablo@netfilter.org>
References: <20260416013101.221555-1-pablo@netfilter.org>
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

