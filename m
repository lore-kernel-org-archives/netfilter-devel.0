Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A3046F486;
	Fri, 11 Sep 2026 08:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789116300; cv=none; b=nkRaOS5QL/2eoSFuiwXuuALDGP+w5RUUbUfF/A5eKqTWexGFq20Zn79iVZnNbnMzxtIWRLhvJI9Rvg0IsqXpnvz/4wsFAZ2IdmHNzbcXtJuJ3r5XJRGivnrVfpyiPMch+FJTv5gazNiMKNzpo9D1VcAAcpcRqn8ODNbzlGRhGNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789116300; c=relaxed/simple;
	bh=Vi8f8gX0qVd7YTKeuiGQqbDcA9hOWMrO3f7j88ANnKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YmBLb+Xa8HDaFNvmU00smWIINcquTMJGSbYLSq6iRWWU3xTBmYxzk3r9BWoOhq0+cb7PH9RzirLKqIvM6vcKWn3nZYsc0Zk+hj+tUF738J7QYawOZnCsLSJFXhmPjAdHA8qP2Te44/EUPj0pnq9l36BWRd1v4kN7cbJ3nrGugpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=aEMZ1xp4; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="aEMZ1xp4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789116291;
	bh=mCmYBZFAMx6lpdTBV/lcqzfZ/jpp7o4lT/7L6cvuKKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aEMZ1xp4BqsdnqsnzqtM7g7dWeV3/xq0goeHl2Yb2uf2Pvoy1mbGsh+nyCAZxyDyb
	 zPXq5MTa8lXyNDvU1I8OasTBfAMdoRgmEEN/ruPz9LIZ33nHfL4barB/9w4etmUbIv
	 j6KUSc75Yg5D3LCPloqepKrbLnxOZ/Juo0Vb689urw0R2HYDoi4H4PPWd8hmHrgc2t
	 MLaOfjvqHU5e00RThxcl5ekKHltJ4yXWuBBb5T+rA1UVzmX8x8v4dmEyCT9vUFqqt1
	 52d8BiEYLw4ATUtCItAeXEZT5hSGhS2ARrYHSsa/MNfhEH7nphrnNsQ0lqXeSx7lhW
	 a6gL+ODHBbSiA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EA0BE603E4;
	Fri, 11 Sep 2026 10:44:50 +0200 (CEST)
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
Subject: [PATCH net-next 5/8] netfilter: synproxy: use GFP_KERNEL_ACCOUNT
Date: Fri, 11 Sep 2026 10:44:34 +0200
Message-ID: <20260911084437.1838161-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260911084437.1838161-1-pablo@netfilter.org>
References: <20260911084437.1838161-1-pablo@netfilter.org>
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

