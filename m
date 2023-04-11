Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24AD4C77B70
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Apr 2023 14:30:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbjDKOa4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Apr 2023 10:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbjDKOaf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Apr 2023 10:30:35 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F8026194
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Apr 2023 07:30:01 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pmF0J-0002Lp-OV; Tue, 11 Apr 2023 16:29:51 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/3] netfilter: nf_tables: shrink jump stack size
Date:   Tue, 11 Apr 2023 16:29:44 +0200
Message-Id: <20230411142947.9038-1-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This series reworks nf_tables evaluation loop so that only the next
rule to run after returning from the chain needs to be saved.

This reduces nft_do_chain stack usage from 600 to 328 bytes.

There is more potential for reduction of stack usage by dieting
the traceinfo structure, I will look into this next.

Florian Westphal (3):
  netfilter: nf_tables: merge nft_rules_old structure and end of
    ruleblob marker
  netfilter: nf_tables: don't store address of last rule on jump
  netfilter: nf_tables: don't store chain address on jump

 include/net/netfilter/nf_tables.h | 14 ++++++--
 net/netfilter/nf_tables_api.c     | 56 +++++++++++++------------------
 net/netfilter/nf_tables_core.c    | 29 +++++-----------
 net/netfilter/nf_tables_trace.c   | 30 ++++++++++++++---
 4 files changed, 70 insertions(+), 59 deletions(-)

-- 
2.39.2

