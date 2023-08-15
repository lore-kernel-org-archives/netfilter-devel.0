Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F30CFC04FDF
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Aug 2023 22:31:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240381AbjHOWaz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Aug 2023 18:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240288AbjHOWa0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Aug 2023 18:30:26 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EAF71BFF;
        Tue, 15 Aug 2023 15:30:25 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qW2YL-0004ZK-K7; Wed, 16 Aug 2023 00:30:17 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH net 0/9] netfilter fixes for net
Date:   Wed, 16 Aug 2023 00:29:50 +0200
Message-ID: <20230815223011.7019-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

These are netfilter fixes for the *net* tree.

First patch resolves a false-positive lockdep splat:
rcu_dereference is used outside of rcu read lock.  Let lockdep
validate that the transaction mutex is locked.

Second patch fixes a kdoc warning added in previous PR.

Third patch fixes a memory leak:
The catchall element isn't disabled correctly, this allows
userspace to deactivate the element again. This results in refcount
underflow which in turn prevents memory release. This was always
broken since the feature was added in 5.13.

Patch 4 fixes an incorrect change in the previous pull request:
Adding a duplicate key to a set should work if the duplicate key
has expired, restore this behaviour. All from myself.

Patch #5 resolves an old historic artifact in sctp conntrack:
a 300ms timeout for shutdown_ack. Increase this to 3s.  From Xin Long.

Patch #6 fixes a sysctl data race in ipvs, two threads can clobber the
sysctl value, from Sishuai Gong. This is a day-0 bug that predates git
history.

Patches 7, 8 and 9, from Pablo Neira Ayuso, are also followups
for the previous GC rework in nf_tables: The netlink notifier and the
netns exit path must both increment the gc worker seqcount, else worker
may encounter stale (free'd) pointers.

The following changes since commit e4dd0d3a2f64b8bd8029ec70f52bdbebd0644408:

  net: fix the RTO timer retransmitting skb every 1ms if linear option is enabled (2023-08-15 20:24:04 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-23-08-16

for you to fetch changes up to 23185c6aed1ffb8fc44087880ba2767aba493779:

  netfilter: nft_dynset: disallow object maps (2023-08-16 00:05:15 +0200)

----------------------------------------------------------------
nf pull request 2023-08-16

----------------------------------------------------------------
Florian Westphal (4):
      netfilter: nf_tables: fix false-positive lockdep splat
      netfilter: nf_tables: fix kdoc warnings after gc rework
      netfilter: nf_tables: deactivate catchall elements in next generation
      netfilter: nf_tables: don't fail inserts if duplicate has expired

Pablo Neira Ayuso (3):
      netfilter: nf_tables: fix GC transaction races with netns and netlink event exit path
      netfilter: nf_tables: GC transaction race with netns dismantle
      netfilter: nft_dynset: disallow object maps

Sishuai Gong (1):
      ipvs: fix racy memcpy in proc_do_sync_threshold

Xin Long (1):
      netfilter: set default timeout to 3 secs for sctp shutdown send and recv state

 Documentation/networking/nf_conntrack-sysctl.rst |  4 +--
 include/net/netfilter/nf_tables.h                |  1 +
 net/netfilter/ipvs/ip_vs_ctl.c                   |  4 +++
 net/netfilter/nf_conntrack_proto_sctp.c          |  6 ++--
 net/netfilter/nf_tables_api.c                    | 44 +++++++++++++++++++++---
 net/netfilter/nft_dynset.c                       |  3 ++
 net/netfilter/nft_set_pipapo.c                   | 38 +++++++++-----------
 7 files changed, 69 insertions(+), 31 deletions(-)
