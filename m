Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5806C433B4
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Apr 2021 19:55:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB315610FC
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Apr 2021 19:55:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239268AbhDLT4N (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Apr 2021 15:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238889AbhDLT4M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Apr 2021 15:56:12 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E58C061574
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Apr 2021 12:55:53 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lW2f1-0000rq-F6; Mon, 12 Apr 2021 21:55:51 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 0/5] netfilter: conntrack: shrink size of netns_ct
Date:   Mon, 12 Apr 2021 21:55:39 +0200
Message-Id: <20210412195544.417-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

v2: fix linker error when PROCFS=n. This only affects patch 4/5, no
other changes.

This reduces size of the netns_ct structure, which itself is embedded
in struct net.

First two patches move two helper related settings to net_generic,
these are only accessed when a new connection is added.

Patches 3 and 4 move the ct and expect counter to net_generic too.
While these are used from packet path, they are not accessed when
conntack finds an existing entry.

This also makes netns_ct a read-mostly structure, at this time each
newly accepted conntrack dirties the first netns_ct cacheline for other
cpus.

Last patch converts a few sysctls to u8.  Most conntrack sysctls are
timeouts, so these need to be kept as ints.

Florian Westphal (5):
  netfilter: conntrack: move autoassign warning member to net_generic
    data
  netfilter: conntrack: move autoassign_helper sysctl to net_generic
    data
  netfilter: conntrack: move expect counter to net_generic data
  netfilter: conntrack: move ct counter to net_generic data
  netfilter: conntrack: convert sysctls to u8

 include/net/netfilter/nf_conntrack.h    |  8 +++
 include/net/netns/conntrack.h           | 23 ++++-----
 net/netfilter/nf_conntrack_core.c       | 46 ++++++++++++-----
 net/netfilter/nf_conntrack_expect.c     | 22 ++++++---
 net/netfilter/nf_conntrack_helper.c     | 15 ++++--
 net/netfilter/nf_conntrack_netlink.c    |  5 +-
 net/netfilter/nf_conntrack_proto_tcp.c  | 34 ++++++-------
 net/netfilter/nf_conntrack_standalone.c | 66 +++++++++++++------------
 8 files changed, 132 insertions(+), 87 deletions(-)

-- 
2.26.3

