Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B219444AB6B;
	Mon, 10 Aug 2026 19:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786390852; cv=none; b=Z6ReS7uAJF4sICY02GUKEdwt6Beayph9EwhewIDfY4UL1ywAlEqFrZFC3j/OoztAtHegQsxxth0u7E3dZ9Rr4aLWf0t1xT/MKo40wOl40pCE/2aEDuyXUpx9LnRpSUHvWNAF0j22bgqdvFW7v8HW2BR+HBETs/RCMvWgJVrwV+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786390852; c=relaxed/simple;
	bh=GLmAdhI4F9VTJE1vS2CMGMRSqvVXdJgb2xsz9mu038o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aiNLMhpqsjOMNgkBKba0vCEFG7wZ5J5nXVFbXAn99DpTQb2JKLHnc3LFU+z6Fr6tqAlMgxv0OBLW7B2vvYq0sX1ubDHXTJYc8U5ju0rmYXJCwV3owlrLgkluZE9bB6Q9uVEizYN9J8nVof0oO0S4MeKD9OEEiDnV13A6qrVgb1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=e5N8gf9p; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="e5N8gf9p"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C03FE601CC;
	Mon, 10 Aug 2026 21:40:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786390840;
	bh=SymprYbdGOecwib/3911oqybtfFSxbPG8PjnZVqnnZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e5N8gf9pLkZdaMnrApLbpB8qFJZ0/dTmAIoBcLNSztDvXMLZtxUNqUZ6rNyi6Ty9w
	 ybIlpPP1cin3vIj44VfO5e/wA1haDJ3rGpWUco3rSgvlHVK3lt+nOIYd00PNLK0yRo
	 Hhqe18hL1qjcnrIpR8XQyY7eYeexeKJY3j18mIz2M7hrJGgHvsDbBdjNsuHWqjdLMu
	 gsyT7JJNEJktP96Yat2sYdbFVQATIrQt877nC3NOr0TAJWeVdDlBk/AzGQP53/BBXO
	 iXp34kkchTYDkE9+EI+L9HOLZSxfVPM+QEApHYdZ6eo+6OOY+ofKuv7dK8/WsFH0tN
	 7qdwyk/oCY4pg==
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
Subject: [PATCH net-next 11/12] netfilter: nf_conntrack_expect: bail out on insert dead expectations
Date: Mon, 10 Aug 2026 21:40:14 +0200
Message-ID: <20260810194015.932627-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260810194015.932627-1-pablo@netfilter.org>
References: <20260810194015.932627-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the NF_CT_EXPECT_DEAD expectation flag is set on, bail out on
insertion. Moreover, add also DEBUG_NET_WARN_ON_ONCE() since this should
not ever happen. This is hardening commit b8b09dc2bf35 ("netfilter:
nf_conntrack_expect: use conntrack GC to reap expectations").

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_expect.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 10b130a7b230..f1f0c582db5d 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -528,6 +528,12 @@ int nf_ct_expect_related_report(struct nf_conntrack_expect *expect,
 	int ret;
 
 	spin_lock_bh(&nf_conntrack_expect_lock);
+	if (expect->flags & NF_CT_EXPECT_DEAD) {
+		DEBUG_NET_WARN_ON_ONCE(1);
+		ret = -EINVAL;
+		goto out;
+	}
+
 	master_help = nfct_help(expect->master);
 	if (!master_help) {
 		ret = -ESHUTDOWN;
-- 
2.47.3

