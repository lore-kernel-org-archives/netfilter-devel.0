Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A56C6C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Sep 2021 15:04:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 877806101A
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Sep 2021 15:04:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234955AbhI0PFi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Sep 2021 11:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234939AbhI0PFh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Sep 2021 11:05:37 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23B8C061575
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Sep 2021 08:03:59 -0700 (PDT)
Received: from localhost ([::1]:43526 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mUsAg-0005hL-Bc; Mon, 27 Sep 2021 17:03:58 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 00/12] Eliminate dedicated arptables-nft parser
Date:   Mon, 27 Sep 2021 17:03:04 +0200
Message-Id: <20210927150316.11516-1-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Commandline parsing was widely identical with iptables and ip6tables.
This series adds the necessary code-changes to unify the parsers into a
common one.

Phil Sutter (12):
  nft: Introduce builtin_tables_lookup()
  xshared: Store optstring in xtables_globals
  nft-shared: Introduce init_cs family ops callback
  xtables: Simplify addr_mask freeing
  nft: Add family ops callbacks wrapping different nft_cmd_* functions
  xtables-standalone: Drop version number from init errors
  libxtables: Introduce xtables_globals print_help callback
  arptables: Use standard data structures when parsing
  nft-arp: Introduce post_parse callback
  nft-shared: Make nft_check_xt_legacy() family agnostic
  xtables: Derive xtables_globals from family
  nft: Merge xtables-arp-standalone.c into xtables-standalone.c

 include/xtables.h                 |   2 +
 iptables/Makefile.am              |   2 +-
 iptables/nft-arp.c                | 252 +++++++++-
 iptables/nft-ipv4.c               |  93 ++++
 iptables/nft-ipv6.c               | 104 +++++
 iptables/nft-shared.c             |   5 +
 iptables/nft-shared.h             |  24 +
 iptables/nft.c                    |  19 +-
 iptables/nft.h                    |   2 +-
 iptables/xshared.h                |   2 +
 iptables/xtables-arp-standalone.c |  65 ---
 iptables/xtables-arp.c            | 749 +-----------------------------
 iptables/xtables-eb-translate.c   |   1 -
 iptables/xtables-eb.c             |   7 +-
 iptables/xtables-monitor.c        |   2 +-
 iptables/xtables-multi.h          |   3 +
 iptables/xtables-restore.c        |   9 +-
 iptables/xtables-save.c           |   6 +-
 iptables/xtables-standalone.c     |  54 ++-
 iptables/xtables-translate.c      |   7 +-
 iptables/xtables.c                | 268 +++--------
 21 files changed, 642 insertions(+), 1034 deletions(-)
 delete mode 100644 iptables/xtables-arp-standalone.c

-- 
2.33.0

