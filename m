Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AD89C63797
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Jan 2023 21:23:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbjAKVXD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Jan 2023 16:23:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233101AbjAKVXA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Jan 2023 16:23:00 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A2C85BB1
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Jan 2023 13:22:58 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH net 0/3] Netfilter fixes for net
Date:   Wed, 11 Jan 2023 22:22:48 +0100
Message-Id: <20230111212251.193032-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Increase timeout to 120 seconds for netfilter selftests to fix
   nftables transaction tests, from Florian Westphal.

2) Fix overflow in bitmap_ip_create() due to integer arithmetics
   in a 64-bit bitmask, from Gavrilov Ilia.

3) Fix incorrect arithmetics in nft_payload with double-tagged
   vlan matching.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 8fed75653a670a4d3be0ab9949aed5e2968a03ef:

  Merge tag 'mlx5-fixes-2023-01-09' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux (2023-01-11 12:55:09 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to 696e1a48b1a1b01edad542a1ef293665864a4dd0:

  netfilter: nft_payload: incorrect arithmetics when fetching VLAN header bits (2023-01-11 19:18:04 +0100)

----------------------------------------------------------------
Florian Westphal (1):
      selftests: netfilter: fix transaction test script timeout handling

Gavrilov Ilia (1):
      netfilter: ipset: Fix overflow before widen in the bitmap_ip_create() function.

Pablo Neira Ayuso (1):
      netfilter: nft_payload: incorrect arithmetics when fetching VLAN header bits

 net/netfilter/ipset/ip_set_bitmap_ip.c                |  4 ++--
 net/netfilter/nft_payload.c                           |  2 +-
 tools/testing/selftests/netfilter/nft_trans_stress.sh | 16 +++++++++-------
 tools/testing/selftests/netfilter/settings            |  1 +
 4 files changed, 13 insertions(+), 10 deletions(-)
 create mode 100644 tools/testing/selftests/netfilter/settings
