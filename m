Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E6DFC4167B
	for <netfilter-devel@archiver.kernel.org>; Sun,  6 Dec 2020 10:14:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D868230FB
	for <netfilter-devel@archiver.kernel.org>; Sun,  6 Dec 2020 10:14:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbgLFKOZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 6 Dec 2020 05:14:25 -0500
Received: from mx1.riseup.net ([198.252.153.129]:57700 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbgLFKOZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 6 Dec 2020 05:14:25 -0500
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4Cpj2c4mLLzFfym;
        Sun,  6 Dec 2020 02:13:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1607249624; bh=XELxJt+FUejNqr2rSwwTE+Qo1anVFNXUxbmDQ/pff/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wt/fztZyvvs63aQFNp+gHNHDGb488X/+N22tmt1uIHWnutcvrHufF+9euQGD/cECZ
         NqIBFT3Z9hqGfxGzUIxz2ZJ4TyKuSSFbndBAno3jIdqqSFcRxPPaojcDmT4PuZuxYK
         i8Ic+XlcR3RNhD9DuSYPObP/BKqbBkYe+NQWhpxk=
X-Riseup-User-ID: 8D9CBF5EE29044F293B59B2DD408D8EB1C4F911BD22EBD4433E7E52E799D042B
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 4Cpj2b5hXYz8tKR;
        Sun,  6 Dec 2020 02:13:43 -0800 (PST)
From:   "Jose M. Guisado Gomez" <guigom@riseup.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables 2/2] monitor: fix formatting of if statements
Date:   Sun,  6 Dec 2020 11:12:34 +0100
Message-Id: <20201206101233.641-2-guigom@riseup.net>
In-Reply-To: <20201206101233.641-1-guigom@riseup.net>
References: <20201206101233.641-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Replace some "if(" introduced in cb7e02f4 by "if ("

Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
---
 src/monitor.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/src/monitor.c b/src/monitor.c
index 2b5325ea..af2998d4 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -225,7 +225,7 @@ static int netlink_events_table_cb(const struct nlmsghdr *nlh, int type,
 		break;
 	case NFTNL_OUTPUT_JSON:
 		monitor_print_table_json(monh, cmd, t);
-		if(!nft_output_echo(&monh->ctx->nft->output))
+		if (!nft_output_echo(&monh->ctx->nft->output))
 			nft_mon_print(monh, "\n");
 		break;
 	}
@@ -264,7 +264,7 @@ static int netlink_events_chain_cb(const struct nlmsghdr *nlh, int type,
 		break;
 	case NFTNL_OUTPUT_JSON:
 		monitor_print_chain_json(monh, cmd, c);
-		if(!nft_output_echo(&monh->ctx->nft->output))
+		if (!nft_output_echo(&monh->ctx->nft->output))
 			nft_mon_print(monh, "\n");
 		break;
 	}
@@ -312,7 +312,7 @@ static int netlink_events_set_cb(const struct nlmsghdr *nlh, int type,
 		break;
 	case NFTNL_OUTPUT_JSON:
 		monitor_print_set_json(monh, cmd, set);
-		if(!nft_output_echo(&monh->ctx->nft->output))
+		if (!nft_output_echo(&monh->ctx->nft->output))
 			nft_mon_print(monh, "\n");
 		break;
 	}
@@ -457,7 +457,7 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 		/* prevent set_free() from trying to free those */
 		dummyset->handle.set.name = NULL;
 		dummyset->handle.table.name = NULL;
-		if(!nft_output_echo(&monh->ctx->nft->output))
+		if (!nft_output_echo(&monh->ctx->nft->output))
 			nft_mon_print(monh, "\n");
 		break;
 	}
@@ -504,7 +504,7 @@ static int netlink_events_obj_cb(const struct nlmsghdr *nlh, int type,
 		break;
 	case NFTNL_OUTPUT_JSON:
 		monitor_print_obj_json(monh, cmd, obj);
-		if(!nft_output_echo(&monh->ctx->nft->output))
+		if (!nft_output_echo(&monh->ctx->nft->output))
 			nft_mon_print(monh, "\n");
 		break;
 	}
@@ -556,7 +556,7 @@ static int netlink_events_rule_cb(const struct nlmsghdr *nlh, int type,
 		break;
 	case NFTNL_OUTPUT_JSON:
 		monitor_print_rule_json(monh, cmd, r);
-		if(!nft_output_echo(&monh->ctx->nft->output))
+		if (!nft_output_echo(&monh->ctx->nft->output))
 			nft_mon_print(monh, "\n");
 		break;
 	}
-- 
2.28.0

