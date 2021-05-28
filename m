Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ADCEC47087
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 May 2021 10:30:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 125B5613DA
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 May 2021 10:30:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236344AbhE1Kby (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 May 2021 06:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236200AbhE1Kbx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 May 2021 06:31:53 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40FCAC061574
        for <netfilter-devel@vger.kernel.org>; Fri, 28 May 2021 03:30:17 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lmZkt-000073-3W; Fri, 28 May 2021 12:30:15 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/6] netfilter: reduce size of core data structures
Date:   Fri, 28 May 2021 12:30:02 +0200
Message-Id: <20210528103008.17425-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This series reduces a few data structures by moving
members around or switching to a smaller type.

Also, this removes xt_action_param from nft_pktinfo,
the former can be inited on-stack when needed in the nft_compat
expression.

Florian Westphal (6):
  netfilter: x_tables: reduce xt_action_param by 8 byte
  netfilter: reduce size of nf_hook_state on 32bit platforms
  netfilter: nf_tables: add and use nft_sk helper
  netfilter: nf_tables: add and use nft_thoff helper
  netfilter: nft_set_pktinfo_unspec: remove unused arg
  netfilter: nf_tables: remove xt_action_param from nft_pktinfo

 include/linux/netfilter.h              |  4 +--
 include/linux/netfilter/x_tables.h     |  2 +-
 include/net/netfilter/nf_tables.h      | 34 +++++++++++++--------
 include/net/netfilter/nf_tables_ipv4.h | 40 +++++++++++-------------
 include/net/netfilter/nf_tables_ipv6.h | 42 ++++++++++++--------------
 net/ipv4/netfilter/nft_reject_ipv4.c   |  2 +-
 net/ipv6/netfilter/ip6_tables.c        |  2 +-
 net/ipv6/netfilter/nft_reject_ipv6.c   |  2 +-
 net/netfilter/nf_tables_core.c         |  2 +-
 net/netfilter/nf_tables_trace.c        |  6 ++--
 net/netfilter/nft_chain_filter.c       | 26 ++++++++--------
 net/netfilter/nft_chain_nat.c          |  4 +--
 net/netfilter/nft_chain_route.c        |  4 +--
 net/netfilter/nft_compat.c             | 28 +++++++++++------
 net/netfilter/nft_exthdr.c             |  8 ++---
 net/netfilter/nft_flow_offload.c       |  2 +-
 net/netfilter/nft_payload.c            | 10 +++---
 net/netfilter/nft_reject_inet.c        |  4 +--
 net/netfilter/nft_synproxy.c           |  4 +--
 net/netfilter/nft_tproxy.c             |  4 +--
 20 files changed, 120 insertions(+), 110 deletions(-)

-- 
2.26.3

