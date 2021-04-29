Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32828C433ED
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 23:43:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C85C6147E
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 23:43:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbhD2Xns (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Apr 2021 19:43:48 -0400
Received: from mail.netfilter.org ([217.70.188.207]:59520 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhD2Xnr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Apr 2021 19:43:47 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id E5E8A64133
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Apr 2021 01:42:20 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 00/18] cache updates,v2
Date:   Fri, 30 Apr 2021 01:42:37 +0200
Message-Id: <20210429234255.16840-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This is another round of patches to update the cache infrastructure
in nftables:

1) Remove all nftables modules after running tests/shell.

2) Restore removal by 64-bit unique handle.

3) Consolidate cache infrastructure.

4) Add hashtable cache for remaining objects.

5) Track deletions on the cache.

Pablo Neira Ayuso (18):
  tests: shell: remove missing modules
  src: unbreak deletion by table handle
  rule: skip fuzzy lookup for unexisting 64-bit handle
  src: pass chain name to chain_cache_find()
  src: consolidate nft_cache infrastructure
  src: consolidate object cache infrastructure
  cache: add hashtable cache for object
  cache: add hashtable cache for flowtable
  cache: add set_cache_del() and use it
  evaluate: add set to the cache
  evaluate: add flowtable to the cache
  cache: missing table cache for several policy objects
  evaluate: add object to the cache
  cache: add hashtable cache for table
  evaluate: remove chain from cache on delete chain command
  evaluate: remove set from cache on delete set command
  evaluate: remove flowtable from cache on delete flowtable command
  evaluate: remove object from cache on delete object command

 include/cache.h                               |  60 ++-
 include/netlink.h                             |   2 +
 include/nftables.h                            |   8 +-
 include/rule.h                                |  31 +-
 src/cache.c                                   | 341 +++++++++++++++---
 src/cmd.c                                     |  17 +-
 src/evaluate.c                                | 275 +++++++++++---
 src/json.c                                    |  38 +-
 src/libnftables.c                             |  13 +-
 src/mnl.c                                     |   2 +-
 src/monitor.c                                 |  26 +-
 src/netlink.c                                 |  25 +-
 src/netlink_delinearize.c                     |   7 +-
 src/rule.c                                    | 170 ++++-----
 tests/shell/run-tests.sh                      |   5 +-
 .../testcases/cache/0008_delete_by_handle_0   |  20 +
 .../cache/0009_delete_by_handle_incorrect_0   |   8 +
 17 files changed, 738 insertions(+), 310 deletions(-)
 create mode 100755 tests/shell/testcases/cache/0008_delete_by_handle_0
 create mode 100755 tests/shell/testcases/cache/0009_delete_by_handle_incorrect_0

-- 
2.20.1

