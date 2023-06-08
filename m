Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0003C7EE25
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Jun 2023 19:57:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234560AbjFHT5R (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Jun 2023 15:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbjFHT5Q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Jun 2023 15:57:16 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 923231FDE;
        Thu,  8 Jun 2023 12:57:15 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/3] Netfilter fixes for net
Date:   Thu,  8 Jun 2023 21:57:03 +0200
Message-Id: <20230608195706.4429-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Add commit and abort set operation to pipapo set abort path.

2) Bail out immediately in case of ENOMEM in nfnetlink batch.

3) Incorrect error path handling when creating a new rule leads to
   dangling pointer in set transaction list.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-23-06-08

Thanks.

----------------------------------------------------------------

The following changes since commit ab39b113e74751958aac1b125a14ee42bd7d3efd:

  Merge tag 'for-net-2023-06-05' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth (2023-06-06 21:36:57 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-23-06-08

for you to fetch changes up to 1240eb93f0616b21c675416516ff3d74798fdc97:

  netfilter: nf_tables: incorrect error path handling with NFT_MSG_NEWRULE (2023-06-08 21:49:26 +0200)

----------------------------------------------------------------
netfilter pull request 23-06-08

----------------------------------------------------------------
Pablo Neira Ayuso (3):
      netfilter: nf_tables: integrate pipapo into commit protocol
      netfilter: nfnetlink: skip error delivery on batch in case of ENOMEM
      netfilter: nf_tables: incorrect error path handling with NFT_MSG_NEWRULE

 include/net/netfilter/nf_tables.h |  4 ++-
 net/netfilter/nf_tables_api.c     | 59 ++++++++++++++++++++++++++++++++++++++-
 net/netfilter/nfnetlink.c         |  3 +-
 net/netfilter/nft_set_pipapo.c    | 55 ++++++++++++++++++++++++++----------
 4 files changed, 103 insertions(+), 18 deletions(-)
