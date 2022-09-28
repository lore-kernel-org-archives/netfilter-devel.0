Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D932CC6FA82
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Sep 2022 11:39:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233549AbiI1Ljk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Sep 2022 07:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232346AbiI1Lji (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Sep 2022 07:39:38 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87D6F42;
        Wed, 28 Sep 2022 04:39:33 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1odVPP-0003vL-6q; Wed, 28 Sep 2022 13:39:23 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 0/1] netfilter fix for net-next
Date:   Wed, 28 Sep 2022 13:39:07 +0200
Message-Id: <20220928113908.4525-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

This is a late bug fix for the *net-next* tree to make nftables
"fib" expression play nice with VRF devices.

This was broken since day 1 (v4.10) so I don't see a compelling reason
to push this via net at the last minute.

Please consider pulling this change from
  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git

----------------------------------------------------------------
The following changes since commit b9a5cbf8ba24e88071a97a51a09ef5cdf0d1f6a1:

  Merge branch 'sfc-tc-offload' (2022-09-28 09:43:22 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git master

for you to fetch changes up to 2a8a7c0eaa8747c16aa4a48d573aa920d5c00a5c:

  netfilter: nft_fib: Fix for rpath check with VRF devices (2022-09-28 13:33:26 +0200)

----------------------------------------------------------------
Phil Sutter (1):
      netfilter: nft_fib: Fix for rpath check with VRF devices

 net/ipv4/netfilter/nft_fib_ipv4.c | 3 +++
 net/ipv6/netfilter/nft_fib_ipv6.c | 6 +++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

