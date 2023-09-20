Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59E81CE79D4
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 12:10:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235384AbjITMKb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 08:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235334AbjITMKY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 08:10:24 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F3B83;
        Wed, 20 Sep 2023 05:10:15 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4BBFC433C9;
        Wed, 20 Sep 2023 12:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1695211815;
        bh=2Mphd1WoRtpR3HujuCbxZTgVX5h+R5BkDlU8NPsjj90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S2oKX3dnCZoPp3TYqhnCvjY6jS4q/g2/RxuYreKtVGPdA/nqw6h6Q2akm15cJQBCi
         ON+L3O0EmwUzWTZXYnaupazB4TuaxEOPar7ZoCfG1sLNmj+djYP3PGgNuiDSMGXQtM
         mn4p7QRitZIGA8no8tMEO93CmnxjtkodYF033rvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, wenxu <wenxu@ucloud.cn>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 046/273] netfilter: nft_flow_offload: fix underflow in flowtable reference counter
Date:   Wed, 20 Sep 2023 13:28:06 +0200
Message-ID: <20230920112847.839984406@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wenxu <wenxu@ucloud.cn>

commit 8ca79606cdfde2e37ee4f0707b9d1874a6f0eb38 upstream.

The .deactivate and .activate interfaces already deal with the reference
counter. Otherwise, this results in spurious "Device is busy" errors.

Fixes: a3c90f7a2323 ("netfilter: nf_tables: flow offload expression")
Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_flow_offload.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -197,9 +197,6 @@ static void nft_flow_offload_activate(co
 static void nft_flow_offload_destroy(const struct nft_ctx *ctx,
 				     const struct nft_expr *expr)
 {
-	struct nft_flow_offload *priv = nft_expr_priv(expr);
-
-	priv->flowtable->use--;
 	nf_ct_netns_put(ctx->net, ctx->family);
 }
 


