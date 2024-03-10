Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B9631A85
	for <netfilter-devel@vger.kernel.org>; Sun, 10 Mar 2024 17:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710091971; cv=none; b=dSQhWEr9U8d4Zp23R+NEpjiTiK+eg2IpIEbgFXKzmphhdzsF12Ira+I3H0cf+tSqqlkuMFfxGUc53/Pe7CWcBQ5qv368/zIkXD+gB4djOSgFLTSoHUFmzCF5N/LT/dano97ar87Bc02571d+oUT3oFOF4GGFNEY+5amBjmpJ2EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710091971; c=relaxed/simple;
	bh=r6ORFCj9krVKcT4JbvuZb+//j4ZeCVs/tAdW6P6Pz2o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GA+Km1Wm8FKCe0ykILqzCUtmwST6R3wrt8zDlnUCHK9zZjaHYzJSDhflDCbHVeOnez3vmDDibZI//tyf+CpjtyPrhB5xjEs5cTGC57hQMD+xMeUCXqlwsXe+4v6iG6Y7dBXmXalKREyoHY5AzzbHoj97ePivu7DSAxCkGN4aZes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NCkxBvhR; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NCkxBvhR"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1dd9066b7c3so1072915ad.2
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Mar 2024 10:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710091969; x=1710696769; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eXI5XcYM/PJjIPEua1aXDrjjG5iKugtThjjFkDo7bzk=;
        b=NCkxBvhRn7VOT0TZmlShRh65z8ezmc0SoDzC4w9QnXKr1Ojd0zr5/zRUHTet73JTLa
         AHUnV1ifN3QJ6K0ISZtQ7DcCCP+Qy6JNx/mJNFWIPGFk6DMB5vHSx6smB4R9qkedfyqN
         9otjseA4sU4oIFg/JMh8MuONOLVqh7bh8/GtiUD/kG6sNDBTOYujpAFnjKvEnxCDRA+7
         1dUR8U3xhhIl2iZy+rwFA0Ool0ycry8JFECh3bq1T364kEF3iYD1Iyf/zw6HLScFmJ76
         ZFDmJN9dkVHZly0G851NNdJvNFLfvKfqdxKbsq7wnj+m9IfW2xIAPpfUN6HNsxGTyHSv
         VWKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710091969; x=1710696769;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eXI5XcYM/PJjIPEua1aXDrjjG5iKugtThjjFkDo7bzk=;
        b=BhnQJ9QDQ7wMIHlHg97c9yPYJJL6hj/FpC+DE/sggVhqXOI7UuGb3/E2SP6ZdBf8CK
         k/KMQe9ufSkBZTxyD1xcbHbkpRJ30cKTiTN8+YxN9W8wTFSC1QO7g0oMs+9S1TR62fOt
         EDPppzma3pq/pOYMw/CJrIXZbkKM77Z2c2huwLuYVtT3T1p6/6x1lOXKQ8mLbVw5s04f
         dZV+TFu1IvTV7dK6KduwzTSwsB14qbo06C8cQ5lnRxXhwUK3wFqIgn7Rcv30pqnfms55
         /lZ0BTkv9vlyCVB9WSINZUvpJ7Zi3H+Yhl2ASEf0gIfiolAwCdWr8esnnIV2kLJRvR+6
         2bmA==
X-Gm-Message-State: AOJu0YzYkWwbLDxknoQvOFOgZGzVkKYa+kSQAKBFyWnRazEU5etidlBr
	uMhuLVSMQnDiRVEb/Zc3HvFCZLI7Prkk//tL9kZ2N+b/bpgbnT9JzaF/cH51FWvt1A==
X-Google-Smtp-Source: AGHT+IH5E5K4u3hLb9YTwb+j4N9LUgxmnoLXhltxrUZExpZm3wWW8kZo/p7aCtEKZWV99/qPjbDhvg==
X-Received: by 2002:a17:902:e992:b0:1dc:7fb4:20cb with SMTP id f18-20020a170902e99200b001dc7fb420cbmr3681848plb.62.1710091968728;
        Sun, 10 Mar 2024 10:32:48 -0700 (PDT)
Received: from localhost.localdomain (ec2-52-199-81-84.ap-northeast-1.compute.amazonaws.com. [52.199.81.84])
        by smtp.gmail.com with ESMTPSA id y15-20020a17090264cf00b001dd744f97d0sm2983618pli.273.2024.03.10.10.32.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Mar 2024 10:32:48 -0700 (PDT)
From: Quan Tian <tianquan23@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	Quan Tian <tianquan23@gmail.com>
Subject: [PATCH v2 nf-next 1/2] netfilter: nf_tables: use struct nlattr * to store userdata for nft_table
Date: Mon, 11 Mar 2024 01:28:24 +0800
Message-Id: <20240310172825.10582-1-tianquan23@gmail.com>
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
---
 include/net/netfilter/nf_tables.h | 4 +---
 net/netfilter/nf_tables_api.c     | 9 +++++----
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 510244cc0f8f..3944eb969172 100644
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
index 7e938c7397dd..de7efb8c8089 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -983,7 +983,8 @@ static int nf_tables_fill_table_info(struct sk_buff *skb, struct net *net,
 		goto nla_put_failure;
 
 	if (table->udata) {
-		if (nla_put(skb, NFTA_TABLE_USERDATA, table->udlen, table->udata))
+		if (nla_put(skb, NFTA_TABLE_USERDATA, nla_len(table->udata),
+			    nla_data(table->udata)))
 			goto nla_put_failure;
 	}
 
@@ -1386,11 +1387,11 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
 		goto err_strdup;
 
 	if (nla[NFTA_TABLE_USERDATA]) {
-		table->udata = nla_memdup(nla[NFTA_TABLE_USERDATA], GFP_KERNEL_ACCOUNT);
+		table->udata = kmemdup(nla[NFTA_TABLE_USERDATA],
+				       nla_total_size(nla_len(nla[NFTA_TABLE_USERDATA])),
+				       GFP_KERNEL_ACCOUNT);
 		if (table->udata == NULL)
 			goto err_table_udata;
-
-		table->udlen = nla_len(nla[NFTA_TABLE_USERDATA]);
 	}
 
 	err = rhltable_init(&table->chains_ht, &nft_chain_ht_params);
-- 
2.39.3 (Apple Git-145)

