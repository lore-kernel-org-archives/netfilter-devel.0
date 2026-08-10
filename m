Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0335337CD5A
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Aug 2026 10:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786358108; cv=none; b=NsVkp6RNm1TpBJytGLUC1btArBTRKGzpRcbcP9EsJwViLQmohjwyEFGeZGoi4taKfFzEX30p87pC8GJhVL2LvICv4hpEqZocOppqU90FF1aXlp+9MiKB/NSPp4U1p/G32VvM9douhQ1V/c9sw30vrXTezn/ZXpbZWUQmhtL8/KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786358108; c=relaxed/simple;
	bh=zbexZ4nXsN6nkSueslIEMkCLFETCNSprZu/MKFoa1ho=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=mAajh+sJOq9+GBvwsJ7m3jgzdJqXVw8fbZtAebnWS0lH8RWdRu//rABIqrnFvtTliOVWcSWk5mOLETjam8ERYcjcmjx12YW0Y2G0vV3Q+MHRH1kDd+/JL1z5Rb75qh8gQiD+OW2KPBrtK24KuKpMEXHyHki23B8lZly3hSHXBd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=E7yfr4sy; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="E7yfr4sy"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 678A360191
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Aug 2026 12:35:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786358103;
	bh=AnmS2XOVfXt1yiERmCOB4s8qEpWoMByY7L0ps/tA9Ro=;
	h=From:To:Subject:Date:From;
	b=E7yfr4syTE1c3y3EfL5SXnsN4YDhQ4sAAgoNSXhOBbSvYn5pw63MZ/Wv8x5yfeV6F
	 5ss9gwPPdV2MYIBRcRDCC1UmFtt23Ns9JTfIzJ8cRJai46RwbeqjnIwn15gaofTTSZ
	 GHKkrQ/6wEkBL4BSkwJrnABjkj5vNTIRBRzrYEu9DE3FG+UvuOgvAD39+Ui/kMbl47
	 oXv6KXWCDsqa3+TOSlFkwWhh7Hfz/zxR/1H0215kJYrwoMA+fmLhAqbXs7JQ/udnaP
	 P1sIEuxFnNxmzxp6hdi0tI18w2Ohaukd41k9M350HvfAvi1tEuo2y05Le5zlI+b36J
	 7yGE1yVkTbuuA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nf_conntrack_expect: bail out on insert dead expectations
Date: Mon, 10 Aug 2026 12:34:59 +0200
Message-ID: <20260810103459.767936-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
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
Based on a patch recently posted on the ML.

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

