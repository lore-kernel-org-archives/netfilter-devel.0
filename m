Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 020E7C4332F
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:14:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242950AbiDDMQc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242000AbiDDMQ1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:16:27 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2672213D03
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3WcZJPGQD0DJZmsmzl2xxAPXagzo7127gW1n6UrBCns=; b=ShJyDMht+ezLsO9UgHTLthHyim
        0EodEmjKP3UbiHyjbm6sCx9K8Vb1ZrJTj5AjUbL/N4uh2DdGAVoTjzkSpKKLykAIQYM9jpX7gTm5L
        /JONZbiSKu18aU4WuWJ6/a14hfSww+G1K/AUUTzeUgLmOUwJKOzIqUggrGR0z/PNsdXZ+vKxF5loK
        LsfNSv/1ylICf36dlKquWo6rINYDzftlEHHx8ey6Swy/NFbmcOGxKvHoz9zGDW6GTzIId9nEHI/AG
        ABY9n4Tmw5Wj9ul8Pv8nOaAfJwDGndD3pxBgFN1Ts4l4YtPUZnXApufJq2dTrHCd+k79saC+3Jn8j
        HIpyig9A==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLbI-007FTC-NY; Mon, 04 Apr 2022 13:14:28 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [nft PATCH v4 03/32] src: move `byteorder_names` array
Date:   Mon,  4 Apr 2022 13:13:41 +0100
Message-Id: <20220404121410.188509-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220404121410.188509-1-jeremy@azazel.net>
References: <20220404121410.188509-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It's useful for debugging, so move it out of evaluate.c to make it
available elsewhere.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/datatype.h | 6 ++++++
 src/evaluate.c     | 7 +------
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 0b90a33e4e64..8d774a91e350 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -119,6 +119,12 @@ enum byteorder {
 	BYTEORDER_BIG_ENDIAN,
 };
 
+static const char *const byteorder_names[] = {
+	[BYTEORDER_INVALID]             = "invalid",
+	[BYTEORDER_HOST_ENDIAN]         = "host endian",
+	[BYTEORDER_BIG_ENDIAN]          = "big endian",
+};
+
 struct expr;
 
 /**
diff --git a/src/evaluate.c b/src/evaluate.c
index 04d42b800103..be493f85010c 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -27,6 +27,7 @@
 #include <net/if.h>
 #include <errno.h>
 
+#include <datatype.h>
 #include <expression.h>
 #include <statement.h>
 #include <netlink.h>
@@ -40,12 +41,6 @@
 
 static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr);
 
-static const char * const byteorder_names[] = {
-	[BYTEORDER_INVALID]		= "invalid",
-	[BYTEORDER_HOST_ENDIAN]		= "host endian",
-	[BYTEORDER_BIG_ENDIAN]		= "big endian",
-};
-
 #define chain_error(ctx, s1, fmt, args...) \
 	__stmt_binary_error(ctx, &(s1)->location, NULL, fmt, ## args)
 #define monitor_error(ctx, s1, fmt, args...) \
-- 
2.35.1

