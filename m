Return-Path: <SRS0=jECH=SL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C8DAC10F0E
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 08:45:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39138206C0
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 08:45:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfDIIp6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 04:45:58 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:51560 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726431AbfDIIp6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 04:45:58 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hDmOC-0008R7-O1; Tue, 09 Apr 2019 10:45:56 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 0/3] netfilter: masquerade: unify ip/ip6 notifier registration
Date:   Tue,  9 Apr 2019 10:44:05 +0200
Message-Id: <20190409084408.23730-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This series merges the ip/ip6 masquerade helpers.
The xtables masquerade modules are merged into a single module.

Florian Westphal (3):
      netfilter: nf_nat: merge ip/ip6 masquerade headers
      netfilter: x_tables: merge ip and ipv6 masquerade modules
      netfilter: nf_nat_masquerade: unify ipv4/6 notifier registration

 include/net/netfilter/nf_nat_masquerade.h    |   19 ++++
 net/ipv4/netfilter/Kconfig                   |   12 --
 net/ipv4/netfilter/Makefile                  |    1 
 net/ipv6/netfilter/Kconfig                   |   11 --
 net/ipv6/netfilter/Makefile                  |    1 
 net/netfilter/Kconfig                        |   14 +++
 net/netfilter/Makefile                       |    1 
 net/netfilter/nf_nat_masquerade.c            |  104 +++++++++----------------
 net/netfilter/nft_masq.c                     |   19 ----
 net/netfilter/xt_MASQUERADE.c                |   84 +++++++++++++-------
 include/net/netfilter/ipv4/nf_nat_masquerade.h |   15 ---
 include/net/netfilter/ipv6/nf_nat_masquerade.h |   11 --
 net/ipv6/netfilter/ip6t_MASQUERADE.c           |   81 -------------------
 13 files changed, 139 insertions(+), 234 deletions(-)

