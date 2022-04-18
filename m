Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68B73C433FE
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Apr 2022 10:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237585AbiDRKMT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Apr 2022 06:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237321AbiDRKMN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Apr 2022 06:12:13 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3520F12AA3
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2022 03:09:32 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ngOK1-0008QU-Sj; Mon, 18 Apr 2022 12:09:29 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/2] allow base integer type in concatenation
Date:   Mon, 18 Apr 2022 12:09:22 +0200
Message-Id: <20220418100924.5669-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Now that we have typeof support for set keys there is no longer a
technical reason to reject use of datatypes with a zero size provided
that the set key concatenation can be used to retrieve a size instead.

This allows to use e.g. "ipsec in reqid" in a concatenated set key.

Florian Westphal (2):
  src: allow use of base integer types as set keys in concatenations
  tests: add concat test case with integer base type subkey

 src/evaluate.c                                | 24 +++++++++++++------
 .../testcases/maps/dumps/typeof_maps_0.nft    |  6 +++++
 tests/shell/testcases/maps/typeof_maps_0      |  6 +++++
 .../testcases/sets/dumps/typeof_sets_0.nft    |  9 +++++++
 tests/shell/testcases/sets/typeof_sets_0      |  9 +++++++
 5 files changed, 47 insertions(+), 7 deletions(-)

-- 
2.35.1

