Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D78BC4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Oct 2022 11:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiJQLER (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Oct 2022 07:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbiJQLEP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2022 07:04:15 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4F74C25D6
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2022 04:04:12 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 00/16] vxlan, geneve, gre, gretap matching support
Date:   Mon, 17 Oct 2022 13:03:52 +0200
Message-Id: <20221017110408.742223-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset adds support for vxlan, geneve, gre and gretap.
This patchset includes tests and documentation update.

1) Add eval_proto_ctx() to prepare for multiple protocol context to
   track inner and outer headers for the evaluation path.

2) Add dl_proto_ctx() to deal with multiple protocol context to track
   inner and outer header for the delinearize path.

3) Add vxlan support. This includes initial infrastructure for the
   new in-kernel inner expression. A protocol description is added to payload
   and meta expressions.

4) Add tests/py for vxlan.

5) Add tests/shell for vxlan.

6) Update vxlan documentation in nft(8) manpage.

7) Annotate --debug=proto-ctx for easier debugging of inner and outer
   protocol tracking.

8) Add gre support.

9) Add gre tests.

10) Update gre documentation in nft(8) manpage.

11) Add geneve support.

12) Add tests/py for geneve.

13) Update geneve documentation in nft(8) manpage.

14) Add gretap support

15) Add tests/py for gretap.

16) Update gretap documentation in nft(8) manpage.

Pablo Neira Ayuso (16):
  src: add eval_proto_ctx()
  src: add dl_proto_ctx()
  src: add vxlan matching support
  tests: py: add vxlan tests
  tests: shell: add vxlan set tests
  doc: add vxlan matching expression
  src: display (inner) tag in --debug=proto-ctx
  src: add gre support
  tests: py: add gre tests
  doc: add gre matching expression
  src: add geneve matching support
  tests: py: add geneve tests
  doc: add geneve matching expression
  src: add gretap support
  tests: py: add gretap tests
  doc: add gretap matching expression

 doc/payload-expression.txt                   | 154 ++++++++++
 include/expression.h                         |   2 +
 include/linux/netfilter/nf_tables.h          |  27 ++
 include/netlink.h                            |  11 +-
 include/parser.h                             |   1 +
 include/payload.h                            |   4 +
 include/proto.h                              |  58 +++-
 include/rule.h                               |   3 +-
 src/evaluate.c                               | 286 ++++++++++++-----
 src/expression.c                             |   1 +
 src/meta.c                                   |  21 +-
 src/netlink.c                                |   2 +-
 src/netlink_delinearize.c                    | 308 ++++++++++++++++---
 src/netlink_linearize.c                      |  80 ++++-
 src/parser_bison.y                           | 115 +++++++
 src/payload.c                                | 142 +++++++--
 src/proto.c                                  | 133 +++++++-
 src/rule.c                                   |   3 +-
 src/scanner.l                                |  13 +-
 src/xt.c                                     |   8 +-
 tests/py/inet/geneve.t                       |  23 ++
 tests/py/inet/geneve.t.payload               | 114 +++++++
 tests/py/inet/gre.t                          |  22 ++
 tests/py/inet/gre.t.payload                  |  78 +++++
 tests/py/inet/gretap.t                       |  21 ++
 tests/py/inet/gretap.t.payload               |  87 ++++++
 tests/py/inet/vxlan.t                        |  23 ++
 tests/py/inet/vxlan.t.payload                | 114 +++++++
 tests/shell/testcases/sets/dumps/inner_0.nft |  18 ++
 tests/shell/testcases/sets/inner_0           |  25 ++
 30 files changed, 1721 insertions(+), 176 deletions(-)
 create mode 100644 tests/py/inet/geneve.t
 create mode 100644 tests/py/inet/geneve.t.payload
 create mode 100644 tests/py/inet/gre.t
 create mode 100644 tests/py/inet/gre.t.payload
 create mode 100644 tests/py/inet/gretap.t
 create mode 100644 tests/py/inet/gretap.t.payload
 create mode 100644 tests/py/inet/vxlan.t
 create mode 100644 tests/py/inet/vxlan.t.payload
 create mode 100644 tests/shell/testcases/sets/dumps/inner_0.nft
 create mode 100755 tests/shell/testcases/sets/inner_0

--
2.30.2

