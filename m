Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27F08C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Sep 2021 14:40:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0823E61215
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Sep 2021 14:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242862AbhIIOlg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Sep 2021 10:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242097AbhIIOl1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Sep 2021 10:41:27 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38DABC066417;
        Thu,  9 Sep 2021 07:03:50 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mOKea-0003xf-2x; Thu, 09 Sep 2021 16:03:48 +0200
From:   Florian Westphal <fw@strlen.de>
To:     stable@vger.kernel.org
Cc:     <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH 5.10.y 0/3] netfilter: nf_tables fixes for 5.10.y
Date:   Thu,  9 Sep 2021 16:03:34 +0200
Message-Id: <20210909140337.29707-1-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

please consider applying these nf_tables fixes to the 5.10.y tree.
These patches had to mangled to make them apply to 5.10.y.

I've done the follwoing tests in a kasan/kmemleak enabled vm:
1. run upstream nft python/shell tests.
   Without patch 2 and 3 doing so results in kernel crash.
   Some tests fail but afaics those are expected to
   fail on 5.10 due to lack of feature being tested.
2. Tested the 'conncount' feature (its affected by last patch).
   Worked as designed.
3. ran nftables related kernel self tests.

No kmemleak or kasan splats were seen.

Eric Dumazet (1):
  netfilter: nftables: avoid potential overflows on 32bit arches

Pablo Neira Ayuso (2):
  netfilter: nf_tables: initialize set before expression setup
  netfilter: nftables: clone set element expression template

 net/netfilter/nf_tables_api.c | 89 ++++++++++++++++++++++-------------
 net/netfilter/nft_set_hash.c  | 10 ++--
 2 files changed, 62 insertions(+), 37 deletions(-)

-- 
2.32.0

