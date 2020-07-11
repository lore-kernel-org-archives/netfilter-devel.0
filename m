Return-Path: <SRS0=5odi=AW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49B5BC433E4
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jul 2020 10:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 290DC206F4
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jul 2020 10:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgGKKS7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Jul 2020 06:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbgGKKS6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Jul 2020 06:18:58 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D88C08C5DD
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Jul 2020 03:18:58 -0700 (PDT)
Received: from localhost ([::1]:59424 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1juCau-0007EY-PT; Sat, 11 Jul 2020 12:18:57 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 00/18] nft: Sorted chain listing et al.
Date:   Sat, 11 Jul 2020 12:18:13 +0200
Message-Id: <20200711101831.29506-1-phil@nwl.cc>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Work in this series centered around Harald's complaint about seemingly
random custom chain ordering in iptables-nft-save output. In fact,
nftables returns chains in the order they were created which differs
from legacy iptables which sorts by name.

The intuitive approach of simply sorting chains in tables'
nftnl_chain_lists is problematic since base chains, which shall be
dumped first, are contained in there as well. Patch 15 solves this by
introducing a per-table array of nftnl_chain pointers to hold only base
chains (the hook values determine the array index). The old
nftnl_chain_list now contains merely non-base chains and is sorted upon
population by the new nftnl_chain_list_add_sorted() function.

Having dedicated slots for base chains allows for another neat trick,
namely to create only immediately required base chains. Apart from the
obvious case, where adding a rule to OUTPUT chain doesn't cause creation
of INPUT or FORWARD chains, this means ruleset modifications can be
avoided completely when listing, flushing or zeroing counters (unless
chains exist).

The first 14 patches are mostly just preliminary work and some
distinct optimizations found while working on the actual features.

Patch 15 introduces the mentioned base chain array and updates related
routines to be aware of the potential other location a given chain name
may be found in.

Patch 16 enables custom chain sorting at cache population time (or when
new chains are created by the user). It depends on my recent patch sent
for libnftnl.

Patch 17 drops the various workarounds from tests/shell dealing with
differing iptables-save output. This implicitly also enables testing of
the sorting feature.

Patch 18 Changes nft_xt_builtin_init() to accept a specific chain which
should be created, adds nft_xt_builtin_table_init() to create just the
table and no chains at all and nft_xt_fake_builtin_chains() to populate
empty base chain slots with fake entries for ruleset listing commands.

Phil Sutter (18):
  nft: Make table creation purely implicit
  nft: Be lazy when flushing
  nft: cache: Drop duplicate chain check
  nft: Drop pointless nft_xt_builtin_init() call
  nft: Turn nft_chain_save() into a foreach-callback
  nft: Use nft_chain_find() in two more places
  nft: Reorder enum nft_table_type
  nft: cache: Fetch only interesting tables from kernel
  nft: Use nftnl_chain_list_foreach in nft_rule_list{,_save}
  nft: Use nftnl_chain_list_foreach in nft_rule_flush
  nft: Use nftnl_chain_foreach in nft_rule_save
  nft: Fold nftnl_rule_list_chain_save() into caller
  nft: Implement nft_chain_foreach()
  nft: cache: Introduce nft_cache_add_chain()
  nft: Introduce a dedicated base chain array
  nft: cache: Sort custom chains by name
  tests: shell: Drop any dump sorting in place
  nft: Avoid pointless table/chain creation

 iptables/nft-cache.c                          | 107 ++--
 iptables/nft-cache.h                          |   3 +
 iptables/nft-cmd.c                            |   5 -
 iptables/nft.c                                | 466 +++++++++---------
 iptables/nft.h                                |  15 +-
 .../ebtables/0002-ebtables-save-restore_0     |   2 +-
 .../firewalld-restore/0001-firewalld_0        |  17 +-
 .../ipt-restore/0007-flush-noflush_0          |   4 +-
 .../ipt-restore/0014-verbose-restore_0        |   2 +-
 iptables/xtables-restore.c                    |   3 -
 iptables/xtables-save.c                       |   8 +-
 11 files changed, 335 insertions(+), 297 deletions(-)

-- 
2.27.0

