Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E3F31A85
	for <netfilter-devel@vger.kernel.org>; Sun, 10 Mar 2024 17:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710091974; cv=none; b=kc+gGl7KnNa2J/O11u0bmr4ZdrSHlrAeTc6M3yDJ080lqVTQjh9lybH9xOifqV0UDaV7lA7f73kOj0FxJ0QVRICXa80VLuQ1gOs1Tf5D79e+jhVYsshU3gkdemGA3AtnVNC9YcUm+JzjufF+g+Dk5/DTiz5z0pyVS4sNGDugLHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710091974; c=relaxed/simple;
	bh=Y1/1OFqf0Y7icqhr2GHHZLF020J/nGIdIS+c2vEkUKw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BJnnQuxEQSLnW9ITG2uV4WFwsSVoU/EXdWbAMO1pPH0E0zI65Y407HVXs6CufQAz5bdDV9+N6yDcAbOnXx0uBSupo47DXSGRd3FSXhl2m8VWedlKpnNwSi0TqdfldSU5xlWkR+901MeleeRrFDNz82zU/P8mKroKt0CQZnHXI+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B90gbFCW; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B90gbFCW"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6e55731af5cso1559602b3a.0
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Mar 2024 10:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710091971; x=1710696771; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pswn79OldIPU0Tx3PEzreHnP2Njuk76SxnAPyOIG3n8=;
        b=B90gbFCW5CoO4zNgEcfTANPqw+07AMPvfeh1Nsz8jl/VYFNT+jv3W2abCLM4brzxXn
         QpHkXsqJnjq7iFvvWNiJVozrbEDrFXUdKZB/C7ocfmEXgiiSOFnzU4qOs5THIbyEug1Y
         qWczxeRthhamC4XTb3C0l2rRVchepcDRkKFjfV8YyFTN6idvUpo7VuqkhtCV3mATK93D
         ubWv3w2n39wZBLyA3UEWiHlcOTpNOjR71iaZN1okbDN8Y+rGnd/z043T5MZeDXudEn0h
         tQY9YD/XLuBFW3Z4O/EB/5Wevt5ItUtJPbYNC/EnbQffwn+4BzNpGzK/9mHB/twCIRpj
         Q0gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710091971; x=1710696771;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pswn79OldIPU0Tx3PEzreHnP2Njuk76SxnAPyOIG3n8=;
        b=Wp92AJy+chJpG2CdnT/Vxb9Iz81iRn6oWh2IpS7Q08uMKI1k7srqSeRQPOQHjmOrTT
         PzU5op+Rys1m+M62gr+EPdzJ824FnTp9BNudR//vgca1O5Lxoc7xwX205fA+eaXL7KBC
         rlScw00+MmrGqlWMgkfYXiduwoXnPIHkaChPwCXs9siBnFRp7YjOaGPltsmKwfRN887r
         5P0SzLv838M3XUaXFnolr3x2X63itjgqZm+geeXdVHkBl5pEUCfhBBk/xMUSp+mVgHzG
         1q0I7Hd/5fqBTTaIDAKAB1LEmGAXBgDVp4fK6rmmFDQtBz22HT+AfIJmYwz5eBAhDiVU
         dzKQ==
X-Gm-Message-State: AOJu0Yzx7z93cLv3rC8DO5frLVzIMVL0bugtI4+jTKNYpieDFmIAlAs6
	F4gZ69Kv6DjCJf7LMHQMlRHl6HVXXgFZnAVaHts9mV6EWsjEfm5bmhE51sQ4n32Zgw==
X-Google-Smtp-Source: AGHT+IHlIh7IoUZ/FKMyLZqVUXovYeAEOYNjGHsFCmZQCTyOA+F7b44wRw11zdUBt2ItxzWY0n/1XA==
X-Received: by 2002:a05:6a20:4394:b0:1a1:72aa:11b0 with SMTP id i20-20020a056a20439400b001a172aa11b0mr3169809pzl.32.1710091971262;
        Sun, 10 Mar 2024 10:32:51 -0700 (PDT)
Received: from localhost.localdomain (ec2-52-199-81-84.ap-northeast-1.compute.amazonaws.com. [52.199.81.84])
        by smtp.gmail.com with ESMTPSA id y15-20020a17090264cf00b001dd744f97d0sm2983618pli.273.2024.03.10.10.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Mar 2024 10:32:50 -0700 (PDT)
From: Quan Tian <tianquan23@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	Quan Tian <tianquan23@gmail.com>
Subject: [PATCH v2 nf-next 2/2] netfilter: nf_tables: support updating userdata for nft_table
Date: Mon, 11 Mar 2024 01:28:25 +0800
Message-Id: <20240310172825.10582-2-tianquan23@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
In-Reply-To: <20240310172825.10582-1-tianquan23@gmail.com>
References: <20240310172825.10582-1-tianquan23@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The NFTA_TABLE_USERDATA attribute was ignored on updates. The patch adds
handling for it to support table comment updates.

Signed-off-by: Quan Tian <tianquan23@gmail.com>
---
v2: Change to store userdata in struct nlattr * to ensure atomical update
---
 include/net/netfilter/nf_tables.h |  3 ++
 net/netfilter/nf_tables_api.c     | 52 ++++++++++++++++++++++---------
 2 files changed, 41 insertions(+), 14 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 3944eb969172..db324b4d4651 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1678,10 +1678,13 @@ struct nft_trans_chain {
 
 struct nft_trans_table {
 	bool				update;
+	struct nlattr			*udata;
 };
 
 #define nft_trans_table_update(trans)	\
 	(((struct nft_trans_table *)trans->data)->update)
+#define nft_trans_table_udata(trans)	\
+	(((struct nft_trans_table *)trans->data)->udata)
 
 struct nft_trans_elem {
 	struct nft_set			*set;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index de7efb8c8089..b89a2734ab20 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1199,20 +1199,31 @@ static void nf_tables_table_disable(struct net *net, struct nft_table *table)
 #define __NFT_TABLE_F_UPDATE		(__NFT_TABLE_F_WAS_DORMANT | \
 					 __NFT_TABLE_F_WAS_AWAKEN)
 
+static bool nft_userdata_is_same(const struct nlattr *a, const struct nlattr *b)
+{
+	if (!a && !b)
+		return true;
+	if (!a || !b)
+		return false;
+	if (nla_len(a) != nla_len(b))
+		return false;
+	return !memcmp(nla_data(a), nla_data(b), nla_len(a));
+}
+
 static int nf_tables_updtable(struct nft_ctx *ctx)
 {
 	struct nft_trans *trans;
 	u32 flags;
+	const struct nlattr *udata = ctx->nla[NFTA_TABLE_USERDATA];
 	int ret;
 
-	if (!ctx->nla[NFTA_TABLE_FLAGS])
-		return 0;
-
-	flags = ntohl(nla_get_be32(ctx->nla[NFTA_TABLE_FLAGS]));
-	if (flags & ~NFT_TABLE_F_MASK)
-		return -EOPNOTSUPP;
+	if (ctx->nla[NFTA_TABLE_FLAGS]) {
+		flags = ntohl(nla_get_be32(ctx->nla[NFTA_TABLE_FLAGS]));
+		if (flags & ~NFT_TABLE_F_MASK)
+			return -EOPNOTSUPP;
+	}
 
-	if (flags == ctx->table->flags)
+	if (flags == ctx->table->flags && nft_userdata_is_same(udata, ctx->table->udata))
 		return 0;
 
 	if ((nft_table_has_owner(ctx->table) &&
@@ -1230,6 +1241,15 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 	if (trans == NULL)
 		return -ENOMEM;
 
+	if (udata) {
+		nft_trans_table_udata(trans) = kmemdup(udata, nla_total_size(nla_len(udata)),
+						       GFP_KERNEL_ACCOUNT);
+		if (!nft_trans_table_udata(trans)) {
+			ret = -ENOMEM;
+			goto err_table_udata;
+		}
+	}
+
 	if ((flags & NFT_TABLE_F_DORMANT) &&
 	    !(ctx->table->flags & NFT_TABLE_F_DORMANT)) {
 		ctx->table->flags |= NFT_TABLE_F_DORMANT;
@@ -1254,6 +1274,8 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 
 err_register_hooks:
 	ctx->table->flags |= NFT_TABLE_F_DORMANT;
+	kfree(nft_trans_table_udata(trans));
+err_table_udata:
 	nft_trans_destroy(trans);
 	return ret;
 }
@@ -9367,6 +9389,9 @@ static void nft_obj_commit_update(struct nft_trans *trans)
 static void nft_commit_release(struct nft_trans *trans)
 {
 	switch (trans->msg_type) {
+	case NFT_MSG_NEWTABLE:
+		kfree(nft_trans_table_udata(trans));
+		break;
 	case NFT_MSG_DELTABLE:
 	case NFT_MSG_DESTROYTABLE:
 		nf_tables_table_destroy(&trans->ctx);
@@ -10129,14 +10154,12 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		switch (trans->msg_type) {
 		case NFT_MSG_NEWTABLE:
 			if (nft_trans_table_update(trans)) {
-				if (!(trans->ctx.table->flags & __NFT_TABLE_F_UPDATE)) {
-					nft_trans_destroy(trans);
-					break;
+				if (trans->ctx.table->flags & __NFT_TABLE_F_UPDATE) {
+					if (trans->ctx.table->flags & NFT_TABLE_F_DORMANT)
+						nf_tables_table_disable(net, trans->ctx.table);
+					trans->ctx.table->flags &= ~__NFT_TABLE_F_UPDATE;
 				}
-				if (trans->ctx.table->flags & NFT_TABLE_F_DORMANT)
-					nf_tables_table_disable(net, trans->ctx.table);
-
-				trans->ctx.table->flags &= ~__NFT_TABLE_F_UPDATE;
+				swap(trans->ctx.table->udata, nft_trans_table_udata(trans));
 			} else {
 				nft_clear(net, trans->ctx.table);
 			}
@@ -10419,6 +10442,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 		switch (trans->msg_type) {
 		case NFT_MSG_NEWTABLE:
 			if (nft_trans_table_update(trans)) {
+				kfree(nft_trans_table_udata(trans));
 				if (!(trans->ctx.table->flags & __NFT_TABLE_F_UPDATE)) {
 					nft_trans_destroy(trans);
 					break;
-- 
2.39.3 (Apple Git-145)

