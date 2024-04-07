Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315B44C7B
	for <netfilter-devel@vger.kernel.org>; Sun,  7 Apr 2024 12:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712494168; cv=none; b=uG9jgKIQjmpWuNam0lqElnoBKUBCJpOflVf3p64ZioqbtyynZiu+rNRD7OWa4KEKg5/QvUYtXnBwe8Nclthxdb69TZQYd0p2gPPpxE3BengBhFHgbY60jjK/FgNNBeHsGmUXPJwwlLuZbIu+zXBa9UMSYo2FeIkTtsa9omQ4cOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712494168; c=relaxed/simple;
	bh=9eF6yFH/2sMehy0JqGnb6ycOOWewyHjbwww0GhReaKA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=svyh08dDSkk8IZsTSBtGwIuD2figJ10fyNT3AkaD2gh+1DUPzCyeUOD+VKvvt2Oaj8u8e2svjEW8cB4vbuCH+8+nPewbEzesi0MfOaLZFCB4qGCznzp3IgYD4RVIPnNw2KvXyc9eSf4zgMiZvIZ6bBzWFNYsJrTEWohf9IiA1cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nsa5Aa1S; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nsa5Aa1S"
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-22963f0e12cso1970173fac.1
        for <netfilter-devel@vger.kernel.org>; Sun, 07 Apr 2024 05:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712494165; x=1713098965; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lyIk9l4Tswl2yGrdaBcjmE7sGcO6sOM4axMck34yF6k=;
        b=Nsa5Aa1SuHg/q8xk+KDmMkq2OJ8JxoyMnAqRKcKxj70GufIcQtfUbaTbsQrUtYlein
         2aFTa8zVR7kprRA/8333GZjzMehLfkF8t0iOTI/lK8j/hXSScZiqtgHxj3wBCckT6Gun
         XllSfu7HD0o/nw9++MXnxJ+rpuMkabfGiNKsJ0zprudVd5Wsp3u3fEblN31IR1fLv7tw
         K9Y0qOvhQP18YYY3NPINpfsUzae3ROt//VKaUMa49MJ5glpyq1UBcZmf3dZSf/lGQsDK
         gHjIToWpCGXnemimsCP3gtn4lBZpqyzXAqA59YmLCzx2QWWb9PpCj4tVSOdWpsTQDmC+
         OMGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712494165; x=1713098965;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lyIk9l4Tswl2yGrdaBcjmE7sGcO6sOM4axMck34yF6k=;
        b=tC+CEwGN6wMsFAaiMSoDJBWuGWJ5bE63Z1m72Nk6PCvc/Lz2SGQ24xRGsggQ6ipdzQ
         PsVAT7+hHrlODjtdVs+Zh0Y94E59wJVvbzYZEPKgty+mDer1SF0WoLAXFbA15oD7ZYjd
         EtifItdGAWOQbUlE4EpyfbB+82Ze6PNM8LDqGDKR8svjo4qI5mTQddB54766+yR3pvCr
         xW4Tb6d/yJQi+/ttjq1Oizgdcn5LqO0IhYkjG0PFXkOurs/0mjp+O5hKfxL0vg0NYvnn
         k4lEAmGCITLqFci3a+o2hc+VfIJLWCDqqhWdjg7gDCIYQIiVRBqwM7ZWqM6NTRnlPhDg
         s1GA==
X-Gm-Message-State: AOJu0YwWTmRittwNU4BJNRY4ebN2TRgY55JILXw6MF/Ad8FpTLCm6Rr/
	fCr9FpqsH9t+gKM16N/4EQZApIi/d6f0Z+nPUwoqd/tUXmhLW0RWl3DvQKtmHkM=
X-Google-Smtp-Source: AGHT+IH3gxFfoV+ux/huvPzQgNd2//UzQm2Dr8xdnTcaRwdTxp4UDUL0TUM1POFSMl6ThPbEW2K1uQ==
X-Received: by 2002:a05:6870:219e:b0:22a:9ba8:f5de with SMTP id l30-20020a056870219e00b0022a9ba8f5demr6460426oae.1.1712494165240;
        Sun, 07 Apr 2024 05:49:25 -0700 (PDT)
Received: from localhost.localdomain (122-151-81-38.sta.wbroadband.net.au. [122.151.81.38])
        by smtp.gmail.com with ESMTPSA id it24-20020a056a00459800b006ea81423c65sm4732644pfb.148.2024.04.07.05.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Apr 2024 05:49:24 -0700 (PDT)
From: Son Dinh <dinhtrason@gmail.com>
To: netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Cc: Son Dinh <dinhtrason@gmail.com>
Subject: [nft PATCH] dynset: avoid errouneous assert with ipv6 concat data
Date: Sun,  7 Apr 2024 22:47:54 +1000
Message-ID: <20240407124755.1456-1-dinhtrason@gmail.com>
X-Mailer: git-send-email 2.44.0.windows.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix assert bug of map dynset having ipv6 concat data

 nft add rule ip6 table-test chain-1 update @map-X { ip6 saddr : 1000::1 . 5001 }
 nft: src/netlink_linearize.c:873: netlink_gen_expr: Assertion `dreg < ctx->reg_low' failed.
 Aborted (core dumped)

The current code allocates upto 4 registers for map dynset data, but ipv6 concat
data of a dynset requires more than 4 registers, resulting in the assert in
netlink_gen_expr when generating netlink info for the dynset data.

Signed-off-by: Son Dinh <dinhtrason@gmail.com>
---
 src/netlink_linearize.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git src/netlink_linearize.c src/netlink_linearize.c
index 6204d8fd..11b4bc2d 100644
--- src/netlink_linearize.c
+++ src/netlink_linearize.c
@@ -1588,15 +1588,20 @@ static void netlink_gen_map_stmt(struct netlink_linearize_ctx *ctx,
 	struct nftnl_expr *nle;
 	int num_stmts = 0;
 	struct stmt *this;
+	int regspace = 0;
+	struct expr *expr_data = stmt->map.data;
 
 	sreg_key = get_register(ctx, stmt->map.key->key);
 	netlink_gen_expr(ctx, stmt->map.key->key, sreg_key);
 
-	sreg_data = get_register(ctx, stmt->map.data);
-	netlink_gen_expr(ctx, stmt->map.data, sreg_data);
+	/* Adjust ctx->reg_low to the real size of stmt->map.data */
+	regspace = netlink_register_space(expr_data->map->len);
+	sreg_data = ctx->reg_low;
+	ctx->reg_low += regspace;
+	netlink_gen_expr(ctx, expr_data, sreg_data);
 
+	ctx->reg_low -= regspace;
 	release_register(ctx, stmt->map.key->key);
-	release_register(ctx, stmt->map.data);
 
 	nle = alloc_nft_expr("dynset");
 	netlink_put_register(nle, NFTNL_EXPR_DYNSET_SREG_KEY, sreg_key);
-- 
2.44.0.windows.1

