Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C654746A618;
	Fri, 11 Sep 2026 08:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789116302; cv=none; b=HuZ9AVKsUP3wDESWsNKXypjyXhbtMef2EoXw0sx3FC5eBSCExpGprHqZEbRGd/5dP5aDh0ckbaL88p1H4QmEntXFqvE5IvD3bZ2MK/5U7vgU+nHcLM+bylAT6OC87sTwGg3S2Bnn41/ca5TwLerT6/0/qdsCE66/B/5cGK+pM38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789116302; c=relaxed/simple;
	bh=iiXSUx4uQVC4M2bs6rxgqF5NQQn2RJS2IpCGhoemTP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hxe1ByAHNe0+rU2AqhufBGsdoqp3XG8+xch2EcPzVVBrs3cImpHqq33YGD1O63TIN05Ru/mjok+jph28Bd7N9YivLv4R3g/04mJMyTHGHdH87NGe78HYVJe/qzaO2t4fdGyjmO6x+clR2erwkDNGfQFofV1ATx6nN8iLL+oTClc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cyY51KRf; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cyY51KRf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789116295;
	bh=8WXZpFZSaGoNmI1YBiO3P9o/cFSHOTBtFml7SidZqdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cyY51KRfLvPqFnK+UnXme1Wnk5PVq+vtnm9w9Z/V6i0JvVVc+HwKwEt1WNBpyLiWk
	 TI8EdP74d2dkNWE7l1iwEM/d1MGvOBRycQ0Y2LgRr2ApM/oLfhZPvM/KdmQcm4O4fc
	 CpAmKSOBCd9NNlTsTbRMmjixuyN5KC3/FhRxn1E7LxwGZB4XvFagYvmHAJ9UeSNZx3
	 6/1wpELRxAfkTuNqSLkiFBLK6Sc9JmNcH++0n88AL/gC6/Utex7mmS9OzY0u6dB/Yr
	 Jdj8z/7CME2/fB7UH4FOVca778QaA77UFkOtoch3xIPjFFQ1BZrIqFOxiyRe+8qPNj
	 UmHSrbJ5htcXQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C9704603E7;
	Fri, 11 Sep 2026 10:44:54 +0200 (CEST)
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
Subject: [PATCH net-next 8/8] netfilter: conncount: use GFP_KERNEL_ACCOUNT
Date: Fri, 11 Sep 2026 10:44:37 +0200
Message-ID: <20260911084437.1838161-9-pablo@netfilter.org>
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

Allocate the internal nf_conncount datastructure via
GFP_KERNEL_ACCOUNT.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conncount.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 4292c3d9addd..eca7a8d330ce 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -692,7 +692,7 @@ struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int keylen
 	    keylen == 0)
 		return ERR_PTR(-EINVAL);
 
-	data = kvzalloc_obj(*data);
+	data = kvzalloc_obj(*data, GFP_KERNEL_ACCOUNT);
 	if (!data)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.47.3

