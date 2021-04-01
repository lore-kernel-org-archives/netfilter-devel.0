Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C087C43616
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 17:41:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CB3261005
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 17:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234243AbhDARlr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Apr 2021 13:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234680AbhDARjI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Apr 2021 13:39:08 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F83C0A88A8
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Apr 2021 07:11:23 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lRy2c-0001bX-9d; Thu, 01 Apr 2021 16:11:22 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 00/11] netfilter: reduce struct net size
Date:   Thu,  1 Apr 2021 16:11:03 +0200
Message-Id: <20210401141114.24712-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This series moves part of netfilter related pernet data from
struct net to net_generic() infrastructure.

All of these users can be modules, so if they are not loaded there
is no need to waste space.

Also, none of the struct members that are (re)moved are used in packet
path.

A followup patch series will also remove ebt/arp/ip/ip6tables xt_table
anchors from struct net.

Size reduction is 7 cachelines on x86_64.

Only change since v1 is in patch 7, it removes a 'unused variable'
warning.

Florian Westphal (11):
  netfilter: nfnetlink: add and use nfnetlink_broadcast
  netfilter: nfnetlink: use net_generic infra
  netfilter: cttimeout: use net_generic infra
  netfilter: nf_defrag_ipv6: use net_generic infra
  netfilter: nf_defrag_ipv4: use net_generic infra
  netfilter: ebtables: use net_generic infra
  netfilter: nf_tables: use net_generic infra for transaction data
  netfilter: x_tables: move known table lists to net_generic infra
  netfilter: conntrack: move sysctl pointer to net_generic infra
  netfilter: conntrack: move ecache dwork to net_generic infra
  net: remove obsolete members from struct net

 include/linux/netfilter/nfnetlink.h         |   2 +
 include/net/net_namespace.h                 |   9 -
 include/net/netfilter/ipv6/nf_defrag_ipv6.h |   6 +
 include/net/netfilter/nf_conntrack.h        |   7 +
 include/net/netfilter/nf_conntrack_ecache.h |  33 +--
 include/net/netfilter/nf_tables.h           |  11 +
 include/net/netns/conntrack.h               |   4 -
 include/net/netns/netfilter.h               |   6 -
 include/net/netns/nftables.h                |   7 -
 include/net/netns/x_tables.h                |   1 -
 net/bridge/netfilter/ebtables.c             |  39 ++-
 net/ipv4/netfilter/nf_defrag_ipv4.c         |  20 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c     |  68 +++--
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c   |  15 +-
 net/netfilter/nf_conntrack_core.c           |   7 +-
 net/netfilter/nf_conntrack_ecache.c         |  31 +-
 net/netfilter/nf_conntrack_standalone.c     |  10 +-
 net/netfilter/nf_tables_api.c               | 313 +++++++++++++-------
 net/netfilter/nf_tables_offload.c           |  30 +-
 net/netfilter/nfnetlink.c                   |  67 +++--
 net/netfilter/nfnetlink_acct.c              |   3 +-
 net/netfilter/nfnetlink_cttimeout.c         |  41 ++-
 net/netfilter/nft_chain_filter.c            |  11 +-
 net/netfilter/nft_dynset.c                  |   6 +-
 net/netfilter/x_tables.c                    |  46 ++-
 25 files changed, 518 insertions(+), 275 deletions(-)

-- 
2.26.3

