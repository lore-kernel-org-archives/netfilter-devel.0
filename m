Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 057EFC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Dec 2021 17:19:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbhLXRTM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Dec 2021 12:19:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhLXRTM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Dec 2021 12:19:12 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51F9C061401
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Dec 2021 09:19:11 -0800 (PST)
Received: from localhost ([::1]:59106 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1n0oDm-0004yQ-6C; Fri, 24 Dec 2021 18:19:10 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 00/11] Share do_parse() between nft and legacy
Date:   Fri, 24 Dec 2021 18:17:43 +0100
Message-Id: <20211224171754.14210-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Patch 1 removes remains of an unused (and otherwise dropped) feature,
yet the change is necessary for the following ones. Patches 2-6 prepare
for patch 7 which moves do_parse() to xshared.c. Patches 8 and 9 prepare
for use of do_parse() from legacy code, Patches 10 and 11 finally drop
legacy ip(6)tables' rule parsing code.

Merry Xmas!

Phil Sutter (11):
  xtables: Drop xtables' family on demand feature
  xtables: Pull table validity check out of do_parse()
  xtables: Move struct nft_xt_cmd_parse to xshared.h
  xtables: Pass xtables_args to check_empty_interface()
  xtables: Pass xtables_args to check_inverse()
  xtables: Do not pass nft_handle to do_parse()
  xshared: Move do_parse to shared space
  xshared: Store parsed wait and wait_interval in xtables_args
  nft: Move proto_parse and post_parse callbacks to xshared
  iptables: Use xtables' do_parse() function
  ip6tables: Use the shared do_parse, too

 iptables/ip6tables.c            | 499 ++---------------------
 iptables/iptables.c             | 484 ++--------------------
 iptables/nft-ipv4.c             |  59 +--
 iptables/nft-ipv6.c             |  76 +---
 iptables/nft-shared.h           |  49 ---
 iptables/xshared.c              | 684 ++++++++++++++++++++++++++++++++
 iptables/xshared.h              |  66 +++
 iptables/xtables-eb-translate.c |   4 +-
 iptables/xtables-translate.c    |  13 +-
 iptables/xtables.c              | 573 +-------------------------
 10 files changed, 839 insertions(+), 1668 deletions(-)

-- 
2.34.1

