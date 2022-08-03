Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4214C19F2C
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Aug 2022 20:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233695AbiHCUNp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Aug 2022 16:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236087AbiHCUNo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Aug 2022 16:13:44 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4A053D25
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Aug 2022 13:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=S/E5GT3B1mSZZ39pxo+XjVOJcdhPJ3ojsb+N3zrDGNM=; b=C9tLkGkwl08nBppmwEl/PnhxLQ
        yVDI53FJOv3+xBWTIM/cyoUWcJ54K9fdZA32ECUoGRe1Khs92zQ872UQ/r6v4PqcmZbGOUlmmaY+O
        +tiDqWZ5Gz8uB3Lezrulw1wo18WgyiUm9EOAyrobeoY7DGc8dv4ukinEVT3YtyWCWc5z95m3a2MxK
        dBySAUamhf90dN1NzdobWbnDcS/0YkixoO5aeaH4Z/bm2NV9oiwYLW/w76QpyQZ8Flz0V36e6LTgk
        mTMDmq77VM0PwcVptXmqVyTEyEjh8we6yVSjWSsM+Ic/c1IPwyjE9MArtjfbb08gxiBPhbsbBwWcE
        WhpiMLNQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oJKkJ-001Fnp-Sj; Wed, 03 Aug 2022 21:13:35 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Mark Mentovai <mark@mentovai.com>,
        Duncan Roe <duncan_roe@optusnet.com.au>
Subject: [PATCH libmnl 2/6] doc: add .gitignore for Doxygen artefacts
Date:   Wed,  3 Aug 2022 21:12:43 +0100
Message-Id: <20220803201247.3057365-3-jeremy@azazel.net>
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
 doxygen/.gitignore | 3 +++
 1 file changed, 3 insertions(+)
 create mode 100644 doxygen/.gitignore

diff --git a/doxygen/.gitignore b/doxygen/.gitignore
new file mode 100644
index 000000000000..a23345c2c599
--- /dev/null
+++ b/doxygen/.gitignore
@@ -0,0 +1,3 @@
+doxyfile.stamp
+html/
+man/
-- 
2.35.1

