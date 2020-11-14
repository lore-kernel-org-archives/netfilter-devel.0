Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17479C63697
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Nov 2020 17:36:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77EB72222C
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Nov 2020 17:36:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="JcPY/aZD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgKNRgK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 14 Nov 2020 12:36:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbgKNRgJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 14 Nov 2020 12:36:09 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF47C0613D2
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Nov 2020 09:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=H9V0jcU3/gugAZrQZbq4I+syODi4jLw3V7qxaFutRF8=; b=JcPY/aZDybTLxEBH3r3PFQA6M+
        FYTW39rq79EqgA+oo5mZjBZJmzLFl+X4MFJyyNo6zf6wocBAWh1x7xYGZvZvsB1i1VrKq2k80o46d
        rPcEm9Hsp/GZIHabphjsrIWxUp2AcIfHG5aAf6PAR5pXGH+wzh2igJxPPFXVKyDzhZKFWR9UcXYqp
        syr6NCG9+FuvrLDHKvClAhC9fadD9APo70DVec/iuLc0TEXumIMSYyMqHSwcwEorP2GPD72fYENJp
        0uP35MOXSaXvGWdHCsYTd3I/5VhqJ+pAzacPgLX4ZDA56n+JSG7p5VckAr9zwyjHMuoUsmu4i8Hiq
        X0YTsTTA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kdzT4-0001wO-W2; Sat, 14 Nov 2020 17:36:07 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnftnl 0/1] Bitwise dump format fix.
Date:   Sat, 14 Nov 2020 17:36:04 +0000
Message-Id: <20201114173605.244338-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The dumping of bitwise operations looks like:

  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]

instead of:

  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]

which offends my sense of neatness. :) I have a follow-up patch to fix the
payloads of the nft Python tests that this change breaks.  Are there other
things that might be affected?

Jeremy Sowden (1):
  bitwise: improve formatting of registers in bitwise dumps.

 src/expr/bitwise.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.29.2

