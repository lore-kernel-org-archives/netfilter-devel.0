Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73A57C4338F
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Jul 2021 13:14:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4154B60F5C
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Jul 2021 13:14:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238873AbhG3NOi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 30 Jul 2021 09:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238893AbhG3NOi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Jul 2021 09:14:38 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9027C061765
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Jul 2021 06:14:33 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1m9SLN-0004N2-Uu; Fri, 30 Jul 2021 15:14:30 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/2] netfilter: ctnetlink: allow to filter dumps via ct->status
Date:   Fri, 30 Jul 2021 15:14:20 +0200
Message-Id: <20210730131422.16958-1-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently its not possibe to only dump entries that are e.g. in
UNREPLIED state.

Patches to extend libnetfilter_conntrack and conntrack-tools will be
sent separately.

Florian Westphal (2):
  netfilter: ctnetlink: add and use a helper for mark parsing
  netfilter: ctnetlink: allow to filter dump by status bits

 .../linux/netfilter/nfnetlink_conntrack.h     |  1 +
 net/netfilter/nf_conntrack_netlink.c          | 76 +++++++++++++++----
 2 files changed, 61 insertions(+), 16 deletions(-)

-- 
2.31.1

