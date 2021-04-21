Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 873B8C433ED
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Apr 2021 07:51:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46D816113C
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Apr 2021 07:51:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236479AbhDUHvu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Apr 2021 03:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhDUHvu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Apr 2021 03:51:50 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7E1C06174A
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Apr 2021 00:51:16 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lZ7dj-0004ra-Ky; Wed, 21 Apr 2021 09:51:15 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 00/12] netfilter: x_tables: remove ipt_unregister_table
Date:   Wed, 21 Apr 2021 09:50:58 +0200
Message-Id: <20210421075110.19334-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This change removes all xt_table pointers from struct net.

v2: fix "no previous prototype for 'ipt_unregister_table'" warning
in patch 2.

The various ip(6)table_foo incarnations are updated to expect
that the table is passed as 'void *priv' argument that netfilter core
passes to the hook functions.

This reduces the struct net size by 2 cachelines on x86_64.

Florian Westphal (12):
  netfilter: ebtables: remove the 3 ebtables pointers from struct net
  netfilter: x_tables: remove ipt_unregister_table
  netfilter: add xt_find_table
  netfilter: iptables: unregister the tables by name
  netfilter: ip6tables: unregister the tables by name
  netfilter: arptables: unregister the tables by name
  netfilter: x_tables: remove paranoia tests
  netfilter: xt_nat: pass table to hookfn
  netfilter: ip_tables: pass table pointer via nf_hook_ops
  netfilter: arp_tables: pass table pointer via nf_hook_ops
  netfilter: ip6_tables: pass table pointer via nf_hook_ops
  netfilter: remove all xt_table anchors from struct net

 include/linux/netfilter/x_tables.h        |  4 ++
 include/linux/netfilter_arp/arp_tables.h  |  6 +-
 include/linux/netfilter_bridge/ebtables.h |  9 ++-
 include/linux/netfilter_ipv4/ip_tables.h  |  9 +--
 include/linux/netfilter_ipv6/ip6_tables.h |  9 +--
 include/net/netns/ipv4.h                  | 10 ----
 include/net/netns/ipv6.h                  |  9 ---
 include/net/netns/x_tables.h              |  8 ---
 net/bridge/netfilter/ebtable_broute.c     | 10 ++--
 net/bridge/netfilter/ebtable_filter.c     | 26 +++------
 net/bridge/netfilter/ebtable_nat.c        | 27 +++------
 net/bridge/netfilter/ebtables.c           | 42 ++++++++++----
 net/ipv4/netfilter/arp_tables.c           | 57 ++++++++++++------
 net/ipv4/netfilter/arptable_filter.c      | 17 ++----
 net/ipv4/netfilter/ip_tables.c            | 70 ++++++++++++++---------
 net/ipv4/netfilter/iptable_filter.c       | 17 ++----
 net/ipv4/netfilter/iptable_mangle.c       | 23 +++-----
 net/ipv4/netfilter/iptable_nat.c          | 59 +++++++++++++------
 net/ipv4/netfilter/iptable_raw.c          | 17 ++----
 net/ipv4/netfilter/iptable_security.c     | 17 ++----
 net/ipv6/netfilter/ip6_tables.c           | 68 +++++++++++++---------
 net/ipv6/netfilter/ip6table_filter.c      | 17 ++----
 net/ipv6/netfilter/ip6table_mangle.c      | 24 +++-----
 net/ipv6/netfilter/ip6table_nat.c         | 58 +++++++++++++------
 net/ipv6/netfilter/ip6table_raw.c         | 17 ++----
 net/ipv6/netfilter/ip6table_security.c    | 17 ++----
 net/netfilter/x_tables.c                  | 18 ++++++
 27 files changed, 332 insertions(+), 333 deletions(-)

-- 
2.26.3

