Return-Path: <SRS0=245l=WZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1F85C3A59F
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Aug 2019 14:02:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BD55215EA
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Aug 2019 14:02:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbfH2OCP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Aug 2019 10:02:15 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:50836 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726283AbfH2OCP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Aug 2019 10:02:15 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1i3L09-0004Aa-5m; Thu, 29 Aug 2019 16:02:13 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     a@juaristi.eus
Subject: [PATCH nft 0/4] meta: introduce time/day/hour matching
Date:   Thu, 29 Aug 2019 16:09:00 +0200
Message-Id: <20190829140904.3858-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi.

This series contains the changes that I plan to apply to nftables.git
soon to get the 'time' matching feature in.

First patch is unchanged, second patch has the tests removed and
replaces 'day' parsing with one that is based on the symbol table
infra we already have.  This means 'nft describe meta day' will
now print all days plus their numeric value.

Third patch contains the test cases, I've moved them to 'any' because
time matching isn't ip specific.

Last match adds a patch to catch invalid days during eval step.

Ander Juaristi (3):
      evaluate: New internal helper __expr_evaluate_range
      meta: Introduce new conditions 'time', 'day' and 'hour'
      tests: add meta time test cases

Florian Westphal (1):
      src: evaluate: catch invalid 'meta day' values in eval step

 doc/nft.txt                         |    6 
 doc/primary-expression.txt          |   27 +++
 include/datatype.h                  |    6 
 include/linux/netfilter/nf_tables.h |    6 
 include/meta.h                      |    3 
 include/nftables.h                  |    5 
 include/nftables/libnftables.h      |    1 
 src/datatype.c                      |    3 
 src/evaluate.c                      |   91 +++++++++++-
 src/main.c                          |   12 +
 src/meta.c                          |  261 ++++++++++++++++++++++++++++++++++++
 src/parser_bison.y                  |    9 +
 src/scanner.l                       |    1 
 tests/py/any/meta.t                 |   19 ++
 tests/py/any/meta.t.json            |  233 ++++++++++++++++++++++++++++++++
 tests/py/any/meta.t.json.output     |  234 ++++++++++++++++++++++++++++++++
 tests/py/any/meta.t.payload         |   77 ++++++++++
 17 files changed, 982 insertions(+), 12 deletions(-)


