Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2DB3C433F5
	for <netfilter-devel@archiver.kernel.org>; Sun,  2 Jan 2022 22:15:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiABWPA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 2 Jan 2022 17:15:00 -0500
Received: from mail.netfilter.org ([217.70.188.207]:56126 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiABWO7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 2 Jan 2022 17:14:59 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8BD7E62BD8
        for <netfilter-devel@vger.kernel.org>; Sun,  2 Jan 2022 23:12:15 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables,v2 0/7] ruleset optimization infrastructure
Date:   Sun,  2 Jan 2022 23:14:45 +0100
Message-Id: <20220102221452.86469-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This patchset adds a new -o/--optimize option to enable ruleset
optimization. Two type of optimizations are supported in this batch:

* Use a set to compact several rules with the same selector using a set,
  for example:

      meta iifname eth1 ip saddr 1.1.1.1 ip daddr 2.2.2.3 accept
      meta iifname eth1 ip saddr 1.1.1.2 ip daddr 2.2.2.5 accept
      meta iifname eth2 ip saddr 1.1.1.3 ip daddr 2.2.2.6 accept

   into:

      meta iifname . ip saddr . ip daddr { eth1 . 1.1.1.1 . 2.2.2.6, eth1 . 1.1.1.2 . 2.2.2.5 , eth1 . 1.1.1.3 . 2.2.2.6 } accept

* Use a verdict map to compact rules with same selectors but different
  verdicts, for example:

      ip saddr 1.1.1.1 ip daddr 2.2.2.2 accept
      ip saddr 2.2.2.2 ip daddr 3.3.3.3 drop

   into:

      ip saddr . ip daddr vmap { 1.1.1.1 . 2.2.2.2 : accept, 2.2.2.2 . 3.3.3.3 : drop }

Updates since last patch series:

- display information on the rule merges that are proposed, this can be
  combined with -c to inspect the proposed ruleset updates.

  # nft -c -o -f ruleset.nft

  This allows sysadmins to review the proposed optimization without actually
  loading the ruleset, in case they prefer to manually edit their rulesets
  to apply the proposed optimizations (requested by Arturo).

- tests/py and tests/shell run fine after this new iteration.

- fix error reporting with /dev/stdin, which is a prerequisite for this
  series.

- fixes.

Pablo Neira Ayuso (7):
  erec: expose print_location() and line_location()
  src: error reporting with -f and read from stdin
  src: remove '$' in symbol_expr_print
  src: add ruleset optimization infrastructure
  optimize: merge rules with same selectors into a concatenation
  optimize: merge same selector with different verdict into verdict map
  optimize: merge several selectors with different verdict into verdict map

 doc/nft.txt                                   |   5 +
 include/erec.h                                |   5 +
 include/nftables.h                            |   5 +
 include/nftables/libnftables.h                |   7 +
 include/rule.h                                |   1 -
 src/Makefile.am                               |   1 +
 src/erec.c                                    |  87 ++-
 src/expression.c                              |  33 +-
 src/libnftables.c                             | 109 ++-
 src/libnftables.map                           |   5 +
 src/main.c                                    |   9 +-
 src/optimize.c                                | 698 ++++++++++++++++++
 src/scanner.l                                 |   2 +-
 .../optimizations/dumps/merge_stmts.nft       |   5 +
 .../dumps/merge_stmts_concat.nft              |   5 +
 .../dumps/merge_stmts_concat_vmap.nft         |   5 +
 .../optimizations/dumps/merge_stmts_vmap.nft  |   5 +
 .../shell/testcases/optimizations/merge_stmts |  13 +
 .../optimizations/merge_stmts_concat          |  13 +
 .../optimizations/merge_stmts_concat_vmap     |  13 +
 .../testcases/optimizations/merge_stmts_vmap  |  12 +
 21 files changed, 992 insertions(+), 46 deletions(-)
 create mode 100644 src/optimize.c
 create mode 100644 tests/shell/testcases/optimizations/dumps/merge_stmts.nft
 create mode 100644 tests/shell/testcases/optimizations/dumps/merge_stmts_concat.nft
 create mode 100644 tests/shell/testcases/optimizations/dumps/merge_stmts_concat_vmap.nft
 create mode 100644 tests/shell/testcases/optimizations/dumps/merge_stmts_vmap.nft
 create mode 100755 tests/shell/testcases/optimizations/merge_stmts
 create mode 100755 tests/shell/testcases/optimizations/merge_stmts_concat
 create mode 100755 tests/shell/testcases/optimizations/merge_stmts_concat_vmap
 create mode 100755 tests/shell/testcases/optimizations/merge_stmts_vmap

