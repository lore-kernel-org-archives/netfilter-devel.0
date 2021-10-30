Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00197C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 16:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9AFE60FC0
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 16:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhJ3QrH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 12:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbhJ3QrG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 12:47:06 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687C7C061746
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 09:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sxURAdyI3uDTOS5xqRBKINg72Q9a33k6WIb54ylTI/k=; b=GVr0ST2OUxxPUU1re3QS27HvOm
        4IcCQ+095eOKfiCBdNjYJDp/SKgAIV517fdYx59labBwiC3E7NdtX7XYknKcJs1ryaiEAN7YLpA9Q
        oiUmaMEbdY1H/Sg8FzkYVWYGA2V3Aq8zAxDG/0HqB4cbV4vtnUOWQkl9J2XSGVuaxKIdgp8ME45vU
        2OdXFak7yTj78YeB88MMkgO5nQTYWuoLS0CC2IGauFtcEKyoqzxYmzcCz5HW5CHHOndC5uhgQCO45
        j/Ky+LAu0Y4Wn0BnaBBtRL8HwH80MMOvXGAygpSch9Svd/tgq0r9ERijA/QK0eDYioWuPwFRm/gAb
        qie5APag==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgrT8-00AFgT-77
        for netfilter-devel@vger.kernel.org; Sat, 30 Oct 2021 17:44:34 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 03/26] ulog: fix order of log arguments
Date:   Sat, 30 Oct 2021 17:44:09 +0100
Message-Id: <20211030164432.1140896-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211030164432.1140896-1-jeremy@azazel.net>
References: <20211030164432.1140896-1-jeremy@azazel.net>
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
 src/ulogd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/ulogd.c b/src/ulogd.c
index a31b35592a87..97da4fc0018f 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -1569,7 +1569,7 @@ int main(int argc, char* argv[])
 	if (daemonize){
 		if (daemon(0, 0) < 0) {
 			ulogd_log(ULOGD_FATAL, "can't daemonize: %s (%d)\n",
-				  errno, strerror(errno));
+				  strerror(errno), errno);
 			warn_and_exit(daemonize);
 		}
 	}
-- 
2.33.0

