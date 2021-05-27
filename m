Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4516C47089
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 May 2021 15:43:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78BDC61008
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 May 2021 15:43:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234993AbhE0PpE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 May 2021 11:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233848AbhE0PpE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 May 2021 11:45:04 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA639C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 27 May 2021 08:43:30 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lmIAR-0003Nl-Om; Thu, 27 May 2021 17:43:27 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/6] nftables: add --optimize support
Date:   Thu, 27 May 2021 17:43:17 +0200
Message-Id: <20210527154323.4003-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This adds a new option, -O/--optimize, to enable/disable ruleset
transformations.

First two supported optimizations are:
 1. Allow removal of implicit dependencies on 'list ruleset'.
 2. Allow automatic replacement of anonymous sets with only one
    element.

There is currently no exported libnftables function to provide
access to the internal settings.

If there is a use case it can be added later on.

Florian Westphal (6):
  src: add proto ctx options
  src: allow to turn off dependency removal
  main: add -O help to dump list of supported optimzation flags
  evaluate: optionally kill anon sets with one element
  tests: add test case for -O no-remove-dependencies
  tests: add test case for removal of anon sets with only a single
    element

 include/nftables.h                            |  12 +++
 include/proto.h                               |  10 +-
 include/rule.h                                |   6 ++
 src/evaluate.c                                |  25 ++++-
 src/libnftables.c                             |  10 ++
 src/main.c                                    | 100 ++++++++++++++++++
 src/netlink.c                                 |   2 +-
 src/netlink_delinearize.c                     |  16 ++-
 src/proto.c                                   |   4 +-
 .../optimizations/dumps/payload_meta_deps.nft |  10 ++
 .../dumps/payload_meta_deps.no-remove-deps    |  10 ++
 .../optimizations/dumps/single_anon_set.nft   |  12 +++
 .../single_anon_set.replace-single-anon-sets  |  12 +++
 .../testcases/optimizations/payload_meta_deps |  33 ++++++
 .../testcases/optimizations/single_anon_set   |  30 ++++++
 15 files changed, 282 insertions(+), 10 deletions(-)
 create mode 100644 tests/shell/testcases/optimizations/dumps/payload_meta_deps.nft
 create mode 100644 tests/shell/testcases/optimizations/dumps/payload_meta_deps.no-remove-deps
 create mode 100644 tests/shell/testcases/optimizations/dumps/single_anon_set.nft
 create mode 100644 tests/shell/testcases/optimizations/dumps/single_anon_set.replace-single-anon-sets
 create mode 100755 tests/shell/testcases/optimizations/payload_meta_deps
 create mode 100755 tests/shell/testcases/optimizations/single_anon_set

-- 
2.26.3

