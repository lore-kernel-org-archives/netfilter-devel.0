Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B7816FF23
	for <netfilter-devel@vger.kernel.org>; Sun, 10 Mar 2024 13:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710076185; cv=none; b=uMoQ4bkGFdNpXk4zVCIr/tdX4qBJGSd4oHs/dgWBs4grtiYSnREqv2c/jsAfL+MSwMLGlgyQebvhgfAJjgVqDepvUQmlB0xU1BCZqUGS0ogLrJNJZiapk7YHcc0pKpSLRX2I1cV/fTJoVMOKXWKFkv/41lghfH23kOOKXPvWeZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710076185; c=relaxed/simple;
	bh=8y4jIQXtv4pVmkuoSMdzeSs9ZWMs+NIwfscvVrPFYNA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=obw30c/va+PnwcvP+AduwUo2vBz6MOotJtwj4G4y4w9RD+LP9Wb85Xfqzt7PWNU/wYXNpGnqUBGQgYwXWcSTRIYRaEKM513lE/PkGh46+SGGMkc0MGSj/Zku+UY8mhgkw/1GtI60jQvC9fhX2Z0wtZsU7/n6wg7RzQ6nJU2kQzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KulfoBkP; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KulfoBkP"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-366477b5fc2so3136885ab.2
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Mar 2024 06:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710076182; x=1710680982; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=P5OALOdSMzUcWl339YrUBqp7B5ElZ5a+ufhKxVWaeKw=;
        b=KulfoBkPWQzHKQgd+Tmr5lMeWEMluFiBxi8JKTcQxJYHuSCrFsKynyT2AfCNqgVeBt
         e72qJaUriWzMAbn9fJ9iM7QZDXHJI88d2iXqtQmac6ci08t529RZrReadOV4XfC1aQWg
         L9jbV5RHwDhLFGc7hOAng8nvaoTAszkhiROR6FnBcRfdbqw8gDWDRv+MiA14uvWABuSg
         4y76oOjE6nkIysFXauxaPRhckfNUcUSqELQaAmadse4XI8mhrIe6MMFCvpcbbqnZ8Bpb
         tc4ZiO8OlPDeokJDaRyYW02ZZzm1Gr6X+eiRlPDqQjNgp6DdxYccUTTbGRHy6xWd9EDO
         YZtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710076182; x=1710680982;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P5OALOdSMzUcWl339YrUBqp7B5ElZ5a+ufhKxVWaeKw=;
        b=Inp2NCXN7/eWNVZj1KOVW253MkFi+tGebOWhg1SXR2KDFBhqXWGjdEmvVA8Vji41Y3
         bY0hPp+T/liXBfUK3bKguawU1r0k5wOZUdDO0BwhWhslbzybc/jBzsoWpQUR1cYxAJSM
         f8nGToYCMREJEYLLsjHxlQ3mHm0jKtss2gw3fbesYEGiMq/0I4xQSldWGOkksb9YhuD9
         6vYVXdgE8BQ0bbdI2SNX1P/FGTEHFo5BWRlPKp2XDvOjM3Q4fsDnVUi0p2QyoTnjikW4
         PrEkUWa08sZ+5iE1mT16JJ+j+wXkYaWgXF+bCsHBKEa8KEpXXHEGwFqNwXV8GZg931Yf
         yj6Q==
X-Gm-Message-State: AOJu0Yy7DcmuSSn2xwyXkVbd1Q/91+BajKnxfeEnWti+1qjEg56nMr3V
	XL+dMxhx2I0BMGUVomWUdh9JtizESESQNH7IjOIiB6nxCiexQ+Z3LQOYUey8Wbc=
X-Google-Smtp-Source: AGHT+IGHXL/cZRz9jBwqM4CsmUC16a13WSp5Wrn/sowSZNQAXg2ACnKxV0bvdyb00kR4MFavCMSknQ==
X-Received: by 2002:a6b:f005:0:b0:7c8:89cc:8de4 with SMTP id w5-20020a6bf005000000b007c889cc8de4mr4071413ioc.5.1710076181947;
        Sun, 10 Mar 2024 06:09:41 -0700 (PDT)
Received: from localhost.localdomain (ec2-52-199-81-84.ap-northeast-1.compute.amazonaws.com. [52.199.81.84])
        by smtp.gmail.com with ESMTPSA id q10-20020a65524a000000b005dc3fc53f19sm2175226pgp.7.2024.03.10.06.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Mar 2024 06:09:41 -0700 (PDT)
From: Quan Tian <tianquan23@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	Quan Tian <tianquan23@gmail.com>
Subject: [PATCH nf-next] netfilter: nf_tables: support updating userdata for nft_table
Date: Sun, 10 Mar 2024 21:08:10 +0800
Message-Id: <20240310130810.54904-1-tianquan23@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
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
 include/net/netfilter/nf_tables.h |  6 ++++
 net/netfilter/nf_tables_api.c     | 53 +++++++++++++++++++++++--------
 2 files changed, 45 insertions(+), 14 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 510244cc0f8f..4406c056f52f 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1680,10 +1680,16 @@ struct nft_trans_chain {
 
 struct nft_trans_table {
 	bool				update;
+	u16				udlen;
+	u8				*udata;
 };
 
 #define nft_trans_table_update(trans)	\
 	(((struct nft_trans_table *)trans->data)->update)
+#define nft_trans_table_udlen(trans)	\
+	(((struct nft_trans_table *)trans->data)->udlen)
+#define nft_trans_table_udata(trans)	\
+	(((struct nft_trans_table *)trans->data)->udata)
 
 struct nft_trans_elem {
 	struct nft_set			*set;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7e938c7397dd..9243f4b02895 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1198,20 +1198,32 @@ static void nf_tables_table_disable(struct net *net, struct nft_table *table)
 #define __NFT_TABLE_F_UPDATE		(__NFT_TABLE_F_WAS_DORMANT | \
 					 __NFT_TABLE_F_WAS_AWAKEN)
 
+static bool nft_userdata_is_same(const struct nlattr *nla, u8 *udata, u16 udlen)
+{
+	if (!nla && !udata)
+		return true;
+	if (!nla || !udata)
+		return false;
+	if (nla_len(nla) != udlen)
+		return false;
+	return !nla_memcmp(nla, udata, udlen);
+}
+
 static int nf_tables_updtable(struct nft_ctx *ctx)
 {
 	struct nft_trans *trans;
 	u32 flags;
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
+	if (flags == ctx->table->flags &&
+	    nft_userdata_is_same(ctx->nla[NFTA_TABLE_USERDATA], ctx->table->udata,
+				 ctx->table->udlen))
 		return 0;
 
 	if ((nft_table_has_owner(ctx->table) &&
@@ -1229,6 +1241,16 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 	if (trans == NULL)
 		return -ENOMEM;
 
+	if (ctx->nla[NFTA_TABLE_USERDATA]) {
+		nft_trans_table_udata(trans) = nla_memdup(ctx->nla[NFTA_TABLE_USERDATA],
+							  GFP_KERNEL_ACCOUNT);
+		if (!nft_trans_table_udata(trans)) {
+			ret = -ENOMEM;
+			goto err_table_udata;
+		}
+		nft_trans_table_udlen(trans) = nla_len(ctx->nla[NFTA_TABLE_USERDATA]);
+	}
+
 	if ((flags & NFT_TABLE_F_DORMANT) &&
 	    !(ctx->table->flags & NFT_TABLE_F_DORMANT)) {
 		ctx->table->flags |= NFT_TABLE_F_DORMANT;
@@ -1253,6 +1275,8 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 
 err_register_hooks:
 	ctx->table->flags |= NFT_TABLE_F_DORMANT;
+	kfree(nft_trans_table_udata(trans));
+err_table_udata:
 	nft_trans_destroy(trans);
 	return ret;
 }
@@ -10128,14 +10152,14 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
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
+				kfree(trans->ctx.table->udata);
+				trans->ctx.table->udata = nft_trans_table_udata(trans);
+				trans->ctx.table->udlen = nft_trans_table_udlen(trans);
 			} else {
 				nft_clear(net, trans->ctx.table);
 			}
@@ -10418,6 +10442,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 		switch (trans->msg_type) {
 		case NFT_MSG_NEWTABLE:
 			if (nft_trans_table_update(trans)) {
+				kfree(nft_trans_table_udata(trans));
 				if (!(trans->ctx.table->flags & __NFT_TABLE_F_UPDATE)) {
 					nft_trans_destroy(trans);
 					break;
-- 
2.39.3 (Apple Git-145)

