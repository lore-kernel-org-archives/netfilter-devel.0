Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6855BC6FD19
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Mar 2023 13:47:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbjCMNrE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Mar 2023 09:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbjCMNrD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Mar 2023 09:47:03 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F406515E2
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2023 06:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=f8VzB4ZYvua0CIArRawOyVJwku3iFWGLJYLRYHebUMs=; b=fFK7rvJnh7V/qlAVxdTWdJCSIt
        vd0AaAg+Kjdmgz5VyGSuZ+9ZWtDQ2D/sydA/PARZrLanOqHhykgbD+cLeMqaAniFyBf6BT/SX+FJY
        cWecSaeTZiKWkp1PVFPowSSuCKsZajAUKlvCOT9MsGZfKQjF5gxk9PYvw9ZCD4cfHLXNSifb6/JNG
        QXZbEVBCc5QGrD1tR+eFShsk5BnmAAY/8yXA3obZfr2cnxE++bcaU81ItqPgl+6KZSxppIOzdGpjF
        SUdFKVQ8Aa+roG8Zo9FpJzfD2VYEzYPnQ/+u+MzM++YOpbLQj+avkDCJ/Vn5MewdMcPl2ABwV0yyH
        MmX3z7tA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pbiVo-006qSf-6w
        for netfilter-devel@vger.kernel.org; Mon, 13 Mar 2023 13:46:52 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 0/3] NF NAT deduplication refactoring
Date:   Mon, 13 Mar 2023 13:46:46 +0000
Message-Id: <20230313134649.186812-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These three patches perform refactoring in NF NAT modules to remove
duplicate code.

Jeremy Sowden (3):
  netfilter: nf_nat_redirect: use `struct nf_nat_range2` in ipv4 API
  netfilter: nft_masq: deduplicate eval call-backs
  netfilter: nft_redir: deduplicate eval call-backs

 include/net/netfilter/nf_nat_redirect.h |  3 +-
 net/netfilter/nf_nat_redirect.c         | 58 ++++++++---------
 net/netfilter/nft_masq.c                | 75 +++++++++-------------
 net/netfilter/nft_redir.c               | 84 +++++++++----------------
 net/netfilter/xt_REDIRECT.c             | 10 ++-
 5 files changed, 96 insertions(+), 134 deletions(-)

-- 
2.39.2

