Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B0EC77B73
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Jun 2023 16:35:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236543AbjFFQfp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Jun 2023 12:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233462AbjFFQfp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2023 12:35:45 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 70B7BE60
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2023 09:35:41 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nf-next,v2 0/7] nf_tables combo match
Date:   Tue,  6 Jun 2023 18:35:26 +0200
Message-Id: <20230606163533.1533-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This patchset provides the combo match for payload and the iifname and
oifname meta selector. The idea is to track and coalesce expressions in
an internal special combo expression. This batch adds support to
coalesce the following expressions:

      payload + cmp
      payload + bitwise + cmp
      meta {iifname,oifname} + cmp

The coalesce happens when the ruleset blob is built, the expression
tracking is done at rule level, ie. by iterating over the expressions
that represent the rule. The expression tracking happens twice, once to
calculate the ruleset blob (because the combo expression alters the
expected rule data size) and then to build the ruleset blob. If the
register tracking detects an access to uninitialized register,
including recycling a register that has been combo'ed, then combo logic
is disabled and the registers are zeroed at the basechain.

Main changes in v2:

Patch #1 no changes

Patch #2 do not remove 32-bit cmp fast, this helps for usual matching
	 on 32-bits selectors.

Patch #3 adds register tracking infrastructure for the combo match.
         This is new in this series and it is required to detect access
         of registers that has been combo'ed.

Patch #4 adds tracking infrastructure and the payload combo expression.
         This supports for payload whose size is <= 4 bytes and 16 bytes.
         This patch uses the register tracking infrastructure introduced
         in #3 to build the chain blob. There is a new skip_track flag
         that is set on in case that an expression performs an access
         to combo'ed register.

Patch #5 adds meta combo expression for iifname and oifname as noinline
         (per Florian). This v2 also fixes incorrect byteoder in the
	 bitmask calculation that is used to match the interface.

Patch #6 adds bitwise support to the payload combo expression, this
         requires no changes to the datapath.

Patch #7 allows to skip comment match when building the ruleset blob.

I'm exploring a patch to perform conditional register initialization
as Florian suggested using this new register tracking infrastructure.
The idea is to add a new flag in case that it detects what it might be
an uninitialized access to register, then add a new internal built-in
expression to the blob to memset register in the basechains, the
mechanism will be defensive, one access to uninitialized register
enables the zeroing in every basechain.

A few numbers in Mb/sec (w/retpoline) with N mismatching rules, then N+1
finds a matching rule bump counter and accept, with iptables-nft.

			 baseline	after
IPv4 address match:	  458		673
IPv6 address match:	  227		673
interface match:	  130[*]	424
ct state match:		  275		200[**]

[*]  by using IFNAMSIZ in iptables-nft, this should achieve similar
     numbers as IPv6 address, ie. 227.
[**] fast bitwise is removed in this batch, one possibility would be
     add a generic combo: bitwise + cmp that operates on registers,
     but iptables-nft does not use 'ct state', and upcoming nftables
     version allows to combine 'ct state' with vmap and counters.
     Numbers I collected in v1 were not correct for this one.

Pablo Neira Ayuso (7):
  netfilter: nf_tables: remove expression reduce infrastructure
  netfilter: nf_tables: remove fast bitwise and fast cmp16
  netfilter: nf_tables: track register store and load operations
  netfilter: nf_tables: add payload + cmp combo match
  netfilter: nf_tables: add meta + cmp combo match
  netfilter: nf_tables: add payload + bitwise + cmp combo match
  netfilter: nf_tables: skip comment match when building blob

 include/net/netfilter/nf_tables.h        | 141 +++++++++----
 include/net/netfilter/nf_tables_core.h   |  25 +--
 include/net/netfilter/nft_fib.h          |   6 +-
 include/net/netfilter/nft_meta.h         |   9 +-
 net/bridge/netfilter/nft_meta_bridge.c   |  22 +-
 net/bridge/netfilter/nft_reject_bridge.c |   2 +-
 net/ipv4/netfilter/nft_dup_ipv4.c        |  15 +-
 net/ipv4/netfilter/nft_fib_ipv4.c        |   4 +-
 net/ipv4/netfilter/nft_reject_ipv4.c     |   2 +-
 net/ipv6/netfilter/nft_dup_ipv6.c        |  15 +-
 net/ipv6/netfilter/nft_fib_ipv6.c        |   4 +-
 net/ipv6/netfilter/nft_reject_ipv6.c     |   2 +-
 net/netfilter/nf_tables_api.c            | 226 ++++++++++++++-------
 net/netfilter/nf_tables_core.c           | 112 ++++++++---
 net/netfilter/nft_bitwise.c              | 246 +++--------------------
 net/netfilter/nft_byteorder.c            |  14 +-
 net/netfilter/nft_cmp.c                  | 138 ++++---------
 net/netfilter/nft_compat.c               |  14 +-
 net/netfilter/nft_connlimit.c            |   2 +-
 net/netfilter/nft_counter.c              |   2 +-
 net/netfilter/nft_ct.c                   |  73 +++----
 net/netfilter/nft_dup_netdev.c           |  13 +-
 net/netfilter/nft_dynset.c               |  15 +-
 net/netfilter/nft_exthdr.c               |  47 ++---
 net/netfilter/nft_fib.c                  |  54 ++---
 net/netfilter/nft_fib_inet.c             |   2 +-
 net/netfilter/nft_fib_netdev.c           |   2 +-
 net/netfilter/nft_flow_offload.c         |   2 +-
 net/netfilter/nft_fwd_netdev.c           |  38 +++-
 net/netfilter/nft_hash.c                 |  39 ++--
 net/netfilter/nft_immediate.c            |  24 +--
 net/netfilter/nft_inner.c                |  10 +
 net/netfilter/nft_last.c                 |   2 +-
 net/netfilter/nft_limit.c                |   4 +-
 net/netfilter/nft_log.c                  |   2 +-
 net/netfilter/nft_lookup.c               |  26 +--
 net/netfilter/nft_masq.c                 |  20 +-
 net/netfilter/nft_meta.c                 |  80 ++++----
 net/netfilter/nft_nat.c                  |  34 +++-
 net/netfilter/nft_numgen.c               |  36 ++--
 net/netfilter/nft_objref.c               |  15 +-
 net/netfilter/nft_osf.c                  |  37 ++--
 net/netfilter/nft_payload.c              | 116 +++++++----
 net/netfilter/nft_queue.c                |  16 +-
 net/netfilter/nft_quota.c                |   2 +-
 net/netfilter/nft_range.c                |  13 +-
 net/netfilter/nft_redir.c                |  20 +-
 net/netfilter/nft_reject_inet.c          |   2 +-
 net/netfilter/nft_reject_netdev.c        |   2 +-
 net/netfilter/nft_rt.c                   |  15 +-
 net/netfilter/nft_socket.c               |  26 +--
 net/netfilter/nft_synproxy.c             |   2 +-
 net/netfilter/nft_tproxy.c               |  28 ++-
 net/netfilter/nft_tunnel.c               |  26 +--
 net/netfilter/nft_xfrm.c                 |  39 ++--
 55 files changed, 997 insertions(+), 886 deletions(-)

--
2.22.1
