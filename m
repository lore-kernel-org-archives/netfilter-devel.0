Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CBCDC48BE6
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Jun 2021 21:17:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C868613E4
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Jun 2021 21:17:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbhFPVT2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Jun 2021 17:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233836AbhFPVT2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Jun 2021 17:19:28 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9ABEC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Jun 2021 14:17:21 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ltcuW-0002St-0q; Wed, 16 Jun 2021 23:17:20 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     jake.owen@superloop.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/8] Enableruntime queue selection via jhash, numgen and map statement 
Date:   Wed, 16 Jun 2021 23:16:44 +0200
Message-Id: <20210616211652.11765-1-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Back in 2016 Liping Zhang added support to kernel and libnftnl to
specify a source register containing the queue number to use.

This was never added to nft itself, so allow this.

On linearization side, check if attached expression is a range.
If its not, allocate a new register and set NFTNL_EXPR_QUEUE_SREG_QNUM
attribute after generating the lowlevel expressions for the kernel.

On delinarization we need to check for presence of
NFTNL_EXPR_QUEUE_SREG_QNUM and decode the expression(s) when present.

Also need to do postprocessing for STMT_QUEUE so that the protocol
context is set correctly, without this only raw payload expressions
will be shown (@nh,32,...) instead of 'ip ...'.

Unfortunately, it turned out that just removing the eval checks
to allow arbitrary statements as 'num' argument results in parser
problems.

One example is this:
   queue num jhash ip saddr mod 4 bypass

This fails because scanner is still in 'ip' state, not 'queue', when
"bypass" is read, so this will not be recognized as belonging to the
queue statement.

This series solves this in the following way:
1. On output, nft will now always prepend the flags, i.e.
  queue flags bypass num 42

2. On input, 'queue num' is restricted to numbers and ranges.
This is backwards compatible because range and value were the
only permitted inputs (eval step rejects non-constant expressions).

3. To use numgen or jhash, new grammar is added:
 queue flags bypass to jhash ip saddr mod 4

I've restricted the 'to' expressions to numgen, (sym)hash and map
for now.

This can be relaxed later on if other usecases become available.

Florian Westphal (8):
  evaluate: fix hash expression maxval
  parser: restrict queue num expressiveness
  src: add queue expr and flags to queue_stmt_alloc
  parser: add queue_stmt_compat
  parser: new queue flag input format
  src: queue: allow use of arbitrary queue expressions
  tests: extend queue testcases for new sreg support
  src: queue: allow use of MAP statement for queue number retrieval

 doc/statements.txt           | 10 +++-
 include/statement.h          |  3 +-
 src/evaluate.c               | 21 +++++----
 src/netlink_delinearize.c    | 56 +++++++++++++++-------
 src/netlink_linearize.c      | 28 +++++++++--
 src/parser_bison.y           | 38 ++++++++++++---
 src/parser_json.c            | 22 ++++-----
 src/statement.c              | 30 +++++++++---
 tests/py/any/queue.t         | 18 ++++++--
 tests/py/any/queue.t.json    | 90 ++++++++++++++++++++++++++++++++++++
 tests/py/any/queue.t.payload | 25 ++++++++++
 11 files changed, 281 insertions(+), 60 deletions(-)

-- 
2.31.1

