Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A434BC4332F
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Dec 2021 15:03:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239205AbhLAPHM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Dec 2021 10:07:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240647AbhLAPG4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Dec 2021 10:06:56 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A23C061757
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Dec 2021 07:03:35 -0800 (PST)
Received: from localhost ([::1]:35166 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1msR8w-00068C-2q; Wed, 01 Dec 2021 16:03:34 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 0/5] Reduce cache overhead a bit
Date:   Wed,  1 Dec 2021 16:02:53 +0100
Message-Id: <20211201150258.18436-1-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Comparing performance of various commands with equivalent iptables ones
I noticed that nftables fetches data from kernel it doesn't need in some
cases. For instance, listing one table was slowed down by a large other
table.

Since there is already code to filter data added to cache, make use of
that and craft GET requests to kernel a bit further so it returns only
what is needed.

This series is not entirely complete, e.g. objects are still fetched as
before. It rather converts some low hanging fruits.

Phil Sutter (5):
  cache: Filter tables on kernel side
  cache: Filter rule list on kernel side
  cache: Filter chain list on kernel side
  cache: Filter set list on server side
  cache: Support filtering for a specific flowtable

 include/cache.h                               |   1 +
 include/mnl.h                                 |  14 +-
 include/netlink.h                             |   3 +-
 src/cache.c                                   | 188 ++++++++++--------
 src/mnl.c                                     |  91 +++++++--
 src/netlink.c                                 |  15 +-
 tests/shell/testcases/listing/0020flowtable_0 |  51 ++++-
 7 files changed, 247 insertions(+), 116 deletions(-)

-- 
2.33.0

