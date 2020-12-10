Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 688A8C4167B
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Dec 2020 13:07:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13D9E23D39
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Dec 2020 13:07:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389075AbgLJNHV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Dec 2020 08:07:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729355AbgLJNHV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Dec 2020 08:07:21 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DDAAC06179C
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Dec 2020 05:06:41 -0800 (PST)
Received: from localhost ([::1]:40978 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1knLeZ-0000gQ-Vo; Thu, 10 Dec 2020 14:06:40 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v3 0/9] nft: Sorted chain listing et al.
Date:   Thu, 10 Dec 2020 14:06:27 +0100
Message-Id: <20201210130636.26379-1-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a respin of my original series after getting rid of a few
initial ("fallout") patches. It implements structs nft_chain and
nft_chain_list to avoid changes to libnftnl as requested. Obviously this
introduces some code duplication as some bits from libnftnl have to be
replicated within iptables now.

Changes since v2:

* Reworded patch 1 comment to clarify what it fixes.

* Reordered patches so that nft_chain_foreach() introduced in patch
  3 replaces nft_chain_list_get().

* Drop getters previously introduced along with struct nft_chain to
  reduce size of patch 5. Extracting data from embedded nftnl_chain into
  nft_chain and back if needed is future work.

Phil Sutter (9):
  nft: Fix selective chain compatibility checks
  nft: cache: Introduce nft_cache_add_chain()
  nft: Implement nft_chain_foreach()
  nft: cache: Move nft_chain_find() over
  nft: Introduce struct nft_chain
  nft: Introduce a dedicated base chain array
  nft: cache: Sort custom chains by name
  tests: shell: Drop any dump sorting in place
  nft: Avoid pointless table/chain creation

 iptables/Makefile.am                          |   2 +-
 iptables/nft-cache.c                          | 162 ++++++---
 iptables/nft-cache.h                          |  11 +-
 iptables/nft-chain.c                          |  59 ++++
 iptables/nft-chain.h                          |  29 ++
 iptables/nft.c                                | 322 +++++++++++-------
 iptables/nft.h                                |  10 +-
 .../ebtables/0002-ebtables-save-restore_0     |   2 +-
 .../firewalld-restore/0001-firewalld_0        |  17 +-
 .../ipt-restore/0007-flush-noflush_0          |   4 +-
 .../ipt-restore/0014-verbose-restore_0        |   2 +-
 iptables/xtables-save.c                       |   8 +-
 12 files changed, 421 insertions(+), 207 deletions(-)
 create mode 100644 iptables/nft-chain.c
 create mode 100644 iptables/nft-chain.h

-- 
2.28.0

