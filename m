Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43A00C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Apr 2022 14:47:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236381AbiDLOtf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Apr 2022 10:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347926AbiDLOte (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Apr 2022 10:49:34 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1B85E5C86A
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2022 07:47:16 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v4 0/7] revisit overlap/automerge codebase
Date:   Tue, 12 Apr 2022 16:47:04 +0200
Message-Id: <20220412144711.93354-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This is another iteration of the set element automerge codebase rework,
posted last time in March 1st.

This series comes with a oneliner fix for Patch 2/7 "src: replace interval
segment tree overlap and automerge" that sets on i->elem_flags instead of
elem->elem_flags (this was breaking open intervals).

Now tests/monitor are passing fine in this batch.

This patchset removes the segment tree interval overlap/automerge codebase.
This is replaced with mergesort of the set elements + check for overlaps by
linearly iterating the set elements. This also allows to use automerge with
set element deletions.

This is passing tests/shell, tests/py and tests/monitor.

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

