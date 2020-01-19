Return-Path: <SRS0=vOmJ=3I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10DA8C33CB7
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jan 2020 22:57:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D29D520678
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jan 2020 22:57:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="EuXgtNn6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbgASW5M (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 19 Jan 2020 17:57:12 -0500
Received: from kadath.azazel.net ([81.187.231.250]:56580 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728855AbgASW5L (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Jan 2020 17:57:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4UgfGNOvAnEkVa1oYgfDMZ+bKSypTjVKKOInNkEErvs=; b=EuXgtNn6JOkQ5SsYv52j6Ah2dc
        3IN82gOkI002semIMYA1iKlgQaJgU4/v92dBP6nUaddq1qpFNUN2c4WPPczpaea9j6wHjJLcnTIXG
        Qr3vOs1H0k36VKCZHC5yFhPPGaxohvqSE+QNLY2RIZJv+CmkbS1WG1uV5No+XLGjQlJetNA5H2G5j
        YI6xsXg26eUOthcDUXvqDW9UoikE71Y26KByO7GTQxoQWfggP7KJIJV16Amm2Eaf1FiaJMF+kyRFo
        9/MQLMIBNfBzUfthT+TdZ40Lww7chbsiJGXqO4mI2aNRSNo1K1AW5MM6aF1IXeVJt7Z/2NkkpSt4y
        rWokrFuA==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1itJVG-0006wh-S7
        for netfilter-devel@vger.kernel.org; Sun, 19 Jan 2020 22:57:10 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v3 3/9] netlink_delinearize: fix typo.
Date:   Sun, 19 Jan 2020 22:57:04 +0000
Message-Id: <20200119225710.222976-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200119225710.222976-1-jeremy@azazel.net>
References: <20200119225710.222976-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

s/Of/If/ in comment describing function.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/netlink_delinearize.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 387e4b046c6b..8b9b5c808384 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2352,7 +2352,7 @@ static void stmt_payload_binop_pp(struct rule_pp_ctx *ctx, struct expr *binop)
  * the original payload expression because it has an odd size or
  * a non-byte divisible offset/length.
  *
- * Of that was the case, the 'value' expression is not a value but
+ * If that was the case, the 'value' expression is not a value but
  * a binop expression with a munged payload expression on the left
  * and a mask to clear the real payload offset/length.
  *
-- 
2.24.1

