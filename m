Return-Path: <SRS0=+R7G=3E=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66957C33CB3
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jan 2020 21:32:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C48F2081E
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jan 2020 21:32:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="Tc4NG/mz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729141AbgAOVcS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Jan 2020 16:32:18 -0500
Received: from kadath.azazel.net ([81.187.231.250]:56826 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728899AbgAOVcS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Jan 2020 16:32:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GLEQ4K0KKS6sALBxBdPJ1KCG9rZoFn6s4aR5tLODAsg=; b=Tc4NG/mz/ZdSfxzvAUkbbEUHoc
        vMD1B+y1V/c6LS7XLuSW+oJY07F03Tl5rpFYYj/ON0Q41H/eOskDiDziFkV22/VshCxg9QoINIpH2
        Vhkn/vIEQvBVEeBeVpidIsaiSt33haES430qP6hx0/vx4b86SZnvlYjEuOb/I6JomReNQ4GydV0Pl
        ImB6ZWrsO0OBVO5fXWB/umm6igXboePnoAxQVXSiXnfCc7i8p5El0+8qo+WSGy6RxkjRogXYh02D/
        w6Nv0QSOSqwZwig2yP+L7QiXfcShwzf+cLgsDC6YQhinsAYIDZaMRfWvEY4cpK8efjZIGHnuGM5um
        XCbabExQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1irqGu-0008BP-Ut; Wed, 15 Jan 2020 21:32:17 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v4 01/10] netfilter: nf_tables: white-space fixes.
Date:   Wed, 15 Jan 2020 21:32:07 +0000
Message-Id: <20200115213216.77493-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200115213216.77493-1-jeremy@azazel.net>
References: <20200115213216.77493-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Indentation fixes for the parameters of a few nft functions.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 net/netfilter/nft_bitwise.c    | 4 ++--
 net/netfilter/nft_set_bitmap.c | 4 ++--
 net/netfilter/nft_set_hash.c   | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 10e9d50e4e19..e8ca1ec105f8 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -130,8 +130,8 @@ static int nft_bitwise_dump(struct sk_buff *skb, const struct nft_expr *expr)
 static struct nft_data zero;
 
 static int nft_bitwise_offload(struct nft_offload_ctx *ctx,
-                               struct nft_flow_rule *flow,
-                               const struct nft_expr *expr)
+			       struct nft_flow_rule *flow,
+			       const struct nft_expr *expr)
 {
 	const struct nft_bitwise *priv = nft_expr_priv(expr);
 	struct nft_offload_reg *reg = &ctx->regs[priv->dreg];
diff --git a/net/netfilter/nft_set_bitmap.c b/net/netfilter/nft_set_bitmap.c
index 087a056e34d1..87e8d9ba0c9b 100644
--- a/net/netfilter/nft_set_bitmap.c
+++ b/net/netfilter/nft_set_bitmap.c
@@ -259,8 +259,8 @@ static u64 nft_bitmap_privsize(const struct nlattr * const nla[],
 }
 
 static int nft_bitmap_init(const struct nft_set *set,
-			 const struct nft_set_desc *desc,
-			 const struct nlattr * const nla[])
+			   const struct nft_set_desc *desc,
+			   const struct nlattr * const nla[])
 {
 	struct nft_bitmap *priv = nft_set_priv(set);
 
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index b331a3c9a3a8..d350a7cd3af0 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -645,7 +645,7 @@ static bool nft_hash_estimate(const struct nft_set_desc *desc, u32 features,
 }
 
 static bool nft_hash_fast_estimate(const struct nft_set_desc *desc, u32 features,
-			      struct nft_set_estimate *est)
+				   struct nft_set_estimate *est)
 {
 	if (!desc->size)
 		return false;
-- 
2.24.1

