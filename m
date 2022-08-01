Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 486B9C00144
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Aug 2022 13:56:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbiHAN4n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Aug 2022 09:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbiHAN4m (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Aug 2022 09:56:42 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1FB12DE8
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Aug 2022 06:56:41 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oIVuR-0000gj-Qg; Mon, 01 Aug 2022 15:56:39 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v2 0/8] really handle stacked l2 headers
Date:   Mon,  1 Aug 2022 15:56:25 +0200
Message-Id: <20220801135633.5317-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

v2:
- fix a UAF during rule listing.  When OP_AND gets culled,
  'expr' is free'd as well ahead of time because they alias one
  another in the set key case (there is no compare/relational op).
- add and handle plain 'vlan id' in a set key.
  in v1, this would be shown with the '& 0xfff' included, because
  v1 only removed OP_AND in concatenations.

Eric Garver reported a number of issues when matching vlan headers:

In:  update @macset { ether saddr . vlan id timeout 5s }
Out: update @macset { @ll,48,48 . @ll,112,16 & 0xfff timeout 5s }

This is because of amnesia in nft during expression decoding:
When we encounter 'vlan id', the L2 protocl (ethernet) is replaced by
vlan, so we attempt to match @ll,48,48 vs. the vlan header and come up
empty.

The vlan decode fails because we can't handle '& 0xfff' in this
instance, so we can locate the right offset but the payload expression
length doesn't match the template length (16 vs 12 bits).


The main patch is patch 3, which adds a stack of l2 protocols to track
instead of only keeping the cumulative size.

The latter is ok for serialization (we have the expression tree, so its
enough to add the size of the 'previous' l2 headers to payload
expressions that match the new 'top' l2 header.

But for deserialization, we need to be able to search all protocols base
headers seen.

The remaining patches improve handling of 'integer base type'
expressions and add test cases.

Florian Westphal (8):
  netlink_delinearize: allow postprocessing on concatenated elements
  netlink_delinearize: postprocess binary ands in concatenations
  proto: track full stack of seen l2 protocols, not just cumulative
    offset
  debug: dump the l2 protocol stack
  tests: add a test case for ether and vlan listing
  netlink_delinearize: also postprocess OP_AND in set element context
  evaluate: search stacked header list for matching payload dep
  src: allow anon set concatenation with ether and vlan

 include/netlink.h                             |  8 ++
 include/proto.h                               |  3 +-
 src/evaluate.c                                | 36 +++++--
 src/expression.c                              | 17 +++-
 src/netlink.c                                 | 10 +-
 src/netlink_delinearize.c                     | 59 ++++++++---
 src/payload.c                                 | 67 ++++++++++---
 src/proto.c                                   |  8 +-
 tests/py/bridge/vlan.t                        |  5 +
 tests/py/bridge/vlan.t.json                   | 97 +++++++++++++++++++
 tests/py/bridge/vlan.t.payload                | 28 ++++++
 tests/py/bridge/vlan.t.payload.netdev         | 34 +++++++
 .../testcases/sets/0070stacked_l2_headers     |  6 ++
 .../sets/dumps/0070stacked_l2_headers.nft     | 28 ++++++
 14 files changed, 368 insertions(+), 38 deletions(-)
 create mode 100755 tests/shell/testcases/sets/0070stacked_l2_headers
 create mode 100644 tests/shell/testcases/sets/dumps/0070stacked_l2_headers.nft

-- 
2.35.1

