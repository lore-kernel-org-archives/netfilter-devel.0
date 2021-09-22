Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ED6FC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Sep 2021 16:06:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61F2760560
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Sep 2021 16:06:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbhIVQIX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Sep 2021 12:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232357AbhIVQIX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Sep 2021 12:08:23 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26894C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Sep 2021 09:06:53 -0700 (PDT)
Received: from localhost ([::1]:59558 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mT4ln-0006Pl-IE; Wed, 22 Sep 2021 18:06:51 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 0/4] nft: Fix and improve base chain handling
Date:   Wed, 22 Sep 2021 18:06:28 +0200
Message-Id: <20210922160632.15635-1-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a combined series of fixes and improvements:

* Patch 1 fixes a double free happening if the ruleset contains more
 than one base-chains for a given hook.

* Patch 2 improves iptables-nft behaviour in above case, allowing to
  continue even if there is a base chain which doesn't fit. Since
  iptables-nft doesn't fetch the full ruleset from kernel in all cases
  anymore, it is prone to miss offending ruleset parts, anyway.

* Patch 4 tries to avoid the negative side-effects that came with
  Florian's patch allowing to delete base-chains. 

* Patch 3 adds a bit of convenience used by patch 4.

Phil Sutter (4):
  nft: cache: Avoid double free of unrecognized base-chains
  nft: Check base-chain compatibility when adding to cache
  nft-chain: Introduce base_slot field
  nft: Delete builtin chains compatibly

 iptables/nft-cache.c                          |  52 +++++---
 iptables/nft-chain.h                          |   1 +
 iptables/nft-cmd.c                            |   2 +-
 iptables/nft.c                                | 112 +++++++-----------
 iptables/nft.h                                |   2 +
 .../shell/testcases/chain/0004extra-base_0    |  37 ++++++
 .../shell/testcases/chain/0005base-delete_0   |  34 ++++++
 iptables/xtables-save.c                       |   3 +
 8 files changed, 161 insertions(+), 82 deletions(-)
 create mode 100755 iptables/tests/shell/testcases/chain/0004extra-base_0
 create mode 100755 iptables/tests/shell/testcases/chain/0005base-delete_0

-- 
2.33.0

