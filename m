Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9588C7EE2E
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Jun 2023 19:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbjFETUr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Jun 2023 15:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235498AbjFETTv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jun 2023 15:19:51 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4197A10F9
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Jun 2023 12:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EQ4BqLxdrFFXXly9bwG+uQ9oCWjQJiYvaK3UnLaQRQQ=; b=L77eDf9Kcx8QpBtNQcPQzrpQuK
        xtv53xh+LT/zn1X7ZUOryhOeGTZCHD/iO8Q2tZFVW71na9p4m53bYOfsPj4CEvT3wF+TBsZ/WA88S
        GBWxDTkyrBnjXbfqQEbcGICRyNzeElynHL2mtYKhdYikNIBaV+nU+5qZZXSbQ+PYLP4f8AWYvb5lh
        5gIfKNp4saK8ePxtW9CLY8m/nWfIcwuUjZrtaRb6YD6zvHFe6JGsAeXWKegkKu3pFyE8vpD4a/Caf
        JMypyNvuBf282d1AXNE9dr6qam8ySyL0zY5cw8x+NkmzRLJdxgMMJn+94mhJ3neesoroDAYbEYKlU
        +t38aN/Q==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1q6FjL-00H0rc-0s
        for netfilter-devel@vger.kernel.org; Mon, 05 Jun 2023 20:19:03 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 0/8] xt_ipp2p: support for non-linear packets
Date:   Mon,  5 Jun 2023 20:17:27 +0100
Message-Id: <20230605191735.119210-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

xt_ipp2p currently requires that skb's are linear.  This series adds
support for non-linear ones.

* Patches 1-2 fix bugs.
* Patches 3-5 perform some tidy-ups.
* Patch 6 introduces the kernel's textsearch API for doing substring
  matching.
* Patches 7-8 add support for non-linear skb's.

Jeremy Sowden (8):
  xt_ipp2p: fix an off-by-one error
  xt_ipp2p: fix Soulseek false-positive matches
  xt_ipp2p: change byte-orer conversion
  xt_ipp2p: add helper for matching "\r\n"
  xt_ipp2p: rearrange some conditionals and a couple of loops
  xt_ipp2p: use textsearch API for substring searching
  xt_ipp2p: use `skb_header_pointer` and `skb_find_text`
  xt_ipp2p: drop requirement that skb is linear

 extensions/xt_ipp2p.c | 937 ++++++++++++++++++++++++++++++------------
 extensions/xt_ipp2p.h |  10 +
 2 files changed, 689 insertions(+), 258 deletions(-)

-- 
2.39.2

