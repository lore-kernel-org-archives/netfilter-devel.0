Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3109FC433E9
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 15:46:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3DEA6528C
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 15:46:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbhCIPqB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Mar 2021 10:46:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbhCIPpc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Mar 2021 10:45:32 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C581C06174A
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Mar 2021 07:45:32 -0800 (PST)
Received: from localhost ([::1]:56644 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1lJeY6-00016X-SL; Tue, 09 Mar 2021 16:45:30 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 00/10] Kill non-default output leftovers
Date:   Tue,  9 Mar 2021 16:45:06 +0100
Message-Id: <20210309154516.4987-1-phil@nwl.cc>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Any other (debug) output format types than the default have been removed
for a while now. Assuming no new ones will be introduced anymore,
eliminate some of the still existing infrastructure accommodating for
them and a few obvious leftovers.

While working on the above, I identified some real issues (albeit only
triggered with very small output buffers. They come in patches 1-4,
separated by fixing commit.

Instead of proper testing these changes, I went with 'make check' and
running nftables' tests/py testsuite which actually compares the
libnftnl output against records.

Phil Sutter (10):
  expr: Fix snprintf buffer length updates
  obj/ct_expect: Fix snprintf buffer length updates
  obj/ct_timeout: Fix snprintf buffer length updates
  object: Fix for wrong parameter passed to snprintf callback
  expr: Check output type once and for all
  expr/data_reg: Drop output_format parameter
  obj: Drop type parameter from snprintf callback
  Drop pointless local variable in snprintf callbacks
  Get rid of single option switch statements
  ruleset: Eliminate tag and separator helpers

 include/data_reg.h      |   3 +-
 include/expr_ops.h      |   2 +-
 include/obj.h           |   2 +-
 src/chain.c             |  20 ++--
 src/expr.c              |  10 +-
 src/expr/bitwise.c      |  32 ++-----
 src/expr/byteorder.c    |  22 +----
 src/expr/cmp.c          |  24 +----
 src/expr/connlimit.c    |  20 +---
 src/expr/counter.c      |  20 +---
 src/expr/ct.c           |  23 +----
 src/expr/data_reg.c     |  35 ++-----
 src/expr/dup.c          |  25 +----
 src/expr/dynset.c       |  21 +----
 src/expr/exthdr.c       |  20 +---
 src/expr/fib.c          |  21 +----
 src/expr/flow_offload.c |  20 +---
 src/expr/fwd.c          |  21 +----
 src/expr/hash.c         |  21 +----
 src/expr/immediate.c    |  28 ++----
 src/expr/limit.c        |  20 +---
 src/expr/log.c          |  22 +----
 src/expr/lookup.c       |  21 +----
 src/expr/masq.c         |  20 +---
 src/expr/match.c        |  13 +--
 src/expr/meta.c         |  19 +---
 src/expr/nat.c          |  21 +----
 src/expr/numgen.c       |  21 +----
 src/expr/objref.c       |  20 +---
 src/expr/osf.c          |  22 +----
 src/expr/payload.c      |  32 +++----
 src/expr/queue.c        |  34 ++-----
 src/expr/quota.c        |  20 +---
 src/expr/range.c        |  24 +----
 src/expr/redir.c        |  28 ++----
 src/expr/reject.c       |  20 +---
 src/expr/rt.c           |  19 +---
 src/expr/socket.c       |  19 +---
 src/expr/synproxy.c     |  22 +----
 src/expr/target.c       |  13 +--
 src/expr/tproxy.c       |  19 +---
 src/expr/tunnel.c       |  19 +---
 src/expr/xfrm.c         |  21 +----
 src/flowtable.c         |  21 ++---
 src/gen.c               |  14 +--
 src/obj/counter.c       |  22 +----
 src/obj/ct_expect.c     |  39 +++-----
 src/obj/ct_helper.c     |  22 +----
 src/obj/ct_timeout.c    |  35 ++-----
 src/obj/limit.c         |  23 +----
 src/obj/quota.c         |  23 +----
 src/obj/secmark.c       |  23 +----
 src/obj/synproxy.c      |  22 +----
 src/obj/tunnel.c        |  21 +----
 src/object.c            |  28 ++----
 src/rule.c              |  22 ++---
 src/ruleset.c           | 200 +++++++++++++++-------------------------
 src/set.c               |  26 ++----
 src/set_elem.c          |  27 ++----
 src/table.c             |  16 +---
 60 files changed, 337 insertions(+), 1126 deletions(-)

-- 
2.30.1

