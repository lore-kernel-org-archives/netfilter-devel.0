Return-Path: <SRS0=gJ4i=6M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7095FC83006
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 12:11:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5811E206D6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 12:11:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgD1MLH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Apr 2020 08:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726554AbgD1MLG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Apr 2020 08:11:06 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4314C03C1A9
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 05:11:06 -0700 (PDT)
Received: from localhost ([::1]:38656 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jTP4r-00087H-Du; Tue, 28 Apr 2020 14:11:05 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 00/18] iptables: introduce cache evaluation phase
Date:   Tue, 28 Apr 2020 14:09:55 +0200
Message-Id: <20200428121013.24507-1-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

As promised, here's a revised version of your cache rework series from
January. It restores performance according to my tests (which are yet to
be published somewhere) and passes the testsuites.

Patches 1-3 are code simplifications which are not directly related
to the actual caching changes.

Patch 4 enhances set fetching by adding support for passing a table name
to kernel but no set name. Not a big deal for iptables but it aligns the
code with chain fetching.

Patch 5 is a respin of a patch submitted a few weeks ago, namely adding
implicit commits to arptables- and ebtables-restore tools which don't
support explicit COMMIT lines in input. Big benefit here is that we
won't see consecutive commands for different tables anymore, so
selective cache fetching doesn't have to deal with too many odd cases.

Patches 6-10 are yours, I rebased and revisited them. Any changes are
recorded in per-patch changelogs.

Patch 11 simplifies fetch_set_cache() and fetch_rule_cache() functions
as they no longer have to be aware of previous invocations.

Patch 12 improves NFT_CL_FAKE integration considerably, easily possible
now that there is nft_cache_level_set() function.

Patch 13 introduces an embedded struct into struct nft_handle which
holds cache requirements collected from parsed commands. At first there
is just the desired cache level, further patches extend it.

Patches 14-16 re-establish per table/chain cache.

Patch 17 reduces cache requirements for flush command by making
nft_xt_builtin_init() cache-aware.

Patch 18 fixes the segfault reported in nfbz#1407.

Pablo Neira Ayuso (5):
  nft: split parsing from netlink commands
  nft: calculate cache requirements from list of commands
  nft: restore among support
  nft: remove cache build calls
  nft: missing nft_fini() call in bridge family

Phil Sutter (13):
  ebtables-restore: Drop custom table flush routine
  nft: cache: Eliminate init_chain_cache()
  nft: cache: Init per table set list along with chain list
  nft: cache: Fetch sets per table
  ebtables-restore: Table line to trigger implicit commit
  nft: cache: Simplify rule and set fetchers
  nft: cache: Improve fake cache integration
  nft: cache: Introduce struct nft_cache_req
  nft-cache: Fetch cache per table
  nft-cache: Introduce __fetch_chain_cache()
  nft: cache: Fetch cache for specific chains
  nft: cache: Optimize caching for flush command
  nft: Fix for '-F' in iptables dumps

 iptables/Makefile.am                          |   2 +-
 iptables/nft-arp.c                            |   5 +-
 iptables/nft-bridge.c                         |  18 +-
 iptables/nft-cache.c                          | 318 +++++++-------
 iptables/nft-cache.h                          |   6 +-
 iptables/nft-cmd.c                            | 387 ++++++++++++++++++
 iptables/nft-cmd.h                            |  79 ++++
 iptables/nft-shared.c                         |   6 +-
 iptables/nft-shared.h                         |   4 +-
 iptables/nft.c                                | 369 ++++++++++++-----
 iptables/nft.h                                |  62 ++-
 .../testcases/ip6tables/0004-return-codes_0   |   1 +
 .../testcases/iptables/0004-return-codes_0    |   6 +
 .../testcases/nft-only/0006-policy-override_0 |  29 ++
 iptables/xtables-arp.c                        |  26 +-
 iptables/xtables-eb-standalone.c              |   2 +
 iptables/xtables-eb.c                         |  26 +-
 iptables/xtables-restore.c                    | 126 +-----
 iptables/xtables-save.c                       |   3 +
 iptables/xtables.c                            |  57 ++-
 20 files changed, 1100 insertions(+), 432 deletions(-)
 create mode 100644 iptables/nft-cmd.c
 create mode 100644 iptables/nft-cmd.h
 create mode 100755 iptables/tests/shell/testcases/nft-only/0006-policy-override_0

-- 
2.25.1

