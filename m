Return-Path: <SRS0=mMMR=27=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 655C3C47409
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 12:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E52F20838
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 12:38:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="ThL32ME3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbgAJMiI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Jan 2020 07:38:08 -0500
Received: from kadath.azazel.net ([81.187.231.250]:39858 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728159AbgAJMiI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Jan 2020 07:38:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4UgfGNOvAnEkVa1oYgfDMZ+bKSypTjVKKOInNkEErvs=; b=ThL32ME32AAg4c4DNsXldk7f7l
        e55LofOhk1t+Til/3zfrma4jYY1EmhhaAGaD5LwV2yiTBE5VzApQjKlohY51Aj1PpzyhVVT5VdtkV
        OxxxpGb26ZwFei9jlvt0kmOAdvZ49pOTSevqRIXgzYZ11DmFmrosPbLjd0lUP7nIGND0OGVzUYOiK
        /BEf1q6v/fiXFs51i2/Uxv9d75g8vm+wxwVT266VjdyVwS6SsIgN41+c0PnzrQ+nrQq8fzB/Q1dFg
        IjwHyNTufNVYl3Upy2IVYNkz3Md8uxQN4sGzwxNI4AxDwUYUoiPIy86WdXgFMGHGtqktsVOPIPq1h
        1YrUyfaA==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iptYF-0003im-1g
        for netfilter-devel@vger.kernel.org; Fri, 10 Jan 2020 12:38:07 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 3/7] netlink_delinearize: fix typo.
Date:   Fri, 10 Jan 2020 12:38:02 +0000
Message-Id: <20200110123806.106546-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200110123806.106546-1-jeremy@azazel.net>
References: <20200110123806.106546-1-jeremy@azazel.net>
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

