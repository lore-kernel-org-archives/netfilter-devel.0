Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8334BC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Dec 2021 13:12:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358199AbhLBNPl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 08:15:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346737AbhLBNPW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 08:15:22 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D3BC0613D7
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Dec 2021 05:11:47 -0800 (PST)
Received: from localhost ([::1]:37956 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mslsH-0001VW-6K; Thu, 02 Dec 2021 14:11:45 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 0/5] Reduce cache overhead a bit
Date:   Thu,  2 Dec 2021 14:11:31 +0100
Message-Id: <20211202131136.29242-1-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Second try after a quick review and some testing:

- Tested with stable kernels v4.4.293 and v4.9.291: This series does not
  change any of the shell tests' results. The changes are supposedly
  bug- and feature-compatible.

- Upon error return from kernel, check errno to make sure it is really
  ENOENT which is expected instead of ignoring any error with non-dump
  requests.

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
 src/mnl.c                                     |  93 +++++++--
 src/netlink.c                                 |  15 +-
 tests/shell/testcases/listing/0020flowtable_0 |  51 ++++-
 7 files changed, 248 insertions(+), 117 deletions(-)

-- 
2.33.0

