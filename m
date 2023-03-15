Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFB15C61DA4
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Mar 2023 21:48:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbjCOVsJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Mar 2023 17:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbjCOVsI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2023 17:48:08 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DDCBE05E
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2023 14:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DyBdbp4CXDO3+sig2D7Z/gTx6neegtr09+AvgtxqVxw=; b=Z9c8dQN9muzF4nYA/SoJIhsQLC
        w8OnKeAD6AXVRa/l5UNkRGYblMJCvRq+BrYVNd9JK2r4uxzP8lvySEpVlBgr/iSArMUKkVScbigS7
        NbZ7WTZwndyFUs0uOtLxWoFMs9pjMvmkiTR8bA0p4VGucSdsgKjG0D1TVvUmDlNbmOYpnMC18N/9z
        6jUUUR826vnbkQT7yReguW/k1/ExgdKXAU2QXrbS4OKGxlgmOhqvUyNdS1N5vLLubhMkN7rqZROQH
        vMlwML3uA5AVOBJ0nwsi8YgzYHqr/zBtPnuQi+HKWLD/Lii1D4zLmjVOKKFyvyCn4rtaO9kXrvyfu
        nX5sShYg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pcYyb-009sxd-Mb
        for netfilter-devel@vger.kernel.org; Wed, 15 Mar 2023 21:48:06 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v2 0/2] NF NAT deduplication refactoring
Date:   Wed, 15 Mar 2023 21:47:59 +0000
Message-Id: <20230315214802.236464-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These two patches perform refactoring in NF NAT modules to remove
duplicate code.  I've incorporated the changes that Pablo suggested.

Changes since v1.

  * The two redirect patches in v1 have been merged.
  * The new `struct nf_nat_range2` instance in nf_nat_redirect.c is
    memset to zero.
  * The two `union nf_inet_addr` instances in nf_nat_redirect.c are
    zero-initialized.
  * The `WARN_ON` call in nf_nat_redirect.c has been removed.

Jeremy Sowden (2):
  netfilter: nft_redir: use `struct nf_nat_range2` throughout and
    deduplicate eval call-backs
  netfilter: nft_masq: deduplicate eval call-backs

 include/net/netfilter/nf_nat_redirect.h |  3 +-
 net/netfilter/nf_nat_redirect.c         | 71 ++++++++++-----------
 net/netfilter/nft_masq.c                | 75 +++++++++-------------
 net/netfilter/nft_redir.c               | 84 +++++++++----------------
 net/netfilter/xt_REDIRECT.c             | 10 ++-
 5 files changed, 101 insertions(+), 142 deletions(-)

-- 
2.39.2

