Return-Path: <SRS0=A2+c=CD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67194C433E1
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Aug 2020 22:52:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B62D2075F
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Aug 2020 22:52:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgHYWw7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Aug 2020 18:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgHYWw6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Aug 2020 18:52:58 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2494C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Aug 2020 15:52:58 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kAhoE-00065H-EV; Wed, 26 Aug 2020 00:52:55 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 0/4] netfilter: revisit conntrack statistics
Date:   Wed, 26 Aug 2020 00:52:41 +0200
Message-Id: <20200825225245.8072-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With recent addition of clash resolution the 'insert_failed' counter has
become confusing.  Depending on wheter clash resolution is successful,
insert_failed increments or both insert_failed and drop increment.

Example (conntrack -S):
[..] insert_failed=15 drop=0 [..] search_restart=268

This means clash resolution worked and the insert_failed increase is harmeless.
In case drop is non-zero, things become murky.

It would be better to have a dedicated counter that only increments when
clash resolution is successful.

This series revisits conntrack statistics.  Counters that do not
indicate an error or reside in fast-paths are removed.

With patched kernel and conntrack tool, output looks similar to this
during a 'clash resolve' stress test:

[..] insert_failed=9 drop=9 [..] search_restart=123 clash_resolve=3675

Florian Westphal (4):
      netfilter: conntrack: do not increment two error counters at same time
      netfilter: conntrack: remove ignore stats
      netfilter: conntrack: add clash resolution stat counter
      netfilter: conntrack: remove unneeded nf_ct_put

 include/linux/netfilter/nf_conntrack_common.h      |    2 -
 include/uapi/linux/netfilter/nfnetlink_conntrack.h |    3 +-
 net/netfilter/nf_conntrack_core.c                  |   25 ++++++++-------------
 net/netfilter/nf_conntrack_netlink.c               |    5 ++--
 net/netfilter/nf_conntrack_standalone.c            |    4 +--
 5 files changed, 18 insertions(+), 21 deletions(-)

