Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A68C0C4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Mar 2022 12:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347381AbiCUMc0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Mar 2022 08:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244987AbiCUMcX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Mar 2022 08:32:23 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 165F684ECB;
        Mon, 21 Mar 2022 05:30:58 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id AF4BD62FFE;
        Mon, 21 Mar 2022 13:28:15 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 02/19] netfilter: conntrack: Add and use nf_ct_set_auto_assign_helper_warned()
Date:   Mon, 21 Mar 2022 13:30:35 +0100
Message-Id: <20220321123052.70553-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321123052.70553-1-pablo@netfilter.org>
References: <20220321123052.70553-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

The function sets the pernet boolean to avoid the spurious warning from
nf_ct_lookup_helper() when assigning conntrack helpers via nftables.

Fixes: 1a64edf54f55 ("netfilter: nft_ct: add helper set support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_helper.h | 1 +
 net/netfilter/nf_conntrack_helper.c         | 6 ++++++
 net/netfilter/nft_ct.c                      | 3 +++
 3 files changed, 10 insertions(+)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 37f0fbefb060..9939c366f720 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -177,4 +177,5 @@ void nf_nat_helper_unregister(struct nf_conntrack_nat_helper *nat);
 int nf_nat_helper_try_module_get(const char *name, u16 l3num,
 				 u8 protonum);
 void nf_nat_helper_put(struct nf_conntrack_helper *helper);
+void nf_ct_set_auto_assign_helper_warned(struct net *net);
 #endif /*_NF_CONNTRACK_HELPER_H*/
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index a97ddb1497aa..8dec42ec603e 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -550,6 +550,12 @@ void nf_nat_helper_unregister(struct nf_conntrack_nat_helper *nat)
 }
 EXPORT_SYMBOL_GPL(nf_nat_helper_unregister);
 
+void nf_ct_set_auto_assign_helper_warned(struct net *net)
+{
+	nf_ct_pernet(net)->auto_assign_helper_warned = true;
+}
+EXPORT_SYMBOL_GPL(nf_ct_set_auto_assign_helper_warned);
+
 void nf_conntrack_helper_pernet_init(struct net *net)
 {
 	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 5adf8bb628a8..9c7472af9e4a 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1041,6 +1041,9 @@ static int nft_ct_helper_obj_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		goto err_put_helper;
 
+	/* Avoid the bogus warning, helper will be assigned after CT init */
+	nf_ct_set_auto_assign_helper_warned(ctx->net);
+
 	return 0;
 
 err_put_helper:
-- 
2.30.2

