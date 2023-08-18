Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CBC9C71144
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Aug 2023 12:39:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359608AbjHRMij (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Aug 2023 08:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376972AbjHRMib (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Aug 2023 08:38:31 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34EDA30F1
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 05:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4Zr7GJ96T4ENzY8cBqbodR9At3M8UH4ghGbjN6ykfSU=; b=j/iO7EsYhePM6qO77zRCNvBX6J
        DcVZnYvlUhmJX3ozoNdHqShIURgaK7whFXbDJ+bMrAqncUJvcx5pnbtR01usxqHssFLu0oA0O1xcq
        a/ZrrCwshcuANzjPtq04VI599590GW/w+aKlNmkajB9Y88BVKHxCrgd9riZoogyrPgWec1vk9IkaJ
        B+4FbmRH2V6f4yQGOQqm2sOGralAtQR4w2PpAi2np1EsqgqJbAbC39z6bQAQjm5i4tQuMbOlhTWi6
        P6pV3HLFBNc2jW64OCHCT5ft4TEHTtGguJ3OrVj6s/eAM071pUFv7fs5KkKAut78NwvJLBDPRGgXH
        UG03UHyg==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qWykC-005x0b-2O
        for netfilter-devel@vger.kernel.org;
        Fri, 18 Aug 2023 13:38:24 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 0/5] Autoools silent-rules fixes
Date:   Fri, 18 Aug 2023 13:38:13 +0100
Message-Id: <20230818123818.2739947-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The build system attempts to extend and make use of the `AM_V_*`
variables that automake provides to control the verbosity of the build.
However, there are bugs in the implementation which render it only
partially effective.  This patch-set updates some of the variable
definitions and fixes the bugs.

The first patch is an unrelated `include` tweak.

Jeremy Sowden (5):
  build: use `$(top_srcdir)` when including Makefile.extra
  build: replace `AM_V_silent` with `AM_V_at`
  build: update `AM_V_*` definitions to match autotools
  build: don't hard-code `AM_DEFAULT_VERBOSITY` in Makefile.iptrules
  build: define `AM_V_GEN` where it is needed

 Makefile.iptrules.in           | 24 +++++++++---------------
 Makefile.mans.in               |  5 +++++
 extensions/ACCOUNT/Makefile.am |  2 +-
 extensions/Makefile.am         |  8 ++++----
 extensions/pknock/Makefile.am  |  2 +-
 5 files changed, 20 insertions(+), 21 deletions(-)

-- 
2.40.1

