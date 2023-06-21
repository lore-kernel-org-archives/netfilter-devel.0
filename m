Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 271C7C0015E
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Jun 2023 10:19:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbjFUKTG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Jun 2023 06:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232474AbjFUKSo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Jun 2023 06:18:44 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E7E571FDE;
        Wed, 21 Jun 2023 03:18:06 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net,v3 00/14] Netfilter/IPVS fixes for net
Date:   Wed, 21 Jun 2023 12:07:17 +0200
Message-Id: <20230621100731.68068-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is v3, including a crash fix for patch 01/14.

-o-

Hi,

The following patchset contains Netfilter/IPVS fixes for net:

1) Fix UDP segmentation with IPVS tunneled traffic, from Terin Stock.

2) Fix chain binding transaction logic, add a bound flag to rule
   transactions. Remove incorrect logic in nft_data_hold() and
   nft_data_release().

3) Add a NFT_TRANS_PREPARE_ERROR deactivate state to deal with releasing
   the set/chain as a follow up to 1240eb93f061 ("netfilter: nf_tables:
   incorrect error path handling with NFT_MSG_NEWRULE")

4) Drop map element references from preparation phase instead of
   set destroy path, otherwise bogus EBUSY with transactions such as:

        flush chain ip x y
        delete chain ip x w

   where chain ip x y contains jump/goto from set elements.

5) Pipapo set type does not regard generation mask from the walk
   iteration.

6) Fix reference count underflow in set element reference to
   stateful object.

7) Several patches to tighten the nf_tables API:
   - disallow set element updates of bound anonymous set
   - disallow unbound anonymous set/chain at the end of transaction.
   - disallow updates of anonymous set.
   - disallow timeout configuration for anonymous sets.

8) Fix module reference leak in chain updates.

9) Fix nfnetlink_osf module autoload.

10) Fix deletion of basechain when NFTA_CHAIN_HOOK is specified as
    in iptables-nft.

This Netfilter batch is larger than usual at this stage, I am aware we
are fairly late in the -rc cycle, if you prefer to route them through
net-next, please let me know.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-23-06-21

Thanks.

----------------------------------------------------------------

The following changes since commit 0dbcac3a6dbb32c1de53ebebfd28452965e12950:

  Merge tag 'mlx5-fixes-2023-06-16' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux (2023-06-19 10:28:56 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-23-06-21

for you to fetch changes up to 42e344f01688490cdac4bed8f5ba21817cad26ee:

  netfilter: nf_tables: Fix for deleting base chains with payload (2023-06-20 22:43:42 +0200)

----------------------------------------------------------------
netfilter pull request 23-06-21

----------------------------------------------------------------
Pablo Neira Ayuso (12):
      netfilter: nf_tables: fix chain binding transaction logic
      netfilter: nf_tables: add NFT_TRANS_PREPARE_ERROR to deal with bound set/chain
      netfilter: nf_tables: drop map element references from preparation phase
      netfilter: nft_set_pipapo: .walk does not deal with generations
      netfilter: nf_tables: fix underflow in object reference counter
      netfilter: nf_tables: disallow element updates of bound anonymous sets
      netfilter: nf_tables: reject unbound anonymous set before commit phase
      netfilter: nf_tables: reject unbound chain set before commit phase
      netfilter: nf_tables: disallow updates of anonymous sets
      netfilter: nf_tables: disallow timeout for anonymous sets
      netfilter: nf_tables: drop module reference after updating chain
      netfilter: nfnetlink_osf: fix module autoload

Phil Sutter (1):
      netfilter: nf_tables: Fix for deleting base chains with payload

Terin Stock (1):
      ipvs: align inner_mac_header for encapsulation

 include/net/netfilter/nf_tables.h |  31 +++-
 net/netfilter/ipvs/ip_vs_xmit.c   |   2 +
 net/netfilter/nf_tables_api.c     | 366 ++++++++++++++++++++++++++++++--------
 net/netfilter/nfnetlink_osf.c     |   1 +
 net/netfilter/nft_immediate.c     |  90 +++++++++-
 net/netfilter/nft_set_bitmap.c    |   5 +-
 net/netfilter/nft_set_hash.c      |  23 ++-
 net/netfilter/nft_set_pipapo.c    |  20 ++-
 net/netfilter/nft_set_rbtree.c    |   5 +-
 net/netfilter/xt_osf.c            |   1 -
 10 files changed, 446 insertions(+), 98 deletions(-)
