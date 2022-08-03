Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 442ECC19F28
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Aug 2022 20:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237264AbiHCUNp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Aug 2022 16:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233695AbiHCUNo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Aug 2022 16:13:44 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF684A811
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Aug 2022 13:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Y962I2VJlzPrVPmLuORkzm6ZYil9gCw9ZbXs5TAHYmU=; b=B7j45gBSubh3vNdhk6DAV4mDCT
        KfjUjuagdUR+7mfirJ5dcIpAkuzecDLU4Bvldk3sYDBqu1y+JpzjWhnZ6xulB6pvbmBG/II/wkeyD
        skSNXpWaLt/mltHgTk7mZy7xD4FivHwkbJkhhejSvrDcXkTEGUPeiwHV/UFzYBGp561CjoGEkULEI
        Ggng4l+syklFPZ7nr2o2y7/5Wkxs60FuDYY1J9IS6tdgOsEKeG5tj3kewEKQCHW+E9lyX4RySD6/Y
        ooQ8IpjhjUe8Ov5GGy8KFZi6d2ncLj8tTaGatMHKTlE03Z2fwvhh3RDbnXmhHAOmLsXyXU6iG/RdA
        zqqXJniw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oJKkJ-001Fnp-QI; Wed, 03 Aug 2022 21:13:35 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Mark Mentovai <mark@mentovai.com>,
        Duncan Roe <duncan_roe@optusnet.com.au>
Subject: [PATCH libmnl 1/6] build: add `make dist` tar-balls to .gitignore
Date:   Wed,  3 Aug 2022 21:12:42 +0100
Message-Id: <20220803201247.3057365-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220803201247.3057365-1-jeremy@azazel.net>
References: <20220803201247.3057365-1-jeremy@azazel.net>
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
 .gitignore | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/.gitignore b/.gitignore
index 9a7d86c78ae2..0276c98fb3a5 100644
--- a/.gitignore
+++ b/.gitignore
@@ -17,3 +17,5 @@ Makefile.in
 
 /doxygen.cfg
 /libmnl.pc
+
+/libmnl-*.tar.bz2
-- 
2.35.1

