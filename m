Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 583C1CD98F9
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Oct 2023 07:59:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345140AbjJKH76 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Oct 2023 03:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345349AbjJKH76 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2023 03:59:58 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D26CAC
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Oct 2023 00:59:56 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qqU8I-0006ty-EC; Wed, 11 Oct 2023 09:59:54 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/6] netfilter: more accurate drop statistics
Date:   Wed, 11 Oct 2023 09:59:33 +0200
Message-ID: <20231011075944.2301-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This series adds the skeleton to improve drop statistics in
netfilter and converts nf_tables core and bridge netfilter to use it.

"return NF_DROP" can now optionally be replaced with
"return NF_DROP_REASON(skb, REASON_CODE, errno)".

This allows drop monitoring tools to pinpoint the exact location
where the packet drop occured. For example,
      "ip saddr @deny drop"

will now be attributed to nft_do_chain(). Thanks to location
information, its even possible to differentiate between a
drop rule and a 'fallthrough' to a 'drop policy'.

Before this series, all netfilter packet drops got attributed
to the same location in nf_hook_slow().

Florian Westphal (6):
  netfilter: xt_mangle: only check verdict part of return value
  netfilter: nf_tables:  mask out non-verdict bits when checking return
    value
  netfilter: conntrack: convert nf_conntrack_update to netfilter
    verdicts
  netfilter: nf_nat: mask out non-verdict bits when checking return
    value
  netfilter: make nftables drops visible in net dropmonitor
  netfilter: bridge: convert br_netfilter to NF_DROP_REASON

 include/linux/netfilter.h            | 10 +++++
 net/bridge/br_netfilter_hooks.c      | 26 ++++++-------
 net/bridge/br_netfilter_ipv6.c       |  6 +--
 net/ipv4/netfilter/iptable_mangle.c  |  9 +++--
 net/ipv6/netfilter/ip6table_mangle.c |  9 +++--
 net/netfilter/core.c                 |  6 +--
 net/netfilter/nf_conntrack_core.c    | 58 ++++++++++++++++------------
 net/netfilter/nf_nat_proto.c         |  5 ++-
 net/netfilter/nf_tables_core.c       |  8 +++-
 net/netfilter/nf_tables_trace.c      |  8 +++-
 net/netfilter/nfnetlink_queue.c      | 15 ++++---
 11 files changed, 96 insertions(+), 64 deletions(-)

-- 
2.41.0

