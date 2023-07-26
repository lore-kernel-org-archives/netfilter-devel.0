Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A922C0015E
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jul 2023 15:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbjGZPZf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jul 2023 11:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232656AbjGZPZe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jul 2023 11:25:34 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2799BF;
        Wed, 26 Jul 2023 08:25:33 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qOgOG-0001Gb-BL; Wed, 26 Jul 2023 17:25:28 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH net 0/3] netfilter fixes for net
Date:   Wed, 26 Jul 2023 17:23:46 +0200
Message-ID: <20230726152524.26268-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

Here are three netfilter fixes for the *net* tree:
1. On-demand overlap detection in 'rbtree' set can cause memory leaks.
   This is broken since 6.2.

2. An earlier fix in 6.4 to address an imbalance in refcounts during
   transaction error unwinding was incomplete, from Pablo Neira.

3. Disallow adding a rule to a deleted chain, also from Pablo.
   Broken since 5.9.

The following changes since commit d4a7ce642100765119a872d4aba1bf63e3a22c8a:

  igc: Fix Kernel Panic during ndo_tx_timeout callback (2023-07-26 09:54:40 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-23-07-26

for you to fetch changes up to 0ebc1064e4874d5987722a2ddbc18f94aa53b211:

  netfilter: nf_tables: disallow rule addition to bound chain via NFTA_RULE_CHAIN_ID (2023-07-26 16:48:49 +0200)

----------------------------------------------------------------
netfilter pull request 2023-07-26

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: nft_set_rbtree: fix overlap expiration walk

Pablo Neira Ayuso (2):
      netfilter: nf_tables: skip immediate deactivate in _PREPARE_ERROR
      netfilter: nf_tables: disallow rule addition to bound chain via NFTA_RULE_CHAIN_ID

 net/netfilter/nf_tables_api.c  |  5 +++--
 net/netfilter/nft_immediate.c  | 27 ++++++++++++++++++---------
 net/netfilter/nft_set_rbtree.c | 20 ++++++++++++++------
 3 files changed, 35 insertions(+), 17 deletions(-)
