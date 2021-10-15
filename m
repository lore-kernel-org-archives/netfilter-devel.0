Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2D6FC433FE
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Oct 2021 12:28:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEB0B6108E
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Oct 2021 12:28:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238914AbhJOMaI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Oct 2021 08:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238917AbhJOM3b (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Oct 2021 08:29:31 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8AEC061764
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Oct 2021 05:27:24 -0700 (PDT)
Received: from localhost ([::1]:33896 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mbMJ1-0002W3-9A; Fri, 15 Oct 2021 14:27:23 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v3 00/13] Eliminate dedicated arptables-nft parser
Date:   Fri, 15 Oct 2021 14:25:55 +0200
Message-Id: <20211015122608.12474-1-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Commandline parsing was widely identical with iptables and ip6tables.
This series adds the necessary code-changes to unify the parsers into a
common one.

Changes since v2:
- Drop quirks for ignoring bogus table names and '-m' options, they
  likely just hide bugs.
- Rewrite empty interface name quirk patch, make arptables-nft print
  iptables' error message as warning to notify users.
- Integrate intrapositioned negation support into the final merge patch
  and revive iptables' old warning to notify users.

Changes since v1:
- Fix patch 12, the parser has to check existence of proto_parse
  callback before dereferencing it. Otherwise arptables-nft segfaults if
  '-p' option is given.
- Patches 13-17 add all the arptables quirks to restore compatibility
  with arptables-legacy. I didn't consider them important enough to push
  them unless someone complains. Yet breaking existing scripts is bad
  indeed. Please consider them RFC: If you consider (one of) them not
  important, please NACk and I will drop them before pushing.

Phil Sutter (13):
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
  xtables: arptables accepts empty interface names
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
 iptables/xtables.c                | 348 ++++++--------
 21 files changed, 706 insertions(+), 1050 deletions(-)
 delete mode 100644 iptables/xtables-arp-standalone.c

-- 
2.33.0

