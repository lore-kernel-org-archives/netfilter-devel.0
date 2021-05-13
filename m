Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D381C433ED
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 May 2021 20:30:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C780E61421
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 May 2021 20:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbhEMUbQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 13 May 2021 16:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbhEMUbP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 May 2021 16:31:15 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2FB2C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 13 May 2021 13:30:05 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lhHy6-00037B-7m; Thu, 13 May 2021 22:30:02 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/2] nf_tables: avoid retpoline overhead on set lookups
Date:   Thu, 13 May 2021 22:29:54 +0200
Message-Id: <20210513202956.22709-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This adds a nft_set_do_lookup() helper, then extends it to use
direct calls when RETPOLINE feature is enabled.

For non-retpoline builds, nft_set_do_lookup() inline helper
does a indirect call.  INDIRECT_CALLABLE_SCOPE macro allows to
keep the lookup functions static in this case.

Florian Westphal (2):
  netfilter: add and use nft_set_do_lookup helper
  netfilter: nf_tables: prefer direct calls for set lookups

 include/net/netfilter/nf_tables_core.h | 30 ++++++++++++++++++++++
 net/netfilter/nft_lookup.c             | 35 ++++++++++++++++++++++++--
 net/netfilter/nft_objref.c             |  4 +--
 net/netfilter/nft_set_bitmap.c         |  5 ++--
 net/netfilter/nft_set_hash.c           | 17 +++++++------
 net/netfilter/nft_set_pipapo.c         |  5 ++--
 net/netfilter/nft_set_pipapo_avx2.h    |  2 --
 net/netfilter/nft_set_rbtree.c         |  5 ++--
 8 files changed, 84 insertions(+), 19 deletions(-)

-- 
2.26.3

