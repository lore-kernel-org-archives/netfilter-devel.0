Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCEC8CDB47E
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Oct 2023 12:18:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbjJMMSc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Oct 2023 08:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231409AbjJMMSb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Oct 2023 08:18:31 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B1C0A9
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Oct 2023 05:18:29 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qrH7b-0007eB-5o; Fri, 13 Oct 2023 14:18:27 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/3] netfilter: nf_tables: remove rbtree async garbage collection
Date:   Fri, 13 Oct 2023 14:18:13 +0200
Message-ID: <20231013121821.31322-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The 'rbtree' set backend does not support insertion/removal of elements
from the datapath (ruleset).

Elements can only be added from the control plane, so there is no
compelling reason for regular, async gc scans in the background.

Change rbtree to use the existing 'commit' callback to do a gc scan
instead.  This is run as a last step in the commit phase, when all
checks have passed.

This makes rbtree less complex. It also avoids the need to use atomic
allocations during gc: the commit hook is allowed to sleep, the
transaction mutex prevents any interference during walk.

Florian Westphal (3):
  netfilter: nf_tables: de-constify set commit ops function argument
  netfilter: nft_set_rbtree: rename gc deactivate+erase function
  netfilter: nft_set_rbtree: prefer sync gc to async worker

 include/net/netfilter/nf_tables.h |   2 +-
 net/netfilter/nft_set_pipapo.c    |   7 +-
 net/netfilter/nft_set_rbtree.c    | 135 ++++++++++++++++--------------
 3 files changed, 75 insertions(+), 69 deletions(-)
-- 
2.41.0

