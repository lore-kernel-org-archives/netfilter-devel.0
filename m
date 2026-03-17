Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA6737C91B
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2026 18:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773773642; cv=none; b=ae9Y+dnXOI2e/7ENoFDnS0hPKaumgyw/tYhF0TsJU8AGDnYjynqQzLtCeK7xDnKMmTa/E7qAp+1LIytow/7QZHszGttKxdVpWXWh6phD4daK85NQnOp3Ax784w2YBvta05Q6xznXi/e+SzfiWl84sNRqUwLAiy8/hBJixNZ0wrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773773642; c=relaxed/simple;
	bh=vW0PkwAU8VuB1g01RBLLkEiQiiOsQbYjZuurI0ErI0U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BB3JdhQA4kEQtTQYx+Pd+EVNL7FhHoy79PeHExvPAWwbnKs9MqjJqffKKCL2yANQF73L96b1Lq4FUiT0Y75g7PG8pW3nqSd9eNuQCQUNcx2rZCZIjgquDXlzp7JhAu9lNTFPQtGO+Y/YY1w4DUGxR9XhNXAxY1qnr8W9Md6qTpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Dis6sFZV; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Dis6sFZV"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 637F760180;
	Tue, 17 Mar 2026 19:53:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773773638;
	bh=SOvomFegR8vB2TDEJJK+3zm6H6tAlpmhPzzQBsCAAYg=;
	h=From:To:Cc:Subject:Date:From;
	b=Dis6sFZVC56GrcVIttIWs66xyetRxVwgfNSUNMLX4ntXOvQ3viakZcyIZYBftfiW2
	 R7Z9ZYTVA47FplV30q2fHGiBB13CevfNaiYTinT1bfu7xXkDVnJ2ELQ3vd4S2vdZmg
	 v2em7zemL0EUFdPfONhLKu0Do2gxporpvYzpzFrDesxIGIQI6Fj76kFA/6TudHv1Bi
	 6ZehknYgzSwlapzl0NPU0GgNzd5Z0QYfI7QGIXTOTC79xUoFXl3Zlsk8unoN1KqFKn
	 e9cPRo2Z23KAOEjtJCpgaG684aETX9Pa/CABjkxlbpyhKW8fZg6grrdrkyHuGKXOsU
	 IkQd+BLDfrf6w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	yimingqian591@gmail.com
Subject: [PATCH nf,v2] netfilter: nf_tables: release flowtable after rcu grace period on error
Date: Tue, 17 Mar 2026 19:53:54 +0100
Message-ID: <20260317185354.40804-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Call synchronize_rcu() after unregistering the hooks from error path,
since a hook that already refers to this flowtable can be already
registered, exposing this flowtable to packet path and nfnetlink_hook
control plane.

This error path is rare, it should only happen by reaching the maximum
number hooks or by failing to set up to hardware offload, just call
synchronize_rcu(). There is a check for duplicates but the hook parser
already checks this.

Uncovered by KASAN reported as use-after-free from nfnetlink_hook path
when dumping hooks.

Fixes: 3b49e2e94e6e ("netfilter: nf_tables: add flow table netlink frontend")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: use synchronize_rcu()

 net/netfilter/nf_tables_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 72c1db7738dc..da82a754ba33 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9155,6 +9155,7 @@ static int nf_tables_newflowtable(struct sk_buff *skb,
 	return 0;
 
 err_flowtable_hooks:
+	synchronize_rcu();
 	nft_trans_destroy(trans);
 err_flowtable_trans:
 	nft_hooks_destroy(&flowtable->hook_list);
-- 
2.47.3

