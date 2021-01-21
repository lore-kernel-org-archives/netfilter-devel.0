Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61F36C433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Jan 2021 13:56:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F9A8239A4
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Jan 2021 13:56:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730020AbhAUN4g (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Jan 2021 08:56:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729663AbhAUNz6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Jan 2021 08:55:58 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B3CC061575
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Jan 2021 05:55:17 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1l2aQd-00046x-9M; Thu, 21 Jan 2021 14:55:15 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/4] json test case fixups
Date:   Thu, 21 Jan 2021 14:55:06 +0100
Message-Id: <20210121135510.14941-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

json tests fail in several cases because test files were out of data.
This refreshs them.

One bug is genuine: in limit statement, json parser should treat
a missing burst as 5, not 0.

Florian Westphal (4):
  json: fix icmpv6.t test cases
  json: limit: set default burst to 5
  json: ct: add missing rule
  json: icmp: refresh json output

 src/parser_json.c                 |   2 +-
 tests/py/ip/ct.t.json             |  30 ++
 tests/py/ip/icmp.t.json           | 648 ++++++++++++++++++++++++++----
 tests/py/ip6/icmpv6.t.json        |  27 +-
 tests/py/ip6/icmpv6.t.json.output | 586 ++++++++++++++++++++++++++-
 5 files changed, 1196 insertions(+), 97 deletions(-)

-- 
2.26.2

