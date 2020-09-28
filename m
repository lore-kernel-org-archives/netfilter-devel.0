Return-Path: <SRS0=suW2=DF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD795C2D0A8
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Sep 2020 12:29:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DD82207E8
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Sep 2020 12:29:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="BFV+YBxC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgI1M3C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Sep 2020 08:29:02 -0400
Received: from mx1.riseup.net ([198.252.153.129]:41282 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726328AbgI1M3A (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Sep 2020 08:29:00 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4C0MJW3yr7zFmbV;
        Mon, 28 Sep 2020 05:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1601296139; bh=evWG5voawq9cS71EO+7toSgUc6nBPeUzMZa9Q39TZxs=;
        h=From:To:Cc:Subject:Date:From;
        b=BFV+YBxCfefDeX+W3GavGcSQ43O04A+B6aqQgbTjS35fprr0ljQMBPoQNQ2Dagsr8
         qRW4hqATfEuU5X8eNBtKKwlIex9b62moTG6vb6PVQ4fJzluS5GtuxrH8SGSVfAqLXQ
         QPQSmeYA7Sh8YM34CybvdeNXs/B307E6oDhohmZc=
X-Riseup-User-ID: BCF7643F7BDFB1C9175BCC27E93699C1C45C0F12C6A92EC2C85B46BE8331E9A0
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 4C0MJV5Bwjz8tpx;
        Mon, 28 Sep 2020 05:28:58 -0700 (PDT)
From:   "Jose M. Guisado Gomez" <guigom@riseup.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH v4 nf-next] netfilter: nf_tables: add userdata attributes to nft_chain
Date:   Mon, 28 Sep 2020 14:27:10 +0200
Message-Id: <20200928122709.6474-1-guigom@riseup.net>
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
Free udata inside destroy_chain instead of error path. Use nla_memdup to
copy user data.

 include/net/netfilter/nf_tables.h        |  2 ++
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c            | 36 ++++++++++++++++++------
 3 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index c4c526507ddb..0bd2a081ae39 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -945,6 +945,8 @@ struct nft_chain {
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
index a4393eddaffd..87a5d8746d8f 100644
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
 
@@ -1684,9 +1690,11 @@ void nf_tables_chain_destroy(struct nft_ctx *ctx)
 			free_percpu(rcu_dereference_raw(basechain->stats));
 		}
 		kfree(chain->name);
+		kfree(chain->udata);
 		kfree(basechain);
 	} else {
 		kfree(chain->name);
+		kfree(chain->udata);
 		kfree(chain);
 	}
 }
@@ -1978,6 +1986,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 	struct nft_trans *trans;
 	struct nft_chain *chain;
 	struct nft_rule **rules;
+	u16 udlen = 0;
 	int err;
 
 	if (table->use == UINT_MAX)
@@ -2040,7 +2049,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 	} else {
 		if (!(flags & NFT_CHAIN_BINDING)) {
 			err = -EINVAL;
-			goto err1;
+			goto err_destroy_chain;
 		}
 
 		snprintf(name, sizeof(name), "__chain%llu", ++chain_id);
@@ -2049,13 +2058,24 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 
 	if (!chain->name) {
 		err = -ENOMEM;
-		goto err1;
+		goto err_destroy_chain;
+	}
+
+	if (nla[NFTA_CHAIN_USERDATA]) {
+		udlen = nla_len(nla[NFTA_CHAIN_USERDATA]);
+		chain->udata = nla_memdup(nla[NFTA_CHAIN_USERDATA], GFP_KERNEL);
+		if (chain->udata == NULL) {
+			err = -ENOMEM;
+			goto err_destroy_chain;
+		}
+
+		chain->udlen = udlen;
 	}
 
 	rules = nf_tables_chain_alloc_rules(chain, 0);
 	if (!rules) {
 		err = -ENOMEM;
-		goto err1;
+		goto err_destroy_chain;
 	}
 
 	*rules = NULL;
@@ -2064,12 +2084,12 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 
 	err = nf_tables_register_hook(net, table, chain);
 	if (err < 0)
-		goto err1;
+		goto err_destroy_chain;
 
 	trans = nft_trans_chain_add(ctx, NFT_MSG_NEWCHAIN);
 	if (IS_ERR(trans)) {
 		err = PTR_ERR(trans);
-		goto err2;
+		goto err_unregister_hook;
 	}
 
 	nft_trans_chain_policy(trans) = NFT_CHAIN_POLICY_UNSET;
@@ -2079,15 +2099,15 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
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
+err_destroy_chain:
 	nf_tables_chain_destroy(ctx);
 
 	return err;
-- 
2.28.0

