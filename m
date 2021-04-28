Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A2E6C433ED
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Apr 2021 17:37:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67BFE6143F
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Apr 2021 17:37:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242303AbhD1RiV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 13:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242284AbhD1RiQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 13:38:16 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2521AC061573
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Apr 2021 10:37:31 -0700 (PDT)
Received: from localhost ([::1]:34748 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1lbo7t-0007Ad-Mr; Wed, 28 Apr 2021 19:37:29 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 0/5] Merge some common code
Date:   Wed, 28 Apr 2021 19:36:51 +0200
Message-Id: <20210428173656.16851-1-phil@nwl.cc>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is more or less fallout from a local branch merging arptables code
into xtables:

Patches 1 and 2 are dependencies of patch 3 which combines invflags
handling everywhere else than in ebtables as that is always a bit more
"special" than the others.

Patch 4 fixes an actual bug as a side-effect of removing redundant code.

Patch 5 might change iptables-nft output slightly in corner-cases but
makes it consistent with legacy.

Phil Sutter (5):
  xtables: Make invflags 16bit wide
  xshared: Eliminate iptables_command_state->invert
  xshared: Merge invflags handling code
  ebtables-translate: Use shared ebt_get_current_chain() function
  Use proto_to_name() from xshared in more places

 include/xtables.h               |   2 +-
 iptables/ip6tables.c            | 161 +++++++++++---------------------
 iptables/iptables.c             | 160 +++++++++++--------------------
 iptables/nft-arp.h              |   7 --
 iptables/nft-shared.c           |   6 +-
 iptables/nft-shared.h           |   2 +-
 iptables/xshared.c              |  55 +++++++++--
 iptables/xshared.h              |  18 +++-
 iptables/xtables-arp.c          |  44 ---------
 iptables/xtables-eb-translate.c |  19 +---
 iptables/xtables-eb.c           |   1 -
 iptables/xtables.c              | 114 +++++++---------------
 12 files changed, 210 insertions(+), 379 deletions(-)

-- 
2.31.0

