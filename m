Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A24447A860
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 11:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785325798; cv=none; b=WiIKVdHkjwUf8PGniBL6Sz+cAM96EKSYWlwPHfFYC7cuj3aJxUhFrJpHacnSJ/RKH2R0qyqSwxhZLDe1sPhp2KC8LfZMvpvDR1E6xco0e5hcmWmyzRjo863jiVAzilV9v91bXlkndeT8gsrQEU472h7f2GMF4z7oJPZfIo9tzns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785325798; c=relaxed/simple;
	bh=cIi33l4fHu/+rZVgmE8BNbtJrQxCurLZ3iXnW0fbZWU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nacJCkBEI4groqafW5Cmbi8BF5c2148xxzAr02Dh0OQWELv+YmM1TYDlRyhdoEbNxaFmEXPIcpyT6PbQKpACRDcP7yDvb47MHjBqRq7xy6Y+vxRva3vGB5pNzp40XS//4JtzO8sh+39ugucAk2knOKg+TsB+3BNh8M6kghDTpQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=GdglMMNm; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="GdglMMNm"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B2A926019D
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 13:49:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785325795;
	bh=UjgQI0oR7MVN46Rpjf0zqM1eM70EAvucMpT+J89DkOY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=GdglMMNmX+doxfOaAjp8AaLQDc+aRUu6ruXNJQ5fT2Ijm8XbgIkdQHGfHM3Gjd4Rl
	 mnKfyYHebU30jJGtQnkrL/STD/JhbvCokyS74AN9UTV2qUeFxX6cyGJB59VQ3z/z2X
	 CsnRH6m8gMsMp3qE+UK9KZceA7xATBjCNbdHBEvu02x6eycwxCJxTdJVKrawN9MDd0
	 6/zEHUXnoOZ71X8QslnZJ1Nd5RMHg1koWckPOiH/pXLEZJ1slHtJgEcqv2XxTbHKYp
	 Ei2BzpQQzZCJ0bk6Eunr8lTnTYavQy346h7Asj2KxcdlZWN8Td9/5eAm4n0vWc/cB5
	 5qxm/77zAIuRw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v5 4/6] net: do not advance stack index from dev_fwd_path()
Date: Wed, 29 Jul 2026 13:49:45 +0200
Message-ID: <20260729114947.403782-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729114947.403782-1-pablo@netfilter.org>
References: <20260729114947.403782-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update stack index from dev_fill_forward_path() instead, once the
forward path slot has been populated.

Adjust existing drivers that recycle dev_fill_forward_path() as a
way to reach the mtk SoC WDMA info.

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v5: no changes

 net/core/dev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index c1c1be1a6962..429a55fff667 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -742,12 +742,10 @@ EXPORT_SYMBOL_GPL(dev_fill_metadata_dst);
 
 static struct net_device_path *dev_fwd_path(struct net_device_path_stack *stack)
 {
-	int k = stack->num_paths++;
-
-	if (k >= NET_DEVICE_PATH_STACK_MAX)
+	if (stack->num_paths + 1 > NET_DEVICE_PATH_STACK_MAX)
 		return NULL;
 
-	return &stack->path[k];
+	return &stack->path[stack->num_paths];
 }
 
 int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
@@ -773,6 +771,7 @@ int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 		if (ret < 0)
 			return -1;
 
+		stack->num_paths++;
 		if (WARN_ON_ONCE(last_dev == ctx.dev))
 			return -1;
 	}
@@ -785,6 +784,7 @@ int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 		return -1;
 	path->type = DEV_PATH_ETHERNET;
 	path->dev = ctx.dev;
+	stack->num_paths++;
 
 	return ret;
 }
-- 
2.47.3

