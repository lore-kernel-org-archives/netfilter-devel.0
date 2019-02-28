Return-Path: <SRS0=zt5D=RD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AF41C43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Feb 2019 11:02:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 511D521850
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Feb 2019 11:02:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731745AbfB1LCY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Feb 2019 06:02:24 -0500
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:53998 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727086AbfB1LCX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Feb 2019 06:02:23 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1gzJSH-0003gR-Rw; Thu, 28 Feb 2019 12:02:22 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 0/3] netfilter: nf_tables: merge remaining nat related modules
Date:   Thu, 28 Feb 2019 12:02:49 +0100
Message-Id: <20190228110252.4423-1-fw@strlen.de>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This series merges the remaining nat related modules: redir, masq,
and the nat chain type.

This is the last missing piece to add inet family nat support to nftables.

Florian Westphal (3):
      netfilter: nf_tables: nat: merge nft_redir protocol specific modules
      netfilter: nf_tables: nat: merge nft_masq protocol specific modules
      netfilter: nf_tables: merge ipv4 and ipv6 nat chain types

 net/ipv4/netfilter/Kconfig             | 30 -----
 net/ipv4/netfilter/Makefile            |  3
 net/ipv6/netfilter/Kconfig             | 28 ----
 net/ipv6/netfilter/Makefile            |  3
 net/netfilter/Kconfig                  |  4
 net/netfilter/Makefile                 |  2
 net/netfilter/nft_chain_nat.c          |108 +++++++++++++++++++
 net/netfilter/nft_masq.c               |180 ++++++++++++++++++++++++++++--
 net/netfilter/nft_redir.c              |154 +++++++++++++++++++++++++--
 include/net/netfilter/nft_masq.h       | 22 ---
 include/net/netfilter/nft_redir.h      | 22 ---
 net/ipv4/netfilter/nft_chain_nat_ipv4.c| 85 ---------------
 net/ipv4/netfilter/nft_masq_ipv4.c     | 90 ----------------
 net/ipv4/netfilter/nft_redir_ipv4.c    | 82 --------------
 net/ipv6/netfilter/nft_chain_nat_ipv6.c| 83 --------------
 net/ipv6/netfilter/nft_masq_ipv6.c     | 91 ----------------
 net/ipv6/netfilter/nft_redir_ipv6.c    | 83 --------------
 17 files changed, 422 insertions(+), 648 deletions(-)


