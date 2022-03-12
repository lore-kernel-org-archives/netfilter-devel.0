Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD47EC433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Mar 2022 15:48:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbiCLPtX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 12 Mar 2022 10:49:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiCLPtX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 12 Mar 2022 10:49:23 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF7748A6CD
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2022 07:48:16 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id F027D60866
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2022 16:46:07 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 0/9] register tracking infrastructure follow up
Date:   Sat, 12 Mar 2022 16:48:02 +0100
Message-Id: <20220312154811.68611-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset follows up on the register tracking infrastructure:

1) Add NFT_REDUCE_READONLY pointer cookie and use it, this is used
   to describe expressions that perform read-only operations on registers.
   Add WARN_ON_ONCE() to check for expr->ops->reduce, all expressions
   must have one.

2) Cancel register tracking information for operations that are larger
   than 32-bits (one register). Add update/cancel helper functions and
   adapt existing code to use them.

3) Add .reduce support to nft_ct.

4) Add .reduce support to nft_lookup.

5) Add .reduce support for nft_meta_bridge.

6) Add .reduce support for nft_numgen.

7) Add .reduce support for nft_osf.

8) Add .reduce support for nft_hash (jhash and symhash)

9) Add .reduce support for nft_immediate

Missing expressions with no expr->ops->reduce after this round:

- dynset
- exthdr
- fib
- socket
- tunnel
- xfrm

Florian Westphal (2):
  netfilter: nft_lookup: only cancel tracking for clobbered dregs
  netfilter: nft_meta: extend reduce support to bridge family

Pablo Neira Ayuso (7):
  netfilter: nf_tables: do not reduce read-only expressions
  netfilter: nf_tables: cancel tracking for clobbered destination registers
  netfilter: nft_ct: track register operations
  netfilter: nft_numgen: cancel register tracking
  netfilter: nft_osf: track register operations
  netfilter: nft_hash: track register operations
  netfilter: nft_immediate: cancel register tracking for data destination register

 include/net/netfilter/nf_tables.h        | 15 ++++++++
 include/net/netfilter/nft_meta.h         |  3 ++
 net/bridge/netfilter/nft_meta_bridge.c   |  5 ++-
 net/bridge/netfilter/nft_reject_bridge.c |  1 +
 net/netfilter/nf_tables_api.c            | 47 ++++++++++++++++++++++-
 net/netfilter/nft_bitwise.c              |  8 ++--
 net/netfilter/nft_byteorder.c            |  3 +-
 net/netfilter/nft_cmp.c                  |  3 ++
 net/netfilter/nft_compat.c               |  1 +
 net/netfilter/nft_connlimit.c            |  1 +
 net/netfilter/nft_counter.c              |  1 +
 net/netfilter/nft_ct.c                   | 49 ++++++++++++++++++++++++
 net/netfilter/nft_dup_netdev.c           |  1 +
 net/netfilter/nft_flow_offload.c         |  1 +
 net/netfilter/nft_fwd_netdev.c           |  2 +
 net/netfilter/nft_hash.c                 | 37 ++++++++++++++++++
 net/netfilter/nft_immediate.c            | 12 ++++++
 net/netfilter/nft_last.c                 |  1 +
 net/netfilter/nft_limit.c                |  2 +
 net/netfilter/nft_log.c                  |  1 +
 net/netfilter/nft_lookup.c               | 12 ++++++
 net/netfilter/nft_masq.c                 |  3 ++
 net/netfilter/nft_meta.c                 | 16 ++++----
 net/netfilter/nft_nat.c                  |  2 +
 net/netfilter/nft_numgen.c               | 22 +++++++++++
 net/netfilter/nft_objref.c               |  2 +
 net/netfilter/nft_osf.c                  | 26 +++++++++++++
 net/netfilter/nft_payload.c              |  9 ++---
 net/netfilter/nft_queue.c                |  2 +
 net/netfilter/nft_quota.c                |  1 +
 net/netfilter/nft_range.c                |  1 +
 net/netfilter/nft_redir.c                |  3 ++
 net/netfilter/nft_reject_inet.c          |  1 +
 net/netfilter/nft_reject_netdev.c        |  1 +
 net/netfilter/nft_rt.c                   |  1 +
 net/netfilter/nft_synproxy.c             |  1 +
 net/netfilter/nft_tproxy.c               |  1 +
 37 files changed, 274 insertions(+), 24 deletions(-)

-- 
2.30.2

