Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B29A8C77B7E
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 May 2023 15:40:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241389AbjEYPka (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 May 2023 11:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241327AbjEYPka (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 May 2023 11:40:30 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 656F999
        for <netfilter-devel@vger.kernel.org>; Thu, 25 May 2023 08:40:28 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v1 0/6] nf_tables combo match
Date:   Thu, 25 May 2023 17:40:18 +0200
Message-Id: <20230525154024.222338-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This patchset provides the combo match for payload and the iifname and
oifname meta selector. The idea is to track and coalesce expressions in
an internal special combo expression. This batch adds support to coalesce
the following expressions:

	payload + cmp
	payload + bitwise + cmp
	meta {iifname,oifname} + cmp

The coalesce happens when the ruleset blob is built, the expression
tracking is done at rule level, ie. by iterating over the expressions
that represent the rule. The expression tracking happens twice, once to
calculate the ruleset blob (because the combo expression alters the
expected rule data size) and then to build the ruleset blob.

This batch replaces the existing approach which based on fast variants
of the cmp and bitwise expressions, that are also removed.

This combo expressions skips the store to register operation, instead
the payload and meta data are directly accessed for comparison.
This enters in conflict with recent's Florian patchset to remove the
inconditional initialization of the registers in the datapath because no
write to register happens for combo expressions. One possible solution
could be to build track and coalesce earlier and store the result in
nft_rule, then run Florian's register tracking to bail out on
uninitialized register read access at the cost of consuming more memory
per nft_rule object.

This is the patch series:

Patch #1 removes the expression reduce infrastructure in favour of this
         more simple approach to speed up built-in selectors in iptables.

Patch #2 removes fast bitwise and cmp expressions.

Patch #3 adds tracking infrastructure and the payload combo expression.
         This supports for payload whose size is <= 4 bytes and 16 bytes.

Patch #4 adds meta combo expression for iifname and oifname.

Patch #5 adds bitwise support to the payload combo expression, this
	 requires no changes to the datapath.

Patch #6 allows to skip comment match when building the ruleset blob.

The .track callback possible return values are these:

-1 skip this expression, for the comment match expression
 0 don't know what to do yet, this is to accumulate the expression in the
   stack until more expression are seen.
 1 write the expression stack into the ruleset blob, either the combo
   expression or the accumulated expressions that cannot be coalesced.

This approach is an alternative to the register track & reduce approach,
which so far works at chain level. Such approach requires descending the
tree of chains and tracking registers from base to leaf chains, this
becomes more complicated with dynamic ruleset, but it could be useful
for static rulesets, such approach also requires significant updates in
userspace. Therefore, I'm inclined towards this more simple solution.

One question with this update is whether removing the fast bitwise and
cmp variants slows down other (non-coalesced) expressions. The results
I collected with a simple ruleset to test worst case scenario like this:

	-m state --state ESTABLISHED -j DROP
	... 99 times more
	-m state --state NEW -j DROP  [ <- this is the matching rule ]

shows 301 Mb/s without this patchset vs 412 Mb/s with this patchset,
that it, results are better with this patchset while the payload and
meta expression that are coalesced show much better numbers.

I'm collecting more detailed numbers, I will post them soon.

Comments welcome, thanks.

Pablo Neira Ayuso (6):
  netfilter: nf_tables: remove expression reduce infrastructure
  netfilter: nf_tables: remove fast bitwise and cmp operations
  netfilter: nf_tables: add payload combo match
  netfilter: nf_tables: add meta combo match
  netfilter: nf_tables: add payload bitwise combo match
  netfilter: nf_tables: skip comment match when building blob

 include/net/netfilter/nf_tables.h        | 105 ++++++----
 include/net/netfilter/nf_tables_core.h   |  34 +---
 include/net/netfilter/nft_fib.h          |   2 -
 include/net/netfilter/nft_meta.h         |   3 -
 net/bridge/netfilter/nft_meta_bridge.c   |  20 --
 net/bridge/netfilter/nft_reject_bridge.c |   1 -
 net/ipv4/netfilter/nft_dup_ipv4.c        |   1 -
 net/ipv4/netfilter/nft_fib_ipv4.c        |   2 -
 net/ipv4/netfilter/nft_reject_ipv4.c     |   1 -
 net/ipv6/netfilter/nft_dup_ipv6.c        |   1 -
 net/ipv6/netfilter/nft_fib_ipv6.c        |   2 -
 net/ipv6/netfilter/nft_reject_ipv6.c     |   1 -
 net/netfilter/nf_tables_api.c            | 178 ++++++++++-------
 net/netfilter/nf_tables_core.c           | 122 ++++++++----
 net/netfilter/nft_bitwise.c              | 239 ++---------------------
 net/netfilter/nft_byteorder.c            |  11 --
 net/netfilter/nft_cmp.c                  | 213 ++------------------
 net/netfilter/nft_compat.c               |  12 +-
 net/netfilter/nft_connlimit.c            |   1 -
 net/netfilter/nft_counter.c              |   1 -
 net/netfilter/nft_ct.c                   |  46 -----
 net/netfilter/nft_dup_netdev.c           |   1 -
 net/netfilter/nft_dynset.c               |   1 -
 net/netfilter/nft_exthdr.c               |  34 ----
 net/netfilter/nft_fib.c                  |  42 ----
 net/netfilter/nft_fib_inet.c             |   1 -
 net/netfilter/nft_fib_netdev.c           |   1 -
 net/netfilter/nft_flow_offload.c         |   1 -
 net/netfilter/nft_fwd_netdev.c           |   2 -
 net/netfilter/nft_hash.c                 |  36 ----
 net/netfilter/nft_immediate.c            |  12 --
 net/netfilter/nft_last.c                 |   1 -
 net/netfilter/nft_limit.c                |   2 -
 net/netfilter/nft_log.c                  |   1 -
 net/netfilter/nft_lookup.c               |  12 --
 net/netfilter/nft_masq.c                 |   3 -
 net/netfilter/nft_meta.c                 |  77 +++-----
 net/netfilter/nft_nat.c                  |   2 -
 net/netfilter/nft_numgen.c               |  22 ---
 net/netfilter/nft_objref.c               |   2 -
 net/netfilter/nft_osf.c                  |  25 ---
 net/netfilter/nft_payload.c              |  99 ++++++----
 net/netfilter/nft_queue.c                |   2 -
 net/netfilter/nft_quota.c                |   1 -
 net/netfilter/nft_range.c                |   1 -
 net/netfilter/nft_redir.c                |   3 -
 net/netfilter/nft_reject_inet.c          |   1 -
 net/netfilter/nft_reject_netdev.c        |   1 -
 net/netfilter/nft_rt.c                   |   1 -
 net/netfilter/nft_socket.c               |  26 ---
 net/netfilter/nft_synproxy.c             |   1 -
 net/netfilter/nft_tproxy.c               |   1 -
 net/netfilter/nft_tunnel.c               |  26 ---
 net/netfilter/nft_xfrm.c                 |  27 ---
 54 files changed, 405 insertions(+), 1059 deletions(-)

-- 
2.30.2

