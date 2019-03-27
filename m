Return-Path: <SRS0=34lc=R6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 550C4C43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 08:20:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BAC52082F
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 08:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732468AbfC0IUZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 04:20:25 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:38820 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732456AbfC0IUY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 04:20:24 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1h93nK-0002ab-80; Wed, 27 Mar 2019 09:20:22 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 0/6] netfilter: nat: add inet family nat support
Date:   Wed, 27 Mar 2019 09:22:23 +0100
Message-Id: <20190327082229.29399-1-fw@strlen.de>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This series adds support for the nat chain type in the inet family.

Example:

table inet nat {
	chain postrouting {
		type nat hook output priority 0; policy accept;
		ip6 daddr dead:1::99 snat ip6 to dead:2::99
		meta oifname "ppp+" masquerade
	}
}

This avoids the need to create both ip and ip6 nat tables for
the masquerade rule.

Florian Westphal (6):
      netfilter: nat: add inet family nat support
      netfilter: nf_tables: merge route type into core
      netfilter: replace NF_NAT_NEEDED with IS_ENABLED(CONFIG_NF_NAT)
      netfilter: nft_masq: add inet support
      netfilter: nft_redir: add inet support
      kselftests: extend nft_nat with inet family based nat hooks

 include/linux/netfilter.h                    |    2 
 include/linux/netfilter_ipv6.h               |   15 ++
 include/net/netfilter/nf_conntrack_expect.h  |    2 
 include/net/netfilter/nf_nat.h               |    7 -
 include/net/netfilter/nf_tables.h            |    2 
 net/ipv4/netfilter/Kconfig                   |    8 -
 net/ipv4/netfilter/Makefile                  |    1 
 net/ipv6/netfilter/Kconfig                   |    8 -
 net/ipv6/netfilter/Makefile                  |    1 
 net/netfilter/Kconfig                        |    5 
 net/netfilter/Makefile                       |    3 
 net/netfilter/nf_conntrack_expect.c          |    2 
 net/netfilter/nf_conntrack_netlink.c         |   16 +-
 net/netfilter/nf_conntrack_sip.c             |    2 
 net/netfilter/nf_nat_core.c                  |   16 +-
 net/netfilter/nf_nat_proto.c                 |   59 +++++---
 net/netfilter/nf_tables_api.c                |    2 
 net/netfilter/nft_chain_nat.c                |   36 +++++
 net/netfilter/nft_chain_route.c              |  169 +++++++++++++++++++++++++
 net/netfilter/nft_masq.c                     |   64 +++++++++
 net/netfilter/nft_nat.c                      |   58 ++++++++
 net/netfilter/nft_redir.c                    |   61 +++++++++
 net/openvswitch/conntrack.c                  |   18 +-
 tools/testing/selftests/netfilter/nft_nat.sh |  130 +++++++++++++------
 net/ipv4/netfilter/nft_chain_route_ipv4.c    |   89 -------------
 net/ipv6/netfilter/nft_chain_route_ipv6.c    |   91 -------------
 26 files changed, 572 insertions(+), 295 deletions(-)

