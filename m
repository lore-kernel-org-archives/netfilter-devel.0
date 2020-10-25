Return-Path: <SRS0=hvDf=EA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A955C5DF9D
	for <netfilter-devel@archiver.kernel.org>; Sun, 25 Oct 2020 13:16:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C92B120720
	for <netfilter-devel@archiver.kernel.org>; Sun, 25 Oct 2020 13:16:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="J2lNaz9y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1416225AbgJYNQK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 25 Oct 2020 09:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1416220AbgJYNQI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Oct 2020 09:16:08 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD57BC0613CE
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Oct 2020 06:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=mXCIbD64Gp3ZOJcmLwV6Yv6rNpKIA+dFP5RtkumGSlc=; b=J2lNaz9yih6cTzEOIMHMPd2bcv
        xlt6iIE65bDygcSA8ohtt76bafNHeXwNlSZ9WLg5sSbIEannoeQsXVLCRlBZM6lNjUzflop+feUXz
        o3M4gucYbYNvGyU3g3iFOk1U3uddd26HrtDjcH8my2cV7zXptn+pKD/qhvEI8sQURRBy93wwfe8fw
        0jqHugMROCzX9JFsFEuC8gEYJ68uq3E86lkAUmqht2AR1sMURxbBTaxb5eQ30pAeRqxejqoCZYOOd
        53w2ns5h5el5C3K5X9fqz0QqYBH8dyhaOcEq01mjWUc2QOXnRNf7nkvw68BQqUJd+IhZzwhFQ4bgM
        EhKSXZ2A==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kWfsU-0001SE-6t; Sun, 25 Oct 2020 13:16:06 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons v2 06/13] pknock: pknlusr: use macro to define inet_ntop buffer size.
Date:   Sun, 25 Oct 2020 13:15:52 +0000
Message-Id: <20201025131559.920038-8-jeremy@azazel.net>
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

POSIX provides a macro to define the minimum length required, so let's
use it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/pknock/pknlusr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/pknock/pknlusr.c b/extensions/pknock/pknlusr.c
index 252fd42ffecd..9f11250510a1 100644
--- a/extensions/pknock/pknlusr.c
+++ b/extensions/pknock/pknlusr.c
@@ -53,7 +53,7 @@ int main(void)
 	while(1) {
 
 		const char *ip;
-		char ipbuf[48];
+		char ipbuf[INET_ADDRSTRLEN];
 
 		memset(nlmsg, 0, nlmsg_size);
 
-- 
2.28.0

