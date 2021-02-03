Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 141CCC433E0
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Feb 2021 17:00:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF61764F86
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Feb 2021 17:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhBCRAA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Feb 2021 12:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbhBCQ5x (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Feb 2021 11:57:53 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6A4C0613D6
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Feb 2021 08:57:13 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1l7LSq-0005LE-1P; Wed, 03 Feb 2021 17:57:12 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/3] nft: fix ct zone handling in sets and maps
Date:   Wed,  3 Feb 2021 17:57:03 +0100
Message-Id: <20210203165707.21781-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

'ct zone' (and other expressions w. host byte order and integer dtype)
are not handled correctly on little endian platforms.

First patch adds a test case that demonstrates the problem,
patch 2 and 3 resolve this for the mapping and set key cases.

Florian Westphal (3):
  tests: extend dtype test case to cover expression with integer type
  evaluate: pick data element byte order, not dtype one
  evaluate: set evaluation context for set elements

 src/evaluate.c                                | 13 ++++--
 .../testcases/sets/0029named_ifname_dtype_0   | 41 +++++++++++++++++
 .../sets/dumps/0029named_ifname_dtype_0.nft   | 44 ++++++++++++++++++-
 3 files changed, 93 insertions(+), 5 deletions(-)

-- 
2.26.2

