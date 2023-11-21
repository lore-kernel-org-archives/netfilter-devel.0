Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57E19C61D93
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Nov 2023 12:14:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234720AbjKUMO4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Nov 2023 07:14:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233940AbjKUMO4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Nov 2023 07:14:56 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D726185;
        Tue, 21 Nov 2023 04:14:52 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1r5PeT-00055o-VD; Tue, 21 Nov 2023 13:14:49 +0100
From:   Florian Westphal <fw@strlen.de>
To:     stable@vger.kernel.org
Cc:     <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.6.y 0/2] netfilter: fix catchall element double-free
Date:   Tue, 21 Nov 2023 13:14:20 +0100
Message-ID: <20231121121431.8612-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

This series contains the backports of two related changes to fix
removal of timed-out catchall elements.

As-is, removed element remains on the list and will be collected
again.

The adjustments are needed because of missing commit
0e1ea651c971 ("netfilter: nf_tables: shrink memory consumption of set elements"),
so we need to pass set_elem container struct instead of "elem_priv".

Pablo Neira Ayuso (2):
  netfilter: nf_tables: remove catchall element in GC sync path
  netfilter: nf_tables: split async and sync catchall in two functions

 net/netfilter/nf_tables_api.c | 53 ++++++++++++++++++++++++-----------
 1 file changed, 36 insertions(+), 17 deletions(-)

-- 
2.41.0

