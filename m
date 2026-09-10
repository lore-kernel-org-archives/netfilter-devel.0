Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DF433F5A5
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Sep 2026 08:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789029216; cv=none; b=jwKB3IxjimJfAQ7qjMcq6lYJGLbgTd/7ghVsKqJPbVL7zoDf2nAdhKfk+oHkyfja7RtML8gzrnE+aDLnc1njxo3SK/VOZx44SK/IAYK5GW65cRbFPatj9jV/1wTew1/PmLSZd+Ia63//6sARNiaDuqoUUEkWZDCZt6oFSccAbxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789029216; c=relaxed/simple;
	bh=P/YNUBHnDwhYnfFgrwq4qMj3YUiusx1D46dydg5ZQYE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M7d06UjULSkmWYvc3cqFf7I4uCRuSz9Csfjm0J3J6GPNzvWfDEck0DLjjhzJG43PPcNRydUOkjexQdMRJTf5ip1k2MJmtFnPqeuVVfauufyhvLhqQ41eaPTpf98/QCRdKpeniG0JrAENc6S6Drkgjpymua0kA4Lz3pblLE3h4pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZeZ0wi05; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZeZ0wi05"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc1cebad4afso1702452a12.0
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Sep 2026 01:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789029214; x=1789634014; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pxTKy00LI83HyYkQsjV8PxYjVMG6Lme6WBarRkbM+gw=;
        b=ZeZ0wi05baN5hjKhD4nkoO00Ez5oiBJJ4OMxaxmt9kpRYRyCX16ArHx74Rx1d4MuN2
         he7t9hHe6gLwK0O58IX48XZJl5tDeBmDN8AjRLtH/RahWgVV19VjmoUB/9pQAXoGpqMc
         K+CvuXDDlCXRHujX++C3iRUoBYjSgMtM/1v2xqXO4P9hKhJlB1aGog7TWwGSOIZEkpJj
         q6duQDVV7On3fs/eZuRAvdDI9WukbUlQ7yKxdvke381sptINisLBtxgOifytUtL5Yruu
         Tr4tVAeawkQetDlJVss03Dqvo8erTEgyWhtPPdDS8gSHVzeRfzK4h7JG+zCy2+Wi6Q/4
         VCCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789029214; x=1789634014;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pxTKy00LI83HyYkQsjV8PxYjVMG6Lme6WBarRkbM+gw=;
        b=LmBEjqCEH5L5Av0+S0nJsOfn/oK7ZA7P+57u49EwqfgxF1wVL7SIaT6c4As/b67iMI
         mGcJtvlT/HRnSyvKVStJMJhArwGj0UaWjMr2v/YWtRrCwlUur4m8USk2CCke2jMFUt9J
         oKPvkbQHQ0GnA3u8DylDg2nw3py4HPiz1q9vJanmxhC52jo2dRX1w/Qx/KsZIWWLb2k2
         EsOaEomlf4xt0ROC36GAVaf1S05cv/PCBigfqnrnrdN1VPFUYtfjqahAH9lA+mk4+I0v
         8hZaNBYHkxuM3YFpafZrKV1H3ucT0ghuLv1p3hU77cB+PYLu0aY3CC3fdRJ8u1YfNI9w
         8Rww==
X-Gm-Message-State: AFuF++mx5hqHENbapHfJvYv7sxK7Swh9ivFEY6t2Bfy0+3/VMwL1Aq/B
	sR/8ZHhmYckJhfvvH2edK/CvZ0/IZJo+um6dEMa3GNLi0j5HtcEFcenVgHNZ2A==
X-Gm-Gg: AYBFou0GfrB+vujbiFzDDcZZ61N681u9l0pdI/BjnFV8YXMUEm4Sx8dNcKy+wHhCiKB
	E4v917dQI6hltHFIvc28e7cUmHXNZFqruu7F5M55GFc/PC+GpnqEwx0sTpsa5AYmBSXsCmWDAzJ
	qan1GnvVaKYvQvqnmsj219zc/lKJIVnvv5OgZl5WNL7B5UIzjwC0dUCvFgmeLQ97ZYGJ/JWXuGv
	Z/9EKlMfPMuREoWCAz2tcQkWEc2/e9CRMSe0E7danFcN2I4/OfqBLJQVdlltujc/fHwZTVpKPY7
	L8wzGDDhaPLcCqfRh3Umd6vlVTG5PM/da2ljpW0BNxwGRbKfuTsRk+G2+kGceMaGKYcoNLDLMlz
	t23MmCv9XsP3e3sRDxmM+m7wKKcUaGVipVc73yUAAZN0PjROLKppOMd3CMDLyK+0KBaQ/fluIPn
	4+IX3ZI4ulH9B1f+WPRrcxB1bH7RKxpwpBM2SvDGWmToXWsNT2XyGVKb72/A3Ufca3KWM4ROAsM
	NbqBSESkE44EQyXhiRMU4o2dHCJjiHLZQ6D
X-Received: by 2002:a17:90b:4c42:b0:38d:fda6:4873 with SMTP id 98e67ed59e1d1-39bac1d7de5mr16175322a91.10.1789029213933;
        Thu, 10 Sep 2026 01:33:33 -0700 (PDT)
Received: from localhost.localdomain ([117.88.121.73])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d7e840f3asm3869217a91.12.2026.09.10.01.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 01:33:33 -0700 (PDT)
From: Aohan Mei <ljp1205831794@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	coreteam@netfilter.org,
	Aohan Mei <henrymei@tencent.com>,
	TencentOS Corvus AI <corvus@tencent.com>,
	stable@vger.kernel.org
Subject: [PATCH] netfilter: nft_flow_offload: drop flowtable reference on init error path
Date: Thu, 10 Sep 2026 16:33:26 +0800
Message-ID: <20260910083326.2697336-1-ljp1205831794@gmail.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Aohan Mei <henrymei@tencent.com>

nft_flow_offload_init() bumps the flowtable use count with
nft_use_inc() before calling nf_ct_netns_get().  When the latter
fails, the error is returned as-is and the reference is leaked.

The upper layers do not balance it either: nf_tables_newexpr()
clears expr->ops when the expression init callback fails, so the
nft_expr_more() iteration in nft_rule_expr_deactivate() and
nf_tables_rule_destroy() stops right before the failed expression
and its ->destroy callback, which would drop the reference, never
runs.

Each failed rule addition therefore leaks one flowtable reference
and the flowtable can no longer be removed: NFT_MSG_DELFLOWTABLE
keeps reporting -EBUSY even though no rule references it.

Save the nf_ct_netns_get() return value and undo the nft_use_inc()
when it fails, restoring the inc/dec pairing within
nft_flow_offload_init() itself.

Fixes: a3c90f7a2323 ("netfilter: nf_tables: flow offload expression")
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Cc: stable@vger.kernel.org
Assisted-by: CodeBuddy:Kimi-K3
Signed-off-by: Aohan Mei <henrymei@tencent.com>
---
 net/netfilter/nft_flow_offload.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 32b4281038dd..d3c5651dd699 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -160,6 +160,7 @@ static int nft_flow_offload_init(const struct nft_ctx *ctx,
 	struct nft_flow_offload *priv = nft_expr_priv(expr);
 	u8 genmask = nft_genmask_next(ctx->net);
 	struct nft_flowtable *flowtable;
+	int err;
 
 	if (!tb[NFTA_FLOW_TABLE_NAME])
 		return -EINVAL;
@@ -174,7 +175,11 @@ static int nft_flow_offload_init(const struct nft_ctx *ctx,
 
 	priv->flowtable = flowtable;
 
-	return nf_ct_netns_get(ctx->net, ctx->family);
+	err = nf_ct_netns_get(ctx->net, ctx->family);
+	if (err < 0)
+		nft_use_dec(&flowtable->use);
+
+	return err;
 }
 
 static void nft_flow_offload_deactivate(const struct nft_ctx *ctx,
-- 
2.43.7

