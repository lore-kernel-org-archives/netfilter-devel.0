Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28BA0C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Dec 2021 17:05:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235683AbhLPRFX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 12:05:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235758AbhLPRFW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 12:05:22 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9296DC061574
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Dec 2021 09:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=c10O0xx/CYDJh9aKdFzbYmZBPg4cw/SaWpMogVESPVA=; b=W63uvgPKGXGydakR0ZQOOR/+7d
        MBDix/kjerZwvWoKvJcKmF0stZjWKiW34OPQ8dUXPztfWxx5Qfd9nAW0FenfEq3v/5nBWSHPxa6Ay
        4xBOEh0uW2Foj0bSw+MB8J7CKCfWWrt5uo5IwRxDzEtwnrfz3YXTJKfq/PivMtSHJpryFTP7HLJYq
        Qht9zEomjvigJJ0v6Q6Fem/ovoLWGDvC4KnAr1+CzNn9ch8i7zhfyyF2Lb1Sjw9/2nHuPw+y9GZcf
        MjIU9gPfEr0m0IqAFq4cvo+z/a3OF0O2GlWGOtZPr9LFwZ6++5pV6WXcCPG9Zh55dTORjlRlAJmuN
        c0eTf0mg==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mxuC0-009WE2-4p
        for netfilter-devel@vger.kernel.org; Thu, 16 Dec 2021 17:05:20 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [conntrack-tools PATCH 0/3] bison & flex autotools updates
Date:   Thu, 16 Dec 2021 17:05:10 +0000
Message-Id: <20211216170513.180579-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The first two patches bring the use of bison and flex and their
generated files more into line with the recommendations of automake.
The third fixes an autoconf deprecation warning.

Jeremy Sowden (3):
  build: only require bison and flex if the generated files do not exist
  build: remove MAINTAINERCLEANFILES
  build: replace `AM_PROG_LEX` with `AC_PROG_LEX`

 configure.ac    | 6 +++---
 src/Makefile.am | 1 -
 2 files changed, 3 insertions(+), 4 deletions(-)

-- 
2.34.1

