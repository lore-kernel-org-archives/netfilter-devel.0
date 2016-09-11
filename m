From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH libnftnl 0/3] expr: queue: add sreg_from and sreg_to support
Date: Sun, 11 Sep 2016 22:11:21 +0800
Message-ID: <1473603084-33964-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-12.163.com ([220.181.12.12]:49355 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755728AbcIKOL5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 11 Sep 2016 10:11:57 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

This patch sets mainly used to add NFTA_QUEUE_SREG_FROM and NFTA_QUEUE_SREG_TO
attributes support in libnftnl. Meanwhile, I find some trivial bugs exsit in
queue expr. So try to fix them at patch #1 and patch #2.

Liping Zhang (3):
  expr: queue: remove redundant NFTNL_EXPR_QUEUE_NUM set in json parse
  tests: queue: add missing NFTNL_EXPR_QUEUE_FLAGS compare test
  expr: queue: add sreg_from and sreg_to support

 include/buffer.h                    |  2 +
 include/libnftnl/expr.h             |  2 +
 include/linux/netfilter/nf_tables.h |  4 ++
 src/expr/queue.c                    | 85 +++++++++++++++++++++++++++++++++----
 tests/nft-expr_queue-test.c         | 11 +++++
 5 files changed, 96 insertions(+), 8 deletions(-)

-- 
2.5.5


