Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A9A3F87E0
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2026 19:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773774034; cv=none; b=FfZYNPkvas7yO9XH/6BYkopNXX1zUm2hd2God0oP7CVc4YSXGvuR1CXKHmmZOPRMfB2UsOJnPZNSeYnXtQcaVYGAI6rxi62I+9TRGiymRFl/WXm3JpatKkrbXpl82wRZ6fL3YbFCzZ+pfk8JBkDfyY55lW9IYEDOSnpN0z3pgh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773774034; c=relaxed/simple;
	bh=FICsEE8aX6pdouhE3uBH6iWwWoFMtO3Zild4J03hayM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eoYb8CuZHEVP5zsrfuNY+ATEMbJSS7cbMCGoTH6dgS/npyGuH2DUzp85Rcj2p6cuEB2P+lOTxC42UI2unBKsQrv5KBBC/1FvGx7UZtGJfDrRhCUhiUuzy/xbGH9cL265lOZs6Jgi7bpKCH/X2fCPTO9Dq5aMtJ58+WHQYGfuQ7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=V4iMkrrR; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="V4iMkrrR"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7A26760263;
	Tue, 17 Mar 2026 20:00:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773774030;
	bh=Fgc+lSxgS1ZVPfzlyL7jbpfeFrpwuAC/WT246eGu1+Q=;
	h=From:To:Cc:Subject:Date:From;
	b=V4iMkrrRXluTuuiVifaLu/wJ/kh8epCfyAInYLFqW1JSImCI33atcwWnb5Njae+sd
	 LQchsEuWki1xykuSNDc57M13kj2GebswZPgq9fWSkLrZmrj9X8M0li+HNS1LTmvQZj
	 Wg7mSbb1ckYURt33f2h2ks3O6pEDdtw1MRaQ7gp00EomOWilgfeNlH8UF3NfmgYDwh
	 gDpGlEhTCKXiA7tB1/rkvsuQ/v9UQbMeHt0tNNwYZVLm/0qADpTSFizSMJnWC4ZHUx
	 kNLLMrYISulrx/5tc9wlMyl6efJPj0Wr/kTR6I2O3a+bWkakQD7srECHMeInxqWr20
	 Evo4140ADc+bA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	yimingqian591@gmail.com
Subject: [PATCH nf,v3] netfilter: nf_tables: release flowtable after rcu grace period on error
Date: Tue, 17 Mar 2026 20:00:26 +0100
Message-ID: <20260317190026.42375-1-pablo@netfilter.org>
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
synchronize_rcu().

There is a check for already used device hooks by different flowtable
that could result in EEXIST at this late stage. The hook parser can be
updated to perform this check earlier to this error path really becomes
rarely exercised.

Uncovered by KASAN reported as use-after-free from nfnetlink_hook path
when dumping hooks.

Fixes: 3b49e2e94e6e ("netfilter: nf_tables: add flow table netlink frontend")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: Clarify EEXIST situation when registering hooks with comment in patch.

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

