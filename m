Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D62ADC433E6
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Feb 2021 18:42:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7146164F7C
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Feb 2021 18:42:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbhBCSmi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Feb 2021 13:42:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232131AbhBCSmh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Feb 2021 13:42:37 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF153C061573
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Feb 2021 10:41:56 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1l7N6B-0005wD-DX; Wed, 03 Feb 2021 19:41:55 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/3] evaluate: fix crash on empty set restore
Date:   Wed,  3 Feb 2021 19:41:50 +0100
Message-Id: <20210203184150.32145-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft crashes when it restores an empty set.
First patch moves two dump files to the correct location.
Those test cases now fail when the dump files are modified,
as expected.

Second patch adds crash reproducer test case.
Third patch avoids iteration when no statements exist in the set.

Florian Westphal (3):
  testcases: move two dump files to correct location
  tests: add empty dynamic set
  evaluate: do not crash if dynamic set has no statements

 src/evaluate.c                                   | 10 ++++++----
 .../dumps/0031priority_variable_0.nft}           |  0
 .../dumps/0035policy_variable_0.nft}             |  0
 tests/shell/testcases/nft-f/0025empty_dynset_0   | 16 ++++++++++++++++
 .../testcases/nft-f/dumps/0025empty_dynset_0.nft | 12 ++++++++++++
 5 files changed, 34 insertions(+), 4 deletions(-)
 rename tests/shell/testcases/{nft-f/dumps/0021priority_variable_0.nft => chains/dumps/0031priority_variable_0.nft} (100%)
 rename tests/shell/testcases/{nft-f/dumps/0025policy_variable_0.nft => chains/dumps/0035policy_variable_0.nft} (100%)
 create mode 100755 tests/shell/testcases/nft-f/0025empty_dynset_0
 create mode 100644 tests/shell/testcases/nft-f/dumps/0025empty_dynset_0.nft

-- 
2.26.2

