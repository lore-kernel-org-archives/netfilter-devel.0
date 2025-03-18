Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC3D1EFFA8;
	Tue, 18 Mar 2025 22:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742336130; cv=none; b=sv+1+sv05dJ3IM7nrNUffnQX4r9u1XM6Y8wo3ec4QwmGCTnT8ykeiREWn4GAkQJCzQyzvMKHbPx02N2/JAFCPo01+1dFTmGGVl1zBdHYUkU/bDLQTz8xXZUHGfOt/LPGB1MrwAVWYq3xwmSIgmV4Cx5KgnT/npr5rYbzJ51fPeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742336130; c=relaxed/simple;
	bh=mB/qWvUTY+zfbp58jnvXkbeHoBpnNulbkareUIugrZ4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T1mhaH0gmhTac1WWYgXvItZYbgSCaUckjhSe7R4g4s9FBeBuTss5bOOGfKpCfq70C+NoKRR+s23Dzr9sp+eyfKdtZJnlhlVrm+Q3gZwU+0s/Xv+WUQ9im6+fyV/AsH6IlBcZ3PPLCahg9KIACMq3gNw5DQmtnBoZ8hETRxbRnR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OkykfPI7; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OkykfPI7; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OkykfPI7";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OkykfPI7"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C4F50605B0; Tue, 18 Mar 2025 23:15:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742336127;
	bh=/zeW+gbMvLFqgL4aGU1AKu5qlVcs2X3i1+X41mknfl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OkykfPI7bbnS0WAIcUqDo5JB4bYHZv+yYvDFrv49+MQFSdS5nS17yAnGgNwog+Iot
	 imFGanYQ6ZeOz7ZrcG7rzl7Vy79Qv2xVLAHCqkwOrV3W5bwmokJzA3Zl+t0vipAuvM
	 8iJDWu2USsoG1txuVIthxvlGe/yUXe1vjXvs7EGnzRcUfkyppOfM82Exp+dpUyWmHl
	 52J3LXLYAhVBrTDS5s8CN5UE/i0zg/WbBKSi5TbIm3gZUrtVy9S/9Bv0/Zw6fzel3l
	 Hr5WuJw/xs33axtZFzEY/u/HNqD5M8F+yDYl4HnLRJrho8c/cnuw2N0TtxY8nz2J/b
	 sBrCbdS37s3gA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 18DF5605A1;
	Tue, 18 Mar 2025 23:15:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742336127;
	bh=/zeW+gbMvLFqgL4aGU1AKu5qlVcs2X3i1+X41mknfl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OkykfPI7bbnS0WAIcUqDo5JB4bYHZv+yYvDFrv49+MQFSdS5nS17yAnGgNwog+Iot
	 imFGanYQ6ZeOz7ZrcG7rzl7Vy79Qv2xVLAHCqkwOrV3W5bwmokJzA3Zl+t0vipAuvM
	 8iJDWu2USsoG1txuVIthxvlGe/yUXe1vjXvs7EGnzRcUfkyppOfM82Exp+dpUyWmHl
	 52J3LXLYAhVBrTDS5s8CN5UE/i0zg/WbBKSi5TbIm3gZUrtVy9S/9Bv0/Zw6fzel3l
	 Hr5WuJw/xs33axtZFzEY/u/HNqD5M8F+yDYl4HnLRJrho8c/cnuw2N0TtxY8nz2J/b
	 sBrCbdS37s3gA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,6.6 v2 1/2] netfilter: nf_tables: bail out if stateful expression provides no .clone
Date: Tue, 18 Mar 2025 23:15:21 +0100
Message-Id: <20250318221522.225942-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250318221522.225942-1-pablo@netfilter.org>
References: <20250318221522.225942-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 3c13725f43dcf43ad8a9bcd6a9f12add19a8f93e upstream.

All existing NFT_EXPR_STATEFUL provide a .clone interface, remove
fallback to copy content of stateful expression since this is never
exercised and bail out if .clone interface is not defined.

Stable-dep-of: fa23e0d4b756 ("netfilter: nf_tables: allow clone callbacks to sleep")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index bf24c63aff7b..a85f5e0cc9d1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3336,14 +3336,13 @@ int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src)
 {
 	int err;
 
-	if (src->ops->clone) {
-		dst->ops = src->ops;
-		err = src->ops->clone(dst, src);
-		if (err < 0)
-			return err;
-	} else {
-		memcpy(dst, src, src->ops->size);
-	}
+	if (WARN_ON_ONCE(!src->ops->clone))
+		return -EINVAL;
+
+	dst->ops = src->ops;
+	err = src->ops->clone(dst, src);
+	if (err < 0)
+		return err;
 
 	__module_get(src->ops->type->owner);
 
-- 
2.30.2

