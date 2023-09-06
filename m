Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CB0EEE14AD
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 16:25:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243023AbjIFQZm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 12:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238684AbjIFQZm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 12:25:42 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD227199B;
        Wed,  6 Sep 2023 09:25:36 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qdvLN-0007uQ-4Y; Wed, 06 Sep 2023 18:25:29 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH net 0/6] netfilter updates for net
Date:   Wed,  6 Sep 2023 18:25:06 +0200
Message-ID: <20230906162525.11079-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

This PR contains nf_tables updates for your *net* tree.
This time almost all fixes are for old bugs:

First patch fixes a 4-byte stack OOB write, from myself.
This was broken ever since nftables was switches from 128 to 32bit
register addressing in v4.1.

2nd patch fixes an out-of-bounds read.
This has been broken ever since xt_osf got added in 2.6.31, the bug
was then just moved around during refactoring, from Wander Lairson Costa.

3rd patch adds a missing enum description, from Phil Sutter.

4th patch fixes a UaF inftables that occurs when userspace adds
elements with a timeout so small that expiration happens while the
transaction is still in progress.  Fix from Pablo Neira Ayuso.

Patch 5 fixes a memory out of bounds access, this was
broken since v4.20. Patch from Kyle Zeng and Jozsef Kadlecsik.

Patch 6 fixes another bogus memory access when building audit
record. Bug added in the previous pull request, fix from Pablo.

The following changes since commit 1a961e74d5abbea049588a3d74b759955b4ed9d5:

  net: phylink: fix sphinx complaint about invalid literal (2023-09-06 07:46:49 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-23-09-06

for you to fetch changes up to 9b5ba5c9c5109bf89dc64a3f4734bd125d1ce52e:

  netfilter: nf_tables: Unbreak audit log reset (2023-09-06 18:09:12 +0200)

----------------------------------------------------------------
netfilter pull request 2023-09-06

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: nftables: exthdr: fix 4-byte stack OOB write

Kyle Zeng (1):
      netfilter: ipset: add the missing IP_SET_HASH_WITH_NET0 macro for ip_set_hash_netportnet.c

Pablo Neira Ayuso (2):
      netfilter: nft_set_rbtree: skip sync GC for new elements in this transaction
      netfilter: nf_tables: Unbreak audit log reset

Phil Sutter (1):
      netfilter: nf_tables: uapi: Describe NFTA_RULE_CHAIN_ID

Wander Lairson Costa (1):
      netfilter: nfnetlink_osf: avoid OOB read

 include/uapi/linux/netfilter/nf_tables.h     |  1 +
 net/netfilter/ipset/ip_set_hash_netportnet.c |  1 +
 net/netfilter/nf_tables_api.c                | 11 ++++++-----
 net/netfilter/nfnetlink_osf.c                |  8 ++++++++
 net/netfilter/nft_exthdr.c                   | 22 ++++++++++++++--------
 net/netfilter/nft_set_rbtree.c               |  8 ++++++--
 6 files changed, 36 insertions(+), 15 deletions(-)
