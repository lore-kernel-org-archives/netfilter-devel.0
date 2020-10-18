Return-Path: <SRS0=5q/u=DZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 514B2C433E7
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Oct 2020 15:30:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F96621D7F
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Oct 2020 15:30:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="KgwEuhtu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbgJRPaf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 18 Oct 2020 11:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbgJRPae (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Oct 2020 11:30:34 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD45C061755
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Oct 2020 08:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IAHW35eluMgU1sIKmtS9UP0LeKIu7FJYWwvNCJyX/0c=; b=KgwEuhtuUc0G43RYU8i+AgW/20
        5Gw372mE8d04tan/17UyBSinbBf5PXsKkSFhF9XZNQuDDCjspqBZ9OcyvEtZDaV5JXYoqdQwLWA8r
        iyjDY1iLj6EnQLxuGKhLPWfmotv1sZ3JQ9QhrobG8X4xNUu34oMfD7QZxHDT0/fPC93zZo13WsukK
        mYZFPzQNPOsm49ogrtXJ5U4j3DUW5+AIeMuw32xMLawcP/Yy6eJFxSk+v8JD1kqvZH7lXkYM44+fV
        rS6m8TxZbPbciX+0sIUZ8wwsh7oGnzwdwvl3cSm9Sxk6PqsZZlm3cMIJ9vT+dU2RBKPfcRFASG+Um
        EpsxPhLA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kUAdi-0007kg-Bm; Sun, 18 Oct 2020 16:30:30 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH] docs: nf_flowtable: fix typo.
Date:   Sun, 18 Oct 2020 16:30:19 +0100
Message-Id: <20201018153019.350400-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

"mailined" should be "mainlined."

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 Documentation/networking/nf_flowtable.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/nf_flowtable.rst b/Documentation/networking/nf_flowtable.rst
index b6e1fa141aae..6cdf9a1724b6 100644
--- a/Documentation/networking/nf_flowtable.rst
+++ b/Documentation/networking/nf_flowtable.rst
@@ -109,7 +109,7 @@ More reading
 This documentation is based on the LWN.net articles [1]_\ [2]_. Rafal Milecki
 also made a very complete and comprehensive summary called "A state of network
 acceleration" that describes how things were before this infrastructure was
-mailined [3]_ and it also makes a rough summary of this work [4]_.
+mainlined [3]_ and it also makes a rough summary of this work [4]_.
 
 .. [1] https://lwn.net/Articles/738214/
 .. [2] https://lwn.net/Articles/742164/
-- 
2.28.0

