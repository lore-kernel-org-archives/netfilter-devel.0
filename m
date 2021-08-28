Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0ADDC43216
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Aug 2021 19:40:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80B6660EBD
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Aug 2021 19:40:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbhH1Tlg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 28 Aug 2021 15:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbhH1Tle (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 28 Aug 2021 15:41:34 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD2EEC06179A
        for <netfilter-devel@vger.kernel.org>; Sat, 28 Aug 2021 12:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1NWa/yfYBgbEj5zv1rQHeyh1V4YOWng6X75oclEj0LY=; b=fH71zSCQW6HXn0Mizkr7/Q7Rnv
        5D+vaYDLuxuA3ms4Ip4/w4cTxAIsoG2L0jTADL4JihAaHWRLjQfILapzzCDcFvANDl2jhIQeMI41/
        mJv2GrvuF3A1ZCHzWDFY+tBwgPTzss4eRSHR8aAwhGX39GV80O9PlryRq30t/BXXB8dunm93hbDAX
        SbOafKi+Cn7YtOzRgo6HDLFlGrC1VqKOlsjwIe7w4Y1GIIR+WbXQoj51Xr2gc9Vuk0Te1gJ7oLuYE
        lofMCWqgKLzpqxrplR4avowH5pOComvg+3r5KbgMjnGDj6nz6YbZOHJzieAmjMaNBTT2x6xPFsaBE
        k3W8JCMQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mK4C1-00FeN7-L7; Sat, 28 Aug 2021 20:40:41 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnetfilter_log 3/6] doc: fix typo's in example.
Date:   Sat, 28 Aug 2021 20:38:21 +0100
Message-Id: <20210828193824.1288478-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210828193824.1288478-1-jeremy@azazel.net>
References: <20210828193824.1288478-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use the right group number in nflog_bind_group example.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/libnetfilter_log.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/libnetfilter_log.c b/src/libnetfilter_log.c
index 567049ccfb37..339f286f36bc 100644
--- a/src/libnetfilter_log.c
+++ b/src/libnetfilter_log.c
@@ -182,10 +182,10 @@ struct nfnl_handle *nflog_nfnlh(struct nflog_handle *h)
  *
  * Here's a little code snippet that binds to the group 100:
  * \verbatim
-	printf("binding this socket to group 0\n");
-	qh = nflog_bind_group(h, 0);
+	printf("binding this socket to group 100\n");
+	qh = nflog_bind_group(h, 100);
 	if (!qh) {
-		fprintf(stderr, "no handle for grup 0\n");
+		fprintf(stderr, "no handle for group 100\n");
 		exit(1);
 	}
 
-- 
2.33.0

