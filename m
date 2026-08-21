Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE33C4C6F06
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2026 14:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787323124; cv=none; b=EGawfOLkhZ05uRkLdZzzMMck5s1A01hVlUtWUscIjXhOfsEz5CLbfow2+034RwCFRWcw63CinBKUNtw3m1Ejzl/TGCjGattN9drk62l2p+lreIePFpyr7ExGbupU5YsBaa2EPr4hvrWV6f+ajM26sf9j2CvPjVIoMGw6Fcoys/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787323124; c=relaxed/simple;
	bh=Vi8f8gX0qVd7YTKeuiGQqbDcA9hOWMrO3f7j88ANnKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZS2hrS2nAbfr6WNK6AxgzPbXtVxhCkNbZ4p+R+dj+iC2HU3SxPcCBpYvf6ImeZiKbMkhl9Ty12DeMo70CuJFxDzcRKW6mWSW7onNFmbXrjVt2u12XR4pFkES7dar/1wYjXxOg9PKKlCX8lV8csUWKHntiM9rfpAo30GIf/VY7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=aIslxWaC; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="aIslxWaC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787323116;
	bh=mCmYBZFAMx6lpdTBV/lcqzfZ/jpp7o4lT/7L6cvuKKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aIslxWaC95rFfbMpceLKy0Kt0ZTMzaqxvouCursuFdcDxBmQCYPEU5OafPQa8Wem6
	 VNAfqT8AqU7dX8lZ9H1dQ6UMji48wGLnuvdAYQIV3Ztte62C27rxeR1ozEi6MCoBGy
	 XElGzh/K7Ymmf1TNUnzTEqFR/P+y06zxhka31uNVBF1oY8LIgcQtS8Qn2pIqEeRCMR
	 WxiKTalojYik/XrMGieFePPMsUXhysp9DgyKt/22ewNxhmUdFd4MHScH+EtSDPllj3
	 NRNR96ymyNPxWWxwLT+SqQdu1TbyTik8/3hhAeyrc/EuMD5Gu4q7OEeANJJh32q2pA
	 OUrWwtKWZTh0g==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3A0B66008D;
	Fri, 21 Aug 2026 16:38:36 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf-next 04/10] netfilter: synproxy: use GFP_KERNEL_ACCOUNT
Date: Fri, 21 Aug 2026 16:38:21 +0200
Message-ID: <20260821143827.183963-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821143827.183963-1-pablo@netfilter.org>
References: <20260821143827.183963-1-pablo@netfilter.org>
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

