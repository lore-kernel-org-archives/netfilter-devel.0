Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 366B8C04FE3
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Aug 2021 19:40:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A34560EBC
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Aug 2021 19:40:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbhH1Tlh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 28 Aug 2021 15:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbhH1Tle (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 28 Aug 2021 15:41:34 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE75C0617AD
        for <netfilter-devel@vger.kernel.org>; Sat, 28 Aug 2021 12:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/p5GdBJw1itKDswzvW8WXsg/43sfNEJQs+TTJxcAbEA=; b=SxKh3DpO9P2N29XBW50CRwzgJc
        MjhdTfTwgpPmz2ObTL118kzyVuzEhT5AXRzV1gSb70mN/cWNlliV//EXAEZvgjBogz5BQkc9soe6D
        j1kDc1uWGXrbhPUSBsWu9Aww5vYUZU0wLTC4PtHqQM+L52yAkVhCYP1D65FkG2iZKulup7GMxI166
        tB2Epv0FscNO1+KLmRSlkqmBzRKkoWH1mYNKw9U3wmNoII0n1AWw6Gu8CSxcAOUGrvylSSx3Ku6Qh
        uZspNZbur2I5HELcq/KnJLkumm7XZNW2krMftAwq6YBDaGrPuBYxiR7YizYI3rch0d5N8PpcG/ftY
        9k2NrvoA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mK4C1-00FeN7-Ta; Sat, 28 Aug 2021 20:40:41 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnetfilter_log 5/6] libipulog: use correct index to find attribute in packet.
Date:   Sat, 28 Aug 2021 20:38:23 +0100
Message-Id: <20210828193824.1288478-6-jeremy@azazel.net>
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

The time-stamp is at `NFULA_TIMESTAMP-1` not `NFULA_TIMESTAMP`.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/libipulog_compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/libipulog_compat.c b/src/libipulog_compat.c
index 99cd86622d9b..bf957274ca22 100644
--- a/src/libipulog_compat.c
+++ b/src/libipulog_compat.c
@@ -158,7 +158,7 @@ next_msg:	printf("next\n");
 	else
 		h->upmsg.mark = 0;
 
-	if (tb[NFULA_TIMESTAMP]) {
+	if (tb[NFULA_TIMESTAMP-1]) {
 		/* FIXME: 64bit network-to-host */
 		h->upmsg.timestamp_sec = h->upmsg.timestamp_usec = 0;
 	} else
-- 
2.33.0

