Return-Path: <SRS0=SfI0=TX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93C2CC282DD
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 May 2019 13:43:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F9D720881
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 May 2019 13:43:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730495AbfEWNnY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 May 2019 09:43:24 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:48814 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729698AbfEWNnX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 May 2019 09:43:23 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hTo09-0007ij-OL; Thu, 23 May 2019 15:43:21 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 0/8] netfilter: remove skb_make_writable helper
Date:   Thu, 23 May 2019 15:44:04 +0200
Message-Id: <20190523134412.3295-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This series removes skb_make_writable.  All users are converted
to skb_ensure_writable.

In Hindsight, skb_ensure_writable() should never have been added to
the tree, and instead we should have moved skb_make_writable to the core.

What happened instead that skb_ensure_writable was added to OVS, then
moved to core, then extended in functionality until the point it has the
same effect and same pre and post-conditions as skb_make_writable.

So, remove skb_make_writable and use the new function everywhere.
Patch 1 has a more detailed explanation/walkthrough of the two functions
and their pre and post-conditions.

Florian Westphal (8):
      netfilter: bridge: convert skb_make_writable to skb_ensure_writable
      netfilter: ipvs: prefer skb_ensure_writable
      netfilter: conntrack, nat: prefer skb_ensure_writable
      netfilter: ipv4: prefer skb_ensure_writable
      netfilter: nf_tables: prefer skb_ensure_writable
      netfilter: xt_HL: prefer skb_ensure_writable
      netfilter: tcpmss, optstrip: prefer skb_ensure_writable
      netfilter: replace skb_make_writable with skb_ensure_writable

 include/linux/netfilter.h                   |    5 -----
 net/bridge/netfilter/ebt_dnat.c             |    2 +-
 net/bridge/netfilter/ebt_redirect.c         |    2 +-
 net/bridge/netfilter/ebt_snat.c             |    2 +-
 net/ipv4/netfilter/arpt_mangle.c            |    2 +-
 net/ipv4/netfilter/ipt_ECN.c                |    4 ++--
 net/ipv4/netfilter/nf_nat_h323.c            |    2 +-
 net/ipv4/netfilter/nf_nat_snmp_basic_main.c |    2 +-
 net/netfilter/core.c                        |   22 ----------------------
 net/netfilter/ipvs/ip_vs_app.c              |    4 ++--
 net/netfilter/ipvs/ip_vs_core.c             |    4 ++--
 net/netfilter/ipvs/ip_vs_ftp.c              |    4 ++--
 net/netfilter/ipvs/ip_vs_proto_sctp.c       |    4 ++--
 net/netfilter/ipvs/ip_vs_proto_tcp.c        |    4 ++--
 net/netfilter/ipvs/ip_vs_proto_udp.c        |    4 ++--
 net/netfilter/ipvs/ip_vs_xmit.c             |   12 ++++++------
 net/netfilter/nf_conntrack_proto_sctp.c     |    2 +-
 net/netfilter/nf_conntrack_seqadj.c         |    4 ++--
 net/netfilter/nf_nat_helper.c               |    4 ++--
 net/netfilter/nf_nat_proto.c                |   24 ++++++++++++------------
 net/netfilter/nf_nat_sip.c                  |    2 +-
 net/netfilter/nf_synproxy_core.c            |    2 +-
 net/netfilter/nfnetlink_queue.c             |    2 +-
 net/netfilter/nft_exthdr.c                  |    3 ++-
 net/netfilter/nft_payload.c                 |    6 +++---
 net/netfilter/xt_DSCP.c                     |    8 ++++----
 net/netfilter/xt_HL.c                       |    4 ++--
 net/netfilter/xt_TCPMSS.c                   |    2 +-
 net/netfilter/xt_TCPOPTSTRIP.c              |   28 +++++++++++++---------------
 29 files changed, 71 insertions(+), 99 deletions(-)

