Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0D4AC46467
	for <netfilter-devel@archiver.kernel.org>; Sun, 27 Nov 2022 00:23:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiK0AXZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 26 Nov 2022 19:23:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiK0AXY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 26 Nov 2022 19:23:24 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC93DF09
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Nov 2022 16:23:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8qKGulmiuCI3T8wnDIozstdFRMeWyQn/5yHZebBv1jw=; b=q/vAXA8NksxAYHVrxc9xpjv+4u
        tR+76XLeDNg+C3uHuDXV+qsIvWdR1KQYfv1SVCNTvd7NKUsYMwtVYLeHR+X1YO8omxm+avHiyPZer
        xzxGmt1bOefcDh3FykIHY0MrNewZ2g2aHqmN7fyET3Mnnadx2aSh/nAWejGgjl//iJCQUdHMb7nVw
        2TJcQrkUjiUNhxkUUH7OhvKOu9uKAwdZcI0f0fcFQ9t9uGaki3m0qwYtKZDP+CCjCDdDlCqg6zVG+
        1nQFeC1b2BY3C58rHqRcV8Q+XzjeYd/LsFEpK620sD6QTh2lN7arALOhvINMdNQ8CnigTTNdCyisL
        vthi+aUQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oz5S2-00Aj1L-Qt; Sun, 27 Nov 2022 00:23:18 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Robert O'Brien <robrien@foxtrot-research.com>
Subject: [PATCH ulogd2 1/3] filter: IP2BIN: correct spelling of variable
Date:   Sun, 27 Nov 2022 00:22:58 +0000
Message-Id: <20221127002300.191936-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221127002300.191936-1-jeremy@azazel.net>
References: <20221127002300.191936-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 filter/ulogd_filter_IP2BIN.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/filter/ulogd_filter_IP2BIN.c b/filter/ulogd_filter_IP2BIN.c
index 2172d93506d5..ee1238ff4940 100644
--- a/filter/ulogd_filter_IP2BIN.c
+++ b/filter/ulogd_filter_IP2BIN.c
@@ -218,7 +218,7 @@ static int interp_ip2bin(struct ulogd_pluginstance *pi)
 	return ULOGD_IRET_OK;
 }
 
-static struct ulogd_plugin ip2bin_pluging = {
+static struct ulogd_plugin ip2bin_plugin = {
 	.name = "IP2BIN",
 	.input = {
 		.keys = ip2bin_inp,
@@ -238,5 +238,5 @@ void __attribute__ ((constructor)) init(void);
 
 void init(void)
 {
-	ulogd_register_plugin(&ip2bin_pluging);
+	ulogd_register_plugin(&ip2bin_plugin);
 }
-- 
2.35.1

