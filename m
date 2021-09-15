Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EEC3C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Sep 2021 14:46:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0616D60E90
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Sep 2021 14:46:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237970AbhIOOsE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Sep 2021 10:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232242AbhIOOsE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Sep 2021 10:48:04 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A42BC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Sep 2021 07:46:45 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mQWBQ-0005k7-3k; Wed, 15 Sep 2021 16:46:44 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 0/2] netfilter: nf_nat_masquerade: don't block rtnl lock
Date:   Wed, 15 Sep 2021 16:46:37 +0200
Message-Id: <20210915144639.25024-1-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nf_nat_masquerade registers conntrack notifiers to early-expire
conntracks that have been using the downed device/removed address.

With large number of disappearing devices (ppp), iterating the table
for every notification blocks the rtnl lock for multiple seconds.

This change unconditionally defers the walk to the system work queue
so that rtnl lock is not blocked longer than needed.

This is not a regression, the notifier and cleanup walk have existed
since the functionality was added more than 20 years ago.

Florian Westphal (2):
  netfilter: nf_nat_masquerade: make async masq_inet6_event handling
    generic
  netfilter: nf_nat_masquerade: defer conntrack walk to work queue

 net/netfilter/nf_nat_masquerade.c | 168 +++++++++++++++++-------------
 1 file changed, 97 insertions(+), 71 deletions(-)

-- 
2.32.0

