Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E94FC77B72
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Apr 2023 13:01:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbjDNNBn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Apr 2023 09:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDNNBm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Apr 2023 09:01:42 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9700810B
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2023 06:01:41 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pnJ3a-0001qR-PQ; Fri, 14 Apr 2023 15:01:38 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/4] netfilter: nf_tables: shrink stack usage a bit more
Date:   Fri, 14 Apr 2023 15:01:30 +0200
Message-Id: <20230414130134.29040-1-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Get rid of a few redundant pointers in the traceinfo structure.
The three removed pointers are used in the expression evaluation loop,
so gcc keeps them in registers.  Passing them to the (inlined) helpers
thus doesn't increase nft_do_chain text size, while stack is reduced
by another 24 bytes on 64bit arches.

These patches apply on top of 'netfilter: nf_tables: shrink jump stack size'.

Florian Westphal (4):
  netfilter: nf_tables: remove unneeded conditional
  netfilter: nf_tables: do not store pktinfo in traceinfo structure
  netfilter: nf_tables: do not store verdict in traceinfo structure
  netfilter: nf_tables: do not store rule in traceinfo structure

 include/net/netfilter/nf_tables.h | 12 +++------
 net/netfilter/nf_tables_core.c    | 42 ++++++++++++++++---------------
 net/netfilter/nf_tables_trace.c   | 38 +++++++++++++++-------------
 3 files changed, 46 insertions(+), 46 deletions(-)

-- 
2.39.2

