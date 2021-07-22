Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E310DC6377D
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Jul 2021 08:48:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFBA461355
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Jul 2021 08:48:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbhGVIIO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Jul 2021 04:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbhGVIIO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Jul 2021 04:08:14 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0768C061575
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Jul 2021 01:48:49 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1m6UNr-0000y6-Ps; Thu, 22 Jul 2021 10:48:47 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/3] netfilter: clusterip: don't register hook in all netns
Date:   Thu, 22 Jul 2021 10:48:31 +0200
Message-Id: <20210722084834.27027-1-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This series stops ipt_CLUSTERIP from registering arp mangling hook
unconditionally.

Hook gets installed/removed from checkentry/destroy callbacks.

Before this, modprobe ipt_CLUSTERIP would add a hook in each netns.
While at it, also get rid of x_tables.h/xt storage space in struct net,
there is no need for this.

Florian Westphal (3):
  netfilter: ipt_CLUSTERIP: only add arp mangle hook when required
  netfilter: ipt_CLUSTERIP: use clusterip_net to store pernet warning
  netfilter: remove xt pernet data

 include/net/net_namespace.h        |  2 --
 include/net/netns/x_tables.h       | 12 -------
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 56 ++++++++++++++++++++----------
 net/netfilter/xt_CT.c              | 11 ------
 4 files changed, 37 insertions(+), 44 deletions(-)
 delete mode 100644 include/net/netns/x_tables.h

-- 
2.31.1

