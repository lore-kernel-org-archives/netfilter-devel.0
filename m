Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6A13F4100
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2026 18:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788807366; cv=none; b=Pw7NmcxaVljOyBxCi4l71Z1buxBboICWY+cIbv7knlbyjEsGxx/XLimaGehTgBuwISkAVdcEHM3Oxc6uNZd8gaQGEoZ5S7a58AmF4EvMkjjFVPa1LRF3TKox5CajsZVkn2y469WjlItdQcX70LSN8JtJPIPP8Iy+hhdkxp4pNw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788807366; c=relaxed/simple;
	bh=QOwjqLIxk4wpGIWnZLeaqkGK5ogSzXgE8GH/yfuTVz8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kN6rtlpS8ElqJDmb+Y6FxY0z5d/ZFh7nJMkVY0QakdyRAqHaWszdP1iIAGcsWo8+4VjP4juKz92MAaZqrr4Ju4wABTk2myvRFMunQyXh/4MLidSpHPVUPnFiENBEf6XdJZ8tHfelIuznWXvMoyfmujUu0uEFzVS54JqCUyQTZJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=E9R0Zz43; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="E9R0Zz43"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788807362;
	bh=7brqQakbrHBBAf4Pr+E+GaGZxn+CLj4Kb07m1TyJcNg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=E9R0Zz43jXcIpGG1o15dM/+pP+7BqhPGMuXjXj+FTBuxTPanNUgP3u2QzgaRM4MC3
	 70VtEFL6FH4In40jLCZfabm5gLxDyIN0Jbt0XnXfoCBgAYcLxW4LASSrrCYfomyA0l
	 TGzORLM9HCJnUaj6uLnAEkqkGX387kpFBFXDF4AboZDqziVGbdy6IiFS3m3hGD3Bjj
	 AGJDzEJmRNkm/1iN5VbLzPbFKT0tfZRoc00GLvfGKFsFaWs8UYUhlRnd9AgceSRCQK
	 2ANn8Atw2Mdxj214k3hNw8JpK0tbbTGadPWu7tV4++6VY8tEoSy6UIW3hARrXguOl6
	 4M5lQ3/YkMvqg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C6A9260793
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2026 20:56:02 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v3 7/8] netfilter: conncount: use GFP_KERNEL_ACCOUNT
Date: Mon,  7 Sep 2026 20:55:51 +0200
Message-ID: <20260907185552.1422008-7-pablo@netfilter.org>
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

Allocate the internal nf_conncount datastructure via
GFP_KERNEL_ACCOUNT.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: no changes

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

