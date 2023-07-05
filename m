Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7699BC001B0
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jul 2023 16:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbjGEQys (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Jul 2023 12:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231815AbjGEQyk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Jul 2023 12:54:40 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2B5121989;
        Wed,  5 Jul 2023 09:54:34 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     sashal@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Subject: [PATCH -stable,5.4 00/10] stable fixes for 5.4
Date:   Wed,  5 Jul 2023 18:54:13 +0200
Message-Id: <20230705165423.50054-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Greg, Sasha,

The following list shows the backported patches, I am using original
commit IDs for reference:

1) 1e9451cbda45 ("netfilter: nf_tables: fix nat hook table deletion")

2) 802b805162a1 ("netfilter: nftables: add helper function to set the base sequence number")

3) 19c28b1374fb ("netfilter: add helper function to set up the nfnetlink header and use it")

4) 0854db2aaef3 ("netfilter: nf_tables: use net_generic infra for transaction data")

5) 81ea01066741 ("netfilter: nf_tables: add rescheduling points during loop detection walks")

6) 1240eb93f061 ("netfilter: nf_tables: incorrect error path handling with NFT_MSG_NEWRULE")

7) 26b5a5712eb8 ("netfilter: nf_tables: add NFT_TRANS_PREPARE_ERROR to deal with bound set/chain")

8) 938154b93be8 ("netfilter: nf_tables: reject unbound anonymous set before commit phase")

9) 3e70489721b6 ("netfilter: nf_tables: unbind non-anonymous set if rule construction fails")

10) 2024439bd5ce ("netfilter: nf_tables: fix scheduling-while-atomic splat")

Please, apply,
Thanks

Florian Westphal (4):
  netfilter: nf_tables: fix nat hook table deletion
  netfilter: nf_tables: use net_generic infra for transaction data
  netfilter: nf_tables: add rescheduling points during loop detection walks
  netfilter: nf_tables: fix scheduling-while-atomic splat

Pablo Neira Ayuso (6):
  netfilter: nftables: add helper function to set the base sequence number
  netfilter: add helper function to set up the nfnetlink header and use it
  netfilter: nf_tables: incorrect error path handling with NFT_MSG_NEWRULE
  netfilter: nf_tables: add NFT_TRANS_PREPARE_ERROR to deal with bound set/chain
  netfilter: nf_tables: reject unbound anonymous set before commit phase
  netfilter: nf_tables: unbind non-anonymous set if rule construction fails

 include/linux/netfilter/nfnetlink.h  |  27 ++
 include/net/netfilter/nf_tables.h    |  14 +
 include/net/netns/nftables.h         |   6 -
 net/netfilter/ipset/ip_set_core.c    |  17 +-
 net/netfilter/nf_conntrack_netlink.c |  77 ++--
 net/netfilter/nf_tables_api.c        | 510 ++++++++++++++++-----------
 net/netfilter/nf_tables_offload.c    |  29 +-
 net/netfilter/nf_tables_trace.c      |   9 +-
 net/netfilter/nfnetlink_acct.c       |  11 +-
 net/netfilter/nfnetlink_cthelper.c   |  11 +-
 net/netfilter/nfnetlink_cttimeout.c  |  22 +-
 net/netfilter/nfnetlink_log.c        |  11 +-
 net/netfilter/nfnetlink_queue.c      |  12 +-
 net/netfilter/nft_chain_filter.c     |  11 +-
 net/netfilter/nft_compat.c           |  11 +-
 net/netfilter/nft_dynset.c           |   6 +-
 16 files changed, 418 insertions(+), 366 deletions(-)

-- 
2.30.2

