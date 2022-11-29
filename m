Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B884FC4321E
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Nov 2022 21:47:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236875AbiK2Vr5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:47:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236192AbiK2Vr5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2022 16:47:57 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA9263CEF
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2022 13:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YAWVzfZaeasr+AwR+MyvXxfzEdwzLh1Pxcv4AUjhFX4=; b=red4nIVv6x2vfNcSDYzWMHE0lz
        8WXrBHFAT8oehlakKTo1aD5yyZvxYINoU8Fj2U5dsW9LhXqB/CGQvAqlCu9Uu6cDgL/p2c0quS9w9
        OyVssLYIPC/N5S3W0U2eqpZwcIDknbeL2WzGxcf0eA+HO+Yu4mh7N3CRV7WkbOeFe/7OT4cfgzjom
        PNr086uV4rbVhGn+BD8AspGScQ5+f0giAcIXe78xAelhooe7GRL2dByj/9+QdhNHSdNRLI6UllrgM
        M1u5T5ZGD6lNo1M2sUfQr0xule8cx7rlGJH6ueTvUx30M/dvgafiTKCEughB48BY71YQ2N5u9HX/W
        1BceBaDA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1p08SI-00DjQp-J4
        for netfilter-devel@vger.kernel.org; Tue, 29 Nov 2022 21:47:54 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 v2 v2 01/34] ulogd: fix parse-error check
Date:   Tue, 29 Nov 2022 21:47:16 +0000
Message-Id: <20221129214749.247878-2-jeremy@azazel.net>
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

