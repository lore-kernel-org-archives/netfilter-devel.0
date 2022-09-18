Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AEB2C32771
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Sep 2022 17:23:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbiIRRXG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 18 Sep 2022 13:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiIRRXF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Sep 2022 13:23:05 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC8E640D
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Sep 2022 10:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uNqx/I0TLz0Lc8+uWxnQ3sEt+CAWN9Q8qer0MivF6f0=; b=XlZZgIArBcaxCQqypX0VbL4pe7
        ovOrjyjr5yOvJphInyWWIHyllo+DhIa8FSSv+xTFsJONAYej4+pddOj5rDcax7+/tZt92Yd0JlmuY
        049qJH9oXRkJBSqh1SGTJdtUyoSf1sKL1sqnn3foYLkpZjJfm/jhx6niikN/d4/GJ7YDJWIDC46Cz
        JOXDDv1sbCeyA5jtCw/O41O5R0Gym8VKYuXvik2+aBt/W5EI4d/W0oAXvrTtaZNo8oxzSY/33Ue9x
        E0y5911RPtNfIKmwoM/srxuAXj2U3SgBSZlNX2bp5jiCNyAykq1yxPwiznBL+cL87vEaQWd5WtFrS
        nVRaNY0Q==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oZy0U-004VxI-EN
        for netfilter-devel@vger.kernel.org; Sun, 18 Sep 2022 18:23:02 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 0/2] Fix listing of sets containing unclosed address prefix intervals
Date:   Sun, 18 Sep 2022 18:22:10 +0100
Message-Id: <20220918172212.3681553-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The code which decomposes unclosed intervals in sets doesn't check for
prefixes.  This means that a set containing such a prefix (e.g.,
ff00::/8 or 192.0.0.0/2) is incorrectly listed:

  # nft list table ip6 t
  table ip6 t {
    chain c {
      ip6 saddr ff00::/8 drop
      ip6 saddr fe80::/10 drop
      ip6 saddr { fe80::/10, ff00::-ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff } drop
    }
  }
  # nft list table ip t
  table ip t {
    chain c {
      ip saddr 192.0.0.0/2 drop
      ip saddr 10.0.0.0/8 drop
      ip saddr { 10.0.0.0/8, 192.0.0.0-255.255.255.255 } drop
    }
  }

This patch-set refactors `interval_map_decompose` to use the same code
to handle unclosed intervals that is used for closed ones.

Jeremy Sowden (2):
  segtree: refactor decomposition of closed intervals
  segtree: fix decomposition of unclosed intervals containing address
    prefixes

 src/segtree.c                                 | 90 +++++++++----------
 .../sets/0071unclosed_prefix_interval_0       | 23 +++++
 .../dumps/0071unclosed_prefix_interval_0.nft  | 19 ++++
 3 files changed, 85 insertions(+), 47 deletions(-)
 create mode 100755 tests/shell/testcases/sets/0071unclosed_prefix_interval_0
 create mode 100644 tests/shell/testcases/sets/dumps/0071unclosed_prefix_interval_0.nft

-- 
2.35.1

