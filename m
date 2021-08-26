Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0C21C432BE
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Aug 2021 13:54:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5AF560F21
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Aug 2021 13:54:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234615AbhHZNzU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Aug 2021 09:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231934AbhHZNzT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Aug 2021 09:55:19 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47572C061757
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Aug 2021 06:54:32 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mJFpu-0000YG-4h; Thu, 26 Aug 2021 15:54:30 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 0/3] netfilter: conntrack: switch to siphash
Date:   Thu, 26 Aug 2021 15:54:18 +0200
Message-Id: <20210826135422.31063-1-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Two recent commits switched inet rt and nexthop exception
hashes from jhash to siphash.

If those two spots are problematic then conntrack is affected
as well, so switch voer to siphash too.

While at it, add a hard upper limit on chain lengths and reject
insertion if this is hit.

Florian Westphal (3):
  netfilter: conntrack: sanitize table size default settings
  netfilter: conntrack: switch to siphash
  netfilter: conntrack: refuse insertion if chain has grown too large

 .../networking/nf_conntrack-sysctl.rst        |  13 ++-
 include/linux/netfilter/nf_conntrack_common.h |   1 +
 .../linux/netfilter/nfnetlink_conntrack.h     |   1 +
 net/netfilter/nf_conntrack_core.c             | 103 ++++++++++++------
 net/netfilter/nf_conntrack_expect.c           |  25 +++--
 net/netfilter/nf_conntrack_netlink.c          |   4 +-
 net/netfilter/nf_conntrack_standalone.c       |   4 +-
 net/netfilter/nf_nat_core.c                   |  18 ++-
 8 files changed, 114 insertions(+), 55 deletions(-)

-- 
2.31.1

