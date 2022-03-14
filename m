Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35DFCC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Mar 2022 17:23:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236139AbiCNRYa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Mar 2022 13:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiCNRYa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Mar 2022 13:24:30 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 724CC27CD8
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Mar 2022 10:23:19 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 39B5160240
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Mar 2022 18:21:02 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v3 00/14] register tracking infrastructure follow up
Date:   Mon, 14 Mar 2022 18:22:59 +0100
Message-Id: <20220314172313.63348-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: OpenGnSys Support Team <soporte-og@soleta.eu>

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

10) Add .reduce support for nft_socket

11) Add .reduce support for nft_xfrm

12) Add .reduce support for nft_tunnel

13) Add .reduce support for nft_exthdr

14) Add .reduce support for nft_fib

Florian Westphal (4):
  netfilter: nft_lookup: only cancel tracking for clobbered dregs
  netfilter: nft_meta: extend reduce support to bridge family
  netfilter: nft_fib: add reduce support
  netfilter: nft_exthdr: add reduce support

Pablo Neira Ayuso (10):
  netfilter: nf_tables: do not reduce read-only expressions
  netfilter: nf_tables: cancel tracking for clobbered destination registers
  netfilter: nft_ct: track register operations
  netfilter: nft_numgen: cancel register tracking
  netfilter: nft_osf: track register operations
  netfilter: nft_hash: track register operations
  netfilter: nft_immediate: cancel register tracking for data destination register
  netfilter: nft_socket: track register operations
  netfilter: nft_xfrm: track register operations
  netfilter: nft_tunnel: track register operations

 include/net/netfilter/nf_tables.h        | 22 ++++++++
 include/net/netfilter/nft_fib.h          |  3 +
 include/net/netfilter/nft_meta.h         |  3 +
 net/bridge/netfilter/nft_meta_bridge.c   |  5 +-
 net/bridge/netfilter/nft_reject_bridge.c |  1 +
 net/ipv4/netfilter/nft_dup_ipv4.c        |  1 +
 net/ipv4/netfilter/nft_fib_ipv4.c        |  2 +
 net/ipv4/netfilter/nft_reject_ipv4.c     |  1 +
 net/ipv6/netfilter/nft_dup_ipv6.c        |  1 +
 net/ipv6/netfilter/nft_fib_ipv6.c        |  2 +
 net/ipv6/netfilter/nft_reject_ipv6.c     |  1 +
 net/netfilter/nf_tables_api.c            | 70 +++++++++++++++++++++++-
 net/netfilter/nft_bitwise.c              | 24 +++++---
 net/netfilter/nft_byteorder.c            |  3 +-
 net/netfilter/nft_cmp.c                  |  3 +
 net/netfilter/nft_compat.c               |  1 +
 net/netfilter/nft_connlimit.c            |  1 +
 net/netfilter/nft_counter.c              |  1 +
 net/netfilter/nft_ct.c                   | 48 ++++++++++++++++
 net/netfilter/nft_dup_netdev.c           |  1 +
 net/netfilter/nft_dynset.c               |  1 +
 net/netfilter/nft_exthdr.c               | 33 +++++++++++
 net/netfilter/nft_fib.c                  | 42 ++++++++++++++
 net/netfilter/nft_fib_inet.c             |  1 +
 net/netfilter/nft_fib_netdev.c           |  1 +
 net/netfilter/nft_flow_offload.c         |  1 +
 net/netfilter/nft_fwd_netdev.c           |  2 +
 net/netfilter/nft_hash.c                 | 36 ++++++++++++
 net/netfilter/nft_immediate.c            | 12 ++++
 net/netfilter/nft_last.c                 |  1 +
 net/netfilter/nft_limit.c                |  2 +
 net/netfilter/nft_log.c                  |  1 +
 net/netfilter/nft_lookup.c               | 12 ++++
 net/netfilter/nft_masq.c                 |  3 +
 net/netfilter/nft_meta.c                 | 19 +++----
 net/netfilter/nft_nat.c                  |  2 +
 net/netfilter/nft_numgen.c               | 22 ++++++++
 net/netfilter/nft_objref.c               |  2 +
 net/netfilter/nft_osf.c                  | 25 +++++++++
 net/netfilter/nft_payload.c              | 12 ++--
 net/netfilter/nft_queue.c                |  2 +
 net/netfilter/nft_quota.c                |  1 +
 net/netfilter/nft_range.c                |  1 +
 net/netfilter/nft_redir.c                |  3 +
 net/netfilter/nft_reject_inet.c          |  1 +
 net/netfilter/nft_reject_netdev.c        |  1 +
 net/netfilter/nft_rt.c                   |  1 +
 net/netfilter/nft_socket.c               | 28 ++++++++++
 net/netfilter/nft_synproxy.c             |  1 +
 net/netfilter/nft_tproxy.c               |  1 +
 net/netfilter/nft_tunnel.c               | 28 ++++++++++
 net/netfilter/nft_xfrm.c                 | 28 ++++++++++
 52 files changed, 488 insertions(+), 32 deletions(-)

-- 
2.30.2

