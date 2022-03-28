Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58615C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Mar 2022 08:20:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237555AbiC1IWH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Mar 2022 04:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236497AbiC1IWG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Mar 2022 04:22:06 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EFEF9532F8;
        Mon, 28 Mar 2022 01:20:25 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id D661B63004;
        Mon, 28 Mar 2022 10:17:17 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/3] Netfilter fixes for net
Date:   Mon, 28 Mar 2022 10:20:19 +0200
Message-Id: <20220328082022.636423-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Incorrect output device in nf_egress hook, from Phill Sutter.

2) Preserve liberal flag in TCP conntrack state, reported by Sven Auhagen.

3) Use GFP_KERNEL_ACCOUNT flag for nf_tables objects, from Vasily Averin.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit f92fcb5c00dc924a4661d5bf68de7937040f26b8:

  Merge branch 'ice-avoid-sleeping-scheduling-in-atomic-contexts' (2022-03-23 10:40:44 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to 33758c891479ea1c736abfee64b5225925875557:

  memcg: enable accounting for nft objects (2022-03-28 10:11:23 +0200)

----------------------------------------------------------------
Pablo Neira Ayuso (1):
      netfilter: nf_conntrack_tcp: preserve liberal flag in tcp options

Phil Sutter (1):
      netfilter: egress: Report interface as outgoing

Vasily Averin (1):
      memcg: enable accounting for nft objects

 include/linux/netfilter_netdev.h       |  2 +-
 net/netfilter/core.c                   |  2 +-
 net/netfilter/nf_conntrack_proto_tcp.c | 17 +++++++++----
 net/netfilter/nf_tables_api.c          | 44 +++++++++++++++++-----------------
 4 files changed, 37 insertions(+), 28 deletions(-)
