Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E1ADC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:29:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344614AbiDDMa5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345292AbiDDMaw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:30:52 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B166F120AA
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=RSCsmFBuHiJPLp87H8UgZuGFQX5ePdu6FWkV/NuItyY=; b=KQjn6FuZfA9/+Pb2UcxMNGQUBQ
        wcX4uD6lhpG61Cc1xFyH1dnJZ/HhS7CBjZU3fwqSSwTlYK7YnsZrgKv8C8OGuA5IU1vFd+YlDPvV+
        zgSIeETHBIZSWirJIHFqvOub2FEVeSV/rcT6r8pBZitfsBfoalq4+rVDM7nJ5FGeWKzEfODvaYuSe
        j+NPz3Ce1tCkFJcywWqji5gUCnaOZidFA5ddU2vrQdbGVG3ZHFXkqGaT2wBOjORDymKWkCh3mdihl
        1P+k9uV8TFWcD2n3WJAnQ3UNH91lYnVFaPxj6edsHoaE0fIWlWb/TzpnzyJYbrnw+S++3qqgU0501
        h+NNd1jw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLbJ-007FTC-HU; Mon, 04 Apr 2022 13:14:29 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [nft PATCH v4 12/32] payload: set byte-order when completing expression
Date:   Mon,  4 Apr 2022 13:13:50 +0100
Message-Id: <20220404121410.188509-13-jeremy@azazel.net>
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

`payload_expr_complete` is called during netlink delinearization to fill
in missing fields in the payload expression.  However, the byte-order
was not being set.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/payload.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/payload.c b/src/payload.c
index f433c38421a4..e8fcd95d4bbe 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -857,6 +857,7 @@ void payload_expr_complete(struct expr *expr, const struct proto_ctx *ctx)
 			continue;
 
 		expr->dtype	   = tmpl->dtype;
+		expr->byteorder	   = tmpl->byteorder;
 		expr->payload.desc = desc;
 		expr->payload.tmpl = tmpl;
 		return;
-- 
2.35.1

