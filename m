Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC5E4C4708E
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Nov 2022 21:58:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236910AbiK2V6J (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:58:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237119AbiK2V6A (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2022 16:58:00 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2637F6F0DB
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2022 13:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DcUjKMupoQIExUat9/wsMdtWWnM0mvUAGnZo2aZAVCg=; b=pR2EzabVtM9Z69NqobsxA7F5jm
        KoX0IeitakBu9sAs8d5CyuA+yNi1UEh+7NGvk27g+/0wEiM28GGVMkzOP4o93hZxhdCHtbW0rVLh2
        rqMJ33SAZcf+xMKl7zxX8rHUbPmvobsjydDkreIwHcbD/OVXtne+mKZ6Xkp3faIc3faSbJW+Yxjlf
        6ntBODyUQeBwiZECHgqm0eoacFQih4Ucb54zWn9rKEMVQXTzUerE3epYdEeqyCdVAYRnuGAbCs7ae
        q2ro4pgwGN4sm0SuNXX5lhLQAqaxlqqOC2yeAAZNFirZ68ohMeag7c2RNWRThSAd+cr6hpk6nlZ3/
        NIAuT9fg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1p08SJ-00DjQp-TF
        for netfilter-devel@vger.kernel.org; Tue, 29 Nov 2022 21:47:56 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 v2 v2 12/34] conffile: replace malloc+strcpy with strdup
Date:   Tue, 29 Nov 2022 21:47:27 +0000
Message-Id: <20221129214749.247878-13-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221129214749.247878-1-jeremy@azazel.net>
References: <20221129214749.247878-1-jeremy@azazel.net>
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
 src/conffile.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/src/conffile.c b/src/conffile.c
index 8a208d6d8cfe..e58f54778e41 100644
--- a/src/conffile.c
+++ b/src/conffile.c
@@ -104,12 +104,10 @@ int config_register_file(const char *file)
 
 	pr_debug("%s: registered config file '%s'\n", __func__, file);
 
-	fname = malloc(strlen(file)+1);
+	fname = strdup(file);
 	if (!fname)
 		return -ERROOM;
 
-	strcpy(fname, file);
-
 	return 0;
 }
 
-- 
2.35.1

