Return-Path: <SRS0=+Cxx=DA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55467C2D0A8
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Sep 2020 10:56:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0081F235FC
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Sep 2020 10:56:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="itc0aHaw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgIWK4e (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Sep 2020 06:56:34 -0400
Received: from mx1.riseup.net ([198.252.153.129]:45960 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbgIWK4e (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Sep 2020 06:56:34 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4BxFVB2mTzzFrd7;
        Wed, 23 Sep 2020 03:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1600858594; bh=nF6qSOCBd09kfBWDLuRGTdWVvOq5TsN6XQjVWUtb2I8=;
        h=From:To:Cc:Subject:Date:Reply-To:From;
        b=itc0aHawbk1VpTvyDZaNbNqEkYDAYTao422pQx9+ZuawQg/Ra7+HlLJEa921+yS+S
         Nnf8uS0l90UUrNCEjCs8wL8hZLCIgeIqICOPgp6L7J7ZTtGuuFBiJ2TSUMgcDkDy71
         /hyyovqlekwwSaLbNfMZNnFqN9ifu6PqbbqDsehg=
X-Riseup-User-ID: F102DB01BD732E677DE823414716D1C2BFE5ACD2465611E938AA233291DF8C9D
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 4BxFV94FVmzJnDZ;
        Wed, 23 Sep 2020 03:56:33 -0700 (PDT)
From:   "Jose M. Guisado Gomez" <guigom@riseup.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH v2 nf-next] netfilter: nf_tables: add userdata attributes to nft_chain
Date:   Wed, 23 Sep 2020 12:55:17 +0200
Message-Id: <20200923105517.1480-1-guigom@riseup.net>
Reply-To: <20200921234912.GA6657@salvia>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Enables storing userdata for nft_chain. Field udata points to user data
and udlen stores its length.

Adds new attribute flag NFTA_CHAIN_USERDATA.

Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
---
Fix error path and remove basic-like labels

 include/net/netfilter/nf_tables.h        |  2 ++
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c            | 41 +++++++++++++++++++-----
 3 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 8ceca0e419b3..4686fafbfd8a 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -952,6 +952,8 @@ struct nft_chain {
 					bound:1,
 					genmask:2;
 	char				*name;
+	u16				udlen;
+	u8				*udata;
 
 	/* Only used during control plane commit phase: */
 	struct nft_rule			**rules_next;
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 3c2469b43742..352ee51707a1 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -208,6 +208,7 @@ enum nft_chain_flags {
  * @NFTA_CHAIN_COUNTERS: counter specification of the chain (NLA_NESTED: nft_counter_attributes)
  * @NFTA_CHAIN_FLAGS: chain flags
  * @NFTA_CHAIN_ID: uniquely identifies a chain in a transaction (NLA_U32)
+ * @NFTA_CHAIN_USERDATA: user data (NLA_BINARY)
  */
 enum nft_chain_attributes {
 	NFTA_CHAIN_UNSPEC,
@@ -222,6 +223,7 @@ enum nft_chain_attributes {
 	NFTA_CHAIN_PAD,
 	NFTA_CHAIN_FLAGS,
 	NFTA_CHAIN_ID,
+	NFTA_CHAIN_USERDATA,
 	__NFTA_CHAIN_MAX
 };
 #define NFTA_CHAIN_MAX		(__NFTA_CHAIN_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 84c0c1aaae99..df800a20df59 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1306,6 +1306,8 @@ static const struct nla_policy nft_chain_policy[NFTA_CHAIN_MAX + 1] = {
 	[NFTA_CHAIN_COUNTERS]	= { .type = NLA_NESTED },
 	[NFTA_CHAIN_FLAGS]	= { .type = NLA_U32 },
 	[NFTA_CHAIN_ID]		= { .type = NLA_U32 },
+	[NFTA_CHAIN_USERDATA]	= { .type = NLA_BINARY,
+				    .len = NFT_USERDATA_MAXLEN },
 };
 
 static const struct nla_policy nft_hook_policy[NFTA_HOOK_MAX + 1] = {
@@ -1447,6 +1449,10 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 	if (nla_put_be32(skb, NFTA_CHAIN_USE, htonl(chain->use)))
 		goto nla_put_failure;
 
+	if (chain->udata &&
+	    nla_put(skb, NFTA_CHAIN_USERDATA, chain->udlen, chain->udata))
+		goto nla_put_failure;
+
 	nlmsg_end(skb, nlh);
 	return 0;
 
@@ -1978,6 +1984,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 	struct nft_trans *trans;
 	struct nft_chain *chain;
 	struct nft_rule **rules;
+	u16 udlen = 0;
 	int err;
 
 	if (table->use == UINT_MAX)
@@ -2040,7 +2047,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 	} else {
 		if (!(flags & NFT_CHAIN_BINDING)) {
 			err = -EINVAL;
-			goto err1;
+			goto err_flag;
 		}
 
 		snprintf(name, sizeof(name), "__chain%llu", ++chain_id);
@@ -2049,13 +2056,25 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 
 	if (!chain->name) {
 		err = -ENOMEM;
-		goto err1;
+		goto err_chain_name;
+	}
+
+	if (nla[NFTA_CHAIN_USERDATA]) {
+		udlen = nla_len(nla[NFTA_CHAIN_USERDATA]);
+		chain->udata = kzalloc(udlen, GFP_KERNEL);
+		if (chain->udata == NULL) {
+			err = -ENOMEM;
+			goto err_userdata;
+		}
+
+		nla_memcpy(chain->udata, nla[NFTA_CHAIN_USERDATA], udlen);
+		chain->udlen = udlen;
 	}
 
 	rules = nf_tables_chain_alloc_rules(chain, 0);
 	if (!rules) {
 		err = -ENOMEM;
-		goto err1;
+		goto err_alloc_rules;
 	}
 
 	*rules = NULL;
@@ -2064,12 +2083,12 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 
 	err = nf_tables_register_hook(net, table, chain);
 	if (err < 0)
-		goto err1;
+		goto err_register_hook;
 
 	trans = nft_trans_chain_add(ctx, NFT_MSG_NEWCHAIN);
 	if (IS_ERR(trans)) {
 		err = PTR_ERR(trans);
-		goto err2;
+		goto err_trans;
 	}
 
 	nft_trans_chain_policy(trans) = NFT_CHAIN_POLICY_UNSET;
@@ -2079,15 +2098,21 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 	err = nft_chain_add(table, chain);
 	if (err < 0) {
 		nft_trans_destroy(trans);
-		goto err2;
+		goto err_chain_add;
 	}
 
 	table->use++;
 
 	return 0;
-err2:
+err_chain_add:
+err_trans:
 	nf_tables_unregister_hook(net, table, chain);
-err1:
+err_register_hook:
+err_alloc_rules:
+	kfree(chain->udata);
+err_userdata:
+err_chain_name:
+err_flag:
 	nf_tables_chain_destroy(ctx);
 
 	return err;
-- 
2.27.0

