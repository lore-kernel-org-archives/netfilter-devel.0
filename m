Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 645CEC6FD1D
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Mar 2023 20:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbjC3U3j (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Mar 2023 16:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjC3U3i (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Mar 2023 16:29:38 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC09910FD;
        Thu, 30 Mar 2023 13:29:37 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1phyto-0000gP-3U; Thu, 30 Mar 2023 22:29:32 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH net-next 0/4] netfilter updates for net-next
Date:   Thu, 30 Mar 2023 22:29:24 +0200
Message-Id: <20230330202928.28705-1-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

This pull request contains changes for the *net-next* tree.

1. No need to disable BH in nfnetlink proc handler, freeing happens
   via call_rcu.
2. Expose classid in nfetlink_queue, from Eric Sage.
3. Fix nfnetlink message description comments, from Matthieu De Beule.
4. Allow removal of offloaded connections via ctnetlink, from Paul Blakey.

The following changes since commit da617cd8d90608582eb8d0b58026f31f1a9bfb1d:

  smsc911x: remove superfluous variable init (2023-03-30 15:35:33 +0200)

are available in the Git repository at:

  ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next 

for you to fetch changes up to 9b7c68b3911aef84afa4cbfc31bce20f10570d51:

  netfilter: ctnetlink: Support offloaded conntrack entry deletion (2023-03-30 22:20:09 +0200)

----------------------------------------------------------------
Eric Sage (1):
      netfilter: nfnetlink_queue: enable classid socket info retrieval

Florian Westphal (1):
      netfilter: nfnetlink_log: remove rcu_bh usage

Matthieu De Beule (1):
      netfilter: Correct documentation errors in nf_tables.h

Paul Blakey (1):
      netfilter: ctnetlink: Support offloaded conntrack entry deletion

 include/uapi/linux/netfilter/nf_tables.h       |  8 +++---
 include/uapi/linux/netfilter/nfnetlink_queue.h |  1 +
 net/netfilter/nf_conntrack_netlink.c           |  8 ------
 net/netfilter/nfnetlink_log.c                  | 36 ++++++++++++++++----------
 net/netfilter/nfnetlink_queue.c                | 20 ++++++++++++++
 5 files changed, 48 insertions(+), 25 deletions(-)
