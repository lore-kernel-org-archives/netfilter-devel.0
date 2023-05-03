Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A80EC77B7F
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 May 2023 06:33:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjECGdA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 May 2023 02:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjECGc6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 May 2023 02:32:58 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3E43A3AB2;
        Tue,  2 May 2023 23:32:54 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/3] Netfilter fixes for net
Date:   Wed,  3 May 2023 08:32:47 +0200
Message-Id: <20230503063250.13700-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Hit ENOENT when trying to update an unexisting base chain.

2) Fix libmnl pkg-config usage in selftests, from Jeremy Sowden.

3) KASAN reports use-after-free when deleting a set element for an
   anonymous set that was already removed in the same transaction,
   reported by P. Sondej and P. Krysiuk.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit c6d96df9fa2c1d19525239d4262889cce594ce6c:

  net: ethernet: mtk_eth_soc: drop generic vlan rx offload, only use DSA untagging (2023-05-02 20:19:52 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-23-05-03

for you to fetch changes up to c1592a89942e9678f7d9c8030efa777c0d57edab:

  netfilter: nf_tables: deactivate anonymous set from preparation phase (2023-05-03 08:24:32 +0200)

----------------------------------------------------------------
netfilter pull request 23-05-03

----------------------------------------------------------------
Jeremy Sowden (1):
      selftests: netfilter: fix libmnl pkg-config usage

Pablo Neira Ayuso (2):
      netfilter: nf_tables: hit ENOENT on unexisting chain/flowtable update with missing attributes
      netfilter: nf_tables: deactivate anonymous set from preparation phase

 include/net/netfilter/nf_tables.h          |  1 +
 net/netfilter/nf_tables_api.c              | 41 +++++++++++++++++++++---------
 net/netfilter/nft_dynset.c                 |  2 +-
 net/netfilter/nft_lookup.c                 |  2 +-
 net/netfilter/nft_objref.c                 |  2 +-
 tools/testing/selftests/netfilter/Makefile |  7 +++--
 6 files changed, 38 insertions(+), 17 deletions(-)
