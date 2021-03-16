Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42A43C433E9
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Mar 2021 23:41:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1605664EFD
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Mar 2021 23:41:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbhCPXlP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Mar 2021 19:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbhCPXkr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Mar 2021 19:40:47 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF23CC06174A
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Mar 2021 16:40:46 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lMJIp-00057f-Vk; Wed, 17 Mar 2021 00:40:44 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/6] arbirary table/chain names
Date:   Wed, 17 Mar 2021 00:40:33 +0100
Message-Id: <20210316234039.15677-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This series allows (almost) arbitrary chain names.

Unsolved problem:
nft has implict 'rule add' behaviour, e.g.

'nft add rule ip filter input foo ip saddr 1.2.3.4 drop' can be written like
'nft ip filter input foo ip saddr 1.2.3.4 drop' or even
'nft filter input foo ip saddr 1.2.3.4 drop'.

IOW, the scanner cannot switch to the exclusive rule scope
added in patch 5 to allow for arbitrary names.

Patch 6 resolves this by switching state from bison, but this
requires to add future tokens to a special whitelist.

It might be better to omit patch 6 and/or deprecate the
implicit rule add behaviour.  See patch 6 for details.

Florian Westphal (6):
  scanner: add support for scope nesting
  scanner: counter: move to own scope
  scanner: log: move to own scope
  scanner: support arbitary table names
  scanner: support arbitrary chain names
  src: allow arbitary chain name in implicit rule add case

 include/parser.h   |  12 ++++
 src/parser_bison.y |  97 ++++++++++++++++++-------
 src/scanner.l      | 173 +++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 241 insertions(+), 41 deletions(-)

-- 
2.26.2

