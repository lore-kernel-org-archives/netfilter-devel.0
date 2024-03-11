Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA843FB8E
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Mar 2024 14:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710166518; cv=none; b=EJs9HrmURn/sOGrEvXMrHu7zrTffQATTM48IeIM8cX5xhr7CzczFG9g+Bier/9D0Z7hwnGZLABRKC+K0wLB6Fldhiz+qpaG82FJY20e4b86e96Q7ykRwyzS0NMJt3C93GMyKkWfQy4r2hm8IxqbcaZ0CcFuKHL1FtqmlxE4egxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710166518; c=relaxed/simple;
	bh=HisiDJYVuiNIw8PpKcTFbYNz9xDA3rCtZdSYXXZTT3k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lc/DyOpmWCqf4dyg9VUd82/jaxtdz4al4Qp7CRmtnBDLFCm1ifY2+SBTTUGo/XVluCM7jn2btm7WLeYktdj0UFHb92O59/oX18HE6xMosVUCMojgU9B4E2IctGSKylA3TsGSyRz6LM9ah1Y51pOZFkJyLcWFV87yQyoPAJmRuMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c1zLXKF5; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c1zLXKF5"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6e5a232fe80so2948637b3a.0
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Mar 2024 07:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710166516; x=1710771316; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BWDjIruzpNBJF5qfyOeVKj/HAYcGE1vK/z2KLDBvVQg=;
        b=c1zLXKF5+zNDePrkAquI4+gGeBNHYf7v6xJVmS61RR6BS8msrJ2X6vHYSCx5aVrru1
         g7lHp4krRqk3PeMH4BWZKuGOv0qt+UVr2y4rnTzn4iWLYYX4qepw8PWTFP+Egy36Cla0
         NODnUAi/dk7XpZb/jQ1pz5pj9ARlUSQvMlldUouZ1JqQ/dl3BTgTZ84K2CZTU5UMrOlW
         kPMsrlCCN36KzPmQWsFVb9sNIJFulbMHvmh/x+pfWY4xaPJfjtk6kL5BuyPaf6ogDgz3
         H/Zq3cWKhjC5V8qU09KzJ84+xXbCOKKGDTAy9sWom25wu7JdJ7YzZ7dCGwoCPK5v0ki0
         kIAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710166516; x=1710771316;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BWDjIruzpNBJF5qfyOeVKj/HAYcGE1vK/z2KLDBvVQg=;
        b=KqTRicnkNGvBy8jqTP+WNo4XOpHAY2s9pRzpyi5h+R/lARgBZ5b2sQtmg7pris0V3+
         j8B90AxU7cnBTgBLJG9T84bFubglSbS+SRF1XmEZE2jd1ygZHq94R2ZEWlh7mOWucY44
         oUzKtFQAM9PSd14059E/RvK58hX1eCMnvSBQFsDaIBZlR+YUPbb2PQOu3lJ/kn/BqKkz
         oQr2j6pve56nW9RHdRcTPXctFt6puqcNUIHp5tH1k2px1kk7oGY+1tqqDeTOt7sAlqxH
         +q1gYPpqssd+1mFhDzD2Vde9bjZApXOB9C7E/g+wuaPlIF9xlj/VaZJJPcF5euhhIYW1
         lckA==
X-Gm-Message-State: AOJu0YygV8YthHxnoKBIN19b9DSWx8Q54gnPakDEFbrpC+DFQlzNs6Df
	7qfJSXk+RLRB1tSvAgBgL6wqViK3Iq3BhcntIsgRdY6ouQjngbnC+ZkdeRkEhWdn0ipQ
X-Google-Smtp-Source: AGHT+IGonlx4PlXCRNyt44IzvH5H33O1NSggzmRwsyPioBFGQRBsU6I2eCEFyE6lW2fP+8G+NPGizg==
X-Received: by 2002:a05:6a20:12cb:b0:1a1:87b5:4b28 with SMTP id v11-20020a056a2012cb00b001a187b54b28mr8710957pzg.0.1710166516242;
        Mon, 11 Mar 2024 07:15:16 -0700 (PDT)
Received: from localhost.localdomain (ec2-52-199-81-84.ap-northeast-1.compute.amazonaws.com. [52.199.81.84])
        by smtp.gmail.com with ESMTPSA id k12-20020aa7998c000000b006e632025bcdsm4378366pfh.138.2024.03.11.07.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Mar 2024 07:15:15 -0700 (PDT)
From: Quan Tian <tianquan23@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	Quan Tian <tianquan23@gmail.com>
Subject: [PATCH v3 nf-next 2/2] netfilter: nf_tables: support updating userdata for nft_table
Date: Mon, 11 Mar 2024 22:14:54 +0800
Message-Id: <20240311141454.31537-2-tianquan23@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
In-Reply-To: <20240311141454.31537-1-tianquan23@gmail.com>
References: <20240311141454.31537-1-tianquan23@gmail.com>
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
 v3: Do not call nft_trans_destroy() on table updates in nf_tables_commit()

 include/net/netfilter/nf_tables.h |  3 ++
 net/netfilter/nf_tables_api.c     | 56 ++++++++++++++++++++++---------
 2 files changed, 43 insertions(+), 16 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 144dc469ebf8..43c747bd3f80 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1684,10 +1684,13 @@ struct nft_trans_chain {
 
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
index 85088297dd0d..62a2a1798052 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -188,6 +188,17 @@ static struct nlattr *nft_userdata_dup(const struct nlattr *udata, gfp_t gfp)
 	return kmemdup(udata, nla_total_size(nla_len(udata)), gfp);
 }
 
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
 static void __nft_set_trans_bind(const struct nft_ctx *ctx, struct nft_set *set,
 				 bool bind)
 {
@@ -1210,16 +1221,16 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
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
@@ -1240,6 +1251,14 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 	if (trans == NULL)
 		return -ENOMEM;
 
+	if (udata) {
+		nft_trans_table_udata(trans) = nft_userdata_dup(udata, GFP_KERNEL_ACCOUNT);
+		if (!nft_trans_table_udata(trans)) {
+			ret = -ENOMEM;
+			goto err_table_udata;
+		}
+	}
+
 	if ((flags & NFT_TABLE_F_DORMANT) &&
 	    !(ctx->table->flags & NFT_TABLE_F_DORMANT)) {
 		ctx->table->flags |= NFT_TABLE_F_DORMANT;
@@ -1271,6 +1290,8 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 
 err_register_hooks:
 	ctx->table->flags |= NFT_TABLE_F_DORMANT;
+	kfree(nft_trans_table_udata(trans));
+err_table_udata:
 	nft_trans_destroy(trans);
 	return ret;
 }
@@ -9378,6 +9399,9 @@ static void nft_obj_commit_update(struct nft_trans *trans)
 static void nft_commit_release(struct nft_trans *trans)
 {
 	switch (trans->msg_type) {
+	case NFT_MSG_NEWTABLE:
+		kfree(nft_trans_table_udata(trans));
+		break;
 	case NFT_MSG_DELTABLE:
 	case NFT_MSG_DESTROYTABLE:
 		nf_tables_table_destroy(&trans->ctx);
@@ -10140,19 +10164,18 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
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
+				nf_tables_table_notify(&trans->ctx, NFT_MSG_NEWTABLE);
 			} else {
 				nft_clear(net, trans->ctx.table);
+				nf_tables_table_notify(&trans->ctx, NFT_MSG_NEWTABLE);
+				nft_trans_destroy(trans);
 			}
-			nf_tables_table_notify(&trans->ctx, NFT_MSG_NEWTABLE);
-			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_DELTABLE:
 		case NFT_MSG_DESTROYTABLE:
@@ -10430,6 +10453,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 		switch (trans->msg_type) {
 		case NFT_MSG_NEWTABLE:
 			if (nft_trans_table_update(trans)) {
+				kfree(nft_trans_table_udata(trans));
 				if (!(trans->ctx.table->flags & __NFT_TABLE_F_UPDATE)) {
 					nft_trans_destroy(trans);
 					break;
-- 
2.39.3 (Apple Git-145)

