Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE8C13E7D8
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Mar 2024 17:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709745866; cv=none; b=aYsvwcj/bQOQJnUSYCiQ8lYQdW4PHqHvort6kC5BVtZ4gJWveFTCRONkBuLBqsXeg7aStkj9Q8EaX4qmyTEAbM/Ekz3KRggvGDaqrAdIQWg+obOl4I0omr5mmmUoXfnxJqz4T/JXqcvqr7NCHNpEb5H8WSUcs9X1Y4qeywyU/dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709745866; c=relaxed/simple;
	bh=Nj0t00gmdOi16cHqYSLaqWjOOgFbe2TbjxWpdUEv81I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qo1ZWvnshxfYXjOuhNQw+zktkcINhe4GP04DAdnMyxisUaMahn6ib1flVQAQAsa8M/7unn0J+qbf1sSdTX8dJgRbRcEL/eJs4CCUEv/Hv8g7VhCwch2am42V2sU48nfp3gPCYVEE/B0aESJWi7p5SLg0+oRPb+1qI/VdWtzUJIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c2P4htRL; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c2P4htRL"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6e64997a934so1006015b3a.0
        for <netfilter-devel@vger.kernel.org>; Wed, 06 Mar 2024 09:24:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709745863; x=1710350663; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VS0x2IKk7gIVXL1nWoGzE9d19xhJdP60jy9ecxEa2us=;
        b=c2P4htRLO/I4em9NQXWZueQSzETfPLOoGd+dCc+/AS1y9b/LmapIinzzVm4ldFL90F
         ZesxjOZkjdbvVtG3ue7vYSNcdqK01NO7agCNFsBF6JMztz5bJO60dMrgti6aTJketjcX
         1elcLVHNKnbQlI9PSGrLXTeURJWeW12EbHVkMZPRvIvKQ/I53VytX2Dtl/+DX7/CVYhs
         XhwBmjiofcsCdvFelCFhRmXs24YB2+XWqtXI/iWoUNeuXygBFiDqgZjmFAi8HPj60bab
         R5W+G3o46w5y6Hpg9N/TnQu/A+p7vv7XG8Mn5UK2SxGkphYyX/uB/4BGx+Otviy+fZFo
         recg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709745863; x=1710350663;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VS0x2IKk7gIVXL1nWoGzE9d19xhJdP60jy9ecxEa2us=;
        b=FZ7UksGNBXtWeyd9xq3B48m7J6oPYVH9IWlA7iFdW2hQUn0YPlZw09E5ykgchUYaDe
         gfUd5fmGBa6pQRB97I62zeQnnU8NvDPvyJjgal/UkzsqJaLHvKKnTqIxaXUbTJ5PBomS
         jJWs78nFcLFVwpUYgcTuhTp0Buy60D2JDJSwKPUCOMEbgqgJEBf4RhweQlAVGTShMBwV
         Eqea4T5DJ4zfORmG7xcFaIsyGRHFKqcjgDDpmDO1jhgupG1/8QOiF3dvVyXEh3gChmvF
         PBeY4Krt0xSufPw6pjIqhZ9mEai+XATv8viosf/yJ+M8jbL/cijOnLuTXbiVhpQwCf+C
         6/sw==
X-Gm-Message-State: AOJu0YxBw2N6ObH6rmRMWyKzHjKx4+Zcfqj6uD7igZGaoPEdNZqgHUcA
	8Qcmrm57kwdz0bld3oMKzYQbE3MMPgdeopI8WFbjWIXdLEKIAYA7YwdTC9k8z4ZjhBVK
X-Google-Smtp-Source: AGHT+IF6jbYyb9rj9hn1Ly9WfV+N1OIuhEF6h1SxgexwVwZurgCsBtELflOQoyZYf7GeCVol3m69nA==
X-Received: by 2002:a05:6a20:7485:b0:1a1:6ceb:92fc with SMTP id p5-20020a056a20748500b001a16ceb92fcmr710233pzd.6.1709745862954;
        Wed, 06 Mar 2024 09:24:22 -0800 (PST)
Received: from localhost.localdomain (ec2-52-199-81-84.ap-northeast-1.compute.amazonaws.com. [52.199.81.84])
        by smtp.gmail.com with ESMTPSA id q19-20020a170902e31300b001dc23e877c0sm12876730plc.255.2024.03.06.09.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Mar 2024 09:24:22 -0800 (PST)
From: Quan Tian <tianquan23@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Quan Tian <tianquan23@gmail.com>
Subject: [PATCH net] netfilter: nf_tables: Fix a memory leak in nf_tables_updchain
Date: Thu,  7 Mar 2024 01:24:02 +0800
Message-Id: <20240306172402.11966-1-tianquan23@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If nft_netdev_register_hooks() fails, the memory associated with
nft_stats is not freed, causing a memory leak.

This patch fixes it by moving nft_stats_alloc() down after
nft_netdev_register_hooks() succeeds.

Fixes: b9703ed44ffb ("netfilter: nf_tables: support for adding new devices to an existing netdev chain")
Signed-off-by: Quan Tian <tianquan23@gmail.com>
---
 net/netfilter/nf_tables_api.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7e938c7397dd..807ea8e4bcc6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2619,19 +2619,6 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 		}
 	}
 
-	if (nla[NFTA_CHAIN_COUNTERS]) {
-		if (!nft_is_base_chain(chain)) {
-			err = -EOPNOTSUPP;
-			goto err_hooks;
-		}
-
-		stats = nft_stats_alloc(nla[NFTA_CHAIN_COUNTERS]);
-		if (IS_ERR(stats)) {
-			err = PTR_ERR(stats);
-			goto err_hooks;
-		}
-	}
-
 	if (!(table->flags & NFT_TABLE_F_DORMANT) &&
 	    nft_is_base_chain(chain) &&
 	    !list_empty(&hook.list)) {
@@ -2646,6 +2633,20 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 	}
 
 	unregister = true;
+
+	if (nla[NFTA_CHAIN_COUNTERS]) {
+		if (!nft_is_base_chain(chain)) {
+			err = -EOPNOTSUPP;
+			goto err_hooks;
+		}
+
+		stats = nft_stats_alloc(nla[NFTA_CHAIN_COUNTERS]);
+		if (IS_ERR(stats)) {
+			err = PTR_ERR(stats);
+			goto err_hooks;
+		}
+	}
+
 	err = -ENOMEM;
 	trans = nft_trans_alloc(ctx, NFT_MSG_NEWCHAIN,
 				sizeof(struct nft_trans_chain));
-- 
2.39.3 (Apple Git-145)

