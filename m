Return-Path: <SRS0=EuAs=XL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E056C4CECD
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 16:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51B35214D9
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 16:50:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390204AbfIPQuQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Sep 2019 12:50:16 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:51154 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390198AbfIPQuP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Sep 2019 12:50:15 -0400
Received: from localhost ([::1]:36012 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1i9uCc-0003my-3C; Mon, 16 Sep 2019 18:50:14 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 00/14] Improve iptables-nft performance with large rulesets
Date:   Mon, 16 Sep 2019 18:49:46 +0200
Message-Id: <20190916165000.18217-1-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I came up with a bunch of tests to compare nft and legacy performance in
rulesets of varying size, so I could not only compare individual
performance but also scaling ability of each.

Initial results were sobering, current nft performs worse in all tests
and scales much worse in almost all of them. With this series applied,
nft is on par or better in most of the cases, often also scaling much
better. Leftovers are scenarios which require to fetch the large
ruleset, e.g. deleting a rule from a large chain or calling
iptables-restore with --noflush option.

Patches 1-6 are merely fallout, fixing things or improving code.

Patch 7 is the first performance-related one: Simply increasing
mnl_talk() receive buffer size speeds up all cache fetches.

The remaining patches uniformly deal with caching: Either avoiding
the cache entirely or allowing for finer granular cache content
selection.

Phil Sutter (14):
  tests/shell: Make ebtables-basic test more verbose
  tests/shell: Speed up ipt-restore/0004-restore-race_0
  DEBUG: Print to stderr to not disturb iptables-save
  nft: Use nftnl_*_set_str() functions
  nft: Introduce nft_bridge_commit()
  nft: Fix for add and delete of same rule in single batch
  nft Increase mnl_talk() receive buffer size
  xtables-restore: Avoid cache population when flushing
  nft: Rename have_cache into have_chain_cache
  nft: Fetch rule cache only if needed
  nft: Allow to fetch only a specific chain from kernel
  nft: Support fetching rules for a single chain only
  nft: Optimize flushing all chains of a table
  nft: Reduce impact of nft_chain_builtin_init()

 iptables/nft.c                                | 285 +++++++++++++-----
 iptables/nft.h                                |  13 +-
 .../testcases/ebtables/0001-ebtables-basic_0  |  28 +-
 .../ipt-restore/0003-restore-ordering_0       |  18 +-
 .../testcases/ipt-restore/0004-restore-race_0 |   4 +-
 iptables/xshared.h                            |   2 +-
 iptables/xtables-eb-standalone.c              |   2 +-
 iptables/xtables-restore.c                    |  11 +-
 iptables/xtables-save.c                       |   4 +-
 9 files changed, 268 insertions(+), 99 deletions(-)

-- 
2.23.0

