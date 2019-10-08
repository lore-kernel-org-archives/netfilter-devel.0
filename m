Return-Path: <SRS0=bnKo=YB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 613BFC35280
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Oct 2019 16:15:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 366B02070B
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Oct 2019 16:15:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbfJHQPk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Oct 2019 12:15:40 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:48520 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725966AbfJHQPj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Oct 2019 12:15:39 -0400
Received: from localhost ([::1]:33378 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iHs9C-0004XW-PP; Tue, 08 Oct 2019 18:15:38 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v3 00/11] Improve iptables-nft performance with large rulesets
Date:   Tue,  8 Oct 2019 18:14:36 +0200
Message-Id: <20191008161447.6595-1-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Third approach at caching optimizations implementation.

The goal of reducing scope of cached data remains the same: First,
optimize cache depth (i.e., omit caching rules or chains if not needed).
Second, optimize cache width (i.e., cache only required chains).

Changes since v2:

* Move all cache-related code into a dedicated source file.
* Replace have_cache boolean by a cache level, indicating cache
  completeness from a depth view.
* Keep a central function to populate the cache, perform consistency
  checking based on generation ID and update cache level.

The first two patches contain preparational work for the changes
described above. Patch 3 performs the code relocation, patches 4 to 8
extend functionality of the separated caching code and the last three
patches optimize core code in nft.c to put optimized caching into full
effect.

A follow-up series will deal with xtables-restore performance.

Phil Sutter (11):
  nft: Pass nft_handle to flush_cache()
  nft: Avoid nested cache fetching
  nft: Extract cache routines into nft-cache.c
  nft-cache: Introduce cache levels
  nft-cache: Fetch only chains in nft_chain_list_get()
  nft-cache: Cover for multiple fetcher invocation
  nft-cache: Support partial cache per table
  nft-cache: Support partial rule cache per chain
  nft: Reduce cache overhead of nft_chain_builtin_init()
  nft: Support nft_is_table_compatible() per chain
  nft: Optimize flushing all chains of a table

 iptables/Makefile.am       |   2 +-
 iptables/nft-cache.c       | 498 +++++++++++++++++++++++++++++++++++++
 iptables/nft-cache.h       |  18 ++
 iptables/nft.c             | 487 +++++++-----------------------------
 iptables/nft.h             |  22 +-
 iptables/xtables-restore.c |   5 +-
 iptables/xtables-save.c    |   5 +-
 7 files changed, 623 insertions(+), 414 deletions(-)
 create mode 100644 iptables/nft-cache.c
 create mode 100644 iptables/nft-cache.h

-- 
2.23.0

