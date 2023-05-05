Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C2D7C77B7C
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 May 2023 15:31:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbjEEPbr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 May 2023 11:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232951AbjEEPbp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 May 2023 11:31:45 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7F53065A0
        for <netfilter-devel@vger.kernel.org>; Fri,  5 May 2023 08:31:34 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH 00/11 nf-next,v1] track, reduce and prefetch expression
Date:   Fri,  5 May 2023 17:31:18 +0200
Message-Id: <20230505153130.2385-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This is v1 of a revamp of the track and reduce infrastructure. This is
targeted at linear rulesets which perform reiterative checks on the same
selectors, such as iptables-nft.

In this iteration, userspace specifies what expressions should be
prefetched by the kernel in the context of a given chain. The prefetch
operation in inconditional and it happens before the chain evaluation.
This prefetch operation is also subject to NFT_BREAK, therefore,
register tracking is also performed in runtime. The prefetched
expressions are specified via NFTA_CHAIN_EXPRESSION. Userspace might
decide to opt-out, ie. prefetch nothing at all.

Userspace deals with allocating the registers, so it has to carefully
select the register that already contains the prefetched expression (if
available). Based on this, the kernel reduces the expressions when the
ruleset blob is built, in case the register already contains the
expression data, based on the register tracking information that is
loaded via NFTA_CHAIN_EXPRESSION for expression to be prefetched. The
reduction is not done from userspace to allow for incremental ruleset
updates.

Currently returning from jump to chain also restores prefetched
registers when coming back to parent chain.

This batch is divided in three chunks:

Chunk #1: add nft_reg_load*() and nft_reg_store*() helpers to operate
on registers.

- Patch #1 adds a helper function to allocate and set up nft_expr_info
  structure.

- Patch #2 adds nft_reg_store*() helper function to write registers.

- Patch #3 updates nft_data_copy() to prepare to use nft_reg_load*().

- Patch #4 adds nft_reg_load*() helper function read registers.

- Patch #5 updates nft_reg_load*() to check for the validity bitmask.
  This tells if data is already present in the register, otherwise
  evaluation breaks. The validity register bitmask allows to remove
  the inconditional initialization of the registers (although Florian
  posted a patch to deal with this from ruleset load time) but this is
  still a requirement for the expression reduction coming in Chunk #3
  for the case where expression prefetch results in NFT_BREAK.

Chunk #2: more preparation work for the track & reduce infrastructure

- Patch #6: add struct nft_reg_track structure and adapt existing code to
  use it, this is used to store information on the existing prefetched
  expressions and how the expressions are reduced.

- Patch #7: extract the code to compare the existing register content with
  the expression.

- Patch #8: remove existing bitwise reduction by now to simplify things
  in this iteration.

- Patch #9: adds nft_reg_track_cancel() to cancel existing tracking
  information from the expression reduce step, in case userspace
  decides to evict a prefetched register at some point.

Chunk #3: add track, reduce and prefetch infra

- Patch #10 adds the expression prefetch support. The register tracking
  infers what expressions need to be prefetched. Then, the initial area
  of the chain blob stores the prefetch expressions. This also adds one
  extra field to jumpstack to store the blob, since returning from chain
  results in a new prefetch for the given chain.

- Patch #11 adds expression tracking infrastructure which is used by the
  prefetch support, to populate the initially prefetched registers. The
  expression reduction is only performed if prefetched expressions are
  available, so there is a way to disable expression reduction from
  userspace.

- Patch #12 re-enables reduce infrastructure.

Several things can probably be simplified, and I might need to rebase on
top of Florian's batch posted today. More runtime tests would be also
convenient, selftests/netfilter seem to run fine on my side and it already
helped me catch a few bugs.

Another idea: The prefetch infrastructure also allows to conditionally
run the packet parser that sets up nft_pktinfo based on requirements via
a new internal expression, according to the expression requirements that
can be described via struct nft_expr_ops (this is not done in this
batch), this is also relevant to skip IPv6 transport protocol parser if
user does not need it.

So surely this requires a v2.

Thanks.

Pablo Neira Ayuso (12):
  netfilter: nf_tables: add nft_reg_store_*() and use it
  netfilter: nf_tables: update nft_copy_data() to take struct nft_regs
  netfilter: nf_tables: add nft_reg_load*() and use it
  netfilter: nf_tables: check if register contains valid data before access
  netfilter: nf_tables: add struct nft_reg_track and use it
  netfilter: nf_tables: split expression comparison and reduction
  netfilter: nf_tables: remove bitwise register tracking
  netfilter: nf_tables: cancel tracking when register differs from expression
  netfilter: nf_tables: add track infrastructure to prepare for expression prefetch
  netfilter: nf_tables: add nft_expr_info_setup() helper function
  netfilter: nf_tables: add expression prefetch infrastructure
  netfilter: nf_tables: re-enable expression reduction

 include/net/netfilter/nf_tables.h        | 208 ++++++++++++---
 include/net/netfilter/nft_fib.h          |   3 +-
 include/net/netfilter/nft_meta.h         |   3 +
 include/uapi/linux/netfilter/nf_tables.h |   2 +
 net/bridge/netfilter/nft_meta_bridge.c   |  22 +-
 net/ipv4/netfilter/nft_dup_ipv4.c        |  26 +-
 net/ipv4/netfilter/nft_fib_ipv4.c        |  15 +-
 net/ipv6/netfilter/nft_dup_ipv6.c        |  20 +-
 net/ipv6/netfilter/nft_fib_ipv6.c        |  13 +-
 net/netfilter/nf_tables_api.c            | 321 ++++++++++++++++++++---
 net/netfilter/nf_tables_core.c           |  60 ++++-
 net/netfilter/nft_bitwise.c              | 122 ++-------
 net/netfilter/nft_byteorder.c            |  35 ++-
 net/netfilter/nft_cmp.c                  |   8 +-
 net/netfilter/nft_ct.c                   | 141 ++++++----
 net/netfilter/nft_ct_fast.c              |  12 +-
 net/netfilter/nft_dup_netdev.c           |  12 +-
 net/netfilter/nft_dynset.c               |  27 +-
 net/netfilter/nft_exthdr.c               |  88 ++++---
 net/netfilter/nft_fib.c                  |  86 ++++--
 net/netfilter/nft_fib_inet.c             |   1 +
 net/netfilter/nft_fib_netdev.c           |   1 +
 net/netfilter/nft_fwd_netdev.c           |  27 +-
 net/netfilter/nft_hash.c                 |  53 ++--
 net/netfilter/nft_immediate.c            |   2 +-
 net/netfilter/nft_lookup.c               |  17 +-
 net/netfilter/nft_masq.c                 |  18 +-
 net/netfilter/nft_meta.c                 | 237 ++++++++++-------
 net/netfilter/nft_nat.c                  |  61 +++--
 net/netfilter/nft_numgen.c               |   4 +-
 net/netfilter/nft_objref.c               |  17 +-
 net/netfilter/nft_osf.c                  |  46 ++--
 net/netfilter/nft_payload.c              |  77 ++++--
 net/netfilter/nft_queue.c                |  13 +-
 net/netfilter/nft_range.c                |  13 +-
 net/netfilter/nft_redir.c                |  18 +-
 net/netfilter/nft_rt.c                   |  18 +-
 net/netfilter/nft_socket.c               |  65 +++--
 net/netfilter/nft_tproxy.c               |  49 +++-
 net/netfilter/nft_tunnel.c               |  49 ++--
 net/netfilter/nft_xfrm.c                 |  58 ++--
 41 files changed, 1437 insertions(+), 631 deletions(-)

-- 
2.12.0
