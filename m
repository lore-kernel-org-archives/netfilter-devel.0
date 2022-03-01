Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5084C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Mar 2022 20:58:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235306AbiCAU7W (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Mar 2022 15:59:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233898AbiCAU7V (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Mar 2022 15:59:21 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CA9CD50076
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Mar 2022 12:58:38 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2391160745
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Mar 2022 21:57:10 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v3 0/7] revisit overlap/automerge codebase
Date:   Tue,  1 Mar 2022 21:58:27 +0100
Message-Id: <20220301205834.290720-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This is another iteration on the set element automerge codebase.

This patchset removes the segment tree interval overlap/automerge codebase.
This is replaced with mergesort of the set elements + check for overlaps by
linearly iterating the set elements.

This version also contains support to delete via automerge which allows
you to merge new ranges to existing ones as well as to perform partial
deletions.

This adds a new testcases/sets/0069interval_merge_0.

This is passing tests/shell and tests/py.

Pablo Neira Ayuso (7):
  src: add EXPR_F_KERNEL to identify expression in the kernel
  src: replace interval segment tree overlap and automerge
  src: remove rbtree datastructure
  mnl: update mnl_nft_setelem_del() to allow for more reuse
  intervals: add support to automerge with kernel elements
  evaluate: allow for zero length ranges
  intervals: support to partial deletion with automerge

 include/Makefile.am                           |   2 +-
 include/expression.h                          |   7 +-
 include/intervals.h                           |  12 +
 include/mnl.h                                 |   3 +-
 include/rbtree.h                              |  98 ---
 include/rule.h                                |   2 +
 src/Makefile.am                               |   2 +-
 src/cache.c                                   |   6 +
 src/evaluate.c                                |  75 +-
 src/intervals.c                               | 740 ++++++++++++++++++
 src/libnftables.c                             |   4 +-
 src/mergesort.c                               |   1 +
 src/mnl.c                                     |   6 +-
 src/netlink.c                                 |   1 +
 src/rbtree.c                                  | 388 ---------
 src/rule.c                                    |  25 +-
 src/segtree.c                                 | 660 +---------------
 .../shell/testcases/sets/0069interval_merge_0 |  28 +
 .../sets/dumps/0069interval_merge_0.nft       |   9 +
 19 files changed, 895 insertions(+), 1174 deletions(-)
 create mode 100644 include/intervals.h
 delete mode 100644 include/rbtree.h
 create mode 100644 src/intervals.c
 delete mode 100644 src/rbtree.c
 create mode 100755 tests/shell/testcases/sets/0069interval_merge_0
 create mode 100644 tests/shell/testcases/sets/dumps/0069interval_merge_0.nft

-- 
2.30.2

