Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAB7EC63798
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Nov 2020 14:05:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4802120789
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Nov 2020 14:05:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="aXx8HtMt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgKVOFi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Nov 2020 09:05:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727876AbgKVOFg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Nov 2020 09:05:36 -0500
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 411D1C061A4C
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Nov 2020 06:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=il/CPPwUrGbQYeXmbvAXy9sjzAPQafR/BMH6uONb8xM=; b=aXx8HtMtKPQSQ2ukNoNLemzN+B
        94rIP7ssNg3nhPC7TTmFiCuNEH86h3dE/6uT+I+Ev1+2rQ08x8xoQHt5uavnK7c9vjbadIS6QdyFn
        abnfjhmlYqEMbxUfRRXJ91NGP3gKaKq2oPYKfcVF5D9vWmeoEXfo7FU1voJfQhKVZB69Ft514A9Tk
        9nz8R5Vzm55ukoXICnhOx4OP1Wuu/eX/J6lRPVIuGOmJy0KLAesgfGckw/T70gdBmyan0VPd6mFI3
        1cKO0H31uyPta8R+VbIXriw5KFJbf8YeQwxsy0T1yjzLRf3j6MWfeTmKNO/wKcug41hrTMBhfTcaU
        NjGBSBpQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kgpzi-0002wq-Hm; Sun, 22 Nov 2020 14:05:34 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 4/4] geoip: use correct download URL for MaxMind DB's.
Date:   Sun, 22 Nov 2020 14:05:30 +0000
Message-Id: <20201122140530.250248-5-jeremy@azazel.net>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201122140530.250248-1-jeremy@azazel.net>
References: <20201122140530.250248-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The download URL for the GeoLite2 DB's has changed and includes a
licence-key.  Update the download script to read the key from file or
stdin and use the correct URL.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 geoip/xt_geoip_dl_maxmind | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/geoip/xt_geoip_dl_maxmind b/geoip/xt_geoip_dl_maxmind
index 1de60442a804..d5640336c1c0 100755
--- a/geoip/xt_geoip_dl_maxmind
+++ b/geoip/xt_geoip_dl_maxmind
@@ -1,7 +1,16 @@
 #!/bin/sh
 
+if [ $# -eq 1 ]; then
+    exec <$1
+elif [ $# -ne 0 ]; then
+    echo $(basename $0) [ licence_key_file ] 1>&2
+    exit 1
+fi
+
+read licence_key
+
 rm -rf GeoLite2-Country-CSV_*
 
-wget -q http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country-CSV.zip
+wget -q -OGeoLite2-Country-CSV.zip "https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-Country-CSV&license_key=${licence_key}&suffix=zip"
 unzip -q GeoLite2-Country-CSV.zip
 rm -f GeoLite2-Country-CSV.zip
-- 
2.29.2

