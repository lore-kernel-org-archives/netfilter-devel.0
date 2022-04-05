Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A64EBC35274
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Apr 2022 11:32:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240116AbiDEL0E (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Apr 2022 07:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357273AbiDEKZ7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Apr 2022 06:25:59 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CBF0BDF5C;
        Tue,  5 Apr 2022 03:09:54 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1D53F601DC;
        Tue,  5 Apr 2022 12:06:16 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/2] Netfilter fixes for net
Date:   Tue,  5 Apr 2022 12:09:21 +0200
Message-Id: <20220405100923.7231-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Incorrect comparison in bitmask .reduce, from Jeremy Sowden.

2) Missing GFP_KERNEL_ACCOUNT for dynamically allocated objects,
   from Vasily Averin.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit ad7da1ce5749c0eb4f09dd7e5510123be56f10fb:

  net: lan966x: fix kernel oops on ioctl when I/F is down (2022-03-29 10:47:24 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to 42193ffd79bd3acd91bd947e53f3548a3661d0a1:

  netfilter: nf_tables: memcg accounting for dynamically allocated objects (2022-04-05 11:55:46 +0200)

----------------------------------------------------------------
Jeremy Sowden (1):
      netfilter: bitwise: fix reduce comparisons

Vasily Averin (1):
      netfilter: nf_tables: memcg accounting for dynamically allocated objects

 net/netfilter/nf_tables_api.c | 2 +-
 net/netfilter/nft_bitwise.c   | 4 ++--
 net/netfilter/nft_connlimit.c | 2 +-
 net/netfilter/nft_counter.c   | 2 +-
 net/netfilter/nft_last.c      | 2 +-
 net/netfilter/nft_limit.c     | 2 +-
 net/netfilter/nft_quota.c     | 2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)
