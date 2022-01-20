Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B604C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jan 2022 10:54:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiATKyk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jan 2022 05:54:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiATKyk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jan 2022 05:54:40 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48EEAC061574
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jan 2022 02:54:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Edb2hixrkcStKLUAyZmmpBTazqHXVxTl3IePI+myMdI=; b=IAQY4ZXDit57QzLPFntMg914Hh
        pN/GNhFOO1mwmaDkp2q/ns+2bUzo7bD5ZTt8kfvBjoECA365NGH7ZnqaHrgdhbwrMNuuhP2J8hmbB
        ywH/uYsMLZulZSk+Xz6Fma8os20poxcS5ypTvg8ou2e/1D9YHfDhuDfQsa20PvJCoB0wUCnTGWNpB
        QXG+h7DeLdXTcSSPD75koxKtlGw2JpClPnrEJjlL/R+QPeG7t0wkvnuiMGXbR/GWPP4NVE//H88pF
        gtfHanAHqDToR/BBz4+ZwNrbrqTPYvnB4EACzu2q/k8mXNCZ0d21Kns0bNP7VBPIIBpolh7mquMSi
        HJMdVPSw==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nAV5R-00DGNy-U3
        for netfilter-devel@vger.kernel.org; Thu, 20 Jan 2022 10:54:38 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [iptables PATCH] extensions: libxt_NFLOG: fix typo
Date:   Thu, 20 Jan 2022 10:54:05 +0000
Message-Id: <20220120105405.2738662-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The deprecation warning for `--nflog-range` contains a spelling mistake.
Fix it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/libxt_NFLOG.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
index 02a1b4aa35a3..13212a6bba82 100644
--- a/extensions/libxt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -69,7 +69,7 @@ static void NFLOG_check(struct xt_fcheck_call *cb)
 
 	if (cb->xflags & F_RANGE)
 		fprintf(stderr, "warn: --nflog-range has never worked and is no"
-			" longer supported, please use --nflog-size insted\n");
+			" longer supported, please use --nflog-size instead\n");
 
 	if (cb->xflags & F_SIZE)
 		info->flags |= XT_NFLOG_F_COPY_LEN;
-- 
2.34.1

