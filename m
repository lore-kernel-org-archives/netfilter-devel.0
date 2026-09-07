Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38063BB690
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2026 18:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788807363; cv=none; b=pFz1pj4UO5Xx6St7hr2PJwr+LSqLCOdMTSmble5IRUVAmB9n+GfkYSyVwOJg09+6imfccmpNuwUmgP2vJgvpJMUEtF+3HsmX63IRQFFYTBzGyfSyA0y771RW/h8OVgZZjFzjCMUJXSf383+OAmCPSD/mY2Nm2aHh8sVGbROCEpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788807363; c=relaxed/simple;
	bh=iXwzEB0+f5383joctvxregydwVoKCJ2/lKI2gDs/MX8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9JkUFqO3jRfHi9HNSr6ng6AfVEJUs+9CE8l13vJPw64VglKCUD/0dHTOCkBiLEvMMK4QYKn5GGFNRcqfGH6tW0cQ1B3Q5l+Wo5gSJHs1AKRBFepbDI+ZyDRQz+JN7ZNSQLY5yskRfDIgiJwJfo+EIIQ+mG7Mudq7hdZXp8ujn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CIK1PCks; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CIK1PCks"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788807360;
	bh=15w/iLlORIiP+1fAEeFfdbC03e6YpY5LDs/FpWokryk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=CIK1PCks0rAcyieW0xKnZk3ZlRA115xq2Ujcq/QlpA7pAT+wa352NM0BvR9L9mLcD
	 /T6NYQOER97LWNLRWuD6v5DxM86BKxxAbwJE3gAHG61fJCu5f8wA/GerC0pCE3JCe7
	 i2WlnfjbjmuKywfBhvBlDTpmJnLLRAtmtQcgHWaG0gGhJUNGrVa3H2pJrMNdbxcVLU
	 Q6E4sWNxPNLh+AlzHD3XcvvoOpIj14CjOgBHwMwoLUZ4AL2IflgPSlK/ePJiwt4C6f
	 xHVhUJ8nisCJ+X54Q65KaCzQNANGu+1sJLUiLpQGhBykPB6BvP8iu3n+su1+XPP3Fh
	 8XOywzTJRQ9eQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1CF3160796
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2026 20:56:00 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v3 4/8] netfilter: synproxy: use GFP_KERNEL_ACCOUNT
Date: Mon,  7 Sep 2026 20:55:48 +0200
Message-ID: <20260907185552.1422008-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260907185552.1422008-1-pablo@netfilter.org>
References: <20260907185552.1422008-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

GFP_KERNEL_ACCOUNT is preferred these days for memcg, replace
GFP_KERNEL by GFP_KERNEL_ACCOUNT.

Allocate template conntrack via GFP_KERNEL_ACCOUNT.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: no changes

 net/netfilter/nf_synproxy_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index acd360515972..9fc959ba2030 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -336,7 +336,7 @@ static int __net_init synproxy_net_init(struct net *net)
 	struct nf_conn *ct;
 	int err = -ENOMEM;
 
-	ct = nf_ct_tmpl_alloc(net, &nf_ct_zone_dflt, GFP_KERNEL);
+	ct = nf_ct_tmpl_alloc(net, &nf_ct_zone_dflt, GFP_KERNEL_ACCOUNT);
 	if (!ct)
 		goto err1;
 
-- 
2.47.3

