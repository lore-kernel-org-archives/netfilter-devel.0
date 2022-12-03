Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FBA0C4332F
	for <netfilter-devel@archiver.kernel.org>; Sat,  3 Dec 2022 19:02:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiLCTCX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 3 Dec 2022 14:02:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiLCTCW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 3 Dec 2022 14:02:22 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4ED1C90B
        for <netfilter-devel@vger.kernel.org>; Sat,  3 Dec 2022 11:02:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dE6DqpCW13ZPM7Xi3YGxG8CRniylGGp8Kw2SxX2Igsk=; b=hrNbjdlIDcJaURkM+d8wLb+Cpo
        8jyhK1YHOUWw5ef6OzEpqs7KQwc0qpANJyC5SiWfrwsdh+d/G2U3k5Z7JdyAJeLtDqEfXHGsbRmb0
        1HhgWnNeOSXUDUgAzShKYD9EQjzcmtHjjbevk6Y9Hb7L/unyOf9uXssDtia7uZHysEU4Wmib9Y5gz
        lZeuUoVpLMjg3vmenaTpvMEvf/HtPTo4tvSerwgtd5eJ+wgF5skAvY6hzhhPuchUQcIfUMb3Sdsec
        Q92jCWai1OQB9l+K98f01P0C1tbpqf2RLWKeIWB5XtIiF+GrGlfN8cK2iN9NkeF8nUWpXbxPwyAgg
        IhhwXIOw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1p1XmE-000B5v-9x
        for netfilter-devel@vger.kernel.org; Sat, 03 Dec 2022 19:02:18 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 1/4] ulogd: fix parse-error check
Date:   Sat,  3 Dec 2022 19:02:09 +0000
Message-Id: <20221203190212.346490-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221203190212.346490-1-jeremy@azazel.net>
References: <20221203190212.346490-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If `config_parse_file` returns `-ERRTOOLONG`, `config_errce` may be
`NULL`.  However, the calling function checks whether
`config_errce->key` is `NULL` instead.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/ulogd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/ulogd.c b/src/ulogd.c
index b02f2602a895..8ea9793ec0fb 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -1134,7 +1134,7 @@ static int parse_conffile(const char *section, struct config_keyset *ce)
 				"section \"%s\" not found\n", section);
 			break;
 		case -ERRTOOLONG:
-			if (config_errce->key)
+			if (config_errce)
 				ulogd_log(ULOGD_ERROR,
 					  "string value too long for key \"%s\"\n",
 					  config_errce->key);
-- 
2.35.1

