Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E290E47A40
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Mar 2024 16:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710346118; cv=none; b=V/x3cVfsUZ3JiOPy/l/H4fR3fGoSLbnkOrOOp6MP7LU3109G3Mx3Z68JNwot841CYmonIadPecHtCg7YJPFuQFCOdjQVq2SvlNxzG/1eCciFPFMgy9di3Cme7pBKEDjLYBMsOuMF7CzVNaHMQzslS5Uu05B7GdQF6XTU53o7ZTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710346118; c=relaxed/simple;
	bh=/Y7Op3Qge0eG/9WBl623crOMwxsKg/hFyC8rtDHsi5w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ShURsQYA7XsJZD+wzMZuMn5H8KWKSSNAcK1VH2fwtEvN8mni8Kqu7fNMuuAUSQv/Ki3C7HrA/Dcv4SznwlQhJ5HNoD4aekR9KxCcfpOxprYnJSUbwkxkAaubuUUkJkU3DWMxw+4UZC6htO2nbhOFThDTzVyrF4gU5HTKntRZY2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GxYi0cIo; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GxYi0cIo"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6e6b6e000a4so60302b3a.0
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Mar 2024 09:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710346115; x=1710950915; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4JExWpcQFaM58SsMjepG9sy8mpdmCA8joU1uTh2zAYU=;
        b=GxYi0cIoR3tG5Zw6q7eTvxCwd7/X5dCp278onEgOfT59JP2479kofOv0n4FYH9TpYu
         X+J49NKdLt/CQcwtqV7mC8hijKHz3skbBZ41WNFdFGw+/QETjfkyJgKQMb3I1j/ZolyK
         bpw3ZB18CszNAX3PWU7Itwd+O7sIRHYcgzyBYlIkyMam/LGb0B1QSrXXgKFizqfVmFbW
         609t83TXWnWWXS+1q1igwf3HbcjOWj0OiW4QnwWEV2lcmEZdCJe+q6zdqfeJsGJh1Nmk
         AL8gQxHEd4P8Cj4jfrW0iHda0fcbpJe8cRxNroNXuzoF2s9X4gxNtsHMualX319X5HUD
         xg8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710346115; x=1710950915;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4JExWpcQFaM58SsMjepG9sy8mpdmCA8joU1uTh2zAYU=;
        b=QEdIygDILJ4gAoys4/sgSfrkvubvV1wXYrNrcPq9Z8xYBQ3wXs97glq/zVHKhG/9q/
         g36qEE3JsIw9nHSIz0U7aZvJR9PdFzGFfxQ0jEDv90UoJ4h57qDZfdV2R2VI3LqTsIju
         zlhq4qn9g417brWpGQcY0S7Vg1O5e6iPWO/ibcORHLjIvDsROEEQB3vwDNBy242Ybvjw
         iEJOH3Q0krS+UccI3hP5okYuJf59lMXY2zn11gfa4MIat4XGC3lODZ5bCv2PlA4gO5xk
         VDnGsxknb6pLDHQh4vGvJzMZKrADuWs8nSdfA1FYOwt4TPICmO1S3nad0MNA0XQkGVin
         RnUw==
X-Gm-Message-State: AOJu0YxmgIh987gxIR7y3ouexHJbuV+/WE93+An0Hzm94aDTWWVkVhc6
	xJJ7Oo15yi1xHQ6Ehbfl4D5klYGsf1JVMQubJNHTC1Ii9R6whe/vTwsRomUK8ezRflMR
X-Google-Smtp-Source: AGHT+IEhzOl3chC1khxG2e90jzrXzjwzsnPPDWMJbSetMY4+o1wHBga4rAuc/XuvPMrT8Hz8aea0cg==
X-Received: by 2002:a05:6a00:2349:b0:6e6:9788:61d with SMTP id j9-20020a056a00234900b006e69788061dmr3963162pfj.17.1710346115357;
        Wed, 13 Mar 2024 09:08:35 -0700 (PDT)
Received: from localhost.localdomain (ec2-52-199-81-84.ap-northeast-1.compute.amazonaws.com. [52.199.81.84])
        by smtp.gmail.com with ESMTPSA id o74-20020a62cd4d000000b006e6b5533308sm1798912pfg.25.2024.03.13.09.08.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Mar 2024 09:08:34 -0700 (PDT)
From: Quan Tian <tianquan23@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	Quan Tian <tianquan23@gmail.com>
Subject: [PATCH nf] netfilter: nf_tables: fix consistent table updates being rejected
Date: Thu, 14 Mar 2024 00:08:18 +0800
Message-Id: <20240313160818.69602-1-tianquan23@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Updating a table with the same flags more than once in single
transaction failed if its previous flags is different from the new one.

For example, the 2nd transaction below would fail:

nft -f -<<EOF
add table ip t { flags dormant ; }
EOF

nft -f -<<EOF
add table ip t
add chain ip t c1 { type filter hook input priority 1; }
add table ip t
add chain ip t c2 { type filter hook input priority 2; }
EOF

This was because nf_tables_updtable rejected all further updates made
to a table after it was updated once, even though they are consistent
with the first update.

The intent of the check should be to reject dormant off/on/off games,
the patch fixes the check to allow consitent updates.

Fixes: c9bd26513b3a ("netfilter: nf_tables: disable toggling dormant table state more than once")
Signed-off-by: Quan Tian <tianquan23@gmail.com>
---
 net/netfilter/nf_tables_api.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e93f905e60b6..8bad5dd427da 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1225,24 +1225,25 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 	if ((flags ^ ctx->table->flags) & NFT_TABLE_F_PERSIST)
 		return -EOPNOTSUPP;
 
-	/* No dormant off/on/off/on games in single transaction */
-	if (ctx->table->flags & __NFT_TABLE_F_UPDATE)
-		return -EINVAL;
-
 	trans = nft_trans_alloc(ctx, NFT_MSG_NEWTABLE,
 				sizeof(struct nft_trans_table));
 	if (trans == NULL)
 		return -ENOMEM;
 
+	ret = -EINVAL;
 	if ((flags & NFT_TABLE_F_DORMANT) &&
 	    !(ctx->table->flags & NFT_TABLE_F_DORMANT)) {
-		ctx->table->flags |= NFT_TABLE_F_DORMANT;
-		if (!(ctx->table->flags & __NFT_TABLE_F_UPDATE))
-			ctx->table->flags |= __NFT_TABLE_F_WAS_AWAKEN;
+		/* No dormant on/off/on games in single transaction */
+		if (ctx->table->flags & __NFT_TABLE_F_WAS_DORMANT)
+			goto err_flags;
+		ctx->table->flags |= NFT_TABLE_F_DORMANT | __NFT_TABLE_F_WAS_AWAKEN;
 	} else if (!(flags & NFT_TABLE_F_DORMANT) &&
 		   ctx->table->flags & NFT_TABLE_F_DORMANT) {
+		/* No dormant off/on/off games in single transaction */
+		if (ctx->table->flags & __NFT_TABLE_F_WAS_AWAKEN)
+			goto err_flags;
 		ctx->table->flags &= ~NFT_TABLE_F_DORMANT;
-		if (!(ctx->table->flags & __NFT_TABLE_F_UPDATE)) {
+		if (!(ctx->table->flags & __NFT_TABLE_F_WAS_DORMANT)) {
 			ret = nf_tables_table_enable(ctx->net, ctx->table);
 			if (ret < 0)
 				goto err_register_hooks;
@@ -1265,6 +1266,7 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 
 err_register_hooks:
 	ctx->table->flags |= NFT_TABLE_F_DORMANT;
+err_flags:
 	nft_trans_destroy(trans);
 	return ret;
 }
-- 
2.39.3 (Apple Git-145)

