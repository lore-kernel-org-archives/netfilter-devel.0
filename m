Return-Path: <SRS0=+Cxx=DA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D090EC2D0E2
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Sep 2020 13:19:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84639221F0
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Sep 2020 13:19:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="RnzGX4kc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgIWNTt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Sep 2020 09:19:49 -0400
Received: from mx1.riseup.net ([198.252.153.129]:46778 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgIWNTt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Sep 2020 09:19:49 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4BxJgS5LCMzFfqn;
        Wed, 23 Sep 2020 06:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1600867188; bh=RT5IvjYZi5EH05ktv/IWExnriex3Hi+doOJG8DZLg44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RnzGX4kcz8SaDYl0qpU8DwMZPra5FfJYK+TZxw9oTulM/hWxhoT26Of6tVWxmBszj
         vt6b737j9z6gvNxlG58FCZ3YO5Urvk4b0yq4RH8qieCCxYWmdge+SwQgrrgo9Y++h1
         Wyx0fGJyPI4TZCr/uAp0xGputsYrngw5gKG6VIWo=
X-Riseup-User-ID: 5272A40F6FFE422DE7F713DEC7E532ED91C50492BF86498CB7D5232CA0DFE7F1
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 4BxJgR6YxSzJqpG;
        Wed, 23 Sep 2020 06:19:47 -0700 (PDT)
From:   "Jose M. Guisado Gomez" <guigom@riseup.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH v3 nf-next] netfilter: nf_tables: add userdata attributes to nft_chain
Date:   Wed, 23 Sep 2020 15:16:30 +0200
Message-Id: <20200923131629.761-1-guigom@riseup.net>
In-Reply-To: <20200923112042.GB3218@salvia>
References: <20200923112042.GB3218@salvia>
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
Rename error path labels as proposed

 include/net/netfilter/nf_tables.h        |  2 ++
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c            | 37 +++++++++++++++++++-----
 3 files changed, 33 insertions(+), 8 deletions(-)

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
index 84c0c1aaae99..cde2c5194ed9 100644
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
+			goto err_destroy_chain;
 		}
 
 		snprintf(name, sizeof(name), "__chain%llu", ++chain_id);
@@ -2049,13 +2056,25 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 
 	if (!chain->name) {
 		err = -ENOMEM;
-		goto err1;
+		goto err_destroy_chain;
+	}
+
+	if (nla[NFTA_CHAIN_USERDATA]) {
+		udlen = nla_len(nla[NFTA_CHAIN_USERDATA]);
+		chain->udata = kzalloc(udlen, GFP_KERNEL);
+		if (chain->udata == NULL) {
+			err = -ENOMEM;
+			goto err_destroy_chain;
+		}
+
+		nla_memcpy(chain->udata, nla[NFTA_CHAIN_USERDATA], udlen);
+		chain->udlen = udlen;
 	}
 
 	rules = nf_tables_chain_alloc_rules(chain, 0);
 	if (!rules) {
 		err = -ENOMEM;
-		goto err1;
+		goto err_free_udata;
 	}
 
 	*rules = NULL;
@@ -2064,12 +2083,12 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 
 	err = nf_tables_register_hook(net, table, chain);
 	if (err < 0)
-		goto err1;
+		goto err_free_udata;
 
 	trans = nft_trans_chain_add(ctx, NFT_MSG_NEWCHAIN);
 	if (IS_ERR(trans)) {
 		err = PTR_ERR(trans);
-		goto err2;
+		goto err_unregister_hook;
 	}
 
 	nft_trans_chain_policy(trans) = NFT_CHAIN_POLICY_UNSET;
@@ -2079,15 +2098,17 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 	err = nft_chain_add(table, chain);
 	if (err < 0) {
 		nft_trans_destroy(trans);
-		goto err2;
+		goto err_unregister_hook;
 	}
 
 	table->use++;
 
 	return 0;
-err2:
+err_unregister_hook:
 	nf_tables_unregister_hook(net, table, chain);
-err1:
+err_free_udata:
+	kfree(chain->udata);
+err_destroy_chain:
 	nf_tables_chain_destroy(ctx);
 
 	return err;
-- 
2.27.0

