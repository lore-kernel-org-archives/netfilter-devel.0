Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4562EC7EE2A
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Jun 2023 22:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbjFEWMG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Jun 2023 18:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbjFEWMF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jun 2023 18:12:05 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067A1F7
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Jun 2023 15:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WTiJsBl98UB/43sOVN3roviz00zwhS3nJuzcWmoLtcg=; b=jJYx4TzGNp9/NcuvzpavF5y/2F
        pKjjBXBICkFXvJ24Gv1jLt5+pO/VEpsmxHyx4ExtKHaWCwD1FFQrdFjtl/Io6Uj5wVaoyZrt4QVXs
        tQQo7U9uvblIiMOIxPWKR97HD5OAo+ZASnf3LgK9FKU0r9V/hnHo5hi38CILv7cUSAZTNcfS4q4Wy
        +5X/ex+SFFFCeAfmUnk/pSodKzgkqPdd0LfzdQ5HM+efybhhQA0flrC6u9hom6nkBTSbe8GFVDhI6
        dOAPJREO1XWY79TY3xP/VlkU87rrwW4Xjs+CvaupAMpK6g8BJyvC2wvt4QsBTUqWa8HkkMRXpKeiO
        xt0Md17A==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1q6IQl-00H5Wa-G8
        for netfilter-devel@vger.kernel.org; Mon, 05 Jun 2023 23:12:03 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons v2 0/7] xt_ipp2p: support for non-linear packets
Date:   Mon,  5 Jun 2023 23:10:37 +0100
Message-Id: <20230605221044.140855-1-jeremy@azazel.net>
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

* Patches 1 fixes a bug.
* Patches 2-4 perform some tidy-ups.
* Patch 5 introduces the kernel's textsearch API for doing substring
  matching.
* Patches 6-7 add support for non-linear skb's.

Changes since v1

 * The first patch in v1 has been applied.
 * Rebased on to 38a85247cf5e ("xt_ipp2p: fix an off-by-one error").

Jeremy Sowden (7):
  xt_ipp2p: fix Soulseek false-positive matches
  xt_ipp2p: change byte-orer conversion
  xt_ipp2p: add helper for matching "\r\n"
  xt_ipp2p: rearrange some conditionals and a couple of loops
  xt_ipp2p: use textsearch API for substring searching
  xt_ipp2p: use `skb_header_pointer` and `skb_find_text`
  xt_ipp2p: drop requirement that skb is linear

 extensions/xt_ipp2p.c | 939 ++++++++++++++++++++++++++++++------------
 extensions/xt_ipp2p.h |  10 +
 2 files changed, 691 insertions(+), 258 deletions(-)

-- 
2.39.2

