Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3A0290BD7;
	Thu, 24 Apr 2025 21:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745529325; cv=none; b=eHcYdLyECzLlNm9Sl1VNjArpEVV02Y53snrBAakoOcowgYf9M0DoE4d1c9CTggQgKOgx6qU/eRFT923ZAPuoihyeghnb6PoTTg1cDOkevYxv16C61Jni/hQM+mPHNENKi/Sg/OPhZ+JupZjfiIAgaJ23VmA32ircGlpoD590r4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745529325; c=relaxed/simple;
	bh=fOzYwC+1kSuSFJXf1RmjiSpsBTH2v9g6dBB9rqLB7Yw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MrX3vilb4Ez7FN+Z6sEfAMtv5mw5h7yPt+JBkk2EOvR/bV9wXKXIbQXQEqc31hxTvkEvdg7YmRqYqytGh4OAZZrbLlSBnL1RoesAU0mGFJKFATw5ShfoCgZWaH62CNm3UIvpDJM4RtPpT3N9WmqC8zIRVgSEHtzhtq7jXmTpNoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BCrppAqy; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=r0lOyD3R; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BCrppAqy";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="r0lOyD3R"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id E4CE46070B; Thu, 24 Apr 2025 23:15:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745529321;
	bh=W2iPd5dcyQ8M4ppe67DmJVGFeHbT03yeWlCC/k3bkts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BCrppAqybStu0TU8SHY1Y3CHhQJSN/H/FR33oO9sG55MWJqM3PHSkm64ri8eLruRv
	 euKkhyv1o8ghniDiq1bS8pfM/xQ7p7g3SdmXh7ZV9XZXnUg2yAZzM/yy168bNnANvA
	 aNR2fD3Y/+O2SX3ZKosF0X9Md9dADllF0c7uofcpgiY/VdUqomG9pfGB3wAxEL8uhj
	 QG2qdhuynLWckd08JFBH00XsboiUzlK/EgqrPtHbfnBosLZ6/XmqMvgDKb7ENY7Bxm
	 +cppmdgJn+sLqP+G47kk5/dXWLf0ROfW+Enm2LaxS2tI37YQh364/50H6Ri+4oRrw9
	 hR1y90Vr+I7wA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4389C60714;
	Thu, 24 Apr 2025 23:15:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745529314;
	bh=W2iPd5dcyQ8M4ppe67DmJVGFeHbT03yeWlCC/k3bkts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r0lOyD3RrB7fuROB15m4kMi+gH//ZTELGoxipD/gPA3XvvDfexV6EojoZ6YVk/2DA
	 J2i1fANe4G3CjQGyutYUqnmlkyJvQxetDCtY5Q0WVNUD0NmHSF8PaVXLKIRgh1HSHx
	 jcOzpKLsNSmlW6TTCOjpMZ2bNu1fCqrwxNqLJZKL8TrXHt8Y90hLZ8hP/J4BgMBf7p
	 WiGNeuxWY4PVEnI0xJWwVmrvz6fjlqoovCIiyY1gvnoPsfPZhSUF8rVna1MouwqMUj
	 mN3wqvVm1vg8MzcvvATpNQw2uWaoAXvmIochDyxcUfBYvQMc2Znze118A4ytacwFr4
	 T9vEoiBNPGAiQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 5/7] netfilter: conntrack: Remove redundant NFCT_ALIGN call
Date: Thu, 24 Apr 2025 23:14:53 +0200
Message-Id: <20250424211455.242482-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250424211455.242482-1-pablo@netfilter.org>
References: <20250424211455.242482-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

The "nf_ct_tmpl_alloc" function had a redundant call to "NFCT_ALIGN" when
aligning the pointer "p". Since "NFCT_ALIGN" always gives the same result
for the same input.

Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 7f8b245e287a..de8d50af9b5b 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -531,10 +531,8 @@ struct nf_conn *nf_ct_tmpl_alloc(struct net *net,
 
 		p = tmpl;
 		tmpl = (struct nf_conn *)NFCT_ALIGN((unsigned long)p);
-		if (tmpl != p) {
-			tmpl = (struct nf_conn *)NFCT_ALIGN((unsigned long)p);
+		if (tmpl != p)
 			tmpl->proto.tmpl_padto = (char *)tmpl - (char *)p;
-		}
 	} else {
 		tmpl = kzalloc(sizeof(*tmpl), flags);
 		if (!tmpl)
-- 
2.30.2

