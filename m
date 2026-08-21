Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FD74BC032
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2026 14:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787323127; cv=none; b=EdxQz0Ep9Dp+XqFKevzBz+RKrLQvRSP7/0PSPBsA6fmh/TfhIiVO56JgYlyC1fHJKDqW8hm1cRdo0tjGIHzq1iPPKyeMp60I5lu9ssKvlwKON17gelLYHpA7lPr+/BEcJ+X2z2vayxbDS3PYZ/XTZunhGfitD7Ogz1/0D5GKoP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787323127; c=relaxed/simple;
	bh=iiXSUx4uQVC4M2bs6rxgqF5NQQn2RJS2IpCGhoemTP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cysCDRMzFdg/WepcKzNsXOtRk+IlcM4ELBQwyqNGehJxk1J/qFmDrOibSTsFXu/9Lan+/uqblW9rwx6E0AQvL1aK7lsDccXB3sPjLRsLtFEYstw5Appe4VBgWnclo5SgSnStMy743kxiBHu5HeSWhQeFX+u9LhWc33W9bb89TKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=VJzivP/u; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="VJzivP/u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787323124;
	bh=8WXZpFZSaGoNmI1YBiO3P9o/cFSHOTBtFml7SidZqdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VJzivP/uXRz50w3DmKekV69NV2L0Fmx8a3j5rYifTD76hKZydw4qXShW9XLUGw++r
	 07U0UpAna1iVID6D7evV9OMu4o+GhSS3p+jZ/WBE6uLB5Q/GODYqr9zAhpgv1m94Zn
	 6zYFWmRhw3Yd++lX0OMF2azaxJOxNacSOEcSXM00YdexgnkStIdua3GW/0SMPWqzk+
	 qHr/dMW62PDucxYH4LZIXDca2V/jTslMFNkZJHShhgTP503ImwGBriFXqPD8AUJ43z
	 RqgAp13ZQJn6CPinpMIb0a8DWfQaaLogyWSCr3lUQmS+V1xriGZZ6xryxHRWtcHYpb
	 S2HocrHUY8ptA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D656160093;
	Fri, 21 Aug 2026 16:38:43 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf-next 10/10] netfilter: conncount: use GFP_KERNEL_ACCOUNT
Date: Fri, 21 Aug 2026 16:38:27 +0200
Message-ID: <20260821143827.183963-10-pablo@netfilter.org>
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

