Return-Path: <SRS0=hvDf=EA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42917C388F7
	for <netfilter-devel@archiver.kernel.org>; Sun, 25 Oct 2020 13:17:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 011FB20720
	for <netfilter-devel@archiver.kernel.org>; Sun, 25 Oct 2020 13:17:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="PWLSdH0+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1416234AbgJYNRV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 25 Oct 2020 09:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2894311AbgJYNRV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Oct 2020 09:17:21 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14915C0613CE
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Oct 2020 06:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QCvr9eCrlqMIls1W+V4soEUo8q79TUK7H+mi1rhsHp0=; b=PWLSdH0+q+Kno/p3HlchIiuW0m
        U644J4sv7/44Sh3owxHgyJOt1LLn0PSke7bzAg7grLZfogd1t0xhvHiXXGM/aOoc4wou36SZrTsus
        fL6ZPCXvrj1HEjr7FbUsP4Lqw3FR54f9LZ26eQJK6VELndQRxGFsfDhTt/xTbf1bWWo/EGUt/Y+xV
        JkWTVjqr99DZfkUQJWo5thy/zkSzWjxLRQOWwwywpg4HeDq8uw80qa5yccQbpY8/EYV77xomuado8
        rNQAAOS2oZ9unN1k2JbdD1RTJbAqzw0fUGz4a0rlkUKWs4FoUHSaACEeLRRx4MJt0cAeFNqB4FKCw
        szqlaW1w==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kWfsW-0001SE-A8; Sun, 25 Oct 2020 13:16:08 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons v2 10/13] pknock: xt_pknock: use IS_ENABLED.
Date:   Sun, 25 Oct 2020 13:15:56 +0000
Message-Id: <20201025131559.920038-12-jeremy@azazel.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201025131559.920038-1-jeremy@azazel.net>
References: <20201025131559.920038-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It's more succinct than checking whether CONFIG_BLAH or
CONFIG_BLAH_MODULE are defined.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/pknock/xt_pknock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/pknock/xt_pknock.c b/extensions/pknock/xt_pknock.c
index a9df420cc75e..ba8161517d27 100644
--- a/extensions/pknock/xt_pknock.c
+++ b/extensions/pknock/xt_pknock.c
@@ -677,7 +677,7 @@ static bool
 msg_to_userspace_nl(const struct xt_pknock_mtinfo *info,
                 const struct peer *peer, int multicast_group)
 {
-#if defined(CONFIG_CONNECTOR) || defined(CONFIG_CONNECTOR_MODULE)
+#if IS_ENABLED(CONFIG_CONNECTOR)
 	struct cn_msg *m;
 	struct xt_pknock_nl_msg msg;
 
@@ -1101,7 +1101,7 @@ static struct xt_match xt_pknock_mt_reg __read_mostly = {
 
 static int __init xt_pknock_mt_init(void)
 {
-#if !defined(CONFIG_CONNECTOR) && !defined(CONFIG_CONNECTOR_MODULE)
+#if !IS_ENABLED(CONFIG_CONNECTOR)
 	if (nl_multicast_group != -1)
 		pr_info("CONFIG_CONNECTOR not present; "
 		        "netlink messages disabled\n");
-- 
2.28.0

