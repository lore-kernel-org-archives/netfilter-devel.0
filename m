Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E6E371D1F;
	Mon,  1 Jun 2026 11:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780315173; cv=none; b=Lmg5qQFTFrEZuglfiD1hK0Yz2g2mNN+X6RqHL6LrMHlsppx+ZymI9rMPDmef4SsJ3dZ2gMRSPjw2GRQ1Y9pVAIVJZEq4zHCp0HdJGVeiXW5af1SGeEp24t8aZ38EOqe8dXPG/0KxDAESKSfwpd1xS4jnRx0NieX5IIcPNCNr/o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780315173; c=relaxed/simple;
	bh=dGRDo5qy+AY8E5TCSrtDQhBNBdbPPtuvL2sixRM+eXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QssFEdERlJjGJ3KZxdjCpmaaTwA7eHrZIscnAV8CICpkWTi+EVOndTdqwO/fG0jAzXZ5oIde1gfcCNnqb1Jh0YS1VbMNVs208Hh7ZTO8L9UVvg8DQw/dqH+8mcFKL/C9BEfqKnyGUPUuSeI/6iojeW3+ec8/algykjtUbIzbNcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=hZPloisn; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="hZPloisn"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7BC8C601BD;
	Mon,  1 Jun 2026 13:59:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780315169;
	bh=+hvLSFXcLLnHE5Px2v78qKJo5uK7ipTjAqAd9sdDd+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hZPloisnU+YGLnBA63ueEvli64tyXwdBf5MJh6ZWJ69Ase4EIFJohx0ZBRpJACF7D
	 AcdP+wgq99M+kRLX0rKsZTiDMyumx0pHPnTdYVnNgbnJacTuXbDV2nM8VMlXbyMPJu
	 jaDgt9HwkdzEJQto/SQkTLhapXXopTxmGP3u74HMPvw5bP3oZS62GRgfjji0D9RH1p
	 WT+VEqVrvcA59B7DIc+Obp+Xtnco5+lebz0u9WVfbCe2jlf0/v8XSgBH3kRzLspcwu
	 ZzmnWaqD4hhwdI4Qu9JmRNIPm9lpUDPgD7MnjGmZv5sxF43KEqaQQG+lujyrXzhIdy
	 EQzikJK5Lg5JA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 1/9] netfilter: xt_NFQUEUE: prefer raw_smp_processor_id
Date: Mon,  1 Jun 2026 13:59:15 +0200
Message-ID: <20260601115923.433946-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260601115923.433946-1-pablo@netfilter.org>
References: <20260601115923.433946-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

With PREEMPT_RCU this triggers a splat because smp_processor_id() can be
preempted while inside a RCU critical section. If xt_NFQUEUE target is
invoked via nft_compat_eval() path, we are inside a RCU critical
section.

Just use the raw version instead.

Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x_tables")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_NFQUEUE.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index 466da23e36ff..b32d153e3a18 100644
--- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -91,7 +91,7 @@ nfqueue_tg_v3(struct sk_buff *skb, const struct xt_action_param *par)
 
 	if (info->queues_total > 1) {
 		if (info->flags & NFQ_FLAG_CPU_FANOUT) {
-			int cpu = smp_processor_id();
+			int cpu = raw_smp_processor_id();
 
 			queue = info->queuenum + cpu % info->queues_total;
 		} else {
-- 
2.47.3

