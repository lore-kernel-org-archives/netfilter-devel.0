Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49FA3C001DE
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Aug 2023 18:55:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234789AbjHJSzF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Aug 2023 14:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233637AbjHJSzE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Aug 2023 14:55:04 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC440270A
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Aug 2023 11:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CaxCCD5gWEDur1KbzY7YetyTic9AetWvbd6vdUQcGpo=; b=C7LjKa6SEQ0ioUL2jZehkT/loW
        qQE5ovmqiZWJtYwPwpee1hHqeUiZ/5DjrO5fcfWIgB35uCPK4EJg2td7ijvWWezHT+fkoFU593xNz
        PD4KOiUqAAtCH8t9fnwBoFhdRbcGoKSAufyWhArnJDtzUxa3yS2g0X9lQv/RSKTWAsCQYo7OqWC1v
        wHTxc/7rD+mWVmRkdz27XSaxR0yJbnHUWDsRv1Ui7sAKLaYzntvVELDDn/tw1x0heakqKcGxTQMpN
        yB70PSd0Yc5YPoGS6eJqADGvDyGfN4/5oEf2JnaSoVLinhu5Lsh5xLRZsmnxJsrn+tkXKX1Ba/9xl
        PewSV2mQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qUAoG-0002YS-Qv
        for netfilter-devel@vger.kernel.org; Thu, 10 Aug 2023 20:55:00 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 2/4] nft: Introduce and use bool nft_handle::compat
Date:   Thu, 10 Aug 2023 20:54:50 +0200
Message-Id: <20230810185452.24387-3-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230810185452.24387-1-phil@nwl.cc>
References: <20230810185452.24387-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If set, create rules using compat expressions where possible and disable
the bitwise expression avoidance introduced in 323259001d617 ("nft:
Optimize class-based IP prefix matches").

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-shared.c |  2 +-
 iptables/nft.c        | 10 ++++++----
 iptables/nft.h        |  1 +
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 34ca9d16569d0..5e0ca00e7dd36 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -198,7 +198,7 @@ void add_addr(struct nft_handle *h, struct nftnl_rule *r,
 
 	for (i = 0; i < len; i++) {
 		if (m[i] != 0xff) {
-			bitwise = m[i] != 0;
+			bitwise = h->compat || m[i] != 0;
 			break;
 		}
 	}
diff --git a/iptables/nft.c b/iptables/nft.c
index 1fc12b0c659c7..09ff9cf11e195 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1476,10 +1476,12 @@ int add_match(struct nft_handle *h, struct nft_rule_ctx *ctx,
 	case NFT_COMPAT_RULE_APPEND:
 	case NFT_COMPAT_RULE_INSERT:
 	case NFT_COMPAT_RULE_REPLACE:
-		if (!strcmp(m->u.user.name, "limit"))
-			return add_nft_limit(r, m);
-		else if (!strcmp(m->u.user.name, "among"))
+		if (!strcmp(m->u.user.name, "among"))
 			return add_nft_among(h, r, m);
+		else if (h->compat)
+			break;
+		else if (!strcmp(m->u.user.name, "limit"))
+			return add_nft_limit(r, m);
 		else if (!strcmp(m->u.user.name, "udp"))
 			return add_nft_udp(h, r, m);
 		else if (!strcmp(m->u.user.name, "tcp"))
@@ -1544,7 +1546,7 @@ int add_target(struct nft_handle *h, struct nftnl_rule *r,
 	struct nftnl_expr *expr;
 	int ret;
 
-	if (strcmp(t->u.user.name, "TRACE") == 0)
+	if (!h->compat && strcmp(t->u.user.name, "TRACE") == 0)
 		return add_meta_nftrace(r);
 
 	expr = nftnl_expr_alloc("target");
diff --git a/iptables/nft.h b/iptables/nft.h
index a89aff0af68d0..fb9fc81ea2704 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -111,6 +111,7 @@ struct nft_handle {
 	struct list_head	cmd_list;
 	bool			cache_init;
 	int			verbose;
+	bool			compat;
 
 	/* meta data, for error reporting */
 	struct {
-- 
2.40.0

