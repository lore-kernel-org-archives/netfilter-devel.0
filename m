Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36917C7EE23
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 May 2023 11:17:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbjEELRN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 May 2023 07:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231916AbjEELRJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 May 2023 07:17:09 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14AD1A107
        for <netfilter-devel@vger.kernel.org>; Fri,  5 May 2023 04:17:03 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1putQq-0005R7-UG; Fri, 05 May 2023 13:17:00 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/3] netfilter: nf_tables: reject loads from uninitialized registers
Date:   Fri,  5 May 2023 13:16:53 +0200
Message-Id: <20230505111656.32238-1-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Keep a per-rule bitmask that tracks registers that have seen a store,
then reject loads when the accessed registers haven't been flagged.

This changes uabi contract, because we previously allowed this.
Neither nftables nor iptables-nft create such rules.

In case there is breakage, we could insert an 'store 0 to x'
immediate expression into the ruleset automatically, but this
isn't done here.

Let me know if you think the "refuse" approach is too risky.

Florian Westphal (3):
  netfilter: nf_tables: pass context structure to
    nft_parse_register_load
  netfilter: nf_tables: validate register loads never access unitialised
    registers
  netfilter: nf_tables: don't initialize registers in nft_do_chain()

 include/net/netfilter/nf_tables.h      |  4 ++-
 net/bridge/netfilter/nft_meta_bridge.c |  2 +-
 net/ipv4/netfilter/nft_dup_ipv4.c      |  4 +--
 net/ipv6/netfilter/nft_dup_ipv6.c      |  4 +--
 net/netfilter/nf_tables_api.c          | 40 +++++++++++++++++++++++---
 net/netfilter/nf_tables_core.c         |  2 +-
 net/netfilter/nft_bitwise.c            |  4 +--
 net/netfilter/nft_byteorder.c          |  2 +-
 net/netfilter/nft_cmp.c                |  6 ++--
 net/netfilter/nft_ct.c                 |  2 +-
 net/netfilter/nft_dup_netdev.c         |  2 +-
 net/netfilter/nft_dynset.c             |  4 +--
 net/netfilter/nft_exthdr.c             |  2 +-
 net/netfilter/nft_fwd_netdev.c         |  6 ++--
 net/netfilter/nft_hash.c               |  2 +-
 net/netfilter/nft_lookup.c             |  2 +-
 net/netfilter/nft_masq.c               |  4 +--
 net/netfilter/nft_meta.c               |  2 +-
 net/netfilter/nft_nat.c                |  8 +++---
 net/netfilter/nft_objref.c             |  2 +-
 net/netfilter/nft_payload.c            |  2 +-
 net/netfilter/nft_queue.c              |  2 +-
 net/netfilter/nft_range.c              |  2 +-
 net/netfilter/nft_redir.c              |  4 +--
 net/netfilter/nft_tproxy.c             |  4 +--
 25 files changed, 76 insertions(+), 42 deletions(-)

-- 
2.39.2

