Return-Path: <SRS0=4pKc=6U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2BB4C28CBC
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 17:33:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2C55206B8
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 17:33:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbgEFRdm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 May 2020 13:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgEFRdm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 May 2020 13:33:42 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E022C061A0F
        for <netfilter-devel@vger.kernel.org>; Wed,  6 May 2020 10:33:42 -0700 (PDT)
Received: from localhost ([::1]:58690 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jWNvQ-0002il-Ey; Wed, 06 May 2020 19:33:40 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 00/15] cache evaluation phase bonus material
Date:   Wed,  6 May 2020 19:33:16 +0200
Message-Id: <20200506173331.9347-1-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Play a bit with valgrind I thought. This will be easy, I thought. So
here's what this turned into:

Patches 1-4 fix bugs in the previous series "iptables: introduce cache
evaluation phase" and hence will get folded into respective commits
before pushing upstream. I left those separate to ease reviews and
provide some explanation in commit messages.

Patch 5 reveals what happens if I'm too lazy to create test cases for
use with valgrind but am not too lazy for shell scripting: In a "big
hammer turns everything into a nail" style, I hacked tests/shell for
memleak analysis.

The remaining patches fix old code, mostly to get rid of reachable
memory at zero-status program exit. This is not just cosmetics: Reducing
noise in valgrind output does a great deal to emphasize real issues.

Phil Sutter (15):
  nft: Free rule pointer in nft_cmd_free()
  nft: Add missing clear_cs() calls
  nft: Avoid use-after-free when rebuilding cache
  nft: Call nft_release_cache() in nft_fini()
  tests: shell: Implement --valgrind mode
  nft: cache: Re-establish cache consistency check
  nft: Clear all lists in nft_fini()
  nft: Fix leaks in ebt_add_policy_rule()
  nft: Fix leak when deleting rules
  ebtables: Free statically loaded extensions again
  libxtables: Introduce xtables_fini()
  nft: Use clear_cs() instead of open coding
  arptables: Fix leak in nft_arp_print_rule()
  nft: Fix leak when replacing a rule
  nft: Don't exit early after printing help texts

 configure.ac                      |  4 +--
 include/xtables.h                 |  1 +
 iptables/ip6tables-standalone.c   |  2 ++
 iptables/iptables-restore.c       | 14 ++++++---
 iptables/iptables-save.c          | 14 +++++++--
 iptables/iptables-standalone.c    |  2 ++
 iptables/nft-arp.c                |  3 ++
 iptables/nft-bridge.c             |  1 +
 iptables/nft-cache.c              | 25 +++++++++++++---
 iptables/nft-cmd.c                |  9 +++++-
 iptables/nft-ipv4.c               |  2 +-
 iptables/nft-ipv6.c               |  2 +-
 iptables/nft-shared.c             |  1 +
 iptables/nft.c                    | 37 ++++++++++++++++--------
 iptables/nft.h                    |  5 ++--
 iptables/tests/shell/run-tests.sh | 47 +++++++++++++++++++++++++++++++
 iptables/xtables-arp-standalone.c |  1 +
 iptables/xtables-arp.c            | 14 ++++-----
 iptables/xtables-eb-standalone.c  |  2 +-
 iptables/xtables-eb.c             | 20 ++++++++++++-
 iptables/xtables-monitor.c        |  2 ++
 iptables/xtables-restore.c        |  4 ++-
 iptables/xtables-save.c           |  1 +
 iptables/xtables-standalone.c     |  1 +
 iptables/xtables-translate.c      |  2 ++
 iptables/xtables.c                | 13 ++++-----
 libxtables/xtables.c              | 44 ++++++++++++++++++++++++++++-
 27 files changed, 224 insertions(+), 49 deletions(-)

-- 
2.25.1

