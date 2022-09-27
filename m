Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95B33C07E9D
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Sep 2022 22:15:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiI0WPr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Sep 2022 18:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiI0WPp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Sep 2022 18:15:45 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D44B912756F
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Sep 2022 15:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OxuSyApwp/HIU9YG9aoxn2ikYlT2LCbdK7dsH9rQzpQ=; b=V6weYAas7D3RH8H315QciZE4vC
        8KrWkS79tBWMfeZXJMyidGnvSaPnk7QVwtizfvaC95LgKEgxpUef4uK/ES08RaRcSX5ehQZj1eGBF
        oV8NqA38iPyChYNqWxzhjWoRLDTjLWZiXSbffYIfz2ygjV8DzsEWa3DAB/Xh8AIbT1BP8P6QLHHs/
        Fo/w4HZ79giQpo8rWs0IJ+U41qozaM8VMvqwzf4iu9QZdvIG2UpiS2S+rGsXi4PU0RovLmOIiUDF4
        eJkwMrybIu8MW35Gk8MTKiQQpyfOl3jqtqOg15BNyaXBiNQ40erUg0iEI1KVfdIEOsrc4o4XPIWm4
        P87oPglQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1odIre-00005z-8s
        for netfilter-devel@vger.kernel.org; Wed, 28 Sep 2022 00:15:42 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 4/5] nft-shared: Introduce __get_cmp_data()
Date:   Wed, 28 Sep 2022 00:15:11 +0200
Message-Id: <20220927221512.7400-5-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220927221512.7400-1-phil@nwl.cc>
References: <20220927221512.7400-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is an inner function to get_cmp_data() returning the op value as-is
for caller examination.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-shared.c | 17 ++++++++++-------
 iptables/nft-shared.h |  1 +
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 71e2f18dab929..616e6a4dcf3a6 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -466,17 +466,20 @@ static void nft_parse_match(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 		ctx->h->ops->parse_match(match, ctx->cs);
 }
 
-void get_cmp_data(struct nftnl_expr *e, void *data, size_t dlen, bool *inv)
+void __get_cmp_data(struct nftnl_expr *e, void *data, size_t dlen, uint8_t *op)
 {
 	uint32_t len;
-	uint8_t op;
 
 	memcpy(data, nftnl_expr_get(e, NFTNL_EXPR_CMP_DATA, &len), dlen);
-	op = nftnl_expr_get_u32(e, NFTNL_EXPR_CMP_OP);
-	if (op == NFT_CMP_NEQ)
-		*inv = true;
-	else
-		*inv = false;
+	*op = nftnl_expr_get_u32(e, NFTNL_EXPR_CMP_OP);
+}
+
+void get_cmp_data(struct nftnl_expr *e, void *data, size_t dlen, bool *inv)
+{
+	uint8_t op;
+
+	__get_cmp_data(e, data, dlen, &op);
+	*inv = (op == NFT_CMP_NEQ);
 }
 
 static void nft_meta_set_to_target(struct nft_xt_ctx *ctx)
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 0718dc23e8b77..d866dcb512766 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -159,6 +159,7 @@ bool is_same_interfaces(const char *a_iniface, const char *a_outiface,
 int parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e, uint8_t key,
 	       char *iniface, unsigned char *iniface_mask, char *outiface,
 	       unsigned char *outiface_mask, uint8_t *invflags);
+void __get_cmp_data(struct nftnl_expr *e, void *data, size_t dlen, uint8_t *op);
 void get_cmp_data(struct nftnl_expr *e, void *data, size_t dlen, bool *inv);
 void nft_rule_to_iptables_command_state(struct nft_handle *h,
 					const struct nftnl_rule *r,
-- 
2.34.1

