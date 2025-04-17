Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61ED125334C
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Apr 2025 15:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744905004; cv=none; b=uzam5hjpyzjUvkJ91XHyXBCFmDfeFFqWiuJN7HhF7GQfF05632G5DjOXyvbehppWb68nSzAmkBlxpkdI6G2lskMZLOtF3VDSj6isEmlwbub72E2kustitdLaZAPtcJCKFCWpWbXzfFaJDmE/1VLZYXjKC7y7R99BF5qWdvacbMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744905004; c=relaxed/simple;
	bh=EZ3bqM3n5nm/s8rbpOnxOE2NBSqZLw1qPcxJINXx9mo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m8gy8LkIaOkqso+KC6fhvVxbGkMAUhy5RNvscRdE51CMWocoawBAOaEZ96UzOHVd8pXl50jPDP+ECr1A5ahBCAGU82vvGaw1mihebW7gDuUj+Q3yPSpjDkGryKZY7pO0XJVLFayASTUBVuCf3rjjwO45OrUetMgsGVFDB5vm1ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k+lH3G64; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k+lH3G64"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-22401f4d35aso12902095ad.2
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Apr 2025 08:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744905002; x=1745509802; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vD2SIxepQeq0Vwa2ltSi6JxJBjQ4SjhNMl+JFAyLuB0=;
        b=k+lH3G64fbUQxMRBizxeycX9fqhRfYE43HbjVSx4izn9QeUqNDorNp203rKNMtPoBN
         aAxMy5riKyBkDz0wyO0TwhBWvc653uvNT0qbzVGhbx+IWQE5Z/gqxrvOsJOASCFFeU1D
         b4NFrhuF1i3qAshYaL9KBeEWFTiEuQyriNNX7N3OmqcyhnPnWJUTH4JLIi0Oxt9y/+IY
         qyYNKApXclKNhNY+DrkiRPmhlOJbQxLT2Bk7dkeqAfAeUx28+QEXc/XmmWPuuAfFtIcR
         hoAqQRpStoUJvtKgBT5QRbvHdnEikBoYlnGzkZrTmlFFvEpnuZZXgahd61viZ005vChe
         k7ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744905002; x=1745509802;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vD2SIxepQeq0Vwa2ltSi6JxJBjQ4SjhNMl+JFAyLuB0=;
        b=foESqXq4mdgnj3iz8/sybsO1MDJgYrGi5wF6MVU/nw/uiWbi+1avZv3Nnbu62vJ075
         evTY8YBY/KhKKnLT6idoOYI1Oamy4Cf8zxj4G3bNrdt68QcNbhs6GKmGQd/LkTdvuRu2
         bulcB6jI2IharmzSYtdLUXdBwV/tvFUAjCHQRCv0hIR4Slf62TiwIh+pi4XKwVufDbRw
         6MBLGRwaLTY4LzxiwRw8msYdy9TW/lZ9ISMlHncyrRUiGRGjeBIUEWWC2yqDLaiqcLRG
         Cvh7G5NEJEUvsyHyu2xM1FWi9pXvrCYN1looVZmJfacUxTKDCATqpvUtcvpWZ5H9NvPH
         A7UQ==
X-Forwarded-Encrypted: i=1; AJvYcCUCBD0fgza1Uc4ufNZ8lWLiIcWuvi9p5xCK/fvZtUfUnG1FpDmo56BP2vXX/pBRIYvhLWnUn8GTyjD2KT3cL24=@vger.kernel.org
X-Gm-Message-State: AOJu0YwV8B9DMej0TxMlRiorGTyhMynyH06wR5e+FhYZkjgmYZfLc2rj
	PqSPaeoKP21fNwM6DQN/aWpwz+iCvenaqo725yrXFgfpCvwBChg8
X-Gm-Gg: ASbGncv4Jj6klzy3YiKqtnGcfDFrG+Ay07WTa7IIsSfMyRJz8AJai9xDrWxiMCSANty
	QF8LQxjXvB1h1gEN+XVU6NV55m60Z0ZG2aleX+RYtUhkvzrryyrBGzB0OkJ1fCIWWurEQr6Oii5
	688CawFZ2YbMNfmDLk2X0Qi9Idw7mqwLRo3/wq/hfFQR1VrqOZdXZoG9KefGx9Eam9lihwfxQqv
	cin8CFrhyDRC3lxTNwEjVMxJlV2bN4TRO4O2R4CUj3ixmY0igZSIj21GdvISmmfsM1V2H2kYmbY
	7iAv64NVK0IELITy5+UI2P0A
X-Google-Smtp-Source: AGHT+IGp4ulvLzJkLlCjztfY4GTzOPB5pcqOVJ/ET5+RVUk0bK7wS9brx1mmrrW2ShASQ+YtK8V7Uw==
X-Received: by 2002:a17:903:2345:b0:224:1ec0:8a0c with SMTP id d9443c01a7336-22c359114b0mr84688885ad.29.1744905002589;
        Thu, 17 Apr 2025 08:50:02 -0700 (PDT)
Received: from fire.. ([220.181.41.17])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c50bf30f3sm1531825ad.59.2025.04.17.08.49.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Apr 2025 08:50:02 -0700 (PDT)
From: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
To: coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org
Cc: Zhongqiu Duan <dzq.aishenghu0@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Simon Horman <horms@kernel.org>
Subject: [PATCH nf-next v2] netfilter: nft_quota: match correctly when the quota just depleted
Date: Thu, 17 Apr 2025 15:49:30 +0000
Message-ID: <20250417154932.314972-1-dzq.aishenghu0@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The xt_quota compares skb length with remaining quota, but the nft_quota
compares it with consumed bytes.

The xt_quota can match consumed bytes up to quota at maximum. But the
nft_quota break match when consumed bytes equal to quota.

i.e., nft_quota match consumed bytes in [0, quota - 1], not [0, quota].

Fixes: 795595f68d6c ("netfilter: nft_quota: dump consumed quota")
Signed-off-by: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
---
v2:
- Keeps the behavior of notified on the quota just exhausted.
- Convert to a more descriptive title.
v1: https://lore.kernel.org/netfilter-devel/20250410071748.248027-1-dzq.aishenghu0@gmail.com/

 net/netfilter/nft_quota.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index 9b2d7463d3d3..df0798da2329 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -19,10 +19,16 @@ struct nft_quota {
 };
 
 static inline bool nft_overquota(struct nft_quota *priv,
-				 const struct sk_buff *skb)
+				 const struct sk_buff *skb,
+				 bool *report)
 {
-	return atomic64_add_return(skb->len, priv->consumed) >=
-	       atomic64_read(&priv->quota);
+	u64 consumed = atomic64_add_return(skb->len, priv->consumed);
+	u64 quota = atomic64_read(&priv->quota);
+
+	if (report)
+		*report = consumed >= quota;
+
+	return consumed > quota;
 }
 
 static inline bool nft_quota_invert(struct nft_quota *priv)
@@ -34,7 +40,7 @@ static inline void nft_quota_do_eval(struct nft_quota *priv,
 				     struct nft_regs *regs,
 				     const struct nft_pktinfo *pkt)
 {
-	if (nft_overquota(priv, pkt->skb) ^ nft_quota_invert(priv))
+	if (nft_overquota(priv, pkt->skb, NULL) ^ nft_quota_invert(priv))
 		regs->verdict.code = NFT_BREAK;
 }
 
@@ -51,13 +57,13 @@ static void nft_quota_obj_eval(struct nft_object *obj,
 			       const struct nft_pktinfo *pkt)
 {
 	struct nft_quota *priv = nft_obj_data(obj);
-	bool overquota;
+	bool overquota, report;
 
-	overquota = nft_overquota(priv, pkt->skb);
+	overquota = nft_overquota(priv, pkt->skb, &report);
 	if (overquota ^ nft_quota_invert(priv))
 		regs->verdict.code = NFT_BREAK;
 
-	if (overquota &&
+	if (report &&
 	    !test_and_set_bit(NFT_QUOTA_DEPLETED_BIT, &priv->flags))
 		nft_obj_notify(nft_net(pkt), obj->key.table, obj, 0, 0,
 			       NFT_MSG_NEWOBJ, 0, nft_pf(pkt), 0, GFP_ATOMIC);
-- 
2.43.0

