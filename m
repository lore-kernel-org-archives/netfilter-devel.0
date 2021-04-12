Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A7AEC433B4
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Apr 2021 22:31:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1533561370
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Apr 2021 22:31:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239972AbhDLWbZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Apr 2021 18:31:25 -0400
Received: from mail.netfilter.org ([217.70.188.207]:50452 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239551AbhDLWbZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Apr 2021 18:31:25 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id C7E2663E3D;
        Tue, 13 Apr 2021 00:30:40 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/7] Netfilter fixes for net
Date:   Tue, 13 Apr 2021 00:30:52 +0200
Message-Id: <20210412223059.20841-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Fix NAT IPv6 offload in the flowtable.

2) icmpv6 is printed as unknown in /proc/net/nf_conntrack.

3) Use div64_u64() in nft_limit, from Eric Dumazet.

4) Use pre_exit to unregister ebtables and arptables hooks,
   from Florian Westphal.

5) Fix out-of-bound memset in x_tables compat match/target,
   also from Florian.

6) Clone set elements expression to ensure proper initialization.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks!

----------------------------------------------------------------

The following changes since commit 9adc89af724f12a03b47099cd943ed54e877cd59:

  net: let skb_orphan_partial wake-up waiters. (2021-03-30 13:57:28 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 4d8f9065830e526c83199186c5f56a6514f457d2:

  netfilter: nftables: clone set element expression template (2021-04-13 00:19:05 +0200)

----------------------------------------------------------------
Eric Dumazet (1):
      netfilter: nft_limit: avoid possible divide error in nft_limit_init

Florian Westphal (3):
      netfilter: bridge: add pre_exit hooks for ebtable unregistration
      netfilter: arp_tables: add pre_exit hook for table unregister
      netfilter: x_tables: fix compat match/target pad out-of-bound write

Pablo Neira Ayuso (3):
      netfilter: flowtable: fix NAT IPv6 offload mangling
      netfilter: conntrack: do not print icmpv6 as unknown via /proc
      netfilter: nftables: clone set element expression template

 include/linux/netfilter_arp/arp_tables.h  |  5 ++--
 include/linux/netfilter_bridge/ebtables.h |  5 ++--
 net/bridge/netfilter/ebtable_broute.c     |  8 +++++-
 net/bridge/netfilter/ebtable_filter.c     |  8 +++++-
 net/bridge/netfilter/ebtable_nat.c        |  8 +++++-
 net/bridge/netfilter/ebtables.c           | 30 ++++++++++++++++++--
 net/ipv4/netfilter/arp_tables.c           | 11 ++++++--
 net/ipv4/netfilter/arptable_filter.c      | 10 ++++++-
 net/ipv4/netfilter/ip_tables.c            |  2 ++
 net/ipv6/netfilter/ip6_tables.c           |  2 ++
 net/netfilter/nf_conntrack_standalone.c   |  1 +
 net/netfilter/nf_flow_table_offload.c     |  6 ++--
 net/netfilter/nf_tables_api.c             | 46 +++++++++++++++++++++++--------
 net/netfilter/nft_limit.c                 |  4 +--
 net/netfilter/x_tables.c                  | 10 ++-----
 15 files changed, 118 insertions(+), 38 deletions(-)
