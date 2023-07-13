Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F244EB64DD
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Jul 2023 08:49:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234445AbjGMIto (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 13 Jul 2023 04:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234148AbjGMItT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Jul 2023 04:49:19 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 804C81B6;
        Thu, 13 Jul 2023 01:49:07 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        sashal@kernel.org
Subject: [PATCH -stable,5.10 v3 00/11] Netfilter stable fixes for 5.10
Date:   Thu, 13 Jul 2023 10:48:48 +0200
Message-Id: <20230713084859.71541-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Greg, Sasha,

[ This is v3:
  - remove backported function that is useless in patch 09/11
  - use: Upstream commit XYZ tag as suggested by Salvatore Bonaccorso.
]

The following list shows the backported patches. I am using original commit IDs
for reference:

1) 0854db2aaef3 ("netfilter: nf_tables: use net_generic infra for transaction data")

2) 81ea01066741 ("netfilter: nf_tables: add rescheduling points during loop detection walks")

3) 1240eb93f061 ("netfilter: nf_tables: incorrect error path handling with NFT_MSG_NEWRULE")

4) 4bedf9eee016 ("netfilter: nf_tables: fix chain binding transaction logic")

5) 26b5a5712eb8 ("netfilter: nf_tables: add NFT_TRANS_PREPARE_ERROR to deal with bound set/chain")

6) 938154b93be8 ("netfilter: nf_tables: reject unbound anonymous set before commit phase")

7) 62e1e94b246e ("netfilter: nf_tables: reject unbound chain set before commit phase")

8) f8bb7889af58 ("netfilter: nftables: rename set element data activation/deactivation functions")

9) 628bd3e49cba ("netfilter: nf_tables: drop map element references from preparation phase")

10) 3e70489721b6 ("netfilter: nf_tables: unbind non-anonymous set if rule construction fails")

11) f838e0906dd3 ("netfilter: nf_tables: fix scheduling-while-atomic splat")

Notes:

- Patch #1 is a backported dependency patch required by these fixes.
- Patch #3 needs an incremental follow up fix coming in Patch #11.

Florian Westphal (3):
  netfilter: nf_tables: use net_generic infra for transaction data
  netfilter: nf_tables: add rescheduling points during loop detection walks
  netfilter: nf_tables: fix scheduling-while-atomic splat

Pablo Neira Ayuso (8):
  netfilter: nf_tables: incorrect error path handling with NFT_MSG_NEWRULE
  netfilter: nf_tables: fix chain binding transaction logic
  netfilter: nf_tables: add NFT_TRANS_PREPARE_ERROR to deal with bound set/chain
  netfilter: nf_tables: reject unbound anonymous set before commit phase
  netfilter: nf_tables: reject unbound chain set before commit phase
  netfilter: nftables: rename set element data activation/deactivation functions
  netfilter: nf_tables: drop map element references from preparation phase
  netfilter: nf_tables: unbind non-anonymous set if rule construction fails

 include/net/netfilter/nf_tables.h |  41 +-
 include/net/netns/nftables.h      |   7 -
 net/netfilter/nf_tables_api.c     | 662 +++++++++++++++++++++---------
 net/netfilter/nf_tables_offload.c |  30 +-
 net/netfilter/nft_chain_filter.c  |  11 +-
 net/netfilter/nft_dynset.c        |   6 +-
 net/netfilter/nft_immediate.c     |  90 +++-
 net/netfilter/nft_set_bitmap.c    |   5 +-
 net/netfilter/nft_set_hash.c      |  23 +-
 net/netfilter/nft_set_pipapo.c    |  14 +-
 net/netfilter/nft_set_rbtree.c    |   5 +-
 11 files changed, 648 insertions(+), 246 deletions(-)

-- 
2.30.2

