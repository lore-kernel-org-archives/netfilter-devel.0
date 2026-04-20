Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D45338759F;
	Mon, 20 Apr 2026 22:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776722544; cv=none; b=Mh4nzBd2/TIS5hvYxC0MVK+zdSIP1eGRbxG/4wm0ycm2OEyl9L0BohQ8asnqXpnq78IrzKk3rHArf5BrK42g1rg/A1fFVxYjzykxL1Jv+MZnCHDesOgD3/T+qMsLNxTlwVzulcW4b2TbhvRkpCW/sJCPX/MAPhne7fHDD9pCTfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776722544; c=relaxed/simple;
	bh=UBRXh4ebWqa8KGLePQsy/v1RQ0542IQzRAqco0tmKC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NVFhwA42Y59ECgvSBWJKnt2F1PRE9HFGPWYojCPofuAnmXlFayJhnn7xPxhPgJbAsDLjE1LWqSzSFKoYX1nVFCLt/1B3QyQTuX792CGhYvAboK3M4vSlTGlH4L9cCy6YOZToEtaj+PKb0GhjfXWNWoNvBvd30Udknhm/QUjBfKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=L/8RGK9/; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="L/8RGK9/"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9A5DE60254;
	Tue, 21 Apr 2026 00:02:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776722541;
	bh=UuuWXoEE6butukVks1CZBTv9eqvABiBxY1NpJxr07OE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L/8RGK9/YpDKss3yHjs2LV3IDavirFwhwSOZcH2SbhPUKtL/m5DqSDYE0PHs7Q+k9
	 DFA+Cu2+dtl5rSMU/Lp3PXArr4+C9QXLU28tmi7+fdKYX3ZI9j7TMaY1f1CiKq1+Wc
	 JYbfBk0Jf7+ybZp/7xp7f7pquPzZyTYyxnXtFgk+dRirGizllNpuxCwPHWYVGnVaNm
	 59dqmATJFh7QTNpOYCWnt+1n/JMNDT8fT3mXdRPT1Wga/IMweWLDv3+JaoS5OKH2PC
	 6qwiYmSQLHhcMAeuLy5bmkH1IY0uM4JguXjovln6jFcHBlvDwsTT8emxYrlMCrvKnC
	 yIa2Qj3A0nY3g==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 1/8] netfilter: nft_osf: restrict it to ipv4
Date: Tue, 21 Apr 2026 00:02:08 +0200
Message-ID: <20260420220215.111510-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260420220215.111510-1-pablo@netfilter.org>
References: <20260420220215.111510-1-pablo@netfilter.org>
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
index 18003433476c..c02d5cb52143 100644
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

