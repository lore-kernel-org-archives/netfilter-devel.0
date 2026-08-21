Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BCC4949F1
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2026 14:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787323127; cv=none; b=ml+lZ0uDUHMHjtZpLxuuBiO4uhYVaGzfOe6wUPgFUJPfriEJMoGANet1vpNTm2WMjSN0Ba6GFAiUs9fIcmsM0YDn+s3tJghMNskQmy+esnMX2V7xeQZA4u3R9Vy9wPdTQP3TCjdm108jTPHqib42tFgn4kGpNMI3pHCGyznA3+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787323127; c=relaxed/simple;
	bh=HOG7vXyP9TvbaEU2QMdlIPAbpFtfj2MeGaWqzCVnLLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=haNzoRBNirCgoYCen3o/QaribR8bHTDmfaswg31jixfyJXqeOXvnFPMbhkw5rR2y/sEdtpzPRkYca4Tz37BWL7jwneIsYSl7gjKtGzBaphPRmPpGoKsHlHi/IbNUJj0gY1455eviTkVipObgrx5I5czg2K6LEBkb1190ac1QqEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jaJVOi5g; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jaJVOi5g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787323121;
	bh=Dt+b3F30XTIFWIWCiuPKcQC6WUJb5AnyCKmdwyFNztc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jaJVOi5gweyWy8ZKyl/m36mzH2y2j9ea+jhn1cJbQUkHLmfosGIpbvP73faCIEQLk
	 hThlPGwA+0l/PDM3e2hVKN7sglXUcz4Z+SR1PBhjzeXqrjU/P/qJssp3/iID+/Gs1f
	 2lJuFofoa+1Ub0WHUb62jctJ56+c2RMY2GP+RBeYcjIaPPcwDmkRag/f5o6/BHYgGM
	 LurzoYxUeNK+L1Yurdj2lThOMgophl1dyK7c3+xzhT75qPv3J9xRXvEX2hiRSl4JTy
	 ZqN5TJ+zJNqY3lvS3udgSS0Io7E4gdnIlRZ5fuM4uxAR6Crc5zDqBxDk0sVxjn5WVA
	 pJTXjI6irkdpg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A59DD6005F;
	Fri, 21 Aug 2026 16:38:41 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf-next 08/10] netfilter: nat: use GFP_KERNEL_ACCOUNT
Date: Fri, 21 Aug 2026 16:38:25 +0200
Message-ID: <20260821143827.183963-8-pablo@netfilter.org>
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

Allocate the internal nat hook via GFP_KERNEL_ACCOUNT.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_nat_core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 8ac326e1eb5b..09cc5b8fd6af 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1204,14 +1204,15 @@ int nf_nat_register_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 	if (!nat_proto_net->nat_hook_ops) {
 		WARN_ON(nat_proto_net->users != 0);
 
-		nat_ops = kmemdup_array(orig_nat_ops, ops_count, sizeof(*orig_nat_ops), GFP_KERNEL);
+		nat_ops = kmemdup_array(orig_nat_ops, ops_count, sizeof(*orig_nat_ops),
+					GFP_KERNEL_ACCOUNT);
 		if (!nat_ops) {
 			mutex_unlock(&nf_nat_proto_mutex);
 			return -ENOMEM;
 		}
 
 		for (i = 0; i < ops_count; i++) {
-			priv = kzalloc_obj(*priv);
+			priv = kzalloc_obj(*priv, GFP_KERNEL_ACCOUNT);
 			if (priv) {
 				nat_ops[i].priv = priv;
 				continue;
-- 
2.47.3

