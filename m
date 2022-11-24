Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E97E4C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Nov 2022 16:57:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiKXQ5V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Nov 2022 11:57:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiKXQ5N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2022 11:57:13 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327373D900
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2022 08:57:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=H3OGmLvP5XsjAveY5iOug6KchuU3u52earwFprGT0FQ=; b=jelN775jlPOF3P6iWJ7Dh9e0B8
        7PpS1d0HJtok7OxmJzdA7GE+hRraJ2/A99fueT5bKKO7Xf8+m2vMwZplkHQU12h8MArujeFa+HUiC
        EEUk6eSr5/gQE2U8n8B3hgINoRxLfySPG+4X2dxF+D4HwqhwW23wJ1uAmekesxI5NpaKZZaSvDR/H
        agRmhcfrdjD4trenDpSwX0mZceOYBFcrhHPd06gfvHiazqFf5EKy3zylELhI4zjgU54IgzRDXg5YU
        B6JNmPIzdL+7iYUWA8vrBEb+6e7MybMEZRdtM/6/JDlCTyrBCpQCOB8Lg5beDCMriDmUuQKPX2pfx
        pmsQw+MQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oyFXD-0000rB-JC; Thu, 24 Nov 2022 17:57:11 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [nft PATCH 4/4] xt: Fall back to generic printing from translation
Date:   Thu, 24 Nov 2022 17:56:41 +0100
Message-Id: <20221124165641.26921-5-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221124165641.26921-1-phil@nwl.cc>
References: <20221124165641.26921-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If translation is not available or fails, print the generic format
instead of calling the print callback (which does not respect
output_fp) or silently failing.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/xt.c | 31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/src/xt.c b/src/xt.c
index 12b52aa33bc30..b75c94e856ca7 100644
--- a/src/xt.c
+++ b/src/xt.c
@@ -34,6 +34,12 @@ static void *xt_entry_alloc(const struct xt_stmt *xt, uint32_t af);
 
 void xt_stmt_xlate(const struct stmt *stmt, struct output_ctx *octx)
 {
+	static const char *typename[NFT_XT_MAX] = {
+		[NFT_XT_MATCH]		= "match",
+		[NFT_XT_TARGET]		= "target",
+		[NFT_XT_WATCHER]	= "watcher",
+	};
+	int rc = 0;
 #ifdef HAVE_LIBXTABLES
 	struct xt_xlate *xl = xt_xlate_alloc(10240);
 	struct xtables_target *tg;
@@ -69,11 +75,7 @@ void xt_stmt_xlate(const struct stmt *stmt, struct output_ctx *octx)
 				.numeric        = 1,
 			};
 
-			mt->xlate(xl, &params);
-			nft_print(octx, "%s", xt_xlate_get(xl));
-		} else if (mt->print) {
-			printf("#");
-			mt->print(&entry, m, 0);
+			rc = mt->xlate(xl, &params);
 		}
 		xfree(m);
 		break;
@@ -102,27 +104,20 @@ void xt_stmt_xlate(const struct stmt *stmt, struct output_ctx *octx)
 				.numeric        = 1,
 			};
 
-			tg->xlate(xl, &params);
-			nft_print(octx, "%s", xt_xlate_get(xl));
-		} else if (tg->print) {
-			printf("#");
-			tg->print(NULL, t, 0);
+			rc = tg->xlate(xl, &params);
 		}
 		xfree(t);
 		break;
 	}
 
+	if (rc == 1)
+		nft_print(octx, "%s", xt_xlate_get(xl));
 	xt_xlate_free(xl);
 	xfree(entry);
-#else
-	static const char *typename[NFT_XT_MAX] = {
-		[NFT_XT_MATCH]		= "match",
-		[NFT_XT_TARGET]		= "target",
-		[NFT_XT_WATCHER]	= "watcher",
-	};
-
-	nft_print(octx, "xt %s %s", typename[stmt->xt.type], stmt->xt.name);
 #endif
+	if (!rc)
+		nft_print(octx, "xt %s %s",
+			  typename[stmt->xt.type], stmt->xt.name);
 }
 
 void xt_stmt_destroy(struct stmt *stmt)
-- 
2.38.0

