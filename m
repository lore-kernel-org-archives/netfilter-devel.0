Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 531E5C4167D
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Nov 2023 16:23:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbjKIQXN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Nov 2023 11:23:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjKIQXN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2023 11:23:13 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 850EC35AC
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 08:23:10 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     thaller@redhat.com, fw@strlen.de
Subject: [PATCH nft 00/12] update tests/shell for 5.4 kernels
Date:   Thu,  9 Nov 2023 17:22:52 +0100
Message-Id: <20231109162304.119506-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This is still not complete, still 8 tests/shell fail in 5.4 related to
flowtable features that are missing, but this batch is already getting large.

This is the series:

1) export DIFF so it can be used from feature scripts.
2) Detect if pipapo set backend is present.
3) Detect if reject from prerouting chain support is present.
4) Detect if stateful expression in sets is supported.
5) Detect if NAT netmap support is present.
6) Detect if multidevice netdev chain support is present.
7) Split several tests not to lose coverage, usually those containing
   set intervals and set intervals with concatenations (pipapo). It is
   a bit of sledgehammer solution but for tests/shell I think it is fine.

I can follow up with a more complete series contains all feature detection
for 5.4 or apply incrementally, just let me know.

Thanks.

Pablo Neira Ayuso (12):
  tests: shell: export DIFF to use it from feature scripts
  tests: shell: skip pipapo tests if kernel lacks support
  tests: shell: skip prerouting reject tests if kernel lacks support
  tests: shell: skip stateful expression in sets tests if kernel lacks support
  tests: shell: skip NAT netmap tests if kernel lacks support
  tests: shell: skip comment tests if kernel lacks support
  tests: shell: skip multidevice chain tests if kernel lacks support
  tests: shell: skip if kernel does not support bitshift
  tests: shell: split set NAT interval test
  tests: shell: split map test
  tests: shell: split single element in anonymous set
  tests: shell: split merge nat optimization in two tests

 tests/shell/features/comment.sh               | 11 +++
 .../features/netdev_chain_multidevice.sh      | 14 +++
 tests/shell/features/netmap.nft               |  8 ++
 tests/shell/features/pipapo.nft               |  9 ++
 tests/shell/features/prerouting_reject.nft    |  8 ++
 tests/shell/features/set_expr.sh              | 19 ++++
 tests/shell/run-tests.sh                      | 11 +--
 .../testcases/chains/0042chain_variable_0     |  2 +
 tests/shell/testcases/json/0002table_map_0    |  1 +
 tests/shell/testcases/json/0006obj_comment_0  |  1 +
 tests/shell/testcases/maps/0009vmap_0         |  2 +
 tests/shell/testcases/maps/0012map_0          | 19 ----
 tests/shell/testcases/maps/0012map_concat_0   | 24 ++++++
 tests/shell/testcases/maps/0013map_0          |  2 +
 tests/shell/testcases/maps/anon_objmap_concat |  2 +
 .../shell/testcases/maps/dumps/0012map_0.nft  | 13 ---
 .../testcases/maps/dumps/0012map_concat_0.nft | 14 +++
 tests/shell/testcases/maps/typeof_integer_0   |  2 +
 .../shell/testcases/maps/vmap_mark_bitwise_0  |  2 +
 .../optimizations/dumps/merge_nat.nft         |  8 --
 .../optimizations/dumps/merge_nat_concat.nft  |  8 ++
 .../optimizations/dumps/single_anon_set.nft   |  1 -
 .../dumps/single_anon_set_expr.nft            |  5 ++
 tests/shell/testcases/optimizations/merge_nat | 13 ---
 .../testcases/optimizations/merge_nat_concat  | 18 ++++
 .../optimizations/merge_stmts_concat          |  2 +
 .../testcases/optimizations/merge_stmts_vmap  |  2 +
 .../testcases/optimizations/merge_vmap_raw    |  2 +
 tests/shell/testcases/optimizations/ruleset   |  2 +
 .../testcases/optimizations/single_anon_set   |  3 -
 .../optimizations/single_anon_set_expr        | 26 ++++++
 .../testcases/optionals/comments_chain_0      |  2 +
 .../testcases/optionals/comments_objects_0    |  2 +
 .../testcases/optionals/comments_table_0      |  2 +
 tests/shell/testcases/sets/0020comments_0     |  2 +
 tests/shell/testcases/sets/0034get_element_0  |  2 +
 .../testcases/sets/0043concatenated_ranges_0  |  1 +
 .../testcases/sets/0043concatenated_ranges_1  |  2 +
 .../testcases/sets/0044interval_overlap_0     | 12 ++-
 tests/shell/testcases/sets/0046netmap_0       |  2 +
 tests/shell/testcases/sets/0047nat_0          |  2 +
 tests/shell/testcases/sets/0048set_counters_0 |  2 +
 .../testcases/sets/0051set_interval_counter_0 |  2 +
 .../testcases/sets/0067nat_concat_interval_0  | 17 +---
 tests/shell/testcases/sets/0067nat_interval_0 | 18 ++++
 tests/shell/testcases/sets/concat_interval_0  |  2 +
 .../sets/dumps/0067nat_concat_interval_0.nft  |  7 --
 .../sets/dumps/0067nat_interval_0.nft         | 12 +++
 tests/shell/testcases/sets/elem_opts_compat_0 |  2 +
 tests/shell/testcases/sets/typeof_sets_0      | 86 +++++++++----------
 50 files changed, 302 insertions(+), 129 deletions(-)
 create mode 100755 tests/shell/features/comment.sh
 create mode 100755 tests/shell/features/netdev_chain_multidevice.sh
 create mode 100644 tests/shell/features/netmap.nft
 create mode 100644 tests/shell/features/pipapo.nft
 create mode 100644 tests/shell/features/prerouting_reject.nft
 create mode 100755 tests/shell/features/set_expr.sh
 create mode 100755 tests/shell/testcases/maps/0012map_concat_0
 create mode 100644 tests/shell/testcases/maps/dumps/0012map_concat_0.nft
 create mode 100644 tests/shell/testcases/optimizations/dumps/merge_nat_concat.nft
 create mode 100644 tests/shell/testcases/optimizations/dumps/single_anon_set_expr.nft
 create mode 100755 tests/shell/testcases/optimizations/merge_nat_concat
 create mode 100755 tests/shell/testcases/optimizations/single_anon_set_expr
 create mode 100755 tests/shell/testcases/sets/0067nat_interval_0
 create mode 100644 tests/shell/testcases/sets/dumps/0067nat_interval_0.nft

-- 
2.30.2

