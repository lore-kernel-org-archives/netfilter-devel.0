Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A597C433FE
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Sep 2022 13:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbiI3NC6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 30 Sep 2022 09:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiI3NC5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Sep 2022 09:02:57 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6BCCD16512A
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Sep 2022 06:02:55 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 0/6,v2] support for vxlan matching
Date:   Fri, 30 Sep 2022 15:02:42 +0200
Message-Id: <20220930130248.416386-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This is another round for the inner header matching support for vxlan.

This round includes updates for tests/py and tests/shell.

Several fixes since the previous round:

- incorrect ruleset listing due to incorrect logic in has_inner_desc().
- a few compilation warnings.
- use NFPROTO_BRIDGE as family base for inner matching, so proto_eth
  is used and NFT_META_PROTOCOL dependencies for matching on IPv4/IPv6
  is generated.
- concatenation now works.
- use of vxlan in set statements.
- missing vxlan flags support (reported by Simon G. Trajkovski)

Pablo Neira Ayuso (6):
  src: add eval_proto_ctx()
  src: add dl_proto_ctx()
  src: add vxlan matching support
  tests: py: add vxlan tests
  tests: shell: add vxlan set tests
  src: display (inner) tag in --debug=proto-ctx

 include/expression.h                         |   2 +
 include/linux/netfilter/nf_tables.h          |  26 ++
 include/netlink.h                            |  11 +-
 include/payload.h                            |   2 +
 include/proto.h                              |  29 ++-
 include/rule.h                               |   3 +-
 src/evaluate.c                               | 261 +++++++++++++------
 src/expression.c                             |   1 +
 src/meta.c                                   |  21 +-
 src/netlink.c                                |   2 +-
 src/netlink_delinearize.c                    | 259 ++++++++++++++----
 src/netlink_linearize.c                      |  80 +++++-
 src/parser_bison.y                           |  53 ++++
 src/payload.c                                |  95 +++++--
 src/proto.c                                  |  59 ++++-
 src/rule.c                                   |   3 +-
 src/scanner.l                                |   3 +
 src/xt.c                                     |   8 +-
 tests/py/inet/vxlan.t                        |  23 ++
 tests/py/inet/vxlan.t.payload                | 114 ++++++++
 tests/shell/testcases/sets/dumps/inner_0.nft |  18 ++
 tests/shell/testcases/sets/inner_0           |  25 ++
 22 files changed, 926 insertions(+), 172 deletions(-)
 create mode 100644 tests/py/inet/vxlan.t
 create mode 100644 tests/py/inet/vxlan.t.payload
 create mode 100644 tests/shell/testcases/sets/dumps/inner_0.nft
 create mode 100755 tests/shell/testcases/sets/inner_0

-- 
2.30.2

