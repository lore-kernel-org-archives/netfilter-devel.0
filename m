Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A62AEC433FE
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Nov 2022 11:28:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiKIL2g (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Nov 2022 06:28:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiKIL2b (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Nov 2022 06:28:31 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0C55410E9;
        Wed,  9 Nov 2022 03:28:30 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/3] Netfilter fixes for net
Date:   Wed,  9 Nov 2022 12:28:17 +0100
Message-Id: <20221109112820.206807-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Fix deadlock in nfnetlink due to missing mutex release in error path,
   from Ziyang Xuan.

2) Clean up pending autoload module list from nf_tables_exit_net() path,
   from Shigeru Yoshida.

3) Fixes for the netfilter's reverse path selftest, from Phil Sutter.

All of these bugs have been around for several releases.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit ce9e57feeed81d17d5e80ed86f516ff0d39c3867:

  drivers: net: xgene: disable napi when register irq failed in xgene_enet_open() (2022-11-08 15:15:55 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to 58bb78ce02269c0cf5b1f2bd2e4a605500b44c6b:

  selftests: netfilter: Fix and review rpath.sh (2022-11-09 10:29:57 +0100)

----------------------------------------------------------------
Phil Sutter (1):
      selftests: netfilter: Fix and review rpath.sh

Shigeru Yoshida (1):
      netfilter: Cleanup nft_net->module_list from nf_tables_exit_net()

Ziyang Xuan (1):
      netfilter: nfnetlink: fix potential dead lock in nfnetlink_rcv_msg()

 net/netfilter/nf_tables_api.c              |  3 ++-
 net/netfilter/nfnetlink.c                  |  1 +
 tools/testing/selftests/netfilter/rpath.sh | 14 ++++++++------
 3 files changed, 11 insertions(+), 7 deletions(-)
