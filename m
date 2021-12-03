Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9340CC433FE
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Dec 2021 16:08:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381963AbhLCQL0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Dec 2021 11:11:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381953AbhLCQL0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Dec 2021 11:11:26 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FB1C061751
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Dec 2021 08:08:01 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mtB6O-00026h-7U; Fri, 03 Dec 2021 17:08:00 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 0/3] typeof fixes
Date:   Fri,  3 Dec 2021 17:07:52 +0100
Message-Id: <20211203160755.8720-1-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

First patch removes unused code fropm ipopt.
Second patch adds missing udata support for tcp/ip options and sctp
chunks.
Third patch fixes a crash in nft describe.

 include/ipopt.h                                    |  2 +-
 src/expression.c                                   |  8 ++--
 src/exthdr.c                                       | 47 ++++++++++++++++++----
 src/ipopt.c                                        | 26 +++---------
 src/parser_bison.y                                 |  8 +++-
 src/parser_json.c                                  |  4 +-
 tests/shell/testcases/parsing/describe             |  7 ++++
 tests/shell/testcases/sets/dumps/typeof_sets_0.nft | 27 +++++++++++++
 tests/shell/testcases/sets/typeof_sets_0           | 27 +++++++++++++
 9 files changed, 119 insertions(+), 37 deletions(-)

