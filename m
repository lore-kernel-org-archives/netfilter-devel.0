Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8815BCE79AC
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 08:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233435AbjITImV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 04:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233775AbjITImR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 04:42:17 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48876FB;
        Wed, 20 Sep 2023 01:42:07 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qismW-0004wT-SJ; Wed, 20 Sep 2023 10:42:00 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH net 0/3] netfilter updates for net
Date:   Wed, 20 Sep 2023 10:41:48 +0200
Message-ID: <20230920084156.4192-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

The following three patches fix regressions in the netfilter subsystem:

1. Reject attempts to repeatedly toggle the 'dormant' flag in a single
   transaction.  Doing so makes nf_tables lose track of the real state
   vs. the desired state.  This ends with an attempt to unregister hooks
   that were never registered in the first place, which yields a splat.

2. Fix element counting in the new nftables garbage collection infra
   that came with 6.5:  More than 255 expired elements wraps a counter
   which results in memory leak.

3. Since 6.4 ipset can BUG when a set is renamed while a CREATE command
   is in progress, fix from Jozsef Kadlecsik.

The following changes since commit 4e4b1798cc90e376b8b61d0098b4093898a32227:

  vxlan: Add missing entries to vxlan_get_size() (2023-09-20 09:00:54 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-23-09-20

for you to fetch changes up to 7433b6d2afd512d04398c73aa984d1e285be125b:

  netfilter: ipset: Fix race between IPSET_CMD_CREATE and IPSET_CMD_SWAP (2023-09-20 10:35:24 +0200)

Florian Westphal (2):
      netfilter: nf_tables: disable toggling dormant table state more than once
      netfilter: nf_tables: fix memleak when more than 255 elements expired

Jozsef Kadlecsik (1):
      netfilter: ipset: Fix race between IPSET_CMD_CREATE and IPSET_CMD_SWAP

 include/net/netfilter/nf_tables.h |  2 +-
 net/netfilter/ipset/ip_set_core.c | 12 ++++++++++--
 net/netfilter/nf_tables_api.c     | 14 ++++++++++++--
 3 files changed, 23 insertions(+), 5 deletions(-)
-- 
2.41.0


