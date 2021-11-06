Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A971C4332F
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 16:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3598F61165
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 16:50:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbhKFQw4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 12:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234628AbhKFQwt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 12:52:49 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E927FC061746
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 09:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sxURAdyI3uDTOS5xqRBKINg72Q9a33k6WIb54ylTI/k=; b=pC6li+MVjC3ljXsk5o79uJc4gh
        jS1tqQEGwxpE7WkNFGo5ebxs1jq9t17K7yKEpMr6TBPBl1c7yJxnCA7mpYIgjA1qJXm6I9CR//KJg
        AqNWLe3a5atvvWU5Ishon9VPHBQO7SR9vERTw8WSVV4msY7H6UqfuwYArV3cenmXPPw8JESnsUYB4
        bZPm9SkFbAkuTz4SRawlT3yDtQnPlvEoDvqoQyez2QR9JYxBfpUTxGlU1T9dvmp63r9meXE0xf0pV
        D3QBs28bHCCoPrdGITU6ASJq2ZfB08Vm2iRIpvCz49BUBp0FhNwPfwvetFHSDCLY2TZbZVDe6olhv
        BbmW01dg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mjOtJ-004m1E-8C
        for netfilter-devel@vger.kernel.org; Sat, 06 Nov 2021 16:50:05 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v2 03/27] ulog: fix order of log arguments
Date:   Sat,  6 Nov 2021 16:49:29 +0000
Message-Id: <20211106164953.130024-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211106164953.130024-1-jeremy@azazel.net>
References: <20211106164953.130024-1-jeremy@azazel.net>
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

