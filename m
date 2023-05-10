Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D696C77B7D
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 May 2023 08:35:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236594AbjEJIfN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 10 May 2023 04:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236754AbjEJIe4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 May 2023 04:34:56 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC25E30DA;
        Wed, 10 May 2023 01:34:20 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/7] Netfilter updates for net
Date:   Wed, 10 May 2023 10:33:06 +0200
Message-Id: <20230510083313.152961-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Fix UAF when releasing netnamespace, from Florian Westphal.

2) Fix possible BUG_ON when nf_conntrack is enabled with enable_hooks,
   from Florian Westphal.

3) Fixes for nft_flowtable.sh selftest, from Boris Sukholitko.

4) Extend nft_flowtable.sh selftest to cover integration with
   ingress/egress hooks, from Florian Westphal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-23-05-10

Thanks.

----------------------------------------------------------------

The following changes since commit 582dbb2cc1a0a7427840f5b1e3c65608e511b061:

  net: phy: bcm7xx: Correct read from expansion register (2023-05-09 20:25:52 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-23-05-10

for you to fetch changes up to 3acf8f6c14d0e42b889738d63b6d9cb63348fc94:

  selftests: nft_flowtable.sh: check ingress/egress chain too (2023-05-10 09:31:07 +0200)

----------------------------------------------------------------
netfilter pull request 23-05-10

----------------------------------------------------------------
Boris Sukholitko (4):
      selftests: nft_flowtable.sh: use /proc for pid checking
      selftests: nft_flowtable.sh: no need for ps -x option
      selftests: nft_flowtable.sh: wait for specific nc pids
      selftests: nft_flowtable.sh: monitor result file sizes

Florian Westphal (3):
      netfilter: nf_tables: always release netdev hooks from notifier
      netfilter: conntrack: fix possible bug_on with enable_hooks=1
      selftests: nft_flowtable.sh: check ingress/egress chain too

 net/netfilter/core.c                               |   6 +-
 net/netfilter/nf_conntrack_standalone.c            |   3 +-
 net/netfilter/nft_chain_filter.c                   |   9 +-
 tools/testing/selftests/netfilter/nft_flowtable.sh | 145 ++++++++++++++++++++-
 4 files changed, 151 insertions(+), 12 deletions(-)
