Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D4A1CDB482
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Oct 2023 08:51:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjJRIvc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Oct 2023 04:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjJRIvb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Oct 2023 04:51:31 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA39AB6;
        Wed, 18 Oct 2023 01:51:29 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qt2Gw-0006Je-Vy; Wed, 18 Oct 2023 10:51:22 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH net-next 0/7] netfilter updates for net-next
Date:   Wed, 18 Oct 2023 10:51:04 +0200
Message-ID: <20231018085118.10829-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

This series contains initial netfilter skb drop_reason support, from
myself.

First few patches fix up a few spots to make sure we won't trip
when followup patches embed error numbers in the upper bits
(we already do this in some places).

Then, nftables and bridge netfilter get converted to call kfree_skb_reason
directly to let tooling pinpoint exact location of packet drops,
rather than the existing NF_DROP catchall in nf_hook_slow().

I would like to eventually convert all netfilter modules, but as some
callers cannot deal with NF_STOLEN (notably act_ct), more preparation
work is needed for this.

Last patch gets rid of an ugly 'de-const' cast in nftables.

The following changes since commit a0a86022474304e012aad5d41943fdd31a036284:

  Merge branch 'devlink-deadlock' (2023-10-18 09:23:02 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-23-10-18

for you to fetch changes up to 256001672153af5786c6ca148114693d7d76d836:

  netfilter: nf_tables: de-constify set commit ops function argument (2023-10-18 10:26:43 +0200)

----------------------------------------------------------------
netfilter next pull request 2023-10-18

----------------------------------------------------------------
Florian Westphal (7):
      netfilter: xt_mangle: only check verdict part of return value
      netfilter: nf_tables: mask out non-verdict bits when checking return value
      netfilter: conntrack: convert nf_conntrack_update to netfilter verdicts
      netfilter: nf_nat: mask out non-verdict bits when checking return value
      netfilter: make nftables drops visible in net dropmonitor
      netfilter: bridge: convert br_netfilter to NF_DROP_REASON
      netfilter: nf_tables: de-constify set commit ops function argument

 include/linux/netfilter.h            | 10 +++++++
 include/net/netfilter/nf_tables.h    |  2 +-
 net/bridge/br_netfilter_hooks.c      | 26 ++++++++--------
 net/bridge/br_netfilter_ipv6.c       |  6 ++--
 net/ipv4/netfilter/iptable_mangle.c  |  9 +++---
 net/ipv6/netfilter/ip6table_mangle.c |  9 +++---
 net/netfilter/core.c                 |  6 ++--
 net/netfilter/nf_conntrack_core.c    | 58 ++++++++++++++++++++----------------
 net/netfilter/nf_nat_proto.c         |  5 ++--
 net/netfilter/nf_tables_core.c       |  8 +++--
 net/netfilter/nf_tables_trace.c      |  8 +++--
 net/netfilter/nfnetlink_queue.c      | 15 ++++++----
 net/netfilter/nft_set_pipapo.c       |  7 ++---
 13 files changed, 100 insertions(+), 69 deletions(-)
