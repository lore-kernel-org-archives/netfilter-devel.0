Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AED7C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Sep 2021 14:04:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D347619E7
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Sep 2021 14:04:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236263AbhI3OGS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Sep 2021 10:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351739AbhI3OGR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Sep 2021 10:06:17 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB38C06176A
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Sep 2021 07:04:35 -0700 (PDT)
Received: from localhost ([::1]:51658 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mVwfp-0007OD-O7; Thu, 30 Sep 2021 16:04:33 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 00/17] Eliminate dedicated arptables-nft parser
Date:   Thu, 30 Sep 2021 16:04:02 +0200
Message-Id: <20210930140419.6170-1-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Commandline parsing was widely identical with iptables and ip6tables.
This series adds the necessary code-changes to unify the parsers into a
common one.

Changes since v1:
- Fix patch 12, the parser has to check existence of proto_parse
  callback before dereferencing it. Otherwise arptables-nft segfaults if
  '-p' option is given.
- Patches 13-17 add all the arptables quirks to restore compatibility
  with arptables-legacy. I didn't consider them important enough to push
  them unless someone complains. Yet breaking existing scripts is bad
  indeed. Please consider them RFC: If you consider (one of) them not
  important, please NACk and I will drop them before pushing.

Phil Sutter (17):
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
  xtables: arptables doesn't warn about empty interface
  xtables: arptables accepts but ignores '-m'
  xtables: arptables ignores wrong -t values
  xtables: Support '!' betwen option and argument
  nft: Store maximum allowed chain name length in family ops

 include/xtables.h                 |   2 +
 iptables/Makefile.am              |   2 +-
 iptables/nft-arp.c                | 253 +++++++++-
 iptables/nft-ipv4.c               |  94 ++++
 iptables/nft-ipv6.c               | 105 +++++
 iptables/nft-shared.c             |   5 +
 iptables/nft-shared.h             |  25 +
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
 iptables/xtables.c                | 336 +++++---------
 21 files changed, 701 insertions(+), 1047 deletions(-)
 delete mode 100644 iptables/xtables-arp-standalone.c

-- 
2.33.0

