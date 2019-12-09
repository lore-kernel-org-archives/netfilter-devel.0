Return-Path: <SRS0=ntVu=Z7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F417C04E30
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Dec 2019 19:27:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE29C20726
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Dec 2019 19:27:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbfLIT07 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Dec 2019 14:26:59 -0500
Received: from correo.us.es ([193.147.175.20]:58466 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727021AbfLIT06 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Dec 2019 14:26:58 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9D8B312085D
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Dec 2019 20:26:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 81AB8DA702
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Dec 2019 20:26:54 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 80E2BDA712; Mon,  9 Dec 2019 20:26:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 71C06DA702;
        Mon,  9 Dec 2019 20:26:52 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 09 Dec 2019 20:26:52 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 40A2C41E4800;
        Mon,  9 Dec 2019 20:26:52 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 13/17] netfilter: nf_tables: validate NFT_DATA_VALUE after nft_data_init()
Date:   Mon,  9 Dec 2019 20:26:34 +0100
Message-Id: <20191209192638.71184-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191209192638.71184-1-pablo@netfilter.org>
References: <20191209192638.71184-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Userspace might bogusly sent NFT_DATA_VERDICT in several netlink
attributes that assume NFT_DATA_VALUE. Moreover, make sure that error
path invokes nft_data_release() to decrement the reference count on the
chain object.

Fixes: 96518518cc41 ("netfilter: add nftables")
Fixes: 0f3cd9b36977 ("netfilter: nf_tables: add range expression")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |  4 +++-
 net/netfilter/nft_bitwise.c   |  4 ++--
 net/netfilter/nft_cmp.c       |  6 ++++++
 net/netfilter/nft_range.c     | 10 ++++++++++
 4 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0db2784fee9a..72a7816ba761 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4519,8 +4519,10 @@ static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		return err;
 
 	err = -EINVAL;
-	if (desc.type != NFT_DATA_VALUE || desc.len != set->klen)
+	if (desc.type != NFT_DATA_VALUE || desc.len != set->klen) {
+		nft_data_release(&elem.key.val, desc.type);
 		return err;
+	}
 
 	priv = set->ops->get(ctx->net, set, &elem, flags);
 	if (IS_ERR(priv))
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 02afa752dd2e..10e9d50e4e19 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -80,7 +80,7 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 			    tb[NFTA_BITWISE_MASK]);
 	if (err < 0)
 		return err;
-	if (d1.len != priv->len) {
+	if (d1.type != NFT_DATA_VALUE || d1.len != priv->len) {
 		err = -EINVAL;
 		goto err1;
 	}
@@ -89,7 +89,7 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 			    tb[NFTA_BITWISE_XOR]);
 	if (err < 0)
 		goto err1;
-	if (d2.len != priv->len) {
+	if (d2.type != NFT_DATA_VALUE || d2.len != priv->len) {
 		err = -EINVAL;
 		goto err2;
 	}
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index b8092069f868..8a28c127effc 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -81,6 +81,12 @@ static int nft_cmp_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	if (err < 0)
 		return err;
 
+	if (desc.type != NFT_DATA_VALUE) {
+		err = -EINVAL;
+		nft_data_release(&priv->data, desc.type);
+		return err;
+	}
+
 	priv->sreg = nft_parse_register(tb[NFTA_CMP_SREG]);
 	err = nft_validate_register_load(priv->sreg, desc.len);
 	if (err < 0)
diff --git a/net/netfilter/nft_range.c b/net/netfilter/nft_range.c
index 4701fa8a45e7..89efcc5a533d 100644
--- a/net/netfilter/nft_range.c
+++ b/net/netfilter/nft_range.c
@@ -66,11 +66,21 @@ static int nft_range_init(const struct nft_ctx *ctx, const struct nft_expr *expr
 	if (err < 0)
 		return err;
 
+	if (desc_from.type != NFT_DATA_VALUE) {
+		err = -EINVAL;
+		goto err1;
+	}
+
 	err = nft_data_init(NULL, &priv->data_to, sizeof(priv->data_to),
 			    &desc_to, tb[NFTA_RANGE_TO_DATA]);
 	if (err < 0)
 		goto err1;
 
+	if (desc_to.type != NFT_DATA_VALUE) {
+		err = -EINVAL;
+		goto err2;
+	}
+
 	if (desc_from.len != desc_to.len) {
 		err = -EINVAL;
 		goto err2;
-- 
2.11.0

