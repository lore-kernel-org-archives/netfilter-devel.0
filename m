Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F2F1C43217
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Dec 2021 18:55:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbhLKSzd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Dec 2021 13:55:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbhLKSzc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Dec 2021 13:55:32 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64454C061714
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Dec 2021 10:55:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=mVgWcGrYGrONA9HdVTE32o6Nh6aGnDHwkZQkU6rh5H8=; b=W+v5L45PcKqosLsm2umoSCRu0b
        Yt950r+T8Fo9j4u3VWD2BL0KKMPc4B2tDB4zNMzGTifrR9kW9/SzIXVpBxJiOWy8g9Bw4l+iSCLHz
        vG0W4hyagVwPE/o9xNp3tl8+INyF+SPEyLdObvl+EwYWa2c/6Kd0oDJg/nSbuOe4d9+UdkmfElLOJ
        tsNm2bu7S3w7BiiB8wEswXjMKU5p5WKI8JvK/TkMKPpl3rUh+jr/j8drH+9qXtTjADSLxHzDRi9Db
        Qvk6/Ke4SEzGv563xEVkIjtDWFTOLJE5RUwsLxSVVYehx7Q77cE7pFdO9Lu6ZSDhLyYRFMTKma6bR
        MeNMCFKQ==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mw7Ws-004cqg-5Y
        for netfilter-devel@vger.kernel.org; Sat, 11 Dec 2021 18:55:30 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nft PATCH 2/3] evaluate: correct typo's
Date:   Sat, 11 Dec 2021 18:55:24 +0000
Message-Id: <20211211185525.20527-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211211185525.20527-1-jeremy@azazel.net>
References: <20211211185525.20527-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There are a couple of mistakes in comments.  Fix them.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/evaluate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 49fb8f84fe76..4d4dcc2e3d08 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -599,7 +599,7 @@ static int expr_evaluate_exthdr(struct eval_ctx *ctx, struct expr **exprp)
 
 /* dependency supersede.
  *
- * 'inet' is a 'phony' l2 dependency used by NFPROTO_INET to fulfill network
+ * 'inet' is a 'phony' l2 dependency used by NFPROTO_INET to fulfil network
  * header dependency, i.e. ensure that 'ip saddr 1.2.3.4' only sees ip headers.
  *
  * If a match expression that depends on a particular L2 header, e.g. ethernet,
@@ -611,7 +611,7 @@ static int expr_evaluate_exthdr(struct eval_ctx *ctx, struct expr **exprp)
  * Example: inet filter in ip saddr 1.2.3.4 ether saddr a:b:c:d:e:f
  *
  * ip saddr adds meta dependency on ipv4 packets
- * ether saddr adds another dependeny on ethernet frames.
+ * ether saddr adds another dependency on ethernet frames.
  */
 static int meta_iiftype_gen_dependency(struct eval_ctx *ctx,
 				       struct expr *payload, struct stmt **res)
-- 
2.33.0

