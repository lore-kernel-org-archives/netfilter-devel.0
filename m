Return-Path: <SRS0=i/iJ=2H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85808C43603
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 11:27:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62D02207FF
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 11:27:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfLQL1U (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Dec 2019 06:27:20 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:57314 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726275AbfLQL1T (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Dec 2019 06:27:19 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ihB0Y-0006jr-1M; Tue, 17 Dec 2019 12:27:18 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v3 00/10] add typeof keyword
Date:   Tue, 17 Dec 2019 12:27:03 +0100
Message-Id: <20191217112713.6017-1-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch series adds the typeof keyword.

This depends on Pablos extensions to libnftnls udata parsing facilities.

named set can be configured as follows:

set os {
   typeof osf name
   elements = { "Linux", "Windows" }
}

The type is stored in the kernel via the udata infrastructure.
On listing -- if a udata type is present -- nft will validate that this
type matches the set key length and, if so, will print back the 'typeof'
information.

Note that while 'typeof' can be used with concatenations, they
only work as aliases for known types -- its currently not possible
to use integer/string types via the 'typeof' keyword (its rejected
at evaluation stage due to 0-length sub expression types).

Doing so requires a bit more work to dissect the correct key
geometry on netlink dumps.

In case typeof udata is not there/invalid, the normal 'type' syntax
is used.

This patch set isn't complete -- the test cases will not work
yet because 'meta' and 'osf' lack the udata parse/buil callbacks.

This is caught at the parsing stage.

The following changes since commit ddbe652bf0f4ed300bae9497250130d68e4cbf5b:

  py: load the SONAME-versioned shared object (2019-12-10 19:07:16 +0100)

are available in the Git repository at:

  git://git.breakpoint.cc/fw/nftables.git typeof_rework_09

for you to fetch changes up to 02485d775dea55a067c6dbea0826ab3fc9ff7398:

  tests: add typeof test cases (2019-12-17 12:19:51 +0100)

----------------------------------------------------------------
Florian Westphal (7):
      parser: add a helper for concat expression handling
      src: store expr, not dtype to track data in sets
      src: add "typeof" build/parse/print support
      mnl: round up the map data size too
      evaluate: print a hint about 'typeof' syntax on 0 keylen
      doc: mention 'typeof' as alternative to 'type' keyword
      tests: add typeof test cases

Pablo Neira Ayuso (3):
      proto: add proto_desc_id enumeration
      expr: add expr_ops_by_type()
      parser: add typeof keyword for declarations

 doc/nft.txt                                        |  12 +-
 include/datatype.h                                 |   1 -
 include/expression.h                               |   5 +
 include/netlink.h                                  |   1 -
 include/proto.h                                    |  27 ++++
 include/rule.h                                     |   7 +-
 src/datatype.c                                     |   5 -
 src/evaluate.c                                     |  81 +++++++----
 src/expression.c                                   |  14 +-
 src/json.c                                         |   4 +-
 src/mnl.c                                          |  30 ++++-
 src/monitor.c                                      |   2 +-
 src/netlink.c                                      | 149 +++++++++++++++++----
 src/parser_bison.y                                 | 148 +++++++++++---------
 src/parser_json.c                                  |   8 +-
 src/payload.c                                      |  75 +++++++++++
 src/proto.c                                        |  46 +++++++
 src/rule.c                                         |  48 +++++--
 src/scanner.l                                      |   1 +
 src/segtree.c                                      |   8 +-
 tests/shell/testcases/maps/dumps/typeof_maps_0.nft |  16 +++
 tests/shell/testcases/maps/typeof_maps_0           |  27 ++++
 tests/shell/testcases/sets/dumps/typeof_sets_0.nft |  19 +++
 tests/shell/testcases/sets/typeof_sets_0           |  29 ++++
 24 files changed, 621 insertions(+), 142 deletions(-)
 create mode 100644 tests/shell/testcases/maps/dumps/typeof_maps_0.nft
 create mode 100755 tests/shell/testcases/maps/typeof_maps_0
 create mode 100644 tests/shell/testcases/sets/dumps/typeof_sets_0.nft
 create mode 100755 tests/shell/testcases/sets/typeof_sets_0

