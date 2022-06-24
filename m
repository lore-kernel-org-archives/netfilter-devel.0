Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ABA6C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Jun 2022 09:26:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbiFXJ0G (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Jun 2022 05:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbiFXJ0F (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Jun 2022 05:26:05 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681446DB12
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Jun 2022 02:26:04 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1o4fZg-0003oG-Ni; Fri, 24 Jun 2022 11:26:00 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/3] parser: fix scope closing with > 1 nested scope
Date:   Fri, 24 Jun 2022 11:25:52 +0200
Message-Id: <20220624092555.1572-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This resolves the parsing problem reported by Phil.
First patch is his test case, second patch is an
(unrelated) fix for SYNPROXY scoping (lack of close).

Last patch fixes closing with nested scopes, where we exited
a scope too early.

Florian Westphal (2):
  parser: add missing synproxy scope closure
  scanner: don't pop active flex scanner scope

Phil Sutter (1):
  tests/py: Add a test for failing ipsec after counter

 include/parser.h              |  3 +++
 src/parser_bison.y            |  2 +-
 src/scanner.l                 | 11 +++++++++++
 tests/py/inet/ipsec.t         |  2 ++
 tests/py/inet/ipsec.t.json    | 21 +++++++++++++++++++++
 tests/py/inet/ipsec.t.payload |  6 ++++++
 6 files changed, 44 insertions(+), 1 deletion(-)

-- 
2.35.1

