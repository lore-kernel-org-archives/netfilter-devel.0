Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9DA1C433B4
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 May 2021 12:08:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D1F2613B6
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 May 2021 12:08:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbhEUMKT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 May 2021 08:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhEUMKS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 May 2021 08:10:18 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A28C061574
        for <netfilter-devel@vger.kernel.org>; Fri, 21 May 2021 05:08:54 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lk3xV-0005ef-B3; Fri, 21 May 2021 14:08:53 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/3] hook dump support
Date:   Fri, 21 May 2021 14:08:43 +0200
Message-Id: <20210521120846.1140-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This adds nft-side support for the hook dump feature.
First patch adds scope for 'list' so that the new "hooks"
keyword won't interfere with table/rule parsing.

Second patch is the dump feature.
Last patch adds a LISTING section to the man page.

There is no libnftnl integration since the hook dump
is technically not related to nftables.

Florian Westphal (3):
  scanner: add list cmd parser scope
  src: add support for base hook dumping
  doc: add LISTING section

 doc/nft.txt                         |  13 ++
 include/linux/netfilter/nf_tables.h |   4 +
 include/mnl.h                       |   3 +
 include/parser.h                    |   1 +
 include/rule.h                      |   1 +
 src/evaluate.c                      |  10 ++
 src/mnl.c                           | 269 +++++++++++++++++++++++++++-
 src/parser_bison.y                  |  51 +++++-
 src/rule.c                          |  13 ++
 src/scanner.l                       |  16 +-
 10 files changed, 371 insertions(+), 10 deletions(-)

-- 
2.26.3

