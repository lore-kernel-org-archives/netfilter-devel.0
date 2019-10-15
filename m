Return-Path: <SRS0=TYlN=YI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 521AEECE588
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 11:42:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3447421848
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 11:42:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729153AbfJOLm3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Oct 2019 07:42:29 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:36592 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726472AbfJOLm2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Oct 2019 07:42:28 -0400
Received: from localhost ([::1]:49682 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iKLDf-0000zy-Ai; Tue, 15 Oct 2019 13:42:27 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v4 0/8] Improve iptables-nft performance with large rulesets
Date:   Tue, 15 Oct 2019 13:41:44 +0200
Message-Id: <20191015114152.25254-1-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fourth try at caching optimizations implementation.

Changes since v3:

* Rebase onto current master after pushing the accepted initial three
  patches.
* Avoid cache inconsistency in __nft_build_cache() if kernel ruleset
  changed since last call.

Phil Sutter (8):
  nft-cache: Introduce cache levels
  nft-cache: Fetch only chains in nft_chain_list_get()
  nft-cache: Cover for multiple fetcher invocation
  nft-cache: Support partial cache per table
  nft-cache: Support partial rule cache per chain
  nft: Reduce cache overhead of nft_chain_builtin_init()
  nft: Support nft_is_table_compatible() per chain
  nft: Optimize flushing all chains of a table

 iptables/nft-cache.c       | 203 ++++++++++++++++++++++++++++++-------
 iptables/nft-cache.h       |   9 +-
 iptables/nft.c             | 108 +++++++++++++-------
 iptables/nft.h             |  14 ++-
 iptables/xtables-restore.c |   4 +-
 iptables/xtables-save.c    |   4 +-
 6 files changed, 259 insertions(+), 83 deletions(-)

-- 
2.23.0

