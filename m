Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0E83FB8E
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Mar 2024 14:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710166516; cv=none; b=JKbGmVAFHd9iECGlC1WcZUg0W3/3LZT/4fcaZpmkE6NnaAKQjZb2RK9RwdlzmeLs6ncC0V7K6eAyB1XypcwSFs+PhlVZ0HdrwxZPFOWPElvE2c+8MWvj7na58NLij2Cz4ZUQxirMUcb/3/jFBLM9loCqWdt08rougOp0LejJv/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710166516; c=relaxed/simple;
	bh=M2iDWlFDVBBQKl4DRm6cpRs8S4lrKfo4CxXIXH1hvMY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aqd7tlHV/eLwK2sXuODumxtM03ILkOqnbsb3zGX/Mf0pmOoEPj3jKRqRcMCVrzyNMwbqhmCdlVhyvuBwf5piJ70h9mHs+HXLGk/HBo4ys/NFRnPS3yGJJfMay9TPmmkqs5A/EDiUTXtvPIkEftzYN85JNYiTwVnayPe8Uvl1+GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CGcp/XE5; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CGcp/XE5"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6e64997a934so3403344b3a.0
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Mar 2024 07:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710166514; x=1710771314; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=O83dn/npEzg+4UFsPaFoOVIQju5+66C547b5i7OkLxw=;
        b=CGcp/XE539ANOYi1DZ+R9g4R2P23qgqdkZBLckoU35sxC+dFRkpRde1JgMgSlwBKEc
         m1AZAawzjWWGrHNOcpretNHv6lBDE9rgTE+lQCixqi2cWEoV9oD/CNB0y1rel60NlckF
         NbR3np9/zB32OopJpYLzLuNnx6vVzWR/p7AD7lvMgC2ZPisH2EcZPMJiehiIsmeU0B6B
         ypNuKWEx89F8DrPYEYX09Se/qjRFkpZ6uEwNpJ36AebWDTSfdM2m7flcFVoEr/oBmhtq
         ZER8kg8/hKZ1clkSY076B8MYExQ4ia1wUKXFygEcV3zFAaQQ2P8VtfRCA8HfKXRuDo91
         gdgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710166514; x=1710771314;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O83dn/npEzg+4UFsPaFoOVIQju5+66C547b5i7OkLxw=;
        b=Hu0UWvfDRasv4dJX7js7GL1KjtISbGJGKu5297awNe6B1ljVHfIkDr4ZUFnx3QU9ye
         kUCf07UWIelvXMAroxnL2wxr8ttMMo5fV0EFaPkO0EaIjmfMK8ht6/jox6Q4KsAHN6qE
         DkBtmhjrzARZiNn7dmIAr54ViqH7CtkeF0PxGS9ubNtcWQ7GbjXeeiKbij795FXKtcsm
         DNwGFpfXjhFb42T7ysijJHnGHlfjgzWPeEAq7rNQa649rqvllktWrQk6i/5cy3jm/Viy
         /6NhDFftGLVn6tcVjR2IP3FQRl4+E5aWcu2xtxHaJVFWvc2Zw0sOWY0Yp1bwcW7XNJru
         mBYA==
X-Gm-Message-State: AOJu0YwSKJvqgnOflGl9ha5VXiRI3RuDUo5WX82cAzIshWyEDwuCy9jg
	l3Exl4VY3VnvjwFjMBAffC929fcKZ73Pjgv53gaGg3Q2zg1/yD0K1dWLQMNAj6JBwZPE
X-Google-Smtp-Source: AGHT+IGhrNShwLnOFLm+bSl8sPYYm982OY28Ly/SxI+t3lBTSkbCMoFP1iW6s5OSZgNPQ5D/5+yXlw==
X-Received: by 2002:a05:6a20:da86:b0:1a1:3ecb:52ff with SMTP id iy6-20020a056a20da8600b001a13ecb52ffmr609869pzb.0.1710166513647;
        Mon, 11 Mar 2024 07:15:13 -0700 (PDT)
Received: from localhost.localdomain (ec2-52-199-81-84.ap-northeast-1.compute.amazonaws.com. [52.199.81.84])
        by smtp.gmail.com with ESMTPSA id k12-20020aa7998c000000b006e632025bcdsm4378366pfh.138.2024.03.11.07.15.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Mar 2024 07:15:13 -0700 (PDT)
From: Quan Tian <tianquan23@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	Quan Tian <tianquan23@gmail.com>
Subject: [PATCH v3 nf-next 1/2] netfilter: nf_tables: use struct nlattr * to store userdata for nft_table
Date: Mon, 11 Mar 2024 22:14:53 +0800
Message-Id: <20240311141454.31537-1-tianquan23@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To prepare for the support for table comment updates, the patch changes
to store userdata in struct nlattr *, which can be updated atomically on
updates.

Signed-off-by: Quan Tian <tianquan23@gmail.com>
---
 v2: Change to store userdata in struct nlattr * to ensure atomical update
 v3: Extract a helper function to duplicate userdata

 include/net/netfilter/nf_tables.h |  4 +---
 net/netfilter/nf_tables_api.c     | 13 +++++++++----
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index e27c28b612e4..144dc469ebf8 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1248,7 +1248,6 @@ static inline void nft_use_inc_restore(u32 *use)
  *	@genmask: generation mask
  *	@nlpid: netlink port ID
  *	@name: name of the table
- *	@udlen: length of the user data
  *	@udata: user data
  *	@validate_state: internal, set when transaction adds jumps
  */
@@ -1267,8 +1266,7 @@ struct nft_table {
 					genmask:2;
 	u32				nlpid;
 	char				*name;
-	u16				udlen;
-	u8				*udata;
+	struct nlattr			*udata;
 	u8				validate_state;
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 224e5fb6a916..85088297dd0d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -183,6 +183,11 @@ static void nft_trans_destroy(struct nft_trans *trans)
 	kfree(trans);
 }
 
+static struct nlattr *nft_userdata_dup(const struct nlattr *udata, gfp_t gfp)
+{
+	return kmemdup(udata, nla_total_size(nla_len(udata)), gfp);
+}
+
 static void __nft_set_trans_bind(const struct nft_ctx *ctx, struct nft_set *set,
 				 bool bind)
 {
@@ -983,7 +988,8 @@ static int nf_tables_fill_table_info(struct sk_buff *skb, struct net *net,
 		goto nla_put_failure;
 
 	if (table->udata) {
-		if (nla_put(skb, NFTA_TABLE_USERDATA, table->udlen, table->udata))
+		if (nla_put(skb, NFTA_TABLE_USERDATA, nla_len(table->udata),
+			    nla_data(table->udata)))
 			goto nla_put_failure;
 	}
 
@@ -1398,11 +1404,10 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
 		goto err_strdup;
 
 	if (nla[NFTA_TABLE_USERDATA]) {
-		table->udata = nla_memdup(nla[NFTA_TABLE_USERDATA], GFP_KERNEL_ACCOUNT);
+		table->udata = nft_userdata_dup(nla[NFTA_TABLE_USERDATA],
+						GFP_KERNEL_ACCOUNT);
 		if (table->udata == NULL)
 			goto err_table_udata;
-
-		table->udlen = nla_len(nla[NFTA_TABLE_USERDATA]);
 	}
 
 	err = rhltable_init(&table->chains_ht, &nft_chain_ht_params);
-- 
2.39.3 (Apple Git-145)

