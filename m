Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53569C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Oct 2021 19:53:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39DED610C7
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Oct 2021 19:53:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233845AbhJGTyx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Oct 2021 15:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233889AbhJGTyv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Oct 2021 15:54:51 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFAD8C061760
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Oct 2021 12:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/S0i1qf+bpMTd/JYP/aT4pvzAA4Vp+I7VMq1aIGddqI=; b=lg/G2wtB/mcf5aeOyctfXGPZzI
        83H2xjo7cSWAqpThi6y8Pn2eyDtxNTh4vGLx8HcnQ+IErmqcCridZE65eVmlAfjt+0YkCOp8Lmflu
        k2SBipnwgUYrx/6Jb/pH4rKewLw2HuiSK2m8SpLBYD2JdYQs4DwYIJUmbaRTOFjb5CqS/ES5Wjcix
        UnxjiMO3fA6CBs8l0X9v3mbFlvv8G5VNOkSRFvLqu571UXb3mugdaOIN9jlzHxi0Pxc3xTiFs3Uwm
        sUiKASsTuxBgezyH63JRq2vem4Mc0CRovff0wgtTV3ZHsgQF1i4zqWDXAQ7GIWFYxoRsDmNPkbbug
        7DTKh18A==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mYZRi-009WeN-TK
        for netfilter-devel@vger.kernel.org; Thu, 07 Oct 2021 20:52:50 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nft PATCH v2 0/3] Stateless output fixes
Date:   Thu,  7 Oct 2021 20:48:59 +0100
Message-Id: <20211007194902.2613579-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The first patch removes some dummy output for named counters.  The
second patch fixes a bug that erroneously clears the stateless output
flag.  The third patch merges some conditionals.

Changes since v1: patches 2 & 3 are new.

Jeremy Sowden (3):
  rule: remove fake stateless output of named counters
  rule: fix stateless output after listing sets containing counters.
  rule: replace three conditionals with one.

 src/rule.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

-- 
2.33.0

