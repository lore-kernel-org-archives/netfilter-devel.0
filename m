Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FD9AC4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Nov 2022 22:27:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbiKUW1e (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Nov 2022 17:27:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbiKUW1c (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2022 17:27:32 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A09B1114C
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2022 14:27:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YAWVzfZaeasr+AwR+MyvXxfzEdwzLh1Pxcv4AUjhFX4=; b=Ax05ZOb0CZ7oGCzOhrTyaXdSkP
        OUiGOqc+M2lj4CvhhcQWE3Z3ghBA6bZ2K7eoqM9eSVRC9AkxeVXe7ynAPyuqK1Jp4OXe5TmNxgU+u
        7S534Sn8W2VnOsB+31lKOPFKc1lcuHA7EcWuPs0xKEXRetVsxTvTBRnCLeYLQ0HUHmJYDIkDp5zn0
        Rzd3/27kmVWSY659Ag/ykzoSkl+ybUABDuqEBSdt/ytf8/K/71yMeRAB5WWTJ34Qq/KTNVemvhwip
        vsmx9NBJ7+hs0wzyRH5M9qqDdYuGmAOHUGwnCl95P6U+KrdZIMz9kHXgTvoncs65K6YHnRuwkXyJu
        MGE+MtRA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oxFGB-005LgP-UR
        for netfilter-devel@vger.kernel.org; Mon, 21 Nov 2022 22:27:28 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 01/34] ulogd: fix parse-error check
Date:   Mon, 21 Nov 2022 22:25:38 +0000
Message-Id: <20221121222611.3914559-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221121222611.3914559-1-jeremy@azazel.net>
References: <20221121222611.3914559-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If `config_parse_file` returns `-ERRTOOLONG`, `config_errce` may
be NULL.  However, the calling function was checking whether
`config_errce->key` was NULL instead.

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

