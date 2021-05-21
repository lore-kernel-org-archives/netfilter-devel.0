Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 581B5C433ED
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 May 2021 11:39:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37372613DD
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 May 2021 11:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233371AbhEULlB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 May 2021 07:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233128AbhEULkz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 May 2021 07:40:55 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272E9C061574
        for <netfilter-devel@vger.kernel.org>; Fri, 21 May 2021 04:39:31 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lk3V2-0005Vz-OU; Fri, 21 May 2021 13:39:28 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/4] netfilter: add hook dump feature
Date:   Fri, 21 May 2021 13:39:18 +0200
Message-Id: <20210521113922.20798-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Enable dump of the registered netfilter hooks to userspace.
This allows userspace to peek at the active hooks for each family/hook
point.

Example:
    $ nft list hook ip type input
    family ip hook input {
            +0000000000 nft_do_chain_inet [nf_tables]       # nft table ip filter chain input
            +0000000010 nft_do_chain_inet [nf_tables]       # nft table ip firewalld chain filter_INPUT
            +0000000100 nf_nat_ipv4_local_in [nf_nat]
            +2147483647 ipv4_confirm [nf_conntrack]
    }

Implementation is done in nf_tables.
Alternative would be to add this as a separate/new nfnetlink family.

Let me know if thats the preferred route and I will respin.
I did this in nf_tables because it allows re-use of the existing
nft_hook_attributes and it seemed strange to add a new kernel module
for this.

Florian Westphal (4):
  netfilter: nf_tables: allow to dump all registered base hooks
  netfilter: nf_tables: include function and module name in hook dumps
  netfilter: annotate nf_tables base hook ops
  netfilter: nf_tables: include table and chain name when dumping hooks

 include/linux/netfilter.h                |  12 +-
 include/uapi/linux/netfilter/nf_tables.h |   7 +
 net/netfilter/core.c                     |   6 +
 net/netfilter/nf_queue.c                 |   4 +-
 net/netfilter/nf_tables_api.c            | 275 ++++++++++++++++++++++-
 5 files changed, 300 insertions(+), 4 deletions(-)

-- 
2.26.3

